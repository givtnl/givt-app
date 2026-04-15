import 'dart:convert';
import 'dart:typed_data';

const String lottieOrgLabelPlaceholder = '__ORG_LABEL__';

/// Replaces the placeholder label in a Lottie JSON string.
///
/// The Lottie asset is expected to contain the literal placeholder string
/// `__ORG_LABEL__` exactly once (as the text layer value).
Uint8List replaceLottiePlaceholder({
  required String lottieJson,
  required String replacement,
}) {
  final out = lottieJson.replaceAll(lottieOrgLabelPlaceholder, replacement);
  return Uint8List.fromList(utf8.encode(out));
}

