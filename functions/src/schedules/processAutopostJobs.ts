import { getFirestore, Timestamp } from "firebase-admin/firestore";
import { onSchedule } from "firebase-functions/v2/scheduler";

import { dispatchAutopost } from "../autopost/dispatcher";
import { AutopostPlatform, YouTubeTarget } from "../autopost/types";

const COLLECTION_BY_TYPE: Record<string, string> = {
  news: "news",
  events: "events",
  matches: "matches",
  gallery: "gallery",
  ads: "ads",
  announcements: "announcements",
};

function toText(v: unknown): string {
  return typeof v === "string" ? v : "";
}

function toNumber(v: unknown): number | null {
  return typeof v === "number" && Number.isFinite(v) ? v : null;
}

function classifyYouTubeTarget(durationSeconds: number | null): YouTubeTarget {
  if (durationSeconds !== null && durationSeconds < 120) {
    return "shorts";
  }
  return "video";
}

function contentPayload(contentType: string, data: Record<string, unknown>): {
  mediaUrl?: string;
  caption?: string;
  durationSeconds: number | null;
  explicitTarget?: YouTubeTarget;
} {
  const title = toText(data.title);

  switch (contentType) {
    case "gallery": {
      const mediaUrl = toText(data.mediaUrl);
      const caption = toText(data.caption) || title;
      const explicitTarget =
        data.youtubeTarget === "shorts" || data.youtubeTarget === "video"
          ? (data.youtubeTarget as YouTubeTarget)
          : undefined;
      return {
        mediaUrl: mediaUrl || undefined,
        caption: caption || undefined,
        durationSeconds: toNumber(data.durationSeconds),
        explicitTarget,
      };
    }
    case "news":
      return {
        mediaUrl: toText(data.coverUrl) || undefined,
        caption: [title, toText(data.body)].filter(Boolean).join("\n\n") || undefined,
        durationSeconds: null,
      };
    case "events":
      return {
        mediaUrl: toText(data.bannerUrl) || undefined,
        caption: [title, toText(data.description)].filter(Boolean).join("\n\n") || undefined,
        durationSeconds: null,
      };
    case "ads":
      return {
        mediaUrl: toText(data.imageUrl) || undefined,
        caption: title || undefined,
        durationSeconds: null,
      };
    case "announcements":
      return {
        mediaUrl: undefined,
        caption: [title, toText(data.message)].filter(Boolean).join("\n\n") || undefined,
        durationSeconds: null,
      };
    default:
      return { durationSeconds: null };
  }
}

export const processAutopostJobs = onSchedule("every 10 minutes", async () => {
  // Skeleton queue processor:
  // - queries autopost_jobs with status=queued
  // - skips jobs scheduled in the future
  // - calls platform placeholders
  // - marks jobs sent/failed
  const db = getFirestore();
  const now = Timestamp.now();

  const snapshot = await db
    .collection("autopost_jobs")
    .where("status", "==", "queued")
    .limit(25)
    .get();

  for (const doc of snapshot.docs) {
    const data = doc.data() as Record<string, unknown>;
    const scheduledAt = data.scheduledAt as Timestamp | null | undefined;
    if (scheduledAt && scheduledAt.toMillis() > now.toMillis()) {
      continue;
    }

    const platforms = (data.platforms as unknown[])
      ?.filter((p) => typeof p === "string")
      .map((p) => (p as string).toLowerCase() as AutopostPlatform) ?? [];
    const contentType = (data.contentType as string) ?? "";
    const contentId = (data.contentId as string) ?? "";

    if (!contentType || !contentId) {
      await doc.ref.update({
        status: "failed",
        lastError: "Missing contentType/contentId",
      });
      continue;
    }

    const collection = COLLECTION_BY_TYPE[contentType];
    if (!collection) {
      await doc.ref.update({
        status: "failed",
        lastError: `Unsupported contentType: ${contentType}`,
      });
      continue;
    }

    const contentSnap = await db.collection(collection).doc(contentId).get();
    if (!contentSnap.exists) {
      await doc.ref.update({
        status: "failed",
        lastError: `Content not found: ${contentType}/${contentId}`,
      });
      continue;
    }

    const payload = contentPayload(contentType, contentSnap.data() as Record<string, unknown>);
    const youtubeTarget =
      payload.explicitTarget ?? classifyYouTubeTarget(payload.durationSeconds);

    await doc.ref.update({ status: "running" });

    try {
      // 1) Publish to YouTube first so downstream platforms can reuse the URL.
      let youtubeUrl = toText(data.youtubeUrl) || "";
      if (platforms.includes("youtube")) {
        const ytResult = await dispatchAutopost({
          platform: "youtube",
          contentType,
          contentId,
          mediaUrl: payload.mediaUrl,
          caption: payload.caption,
          youtubeTarget,
        });
        youtubeUrl = ytResult.url ?? youtubeUrl;

        if (youtubeUrl) {
          await contentSnap.ref.set(
            {
              youtubeUrl,
              youtubeTarget,
            },
            { merge: true },
          );
        }
      }

      // 2) Fan-out to the rest of platforms and include YouTube URL when available.
      for (const platform of platforms) {
        if (platform === "youtube") continue;

        await dispatchAutopost({
          platform,
          contentType,
          contentId,
          mediaUrl: payload.mediaUrl,
          caption: payload.caption,
          youtubeUrl: youtubeUrl || undefined,
          youtubeTarget,
        });
      }

      await doc.ref.update({
        status: "sent",
        sentAt: now,
        lastError: "",
        youtubeTarget,
        youtubeUrl: youtubeUrl || null,
      });
    } catch (e) {
      await doc.ref.update({
        status: "failed",
        lastError: String(e),
      });
    }
  }
});

