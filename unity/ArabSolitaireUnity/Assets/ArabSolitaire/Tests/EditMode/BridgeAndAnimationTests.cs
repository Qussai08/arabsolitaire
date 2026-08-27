using System.Collections.Generic;
using System.Linq;
using ArabSolitaire.Animation;
using ArabSolitaire.Bridge;
using ArabSolitaire.Gameplay;
using Newtonsoft.Json.Linq;
using NUnit.Framework;

namespace ArabSolitaire.Tests.EditMode
{
    public sealed class BridgeEnvelopeTests
    {
        private const string SampleJson =
            "{" +
            "\"schemaVersion\":1," +
            "\"messageId\":\"m1\"," +
            "\"sessionId\":\"s1\"," +
            "\"attemptId\":\"محاولة-١\"," +
            "\"levelDefinitionId\":\"cairo_level_1\"," +
            "\"revision\":0," +
            "\"type\":\"stateSnapshot\"," +
            "\"payload\":{\"revision\":0,\"gameState\":{\"attemptId\":\"محاولة-١\"}}" +
            "}";

        [Test]
        public void RoundTrip_PreservesArabicAttemptId()
        {
            var envelope = BridgeEnvelope.FromJson(SampleJson);
            var roundTrip = BridgeEnvelope.FromJson(envelope.ToJson());
            Assert.AreEqual("محاولة-١", roundTrip.attemptId);
        }

        [Test]
        public void UnknownSchemaVersion_IsRejected()
        {
            var json = SampleJson.Replace("\"schemaVersion\":1", "\"schemaVersion\":99");
            Assert.Throws<UnknownSchemaVersionError>(() => BridgeEnvelope.FromJson(json));
        }

        [Test]
        public void UnknownMessageType_IsRejected()
        {
            var json = SampleJson.Replace("\"type\":\"stateSnapshot\"", "\"type\":\"teleportCards\"");
            Assert.Throws<UnknownMessageTypeError>(() => BridgeEnvelope.FromJson(json));
        }

        [Test]
        public void PresentationCompleted_Parses()
        {
            var json = SampleJson.Replace("\"type\":\"stateSnapshot\"", "\"type\":\"presentationCompleted\"");
            Assert.DoesNotThrow(() => BridgeEnvelope.FromJson(json));
        }
    }

    public sealed class BridgeMessageValidatorTests
    {
        [Test]
        public void StaleRevision_IsRejected()
        {
            var validator = new BridgeMessageValidator(0);
            var intent = new BridgeEnvelope
            {
                schemaVersion = BridgeConstants.SchemaVersion,
                messageId = "u-1",
                sessionId = "s",
                attemptId = "a",
                levelDefinitionId = "l",
                revision = 5,
                type = BridgeMessageType.ActionIntent.ToWireName(),
                requestId = "r-1",
                payload = new JObject(),
            };

            Assert.Throws<StaleRevisionError>(() => validator.ValidateInboundIntent(intent));
            Assert.AreEqual(0, validator.AuthoritativeRevision);
        }

        [Test]
        public void DuplicateMessageId_IsRejected()
        {
            var validator = new BridgeMessageValidator(0);
            var intent = new BridgeEnvelope
            {
                schemaVersion = BridgeConstants.SchemaVersion,
                messageId = "dup-1",
                sessionId = "s",
                attemptId = "a",
                levelDefinitionId = "l",
                revision = 0,
                type = BridgeMessageType.ActionIntent.ToWireName(),
                requestId = "r-dup",
                payload = new JObject(),
            };

            validator.ValidateInboundIntent(intent);
            Assert.Throws<DuplicateMessageError>(() => validator.ValidateInboundIntent(intent));
        }
    }

    public sealed class BridgeSessionGuardTests
    {
        [Test]
        public void LockBlocksReadyState()
        {
            var guard = new BridgeSessionGuard(0);
            Assert.IsTrue(guard.IsReadyForInput);
            guard.LockInput();
            Assert.IsFalse(guard.IsReadyForInput);
            guard.UnlockInput();
            Assert.IsTrue(guard.IsReadyForInput);
        }
    }

