using System.Collections.Generic;

namespace ArabSolitaire.Bridge
{
    public sealed class BridgeMessageValidator
    {
        private readonly HashSet<string> _seenMessageIds = new();
        private readonly HashSet<string> _seenRequestIds = new();

        public int AuthoritativeRevision { get; private set; }

        public BridgeMessageValidator(int initialRevision = 0)
        {
            AuthoritativeRevision = initialRevision;
        }

        public void ValidateInboundIntent(BridgeEnvelope envelope)
        {
            if (!BridgeMessageTypeExtensions.TryParse(envelope.type, out var type)
                || type != BridgeMessageType.ActionIntent)
            {
                throw new UnknownMessageTypeError(envelope.type);
            }

            if (envelope.revision != AuthoritativeRevision)
            {
                throw new StaleRevisionError(envelope.revision, AuthoritativeRevision);
            }

            if (!_seenMessageIds.Add(envelope.messageId))
            {
                throw new DuplicateMessageError(envelope.messageId);
            }

            if (!string.IsNullOrEmpty(envelope.requestId) && !_seenRequestIds.Add(envelope.requestId))
            {
                throw new DuplicateMessageError(envelope.requestId);
            }
        }

        public void AdvanceRevision(int newRevision) => AuthoritativeRevision = newRevision;
    }
}
