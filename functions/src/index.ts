import { setGlobalOptions } from "firebase-functions/v2";
import * as admin from "firebase-admin";

admin.initializeApp();

setGlobalOptions({
  region: "us-central1",
});

export { autopostNow } from "./callables/autopostNow";
export { processAutopostJobs } from "./schedules/processAutopostJobs";
export { onGalleryCreated } from "./triggers/onGalleryCreated";
export { onEventCreated } from "./triggers/onEventCreated";
export { onMediaUploaded } from "./triggers/onMediaUploaded";

