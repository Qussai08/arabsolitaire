/**
 * Firestore Security Rules Tests — Sprint 11 §21
 *
 * Verifies critical authorization invariants using the Firebase Rules
 * Unit Testing SDK (@firebase/rules-unit-testing).
 *
 * Run locally:
 *   cd firebase
 *   npm run rules:test
 *
 * CI: firebase-rules-test.yml workflow.
 *
 * Emulator must be running:
 *   firebase emulators:start --only firestore
 */

'use strict';

const {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} = require('@firebase/rules-unit-testing');
const { readFileSync } = require('fs');
const path = require('path');

const PROJECT_ID = 'demo-arabsolitaire';
const RULES_PATH = path.resolve(__dirname, '../firestore.rules');

let testEnv;

async function withAuth(uid) {
  return testEnv.authenticatedContext(uid);
}

async function withoutAuth() {
  return testEnv.unauthenticatedContext();
}

// ── Setup / teardown ──────────────────────────────────────────────────────────

before(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: PROJECT_ID,
    firestore: {
      rules: readFileSync(RULES_PATH, 'utf8'),
      host: 'localhost',
      port: 8088,
    },
  });
});

afterEach(async () => {
  await testEnv.clearFirestore();
});

after(async () => {
  await testEnv.cleanup();
});

// ── Helper: pre-seed data via admin context ───────────────────────────────────

