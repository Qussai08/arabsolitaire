// Sprint 10 — Loads bundled fallback content from Flutter assets.
// Bundled content is trusted — no hash validation required.

import 'dart:convert';
import 'package:flutter/services.dart';
import '../domain/content_bundle.dart';

class BundledContentRepository {
  static const _base = 'assets/content/bundle';

  Future<ContentSnapshot> load() async {
    final manifest = await _loadManifest();
    final chapters = await _loadChapters();
    final levels = await _loadLevels();
    final associations = await _loadAssociations();
    final storyBeats = await _loadStoryBeats();
    final localization = await _loadLocalization();

    return ContentSnapshot(
      manifest: manifest,
      chapters: chapters,
      levels: levels,
      associations: associations,
      storyBeats: storyBeats,
      localization: localization,
      source: ContentSource.bundled,
    );
  }

  Future<BundleManifest> _loadManifest() async {
    final raw = await rootBundle.loadString('$_base/manifest.json');
    return BundleManifest.fromJson(json.decode(raw) as Map<String, dynamic>);
  }

  Future<List<ChapterDto>> _loadChapters() async {
    final raw = await rootBundle.loadString('$_base/chapters.json');
    final list = json.decode(raw) as List<dynamic>;
    return list
        .map((e) => ChapterDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<LevelDto>> _loadLevels() async {
    final raw = await rootBundle.loadString('$_base/levels.json');
    final list = json.decode(raw) as List<dynamic>;
    return list
        .map((e) => LevelDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<AssociationVariantDto>> _loadAssociations() async {
    final raw = await rootBundle.loadString('$_base/associations.json');
    final list = json.decode(raw) as List<dynamic>;
    return list
        .map((e) => AssociationVariantDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<StoryBeatDto>> _loadStoryBeats() async {
    final raw = await rootBundle.loadString('$_base/story_beats.json');
    final list = json.decode(raw) as List<dynamic>;
    return list
        .map((e) => StoryBeatDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, String>> _loadLocalization() async {
    final raw = await rootBundle.loadString('$_base/localization/ar.json');
    final j = json.decode(raw) as Map<String, dynamic>;
    final strings = j['strings'] as Map<String, dynamic>? ?? {};
    return strings.map((k, v) => MapEntry(k, v as String));
  }
}
