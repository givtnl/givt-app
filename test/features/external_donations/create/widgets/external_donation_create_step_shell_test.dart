import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_create_step_shell.dart';

const _bodyKey = Key('shell-body');
const _previewKey = Key('shell-preview');
const _bottomKey = Key('shell-bottom');

Widget _wrap(Widget child) {
  return MaterialApp(home: child);
}

ExternalDonationCreateStepShell _shell({
  required Widget body,
  Widget? preview,
  Widget? bottom,
}) {
  return ExternalDonationCreateStepShell(
    title: 'Test step',
    currentStep: 1,
    stepCount: 3,
    body: body,
    preview: preview,
    bottom: bottom,
  );
}

void main() {
  testWidgets('renders body, preview, and bottom with preview above bottom',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        _shell(
          body: const SizedBox(key: _bodyKey, height: 80, child: Text('Body')),
          preview: const SizedBox(
            key: _previewKey,
            height: 80,
            child: Text('Preview'),
          ),
          bottom: const SizedBox(
            key: _bottomKey,
            height: 54,
            child: Text('CTA'),
          ),
        ),
      ),
    );

    expect(find.byKey(_bodyKey), findsOneWidget);
    expect(find.byKey(_previewKey), findsOneWidget);
    expect(find.byKey(_bottomKey), findsOneWidget);

    final previewRect = tester.getRect(find.byKey(_previewKey));
    final bottomRect = tester.getRect(find.byKey(_bottomKey));
    expect(previewRect.bottom, lessThanOrEqualTo(bottomRect.top));
  });

  testWidgets('positions preview towards bottom when body is short', (tester) async {
    await tester.pumpWidget(
      _wrap(
        SizedBox(
          height: 800,
          child: _shell(
            body: const SizedBox(key: _bodyKey, height: 80, child: Text('Body')),
            preview: const SizedBox(
              key: _previewKey,
              height: 80,
              child: Text('Preview'),
            ),
            bottom: const SizedBox(
            key: _bottomKey,
            height: 54,
            child: Text('CTA'),
          ),
          ),
        ),
      ),
    );

    final bodyRect = tester.getRect(find.byKey(_bodyKey));
    final previewRect = tester.getRect(find.byKey(_previewKey));
    expect(previewRect.top - bodyRect.bottom, greaterThan(16));
  });

  testWidgets('keeps preview in scroll view when body overflows', (tester) async {
    await tester.pumpWidget(
      _wrap(
        SizedBox(
          height: 400,
          child: _shell(
            body: const SizedBox(
              key: _bodyKey,
              height: 600,
              child: Text('Body'),
            ),
            preview: const SizedBox(
              key: _previewKey,
              height: 80,
              child: Text('Preview'),
            ),
            bottom: const SizedBox(
              key: _bottomKey,
              height: 54,
              child: Text('CTA'),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byKey(_previewKey), findsOneWidget);
    expect(find.byKey(_bottomKey), findsOneWidget);

    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
    await tester.pumpAndSettle();

    final previewRect = tester.getRect(find.byKey(_previewKey));
    final bottomRect = tester.getRect(find.byKey(_bottomKey));
    expect(previewRect.bottom, lessThanOrEqualTo(bottomRect.top));
  });

  testWidgets('renders without preview when preview is null', (tester) async {
    await tester.pumpWidget(
      _wrap(
        _shell(
          body: const SizedBox(key: _bodyKey, height: 80, child: Text('Body')),
          bottom: const SizedBox(
            key: _bottomKey,
            height: 54,
            child: Text('CTA'),
          ),
        ),
      ),
    );

    expect(find.byKey(_bodyKey), findsOneWidget);
    expect(find.byKey(_previewKey), findsNothing);
    expect(find.byKey(_bottomKey), findsOneWidget);
  });
}
