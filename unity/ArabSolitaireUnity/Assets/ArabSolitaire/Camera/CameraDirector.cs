using System.Collections;
using ArabSolitaire.Animation;
using UnityEngine;

namespace ArabSolitaire.Cameras
{
    public enum CameraBeat
    {
        Gameplay,
        Selection,
        AssociationComplete,
        Streak,
        Reject,
        Win,
        NodeRestore,
    }

    /// <summary>
    /// Camera director without Cinemachine dependency (Unity 6000.5 compatible).
    /// </summary>
    public sealed class CameraDirector : MonoBehaviour
    {
        [SerializeField] private Camera targetCamera;
        [SerializeField] private PresentationRuntimeConfig config;
        [SerializeField] private Vector3 gameplayPosition = new(0f, 4.05f, -6.6f);
        [SerializeField] private Vector3 gameplayEuler = new(29f, 0f, 0f);
        [SerializeField] private float gameplayFov = 44f;

        private Coroutine _blend;

        private void Awake()
        {
            targetCamera ??= Camera.main ?? GetComponent<Camera>();
            ApplyImmediate(CameraBeat.Gameplay);
        }

        public void PlayBeat(CameraBeat beat)
        {
            if (config != null && (!config.enableCameraMotion || config.reducedMotion))
            {
                return;
            }

            if (_blend != null)
            {
                StopCoroutine(_blend);
            }

            _blend = StartCoroutine(BlendTo(beat));
        }

        private IEnumerator BlendTo(CameraBeat beat)
        {
            var startPos = targetCamera.transform.position;
            var startRot = targetCamera.transform.rotation;
            var startFov = targetCamera.fieldOfView;
            GetBeatTransform(beat, out var endPos, out var endRot, out var endFov);
            var duration = config != null ? config.ScaleDuration(config.cameraBlendDuration) : 0.35f;
            var t = 0f;
            while (t < duration)
            {
                t += Time.deltaTime;
                var k = Mathf.SmoothStep(0f, 1f, t / duration);
                targetCamera.transform.position = Vector3.Lerp(startPos, endPos, k);
                targetCamera.transform.rotation = Quaternion.Slerp(startRot, endRot, k);
                targetCamera.fieldOfView = Mathf.Lerp(startFov, endFov, k);
                yield return null;
            }
        }

        private void ApplyImmediate(CameraBeat beat)
        {
            GetBeatTransform(beat, out var pos, out var rot, out var fov);
            targetCamera.transform.position = pos;
            targetCamera.transform.rotation = rot;
            targetCamera.fieldOfView = fov;
        }

        private void GetBeatTransform(CameraBeat beat, out Vector3 pos, out Quaternion rot, out float fov)
        {
            pos = gameplayPosition;
            rot = Quaternion.Euler(gameplayEuler);
            fov = gameplayFov;
            switch (beat)
            {
                case CameraBeat.Selection:
                    pos += new Vector3(0f, 0.15f, -0.2f);
                    fov -= 2f;
                    break;
                case CameraBeat.AssociationComplete:
                case CameraBeat.Streak:
                    pos += new Vector3(0f, 0.25f, -0.35f);
                    fov -= 3f;
                    break;
                case CameraBeat.Reject:
                    pos += new Vector3(Mathf.Sin(Time.time * 20f) * 0.02f, 0f, 0f);
                    break;
                case CameraBeat.Win:
                case CameraBeat.NodeRestore:
                    pos += new Vector3(0f, 0.5f, -0.6f);
                    rot = Quaternion.Euler(gameplayEuler.x - 4f, 0f, 0f);
                    fov -= 5f;
                    break;
            }
        }
    }
}
