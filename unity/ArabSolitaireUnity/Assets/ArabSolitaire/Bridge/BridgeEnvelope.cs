using System;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace ArabSolitaire.Bridge
{
    [Serializable]
    public sealed class BridgeEnvelope
    {
        public int schemaVersion;
        public string messageId = string.Empty;
        public string sessionId = string.Empty;
        public string attemptId = string.Empty;
        public string levelDefinitionId = string.Empty;
        public int revision;
        public string type = string.Empty;
        public string requestId;
        public JObject payload = new();

        public static BridgeEnvelope FromJson(string json)
        {
            var envelope = JsonConvert.DeserializeObject<BridgeEnvelope>(json)
                ?? throw new MissingRequiredFieldError("root");
            Validate(envelope);
            return envelope;
        }

        public static BridgeEnvelope FromJObject(JObject json)
        {
            var envelope = json.ToObject<BridgeEnvelope>()
                ?? throw new MissingRequiredFieldError("root");
            Validate(envelope);
            return envelope;
        }

        public static void Validate(BridgeEnvelope envelope)
        {
            if (envelope.schemaVersion != BridgeConstants.SchemaVersion)
            {
                throw new UnknownSchemaVersionError(envelope.schemaVersion);
            }

            Require(envelope.messageId, nameof(messageId));
            Require(envelope.sessionId, nameof(sessionId));
            Require(envelope.attemptId, nameof(attemptId));
            Require(envelope.levelDefinitionId, nameof(levelDefinitionId));
            Require(envelope.type, nameof(type));

            if (!BridgeMessageTypeExtensions.TryParse(envelope.type, out _))
            {
                throw new UnknownMessageTypeError(envelope.type);
            }

            if (envelope.payload == null)
            {
                throw new MissingRequiredFieldError(nameof(payload));
            }
        }

        public string ToJson() => JsonConvert.SerializeObject(this);

        private static void Require(string value, string field)
        {
            if (string.IsNullOrWhiteSpace(value))
            {
                throw new MissingRequiredFieldError(field);
            }
        }
    }

    [Serializable]
    public sealed class TransitionResultPayload
    {
        public bool accepted;
        public JObject nextState;
        public int moveCost;
        public JArray events = new();
        public int newRevision;
        public string rejectionReason;
    }
}
