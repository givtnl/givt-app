import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/utils/email_typo_helper.dart';

void main() {
  group('EmailTypoHelper.suggestEmail', () {
    test('fixes doubled, trailing, and local-part dots on known domains', () {
      expect(
        EmailTypoHelper.suggestEmail('example@gmail..com'),
        'example@gmail.com',
      );
      expect(
        EmailTypoHelper.suggestEmail('example@gmail.com.'),
        'example@gmail.com',
      );
      expect(
        EmailTypoHelper.suggestEmail('example.@gmail.com'),
        'example@gmail.com',
      );
    });

    test('suggests close spelling typos while typing', () {
      expect(
        EmailTypoHelper.suggestEmail('example@gmial.com'),
        'example@gmail.com',
      );
      expect(
        EmailTypoHelper.suggestEmail('example@gmaill.com'),
        'example@gmail.com',
      );
      expect(
        EmailTypoHelper.suggestEmail('example@gnail.com'),
        'example@gmail.com',
      );
      expect(
        EmailTypoHelper.suggestEmail('example@hotmial.com'),
        'example@hotmail.com',
      );
      expect(
        EmailTypoHelper.suggestEmail('example@yaho.com'),
        'example@yahoo.com',
      );
    });

    test('keeps unfinished prefixes quiet until blur', () {
      expect(
        EmailTypoHelper.suggestEmail(
          'example@gmail.co',
        ),
        isNull,
      );
      expect(
        EmailTypoHelper.suggestEmail(
          'example@gmail.co',
          allowPrefixMatches: true,
        ),
        'example@gmail.com',
      );
    });

    test('returns null for an exact known domain and a custom domain', () {
      expect(EmailTypoHelper.suggestEmail('user@gmail.com'), isNull);
      expect(EmailTypoHelper.suggestEmail('user@mycompany.org'), isNull);
    });

    test(
      'uses the market list for the country and not for other countries',
      () {
        expect(
          EmailTypoHelper.suggestEmail('example@zigo.nl', countryCode: 'NL'),
          'example@ziggo.nl',
        );
        expect(
          EmailTypoHelper.suggestEmail('example@zigo.nl', countryCode: 'US'),
          isNull,
        );
        expect(
          EmailTypoHelper.suggestEmail(
            'example@btinternet.co',
            countryCode: 'GB',
          ),
          isNull,
        );
        expect(
          EmailTypoHelper.suggestEmail(
            'example@btinternet.co',
            countryCode: 'GB',
            allowPrefixMatches: true,
          ),
          'example@btinternet.com',
        );
      },
    );

    test('returns null when two domains are equally close', () {
      expect(
        EmailTypoHelper.suggestEmail('example@gmx.ne', countryCode: 'DE'),
        isNull,
      );
    });
  });
}
