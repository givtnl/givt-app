import 'package:flutter/services.dart';
import 'package:givt_app/features/family/helpers/color_helper.dart';

Future<String> recolorPlaceholdersSvgFromAsset(
  String svgAssetPath, {
  required Color color,
}) async {
  // Read SVG content from asset file
  final rawSvgContent = await rootBundle.loadString(svgAssetPath);

  // Modify SVG content
  final modifiedSvgContent = replacePlaceholdersSvgContent(
    rawSvgContent,
    color,
  );

  return modifiedSvgContent;
}

String replacePlaceholdersSvgContent(String rawSvgContent, Color color) {
  // Replace the placeholder color with the new color
  final newFillColor = colorToHex(color);
  rawSvgContent = rawSvgContent.replaceAll(
    'fill="placeholder"',
    'fill="$newFillColor"',
  );

  return rawSvgContent;
}

Future<String> recolorSvgFromAsset(
  String svgAssetPath, {
  required Color color,
  bool useSecondLongestPath = false,
}) async {
  // Read SVG content from asset file
  final rawSvgContent = await rootBundle.loadString(svgAssetPath);

  // Modify SVG content
  final modifiedSvgContent = modifySvgContent(
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
  final pathRegex = RegExp('<path[^>]*>', multiLine: true);
  final paths = pathRegex.allMatches(rawSvgContent);

  String? longestPath;
  String? secondLongestPath;
  var maxLength = 0;
  var secondMaxLength = 0;
  String? longestFillColor;
  String? secondLongestFillColor;

  for (final match in paths) {
    final path = match.group(0);
    if (path != null) {
      // Check the length of the 'd' attribute
      final dAttributeRegex = RegExp('d="([^"]+)"');
      final dMatch = dAttributeRegex.firstMatch(path);
      if (dMatch != null) {
        final dValue = dMatch.group(1);
        if (dValue != null) {
          if (dValue.length > maxLength) {
            // Update second longest path before updating the longest path
            final previousPath = longestPath;

            // Update longest path
            maxLength = dValue.length;
            longestPath = path;

            // Extract the fill color of the longest path
            final fillRegex = RegExp('fill="([^"]+)"');
            final fillMatch = fillRegex.firstMatch(path);
            final secondFillMatch =
                fillRegex.firstMatch(secondLongestPath ?? '');
            longestFillColor = fillMatch?.group(1);
            final previousColor = secondFillMatch?.group(1);
            if (previousColor != longestFillColor) {
              secondLongestPath = previousPath;
              secondLongestFillColor = previousColor;
              secondMaxLength = previousPath?.length ?? 0;
            }
          } else if (dValue.length > secondMaxLength) {
            // Update second longest path
            secondMaxLength = dValue.length;
            secondLongestPath = path;

            // Extract the fill color of the second longest path
            final fillRegex = RegExp('fill="([^"]+)"');
            final fillMatch = fillRegex.firstMatch(path);
            secondLongestFillColor = fillMatch?.group(1);
          }
        }
      }
    }
  }

  if (longestPath != null && longestFillColor != null) {
    // Replace the fill color of the longest path
    final newFillColor = colorToHex(color);
    if (useSecondLongestPath) {
      if (secondLongestPath != null &&
          secondLongestFillColor != null &&
          secondLongestFillColor != longestFillColor) {
        rawSvgContent = rawSvgContent.replaceAll(
          'fill="$secondLongestFillColor"',
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
