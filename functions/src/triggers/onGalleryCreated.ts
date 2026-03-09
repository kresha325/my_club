import { onDocumentCreated } from "firebase-functions/v2/firestore";

export const onGalleryCreated = onDocumentCreated("gallery/{id}", async (event) => {
  // Trigger placeholder for "media upload".
  // Developer: if you want automatic social posting:
  // - add `autopostPlatforms: ["youtube","instagram","facebook"]` on the gallery doc
  // - create an autopost_jobs entry here
  const snap = event.data;
  if (!snap) return;

  console.log("[Trigger] gallery created:", snap.id);
});

