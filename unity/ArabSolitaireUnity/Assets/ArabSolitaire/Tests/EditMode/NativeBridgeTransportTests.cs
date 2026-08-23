using ArabSolitaire.Bridge;
using ArabSolitaire.Bridge.Android;
using NUnit.Framework;
using UnityEngine;

namespace ArabSolitaire.Tests.EditMode
{
    public sealed class NativeBridgeTransportTests
    {
        [TearDown]
        public void TearDown()
        {
            foreach (var transport in Object.FindObjectsByType<NativeBridgeTransport>(FindObjectsSortMode.None))
            {
                Object.DestroyImmediate(transport.gameObject);
            }
        }

        [Test]
        public void ConfigureSession_populates_outbound_envelope_fields()
        {
            var transport = NativeBridgeTransport.CreateRuntime();
            transport.ConfigureSession("s1", "a1", "l1");
            transport.EmitUnityReady();

            Assert.That(transport.SessionId, Is.EqualTo("s1"));
            Assert.That(transport.AttemptId, Is.EqualTo("a1"));
            Assert.That(transport.LevelDefinitionId, Is.EqualTo("l1"));
        }

        [Test]
        public void HandleInboundJson_updates_revision_for_snapshot()
        {
            var transport = NativeBridgeTransport.CreateRuntime();
            var json =
                "{\"schemaVersion\":1,\"messageId\":\"snap-1\",\"sessionId\":\"s1\",\"attemptId\":\"a1\",\"levelDefinitionId\":\"l1\",\"revision\":3,\"type\":\"stateSnapshot\",\"payload\":{\"gameState\":{}}}";

            BridgeEnvelope received = null;
            transport.OnInboundMessage += envelope => received = envelope;
            transport.HandleInboundJson(json);

            Assert.That(received, Is.Not.Null);
            Assert.That(transport.AuthoritativeRevision, Is.EqualTo(3));
            Assert.That(transport.CurrentSnapshot, Is.Not.Null);
        }

        [Test]
        public void FlutterBridgeReceiver_routes_to_transport()
        {
            var transport = NativeBridgeTransport.CreateRuntime();
            var receiverGo = new GameObject("receiver");
            var receiver = receiverGo.AddComponent<FlutterBridgeReceiver>();

            receiver.ConfigureSession("s1|a1|l1");
            Assert.That(transport.SessionId, Is.EqualTo("s1"));

            Object.DestroyImmediate(receiverGo);
        }
    }
}
