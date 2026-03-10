import { autopostToFacebook } from "./facebook";
import { autopostToInstagram } from "./instagram";
import { autopostToYouTube } from "./youtube";
import { AutopostRequest, AutopostResult } from "./types";

export async function dispatchAutopost(
  req: AutopostRequest,
): Promise<AutopostResult> {
  switch (req.platform) {
    case "youtube":
      return autopostToYouTube(req);
    case "instagram":
      return autopostToInstagram(req);
    case "facebook":
      return autopostToFacebook(req);
    default: {
      const exhaustive: never = req.platform;
      return exhaustive;
    }
  }
}

