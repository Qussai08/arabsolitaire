using ArabSolitaire.Gameplay;
using UnityEngine;

namespace ArabSolitaire.Interaction
{
    public readonly struct DropTarget
    {
        public DropTarget(string zone, int index, Vector3 worldPoint)
        {
            Zone = zone;
            Index = index;
            WorldPoint = worldPoint;
        }

        public string Zone { get; }
        public int Index { get; }
        public Vector3 WorldPoint { get; }
        public bool IsValid => !string.IsNullOrEmpty(Zone);
    }

    public sealed class DropTargetResolver : MonoBehaviour
    {
        [SerializeField] private TableauPresenter tableau;
        [SerializeField] private StockPresenter stock;
        [SerializeField] private AssociationSlotPresenter slots;
        [SerializeField] private float pickRadius = 0.55f;

        public void Configure(TableauPresenter t, StockPresenter s, AssociationSlotPresenter a)
        {
            tableau = t;
            stock = s;
            slots = a;
        }

        public DropTarget Resolve(Vector3 worldPoint)
        {
            if (stock != null && Vector3.Distance(worldPoint, stock.StockAnchor) < pickRadius)
            {
                return new DropTarget("stock", 0, stock.StockAnchor);
            }

            if (tableau != null)
            {
                for (var column = 0; column < 8; column++)
                {
                    var anchor = tableau.GetColumnAnchor(column, 8);
                    if (Vector3.Distance(new Vector3(worldPoint.x, anchor.y, worldPoint.z), anchor) < pickRadius)
                    {
                        return new DropTarget("tableau", column, anchor);
                    }
                }
            }

            if (slots != null && Vector3.Distance(worldPoint, slots.SlotAnchor) < pickRadius)
            {
                return new DropTarget("slot", 0, slots.SlotAnchor);
            }

            return default;
        }

        public void SetHighlight(DropTarget target, bool enabled)
        {
            // Placeholder highlight — expanded in CardInteractionController via gizmos/material tint.
        }
    }
}
