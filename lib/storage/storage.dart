import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Storage to = Storage._init();

  SharedPreferences? _prefs;

  Storage._init();

  /// 初始化SharpPreferences
  Future<void> _initPrefs() async {
    if (_prefs != null) {
      return;
    }
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setData<T>(String key, T value) async {
    await _initPrefs();
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
  Future<T?> getData<T>(String key) async {
    await _initPrefs();
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
      return await _getMap(key) as T?;
    }
    return null;
  }

  void _setMap(String key, Map map) async {
    final jsonString = jsonEncode(map);
    await _prefs?.setString(key, jsonString);
  }

  Future<Map?> _getMap(String key) async {
    final jsonString = _prefs?.getString(key) ?? "";
    return jsonString.isEmpty ? null : jsonDecode(jsonString) as Map?;
  }
}
