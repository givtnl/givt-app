import 'dart:io';

import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/utils/media_picker_service.dart';

class ChatStoredPictureWidget extends StatefulWidget {
  const ChatStoredPictureWidget(
      {required this.width,
      required this.height,
      required this.path,
      super.key,});
  final double width;
  final double height;
  final String path;

  @override
  State<ChatStoredPictureWidget> createState() =>
      _ChatStoredPictureWidgetState();
}

class _ChatStoredPictureWidgetState extends State<ChatStoredPictureWidget> {
  late final MediaPickerService service;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    service = getIt<MediaPickerService>();
    _initializeImagePath();
  }

  Future<void> _initializeImagePath() async {
    final rootPath = await service.getRootPath();
    final savedPath = '$rootPath/${widget.path}';
    setState(() {
      imagePath = savedPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      // margin: EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        image: imagePath != null
            ? DecorationImage(
                image: FileImage(File(imagePath!)),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imagePath == null
          ? const Center(child: CircularProgressIndicator())
          : null,
    );
  }
}
