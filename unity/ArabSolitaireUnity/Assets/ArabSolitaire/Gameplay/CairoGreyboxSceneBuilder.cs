using ArabSolitaire.Animation;
using ArabSolitaire.Cameras;
using ArabSolitaire.Chapters;
using ArabSolitaire.Characters;
using ArabSolitaire.Gameplay;
using ArabSolitaire.UI;
using ArabSolitaire.Vfx;
using UnityEngine;
using UnityEngine.UI;

namespace ArabSolitaire.Gameplay.Greybox
{
    public sealed class CairoGreyboxSceneBuilder : MonoBehaviour
    {
        [SerializeField] private ChapterEnvironmentConfig chapterConfig;
        [SerializeField] private TextAsset fixtureAsset;
        [SerializeField] private PresentationRuntimeConfig runtimeConfig;
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
            BuildEnvironment();
            BuildTable();
            BuildCamera();
            BuildSystems();
            BuildMeaningThreads();
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
            RenderSettings.fogDensity = 0.012f;

            var sun = new GameObject("Sun_PROTOTYPE").AddComponent<Light>();
            sun.type = LightType.Directional;
            sun.color = chapterConfig != null
                ? chapterConfig.accentColor
                : new Color(0.95f, 0.82f, 0.55f);
            sun.intensity = 1.15f;
            sun.transform.rotation = Quaternion.Euler(42f, -35f, 0f);

            var fill = new GameObject("FillCool_PROTOTYPE").AddComponent<Light>();
            fill.type = LightType.Directional;
            fill.color = new Color(0.55f, 0.62f, 0.75f);
            fill.intensity = 0.35f;
            fill.transform.rotation = Quaternion.Euler(20f, 120f, 0f);
        }

        private void BuildEnvironment()
        {
            var env = new GameObject("CairoLibrary_PROTOTYPE");
            BuildArch(env.transform, new Vector3(-3.5f, 1.8f, 2.5f), 2.8f, 3.2f);
            BuildArch(env.transform, new Vector3(3.5f, 1.8f, 2.5f), 2.8f, 3.2f);
            BuildShelf(env.transform, new Vector3(-4.2f, 1.2f, 0.5f));
            BuildShelf(env.transform, new Vector3(4.2f, 1.2f, 0.5f));
            BuildFabricStrip(env.transform, new Vector3(-2f, 2.4f, 1.8f));
            BuildFabricStrip(env.transform, new Vector3(2f, 2.4f, 1.8f));
            BuildManuscript(env.transform, new Vector3(0f, 2.6f, 2.2f));
            BuildDistortionAccent(env.transform, new Vector3(0f, 0.2f, 3.2f));
            BuildDust(env.transform);
        }

        private static void BuildArch(Transform parent, Vector3 pos, float width, float height)
        {
            var arch = GameObject.CreatePrimitive(PrimitiveType.Cube);
            arch.name = "Arch_PROTOTYPE";
            arch.transform.SetParent(parent, false);
            arch.transform.position = pos;
            arch.transform.localScale = new Vector3(width, height, 0.35f);
            arch.GetComponent<Renderer>().material.color = new Color(0.32f, 0.24f, 0.18f);
        }

        private static void BuildShelf(Transform parent, Vector3 pos)
        {
            var shelf = GameObject.CreatePrimitive(PrimitiveType.Cube);
            shelf.name = "Shelf_PROTOTYPE";
            shelf.transform.SetParent(parent, false);
            shelf.transform.position = pos;
            shelf.transform.localScale = new Vector3(0.25f, 2.4f, 1.6f);
            shelf.GetComponent<Renderer>().material.color = new Color(0.28f, 0.2f, 0.14f);
        }

        private static void BuildFabricStrip(Transform parent, Vector3 pos)
        {
            var fabric = GameObject.CreatePrimitive(PrimitiveType.Quad);
            fabric.name = "Fabric_PROTOTYPE";
            fabric.transform.SetParent(parent, false);
            fabric.transform.position = pos;
            fabric.transform.localScale = new Vector3(1.2f, 2.5f, 1f);
            fabric.transform.rotation = Quaternion.Euler(0f, 180f, 0f);
            fabric.GetComponent<Renderer>().material.color = new Color(0.55f, 0.22f, 0.18f, 0.85f);
        }

