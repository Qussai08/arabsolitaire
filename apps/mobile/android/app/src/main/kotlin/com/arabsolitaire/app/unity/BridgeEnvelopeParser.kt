package com.arabsolitaire.app.unity

/**
 * Pure-Kotlin envelope field extraction for JVM unit tests and Android runtime.
 */
internal object BridgeEnvelopeParser {
    private val messageIdPattern = Regex(""""messageId"\s*:\s*"([^"]+)"""")
    private val sessionIdPattern = Regex(""""sessionId"\s*:\s*"([^"]*)"""")
    private val schemaPattern = Regex(""""schemaVersion"\s*:\s*(\d+)""")

    fun schemaVersion(json: String): Int? =
        schemaPattern.find(json)?.groupValues?.get(1)?.toIntOrNull()

    fun messageId(json: String): String? =
        messageIdPattern.find(json)?.groupValues?.get(1)

    fun sessionId(json: String): String? =
        sessionIdPattern.find(json)?.groupValues?.get(1)

    fun hasTypeField(json: String): Boolean = json.contains("\"type\"")
}
