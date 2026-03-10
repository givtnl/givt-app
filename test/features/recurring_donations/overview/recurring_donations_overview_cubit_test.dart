import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/recurring_donations/overview/cubit/recurring_donations_overview_cubit.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/features/recurring_donations/overview/repositories/recurring_donations_overview_repository.dart';

class _FakeRecurringDonationsOverviewRepository
    with RecurringDonationsOverviewRepository {
  final _controller =
      StreamController<List<RecurringDonation>>.broadcast(sync: true);

  List<RecurringDonation> _donations = const [];
  bool _isLoading = false;
  String? _error;

  @override
  Stream<List<RecurringDonation>> onRecurringDonationsChanged() {
    return _controller.stream;
  }

  @override
  List<RecurringDonation> getRecurringDonations() {
    return _donations;
  }

  @override
  bool isLoading() {
    return _isLoading;
  }

  @override
  String? getError() {
    return _error;
  }

  @override
  Future<void> loadRecurringDonations({String status = 'active'}) async {
    _isLoading = true;
    _error = null;
    _controller.add(_donations);

    _isLoading = false;
    _controller.add(_donations);
  }

  void emitDonations(List<RecurringDonation> donations) {
    _donations = donations;
    _controller.add(_donations);
  }

  void emitError(String message) {
    _error = message;
    _controller.add(_donations);
  }

  void dispose() {
    _controller.close();
  }
}

void main() {
  group('RecurringDonationsOverviewCubit', () {
    late _FakeRecurringDonationsOverviewRepository repository;
    late RecurringDonationsOverviewCubit cubit;

    setUp(() {
      repository = _FakeRecurringDonationsOverviewRepository();
      cubit = RecurringDonationsOverviewCubit(repository);
    });

    tearDown(() async {
      await cubit.close();
      repository.dispose();
    });

    test(
      'does not emit new states after close when stream emits',
      () async {
        final emittedStates = <Object>[];

        final subscription = cubit.stream.listen(emittedStates.add);

        cubit.init();

        await Future<void>.delayed(Duration.zero);

        emittedStates.clear();

        await cubit.close();

        repository.emitDonations(const []);

        await Future<void>.delayed(Duration.zero);

        expect(emittedStates, isEmpty);

        await subscription.cancel();
      },
    );
  });
}

