package com.fzfstudio.ezw_utils.extension

/// 转十六进制
@OptIn(ExperimentalStdlibApi::class)
fun ByteArray.toHexString(): String {
    if (isEmpty()) {
        return ""
    }
    val hexString = StringBuilder()
    for (b in this) {
        hexString.append(b.toInt().toHexString())
    }
    return hexString.toString()
}