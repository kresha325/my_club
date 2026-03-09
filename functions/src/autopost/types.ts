export type AutopostPlatform = "youtube" | "instagram" | "facebook";

export interface AutopostRequest {
  platform: AutopostPlatform;
  contentType: string;
  contentId: string;
}

