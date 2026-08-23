using System.Collections;
using UnityEngine;

namespace ArabSolitaire.Vfx
{
    public sealed class DistortionVfx : MonoBehaviour
    {
        [SerializeField] private ParticleSystem particles;
        [SerializeField] private float duration = 0.35f;

        private void Awake()
        {
            if (particles == null)
            {
                particles = gameObject.AddComponent<ParticleSystem>();
                var main = particles.main;
                main.startColor = new Color(0.45f, 0.1f, 0.35f, 0.6f);
                main.startSize = 0.08f;
                main.startLifetime = 0.25f;
                main.maxParticles = 24;
            }

            gameObject.SetActive(false);
        }

        public void PlayAt(Vector3 worldPoint)
        {
            transform.position = worldPoint + Vector3.up * 0.05f;
            gameObject.SetActive(true);
            particles.Play();
            StopAllCoroutines();
            StartCoroutine(HideAfter(duration));
        }

        private IEnumerator HideAfter(float seconds)
        {
            yield return new WaitForSeconds(seconds);
            gameObject.SetActive(false);
        }
    }
}
