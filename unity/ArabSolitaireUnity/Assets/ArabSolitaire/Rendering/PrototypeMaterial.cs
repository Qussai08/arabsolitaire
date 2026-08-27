using UnityEngine;

namespace ArabSolitaire.Rendering
{
    /// <summary>
    /// Runtime materials for greybox prototypes. Avoids CreatePrimitive's default
    /// URP Lit material, which often fails (magenta) on GLES/older Mali GPUs.
    /// </summary>
    public static class PrototypeMaterial
    {
        private static Shader _cachedShader;

        public static Material Create(Color color)
        {
            var shader = ResolveShader();
            var mat = new Material(shader);
            ApplyColor(mat, color);
            return mat;
        }

        public static Material CreateParticle(Color color)
        {
            var shader =
                Shader.Find("Universal Render Pipeline/Particles/Unlit")
                ?? Shader.Find("Particles/Standard Unlit")
                ?? ResolveShader();
            var mat = new Material(shader);
            ApplyColor(mat, color);

            if (mat.HasProperty("_Surface"))
            {
                mat.SetFloat("_Surface", 1f);
                mat.EnableKeyword("_SURFACE_TYPE_TRANSPARENT");
            }

            if (mat.HasProperty("_ZWrite"))
            {
                mat.SetFloat("_ZWrite", 0f);
            }

            mat.renderQueue = 3000;
            return mat;
        }

        public static void Apply(Renderer renderer, Color color)
        {
            if (renderer == null)
            {
                return;
            }

            renderer.sharedMaterial = Create(color);
        }

        public static void Tint(Renderer renderer, Color color)
        {
            if (renderer == null)
            {
                return;
            }

            // Ensure instance material uses a known-good shader before tinting.
            if (renderer.sharedMaterial == null ||
                renderer.sharedMaterial.shader == null ||
                renderer.sharedMaterial.shader.name.Contains("Hidden/InternalErrorShader"))
            {
                Apply(renderer, color);
                return;
            }

            ApplyColor(renderer.material, color);
        }

        private static Shader ResolveShader()
        {
            if (_cachedShader != null)
            {
                return _cachedShader;
            }

            _cachedShader =
                Shader.Find("Universal Render Pipeline/Unlit")
                ?? Shader.Find("Universal Render Pipeline/Simple Lit")
                ?? Shader.Find("Unlit/Color")
                ?? Shader.Find("Sprites/Default")
                ?? Shader.Find("Standard");

            if (_cachedShader == null)
            {
                Debug.LogError("PrototypeMaterial: no usable shader found.");
            }

            return _cachedShader;
        }

        private static void ApplyColor(Material mat, Color color)
        {
            if (mat.HasProperty("_BaseColor"))
            {
                mat.SetColor("_BaseColor", color);
            }

            if (mat.HasProperty("_Color"))
            {
                mat.SetColor("_Color", color);
            }

            mat.color = color;
        }
    }
}
