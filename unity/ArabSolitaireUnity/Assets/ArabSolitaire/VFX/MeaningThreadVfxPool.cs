using System.Collections.Generic;
using UnityEngine;

namespace ArabSolitaire.Vfx
{
    public sealed class MeaningThreadVfxPool : MonoBehaviour
    {
        [SerializeField] private AssociationThreadVfx prefab;
        [SerializeField] private int poolSize = 8;
        [SerializeField] private Color lowTierColor = new(0.86f, 0.72f, 0.28f, 0.85f);
        [SerializeField] private Color highTierColor = new(0.35f, 0.78f, 0.72f, 0.9f);

        private readonly Queue<AssociationThreadVfx> _pool = new();

        private void Awake()
        {
            for (var i = 0; i < poolSize; i++)
            {
                var instance = prefab != null
                    ? Instantiate(prefab, transform)
                    : new GameObject($"MeaningThread_{i}").AddComponent<AssociationThreadVfx>();
                instance.transform.SetParent(transform, false);
                instance.Hide();
                _pool.Enqueue(instance);
            }
        }

        public void Play(Vector3 from, Vector3 to, int comboTier)
        {
            if (_pool.Count == 0)
            {
                return;
            }

            var vfx = _pool.Dequeue();
            vfx.SetColor(comboTier > 1 ? highTierColor : lowTierColor);
            vfx.Show(from, to);
            StartCoroutine(ReturnAfter(vfx, 0.6f));
        }

        private System.Collections.IEnumerator ReturnAfter(AssociationThreadVfx vfx, float seconds)
        {
            yield return new WaitForSeconds(seconds);
            vfx.Hide();
            _pool.Enqueue(vfx);
        }

        public int PooledCount => _pool.Count;
    }
}