async function seedDoc(docPath, data) {
  await testEnv.withSecurityRulesDisabled(async (ctx) => {
    await ctx.firestore().doc(docPath).set(data);
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Test groups
// ─────────────────────────────────────────────────────────────────────────────

describe('Default deny', () => {
  it('unauthenticated user cannot read any document', async () => {
    const ctx = await withoutAuth();
    await assertFails(ctx.firestore().doc('players/alice').get());
  });

  it('unauthenticated user cannot write any document', async () => {
    const ctx = await withoutAuth();
    await assertFails(
      ctx.firestore().doc('players/alice').set({ name: 'Alice' }),
    );
  });
});

// ─────────────────────────────────────────────────────────────────────────────

describe('Player document — own uid', () => {
  const uid = 'user_alice';

  it('player may read own document', async () => {
    await seedDoc(`players/${uid}`, { joined: true });
    const ctx = await withAuth(uid);
    await assertSucceeds(ctx.firestore().doc(`players/${uid}`).get());
  });

  it('player may NOT read another player document', async () => {
    await seedDoc('players/other_user', { joined: true });
    const ctx = await withAuth(uid);
    await assertFails(ctx.firestore().doc('players/other_user').get());
  });

  it('client CANNOT write player document (server-only)', async () => {
    const ctx = await withAuth(uid);
    await assertFails(
      ctx.firestore().doc(`players/${uid}`).set({ hacked: true }),
    );
  });
});

// ─────────────────────────────────────────────────────────────────────────────

describe('Player state sub-collection', () => {
  const uid = 'user_bob';

  it('player may read own state', async () => {
    await seedDoc(`players/${uid}/state/progression`, { level: 5 });
    const ctx = await withAuth(uid);
    await assertSucceeds(
      ctx.firestore().doc(`players/${uid}/state/progression`).get(),
    );
  });

  it('client CANNOT write own state (server-only)', async () => {
    const ctx = await withAuth(uid);
    await assertFails(
      ctx
        .firestore()
        .doc(`players/${uid}/state/progression`)
        .set({ level: 999 }),
    );
  });

  it('player cannot read another player state', async () => {
    await seedDoc('players/other_user/state/progression', { level: 1 });
    const ctx = await withAuth(uid);
    await assertFails(
      ctx.firestore().doc('players/other_user/state/progression').get(),
    );
  });
});

// ─────────────────────────────────────────────────────────────────────────────

describe('Economy — wallet', () => {
  const uid = 'user_carol';

  it('player may read own wallet', async () => {
    await seedDoc(`players/${uid}/economy/wallet`, { coins: 500 });
    const ctx = await withAuth(uid);
    await assertSucceeds(
      ctx.firestore().doc(`players/${uid}/economy/wallet`).get(),
    );
  });

  it('client CANNOT write wallet (server-only)', async () => {
    const ctx = await withAuth(uid);
    await assertFails(
      ctx
        .firestore()
        .doc(`players/${uid}/economy/wallet`)
        .set({ coins: 999999 }),
    );
  });
});

// ─────────────────────────────────────────────────────────────────────────────

describe('Economy — transactions (ledger)', () => {
  const uid = 'user_dan';

  it('client CANNOT read ledger', async () => {
    await seedDoc(`players/${uid}/economy/transactions/txn1`, {
      amount: 100,
    });
    const ctx = await withAuth(uid);
    await assertFails(
      ctx
        .firestore()
        .doc(`players/${uid}/economy/transactions/txn1`)
        .get(),
    );
  });

  it('client CANNOT write ledger', async () => {
    const ctx = await withAuth(uid);
    await assertFails(
      ctx
        .firestore()
        .doc(`players/${uid}/economy/transactions/txn1`)
        .set({ amount: 9999 }),
    );
  });
});

// ─────────────────────────────────────────────────────────────────────────────

describe('Economy — operation receipts', () => {
  const uid = 'user_eve';

  it('player may read own operation receipts (crash recovery)', async () => {
    await seedDoc(`players/${uid}/economy/operations/op1`, {
      status: 'pending',
    });
    const ctx = await withAuth(uid);
    await assertSucceeds(
      ctx
        .firestore()
        .doc(`players/${uid}/economy/operations/op1`)
        .get(),
    );
  });

  it('client CANNOT write operation receipts', async () => {
    const ctx = await withAuth(uid);
    await assertFails(
      ctx
        .firestore()
        .doc(`players/${uid}/economy/operations/op1`)
        .set({ status: 'success' }),
    );
  });
});

// ─────────────────────────────────────────────────────────────────────────────

describe('Entitlements', () => {
  const uid = 'user_frank';

  it('player may read own entitlements', async () => {
    await seedDoc(`players/${uid}/entitlements/remove_ads`, {
      active: true,
    });
    const ctx = await withAuth(uid);
    await assertSucceeds(
      ctx
        .firestore()
        .doc(`players/${uid}/entitlements/remove_ads`)
        .get(),
    );
  });

  it('client CANNOT write entitlements', async () => {
    const ctx = await withAuth(uid);
    await assertFails(
      ctx
        .firestore()
        .doc(`players/${uid}/entitlements/remove_ads`)
        .set({ active: true }),
    );
  });
});

// ─────────────────────────────────────────────────────────────────────────────

describe('Purchase receipts', () => {
  const uid = 'user_grace';

  it('player may read own purchase receipts', async () => {
    await seedDoc(`players/${uid}/purchase_receipts/receipt1`, {
      product: 'coins_1000',
    });
    const ctx = await withAuth(uid);
    await assertSucceeds(
      ctx
        .firestore()
        .doc(`players/${uid}/purchase_receipts/receipt1`)
        .get(),
    );
  });

  it('client CANNOT write purchase receipts', async () => {
    const ctx = await withAuth(uid);
    await assertFails(
      ctx
        .firestore()
        .doc(`players/${uid}/purchase_receipts/receipt1`)
        .set({ product: 'coins_1000' }),
    );
  });
});

// ─────────────────────────────────────────────────────────────────────────────

describe('Daily state', () => {
  const uid = 'user_henry';

  it('player may read own daily state', async () => {
    await seedDoc(`players/${uid}/daily/streak`, { current: 3 });
    const ctx = await withAuth(uid);
    await assertSucceeds(
      ctx.firestore().doc(`players/${uid}/daily/streak`).get(),
    );
  });

  it('client CANNOT write daily state', async () => {
    const ctx = await withAuth(uid);
    await assertFails(
      ctx.firestore().doc(`players/${uid}/daily/streak`).set({ current: 999 }),
    );
  });
});

// ─────────────────────────────────────────────────────────────────────────────

describe('FCM device tokens', () => {
  const uid = 'user_irene';

  it('client CANNOT read device tokens', async () => {
    await seedDoc(`players/${uid}/devices/device1`, { token: 'abc' });
    const ctx = await withAuth(uid);
    await assertFails(
      ctx.firestore().doc(`players/${uid}/devices/device1`).get(),
    );
  });

  it('client CANNOT write device tokens', async () => {
    const ctx = await withAuth(uid);
    await assertFails(
      ctx
        .firestore()
        .doc(`players/${uid}/devices/device1`)
        .set({ token: 'xyz' }),
    );
  });
});

// ─────────────────────────────────────────────────────────────────────────────

describe('Daily challenges (global read-only)', () => {
  it('authenticated player may read daily challenge', async () => {
    await seedDoc('dailyChallenges/2026-08-22', { seed: 42 });
    const ctx = await withAuth('any_user');
    await assertSucceeds(
      ctx.firestore().doc('dailyChallenges/2026-08-22').get(),
    );
  });

  it('client CANNOT write daily challenge', async () => {
    const ctx = await withAuth('any_user');
    await assertFails(
      ctx.firestore().doc('dailyChallenges/2026-08-22').set({ seed: 999 }),
    );
  });

  it('unauthenticated user CANNOT read daily challenge', async () => {
    await seedDoc('dailyChallenges/2026-08-22', { seed: 42 });
    const ctx = await withoutAuth();
    await assertFails(
      ctx.firestore().doc('dailyChallenges/2026-08-22').get(),
    );
  });
});

// ─────────────────────────────────────────────────────────────────────────────

describe('Content control plane', () => {
  it('authenticated player may read content pointer', async () => {
    await seedDoc('content/pointer', { bundleVersion: 'v1.0.0' });
    const ctx = await withAuth('any_user');
    await assertSucceeds(ctx.firestore().doc('content/pointer').get());
  });

  it('client CANNOT write content pointer', async () => {
    const ctx = await withAuth('any_user');
    await assertFails(
      ctx
        .firestore()
        .doc('content/pointer')
        .set({ bundleVersion: 'hacked' }),
    );
  });

  it('client CANNOT write to cmsContent', async () => {
    const ctx = await withAuth('any_user');
    await assertFails(
      ctx
        .firestore()
        .doc('cmsContent/associations/item1')
        .set({ text: 'hacked' }),
    );
  });

  it('client CANNOT read contentAuditLog', async () => {
    await seedDoc('contentAuditLog/log1', { action: 'publish' });
    const ctx = await withAuth('any_user');
    await assertFails(
      ctx.firestore().doc('contentAuditLog/log1').get(),
    );
  });
});

// ─────────────────────────────────────────────────────────────────────────────

describe('Cross-user access denied', () => {
  it('user A cannot read user B wallet', async () => {
    await seedDoc('players/user_b/economy/wallet', { coins: 100 });
    const ctxA = await withAuth('user_a');
    await assertFails(
      ctxA.firestore().doc('players/user_b/economy/wallet').get(),
    );
  });

  it('user A cannot write user B state', async () => {
    const ctxA = await withAuth('user_a');
    await assertFails(
      ctxA
        .firestore()
        .doc('players/user_b/state/progression')
        .set({ level: 1 }),
    );
  });
});
