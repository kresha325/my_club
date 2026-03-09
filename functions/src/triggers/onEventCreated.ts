import { onDocumentCreated } from "firebase-functions/v2/firestore";

export const onEventCreated = onDocumentCreated("events/{id}", async (event) => {
  // Trigger placeholder for "event upload".
  // Developer: enqueue an autopost job when events are created/updated.
  const snap = event.data;
  if (!snap) return;

  console.log("[Trigger] event created:", snap.id);
});

