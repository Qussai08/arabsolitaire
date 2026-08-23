import 'package:game_engine/game_engine.dart';
import 'package:test/test.dart';
import 'package:unity_bridge_contracts/unity_bridge_contracts.dart';

GameState _arabicFixture() {
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
  const engine = GameEngine();

  group('BridgeEnvelope', () {
    test('JSON round-trip preserves Arabic UTF-8 card text', () {
      final state = _arabicFixture();
      final session = BridgeSession(
        sessionId: 'session-1',
        attemptId: state.attemptId,
        levelDefinitionId: state.levelDefinitionId,
      );

      final envelope = session.buildOutbound(
        type: BridgeMessageType.stateSnapshot,
        payload: BridgePayloads.stateSnapshot(state: state, revision: 0),
      );

      final decoded = BridgeEnvelope.fromJson(envelope.toJson());
      expect(decoded.type, BridgeMessageType.stateSnapshot);
      expect(decoded.attemptId, 'محاولة-١');

      final gameStateRaw = decoded.payload['gameState'];
      expect(gameStateRaw, isA<Map<Object?, Object?>>());
      final roundTripped = GameStateCodec.decode(
        Map<String, Object?>.from(gameStateRaw! as Map),
      );
      expect(
        (roundTripped.tableau[0].exposedUnit as SingleMember).card.id,
        'أحمر',
      );
      expect(
        roundTripped.associations['assoc_a']!.associationCardId,
        'ألوان أساسية',
      );
    });

    test('unknown schema version is rejected', () {
      expect(
        () => BridgeEnvelope.fromJson({
          'schemaVersion': 99,
          'messageId': 'm1',
          'sessionId': 's1',
          'attemptId': 'a1',
          'levelDefinitionId': 'l1',
          'revision': 0,
          'type': 'stateSnapshot',
          'payload': <String, Object?>{},
        }),
        throwsA(isA<UnknownSchemaVersionError>()),
      );
    });

    test('unknown message type is rejected', () {
      expect(
        () => BridgeEnvelope.fromJson({
          'schemaVersion': kBridgeSchemaVersion,
          'messageId': 'm1',
          'sessionId': 's1',
          'attemptId': 'a1',
          'levelDefinitionId': 'l1',
          'revision': 0,
          'type': 'teleportCards',
          'payload': <String, Object?>{},
        }),
        throwsA(isA<UnknownMessageTypeError>()),
      );
    });

    test('missing required fields are rejected', () {
      expect(
        () => BridgeEnvelope.fromJson({'schemaVersion': kBridgeSchemaVersion}),
        throwsA(isA<MissingRequiredFieldError>()),
      );
    });
  });

  group('BridgeSession', () {
    test('stale revision is rejected without advancing revision', () {
      final state = _arabicFixture();
      final session = BridgeSession(
        sessionId: 's',
        attemptId: state.attemptId,
        levelDefinitionId: state.levelDefinitionId,
      );

      final stale = BridgeEnvelope(
        schemaVersion: kBridgeSchemaVersion,
        messageId: 'u-1',
        sessionId: 's',
        attemptId: state.attemptId,
        levelDefinitionId: state.levelDefinitionId,
        revision: 5,
        type: BridgeMessageType.actionIntent,
        requestId: 'r-1',
        payload: BridgePayloads.actionIntent(
          action: const MoveTableauToTableau(fromColumn: 0, toColumn: 2),
        ),
      );

      final result = session.handleActionIntent(
        envelope: stale,
        apply: (action) => engine.applyAction(state, action),
      );

      expect(result, isA<BridgeIntentRejected>());
      expect((result as BridgeIntentRejected).error, isA<StaleRevisionError>());
      expect(session.revision, 0);
    });

    test('duplicate message/request ids are rejected', () {
      final state = _arabicFixture();
      final session = BridgeSession(
        sessionId: 's',
        attemptId: state.attemptId,
        levelDefinitionId: state.levelDefinitionId,
      );

      BridgeEnvelope intent(String messageId, String requestId) {
        return BridgeEnvelope(
          schemaVersion: kBridgeSchemaVersion,
          messageId: messageId,
          sessionId: 's',
          attemptId: state.attemptId,
          levelDefinitionId: state.levelDefinitionId,
          revision: session.revision,
          type: BridgeMessageType.actionIntent,
          requestId: requestId,
          payload: BridgePayloads.actionIntent(action: const AdvanceStock()),
        );
      }

      final first = session.handleActionIntent(
        envelope: intent('u-1', 'req-1'),
        apply: (action) => engine.applyAction(state, action),
      );
      expect(first, isA<BridgeIntentApplied>());

      final dupMessage = session.handleActionIntent(
        envelope: intent('u-1', 'req-2'),
        apply: (action) => engine.applyAction(state, action),
      );
      expect(dupMessage, isA<BridgeIntentRejected>());
      expect(
        (dupMessage as BridgeIntentRejected).error,
        isA<DuplicateMessageError>(),
      );

      final dupRequest = session.handleActionIntent(
        envelope: intent('u-2', 'req-1'),
        apply: (action) => engine.applyAction(state, action),
      );
      expect(dupRequest, isA<BridgeIntentRejected>());
      expect(
        (dupRequest as BridgeIntentRejected).error,
        isA<DuplicateMessageError>(),
      );
    });

    test('accepted and rejected transitions serialize correctly', () {
      final state = GameState(
        attemptId: 'attempt_1',
        levelDefinitionId: 'level_fixture',
        associations: {
          'assoc_a': const AssociationDefinition(
            associationId: 'assoc_a',
            associationCardId: 'a_card',
            requiredMemberCardIds: {'a1', 'a2'},
          ),
        },
        tableau: [
          columnWithTop(const MemberCard(id: 'a1', associationId: 'assoc_a')),
          columnWithTop(const MemberCard(id: 'a2', associationId: 'assoc_a')),
          const TableauColumn(),
        ],
        stock: const StockState(),
        slots: const [AssociationSlot(index: 0)],
        moveLimit: 50,
        movesRemaining: 50,
      );

      final session = BridgeSession(
        sessionId: 's',
        attemptId: state.attemptId,
        levelDefinitionId: state.levelDefinitionId,
      );

      final acceptEnvelope = BridgeEnvelope(
        schemaVersion: kBridgeSchemaVersion,
        messageId: 'u-ok',
        sessionId: 's',
        attemptId: state.attemptId,
        levelDefinitionId: state.levelDefinitionId,
        revision: 0,
        type: BridgeMessageType.actionIntent,
        requestId: 'req-ok',
        payload: BridgePayloads.actionIntent(
          action: const MoveTableauToTableau(fromColumn: 0, toColumn: 1),
        ),
      );

      final accepted = session.handleActionIntent(
        envelope: acceptEnvelope,
        apply: (action) => engine.applyAction(state, action),
      );
      expect(accepted, isA<BridgeIntentApplied>());
      final applied = accepted as BridgeIntentApplied;
      expect(applied.transition.accepted, isTrue);
      expect(applied.response.type, BridgeMessageType.transitionResult);
      expect(applied.response.payload['accepted'], isTrue);
      expect(applied.response.payload['newRevision'], 1);
      expect(applied.response.payload['events'], isA<List<Object?>>());
      expect(applied.newRevision, 1);

      final rejectEnvelope = BridgeEnvelope(
        schemaVersion: kBridgeSchemaVersion,
        messageId: 'u-bad',
        sessionId: 's',
        attemptId: state.attemptId,
        levelDefinitionId: state.levelDefinitionId,
        revision: session.revision,
        type: BridgeMessageType.actionIntent,
        requestId: 'req-bad',
        payload: BridgePayloads.actionIntent(
          action: const MoveTableauToTableau(fromColumn: 2, toColumn: 0),
        ),
      );

      final nextState = applied.transition.nextState;
      final rejected = session.handleActionIntent(
        envelope: rejectEnvelope,
        apply: (action) => engine.applyAction(nextState, action),
      );
      expect(rejected, isA<BridgeIntentApplied>());
      final rejectedApplied = rejected as BridgeIntentApplied;
      expect(rejectedApplied.transition.accepted, isFalse);
      expect(rejectedApplied.response.payload['accepted'], isFalse);
      expect(rejectedApplied.response.payload['rejectionReason'], isNotNull);
      expect(rejectedApplied.newRevision, 2);
    });
  });
}
