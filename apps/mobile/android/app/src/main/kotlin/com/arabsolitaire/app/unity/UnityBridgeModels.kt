package com.arabsolitaire.app.unity

/**
 * Transport-level validation errors mapped for Flutter.
 */
enum class BridgeTransportError(val code: String) {
    EmptyPayload("empty_payload"),
    PayloadTooLarge("payload_too_large"),
    MalformedJson("malformed_json"),
    UnsupportedSchema("unsupported_schema"),
    StaleSession("stale_session"),
    RuntimeNotReady("runtime_not_ready"),
    QueueOverflow("queue_overflow"),
    DuplicateMessage("duplicate_message"),
    LifecycleInvalid("lifecycle_invalid"),
}

data class UnityLaunchArgs(
    val sessionId: String,
    val attemptId: String,
    val levelDefinitionId: String,
    val chapterId: String,
)
