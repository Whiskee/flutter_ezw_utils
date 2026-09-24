import 'package:flutter_ezw_utils/storage/storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mmkv/mmkv.dart';

void main() {
  late _MemoryMMKV backend;
  late Storage storage;
  late List<(String, String?, String?)> changes;

  setUp(() {
    backend = _MemoryMMKV()..values['save'] = 'old';
    storage = Storage.forTesting(backend);
    changes = [];
    storage.addListener<String>('save', (key, oldValue, newValue) {
      changes.add((key, oldValue as String?, newValue as String?));
    });
  });

  test('successful write returns true and notifies with old/new values', () {
    expect(storage.setStringWithResult('save', 'new'), isTrue);
    expect(storage.getData<String>('save'), 'new');
    expect(changes, [('save', 'old', 'new')]);
    expect(backend.writes, 1);
  });

  test('false from MMKV is preserved, without a change notification', () async {
    backend.succeeds = false;
    final noEvents = expectLater(storage.watch<String>('save'), emitsDone);
    expect(storage.setStringWithResult('save', 'new'), isFalse);
    expect(storage.getData<String>('save'), 'old');
    expect(changes, isEmpty);
    // Closing the stream drains queued events; no wall-clock delay.
    storage.removeListener<String>('save');
    await noEvents;
  });

  test('write exception returns false without a change notification', () {
    backend.throwsOnWrite = true;
    expect(storage.setStringWithResult('save', 'new'), isFalse);
    expect(storage.getData<String>('save'), 'old');
    expect(changes, isEmpty);
  });

  test('uninitialized storage returns false without notifying', () {
    final uninitialized = Storage.forTesting(null);
    var notified = false;
    uninitialized.addListener<String>('save', (_, __, ___) => notified = true);
    expect(uninitialized.setStringWithResult('save', 'new'), isFalse);
    expect(notified, isFalse);
  });

  test('empty string remains a valid stored value', () {
    expect(storage.setStringWithResult('save', ''), isTrue);
    expect(storage.getData<String>('save'), '');
    expect(changes, [('save', 'old', '')]);
  });

  test('same value still uses MMKV result instead of read-back equality', () {
    backend.succeeds = false;
    expect(storage.setStringWithResult('save', 'old'), isFalse);
    expect(backend.writes, 1);
    expect(changes, isEmpty);
  });

  test('legacy setData behavior is unchanged', () {
    storage.setData('save', 'legacy');
    expect(storage.getData<String>('save'), 'legacy');
    expect(changes, [('save', 'old', 'legacy')]);
  });
}

class _MemoryMMKV extends Fake implements MMKV {
  final values = <String, String>{};
  int writes = 0;
  bool succeeds = true;
  bool throwsOnWrite = false;

  @override
  bool containsKey(String key) => values.containsKey(key);

  @override
  String? decodeString(String key) => values[key];

  @override
  bool encodeString(String key, String? value, [int? expireDurationInSecond]) {
    writes++;
    if (throwsOnWrite) throw StateError('write failed');
    if (!succeeds) return false;
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
    return true;
  }
}
