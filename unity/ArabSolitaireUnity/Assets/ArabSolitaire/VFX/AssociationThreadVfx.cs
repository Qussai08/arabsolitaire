using UnityEngine;

namespace ArabSolitaire.Vfx
{
    /// <summary>
    /// Placeholder association light-thread VFX — presentation only.
    /// </summary>
    public sealed class AssociationThreadVfx : MonoBehaviour
    {
        [SerializeField] private LineRenderer line;
        [SerializeField] private Color threadColor = new(0.86f, 0.72f, 0.28f, 0.85f);

        private void Awake()
        {
            if (line == null)
            {
                line = gameObject.AddComponent<LineRenderer>();
                line.positionCount = 2;
                line.startWidth = 0.03f;
                line.endWidth = 0.01f;
                line.material = new Material(Shader.Find("Sprites/Default"));
                line.startColor = threadColor;
                line.endColor = threadColor;
            }
        }

        public void Show(Vector3 from, Vector3 to)
        {
            gameObject.SetActive(true);
            line.SetPosition(0, from);
            line.SetPosition(1, to);
        }

        public void SetColor(Color color)
        {
            threadColor = color;
            if (line != null)
            {
                line.startColor = color;
                line.endColor = color;
            }
        }

        public void Hide() => gameObject.SetActive(false);
    }
}
