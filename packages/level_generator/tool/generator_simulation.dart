// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:level_generator/level_generator.dart';

/// Batch simulation CLI for QA / balancing.
///
/// Usage:
///   dart run tool/generator_simulation.dart [--boards=20] [--seed=42] [--json=out.json]
void main(List<String> args) {
  var boards = 20;
  var baseSeed = 42;
  String? jsonPath;

  for (final arg in args) {
    if (arg.startsWith('--boards=')) {
      boards = int.parse(arg.substring('--boards='.length));
    } else if (arg.startsWith('--seed=')) {
      baseSeed = int.parse(arg.substring('--seed='.length));
    } else if (arg.startsWith('--json=')) {
      jsonPath = arg.substring('--json='.length);
    }
  }

  final generator = LevelGenerator();
  final config = LevelTemplates.early3x1(includeSolutionActions: false);
  final content = FixedContentSelector(
    SyntheticContent.forProfile(config.groupSizeProfile),
  );

  final successTimes = <int>[];
  final solutionLengths = <int>[];
  final nodes = <int>[];
  final difficultyScores = <double>[];
  final restores = <int>[];
  var generated = 0;
  var attemptsSum = 0;
  var unsolvable = 0;
  var tooEasy = 0;
  var tooHard = 0;
  var inconclusive = 0;

  final wallStart = DateTime.now().toUtc();

  for (var i = 0; i < boards; i++) {
    final result = generator.generate(
      config: config,
      contentSelector: content,
      baseSeed: GenerationSeed(baseSeed + i * 97),
    );
    attemptsSum += result.metrics.generationAttempts;
    unsolvable += result.metrics.unsolvableRejects;
    tooEasy += result.metrics.tooEasyRejects;
    tooHard += result.metrics.tooHardRejects;
    inconclusive += result.metrics.solverInconclusiveCount;

    switch (result) {
      case GenerationSucceeded(:final level, :final metrics):
        generated++;
        successTimes.add(metrics.elapsed.inMilliseconds);
        solutionLengths.add(level.solutionLength);
        nodes.add(level.solverMetrics.nodesExpanded);
        difficultyScores.add(level.difficultyScore.value);
        restores.add(level.difficultyMetrics.stockRestoresInSolution);
      case GenerationFailed() || GenerationInconclusive():
        break;
    }
  }

  final wallMs = DateTime.now().toUtc().difference(wallStart).inMilliseconds;
  successTimes.sort();
  final summary = <String, Object?>{
    'boardsRequested': boards,
    'boardsGenerated': generated,
    'generationSuccessRate': boards == 0 ? 0 : generated / boards,
    'averageAttemptsToAccept': generated == 0 ? 0 : attemptsSum / boards,
    'unsolvableRejectRate': _rate(unsolvable, attemptsSum),
    'tooEasyRejectRate': _rate(tooEasy, attemptsSum),
    'tooHardRejectRate': _rate(tooHard, attemptsSum),
    'solverInconclusiveRate': _rate(inconclusive, attemptsSum),
    'averageGenerationTimeMs': _avg(successTimes),
    'p50GenerationTimeMs': _percentile(successTimes, 0.50),
    'p95GenerationTimeMs': _percentile(successTimes, 0.95),
    'averageSolutionLength': _avg(solutionLengths.map((e) => e.toDouble())),
    'averageNodesExpanded': _avg(nodes.map((e) => e.toDouble())),
    'difficultyScoreDistribution': {
      'min': difficultyScores.isEmpty
          ? null
          : difficultyScores.reduce(math.min),
      'max': difficultyScores.isEmpty
          ? null
          : difficultyScores.reduce(math.max),
      'avg': _avg(difficultyScores),
    },
    'stockRestoreDistribution': {
      'avg': _avg(restores.map((e) => e.toDouble())),
      'max': restores.isEmpty ? null : restores.reduce(math.max),
    },
    'wallClockMs': wallMs,
    'baseSeed': baseSeed,
    'template': config.levelDefinitionId,
    'generatorVersion': levelGeneratorVersion,
  };

  const encoder = JsonEncoder.withIndent('  ');
  final text = encoder.convert(summary);
  print(text);
  if (jsonPath != null) {
    File(jsonPath).writeAsStringSync(text);
  }
}

double _rate(int count, int total) => total == 0 ? 0 : count / total;

double _avg(Iterable<num> values) {
  final list = values.toList();
  if (list.isEmpty) return 0;
  return list.fold<num>(0, (a, b) => a + b) / list.length;
}

int? _percentile(List<int> sorted, double p) {
  if (sorted.isEmpty) return null;
  final idx = ((sorted.length - 1) * p).round();
  return sorted[idx];
}
