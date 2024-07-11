import 'dart:async';

import 'package:givt_app/core/logging/logging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class MediaPickerService {
  MediaPickerService(this._imagePicker);
  final ImagePicker _imagePicker;
  Future<String> getRootPath() async =>
      (await getApplicationDocumentsDirectory()).path;
  Future<XFile> takePhoto() async {
    try {
      final file = await _imagePicker.pickImage(source: ImageSource.camera);
      if (file == null) {
        throw Exception('No image taken');
      }
      return file;
    } catch (error) {
      Exception('Failed to take photo');
      unawaited(LoggingInfo.instance.error('Failed to take photo'));
      rethrow;
    }
  }

  Future<XFile> uploadPhoto() async {
    try {
      final file = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (file == null) {
        throw Exception('No file selected');
      }
      return file;
    } catch (error) {
      Exception('Failed to upload photo');
      unawaited(LoggingInfo.instance.error('Failed to upload photo'));
      rethrow;
    }
  }

  Future<String> savePhoto(XFile file) async {
    try {
      final rootPath = await getRootPath();
      final filename = basename(file.path);
      final path = '$rootPath/$filename';
      await file.saveTo(path);
      return path;
    } catch (error) {
      Exception('Failed to save day 5 photo locally');
      unawaited(
        LoggingInfo.instance.error(
          'Failed to save day 5 photo locally',
        ),
      );
      rethrow;
    }
  }
}
