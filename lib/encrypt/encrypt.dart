import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

class Encrypt {
  Encrypt._();

  static Uint8List encryptAesCbc(
      String plaintext, Uint8List key, Uint8List iv) {
    final params = PaddedBlockCipherParameters(
        ParametersWithIV<KeyParameter>(KeyParameter(key), iv), null);
    final blockCipher = PaddedBlockCipher('AES/CBC/PKCS7')..init(true, params);
    return blockCipher.process(Uint8List.fromList(utf8.encode(plaintext)));
  }

  static String decryptAesCbc(
      Uint8List ciphertext, Uint8List key, Uint8List iv) {
    final params = PaddedBlockCipherParameters(
        ParametersWithIV<KeyParameter>(KeyParameter(key), iv), null);
    final blockCipher = PaddedBlockCipher('AES/CBC/PKCS7')..init(false, params);
    return utf8.decode(blockCipher.process(ciphertext));
  }
  // Fixed IV
}
