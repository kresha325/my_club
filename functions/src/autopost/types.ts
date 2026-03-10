export type AutopostPlatform = "youtube" | "instagram" | "facebook";

export type YouTubeTarget = "shorts" | "video";

export interface AutopostRequest {
  platform: AutopostPlatform;
  contentType: string;
  contentId: string;
  mediaUrl?: string;
  caption?: string;
  youtubeUrl?: string;
  youtubeTarget?: YouTubeTarget;
}

export interface AutopostResult {
  platform: AutopostPlatform;
  url?: string;
  externalId?: string;
}

