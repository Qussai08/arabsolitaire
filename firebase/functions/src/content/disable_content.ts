// Sprint 10 — Emergency disable/enable controls.
// Allows Publisher to disable bad content without a mobile release.
// Granular controls: bundle, level, association variant, story beat.

import { onCall, HttpsError } from "firebase-functions/v2/https";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { extractRoleClaims, requireRole } from "./content_permissions";
import { writeAuditLog } from "./audit_service";

function db() {
  return getFirestore();
}

type DisableTarget =
  | "bundleVersion"
  | "levelId"
  | "associationVariantId"
  | "storyBeatId";

interface DisableContentRequest {
  targetType: DisableTarget;
  targetId: string;
  reason: string;
  confirmationToken: string;
}

interface EnableContentRequest {
  targetType: DisableTarget;
  targetId: string;
  reason: string;
}

const _targetField: Record<DisableTarget, string> = {
  bundleVersion: "disabledBundleVersions",
  levelId: "disabledLevelIds",
  associationVariantId: "disabledAssociationVariantIds",
  storyBeatId: "disabledStoryBeatIds",
};

export const disableContent = onCall(async (request) => {
  const claims = extractRoleClaims(request);
  requireRole(claims.role as string as never, "Publisher", "Admin");

  const { targetType, targetId, reason, confirmationToken } =
    request.data as DisableContentRequest;

  if (!targetType || !targetId || !reason) {
    throw new HttpsError(
      "invalid-argument",
      "targetType, targetId, and reason are required."
    );
  }
  if (!confirmationToken) {
    throw new HttpsError("invalid-argument", "Explicit confirmation required.");
  }

  const field = _targetField[targetType];
  if (!field) {
    throw new HttpsError("invalid-argument", `Unknown targetType: ${targetType}`);
  }

  const disableRef = db().collection("content").doc("disableMetadata");

  await disableRef.set(
    {
      [field]: FieldValue.arrayUnion(targetId),
      updatedAt: new Date().toISOString(),
      updatedBy: claims.uid,
      serverTimestamp: FieldValue.serverTimestamp(),
    },
    { merge: true }
  );

  // Also update the fetchedAt so clients know to refresh
  await disableRef.set(
    { fetchedAt: new Date().toISOString() },
    { merge: true }
  );

  await writeAuditLog({
    actorId: claims.uid!,
    actorRole: claims.role ?? "unknown",
    action: "disableContent",
    entityType: targetType,
    entityId: targetId,
    previousState: "enabled",
    newState: "disabled",
    timestamp: new Date().toISOString(),
    reason,
    environment: "prod",
  });

  return { success: true, disabled: targetId, type: targetType };
});

export const enableContent = onCall(async (request) => {
  const claims = extractRoleClaims(request);
  requireRole(claims.role as string as never, "Publisher", "Admin");

  const { targetType, targetId, reason } =
    request.data as EnableContentRequest;

  if (!targetType || !targetId || !reason) {
    throw new HttpsError(
      "invalid-argument",
      "targetType, targetId, and reason are required."
    );
  }

  const field = _targetField[targetType];
  if (!field) {
    throw new HttpsError("invalid-argument", `Unknown targetType: ${targetType}`);
  }

  const disableRef = db().collection("content").doc("disableMetadata");

  await disableRef.set(
    {
      [field]: FieldValue.arrayRemove(targetId),
      updatedAt: new Date().toISOString(),
      updatedBy: claims.uid,
      serverTimestamp: FieldValue.serverTimestamp(),
    },
    { merge: true }
  );

  await writeAuditLog({
    actorId: claims.uid!,
    actorRole: claims.role ?? "unknown",
    action: "enableContent",
    entityType: targetType,
    entityId: targetId,
    previousState: "disabled",
    newState: "enabled",
    timestamp: new Date().toISOString(),
    reason,
    environment: "prod",
  });

  return { success: true, enabled: targetId, type: targetType };
});

export const getAuditLogEntries = onCall(async (request) => {
  const claims = extractRoleClaims(request);
  requireRole(
    claims.role as string as never,
    "ContentReviewer",
    "ContentApprover",
    "Publisher",
    "Admin"
  );

  const { entityType, entityId, limit } = request.data as {
    entityType?: string;
    entityId?: string;
    limit?: number;
  };

  let query: FirebaseFirestore.Query = db()
    .collection("contentAuditLog")
    .orderBy("timestamp", "desc")
    .limit(limit ?? 100);

  if (entityType) query = query.where("entityType", "==", entityType);
  if (entityId) query = query.where("entityId", "==", entityId);

  const snap = await query.get();
  return { entries: snap.docs.map((d) => d.data()) };
});
