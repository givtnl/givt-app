import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:givt_app/features/family/helpers/color_helper.dart';

Future<String> loadSvgFromAsset(
  String svgAssetPath, {
  required Color color,
}) async {
  // Read SVG content from asset file
  String rawSvgContent = await rootBundle.loadString(svgAssetPath);

  // Modify SVG content
  String modifiedSvgContent = modifySvgContent(rawSvgContent, color: color);

  return modifiedSvgContent;
}

String modifySvgContent(String rawSvgContent, {required Color color}) {
  print("ORIGINAL: $rawSvgContent");

  // Parse the SVG content to find paths
  final pathRegex = RegExp(r'<path[^>]*>', multiLine: true);
  final paths = pathRegex.allMatches(rawSvgContent);

  String? longestPath;
  int maxLength = 0;
  String? currentFillColor;

  for (final match in paths) {
    final path = match.group(0);
    if (path != null) {
      // Check the length of the 'd' attribute
      final dAttributeRegex = RegExp(r'd="([^"]+)"');
      final dMatch = dAttributeRegex.firstMatch(path);
      if (dMatch != null) {
        final dValue = dMatch.group(1);
        if (dValue != null && dValue.length > maxLength) {
          maxLength = dValue.length;
          longestPath = path;

          // Extract the fill color of the longest path
          final fillRegex = RegExp(r'fill="([^"]+)"');
          final fillMatch = fillRegex.firstMatch(path);
          currentFillColor = fillMatch?.group(1);
        }
      }
    }
  }

  if (longestPath != null && currentFillColor != null) {
    // Replace the fill color of the longest path
    final newFillColor = colorToHex(color);
    rawSvgContent = rawSvgContent.replaceAll(
      'fill="$currentFillColor"',
      'fill="$newFillColor"',
    );
    print(
      "Longest path found and modified. New fill color: $newFillColor. Current fill color: $currentFillColor",
    );
  } else {
    print("No path found or no fill color detected.");
  }

  print("MODIFIED: $rawSvgContent");
  return rawSvgContent;
}
