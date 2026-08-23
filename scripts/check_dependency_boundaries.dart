#!/usr/bin/env dart
// Dependency-boundary verification for pure Dart domain packages.
//
// Fails CI if forbidden imports appear in packages/.

import 'dart:io';

void main() {
  final violations = <String>[];
  final root = _repoRoot();

  void scanPackage({
    required String packagePath,
    required List<RegExp> forbidden,
  }) {
    final libDir = Directory('$root/$packagePath/lib');
    if (!libDir.existsSync()) {
      violations.add('Missing lib/ in $packagePath (looked in ${libDir.path})');
      return;
    }

    for (final entity in libDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) {
        continue;
      }
      final content = entity.readAsStringSync();
      for (final pattern in forbidden) {
        if (pattern.hasMatch(content)) {
          violations.add('${entity.path} matches ${pattern.pattern}');
        }
      }
    }
  }

  final flutterOrUi = [
    RegExp(r"import\s+'package:flutter/"),
    RegExp(r"import\s+'package:flutter_riverpod/"),
    RegExp(r"import\s+'package:riverpod/"),
    RegExp(r"import\s+'package:firebase_"),
    RegExp(r"import\s+'package:cloud_firestore/"),
  ];

  scanPackage(packagePath: 'packages/game_engine', forbidden: flutterOrUi);
  scanPackage(packagePath: 'packages/game_solver', forbidden: flutterOrUi);
  scanPackage(packagePath: 'packages/unity_bridge_contracts', forbidden: flutterOrUi);
  scanPackage(
    packagePath: 'packages/level_generator',
    forbidden: [
      RegExp(r"import\s+'package:flutter/"),
      RegExp(r"import\s+'package:firebase_"),
      RegExp(r"import\s+'package:cloud_firestore/"),
    ],
  );

  scanPackage(
    packagePath: 'packages/game_engine',
    forbidden: [
      RegExp(r"import\s+'package:game_solver/"),
      RegExp(r"import\s+'package:level_generator/"),
    ],
  );

  if (violations.isNotEmpty) {
    stderr.writeln('Dependency boundary violations:');
    for (final v in violations) {
      stderr.writeln(' - $v');
    }
    exit(1);
  }

  stdout.writeln('Dependency boundaries OK');
}

String _repoRoot() {
  var dir = Directory.current;
  while (true) {
    final marker = File('${dir.path}/CURSOR_PROJECT_CONTEXT.md');
    if (marker.existsSync()) {
      return dir.path;
    }
    final parent = dir.parent;
    if (parent.path == dir.path) {
      return Directory.current.path;
    }
    dir = parent;
  }
}
