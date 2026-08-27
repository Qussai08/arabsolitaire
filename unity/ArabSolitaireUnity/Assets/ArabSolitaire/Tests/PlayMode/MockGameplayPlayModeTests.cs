using System.Collections;
using ArabSolitaire.Bridge;
using ArabSolitaire.Bridge.Android;
using ArabSolitaire.Bridge.Mock;
using ArabSolitaire.Cards;
using ArabSolitaire.Gameplay;
using ArabSolitaire.Gameplay.Greybox;
using Newtonsoft.Json.Linq;
using NUnit.Framework;
using TMPro;
using UnityEngine;
using UnityEngine.TestTools;

namespace ArabSolitaire.Tests.PlayMode
{
    public sealed class MockGameplayPlayModeTests
    {
        private const string FixturePath = "Assets/ArabSolitaire/Bridge/Fixtures/cairo_mock_state.json";

        [UnitySetUp]
        public IEnumerator RemoveProductionTransport()
        {
            var nativeTransport = NativeBridgeTransport.Instance;
            if (nativeTransport != null)
            {
                Object.Destroy(nativeTransport.gameObject);
                yield return null;
            }

            Assert.IsNull(
                NativeBridgeTransport.Instance,
                "Mock PlayMode tests require the production native transport to be absent.");
        }

        [UnityTest]
        public IEnumerator FixtureLoad_PresentsExpectedCardCount()
        {
            var fixture = LoadFixture();
            var go = new GameObject("GreyboxBuilder");
            var builder = go.AddComponent<CairoGreyboxSceneBuilder>();
            builder.SetFixtureAsset(fixture);
            builder.Build();

            for (var frame = 0; frame < 10 && builder.Session?.Transport == null; frame++)
            {
                yield return null;
            }

            Assert.IsNotNull(
                builder.Session?.Transport,
                "Mock session did not initialize within 10 frames.");
            var board = builder.BoardPresenter;
            Assert.IsNotNull(board);
            Assert.GreaterOrEqual(board.ActiveCardCount, 2);
            Assert.IsTrue(
                builder.Session.gameObject.activeInHierarchy,
                "GameplaySystems must remain active after distortion VFX initialization.");
            foreach (var card in board.Tableau.CardsById.Values)
            {
                Assert.IsTrue(
                    card.gameObject.activeInHierarchy,
                    $"Presented card '{card.CardId}' must be active in the hierarchy.");
            }

            Object.Destroy(go);
        }

        [UnityTest]
        public IEnumerator CardVisuals_DistinguishRoleAndConcealedBack()
        {
            var root = new GameObject("CardVisualTestRoot");
            var card = CardView.Create(root.transform);

            card.BindIdentity(
                new CardVisualIdentity
                {
                    CardId = "أحمر",
                    DisplayText = "أحمر",
                    CardType = "member",
                    VisualState = CardVisualState.Revealed,
                    Interactable = true,
                },
                new Color(0.93f, 0.86f, 0.68f));

            var roleBadge = card.transform.Find("RoleBadge");
            var typeLabel = roleBadge?.Find("TypeLabel")?.GetComponent<TMP_Text>();
            var backArtwork = card.transform.Find("BackArtwork");
            Assert.IsNotNull(roleBadge);
            Assert.IsNotNull(typeLabel);
            Assert.AreEqual("كلمة", typeLabel.text);
            Assert.IsTrue(roleBadge.gameObject.activeSelf);
            Assert.IsNotNull(backArtwork);
            Assert.IsFalse(backArtwork.gameObject.activeSelf);

            card.BindIdentity(
                new CardVisualIdentity
                {
                    CardId = "ألوان",
                    DisplayText = "ألوان",
                    CardType = "association",
                    VisualState = CardVisualState.Revealed,
                    Interactable = true,
                },
                Color.white);
            Assert.AreEqual("رابطة", typeLabel.text);
            Assert.IsTrue(roleBadge.gameObject.activeSelf);

            card.BindIdentity(
                new CardVisualIdentity
                {
                    CardId = "مخفي",
                    DisplayText = "مخفي",
                    CardType = "member",
                    VisualState = CardVisualState.Stock,
                    Interactable = false,
                },
                Color.white);
            Assert.IsFalse(roleBadge.gameObject.activeSelf);
            Assert.IsTrue(backArtwork.gameObject.activeSelf);
            Assert.AreEqual("دار الروابط", card.transform.Find("Label").GetComponent<TMP_Text>().text);

            Object.Destroy(root);
            yield return null;
        }

