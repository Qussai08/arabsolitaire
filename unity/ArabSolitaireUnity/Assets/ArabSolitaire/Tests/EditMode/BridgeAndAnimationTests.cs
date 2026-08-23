using ArabSolitaire.Animation;
using ArabSolitaire.Bridge;
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

    public sealed class EventAnimationMapperTests
    {
        [Test]
        public void RejectedMove_MapsToRejectShake()
        {
            var mapper = new EventAnimationMapper();
            var events = new JArray { new JObject { ["type"] = "moveRejected" } };
            Assert.AreEqual(PresentationAnimCommand.RejectShake, mapper.Map(events, accepted: false));
        }

        [Test]
        public void AssociationCompleted_MapsToCelebrate()
        {
            var mapper = new EventAnimationMapper();
            var events = new JArray { new JObject { ["type"] = "associationCompleted" } };
            Assert.AreEqual(PresentationAnimCommand.Celebrate, mapper.Map(events, accepted: true));
        }
    }
}
