import { getFirestore } from "firebase-admin/firestore";
import { CallableRequest, HttpsError } from "firebase-functions/v2/https";

export async function ensureAdmin(request: CallableRequest<unknown>): Promise<void> {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "Sign-in required.");
  }

  // Preferred: set a custom claim `admin: true` for admin users.
  // Fallback: allowlist document at `admins/{uid}`.
  const token = request.auth?.token as Record<string, unknown> | undefined;
  if (token?.admin === true) return;

  const doc = await getFirestore().collection("admins").doc(uid).get();
  if (!doc.exists) {
    throw new HttpsError("permission-denied", "Admin access required.");
  }
}

