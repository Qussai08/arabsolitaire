# Security Release Checklist — سوليتير العرب: أسطورة المعاني

**Authoritative spec:** Sprint 11 §95, §17–§32  
**Run at every RC gate.**

---

## Firestore Rules

- [ ] Default-deny rule is the outermost catch-all.
- [ ] No wildcard write rule (`allow write: if true` or `allow write: if request.auth != null`).
- [ ] Client cannot write Wallet (`economy/wallet`).
- [ ] Client cannot write ledger (`economy/transactions`).
- [ ] Client cannot write entitlements.
- [ ] Client cannot write purchase receipts.
- [ ] Client cannot write content pointer (`content/pointer`).
- [ ] Client cannot write Daily authoritative state.
- [ ] Admin paths have no client write access.
- [ ] Cross-user access denied (user A cannot read/write user B documents).
- [ ] Firestore rules unit tests pass in CI.

## Storage Rules

- [ ] Default-deny rule is the outermost catch-all.
- [ ] No wildcard public write.
- [ ] Client cannot write content bundles or assets.
- [ ] Only `prod` and `staging` environments are readable by authenticated clients.

## Cloud Functions

- [ ] Every trusted endpoint verifies `request.auth` is not null.
- [ ] UID is read from `request.auth.uid`, NOT from client-provided parameter.
- [ ] Input schema validation on all endpoints.
- [ ] Idempotency key checked before mutation.
- [ ] Environment / config validated on startup.
- [ ] No secrets logged.

## App Check

- [ ] App Check enforcement reviewed for Firestore / Storage / Functions.
- [ ] Metrics validated before enforcement (legitimate users not blocked).
- [ ] Progressive enforcement plan documented.

## Secrets

- [ ] `gitleaks` scan passes on current tree AND git history.
- [ ] No service account keys committed.
- [ ] No OAuth secrets committed.
- [ ] No store signing keys committed.
- [ ] No Firebase private keys committed.
- [ ] Secrets are in GitHub Secrets / Firebase/GCP Secret Manager.

## Mobile Binary

- [ ] No secrets in compiled app binary.
- [ ] No debug endpoints in PROD build.
- [ ] No DEV menu visible in PROD build.
- [ ] No test ad unit IDs in PROD build.
- [ ] No sandbox IAP configuration in PROD build.
- [ ] TLS enforced for all network calls.
- [ ] Sensitive logs stripped from PROD build.
- [ ] Local Drift DB does not store provider tokens.

## Admin / CMS

- [ ] Entra ID authentication enforced.
- [ ] MFA enforced for privileged actions.
- [ ] Publisher / Approver roles separated.
- [ ] Re-authentication required for economy / notification broad changes.
- [ ] STAGING → PROD promotion is immutable (no post-approval edits).
- [ ] Audit log retained (2 years).

## Dependencies

- [ ] `dart pub audit` passes without high/critical issues.
- [ ] `npm audit --audit-level=high` passes for firebase/ and firebase/functions/.
- [ ] No abandoned packages in critical paths.
- [ ] No incompatible licenses.

## Penetration Test

- [ ] External / manual pen-test scoped and executed (or formally scheduled with no S0/S1 findings open).
- [ ] All S0 / S1 findings resolved before release.
- [ ] S2 findings have explicit risk acceptance documented.
- [ ] S3 / S4 in backlog.
