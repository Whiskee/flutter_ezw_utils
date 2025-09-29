import 'dart:developer';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

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

  /// 将字节数据保存为文件
  ///
  /// - [bytes] 要写入的字节数据（List<int> 或 Uint8List 均可）
  /// - [fileName] 自定义文件名（包含扩展名）。为空时使用时间戳生成
  /// - [useTempDir] 为 true 时保存到临时目录；否则保存到应用文档目录
  Future<File> saveBytesToFile(
    List<int> bytes, {
    String? fileName,
    bool useTempDir = false,
  }) async {
    final Directory dir = useTempDir
        ? await getTemporaryDirectory()
        : await getApplicationDocumentsDirectory();

    final String safeName = (fileName == null || fileName.trim().isEmpty)
        ? 'ezw_${DateTime.now().millisecondsSinceEpoch}'
        : fileName.trim();

    final String filePath = '${dir.path}/$safeName';
    final File file = File(filePath);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    log('EzwUtil::SaveBytesToFile: $filePath (${bytes.length} bytes)');
    return file;
  }

  /// 将字节数据写入到指定完整路径
  ///
  /// - [fullPath] 目标文件完整路径，例如：/path/to/file.bin
  Future<File> saveBytesToPath(
    List<int> bytes, {
    required String fullPath,
  }) async {
    final File file = File(fullPath);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    log('EzwUtil::SaveBytesToPath: $fullPath (${bytes.length} bytes)');
    return file;
  }
}
