import 'package:flutter/material.dart';

extension GlobalKeyEx on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    if (renderObject is RenderBox && renderObject.attached) {
      final topLeft = renderObject.localToGlobal(Offset.zero);
      return topLeft & renderObject.size;
    }
    return null;
  }
}
