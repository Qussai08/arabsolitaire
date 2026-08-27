import 'dart:convert';
import 'dart:io';

import 'package:game_engine/game_engine.dart';
import 'package:unity_bridge_contracts/unity_bridge_contracts.dart';

GameState arabicFixture() {
  return GameState(
    attemptId: 'محاولة-١',
    levelDefinitionId: 'cairo_level_1',
    associations: {
      'assoc_a': const AssociationDefinition(
        associationId: 'assoc_a',
        associationCardId: 'ألوان أساسية',
        requiredMemberCardIds: {'أحمر', 'أزرق', 'أصفر'},
      ),
    },
    tableau: [
      columnWithTop(const MemberCard(id: 'أحمر', associationId: 'assoc_a')),
      columnWithTop(const MemberCard(id: 'أزرق', associationId: 'assoc_a')),
      const TableauColumn(),
    ],
    stock: const StockState(),
    slots: const [AssociationSlot(index: 0)],
    moveLimit: 30,
    movesRemaining: 30,
  );
}

void main() {
  final state = arabicFixture();
  final session = BridgeSession(
    sessionId: 'mock-session-cairo',
    attemptId: state.attemptId,
    levelDefinitionId: state.levelDefinitionId,
  );
  final envelope = session.buildOutbound(
    type: BridgeMessageType.stateSnapshot,
    payload: BridgePayloads.stateSnapshot(state: state, revision: 0),
  );
  final fixture = <String, Object?>{
    'schemaVersion': envelope.schemaVersion,
    'sessionId': envelope.sessionId,
    'attemptId': envelope.attemptId,
    'levelDefinitionId': envelope.levelDefinitionId,
    'revision': envelope.revision,
    'initialSnapshot': envelope.toJson(),
    'mockResponses': {
      'accept_move_0_to_2': {
        'accepted': true,
        'moveCost': 1,
        'newRevision': 1,
        'rejectionReason': null,
        'events': [
          {'type': 'cardMoved', 'fromColumn': 0, 'toColumn': 2},
        ],
      },
      'reject_move_2_to_0': {
        'accepted': false,
        'moveCost': 0,
        'newRevision': 2,
        'rejectionReason': 'illegalTarget',
        'events': [
          {'type': 'moveRejected', 'reason': 'illegalTarget'},
        ],
      },
    },
  };
  final repoRoot = Directory(Platform.script.toFilePath()).parent.parent;
  final path =
      '${repoRoot.path}/unity/ArabSolitaireUnity/Assets/ArabSolitaire/Bridge/Fixtures/cairo_mock_state.json';
  Directory(File(path).parent.path).createSync(recursive: true);
  File(path).writeAsStringSync(const JsonEncoder.withIndent('  ').convert(fixture));
  stdout.writeln('Wrote fixture to $path');
}
