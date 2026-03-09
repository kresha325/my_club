import axios from "axios";

import { AutopostRequest } from "./types";

export async function autopostToYouTube(req: AutopostRequest): Promise<void> {
  // Placeholder only.
  // Real YouTube posting typically requires OAuth 2.0 user consent and a stored refresh token.
  //
  // Suggested env vars:
  // - YOUTUBE_ACCESS_TOKEN
  // - YOUTUBE_CHANNEL_ID
  //
  // Example (placeholder):
  // await axios.post(
  //   "https://www.googleapis.com/youtube/v3/activities?part=snippet,contentDetails",
  //   { /* ... */ },
  //   { headers: { Authorization: `Bearer ${accessToken}` } }
  // );

  const accessToken = process.env.YOUTUBE_ACCESS_TOKEN;
  if (!accessToken) {
    console.log("[YouTube] Missing YOUTUBE_ACCESS_TOKEN. Skipping.", req);
    return;
  }

  // Example lightweight request (no posting) just to show structure:
  await axios.get("https://www.googleapis.com/youtube/v3/channels", {
    params: {
      part: "snippet",
      mine: true,
    },
    headers: { Authorization: `Bearer ${accessToken}` },
  });

  console.log("[YouTube] Autopost placeholder executed.", req);
}

