import { onObjectFinalized } from "firebase-functions/v2/storage";

export const onMediaUploaded = onObjectFinalized(async (event) => {
  // Storage trigger placeholder.
  // This fires when any object is uploaded to the default bucket.
  //
  // Developer ideas:
  // - generate image thumbnails
  // - extract video poster frames
  // - write metadata into Firestore
  const object = event.data;
  console.log("[Trigger] storage finalized:", object.name);
});

