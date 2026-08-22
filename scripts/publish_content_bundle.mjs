#!/usr/bin/env node
/**
 * Builds a versioned content bundle from apps/mobile/assets/content/bundle
 * and publishes it to the Firebase Emulator (Storage + Firestore pointer).
 *
 * Prerequisites:
 *   cd firebase && npm run emulators   # leave running
 *
 * Usage:
 *   node scripts/publish_content_bundle.mjs
 *   node scripts/publish_content_bundle.mjs --version=v1.0.0 --env=prod
 */
import { createHash } from 'node:crypto';
import {
  copyFileSync,
  existsSync,
  mkdirSync,
  readFileSync,
  writeFileSync,
} from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, '..');
const sourceDir = path.join(root, 'apps/mobile/assets/content/bundle');
const outRoot = path.join(root, 'firebase/content-bundles');

const args = Object.fromEntries(
  process.argv.slice(2).map((a) => {
    const [k, v] = a.replace(/^--/, '').split('=');
    return [k, v ?? true];
  }),
);

const bundleVersion = args.version || 'v1.0.0';
const environment = args.env || 'prod';
const projectId = args.project || 'demo-arabsolitaire';
const firestoreHost = args.firestoreHost || '127.0.0.1';
const firestorePort = Number(args.firestorePort || 8088);
const storageHost = args.storageHost || '127.0.0.1';
const storagePort = Number(args.storagePort || 9199);

const BUNDLE_FILES = [
  'chapters.json',
  'levels.json',
  'associations.json',
  'story_beats.json',
  'localization/ar.json',
];

function sha256File(filePath) {
  const buf = readFileSync(filePath);
  return createHash('sha256').update(buf).digest('hex');
}

function buildLocalBundle() {
  const outDir = path.join(outRoot, bundleVersion);
  mkdirSync(path.join(outDir, 'localization'), { recursive: true });

  const fileEntries = [];
  for (const rel of BUNDLE_FILES) {
    const src = path.join(sourceDir, rel);
    if (!existsSync(src)) {
      throw new Error(`Missing source file: ${src}`);
    }
    const dest = path.join(outDir, rel);
    mkdirSync(path.dirname(dest), { recursive: true });
    copyFileSync(src, dest);
    const hash = sha256File(dest);
    const size = readFileSync(dest).byteLength;
    fileEntries.push({ path: rel, sha256: hash, size });
    console.log(`  ${rel}  ${hash.slice(0, 12)}…  (${size} bytes)`);
  }

  // Aggregate content hash = sha256 of sorted file hashes
  const aggregate = createHash('sha256');
  for (const f of fileEntries) {
    aggregate.update(f.sha256);
  }
  const contentHash = aggregate.digest('hex');

  const now = new Date().toISOString();
  const manifest = {
    bundleId: 'arabsolitaire-content',
    bundleVersion,
    schemaVersion: 1,
    rulesVersion: 1,
    createdAt: now,
    publishedAt: now,
    contentHash,
    files: fileEntries,
    contentTypes: [
      'chapters',
      'levels',
      'associations',
      'storyBeats',
      'localization',
    ],
    status: 'published',
    bundleBuilderVersion: '1.0.0',
    contentValidatorVersion: '1.0.0',
    source: 'remote',
  };

  writeFileSync(
    path.join(outDir, 'manifest.json'),
    `${JSON.stringify(manifest, null, 2)}\n`,
  );

  console.log(`\nBuilt local bundle → ${outDir}`);
  console.log(`contentHash: ${contentHash}`);
  return { outDir, contentHash, manifest };
}

async function publishToEmulator({ outDir, contentHash, manifest }) {
  // Use Firebase Admin against emulators (no real credentials needed for demo-*).
  process.env.FIRESTORE_EMULATOR_HOST = `${firestoreHost}:${firestorePort}`;
  process.env.FIREBASE_STORAGE_EMULATOR_HOST = `${storageHost}:${storagePort}`;
  process.env.GCLOUD_PROJECT = projectId;

  // Resolve firebase-admin from firebase/node_modules (script lives in /scripts).
  const { createRequire } = await import('node:module');
  const requireFromFirebase = createRequire(
    path.join(root, 'firebase/package.json'),
  );
  const { initializeApp } = requireFromFirebase('firebase-admin/app');
  const { getFirestore } = requireFromFirebase('firebase-admin/firestore');
  const { getStorage } = requireFromFirebase('firebase-admin/storage');

  try {
    initializeApp({
      projectId,
      storageBucket: `${projectId}.appspot.com`,
    });
  } catch (e) {
    // already initialized
    if (!String(e).includes('already exists')) throw e;
  }

  const bucket = getStorage().bucket();
  const storagePrefix = `content/${environment}/bundles/${bundleVersion}`;

  console.log(`\nUploading to Storage emulator gs://${bucket.name}/${storagePrefix}/`);

  const allFiles = ['manifest.json', ...BUNDLE_FILES];
  for (const rel of allFiles) {
    const localPath = path.join(outDir, rel);
    const remotePath = `${storagePrefix}/${rel}`;
    await bucket.upload(localPath, {
      destination: remotePath,
      metadata: { contentType: 'application/json' },
    });
    console.log(`  uploaded ${remotePath}`);
  }

  const pointerDoc =
    environment === 'staging' ? 'pointer_staging' : 'pointer';
  const pointer = {
    activeBundleVersion: bundleVersion,
    bundlePath: storagePrefix,
    contentHash,
    updatedAt: new Date().toISOString(),
    publishedBy: 'publish_content_bundle.mjs',
    disabledBundleVersions: [],
    environment,
  };

  await getFirestore().collection('content').doc(pointerDoc).set(pointer);
  console.log(`\nFirestore pointer content/${pointerDoc} → ${bundleVersion}`);

  // Also write an empty disable metadata doc for clients.
  await getFirestore()
    .collection('content')
    .doc('disableMetadata')
    .set(
      {
        disabledBundleVersions: [],
        disabledLevelIds: [],
        disabledAssociationVariantIds: [],
        disabledStoryBeatIds: [],
        updatedAt: new Date().toISOString(),
      },
      { merge: true },
    );

  console.log('Disable metadata ready.');
  console.log('\nDone. Emulator UI: http://127.0.0.1:4000');
  return pointer;
}

async function main() {
  console.log(`Publishing content bundle ${bundleVersion} (${environment})\n`);
  console.log('Source files:');
  const built = buildLocalBundle();

  if (args['local-only']) {
    console.log('\n--local-only set; skipping emulator upload.');
    return;
  }

  try {
    await publishToEmulator(built);
  } catch (err) {
    console.error('\nFailed to publish to emulator:');
    console.error(err.message || err);
    console.error(
      '\nIs the emulator running?\n  cd firebase && npm run emulators\n',
    );
    console.error(
      'Local bundle is still available at firebase/content-bundles/' +
        bundleVersion,
    );
    process.exitCode = 1;
  }
}

main();
