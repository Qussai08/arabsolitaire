using UnityEngine;

namespace ArabSolitaire.Animation
{
    [CreateAssetMenu(
        fileName = "PresentationRuntimeConfig",
        menuName = "Arab Solitaire/Presentation Runtime Config")]
    public sealed class PresentationRuntimeConfig : ScriptableObject
    {
        [Header("Motion")]
        public bool reducedMotion;
        public float moveDuration = 0.35f;
        public float rejectDuration = 0.25f;
        public float revealDuration = 0.2f;

        [Header("Quality")]
        public bool lowQualityDevice;
        public int maxParticleCount = 32;
        public bool enableDistortionVfx = true;
        public bool enableMeaningThreads = true;

        [Header("Camera")]
        public bool enableCameraMotion = true;
        public float cameraBlendDuration = 0.45f;

        public float ScaleDuration(float baseSeconds) =>
            reducedMotion ? Mathf.Min(baseSeconds, 0.05f) : baseSeconds;
    }
}
