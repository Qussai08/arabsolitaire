using System;

namespace ArabSolitaire.Bridge
{
    public sealed class BridgeMessageRouter
    {
        public event Action<BridgeEnvelope> OnSnapshot;
        public event Action<BridgeEnvelope> OnTransitionResult;
        public event Action<BridgeEnvelope> OnHintResult;
        public event Action<BridgeEnvelope> OnFatalError;

        public void Route(BridgeEnvelope envelope)
        {
            if (!BridgeMessageTypeExtensions.TryParse(envelope.type, out var type))
            {
                return;
            }

            switch (type)
            {
                case BridgeMessageType.StateSnapshot:
                    OnSnapshot?.Invoke(envelope);
                    break;
                case BridgeMessageType.TransitionResult:
                    OnTransitionResult?.Invoke(envelope);
                    break;
                case BridgeMessageType.HintResult:
                    OnHintResult?.Invoke(envelope);
                    break;
                case BridgeMessageType.FatalError:
                    OnFatalError?.Invoke(envelope);
                    break;
            }
        }
    }
}
