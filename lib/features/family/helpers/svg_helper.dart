import 'package:flutter/services.dart';
import 'package:givt_app/features/family/helpers/color_helper.dart';

Future<String> loadSvgFromAsset(
  String svgAssetPath, {
  required Color color,
  bool useSecondLongestPath = false,
}) async {
  // Read SVG content from asset file
  String rawSvgContent = await rootBundle.loadString(svgAssetPath);

  // Modify SVG content
  String modifiedSvgContent = modifySvgContent(
    rawSvgContent,
    color: color,
    useSecondLongestPath: useSecondLongestPath,
  );

  return modifiedSvgContent;
}

String modifySvgContent(
  String rawSvgContent, {
  required Color color,
  bool useSecondLongestPath = false,
}) {
  // Parse the SVG content to find paths
  final pathRegex = RegExp(r'<path[^>]*>', multiLine: true);
  final paths = pathRegex.allMatches(rawSvgContent);

  String? longestPath;
  String? secondLongestPath;
  int maxLength = 0;
  int secondMaxLength = 0;
  String? longestFillColor;
  String? secondLongestFillColor;

  for (final match in paths) {
    final path = match.group(0);
    if (path != null) {
      // Check the length of the 'd' attribute
      final dAttributeRegex = RegExp(r'd="([^"]+)"');
      final dMatch = dAttributeRegex.firstMatch(path);
      if (dMatch != null) {
        final dValue = dMatch.group(1);
        if (dValue != null) {
          if (dValue.length > maxLength) {
            // Update second longest path before updating the longest path
            secondLongestPath = longestPath;
            secondMaxLength = maxLength;

            // Update longest path
            maxLength = dValue.length;
            longestPath = path;

            // Extract the fill color of the longest path
            final fillRegex = RegExp(r'fill="([^"]+)"');
            final fillMatch = fillRegex.firstMatch(path);
            longestFillColor = fillMatch?.group(1);
          } else if (dValue.length > secondMaxLength) {
            // Update second longest path
            secondMaxLength = dValue.length;
            secondLongestPath = path;
            // Extract the fill color of the second longest path
            final fillRegex = RegExp(r'fill="([^"]+)"');
            final fillMatch = fillRegex.firstMatch(path);
            if (fillMatch != null) {
              secondLongestFillColor = fillMatch.group(1);
            }
          }
        }
      }
    }
  }

  if (longestPath != null && longestFillColor != null) {
    // Replace the fill color of the longest path
    final newFillColor = colorToHex(color);
    if (useSecondLongestPath) {
      if (secondLongestPath != null && secondLongestFillColor != null) {
        rawSvgContent = rawSvgContent.replaceAll(
          'fill="$longestFillColor"',
          'fill="$newFillColor"',
        );
      }
    } else {
      rawSvgContent = rawSvgContent.replaceAll(
        'fill="$longestFillColor"',
        'fill="$newFillColor"',
      );
    }
  }

  return rawSvgContent;
}
