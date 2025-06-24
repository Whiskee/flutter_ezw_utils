import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Storage to = Storage._init();

  SharedPreferences? _prefs;

  Storage._init();

  /// (使用前必须执行)初始化SharpPreferences
  Future<void> initPrefs() async {
    if (_prefs != null) {
      return;
    }
    _prefs = await SharedPreferences.getInstance();
  }

  void setData<T>(String key, T value) {
    if (value is String) {
      _prefs?.setString(key, value);
    } else if (value is int) {
      _prefs?.setInt(key, value);
    } else if (value is bool) {
      _prefs?.setBool(key, value);
    } else if (value is double) {
      _prefs?.setDouble(key, value);
    } else if (value is List<String>) {
      _prefs?.setStringList(key, value);
    } else if (value is Map) {
      _setMap(key, value);
    }
  }

  /// 获取存储数据
  T? getData<T>(String key) {
    if (T == String) {
      return _prefs?.getString(key) as T?;
    } else if (T == int) {
      return _prefs?.getInt(key) as T?;
    } else if (T == double) {
      return _prefs?.getDouble(key) as T?;
    } else if (T == bool) {
      return _prefs?.getBool(key) as T?;
    } else if (T == List<String>) {
      return _prefs?.getStringList(key) as T?;
    } else if (T == Map) {
      return _getMap(key) as T?;
    }
    return null;
  }

  void _setMap(String key, Map map) {
    final jsonString = jsonEncode(map);
    _prefs?.setString(key, jsonString);
  }

  Map? _getMap(String key) {
    final jsonString = _prefs?.getString(key) ?? "";
    return jsonString.isEmpty ? null : jsonDecode(jsonString) as Map?;
  }
}
