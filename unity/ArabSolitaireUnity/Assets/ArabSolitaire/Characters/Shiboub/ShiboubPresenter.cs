using ArabSolitaire.Animation;
using ArabSolitaire.Rendering;
using TMPro;
using UnityEngine;

namespace ArabSolitaire.Characters
{
    /// <summary>
    /// PLACEHOLDER Shiboub presentation — stylized capsule proxy. Not final art or canon dialogue.
    /// </summary>
    public sealed class ShiboubPresenter : MonoBehaviour
    {
        [SerializeField] private TMP_Text placeholderLabel;
        [SerializeField] private Transform body;
        [SerializeField] private Transform hair;

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
        public void PlayNotice() => Play(PresentationAnimCommand.Notice);
        public void PlayPoint() => Play(PresentationAnimCommand.Point);
        public void PlayWarning() => Play(PresentationAnimCommand.Warning);
        public void PlayCelebrate() => Play(PresentationAnimCommand.Celebrate);
        public void PlayConcerned() => Play(PresentationAnimCommand.Concerned);
        public void PlayReject() => Play(PresentationAnimCommand.RejectShake);

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
                case PresentationAnimCommand.Notice:
                    body.localRotation = Quaternion.Euler(Mathf.Sin(_phase * 4f) * 4f, 0f, 0f);
                    break;
                case PresentationAnimCommand.Point:
                    body.localRotation = Quaternion.Euler(0f, Mathf.Sin(_phase * 6f) * 10f, 0f);
                    break;
                case PresentationAnimCommand.Warning:
                case PresentationAnimCommand.Concerned:
                    body.localPosition = new Vector3(0f, 0.04f + Mathf.Sin(_phase * 3f) * 0.01f, 0f);
                    body.localRotation = Quaternion.Euler(0f, 0f, Mathf.Sin(_phase * 5f) * 3f);
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
                bodyGo.name = "ShiboubBody_PROTOTYPE";
                bodyGo.transform.SetParent(transform, false);
                bodyGo.transform.localScale = new Vector3(0.45f, 0.7f, 0.45f);
                PrototypeMaterial.Apply(bodyGo.GetComponent<Renderer>(), new Color(0.28f, 0.18f, 0.12f));
                body = bodyGo.transform;
            }

            if (hair == null)
            {
                var hairGo = GameObject.CreatePrimitive(PrimitiveType.Sphere);
                hairGo.name = "ShiboubHair_PROTOTYPE";
                hairGo.transform.SetParent(body, false);
                hairGo.transform.localPosition = new Vector3(0f, 0.75f, 0f);
                hairGo.transform.localScale = new Vector3(0.9f, 0.55f, 0.9f);
                PrototypeMaterial.Apply(hairGo.GetComponent<Renderer>(), new Color(0.05f, 0.05f, 0.08f));
                hair = hairGo.transform;
            }

            if (placeholderLabel == null)
            {
                var labelGo = new GameObject("PlaceholderLabel");
                labelGo.transform.SetParent(body, false);
                labelGo.transform.localPosition = new Vector3(0f, 1.2f, 0f);
                labelGo.transform.localRotation = Quaternion.Euler(0f, 180f, 0f);
                placeholderLabel = labelGo.AddComponent<TextMeshPro>();
                placeholderLabel.text = "PLACEHOLDER — Shiboub";
                placeholderLabel.fontSize = 1.6f;
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
