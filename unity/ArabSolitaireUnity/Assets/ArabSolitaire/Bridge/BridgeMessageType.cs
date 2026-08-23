using System;

namespace ArabSolitaire.Bridge
{
    public enum BridgeMessageType
    {
        StateSnapshot,
        TransitionResult,
        ActionIntent,
        UnityReady,
        RequestHint,
        RequestRestart,
        RequestExit,
        HintResult,
        ClientError,
    }

    public static class BridgeMessageTypeExtensions
    {
        public static string ToWireName(this BridgeMessageType type) => type switch
        {
            BridgeMessageType.StateSnapshot => "stateSnapshot",
            BridgeMessageType.TransitionResult => "transitionResult",
            BridgeMessageType.ActionIntent => "actionIntent",
            BridgeMessageType.UnityReady => "unityReady",
            BridgeMessageType.RequestHint => "requestHint",
            BridgeMessageType.RequestRestart => "requestRestart",
            BridgeMessageType.RequestExit => "requestExit",
            BridgeMessageType.HintResult => "hintResult",
            BridgeMessageType.ClientError => "clientError",
            _ => throw new ArgumentOutOfRangeException(nameof(type), type, null),
        };

        public static bool TryParse(string wireName, out BridgeMessageType type)
        {
            foreach (BridgeMessageType value in Enum.GetValues(typeof(BridgeMessageType)))
            {
                if (value.ToWireName() == wireName)
                {
                    type = value;
                    return true;
                }
            }

            type = default;
            return false;
        }
    }
}
