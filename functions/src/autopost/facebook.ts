import axios from "axios";

import { AutopostRequest } from "./types";

export async function autopostToFacebook(req: AutopostRequest): Promise<void> {
  // Placeholder only.
  // Facebook posting typically uses the Graph API and requires:
  // - PAGE_ID
  // - PAGE_ACCESS_TOKEN

  const pageId = process.env.FB_PAGE_ID;
  const accessToken = process.env.FB_PAGE_ACCESS_TOKEN;
  if (!pageId || !accessToken) {
    console.log("[Facebook] Missing FB_PAGE_ID/FB_PAGE_ACCESS_TOKEN. Skipping.", req);
    return;
  }

  const message = "Placeholder autopost from Firebase Functions.";
  await axios.post(`https://graph.facebook.com/v19.0/${pageId}/feed`, null, {
    params: { message, access_token: accessToken },
  });

  console.log("[Facebook] Autopost placeholder executed.", req);
}

