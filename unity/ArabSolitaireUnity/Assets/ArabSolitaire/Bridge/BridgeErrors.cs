using System;

namespace ArabSolitaire.Bridge
{
    public abstract class BridgeError : Exception
    {
        protected BridgeError(string message) : base(message)
        {
        }
    }

    public sealed class UnknownSchemaVersionError : BridgeError
    {
        public UnknownSchemaVersionError(int version)
            : base($"Unsupported schemaVersion: {version}")
        {
        }
    }

    public sealed class UnknownMessageTypeError : BridgeError
    {
        public UnknownMessageTypeError(string type)
            : base($"Unknown message type: {type}")
        {
        }
    }

    public sealed class MissingRequiredFieldError : BridgeError
    {
        public MissingRequiredFieldError(string field)
            : base($"Missing required field: {field}")
        {
        }
    }

    public sealed class StaleRevisionError : BridgeError
    {
        public StaleRevisionError(int received, int authoritative)
            : base($"Stale revision {received}; authoritative is {authoritative}")
        {
        }
    }

    public sealed class DuplicateMessageError : BridgeError
    {
        public DuplicateMessageError(string id)
            : base($"Duplicate message/request id: {id}")
        {
        }
    }
}
