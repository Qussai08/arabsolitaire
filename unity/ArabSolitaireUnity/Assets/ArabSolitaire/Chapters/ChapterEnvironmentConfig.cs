using UnityEngine;

namespace ArabSolitaire.Chapters
{
    [CreateAssetMenu(
        fileName = "ChapterEnvironmentConfig",
        menuName = "Arab Solitaire/Chapter Environment Config")]
    public sealed class ChapterEnvironmentConfig : ScriptableObject
    {
        public string chapterId = "cairo";
        public string displayNameAr = "القاهرة";
        public Color ambientColor = new(0.45f, 0.38f, 0.28f);
        public Color accentColor = new(0.82f, 0.68f, 0.35f);
        public Color fogColor = new(0.35f, 0.28f, 0.22f);
        public string paletteNote = "Warm sandstone / gold thread";
        public string lightingNote = "Soft directional library light";
        public string particlesNote = "Dust motes / thread sparkles (placeholder)";
        public string distortionNote = "Heat shimmer off (placeholder)";
        public string cameraNote = "Portrait 9:16 table overview";
        public string audioAmbienceRef = "TBD";
        public string audioMusicRef = "TBD";
        public string sceneRef = "Chapter_Cairo_Greybox";
        public string[] waveStageNames =
        {
            "Wave 1", "Wave 2", "Wave 3", "Wave 4", "Wave 5",
        };
        public string cinematicIntroRef = "BLOCKED — story_beats.json conflicts with Narrative Canon";
        public string cinematicOutroRef = "BLOCKED — do not generate final cinematics from Layla content";
        public string environmentMotif = "Historic library / khan — golden threads";
        [TextArea] public string notes = "Greybox placeholder — painterly cinematic, not chibi.";
    }
}