    public sealed class ArabicFixtureTests
    {
        [Test]
        public void FixtureContainsArabicCardIds()
        {
            var path = UnityEngine.Application.dataPath + "/ArabSolitaire/Bridge/Fixtures/cairo_mock_state.json";
            var json = System.IO.File.ReadAllText(path);
            StringAssert.Contains("أحمر", json);
            StringAssert.Contains("ألوان أساسية", json);
        }
    }

    public sealed class BoardVisualModelTests
    {
        [Test]
        public void MapsTableauByCardId_NotDisplayText()
        {
            var gameState = JObject.Parse(
                "{\"tableau\":[{\"hiddenCards\":[],\"exposedUnit\":{\"kind\":\"singleMember\",\"card\":{\"kind\":\"member\",\"id\":\"card_1\",\"associationId\":\"a1\"}}}],\"stock\":{\"undealt\":[],\"waste\":[]},\"slots\":[]}");
            var stacks = BoardVisualModel.BuildTableau(gameState, 1);
            Assert.AreEqual(1, stacks.Count);
            Assert.AreEqual("card_1", stacks[0].Cards[0].CardId);
            Assert.AreEqual("card_1", stacks[0].Cards[0].DisplayText);
        }

        [Test]
        public void StackIsAtomic()
        {
            var gameState = JObject.Parse(
                "{\"tableau\":[{\"hiddenCards\":[],\"exposedUnit\":{\"kind\":\"memberStack\",\"cards\":[{\"kind\":\"member\",\"id\":\"c1\",\"associationId\":\"a1\"},{\"kind\":\"member\",\"id\":\"c2\",\"associationId\":\"a1\"}]}}],\"stock\":{\"undealt\":[],\"waste\":[]},\"slots\":[]}");
            var stacks = BoardVisualModel.BuildTableau(gameState, 2);
            Assert.AreEqual(2, stacks[0].Cards.Count);
            Assert.AreEqual("tableau:0", stacks[0].StackId);
        }
    }

    public sealed class DomainEventAnimationMapperTests
    {
        [Test]
        public void RejectedMove_MapsToReject()
        {
            var mapper = new DomainEventAnimationMapper();
            var steps = mapper.Map(new JArray { new JObject { ["type"] = "MoveRejected" } }, accepted: false);
            Assert.IsTrue(steps.Any(s => s.Kind == DomainAnimKind.MoveRejected));
        }

        [Test]
        public void AssociationCompleted_MapsToCelebrateCommand()
        {
            var mapper = new DomainEventAnimationMapper();
            var steps = mapper.Map(new JArray { new JObject { ["type"] = "AssociationCompleted" } }, accepted: true);
            Assert.AreEqual(PresentationAnimCommand.Celebrate, mapper.ToShiboubCommand(steps, accepted: true));
        }

        [Test]
        public void UnknownEvent_IsLoggedSafely()
        {
            var mapper = new DomainEventAnimationMapper();
            var steps = mapper.Map(new JArray { new JObject { ["type"] = "FutureEvent" } }, accepted: true);
            Assert.IsTrue(steps.Any(s => s.Kind == DomainAnimKind.Unknown));
        }

        [Test]
        public void EventOrdering_PreservesSequence()
        {
            var mapper = new DomainEventAnimationMapper();
            var events = new JArray
            {
                new JObject { ["type"] = "MoveAccepted" },
                new JObject { ["type"] = "AssociationCompleted" },
            };
            var steps = mapper.Map(events, accepted: true);
            Assert.AreEqual(DomainAnimKind.MoveAccepted, steps[0].Kind);
            Assert.AreEqual(DomainAnimKind.AssociationCompleted, steps[1].Kind);
        }
    }

    public sealed class BoardReconcilerTests
    {
        [Test]
        public void DetectsDrift()
        {
            var a = new JObject { ["movesRemaining"] = 10 };
            var b = new JObject { ["movesRemaining"] = 9 };
            Assert.IsTrue(BoardReconciler.NeedsReconcile(a, b));
        }
    }

    public sealed class EventAnimationMapperTests
    {
        [Test]
        public void LegacyRejectedMove_MapsToRejectShake()
        {
            var mapper = new EventAnimationMapper();
            var events = new JArray { new JObject { ["type"] = "moveRejected" } };
            Assert.AreEqual(PresentationAnimCommand.RejectShake, mapper.Map(events, accepted: false));
        }
    }
}
