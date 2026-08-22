// Sprint 10 — Promote a validated STAGING bundle to PRODUCTION.
// Immutable bundle files are NOT rebuilt — same bytes + hashes are re-pointed.
// Manual explicit confirmation required; no automatic promotion on merge/commit.

import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { extractRoleClaims, requireRole } from "./content_permissions";
import { writeAuditLog } from "./audit_service";

function db() {
  return getFirestore();
}

interface PromoteProductionRequest {
  bundleVersion: string;
  bundlePath: string;
  contentHash: string;
  confirmationToken: string; // explicit publisher confirmation
  reason?: string;
}

export const promoteToProduction = onCall(async (request) => {
  const claims = extractRoleClaims(request);
  requireRole(claims.role as string as never, "Publisher", "Admin");

  const {
    bundleVersion,
    bundlePath,
    contentHash,
    confirmationToken,
    reason,
  } = request.data as PromoteProductionRequest;

  if (!bundleVersion || !bundlePath || !contentHash) {
    throw new HttpsError("invalid-argument", "bundleVersion, bundlePath, contentHash are required.");
  }
  if (!confirmationToken) {
    throw new HttpsError("invalid-argument", "Explicit confirmation required for production promotion.");
  }

  // Validate staging pointer matches what is being promoted
  const stagingPointer = await db()
    .collection("content")
    .doc("pointer_staging")
    .get();
  const stagingVersion = stagingPointer.data()
    ?.activeBundleVersion as string | undefined;
  if (stagingVersion !== bundleVersion) {
    throw new HttpsError(
      "failed-precondition",
      `Bundle ${bundleVersion} is not the current staging version (${stagingVersion ?? "none"}). Cannot promote.`
    );
  }

  const env = "prod";
  const pointerRef = db().collection("content").doc("pointer");

  const previousSnap = await pointerRef.get();
  const previousVersion = previousSnap.exists
    ? (previousSnap.data()?.activeBundleVersion as string | undefined)
    : undefined;

  // Atomic production pointer update
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
    action: "promoteProduction",
    entityType: "bundle",
    entityId: bundleVersion,
    previousState: previousVersion,
    newState: bundleVersion,
    timestamp: new Date().toISOString(),
    reason,
    bundleVersion,
    environment: env,
    metadata: { contentHash, previousVersion },
  });

  return {
    success: true,
    environment: env,
    bundleVersion,
    previousVersion,
  };
});
