import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/give/utils/lottie_text_localizer.dart';

void main() {
  test('replaceLottiePlaceholder replaces __ORG_LABEL__ placeholder', () {
    const input = '{"layers":[{"ty":5,"t":{"d":{"k":[{"s":{"t":"__ORG_LABEL__"}}]}}}]}';
    final outBytes = replaceLottiePlaceholder(
      lottieJson: input,
      replacement: 'Organisatie',
    );
    final out = utf8.decode(outBytes);

    expect(out, contains('Organisatie'));
    expect(out, isNot(contains(lottieOrgLabelPlaceholder)));
  });
}

