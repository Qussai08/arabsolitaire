#if UNITY_EDITOR
using System;
using System.IO;
using System.Linq;
using ArabSolitaire.Core;
using UnityEditor;
using UnityEditor.Build.Reporting;
using UnityEngine;

namespace ArabSolitaire.EditorTools
{
    /// <summary>
    /// Reproducible Unity-as-a-Library export for the Flutter Android app.
    /// Output: &lt;repo&gt;/apps/mobile/android/unityLibrary (gitignored by default).
    /// </summary>
    public static class AndroidLibraryExporter
    {
        private const string MenuPath = "Arab Solitaire/Build/Export Android Library";

        private static readonly string[] RequiredScenes =
        {
            "Assets/ArabSolitaire/Scenes/Bootstrap.unity",
            "Assets/ArabSolitaire/Scenes/GameplayCore.unity",
            "Assets/ArabSolitaire/Scenes/Chapter_Cairo_Greybox.unity",
        };

        [MenuItem(MenuPath)]
        public static void ExportFromMenu()
        {
            if (!EditorUtility.DisplayDialog(
                    "Export Android Library",
                    "Exports Unity as a Library to apps/mobile/android/unityLibrary.\n\n" +
                    "This may take several minutes. Continue?",
                    "Export",
                    "Cancel"))
            {
                return;
            }

            ExportInternal();
        }

        public static void ExportFromCommandLine()
        {
            ExportInternal();
            EditorApplication.Exit(0);
        }

        private static void ExportInternal()
        {
            ValidateScenes();
            ValidateMobileSettings();

            var outputRoot = ResolveOutputRoot();
            var stagingRoot = Path.Combine(outputRoot, "_staging");
            if (Directory.Exists(stagingRoot))
            {
                Directory.Delete(stagingRoot, true);
            }

            Directory.CreateDirectory(stagingRoot);

            EditorUserBuildSettings.SwitchActiveBuildTarget(
                BuildTargetGroup.Android,
                BuildTarget.Android);
            EditorUserBuildSettings.exportAsGoogleAndroidProject = true;
            EditorUserBuildSettings.androidBuildSystem = AndroidBuildSystem.Gradle;
            PlayerSettings.Android.targetArchitectures = AndroidArchitecture.ARM64;

            var options = new BuildPlayerOptions
            {
                scenes = RequiredScenes,
                locationPathName = stagingRoot,
                target = BuildTarget.Android,
                options = BuildOptions.AcceptExternalModificationsToPlayer,
            };

            Debug.Log($"[AndroidLibraryExporter] Building to {stagingRoot}");
            var report = BuildPipeline.BuildPlayer(options);
            if (report.summary.result != BuildResult.Succeeded)
            {
                throw new InvalidOperationException(
                    $"Unity Android export failed: {report.summary.result}");
            }

            var unityLibrarySrc = Path.Combine(stagingRoot, "unityLibrary");
            if (!Directory.Exists(unityLibrarySrc))
            {
                throw new InvalidOperationException(
                    "Export succeeded but unityLibrary folder was not found in staging output.");
            }

            var unityLibraryDest = Path.Combine(outputRoot, "unityLibrary");
            if (Directory.Exists(unityLibraryDest))
            {
                Directory.Delete(unityLibraryDest, true);
            }

            CopyDirectory(unityLibrarySrc, unityLibraryDest);
            WriteReadme(outputRoot);

            Debug.Log($"[AndroidLibraryExporter] Export complete: {unityLibraryDest}");
            EditorUtility.RevealInFinder(unityLibraryDest);
        }

        private static void ValidateScenes()
        {
            foreach (var scene in RequiredScenes)
            {
                if (!File.Exists(scene))
                {
                    throw new InvalidOperationException($"Missing required scene: {scene}");
                }
            }
        }

        private static void ValidateMobileSettings()
        {
            if (PlayerSettings.defaultInterfaceOrientation != UIOrientation.Portrait &&
                !PlayerSettings.allowedAutorotateToPortrait)
            {
                Debug.LogWarning(
                    "[AndroidLibraryExporter] Project is not portrait-first; verify Player Settings.");
            }

            if (!PlayerSettings.GetGraphicsAPIs(BuildTarget.Android).Contains(GraphicsDeviceType.OpenGLES3))
            {
                Debug.LogWarning(
                    "[AndroidLibraryExporter] OpenGLES3 not listed for Android; verify URP mobile settings.");
            }
        }

        private static string ResolveOutputRoot()
        {
            // unity/ArabSolitaireUnity -> repo root -> apps/mobile/android
            var unityProject = Directory.GetParent(Application.dataPath)!.FullName;
            var repoRoot = Directory.GetParent(Directory.GetParent(unityProject)!.FullName)!.FullName;
            return Path.Combine(repoRoot, "apps", "mobile", "android");
        }

        private static void WriteReadme(string outputRoot)
        {
            var readmePath = Path.Combine(outputRoot, "unityLibrary.README.md");
            File.WriteAllText(
                readmePath,
                "# unityLibrary (generated)\n\n" +
                "Reproducible output of Unity as a Library export.\n\n" +
                "Regenerate with:\n\n" +
                "- Unity menu: Arab Solitaire > Build > Export Android Library\n" +
                "- Or batchmode: `-executeMethod ArabSolitaire.EditorTools.AndroidLibraryExporter.ExportFromCommandLine`\n\n" +
                "Do not commit this folder unless explicitly approved for artifact storage.\n");
        }

        private static void CopyDirectory(string source, string dest)
        {
            Directory.CreateDirectory(dest);
            foreach (var file in Directory.GetFiles(source, "*", SearchOption.AllDirectories))
            {
                var relative = Path.GetRelativePath(source, file);
                var target = Path.Combine(dest, relative);
                Directory.CreateDirectory(Path.GetDirectoryName(target)!);
                File.Copy(file, target, true);
            }
        }
    }
}
#endif
