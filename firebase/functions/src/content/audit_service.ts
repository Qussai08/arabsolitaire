// Sprint 10 — Audit log service.
// Every CMS/publishing action records actor, role, action, entity, state change.
// Retention: 2 years (enforced by Firestore TTL or manual cleanup policy).

import { getFirestore, FieldValue } from "firebase-admin/firestore";

export type AuditAction =
  | "createDraft"
  | "updateDraft"
  | "submitForReview"
  | "reviewContent"
  | "approveContent"
  | "rejectContent"
  | "buildBundle"
  | "publishStaging"
  | "promoteProduction"
  | "rollbackProduction"
  | "disableContent"
  | "enableContent"
  | "activateBundle"
  | "quarantineBundle";

export interface AuditEntry {
  actorId: string;
  actorRole: string;
  action: AuditAction;
  entityType: string;
  entityId: string;
  previousState?: string;
  newState?: string;
  timestamp: string; // ISO UTC
  reason?: string;
  bundleVersion?: string;
  environment: string;
  metadata?: Record<string, unknown>;
}

function db() {
  return getFirestore();
}

export async function writeAuditLog(entry: AuditEntry): Promise<void> {
  const doc: Record<string, unknown> = {
    ...entry,
    serverTimestamp: FieldValue.serverTimestamp(),
    // TTL field for 2-year retention: Firestore TTL policy targets this field
    expireAt: new Date(
      Date.now() + 2 * 365 * 24 * 60 * 60 * 1000
    ).toISOString(),
  };

  await db()
    .collection("contentAuditLog")
    .add(doc);
}

export async function getAuditLog(
  filters: {
    entityType?: string;
    entityId?: string;
    action?: AuditAction;
    environment?: string;
    limit?: number;
  } = {}
): Promise<AuditEntry[]> {
  let query: FirebaseFirestore.Query = db().collection("contentAuditLog");

  if (filters.entityType) {
    query = query.where("entityType", "==", filters.entityType);
  }
  if (filters.entityId) {
    query = query.where("entityId", "==", filters.entityId);
  }
  if (filters.action) {
    query = query.where("action", "==", filters.action);
  }
  if (filters.environment) {
    query = query.where("environment", "==", filters.environment);
  }

  query = query.orderBy("timestamp", "desc").limit(filters.limit ?? 100);

  const snap = await query.get();
  return snap.docs.map((d) => d.data() as AuditEntry);
}
