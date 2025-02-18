package com.fzfstudio.ezw_utils.extension

/// 十进制转十六进制
fun Int.toHexString() = String.format("%02x", this)