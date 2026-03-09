import axios from "axios";

import { AutopostRequest } from "./types";

export async function autopostToInstagram(req: AutopostRequest): Promise<void> {
  // Placeholder only.
  // Instagram publishing uses the Instagram Graph API and requires:
  // - a Facebook App
  // - an Instagram Business Account
  // - a Page access token with the right scopes
  //
  // Suggested env vars:
  // - IG_USER_ID
  // - IG_ACCESS_TOKEN

  const igUserId = process.env.IG_USER_ID;
  const accessToken = process.env.IG_ACCESS_TOKEN;
  if (!igUserId || !accessToken) {
    console.log("[Instagram] Missing IG_USER_ID/IG_ACCESS_TOKEN. Skipping.", req);
    return;
  }

  // Example: create a media container (image URL required).
  // Developer: fetch Firestore content doc by (req.contentType, req.contentId)
  // and build caption/mediaUrl.
  const imageUrl = "https://example.com/placeholder.jpg";
  const caption = "Placeholder autopost from Firebase Functions.";

  const container = await axios.post(
    `https://graph.facebook.com/v19.0/${igUserId}/media`,
    null,
    {
      params: { image_url: imageUrl, caption, access_token: accessToken },
    },
  );

  // Example: publish container
  await axios.post(
    `https://graph.facebook.com/v19.0/${igUserId}/media_publish`,
    null,
    {
      params: { creation_id: container.data.id, access_token: accessToken },
    },
  );

  console.log("[Instagram] Autopost placeholder executed.", req);
}

