import { getFirestore, Timestamp } from "firebase-admin/firestore";
import { onSchedule } from "firebase-functions/v2/scheduler";

import { dispatchAutopost } from "../autopost/dispatcher";
import { AutopostPlatform } from "../autopost/types";

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

    await doc.ref.update({ status: "running" });

    try {
      for (const platform of platforms) {
        await dispatchAutopost({ platform, contentType, contentId });
      }
      await doc.ref.update({
        status: "sent",
        sentAt: now,
        lastError: "",
      });
    } catch (e) {
      await doc.ref.update({
        status: "failed",
        lastError: String(e),
      });
    }
  }
});

