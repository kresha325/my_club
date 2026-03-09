import { Timestamp, getFirestore } from "firebase-admin/firestore";
import { onDocumentCreated } from "firebase-functions/v2/firestore";

type SupportedPlatform = "youtube" | "instagram" | "facebook";
type ContentType =
  | "news"
  | "events"
  | "matches"
  | "gallery"
  | "ads"
  | "announcements";

const DEFAULT_PLATFORMS: SupportedPlatform[] = [
  "facebook",
  "instagram",
  "youtube",
];

const SUPPORTED_PLATFORMS = new Set<SupportedPlatform>(DEFAULT_PLATFORMS);

function resolvePlatforms(data: Record<string, unknown>): SupportedPlatform[] {
  // Allow disabling autopost on individual docs.
  if (data.autopostEnabled === false) {
    return [];
  }

  const fromDoc = (data.autopostPlatforms as unknown[] | undefined)
    ?.filter((p): p is string => typeof p === "string")
    .map((p) => p.toLowerCase())
    .filter((p): p is SupportedPlatform =>
      SUPPORTED_PLATFORMS.has(p as SupportedPlatform),
    );

  if (fromDoc && fromDoc.length > 0) {
    return Array.from(new Set(fromDoc));
  }

  return DEFAULT_PLATFORMS;
}

async function enqueueAutopostJob(
  contentType: ContentType,
  contentId: string,
  data: Record<string, unknown>,
): Promise<void> {
  const platforms = resolvePlatforms(data);
  if (platforms.length === 0) {
    return;
  }

  const scheduledAt =
    data.autopostAt instanceof Timestamp ? data.autopostAt : null;

  await getFirestore().collection("autopost_jobs").add({
    contentType,
    contentId,
    platforms,
    status: "queued",
    lastError: "",
    scheduledAt,
    createdAt: Timestamp.now(),
  });

  console.log(
    `[Trigger] queued autopost job for ${contentType}/${contentId} -> ${platforms.join(", ")}`,
  );
}

export const onNewsCreated = onDocumentCreated("news/{id}", async (event) => {
  const snap = event.data;
  if (!snap) return;

  await enqueueAutopostJob("news", snap.id, snap.data() as Record<string, unknown>);
});

export const onEventCreated = onDocumentCreated("events/{id}", async (event) => {
  const snap = event.data;
  if (!snap) return;

  await enqueueAutopostJob("events", snap.id, snap.data() as Record<string, unknown>);
});

export const onMatchCreated = onDocumentCreated("matches/{id}", async (event) => {
  const snap = event.data;
  if (!snap) return;

  await enqueueAutopostJob("matches", snap.id, snap.data() as Record<string, unknown>);
});

export const onGalleryCreated = onDocumentCreated("gallery/{id}", async (event) => {
  const snap = event.data;
  if (!snap) return;

  await enqueueAutopostJob("gallery", snap.id, snap.data() as Record<string, unknown>);
});

export const onAdCreated = onDocumentCreated("ads/{id}", async (event) => {
  const snap = event.data;
  if (!snap) return;

  await enqueueAutopostJob("ads", snap.id, snap.data() as Record<string, unknown>);
});

export const onAnnouncementCreated = onDocumentCreated(
  "announcements/{id}",
  async (event) => {
    const snap = event.data;
    if (!snap) return;

    await enqueueAutopostJob(
      "announcements",
      snap.id,
      snap.data() as Record<string, unknown>,
    );
  },
);
