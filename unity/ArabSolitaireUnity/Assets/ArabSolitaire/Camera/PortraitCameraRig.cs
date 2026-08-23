using UnityEngine;

namespace ArabSolitaire.Cameras
{
    /// <summary>
    /// Portrait gameplay camera. No Cinemachine dependency in Phase 1
    /// (Cinemachine 3.x hits CS0619 GetInstanceID on Unity 6000.5.9f1).
    /// </summary>
    public sealed class PortraitCameraRig : MonoBehaviour
    {
        [SerializeField] private Camera targetCamera;
        [SerializeField] private Vector3 position = new(0f, 4.8f, -5.6f);
        [SerializeField] private Vector3 euler = new(34f, 0f, 0f);
        [SerializeField] private float fieldOfView = 48f;

        private void Awake()
        {
            targetCamera ??= GetComponent<Camera>() ?? gameObject.AddComponent<Camera>();
            targetCamera.tag = "MainCamera";
            targetCamera.fieldOfView = fieldOfView;
            transform.position = position;
            transform.rotation = Quaternion.Euler(euler);
        }
    }
}
