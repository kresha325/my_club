import { onCall, HttpsError } from "firebase-functions/v2/https";

import { dispatchAutopost } from "../autopost/dispatcher";
import { AutopostPlatform, YouTubeTarget } from "../autopost/types";
import { ensureAdmin } from "../shared/admin";

export const autopostNow = onCall(async (request) => {
  await ensureAdmin(request);

  const data = (request.data ?? {}) as Record<string, unknown>;
  const platform = data.platform;
  const contentType = data.contentType;
  const contentId = data.contentId;
  const mediaUrl = data.mediaUrl;
  const caption = data.caption;
  const youtubeUrl = data.youtubeUrl;
  const youtubeTarget = data.youtubeTarget;

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
  await dispatchAutopost({
    platform: normalized,
    contentType,
    contentId,
    mediaUrl: typeof mediaUrl === "string" ? mediaUrl : undefined,
    caption: typeof caption === "string" ? caption : undefined,
    youtubeUrl: typeof youtubeUrl === "string" ? youtubeUrl : undefined,
    youtubeTarget:
      youtubeTarget === "shorts" || youtubeTarget === "video"
        ? (youtubeTarget as YouTubeTarget)
        : undefined,
  });

  return { ok: true };
});

