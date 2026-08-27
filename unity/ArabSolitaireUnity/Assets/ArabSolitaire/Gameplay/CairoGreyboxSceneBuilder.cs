using ArabSolitaire.Animation;
using ArabSolitaire.Cameras;
using ArabSolitaire.Chapters;
using ArabSolitaire.Characters;
using ArabSolitaire.Gameplay;
using ArabSolitaire.Rendering;
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

        private bool _built;

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
            if (_built)
            {
                return;
            }

            _built = true;
            ApplyLighting();
            BuildEnvironment();
            BuildTable();
            BuildCamera();
            BuildMeaningThreads();
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
            PrototypeMaterial.Apply(arch.GetComponent<Renderer>(), new Color(0.32f, 0.24f, 0.18f));
        }

        private static void BuildShelf(Transform parent, Vector3 pos)
        {
            var shelf = GameObject.CreatePrimitive(PrimitiveType.Cube);
            shelf.name = "Shelf_PROTOTYPE";
            shelf.transform.SetParent(parent, false);
            shelf.transform.position = pos;
            shelf.transform.localScale = new Vector3(0.25f, 2.4f, 1.6f);
            PrototypeMaterial.Apply(shelf.GetComponent<Renderer>(), new Color(0.28f, 0.2f, 0.14f));
        }

        private static void BuildFabricStrip(Transform parent, Vector3 pos)
        {
            var fabric = GameObject.CreatePrimitive(PrimitiveType.Quad);
            fabric.name = "Fabric_PROTOTYPE";
            fabric.transform.SetParent(parent, false);
            fabric.transform.position = pos;
            fabric.transform.localScale = new Vector3(1.2f, 2.5f, 1f);
            fabric.transform.rotation = Quaternion.Euler(0f, 180f, 0f);
            PrototypeMaterial.Apply(fabric.GetComponent<Renderer>(), new Color(0.55f, 0.22f, 0.18f, 0.85f));
        }

        private static void BuildManuscript(Transform parent, Vector3 pos)
        {
            var ms = GameObject.CreatePrimitive(PrimitiveType.Quad);
            ms.name = "Manuscript_PROTOTYPE";
            ms.transform.SetParent(parent, false);
            ms.transform.position = pos;
            ms.transform.localScale = new Vector3(0.8f, 0.5f, 1f);
            ms.transform.rotation = Quaternion.Euler(20f, 180f, 0f);
            PrototypeMaterial.Apply(ms.GetComponent<Renderer>(), new Color(0.82f, 0.74f, 0.58f));
        }

        private static void BuildDistortionAccent(Transform parent, Vector3 pos)
        {
            var accent = GameObject.CreatePrimitive(PrimitiveType.Sphere);
            accent.name = "DistortionAccent_PROTOTYPE";
            accent.transform.SetParent(parent, false);
            accent.transform.position = pos;
            accent.transform.localScale = Vector3.one * 0.35f;
            PrototypeMaterial.Apply(accent.GetComponent<Renderer>(), new Color(0.35f, 0.08f, 0.28f, 0.6f));
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
            var tableRoot = new GameObject("GameTable_PROTOTYPE");

            CreateTablePart(
                tableRoot.transform,
                "WoodUnderframe",
                new Vector3(0f, -0.17f, 0f),
                new Vector3(6.9f, 0.22f, 4.55f),
                new Color(0.22f, 0.09f, 0.045f));

            CreateTablePart(
                tableRoot.transform,
                "FeltSurface",
                new Vector3(0f, -0.045f, 0f),
                new Vector3(6.5f, 0.10f, 4.2f),
                new Color(0.055f, 0.19f, 0.17f));

            var wood = new Color(0.34f, 0.14f, 0.065f);
            CreateTablePart(tableRoot.transform, "RailLeft", new Vector3(-3.31f, 0.04f, 0f), new Vector3(0.18f, 0.20f, 4.45f), wood);
            CreateTablePart(tableRoot.transform, "RailRight", new Vector3(3.31f, 0.04f, 0f), new Vector3(0.18f, 0.20f, 4.45f), wood);
            CreateTablePart(tableRoot.transform, "RailNear", new Vector3(0f, 0.04f, -2.14f), new Vector3(6.45f, 0.20f, 0.18f), wood);
            CreateTablePart(tableRoot.transform, "RailFar", new Vector3(0f, 0.04f, 2.14f), new Vector3(6.45f, 0.20f, 0.18f), wood);

            var gold = new Color(0.72f, 0.47f, 0.16f);
            CreateTablePart(tableRoot.transform, "GoldInlayNear", new Vector3(0f, 0.105f, -1.99f), new Vector3(6.15f, 0.025f, 0.035f), gold);
            CreateTablePart(tableRoot.transform, "GoldInlayFar", new Vector3(0f, 0.105f, 1.99f), new Vector3(6.15f, 0.025f, 0.035f), gold);

            var laneColor = new Color(0.10f, 0.27f, 0.23f);
            for (var i = 0; i < 6; i++)
            {
                var x = (i - 2.5f) * 0.85f;
                CreateTablePart(
                    tableRoot.transform,
                    $"TableauLane_{i + 1}",
                    new Vector3(x, 0.02f, -0.20f),
                    new Vector3(0.67f, 0.018f, 1.65f),
                    laneColor);
            }

            var slotColor = new Color(0.26f, 0.20f, 0.14f);
            CreateTablePart(tableRoot.transform, "StockMat", new Vector3(-2.8f, 0.02f, 1.2f), new Vector3(0.76f, 0.018f, 1.10f), slotColor);
            CreateTablePart(tableRoot.transform, "WasteMat", new Vector3(-2.0f, 0.02f, 1.2f), new Vector3(0.76f, 0.018f, 1.10f), slotColor);
            CreateTablePart(tableRoot.transform, "AssociationMat", new Vector3(2.6f, 0.02f, 1.1f), new Vector3(0.86f, 0.018f, 1.18f), gold);
        }

        private static GameObject CreateTablePart(
            Transform parent,
            string name,
            Vector3 position,
            Vector3 scale,
            Color color)
        {
            var part = GameObject.CreatePrimitive(PrimitiveType.Cube);
            part.name = name;
            part.transform.SetParent(parent, false);
            part.transform.localPosition = position;
            part.transform.localScale = scale;
            PrototypeMaterial.Apply(part.GetComponent<Renderer>(), color);

            var collider = part.GetComponent<Collider>();
            if (collider != null)
            {
                collider.enabled = false;
            }

            return part;
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
            Session.Initialize();

#if UNITY_EDITOR || DEVELOPMENT_BUILD
            systems.AddComponent<DevPerformanceOverlay>();
#endif
        }
    }
}
