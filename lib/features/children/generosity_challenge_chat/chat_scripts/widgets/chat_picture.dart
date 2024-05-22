import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatPicture extends StatelessWidget {
  const ChatPicture({
    required this.width,
    required this.height,
    required this.path,
    required this.isAsset,
    super.key,
  });

  final double width;
  final double height;
  final String path;
  final bool isAsset;

  bool get isSvg {
    // the simpliest solution for now (w/o additional script params)
    final pathParts = path.split('.');
    return pathParts.isNotEmpty && pathParts.last.contains('svg');
  }

  Widget _createImage() {
    return isAsset
        ? Image.asset(path, width: width, height: height)
        : Image.network(
            path,
            width: width,
            height: height,
          );
  }

  Widget _createSvg() {
    return Container(
      width: width,
      height: height,
      color: Colors.white,
      // the simpliest solution for now
      padding: const EdgeInsets.all(20),
      child: isAsset
          ? SvgPicture.asset(path, width: width, height: height)
          : SvgPicture.network(
              path,
              width: width,
              height: height,
            ),
    );
  }

  @override
  Widget build(BuildContext context) => isSvg ? _createSvg() : _createImage();
}
