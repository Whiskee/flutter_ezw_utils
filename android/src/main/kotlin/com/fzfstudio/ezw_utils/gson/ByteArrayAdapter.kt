package com.fzfstudio.ezw_utils.gson

import com.google.gson.JsonDeserializationContext
import com.google.gson.JsonDeserializer
import com.google.gson.JsonElement
import com.google.gson.JsonPrimitive
import com.google.gson.JsonSerializationContext
import com.google.gson.JsonSerializer
import java.lang.reflect.Type
import kotlin.io.encoding.Base64
import kotlin.io.encoding.ExperimentalEncodingApi

class ByteArrayAdapter : JsonSerializer<ByteArray>, JsonDeserializer<ByteArray> {

    // 将 ByteArray 转换为 Base64 编码的字符串
    @OptIn(ExperimentalEncodingApi::class)
    override fun serialize(
        src: ByteArray?,
        typeOfSrc: Type?,
        context: JsonSerializationContext?
    ): JsonElement? = src?.let { JsonPrimitive(Base64.Default.encode(it)) }

    // 将 Base64 字符串解码为 ByteArray
    @OptIn(ExperimentalEncodingApi::class)
    override fun deserialize(
        json: JsonElement?,
        typeOfT: Type?,
        context: JsonDeserializationContext?
    ): ByteArray? = json?.asString?.let { Base64.Default.decode(it) }

}