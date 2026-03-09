import { onCall, HttpsError } from "firebase-functions/v2/https";

import { dispatchAutopost } from "../autopost/dispatcher";
import { AutopostPlatform } from "../autopost/types";
import { ensureAdmin } from "../shared/admin";

export const autopostNow = onCall(async (request) => {
  await ensureAdmin(request);

  const data = (request.data ?? {}) as Record<string, unknown>;
  const platform = data.platform;
  const contentType = data.contentType;
  const contentId = data.contentId;

  if (
    typeof platform !== "string" ||
    typeof contentType !== "string" ||
    typeof contentId !== "string"
  ) {
    throw new HttpsError(
      "invalid-argument",
      "Expected platform/contentType/contentId strings.",
    );
  }

  const normalized = platform.toLowerCase() as AutopostPlatform;
  await dispatchAutopost({ platform: normalized, contentType, contentId });

  return { ok: true };
});

