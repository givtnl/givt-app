import 'package:flutter/material.dart';

extension GlobalKeyEx on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    if (renderObject?.attached ?? false) {
      final translation = renderObject?.getTransformTo(null).getTranslation();
      if (translation != null && renderObject?.paintBounds != null) {
        return renderObject!.paintBounds
            .shift(Offset(translation.x, translation.y));
      }
    }
    return null;
  }
}
