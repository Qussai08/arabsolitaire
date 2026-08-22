// Sprint 10 — Publish validated bundle to STAGING environment.
// Trusted backend operation: updates the staging content pointer atomically.
// Client cannot write content control pointers directly.

import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { extractRoleClaims, requireRole } from "./content_permissions";
import { writeAuditLog } from "./audit_service";

function db() {
  return getFirestore();
}

interface PublishStagingRequest {
  bundleVersion: string;
  bundlePath: string;
  contentHash: string;
  validationSummary?: string;
}

export const publishToStaging = onCall(async (request) => {
  const claims = extractRoleClaims(request);
  requireRole(claims.role as string as never, "Publisher", "Admin");

  const { bundleVersion, bundlePath, contentHash, validationSummary } =
    request.data as PublishStagingRequest;

  if (!bundleVersion || !bundlePath || !contentHash) {
    throw new HttpsError("invalid-argument", "bundleVersion, bundlePath, and contentHash are required.");
  }

  const env = "staging";
  const pointerRef = db()
    .collection("content")
    .doc(`pointer_${env}`);

  const previousSnap = await pointerRef.get();
  const previousVersion = previousSnap.exists
    ? (previousSnap.data()?.activeBundleVersion as string | undefined)
    : undefined;

  // Atomic pointer update
  await pointerRef.set({
    activeBundleVersion: bundleVersion,
    bundlePath,
    contentHash,
    updatedAt: new Date().toISOString(),
    publishedBy: claims.uid,
    disabledBundleVersions: [],
    environment: env,
    serverTimestamp: FieldValue.serverTimestamp(),
  });

  await writeAuditLog({
    actorId: claims.uid!,
    actorRole: claims.role ?? "unknown",
    action: "publishStaging",
    entityType: "bundle",
    entityId: bundleVersion,
    previousState: previousVersion,
    newState: bundleVersion,
    timestamp: new Date().toISOString(),
    bundleVersion,
    environment: env,
    metadata: { contentHash, validationSummary },
  });

  return {
    success: true,
    environment: env,
    bundleVersion,
    previousVersion,
  };
});
