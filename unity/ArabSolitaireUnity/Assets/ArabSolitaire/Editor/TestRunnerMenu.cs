using UnityEditor;
using UnityEditor.TestTools.TestRunner.Api;
using UnityEngine;

namespace ArabSolitaire.Editor
{
    public static class TestRunnerMenu
    {
        [MenuItem("Arab Solitaire/Run EditMode Tests")]
        public static void RunEditModeTests() => RunTests(TestMode.EditMode);

        [MenuItem("Arab Solitaire/Run PlayMode Tests")]
        public static void RunPlayModeTests() => RunTests(TestMode.PlayMode);

        private static void RunTests(TestMode mode)
        {
            var api = ScriptableObject.CreateInstance<TestRunnerApi>();
            api.Execute(new ExecutionSettings(new Filter { testMode = mode }));
        }
    }
}