        private static void BuildManuscript(Transform parent, Vector3 pos)
        {
            var ms = GameObject.CreatePrimitive(PrimitiveType.Quad);
            ms.name = "Manuscript_PROTOTYPE";
            ms.transform.SetParent(parent, false);
            ms.transform.position = pos;
            ms.transform.localScale = new Vector3(0.8f, 0.5f, 1f);
            ms.transform.rotation = Quaternion.Euler(20f, 180f, 0f);
            ms.GetComponent<Renderer>().material.color = new Color(0.82f, 0.74f, 0.58f);
        }

        private static void BuildDistortionAccent(Transform parent, Vector3 pos)
        {
            var accent = GameObject.CreatePrimitive(PrimitiveType.Sphere);
            accent.name = "DistortionAccent_PROTOTYPE";
            accent.transform.SetParent(parent, false);
            accent.transform.position = pos;
            accent.transform.localScale = Vector3.one * 0.35f;
            accent.GetComponent<Renderer>().material.color = new Color(0.35f, 0.08f, 0.28f, 0.6f);
        }

        private static void BuildDust(Transform parent)
        {
            var dustGo = new GameObject("Dust_PROTOTYPE");
            dustGo.transform.SetParent(parent, false);
            var ps = dustGo.AddComponent<ParticleSystem>();
            var main = ps.main;
            main.startLifetime = 3f;
            main.startSpeed = 0.05f;
            main.startSize = 0.03f;
            main.maxParticles = 48;
            main.startColor = new Color(0.9f, 0.82f, 0.65f, 0.25f);
            var emission = ps.emission;
            emission.rateOverTime = 8f;
            var shape = ps.shape;
            shape.shapeType = ParticleSystemShapeType.Box;
            shape.scale = new Vector3(8f, 2f, 4f);
        }

        private void BuildTable()
        {
            var table = GameObject.CreatePrimitive(PrimitiveType.Cube);
            table.name = "GameTable_PROTOTYPE";
            table.transform.position = new Vector3(0f, -0.05f, 0f);
            table.transform.localScale = new Vector3(6.5f, 0.1f, 4.2f);
            table.GetComponent<Renderer>().material.color = new Color(0.24f, 0.17f, 0.12f);
        }

        private void BuildCamera()
        {
            var camGo = new GameObject("PortraitGameplayCamera");
            var cam = camGo.AddComponent<Camera>();
            cam.tag = "MainCamera";
            camGo.AddComponent<PortraitCameraRig>();
            camGo.AddComponent<CameraDirector>();
        }

        private void BuildMeaningThreads()
        {
            var poolGo = new GameObject("MeaningThreadPool");
            poolGo.AddComponent<MeaningThreadVfxPool>();
        }

        private void BuildSystems()
        {
            var systems = new GameObject("GameplaySystems");
            var boardRoot = new GameObject("BoardRoot");
            boardRoot.transform.SetParent(systems.transform, false);

            var tableau = boardRoot.AddComponent<TableauPresenter>();
            var stock = boardRoot.AddComponent<StockPresenter>();
            var slots = boardRoot.AddComponent<AssociationSlotPresenter>();
            BoardPresenter = boardRoot.AddComponent<BoardPresenter>();
            BoardPresenter.Configure(tableau, stock, slots);
            Session = systems.AddComponent<GameplaySessionController>();

            var distortion = systems.AddComponent<DistortionVfx>();
            runtimeConfig ??= ScriptableObject.CreateInstance<PresentationRuntimeConfig>();

            var canvasGo = new GameObject("UI", typeof(Canvas), typeof(CanvasScaler), typeof(GraphicRaycaster));
            var canvas = canvasGo.GetComponent<Canvas>();
            canvas.renderMode = RenderMode.ScreenSpaceOverlay;
            var scaler = canvasGo.GetComponent<CanvasScaler>();
            scaler.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
            scaler.referenceResolution = new Vector2(1080f, 1920f);
            scaler.matchWidthOrHeight = 0.5f;

            Hud = GameplayHud.Create(canvas);
            var shiboub = ShiboubPresenter.Create(systems.transform, new Vector3(2.8f, 0f, 1.2f));
            var threads = FindFirstObjectByType<MeaningThreadVfxPool>();
            var cameraDirector = FindFirstObjectByType<CameraDirector>();
            Session.Configure(
                fixtureAsset,
                BoardPresenter,
                Hud,
                shiboub,
                runtimeConfig,
                cameraDirector,
                threads,
                distortion);

#if UNITY_EDITOR || DEVELOPMENT_BUILD
            systems.AddComponent<DevPerformanceOverlay>();
#endif
        }
    }
}
