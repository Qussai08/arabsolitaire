using UnityEngine;
using UnityEngine.SceneManagement;

namespace ArabSolitaire.Core
{
    public sealed class BootstrapController : MonoBehaviour
    {
        [SerializeField] private string nextScene = "GameplayCore";

        private void Start()
        {
            if (!string.IsNullOrWhiteSpace(nextScene))
            {
                SceneManager.LoadScene(nextScene);
            }
        }
    }
}
