using System.Collections.Generic;
using ArabSolitaire.Bridge;
using ArabSolitaire.Cards;
using Newtonsoft.Json.Linq;
using UnityEngine;

namespace ArabSolitaire.Gameplay
{
    public sealed class BoardPresenter : MonoBehaviour
    {
        [SerializeField] private Transform tableauRoot;
        [SerializeField] private Color cardTint = new(0.93f, 0.86f, 0.68f);

        private readonly List<CardView> _active = new();
        private CardViewPool _pool;

        public int ActiveCardCount => _active.Count;

        private void Awake()
        {
            if (tableauRoot == null)
            {
                var root = new GameObject("TableauRoot");
                root.transform.SetParent(transform, false);
                tableauRoot = root.transform;
            }

            _pool = new CardViewPool(tableauRoot);
        }

        public void PresentSnapshot(BridgeEnvelope snapshot)
        {
            Clear();
            var gameState = snapshot.payload["gameState"] as JObject;
            var tableau = gameState?["tableau"] as JArray;
            if (tableau == null)
            {
                return;
            }

            for (var column = 0; column < tableau.Count; column++)
            {
                var col = tableau[column] as JObject;
                var exposed = col?["exposedUnit"] as JObject;
                var card = exposed?["card"] as JObject;
                var id = card?.Value<string>("id");
                if (string.IsNullOrEmpty(id))
                {
                    continue;
                }

                var view = _pool.Rent();
                view.Bind(id, cardTint);
                view.transform.localPosition = new Vector3((column - 1) * 0.85f, 0f, 0f);
                _active.Add(view);
            }
        }

        public void PresentTransition(TransitionResultPayload transition)
        {
            if (transition?.nextState == null)
            {
                return;
            }

            var envelope = new BridgeEnvelope
            {
                schemaVersion = BridgeConstants.SchemaVersion,
                messageId = "local-present",
                sessionId = "local",
                attemptId = "local",
                levelDefinitionId = "local",
                revision = transition.newRevision,
                type = BridgeMessageType.StateSnapshot.ToWireName(),
                payload = new JObject
                {
                    ["revision"] = transition.newRevision,
                    ["gameState"] = transition.nextState,
                },
            };
            PresentSnapshot(envelope);
        }

        private void Clear()
        {
            foreach (var card in _active)
            {
                _pool.Return(card);
            }

            _active.Clear();
        }
    }
}
