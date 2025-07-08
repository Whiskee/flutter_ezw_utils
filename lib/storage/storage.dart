import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_ezw_logger/even_logger.dart';
import 'package:mmkv/mmkv.dart';

class Storage {
  static Storage to = Storage._init();
  MMKV? _mmkvInstance;
  static const _tag = "Storage";

  Storage._init();

  /// TODO:名字先不改了
  /// (使用前必须执行)初始化SharpPreferences
  Future<void> initPrefs() async {
    if (_mmkvInstance != null) {
      return;
    }
    await MMKV.initialize();
    _mmkvInstance = MMKV.defaultMMKV();
  }

  void setData<T>(String key, T value) {
    if (value is String) {
      _mmkvInstance?.encodeString(key, value);
    } else if (value is int) {
      _mmkvInstance?.encodeInt(key, value);
    } else if (value is bool) {
      _mmkvInstance?.encodeBool(key, value);
    } else if (value is double) {
      _mmkvInstance?.encodeDouble(key, value);
    } else if (value is List<String>) {
      _setListString(key, value);
    } else if (value is Map) {
      _setMap(key, value);
    } else if (value is Uint8List) {
      _mmkvInstance?.encodeBytes(key, MMBuffer.fromList(value));
    } else {
      log.e(_tag, "setData with not support type,key=$key,value=$value");
    }
  }

  /// 获取存储数据
  T? getData<T>(String key) {
    if (T == String) {
      return _mmkvInstance?.decodeString(key) as T?;
    } else if (T == int) {
      return _mmkvInstance?.decodeInt(key) as T?;
    } else if (T == double) {
      return _mmkvInstance?.decodeDouble(key) as T?;
    } else if (T == bool) {
      return _mmkvInstance?.decodeBool(key) as T?;
    } else if (T == List<String>) {
      return _getStringList(key) as T;
    } else if (T == Map) {
      return _getMap(key) as T?;
    } else if (T == Uint8List) {
      return _getUint8List(key) as T?;
    }
    log.e(_tag, "getData with not support type,key=$key");
    return null;
  }

  /// 移除缓存信息
  void removeData(String key) {
    _mmkvInstance?.removeValue(key);
  }

  /// 是否有某个key的缓存
  /// @params key, 缓存的Key
  bool isContainerKey(String key) {
    return _mmkvInstance?.containsKey(key) ?? false;
  }

  void _setListString(String key, List<String> data) {
    _mmkvInstance?.encodeString(key, jsonEncode(data));
  }

  List<String> _getStringList(String key) {
    final valueJson = _mmkvInstance?.decodeString(key);
    if (valueJson == null || valueJson.isEmpty) {
      return [];
    }
    return List<String>.from(jsonDecode(valueJson));
  }

  /// 获取到二进制的数据
  Uint8List? _getUint8List(String key) {
    var cacheBytes = _mmkvInstance?.decodeBytes(key);
    if (cacheBytes == null) {
      return null;
    }
    return cacheBytes.asList();
  }

  void _setMap(String key, Map map) {
    final jsonString = jsonEncode(map);
    _mmkvInstance?.encodeString(key, jsonString);
  }

  Map? _getMap(String key) {
    final jsonString = _mmkvInstance?.decodeString(key) ?? "";
    return jsonString.isEmpty ? null : jsonDecode(jsonString) as Map?;
  }
}
