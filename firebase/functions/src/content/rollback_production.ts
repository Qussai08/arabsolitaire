// Sprint 10 — Rollback production to a previous valid bundle.
// Pointer-based rollback: no rebuild required. Target bundle must already
// exist in Storage, be valid, and not be disabled.

import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { extractRoleClaims, requireRole } from "./content_permissions";
import { writeAuditLog } from "./audit_service";

function db() {
  return getFirestore();
}

interface RollbackRequest {
  targetBundleVersion: string;
  targetBundlePath: string;
  targetContentHash: string;
  reason: string; // mandatory for rollback
  confirmationToken: string;
}

export const rollbackProduction = onCall(async (request) => {
  const claims = extractRoleClaims(request);
  requireRole(claims.role as string as never, "Publisher", "Admin");

  const {
    targetBundleVersion,
    targetBundlePath,
    targetContentHash,
    reason,
    confirmationToken,
  } = request.data as RollbackRequest;

  if (!targetBundleVersion || !targetBundlePath || !targetContentHash) {
    throw new HttpsError("invalid-argument", "targetBundleVersion, targetBundlePath, targetContentHash required.");
  }
  if (!reason) {
    throw new HttpsError("invalid-argument", "Rollback reason is required.");
  }
  if (!confirmationToken) {
    throw new HttpsError("invalid-argument", "Explicit confirmation required for rollback.");
  }

  const pointerRef = db().collection("content").doc("pointer");
  const current = await pointerRef.get();
  const currentVersion = current.data()
    ?.activeBundleVersion as string | undefined;

  // Validate target is not currently disabled
  const disabledVersions: string[] = current.data()
    ?.disabledBundleVersions ?? [];
  if (disabledVersions.includes(targetBundleVersion)) {
    throw new HttpsError(
      "failed-precondition",
      `Cannot rollback to disabled bundle version ${targetBundleVersion}.`
    );
  }

  // Atomic pointer swap to target
  await pointerRef.set({
    activeBundleVersion: targetBundleVersion,
    bundlePath: targetBundlePath,
    contentHash: targetContentHash,
    updatedAt: new Date().toISOString(),
    publishedBy: claims.uid,
    disabledBundleVersions: [],
    environment: "prod",
    rollbackFrom: currentVersion,
    serverTimestamp: FieldValue.serverTimestamp(),
  });

  await writeAuditLog({
    actorId: claims.uid!,
    actorRole: claims.role ?? "unknown",
    action: "rollbackProduction",
    entityType: "bundle",
    entityId: targetBundleVersion,
    previousState: currentVersion,
    newState: targetBundleVersion,
    timestamp: new Date().toISOString(),
    reason,
    bundleVersion: targetBundleVersion,
    environment: "prod",
    metadata: { targetContentHash, rolledBackFrom: currentVersion },
  });

  return {
    success: true,
    rolledBackTo: targetBundleVersion,
    rolledBackFrom: currentVersion,
  };
});
