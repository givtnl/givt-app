import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/donation_overview/models/donation_group.dart';
import 'package:givt_app/features/donation_overview/models/donation_history_mapper.dart';
import 'package:givt_app/features/donation_overview/widgets/donation_list_item.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/user_ext.dart';

class _FakeAuthRepository with AuthRepository {
  final _sessionController = StreamController<bool>.broadcast();

  @override
  Stream<bool> hasSessionStream() => _sessionController.stream;

  void dispose() {
    _sessionController.close();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('DonationListItem', () {
    late _FakeAuthRepository authRepository;
    late AuthCubit authCubit;

    setUp(() {
      authRepository = _FakeAuthRepository();
      authCubit = AuthCubit(authRepository);
      authCubit.emit(
        authCubit.state.copyWith(
          status: AuthStatus.authenticated,
          user: const UserExt(
            guid: 'guid',
            email: 'user@example.com',
            amountLimit: 499,
            country: 'NL',
          ),
        ),
      );
    });

    tearDown(() async {
      await authCubit.close();
      authRepository.dispose();
    });

    Widget buildSubject(DonationGroup group) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: Scaffold(
            body: DonationListItem(donationGroup: group),
          ),
        ),
      );
    }

    testWidgets('shows external subtitle and repeat icon for recurring rows', (
      tester,
    ) async {
      final donation = DonationHistoryMapper.fromHistoryJson({
        'source': 'external',
        'id': 'tx-1',
        'externalDonationId': 'series-1',
        'externalTransactionId': 'tx-1',
        'amount': 20,
        'timestamp': '2026-03-10T09:00:00',
        'organisationName': 'Food Bank',
        'frequency': 'Monthly',
        'isRecurring': true,
      });
      final group = DonationGroup(
        timeStamp: donation.timeStamp,
        organisationName: donation.organisationName,
        donations: [donation],
        amount: donation.amount,
        isExternal: true,
        isRecurringDonation: true,
      );

      await tester.pumpWidget(buildSubject(group));
      await tester.pumpAndSettle();

      expect(find.text('External donation'), findsOneWidget);
      expect(
        find.byIcon(FontAwesomeIcons.arrowsRotate.data),
        findsOneWidget,
      );
      expect(
        find.byIcon(FontAwesomeIcons.arrowUpRightFromSquare.data),
        findsOneWidget,
      );

      final subtitle = tester.widget<Text>(find.text('External donation'));
      expect(subtitle.style?.color, FamilyAppTheme.neutralVariant40);

      final amount = tester.widget<Text>(find.text('€20,00'));
      expect(amount.style?.color, FamilyAppTheme.primary50);

      final iconFinder = find.byIcon(
        FontAwesomeIcons.arrowUpRightFromSquare.data,
      );
      final circleFinder = find.ancestor(
        of: iconFinder,
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration! as BoxDecoration).shape == BoxShape.circle,
        ),
      );
      final circle = tester.widget<Container>(circleFinder);
      expect(
        (circle.decoration! as BoxDecoration).color,
        FamilyAppTheme.tertiary90,
      );
    });

    testWidgets('hides the title row when the organisation name is blank', (
      tester,
    ) async {
      final donation = DonationHistoryMapper.fromHistoryJson({
        'source': 'givtProcessed',
        'id': '1',
        'amount': 10,
        'timestamp': '2026-03-10T09:00:00',
        'organisationName': '',
        'status': 3,
        'collectId': 1,
      });
      final group = DonationGroup(
        timeStamp: donation.timeStamp,
        organisationName: donation.organisationName,
        donations: [donation],
        amount: donation.amount,
      );

      await tester.pumpWidget(buildSubject(group));
      await tester.pumpAndSettle();

      expect(find.text('Collection 1'), findsOneWidget);
    });

    testWidgets('shows givt organisation name for processed donations', (
      tester,
    ) async {
      final donation = DonationHistoryMapper.fromHistoryJson({
        'source': 'givtProcessed',
        'id': '1',
        'amount': 10,
        'timestamp': '2026-03-10T09:00:00',
        'organisationName': 'Hope Church',
        'status': 2,
        'collectId': 1,
      });
      final group = DonationGroup(
        timeStamp: donation.timeStamp,
        organisationName: donation.organisationName,
        donations: [donation],
        amount: donation.amount,
      );

      await tester.pumpWidget(buildSubject(group));
      await tester.pumpAndSettle();

      expect(find.text('Hope Church'), findsOneWidget);
      expect(find.text('External donation'), findsNothing);
      expect(
        find.byIcon(FontAwesomeIcons.arrowUpRightFromSquare.data),
        findsNothing,
      );
    });
  });
}
