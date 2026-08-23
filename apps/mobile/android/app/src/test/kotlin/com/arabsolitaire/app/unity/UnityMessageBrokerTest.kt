package com.arabsolitaire.app.unity

import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Test

class UnityMessageBrokerTest {
    private val dispatcher = object : MainThreadDispatcher {
        val tasks = mutableListOf<() -> Unit>()
        override fun post(block: () -> Unit) {
            tasks.add(block)
        }
    }

    @Test
    fun queuesUntilUnityReadyThenFlushesInOrder() {
        val broker = UnityMessageBroker(dispatcher = dispatcher, maxQueueSize = 4)
        broker.configureSession("session-1")
        broker.onMessageToFlutter = {}

        val first = """{"schemaVersion":1,"messageId":"m1","sessionId":"session-1","attemptId":"a","levelDefinitionId":"l","revision":0,"type":"pause","payload":{}}"""
        val second = """{"schemaVersion":1,"messageId":"m2","sessionId":"session-1","attemptId":"a","levelDefinitionId":"l","revision":0,"type":"resume","payload":{}}"""

        val sent = mutableListOf<String>()
        broker.onSendToUnity = { sent.add(it) }

        assertNull(broker.onFlutterToUnity(first))
        assertNull(broker.onFlutterToUnity(second))
        assertEquals(0, sent.size)

        broker.markUnityReady()
        dispatcher.tasks.forEach { it.invoke() }

        assertEquals(listOf(first, second), sent)
    }

    @Test
    fun rejectsDuplicateMessageIds() {
        val broker = UnityMessageBroker(dispatcher = dispatcher)
        broker.configureSession("session-1")
        broker.markUnityReady()

        val json = """{"schemaVersion":1,"messageId":"dup","sessionId":"session-1","attemptId":"a","levelDefinitionId":"l","revision":0,"type":"pause","payload":{}}"""
        broker.onSendToUnity = {}
        assertNull(broker.onFlutterToUnity(json))
        dispatcher.tasks.forEach { it.invoke() }
        assertEquals(BridgeTransportError.DuplicateMessage, broker.onFlutterToUnity(json))
    }

    @Test
    fun rejectsStaleSession() {
        val broker = UnityMessageBroker(dispatcher = dispatcher)
        broker.configureSession("session-1")
        broker.markUnityReady()

        val json = """{"schemaVersion":1,"messageId":"m3","sessionId":"session-2","attemptId":"a","levelDefinitionId":"l","revision":0,"type":"pause","payload":{}}"""
        assertEquals(BridgeTransportError.StaleSession, broker.onFlutterToUnity(json))
    }

    @Test
    fun enforcesQueueLimit() {
        val broker = UnityMessageBroker(dispatcher = dispatcher, maxQueueSize = 2)
        broker.configureSession("session-1")
        broker.onSendToUnity = {}

        repeat(3) { index ->
            val json =
                """{"schemaVersion":1,"messageId":"m$index","sessionId":"session-1","attemptId":"a","levelDefinitionId":"l","revision":0,"type":"pause","payload":{}}"""
            assertNull(broker.onFlutterToUnity(json))
        }

        broker.markUnityReady()
        assertNotNull(broker.onSendToUnity)
    }
}