        [UnityTest]
        public IEnumerator AcceptThenReject_UpdatesRevision()
        {
            var fixture = LoadFixture();
            var transport = MockBridgeTransport.CreateRuntime(fixture);
            Assert.AreEqual(0, transport.AuthoritativeRevision);

            var accept = transport.HandleActionIntent(BuildIntent(transport, 0, 2, "req-accept-1"));
            Assert.IsTrue(accept.payload.Value<bool>("accepted"));
            Assert.AreEqual(1, transport.AuthoritativeRevision);
            yield return null;

            var reject = transport.HandleActionIntent(BuildIntent(transport, 2, 0, "req-reject-1"));
            Assert.IsFalse(reject.payload.Value<bool>("accepted"));
            Assert.AreEqual(2, transport.AuthoritativeRevision);

            Object.Destroy(transport.gameObject);
        }

        [UnityTest]
        public IEnumerator StockAdvanceAndRestore_UpdatesRevision()
        {
            var fixture = LoadFixture();
            var transport = MockBridgeTransport.CreateRuntime(fixture);
            var advance = transport.HandleStockAdvanceDemo();
            Assert.IsTrue(advance.payload.Value<bool>("accepted"));
            Assert.AreEqual(3, transport.AuthoritativeRevision);
            yield return null;

            var restore = transport.HandleStockRestoreDemo();
            Assert.IsTrue(restore.payload.Value<bool>("accepted"));
            Assert.AreEqual(4, transport.AuthoritativeRevision);
            Object.Destroy(transport.gameObject);
        }

        [UnityTest]
        public IEnumerator Disconnect_BlocksIntents_UntilReconnect()
        {
            var fixture = LoadFixture();
            var transport = MockBridgeTransport.CreateRuntime(fixture);
            transport.SimulateDisconnect();
            Assert.Throws<System.InvalidOperationException>(() =>
                transport.HandleActionIntent(BuildIntent(transport, 0, 2, "req-offline")));

            transport.SimulateReconnect();
            Assert.IsTrue(transport.IsConnected);
            Assert.IsNotNull(transport.CurrentSnapshot);
            Object.Destroy(transport.gameObject);
            yield return null;
        }

        [UnityTest]
        public IEnumerator Reconnect_RestoresAuthoritativeSnapshot()
        {
            var fixture = LoadFixture();
            var go = new GameObject("GreyboxBuilder");
            var builder = go.AddComponent<CairoGreyboxSceneBuilder>();
            builder.SetFixtureAsset(fixture);
            builder.Build();

            var session = builder.Session;
            Assert.IsNotNull(session);
            for (var frame = 0; frame < 10 && session.Transport == null; frame++)
            {
                yield return null;
            }

            Assert.IsNotNull(
                session.Transport,
                "Mock session did not initialize within 10 frames.");
            session.SimulateDisconnect();
            session.SimulateReconnect();
            yield return null;
            Assert.IsNotNull(session.Transport.CurrentSnapshot);
            Object.Destroy(go);
        }

        [UnityTest]
        public IEnumerator WinDemo_SetsWonStatus()
        {
            var fixture = LoadFixture();
            var transport = MockBridgeTransport.CreateRuntime(fixture);
            var win = transport.HandleWinDemo();
            Assert.IsTrue(win.payload.Value<bool>("accepted"));
            var gameState = transport.CurrentSnapshot.payload["gameState"] as JObject;
            Assert.AreEqual("won", gameState?.Value<string>("status"));
            Object.Destroy(transport.gameObject);
            yield return null;
        }

        private static TextAsset LoadFixture()
        {
#if UNITY_EDITOR
            return UnityEditor.AssetDatabase.LoadAssetAtPath<TextAsset>(FixturePath);
#else
            return Resources.Load<TextAsset>("cairo_mock_state");
#endif
        }

        private static BridgeEnvelope BuildIntent(
            MockBridgeTransport transport,
            int from,
            int to,
            string requestId)
        {
            return new BridgeEnvelope
            {
                schemaVersion = BridgeConstants.SchemaVersion,
                messageId = $"play-{requestId}",
                sessionId = transport.CurrentSnapshot.sessionId,
                attemptId = transport.CurrentSnapshot.attemptId,
                levelDefinitionId = transport.CurrentSnapshot.levelDefinitionId,
                revision = transport.AuthoritativeRevision,
                type = BridgeMessageType.ActionIntent.ToWireName(),
                requestId = requestId,
                payload = new JObject
                {
                    ["action"] = new JObject
                    {
                        ["type"] = "moveTableauToTableau",
                        ["fromColumn"] = from,
                        ["toColumn"] = to,
                    },
                },
            };
        }
    }
}
