using ArabSolitaire.Gameplay.Greybox;
using UnityEngine;

namespace ArabSolitaire.Core
{
    public sealed class CairoGreyboxBootstrap : MonoBehaviour
    {
        [SerializeField] private TextAsset fixtureAsset;
        [SerializeField] private CairoGreyboxSceneBuilder builder;

        private void Start()
        {
            builder ??= FindFirstObjectByType<CairoGreyboxSceneBuilder>()
                ?? gameObject.AddComponent<CairoGreyboxSceneBuilder>();
            if (fixtureAsset != null)
            {
                builder.SetFixtureAsset(fixtureAsset);
            }

            builder.Build();
        }
    }
}
