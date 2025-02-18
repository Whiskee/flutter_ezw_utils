package com.fzfstudio.ezw_utils.gson

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import java.io.Serializable

val gson: Gson = GsonBuilder().create()

abstract class GsonSerializable: Serializable {
    open fun toJson(): String = gson.toJson(this)

    open fun toMap(): Map<String, Any> {
        // 使用 TypeToken 来处理泛型类型
        val type = object : TypeToken<Map<String, Any>>() {}.type
        return gson.fromJson(toJson(), type)
    }
}

inline fun <reified T: GsonSerializable> Map<*, *>.toJson(): T? {
    val json = gson.toJson(this)
    return gson.fromJson(json, T::class.java)
}