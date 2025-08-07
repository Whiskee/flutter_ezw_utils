import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_ezw_logger/even_logger.dart';
import 'package:mmkv/mmkv.dart';

class Storage {
  static Storage to = Storage._init();
  MMKV? _mmkvInstance;
  static const _tag = "Storage";

  /// 监听器管理
  /// key:存储的key ,value:需要监听变化的所有的callback的回调
  final Map<String, List<_StorageListener>> _changeListeners = {};

  /// 监听的controller map
  /// key: 存储的key,value: 其对应的StreamController，用于监听对应值的变化回调
  final Map<String, StreamController> _valueChangeStreamControllers = {};

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

  /// 添加监听器
  /// @param key 要监听的key
  /// @param callback 值变化时的回调函数
  /// @param T 值的类型
  void addListener<T>(String key, StorageValueChangedCallback callback) {
    if (!_changeListeners.containsKey(key)) {
      _changeListeners[key] = [];
    }

    final listener = _StorageListener<T>(
      key: key,
      callback: callback,
      valueType: T,
    );

    _changeListeners[key]!.add(listener);
  }

  /// 移除监听器
  /// @param key 要移除监听的key
  /// @param callback 要移除的回调函数，如果为null则移除该key的所有监听器
  void removeListener<T>(String key, [StorageValueChangedCallback? callback]) {
    if (!_changeListeners.containsKey(key)) {
      return;
    }

    if (callback == null) {
      // 移除该key的所有监听器
      _changeListeners.remove(key);
      _disposeStreamController(key);
    } else {
      // 移除特定的监听器
      _changeListeners[key]!.removeWhere((listener) =>
          listener.callback == callback && listener.valueType == T);

      if (_changeListeners[key]!.isEmpty) {
        _changeListeners.remove(key);
        _disposeStreamController(key);
      }
    }
  }

  /// 获取指定key的Stream，用于监听值变化
  /// @param key 要监听的key
  /// @param T 值的类型
  /// @return Stream<T?> 值变化的流
  Stream<T?> watch<T>(String key) {
    if (!_valueChangeStreamControllers.containsKey(key)) {
      _valueChangeStreamControllers[key] = StreamController<T?>.broadcast();
    }
    return _valueChangeStreamControllers[key]!.stream.cast<T?>();
  }

  void setData<T>(String key, T value) {
    // 获取旧值用于通知
    T? oldValue = getData<T>(key);

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
    } else if (value is List<Map<String, dynamic>>) {
      _setListMap(key, value);
    } else if (value is Map) {
      _setMap(key, value);
    } else if (value is Map<String, dynamic>) {
      _setMap(key, value);
    } else if (value is Map<dynamic, dynamic>) {
      _setMap(key, value);
    } else if (value is Uint8List) {
      _mmkvInstance?.encodeBytes(key, MMBuffer.fromList(value));
    } else {
      log.e(_tag, "setData with not support type,key=$key,value=$value");
      return;
    }

