using System.Collections.Generic;
using Newtonsoft.Json.Linq;

namespace ArabSolitaire.Gameplay
{
    public enum CardVisualState
    {
        Hidden,
        Revealed,
        Stock,
        Waste,
        CompletedSlot,
    }

    public sealed class CardVisualIdentity
    {
        public string CardId = string.Empty;
        public string AssociationId = string.Empty;
        public string CardType = string.Empty;
        public string SourceZone = string.Empty;
        public int SourceIndex;
        public string StackId = string.Empty;
        public int Revision;
        public CardVisualState VisualState = CardVisualState.Revealed;
        public bool Interactable = true;
        public string DisplayText = string.Empty;
    }

    public sealed class StackVisualIdentity
    {
        public string StackId = string.Empty;
        public string SourceZone = string.Empty;
        public int SourceIndex;
        public readonly List<CardVisualIdentity> Cards = new();
        public bool IsAtomic => Cards.Count > 0;
    }

    /// <summary>
    /// Maps authoritative gameState JSON into stable visual identities (never keyed by display text).
    /// </summary>
    public static class BoardVisualModel
    {
        public static List<StackVisualIdentity> BuildTableau(JObject gameState, int revision)
        {
            var stacks = new List<StackVisualIdentity>();
            var tableau = gameState?["tableau"] as JArray;
            if (tableau == null)
            {
                return stacks;
            }

            for (var column = 0; column < tableau.Count; column++)
            {
                var col = tableau[column] as JObject;
                if (col == null)
                {
                    continue;
                }

                var stack = new StackVisualIdentity
                {
                    StackId = $"tableau:{column}",
                    SourceZone = "tableau",
                    SourceIndex = column,
                };

                var hidden = col["hiddenCards"] as JArray;
                if (hidden != null)
                {
                    for (var i = 0; i < hidden.Count; i++)
                    {
                        var card = hidden[i] as JObject;
                        if (card == null)
                        {
                            continue;
                        }

                        stack.Cards.Add(BuildCard(card, "tableau", column, revision, CardVisualState.Hidden, i));
                    }
                }

                var exposed = col["exposedUnit"] as JObject;
                if (exposed != null)
                {
                    AppendExposedUnit(stack, exposed, "tableau", column, revision);
                }

                stacks.Add(stack);
            }

            return stacks;
        }

        public static StackVisualIdentity BuildStock(JObject gameState, int revision)
        {
            var stock = gameState?["stock"] as JObject;
            var stack = new StackVisualIdentity { StackId = "stock", SourceZone = "stock", SourceIndex = 0 };
            if (stock == null)
            {
                return stack;
            }

            var undealt = stock["undealt"] as JArray;
            if (undealt != null)
            {
                for (var i = 0; i < undealt.Count; i++)
                {
                    var card = undealt[i] as JObject;
                    if (card != null)
                    {
                        stack.Cards.Add(BuildCard(card, "stock", 0, revision, CardVisualState.Stock, i));
                    }
                }
            }

            var waste = stock["waste"] as JArray;
            if (waste != null)
            {
                for (var i = 0; i < waste.Count; i++)
                {
                    var card = waste[i] as JObject;
                    if (card != null)
                    {
                        stack.Cards.Add(BuildCard(card, "stock", 0, revision, CardVisualState.Waste, i));
                    }
                }
            }

            return stack;
        }

        public static List<StackVisualIdentity> BuildSlots(JObject gameState, int revision)
        {
            var slots = new List<StackVisualIdentity>();
            var slotArray = gameState?["slots"] as JArray;
            if (slotArray == null)
            {
                return slots;
            }

            for (var i = 0; i < slotArray.Count; i++)
            {
                var slot = slotArray[i] as JObject;
                var stack = new StackVisualIdentity
                {
                    StackId = $"slot:{i}",
                    SourceZone = "slot",
                    SourceIndex = i,
                };

                var active = slot?["activeAssociation"] as JObject;
                if (active != null)
                {
                    stack.Cards.Add(BuildCard(active, "slot", i, revision, CardVisualState.CompletedSlot, 0));
                }

                slots.Add(stack);
            }

            return slots;
        }

        private static void AppendExposedUnit(
            StackVisualIdentity stack,
            JObject exposed,
            string zone,
            int index,
            int revision)
        {
            var kind = exposed.Value<string>("kind");
            if (kind == "singleMember" || kind == "singleAssociation")
            {
                var card = exposed["card"] as JObject;
                if (card != null)
                {
                    stack.Cards.Add(BuildCard(card, zone, index, revision, CardVisualState.Revealed, stack.Cards.Count));
                }

                return;
            }

            var cards = exposed["cards"] as JArray;
            if (cards == null)
            {
                return;
            }

            for (var i = 0; i < cards.Count; i++)
            {
                var card = cards[i] as JObject;
                if (card != null)
                {
                    stack.Cards.Add(BuildCard(card, zone, index, revision, CardVisualState.Revealed, stack.Cards.Count));
                }
            }
        }

        private static CardVisualIdentity BuildCard(
            JObject card,
            string zone,
            int index,
            int revision,
            CardVisualState visualState,
            int stackOffset)
        {
            var id = card.Value<string>("id") ?? string.Empty;
            return new CardVisualIdentity
            {
                CardId = id,
                AssociationId = card.Value<string>("associationId") ?? string.Empty,
                CardType = card.Value<string>("kind") ?? "member",
                SourceZone = zone,
                SourceIndex = index,
                StackId = $"{zone}:{index}",
                Revision = revision,
                VisualState = visualState,
                Interactable = visualState is CardVisualState.Revealed or CardVisualState.Waste,
                DisplayText = id,
            };
        }
    }
}
