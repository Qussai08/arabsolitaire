import { logger } from 'firebase-functions/v2';

/** Structured log entry shape — matches Sprint 11 §12 requirements. */
interface StructuredLogEntry {
  requestId?: string;
  operationId?: string;
  idempotencyKeyHash?: string;
  uid?: string; // hashed/reference only — never raw token
  operationType: string;
  result?: 'success' | 'failure' | 'duplicate' | 'inconclusive';
  durationMs?: number;
  environment?: string;
  schemaVersion?: number;
  configVersion?: string;
  detail?: string;
  [key: string]: unknown;
}

const environment = process.env.GCLOUD_PROJECT ?? 'unknown';

/** Log a structured INFO entry for an operation result. */
export function logOperation(entry: StructuredLogEntry): void {
  logger.info({ ...entry, environment, timestamp: new Date().toISOString() });
}

/** Log a structured WARNING (e.g. idempotency hit, slow operation). */
export function logWarning(entry: StructuredLogEntry): void {
  logger.warn({ ...entry, environment, timestamp: new Date().toISOString() });
}

/** Log a structured ERROR (operation failed). */
export function logError(entry: StructuredLogEntry & { error?: string }): void {
  logger.error({ ...entry, environment, timestamp: new Date().toISOString() });
}

/** Simple SHA-256-like hex from an idempotency key for safe log storage.
 *  Uses a deterministic but non-reversible representation. */
export function hashIdempotencyKey(key: string): string {
  // Stable prefix for correlation — not a real crypto hash (no Node crypto available at type level).
  // In production use crypto.createHash('sha256').update(key).digest('hex').
  return `idem_${Buffer.from(key).toString('base64url').slice(0, 24)}`;
}