    // 通知监听器值已变化
    _notifyListeners<T>(key, oldValue, value);
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
    } else if (T == List<Map<String, dynamic>>) {
      return _getMapList(key) as T;
    } else if (T == Map<String, dynamic>) {
      return _getMap(key) as T?;
    } else if (T == Uint8List) {
      return _getUint8List(key) as T?;
    }
    log.e(_tag, "getData with not support type,key=$key");
    return null;
  }

  /// 保存List的缓存数据
  /// @params key 缓存的key
  /// @params list 要缓存的数据list
  /// @params toJson 对应类型T的转换json的方法
  ///       （非string,bool,num类型时最好提供，否则数据可能保存不正确）
  void saveListData<T>(String key, List<T> list,
      [dynamic Function(T item)? toJson]) {
    try {
      // 获取旧值用于通知
      List<T>? oldValue = getListData<T>(key);

      final jsonList = list.map((item) {
        if (item is String || item is num || item is bool) {
          return item; // 基础类型直接存储
        } else if (item is Map || item is List) {
          return item; // Map和List默认支持JSON
        } else if (toJson != null) {
          // 对于自定义对象，使用传入的 toJson 方法
          return toJson(item);
        } else {
          // 如果没有提供 toJson 方法，尝试直接转换
          return item.toString();
        }
      }).toList();

      final jsonString = jsonEncode(jsonList);
      _mmkvInstance?.encodeString(key, jsonString);
      log.d(_tag, "saveListData success: key=$key, count=${list.length}");

      // 通知监听器值已变化
      _notifyListeners<List<T>>(key, oldValue, list);
    } catch (e) {
      log.e(_tag, "saveListData error: key=$key, error=$e");
    }
  }

  /// 获取保存的list数据
  /// @params key 缓存的key
  /// @params list 要缓存的数据list
  /// @params fromJson 对应类型T从json串转换成对应对象的方法
  ///       （非string,bool,num类型时最好提供，否则反序列化可能不正确）
  List<T> getListData<T>(String key, [T Function(dynamic json)? fromJson]) {
    try {
      final jsonString = _mmkvInstance?.decodeString(key);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      final jsonList = jsonDecode(jsonString) as List<dynamic>;

      if (fromJson != null) {
        // 使用传入的 fromJson 方法
        final result = jsonList.map((json) => fromJson(json)).toList();
        return result;
      } else {
        // 如果没有提供 fromJson 方法，尝试直接转换
        final result = jsonList.cast<T>();
        log.d(_tag, "getListData try cast direct: key=$key ");
        return result;
      }
    } catch (e) {
      log.e(_tag, "getListData error: key=$key, error=$e");
      return [];
    }
  }

  /// 移除缓存信息
  void removeData(String key) {
    // 获取旧值用于通知
    final oldValue = _mmkvInstance?.decodeString(key);
    _mmkvInstance?.removeValue(key);

    // 通知监听器值已被移除
    _notifyListeners(key, oldValue, null);
  }

  /// 是否有某个key的缓存
  /// @params key, 缓存的Key
  bool isContainerKey(String key) {
    return _mmkvInstance?.containsKey(key) ?? false;
  }

  /// 通知监听器值已变化
  void _notifyListeners<T>(String key, T? oldValue, T? newValue) async {
    // 通知回调监听器
    if (_changeListeners.containsKey(key)) {
      for (final listener in _changeListeners[key]!) {
        if (listener.valueType == T) {
          try {
            listener.callback(key, oldValue, newValue);
          } catch (e) {
            log.e(_tag,
                "Error in listener callback4444 for key: $key, error: $e");
          }
        }
      }
    }

    // 通知Stream监听器
    if (_valueChangeStreamControllers.containsKey(key)) {
      try {
        _valueChangeStreamControllers[key]!.add(newValue);
      } catch (e) {
        log.e(_tag, "Error in stream controller for key: $key, error: $e");
      }
    }
  }

  /// 释放Stream控制器
  void _disposeStreamController(String key) {
    if (_valueChangeStreamControllers.containsKey(key)) {
      _valueChangeStreamControllers[key]!.close();
      _valueChangeStreamControllers.remove(key);
    }
  }

  void _setListString(String key, List<String> data) {
    _mmkvInstance?.encodeString(key, jsonEncode(data));
  }

  void _setListMap(String key, List<Map<String, dynamic>> data) {
    _mmkvInstance?.encodeString(key, jsonEncode(data));
  }

  List<String> _getStringList(String key) {
    final valueJson = _mmkvInstance?.decodeString(key);
    if (valueJson == null || valueJson.isEmpty) {
      return [];
    }
    return List<String>.from(jsonDecode(valueJson));
  }

  List<Map<String, dynamic>> _getMapList(String key) {
    final valueJson = _mmkvInstance?.decodeString(key);
    if (valueJson == null || valueJson.isEmpty) {
      return [];
    }
    return List<Map<String, dynamic>>.from(jsonDecode(valueJson));
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

  /// 清理所有监听器和Stream控制器
  /// 在应用退出时调用，避免内存泄漏
  void dispose() {
    // 清理所有监听器
    _changeListeners.clear();

    // 关闭所有Stream控制器
    for (final controller in _valueChangeStreamControllers.values) {
      controller.close();
    }
    _valueChangeStreamControllers.clear();

    log.d(_tag, "Storage disposed all listeners and stream controllers");
  }
}

/// 存储监听器包装类
class _StorageListener<T> {
  final String key;
  final StorageValueChangedCallback callback;
  final Type valueType;

  _StorageListener({
    required this.key,
    required this.callback,
    required this.valueType,
  });
}

/// 存储值变化监听器回调类型
typedef StorageValueChangedCallback = void Function(
    String key, dynamic oldValue, dynamic newValue);
