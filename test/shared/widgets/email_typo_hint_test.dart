import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/design_system/components/input/input_form_field.dart';
import 'package:givt_app/shared/widgets/email_typo_field.dart';
import 'package:givt_app/utils/util.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'applies a suggestion, dismisses it, and still allows submit',
    (tester) async {
      final controller = TextEditingController();
      final applied = <String>[];
      String? submitted;

      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  EmailTypoField(
                    controller: controller,
                    screen: 'welcome',
                    onApplied: applied.add,
                    fieldBuilder: (context, focusNode) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () => submitted = controller.text,
                    child: const Text('Continue'),
                  ),
                ],
              );
            },
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'test@gnail.com');
      await tester.pump();

      expect(find.textContaining('Did you mean'), findsOneWidget);
      expect(find.textContaining('test@gmail.com'), findsOneWidget);

      await tester.tap(find.byKey(const Key('email-typo-suggestion')));
      await tester.pump();

      expect(controller.text, 'test@gmail.com');
      expect(applied, ['test@gmail.com']);
      expect(find.textContaining('Did you mean'), findsNothing);

      await tester.enterText(find.byType(TextField), 'test@gmial.com');
      await tester.pump();
      expect(find.textContaining('Did you mean'), findsOneWidget);

      await tester.tap(find.text('Continue'));
      await tester.pump();
      expect(submitted, 'test@gmial.com');
      expect(find.textContaining('Did you mean'), findsOneWidget);

      await tester.tap(find.byKey(const Key('email-typo-dismiss')));
      await tester.pump();

      expect(controller.text, 'test@gmial.com');
      expect(find.textContaining('Did you mean'), findsNothing);
    },
  );

  testWidgets('shows an unfinished prefix only after blur', (tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      _wrap(
        EmailTypoField(
          controller: controller,
          screen: 'welcome',
          fieldBuilder: (context, focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
            );
          },
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'test@gmail.co');
    await tester.pump();
    expect(find.textContaining('Did you mean'), findsNothing);

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();

    expect(find.textContaining('test@gmail.com'), findsOneWidget);
  });

  testWidgets(
    'accepting a syntax fix updates form validation',
    (tester) async {
      final controller = TextEditingController();
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        _wrap(
          Form(
            key: formKey,
            child: EmailTypoField(
              controller: controller,
              screen: 'registration',
              fieldBuilder: (context, focusNode) {
                return InputFormField(
                  controller: controller,
                  focusNode: focusNode,
                  hintText: 'E-mail address',
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !Util.emailRegEx.hasMatch(value)) {
                      return 'Invalid e-mail address';
                    }
                    return null;
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'example@gmail..com');
      await tester.pump();
      expect(find.text('Invalid e-mail address'), findsOneWidget);
      expect(formKey.currentState!.validate(), isFalse);

      await tester.tap(find.byKey(const Key('email-typo-suggestion')));
      await tester.pump();

      expect(controller.text, 'example@gmail.com');
      expect(formKey.currentState!.validate(), isTrue);
      expect(find.text('Invalid e-mail address'), findsNothing);
    },
  );
}

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}
