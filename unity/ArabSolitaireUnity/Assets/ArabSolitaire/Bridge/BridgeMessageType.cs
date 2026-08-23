using System;

namespace ArabSolitaire.Bridge
{
    public enum BridgeMessageType
    {
        Initialize,
        LoadLevel,
        StateSnapshot,
        TransitionResult,
        HintResult,
        Pause,
        Resume,
        ShowStoryBeat,
        Shutdown,
        FatalError,
        UnityReady,
        ActionIntent,
        RequestHint,
        RequestRestart,
        RequestExit,
        StoryBeatSkipped,
        PresentationCompleted,
        ClientError,
    }

    public static class BridgeMessageTypeExtensions
    {
        public static string ToWireName(this BridgeMessageType type) => type switch
        {
            BridgeMessageType.Initialize => "initialize",
            BridgeMessageType.LoadLevel => "loadLevel",
            BridgeMessageType.StateSnapshot => "stateSnapshot",
            BridgeMessageType.TransitionResult => "transitionResult",
            BridgeMessageType.HintResult => "hintResult",
            BridgeMessageType.Pause => "pause",
            BridgeMessageType.Resume => "resume",
            BridgeMessageType.ShowStoryBeat => "showStoryBeat",
            BridgeMessageType.Shutdown => "shutdown",
            BridgeMessageType.FatalError => "fatalError",
            BridgeMessageType.UnityReady => "unityReady",
            BridgeMessageType.ActionIntent => "actionIntent",
            BridgeMessageType.RequestHint => "requestHint",
            BridgeMessageType.RequestRestart => "requestRestart",
            BridgeMessageType.RequestExit => "requestExit",
            BridgeMessageType.StoryBeatSkipped => "storyBeatSkipped",
            BridgeMessageType.PresentationCompleted => "presentationCompleted",
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
