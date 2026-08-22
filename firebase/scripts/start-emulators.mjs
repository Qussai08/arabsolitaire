#!/usr/bin/env node
/**
 * Builds Cloud Functions, checks Java for Firestore/Storage emulators,
 * then starts the Firebase emulator suite.
 */
import { spawnSync } from "node:child_process";
import { existsSync, readdirSync } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const firebaseRoot = path.resolve(__dirname, "..");
const functionsDir = path.join(firebaseRoot, "functions");

function run(command, args, options = {}) {
  const result = spawnSync(command, args, {
    stdio: "inherit",
    shell: process.platform === "win32",
    ...options,
  });
  if (result.status !== 0) {
    process.exit(result.status ?? 1);
  }
}

function javaExecutableFromHome(javaHome) {
  const candidate = path.join(
    javaHome,
    "bin",
    process.platform === "win32" ? "java.exe" : "java",
  );
  return existsSync(candidate) ? candidate : null;
}

function readJavaMajorVersion(javaExecutable) {
  const useShell =
    process.platform === "win32" &&
    !javaExecutable.includes("\\") &&
    !javaExecutable.includes("/");

  const result = spawnSync(javaExecutable, ["-version"], {
    encoding: "utf8",
    shell: useShell,
  });
  const output = `${result.stderr ?? ""}\n${result.stdout ?? ""}`;
  const match = output.match(/version "([^"]+)"/);
  if (!match) {
    return null;
  }

  const version = match[1];
  if (version.startsWith("1.")) {
    return Number.parseInt(version.split(".")[1], 10);
  }
  return Number.parseInt(version.split(".")[0], 10);
}

function findWindowsJdk21Home() {
  const programFiles = process.env.ProgramFiles ?? "C:\\Program Files";
  const roots = [
    path.join(programFiles, "Eclipse Adoptium"),
    path.join(programFiles, "Java"),
    path.join(programFiles, "Microsoft"),
  ];

  for (const root of roots) {
    if (!existsSync(root)) {
      continue;
    }

    const candidates = readdirSync(root, { withFileTypes: true })
      .filter((entry) => entry.isDirectory())
      .map((entry) => entry.name)
      .filter((name) => /jdk[-.]?(21|22|23|24)/i.test(name))
      .sort()
      .reverse();

    for (const name of candidates) {
      const javaHome = path.join(root, name);
      const java = javaExecutableFromHome(javaHome);
      if (!java) {
        continue;
      }
      const major = readJavaMajorVersion(java);
      if (major !== null && major >= 21) {
        return javaHome;
      }
    }
  }

  return null;
}

function resolveJavaRuntime() {
  const candidates = [];

  if (process.env.JAVA_HOME) {
    candidates.push(process.env.JAVA_HOME);
  }

  if (process.platform === "win32") {
    const discovered = findWindowsJdk21Home();
    if (discovered) {
      candidates.push(discovered);
    }
  }

  for (const javaHome of candidates) {
    const java = javaExecutableFromHome(javaHome);
    if (!java) {
      continue;
    }
    const major = readJavaMajorVersion(java);
    if (major !== null && major >= 21) {
      return { javaHome, major };
    }
  }

  const pathJava = process.platform === "win32" ? "java.exe" : "java";
  return { javaHome: process.env.JAVA_HOME, major: readJavaMajorVersion(pathJava) };
}

console.log("Building Cloud Functions...");
run("npm", ["run", "build"], { cwd: functionsDir });

const { javaHome, major: javaMajor } = resolveJavaRuntime();
const firebaseArgs = ["emulators:start"];
const emulatorEnv = { ...process.env };

if (javaHome && javaMajor !== null && javaMajor >= 21) {
  emulatorEnv.JAVA_HOME = javaHome;
  emulatorEnv.PATH = `${path.join(javaHome, "bin")}${path.delimiter}${process.env.PATH ?? ""}`;
  console.log(`Java ${javaMajor} detected (${javaHome}). Starting full emulator suite.\n`);
} else if (javaMajor === null) {
  console.warn(
    "\nJava not found. Firestore and Storage emulators require JDK 21+.",
  );
  console.warn(
    "Starting Auth + Functions only. Install Eclipse Temurin 21 JDK for the full suite.\n",
  );
  firebaseArgs.push("--only", "functions,auth");
} else if (javaMajor < 21) {
  console.warn(
    `\nJava ${javaMajor} detected on PATH. Firestore and Storage emulators require JDK 21+.`,
  );
  console.warn(
    "Starting Auth + Functions only. Install Eclipse Temurin 21 JDK for the full suite.\n",
  );
  firebaseArgs.push("--only", "functions,auth");
}

run("firebase", firebaseArgs, { cwd: firebaseRoot, env: emulatorEnv });
