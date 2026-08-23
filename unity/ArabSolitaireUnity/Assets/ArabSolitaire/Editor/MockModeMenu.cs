#if UNITY_EDITOR
using ArabSolitaire.Bridge.Mock;
using ArabSolitaire.Chapters;
using UnityEditor;
using UnityEngine;

namespace ArabSolitaire.EditorTools
{
    public static class MockModeMenu
    {
        private const string FixturePath = "Assets/ArabSolitaire/Bridge/Fixtures/cairo_mock_state.json";

        [MenuItem("Arab Solitaire/Mock Mode/Load Cairo Fixture")]
        public static void LoadCairoFixture()
        {
            var asset = AssetDatabase.LoadAssetAtPath<TextAsset>(FixturePath);
            if (asset == null)
            {
                Debug.LogError($"Missing fixture at {FixturePath}");
                return;
            }

            var transport = Object.FindFirstObjectByType<MockBridgeTransport>()
                ?? MockBridgeTransport.CreateRuntime(asset);
            transport.LoadFixture(asset);
            Debug.Log("Mock Mode: Cairo fixture loaded.");
        }

        [MenuItem("Arab Solitaire/Create Chapter Placeholder Configs")]
        public static void CreateChapterConfigs()
        {
            Create("cairo", "القاهرة", "Chapters/Cairo/CairoEnvironment.asset");
            Create("alexandria", "الإسكندرية", "Chapters/Alexandria/AlexandriaEnvironment.asset");
            Create("beirut", "بيروت", "Chapters/Beirut/BeirutEnvironment.asset");
            Create("marrakech", "مراكش", "Chapters/Marrakech/MarrakechEnvironment.asset");
            Create("dubai", "دبي", "Chapters/Dubai/DubaiEnvironment.asset");
            AssetDatabase.SaveAssets();
            Debug.Log("Chapter placeholder configs created/updated.");
        }

        private static void Create(string id, string nameAr, string relativePath)
        {
            var path = $"Assets/ArabSolitaire/{relativePath}";
            var dir = System.IO.Path.GetDirectoryName(path);
            if (!System.IO.Directory.Exists(dir))
            {
                System.IO.Directory.CreateDirectory(dir!);
            }

            var asset = AssetDatabase.LoadAssetAtPath<ChapterEnvironmentConfig>(path);
            if (asset == null)
            {
                asset = ScriptableObject.CreateInstance<ChapterEnvironmentConfig>();
                AssetDatabase.CreateAsset(asset, path);
            }

            asset.chapterId = id;
            asset.displayNameAr = nameAr;
            EditorUtility.SetDirty(asset);
        }
    }
}
#endif
