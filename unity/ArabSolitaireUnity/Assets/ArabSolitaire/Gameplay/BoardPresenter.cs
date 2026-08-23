using ArabSolitaire.Bridge;
using Newtonsoft.Json.Linq;
using UnityEngine;

namespace ArabSolitaire.Gameplay
{
    public sealed class BoardPresenter : MonoBehaviour
    {
        [SerializeField] private TableauPresenter tableau;
        [SerializeField] private StockPresenter stock;
        [SerializeField] private AssociationSlotPresenter slots;

        private JObject _lastPresentedState;

        public int ActiveCardCount =>
            (tableau?.CardsById.Count ?? 0) + (stock != null ? 1 : 0);

        public TableauPresenter Tableau => tableau;
        public StockPresenter Stock => stock;
        public AssociationSlotPresenter Slots => slots;

        public void Configure(TableauPresenter t, StockPresenter s, AssociationSlotPresenter a)
        {
            tableau = t;
            stock = s;
            slots = a;
        }

        public void PresentSnapshot(BridgeEnvelope snapshot)
        {
            var gameState = snapshot.payload?["gameState"] as JObject;
            if (gameState == null)
            {
                return;
            }

            PresentGameState(gameState, snapshot.revision);
        }

        public void PresentTransition(TransitionResultPayload transition)
        {
            if (transition?.nextState == null)
            {
                return;
            }

            PresentGameState(transition.nextState, transition.newRevision);
        }

        public void ReconcileTo(BridgeEnvelope snapshot)
        {
            var authoritative = BoardReconciler.ExtractGameState(snapshot);
            if (BoardReconciler.NeedsReconcile(authoritative, _lastPresentedState))
            {
                PresentSnapshot(snapshot);
            }
        }

        public void ReconcileTo(JObject gameState, int revision)
        {
            if (BoardReconciler.NeedsReconcile(gameState, _lastPresentedState))
            {
                PresentGameState(gameState, revision);
            }
        }

        private void PresentGameState(JObject gameState, int revision)
        {
            _lastPresentedState = (JObject)gameState.DeepClone();
            var tableauStacks = BoardVisualModel.BuildTableau(gameState, revision);
            var stockStack = BoardVisualModel.BuildStock(gameState, revision);
            var slotStacks = BoardVisualModel.BuildSlots(gameState, revision);
            tableau?.Present(tableauStacks, revision);
            stock?.Present(stockStack, revision);
            slots?.Present(slotStacks, revision);
        }
    }
}
