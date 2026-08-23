using System.Collections;
using ArabSolitaire.Bridge;
using ArabSolitaire.Bridge.Mock;
using ArabSolitaire.Gameplay;
using ArabSolitaire.Gameplay.Greybox;
using Newtonsoft.Json.Linq;
using NUnit.Framework;
using UnityEngine;
using UnityEngine.TestTools;

namespace ArabSolitaire.Tests.PlayMode
{
    public sealed class MockGameplayPlayModeTests
    {
        private const string FixturePath = "Assets/ArabSolitaire/Bridge/Fixtures/cairo_mock_state.json";

        [UnityTest]
        public IEnumerator FixtureLoad_PresentsExpectedCardCount()
        {
            var fixture = LoadFixture();
            var go = new GameObject("GreyboxBuilder");
            var builder = go.AddComponent<CairoGreyboxSceneBuilder>();
            builder.SetFixtureAsset(fixture);
            builder.Build();
            yield return null;

            var board = Object.FindFirstObjectByType<BoardPresenter>();
            Assert.IsNotNull(board);
            Assert.GreaterOrEqual(board.ActiveCardCount, 2);
            Object.Destroy(go);
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
            yield return null;

            var session = Object.FindFirstObjectByType<GameplaySessionController>();
            Assert.IsNotNull(session);
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
