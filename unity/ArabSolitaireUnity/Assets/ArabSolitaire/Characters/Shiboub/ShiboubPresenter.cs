using ArabSolitaire.Animation;
using TMPro;
using UnityEngine;

namespace ArabSolitaire.Characters
{
    /// <summary>
    /// PLACEHOLDER Shiboub presentation — scale/framing only. Not final art or canon.
    /// </summary>
    public sealed class ShiboubPresenter : MonoBehaviour
    {
        [SerializeField] private TMP_Text placeholderLabel;
        [SerializeField] private Transform body;

        private PresentationAnimCommand _current = PresentationAnimCommand.Idle;
        private float _phase;

        public PresentationAnimCommand CurrentCommand => _current;

        private void Awake() => EnsurePlaceholder();

        private void Update() => Animate();

        public void Play(PresentationAnimCommand command)
        {
            _current = command;
            _phase = 0f;
        }

        public void PlayIdle() => Play(PresentationAnimCommand.Idle);
        public void PlayPoint() => Play(PresentationAnimCommand.Point);
        public void PlayCelebrate() => Play(PresentationAnimCommand.Celebrate);

        private void Animate()
        {
            if (body == null)
            {
                return;
            }

            _phase += Time.deltaTime;
            switch (_current)
            {
                case PresentationAnimCommand.Idle:
                    body.localPosition = Vector3.up * (0.05f + Mathf.Sin(_phase * 1.5f) * 0.02f);
                    body.localRotation = Quaternion.identity;
                    break;
                case PresentationAnimCommand.Point:
                    body.localRotation = Quaternion.Euler(0f, Mathf.Sin(_phase * 6f) * 8f, 0f);
                    break;
                case PresentationAnimCommand.Celebrate:
                    body.localPosition = Vector3.up * (0.1f + Mathf.Abs(Mathf.Sin(_phase * 8f)) * 0.08f);
                    break;
                case PresentationAnimCommand.RejectShake:
                    body.localPosition = new Vector3(Mathf.Sin(_phase * 24f) * 0.04f, 0.05f, 0f);
                    break;
            }
        }

        private void EnsurePlaceholder()
        {
            if (body == null)
            {
                var bodyGo = GameObject.CreatePrimitive(PrimitiveType.Capsule);
                bodyGo.name = "ShiboubBody";
                bodyGo.transform.SetParent(transform, false);
                bodyGo.transform.localScale = new Vector3(0.45f, 0.7f, 0.45f);
                body = bodyGo.transform;
            }

            if (placeholderLabel == null)
            {
                var labelGo = new GameObject("PlaceholderLabel");
                labelGo.transform.SetParent(body, false);
                labelGo.transform.localPosition = new Vector3(0f, 1.2f, 0f);
                labelGo.transform.localRotation = Quaternion.Euler(0f, 180f, 0f);
                placeholderLabel = labelGo.AddComponent<TextMeshPro>();
                placeholderLabel.text = "PLACEHOLDER — Shiboub";
                placeholderLabel.fontSize = 2f;
                placeholderLabel.alignment = TextAlignmentOptions.Center;
            }
        }

        public static ShiboubPresenter Create(Transform parent, Vector3 position)
        {
            var go = new GameObject("ShiboubPresenter");
            go.transform.SetParent(parent, false);
            go.transform.position = position;
            return go.AddComponent<ShiboubPresenter>();
        }
    }
}
