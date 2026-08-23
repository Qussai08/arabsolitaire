using ArabSolitaire.Chapters;
using ArabSolitaire.Characters;
using ArabSolitaire.UI;
using UnityEngine;
using UnityEngine.UI;

namespace ArabSolitaire.Gameplay.Greybox
{
    public sealed class CairoGreyboxSceneBuilder : MonoBehaviour
    {
        [SerializeField] private ChapterEnvironmentConfig chapterConfig;
        [SerializeField] private TextAsset fixtureAsset;
        [SerializeField] private bool buildOnStart = true;

        public BoardPresenter BoardPresenter { get; private set; }
        public GameplaySessionController Session { get; private set; }
        public GameplayHud Hud { get; private set; }

        public void SetFixtureAsset(TextAsset asset) => fixtureAsset = asset;

        private void Start()
        {
            if (buildOnStart)
            {
                Build();
            }
        }

        public void Build()
        {
            ApplyLighting();
            BuildTable();
            BuildCamera();
            BuildSystems();
        }

        private void ApplyLighting()
        {
            RenderSettings.ambientMode = UnityEngine.Rendering.AmbientMode.Flat;
            RenderSettings.ambientLight = chapterConfig != null
                ? chapterConfig.ambientColor
                : new Color(0.45f, 0.38f, 0.28f);
            RenderSettings.fog = true;
            RenderSettings.fogColor = chapterConfig != null
                ? chapterConfig.fogColor
                : new Color(0.35f, 0.28f, 0.22f);
            RenderSettings.fogDensity = 0.015f;

            var sun = new GameObject("Sun").AddComponent<Light>();
            sun.type = LightType.Directional;
            sun.color = chapterConfig != null
                ? chapterConfig.accentColor
                : new Color(0.95f, 0.82f, 0.55f);
            sun.intensity = 1.1f;
            sun.transform.rotation = Quaternion.Euler(42f, -35f, 0f);
        }

        private void BuildTable()
        {
            var table = GameObject.CreatePrimitive(PrimitiveType.Cube);
            table.name = "GameTable";
            table.transform.position = new Vector3(0f, -0.05f, 0f);
            table.transform.localScale = new Vector3(6.5f, 0.1f, 4.2f);
            table.GetComponent<Renderer>().material.color = new Color(0.24f, 0.17f, 0.12f);
        }

        private void BuildCamera()
        {
            var camGo = new GameObject("PortraitGameplayCamera");
            var cam = camGo.AddComponent<Camera>();
            cam.tag = "MainCamera";
            cam.fieldOfView = 48f;
            camGo.transform.position = new Vector3(0f, 4.8f, -5.6f);
            camGo.transform.rotation = Quaternion.Euler(34f, 0f, 0f);
        }

        private void BuildSystems()
        {
            var systems = new GameObject("GameplaySystems");
            BoardPresenter = systems.AddComponent<BoardPresenter>();
            Session = systems.AddComponent<GameplaySessionController>();

            var canvasGo = new GameObject("UI", typeof(Canvas), typeof(CanvasScaler), typeof(GraphicRaycaster));
            var canvas = canvasGo.GetComponent<Canvas>();
            canvas.renderMode = RenderMode.ScreenSpaceOverlay;
            var scaler = canvasGo.GetComponent<CanvasScaler>();
            scaler.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
            scaler.referenceResolution = new Vector2(1080f, 1920f);

            Hud = GameplayHud.Create(canvas);
            var shiboub = ShiboubPresenter.Create(systems.transform, new Vector3(2.8f, 0f, 1.2f));
            Session.Configure(fixtureAsset, BoardPresenter, Hud, shiboub);
        }
    }
}
