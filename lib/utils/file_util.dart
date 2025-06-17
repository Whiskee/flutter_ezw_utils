import 'dart:developer';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:file_picker/file_picker.dart';

class FileUtil {
  static final FileUtil to = FileUtil._();
  FileUtil._();

  /// 选择文件
  ///
  /// - param allowMultiple 是否多选
  Future<List<String>?> pickFiles({bool allowMultiple = false}) async {
    final result =
        await FilePicker.platform.pickFiles(allowMultiple: allowMultiple);
    if (result == null || result.files.isEmpty) {
      log("EzwUtil::PickFiles: No file selected");
      return null;
    }
    return result.files.map((e) => e.path!).toList();
  }

  /// 选择文件
  Future<File?> pickFile() async {
    //  1、选择OTA升级固件包
    final result = await pickFiles(allowMultiple: false);
    if (result == null) {
      log("EzwUtil::PickFile: No file selected");
      return null;
    }
    //  2、解压缩固件包
    return File(result.first);
  }
}
