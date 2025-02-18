package com.fzfstudio.ezw_utils.extension

/**
 * 将全大写转首字母小写驼峰
 */
fun String.toCamelCase(): String {
    if (!contains("_")) {
        return lowercase()
    }
    val lowerWords = lowercase().split("_")
    var newString = ""
    lowerWords.forEach {
        newString += if (it == lowerWords.first()) {
            it
        } else {
            it.replaceFirstChar { it.uppercase() }
        }
    }
    return newString
}

/**
 * 驼峰转下划线词组
 */
fun String.toUpperSnakeCase(): String =  this.replace(Regex("([a-z])([A-Z])"), "$1_$2").uppercase()

