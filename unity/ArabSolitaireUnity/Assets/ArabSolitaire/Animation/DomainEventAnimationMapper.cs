using System.Collections.Generic;
using Newtonsoft.Json.Linq;
using UnityEngine;

namespace ArabSolitaire.Animation
{
    public enum DomainAnimKind
    {
        None,
        MoveAccepted,
        MoveRejected,
        CardRevealed,
        StackCreated,
        StacksMerged,
        AssociationActivated,
        MembersAttached,
        AssociationCompleted,
        StockAdvanced,
        StockRestored,
        StreakRewardEarned,
        UndoPerformed,
        OutOfMovesReached,
        GameWon,
        Unknown,
    }

    public sealed class DomainAnimationStep
    {
        public DomainAnimKind Kind = DomainAnimKind.None;
        public JObject Payload = new();
    }

    /// <summary>
    /// Deterministic mapping from authoritative domain events to presentation steps.
    /// No rule decisions here.
    /// </summary>
    public sealed class DomainEventAnimationMapper
    {
        private static readonly Dictionary<string, DomainAnimKind> WireMap = new()
        {
            ["MoveAccepted"] = DomainAnimKind.MoveAccepted,
            ["MoveRejected"] = DomainAnimKind.MoveRejected,
            ["CardRevealed"] = DomainAnimKind.CardRevealed,
            ["StackCreated"] = DomainAnimKind.StackCreated,
            ["StacksMerged"] = DomainAnimKind.StacksMerged,
            ["AssociationActivated"] = DomainAnimKind.AssociationActivated,
            ["MembersAttached"] = DomainAnimKind.MembersAttached,
            ["AssociationCompleted"] = DomainAnimKind.AssociationCompleted,
            ["StockAdvanced"] = DomainAnimKind.StockAdvanced,
            ["StockRestored"] = DomainAnimKind.StockRestored,
            ["StreakRewardEarned"] = DomainAnimKind.StreakRewardEarned,
            ["UndoPerformed"] = DomainAnimKind.UndoPerformed,
            ["OutOfMovesReached"] = DomainAnimKind.OutOfMovesReached,
            ["GameWon"] = DomainAnimKind.GameWon,
            // Legacy mock fixture names
            ["cardMoved"] = DomainAnimKind.MoveAccepted,
            ["moveRejected"] = DomainAnimKind.MoveRejected,
            ["associationCompleted"] = DomainAnimKind.AssociationCompleted,
            ["stockAdvanced"] = DomainAnimKind.StockAdvanced,
            ["stockRestored"] = DomainAnimKind.StockRestored,
            ["gameWon"] = DomainAnimKind.GameWon,
            ["hintAvailable"] = DomainAnimKind.None,
        };

        public IReadOnlyList<DomainAnimationStep> Map(JArray events, bool accepted)
        {
            var steps = new List<DomainAnimationStep>();
            if (!accepted)
            {
                steps.Add(new DomainAnimationStep { Kind = DomainAnimKind.MoveRejected });
            }

            if (events == null)
            {
                return steps;
            }

            foreach (var token in events)
            {
                if (token is not JObject evt)
                {
                    continue;
                }

                var type = evt.Value<string>("type") ?? string.Empty;
                if (!WireMap.TryGetValue(type, out var kind))
                {
                    Debug.LogWarning($"Unknown domain event type for presentation: {type}");
                    steps.Add(new DomainAnimationStep { Kind = DomainAnimKind.Unknown, Payload = evt });
                    continue;
                }

                if (kind == DomainAnimKind.None)
                {
                    continue;
                }

                steps.Add(new DomainAnimationStep { Kind = kind, Payload = evt });
            }

            return steps;
        }

        public PresentationAnimCommand ToShiboubCommand(IReadOnlyList<DomainAnimationStep> steps, bool accepted)
        {
            if (!accepted)
            {
                return PresentationAnimCommand.RejectShake;
            }

            foreach (var step in steps)
            {
                switch (step.Kind)
                {
                    case DomainAnimKind.AssociationCompleted:
                    case DomainAnimKind.GameWon:
                    case DomainAnimKind.StreakRewardEarned:
                        return PresentationAnimCommand.Celebrate;
                    case DomainAnimKind.OutOfMovesReached:
                        return PresentationAnimCommand.Concerned;
                    case DomainAnimKind.MoveAccepted:
                    case DomainAnimKind.MembersAttached:
                    case DomainAnimKind.StockAdvanced:
                        return PresentationAnimCommand.Point;
                }
            }

            return PresentationAnimCommand.Idle;
        }
    }
}
