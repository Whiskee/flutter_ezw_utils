// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';

typedef Rx<T> = ValueNotifier<T>;

extension RxExt<T> on T {
  Rx<T> get rx => Rx<T>(this);
}

abstract class RxCopy<T> {
  T copy();
}

extension RxTExt<T extends RxCopy> on Rx<T> {
  T get deepCopy => value.copy();
}

extension RxListExt<T> on Rx<List<T>> {
  /// 添加列表对象
  void add(T value) {
    final newList = List<T>.from(this.value);
    newList.add(value);
    this.value = newList;
  }
}
