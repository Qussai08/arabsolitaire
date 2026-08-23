using Newtonsoft.Json.Linq;

namespace ArabSolitaire.Animation
{
    public enum PresentationAnimCommand
    {
        Idle,
        Point,
        Celebrate,
        RejectShake,
    }

    /// <summary>
    /// Maps authoritative bridge events to presentation-only animation commands.
    /// </summary>
    public sealed class EventAnimationMapper
    {
        public PresentationAnimCommand Map(JArray events, bool accepted)
        {
            if (!accepted)
            {
                return PresentationAnimCommand.RejectShake;
            }

            if (events == null || events.Count == 0)
            {
                return PresentationAnimCommand.Idle;
            }

            foreach (var token in events)
            {
                if (token is not JObject evt)
                {
                    continue;
                }

                switch (evt.Value<string>("type"))
                {
                    case "associationCompleted":
                    case "levelCompleted":
                        return PresentationAnimCommand.Celebrate;
                    case "hintAvailable":
                        return PresentationAnimCommand.Point;
                    case "moveRejected":
                        return PresentationAnimCommand.RejectShake;
                }
            }

            return PresentationAnimCommand.Point;
        }
    }
}
