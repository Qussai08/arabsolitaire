package com.arabsolitaire.app.unity

import android.os.Handler
import android.os.Looper
import android.util.Log
import java.util.ArrayDeque

interface MainThreadDispatcher {
    fun post(block: () -> Unit)
}

class AndroidMainThreadDispatcher(
    private val handler: Handler = Handler(Looper.getMainLooper()),
) : MainThreadDispatcher {
    override fun post(block: () -> Unit) {
        handler.post(block)
    }
}

/**
 * Application-scoped broker: queues Flutter→Unity until player ready,
 * forwards Unity→Flutter on main thread, suppresses duplicate message IDs.
 */
class UnityMessageBroker(
    private val dispatcher: MainThreadDispatcher = AndroidMainThreadDispatcher(),
    private val maxQueueSize: Int = 32,
    private val maxSeenIds: Int = 256,
    private val maxPayloadBytes: Int = 256 * 1024,
    private val supportedSchemaVersion: Int = 1,
) {
    enum class LifecycleState {
        Idle,
        Initializing,
        Ready,
        Paused,
        ShuttingDown,
        Destroyed,
    }

    private val outboundQueue = ArrayDeque<String>()
    private val seenMessageIds = LinkedHashSet<String>()
    private var lifecycleState = LifecycleState.Idle
    private var activeSessionId: String? = null
    private var unityReady = false

    var onMessageToFlutter: ((String) -> Unit)? = null
    var onSendToUnity: ((String) -> Unit)? = null

    fun lifecycleState(): LifecycleState = lifecycleState

    fun configureSession(sessionId: String) {
        if (activeSessionId != null && activeSessionId != sessionId) {
            clearQueue()
            seenMessageIds.clear()
        }
        activeSessionId = sessionId
        lifecycleState = LifecycleState.Initializing
        unityReady = false
    }

    fun markUnityReady() {
        unityReady = true
        lifecycleState = LifecycleState.Ready
        flushQueue()
    }

    fun pause() {
        if (lifecycleState == LifecycleState.Ready) {
            lifecycleState = LifecycleState.Paused
        }
    }

    fun resume() {
        if (lifecycleState == LifecycleState.Paused) {
            lifecycleState = LifecycleState.Ready
        }
    }

    fun shutdown() {
        lifecycleState = LifecycleState.ShuttingDown
        clearQueue()
    }

    fun destroy() {
        lifecycleState = LifecycleState.Destroyed
        clearQueue()
        seenMessageIds.clear()
        onMessageToFlutter = null
        onSendToUnity = null
    }

    fun onFlutterToUnity(json: String): BridgeTransportError? {
        if (lifecycleState == LifecycleState.Destroyed ||
            lifecycleState == LifecycleState.ShuttingDown
        ) {
            return BridgeTransportError.LifecycleInvalid
        }

        val validation = validateInbound(json)
        if (validation != null) {
            return validation
        }

        enqueueToUnity(json)
        return null
    }

    fun onUnityToFlutter(json: String) {
        if (lifecycleState == LifecycleState.Destroyed) {
            return
        }

        if (!validateUnityOutbound(json)) {
            Log.w(TAG, "Dropped invalid Unity outbound payload")
            return
        }

        dispatcher.post {
            onMessageToFlutter?.invoke(json)
        }
    }

    private fun validateInbound(json: String): BridgeTransportError? {
        if (json.isBlank()) {
            return BridgeTransportError.EmptyPayload
        }
        if (json.length > maxPayloadBytes) {
            return BridgeTransportError.PayloadTooLarge
        }

        val schema = BridgeEnvelopeParser.schemaVersion(json)
        if (schema == null || schema != supportedSchemaVersion) {
            return BridgeTransportError.UnsupportedSchema
        }

        val messageId = BridgeEnvelopeParser.messageId(json).orEmpty()
        if (messageId.isNotBlank() && seenMessageIds.contains(messageId)) {
            return BridgeTransportError.DuplicateMessage
        }

        val sessionId = BridgeEnvelopeParser.sessionId(json).orEmpty()
        val active = activeSessionId
        if (sessionId.isNotBlank() && !active.isNullOrBlank() && sessionId != active) {
            return BridgeTransportError.StaleSession
        }

        if (messageId.isNotBlank()) {
            rememberMessageId(messageId)
        }

        return null
    }

    private fun validateUnityOutbound(json: String): Boolean {
        if (json.isBlank() || json.length > maxPayloadBytes) {
            return false
        }

        return BridgeEnvelopeParser.hasTypeField(json) &&
            BridgeEnvelopeParser.schemaVersion(json) != null
    }

    private fun enqueueToUnity(json: String) {
        if (unityReady && lifecycleState == LifecycleState.Ready) {
            dispatchToUnity(json)
            return
        }

        if (outboundQueue.size >= maxQueueSize) {
            outboundQueue.removeFirst()
        }
        outboundQueue.addLast(json)
    }

    private fun flushQueue() {
        while (outboundQueue.isNotEmpty() && unityReady && lifecycleState == LifecycleState.Ready) {
            dispatchToUnity(outboundQueue.removeFirst())
        }
    }

    private fun dispatchToUnity(json: String) {
        dispatcher.post {
            onSendToUnity?.invoke(json)
        }
    }

    private fun clearQueue() {
        outboundQueue.clear()
    }

    private fun rememberMessageId(messageId: String) {
        seenMessageIds.add(messageId)
        while (seenMessageIds.size > maxSeenIds) {
            val oldest = seenMessageIds.iterator().next()
            seenMessageIds.remove(oldest)
        }
    }

    companion object {
        private const val TAG = "UnityMessageBroker"
    }
}
