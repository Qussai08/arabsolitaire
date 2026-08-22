// Sprint 10 — Content publishing permissions.
// Role hierarchy enforced server-side; client cannot self-escalate.
// Admin auth uses Microsoft Entra ID claims; publisher actions gate on claim presence.

import { HttpsError, CallableRequest } from "firebase-functions/v2/https";

export type ContentRole =
  | "ContentEditor"
  | "ContentReviewer"
  | "ContentApprover"
  | "Publisher"
  | "Admin";

export interface RoleClaims {
  role?: string;
  uid?: string;
  email?: string;
}

/**
 * Extracts role claims from the callable request.
 * In production, custom Entra ID-issued claims are propagated via Firebase Custom Claims
 * or verified in the request auth context.
 */
export function extractRoleClaims(request: CallableRequest): RoleClaims {
  const auth = request.auth;
  if (!auth) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }
  return {
    uid: auth.uid,
    // Custom claims set via Entra ID / Firebase Admin SDK
    role: (auth.token as Record<string, unknown>)["contentRole"] as
      | string
      | undefined,
    email: auth.token.email as string | undefined,
  };
}

/** Asserts the actor has at least one of the required roles. */
export function requireRole(
  claims: RoleClaims,
  ...roles: ContentRole[]
): void {
  const role = claims.role as ContentRole | undefined;
  if (!role || (!roles.includes(role) && role !== "Admin")) {
    throw new HttpsError(
      "permission-denied",
      `Action requires one of roles: ${roles.join(", ")}. Actor role: ${role ?? "none"}.`
    );
  }
}

// ── Permission matrix (mirrors Sprint 10 spec §120) ────────────────────────

export const Permissions = {
  canCreateDraft: (r: ContentRole) =>
    ["ContentEditor", "Admin"].includes(r),

  canSubmitReview: (r: ContentRole) =>
    ["ContentEditor", "ContentReviewer", "Admin"].includes(r),

  canReview: (r: ContentRole) =>
    ["ContentReviewer", "ContentApprover", "Admin"].includes(r),

  canApprove: (r: ContentRole) =>
    ["ContentApprover", "Admin"].includes(r),

  canBuildBundle: (r: ContentRole) =>
    ["Publisher", "Admin"].includes(r),

  canPublishStaging: (r: ContentRole) =>
    ["Publisher", "Admin"].includes(r),

  canPublishProduction: (r: ContentRole) =>
    ["Publisher", "Admin"].includes(r),

  canRollback: (r: ContentRole) =>
    ["Publisher", "Admin"].includes(r),

  canDisableContent: (r: ContentRole) =>
    ["Publisher", "Admin"].includes(r),

  // Publisher cannot approve their own submissions (duty separation)
  canApproveOwnSubmission: (_r: ContentRole) => false,
} as const;
