import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/external_donations/detail/cubit/external_donation_detail_cubit.dart';
import 'package:givt_app/features/external_donations/detail/models/external_donation_history_item.dart';
import 'package:givt_app/features/external_donations/detail/repositories/external_donation_detail_repository.dart';
import 'package:givt_app/features/external_donations/shared/external_donation_schedule.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation.dart';
import 'package:givt_app/shared/bloc/base_state.dart';

class _FakeExternalDonationDetailRepository
    with ExternalDonationDetailRepository {
  ExternalDonation? _donation;
  bool _stopResult = true;
  bool stopCalled = false;

  @override
  bool isLoading() => false;

  @override
  String? getError() => null;

  @override
  ExternalDonation? getDonation() => _donation;

  @override
  double getTotalDonated() => _donation?.amount ?? 0;

  @override
  GivingDuration? getGivingDuration() =>
      const GivingDuration(1, GivingDurationUnit.days);

  @override
  List<ExternalDonationHistoryItem> getHistory() => const [];

  void setDonation(ExternalDonation donation) {
    _donation = donation;
  }

  void setStopResult(bool value) {
    _stopResult = value;
  }

  @override
  Future<void> loadDetail(ExternalDonation donation) async {
    _donation = donation;
  }

  @override
  Future<bool> stopDonation(String externalDonationId) async {
    stopCalled = true;
    expect(externalDonationId, _donation?.id);
    return _stopResult;
  }
}

void main() {
  group('ExternalDonationDetailCubit', () {
    late _FakeExternalDonationDetailRepository repository;
    late ExternalDonationDetailCubit cubit;

    const donation = ExternalDonation(
      id: 'donation-1',
      amount: 25,
      description: 'Charity',
      frequencyString: 'Monthly',
      creationDate: '2024-01-01T00:00:00.000Z',
      taxDeductible: false,
      active: true,
    );

    setUp(() {
      repository = _FakeExternalDonationDetailRepository();
      cubit = ExternalDonationDetailCubit(repository);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('confirmStopRecording calls repository stop', () async {
      repository.setDonation(donation);
      await cubit.init(donation);

      await cubit.confirmStopRecording();

      expect(repository.stopCalled, isTrue);
      expect(
        cubit.state,
        isA<CustomState<ExternalDonationDetailUIModel, ExternalDonationDetailCustom>>(),
      );
      final custom =
          (cubit.state as CustomState<ExternalDonationDetailUIModel, ExternalDonationDetailCustom>).custom;
      expect(custom, const ExternalDonationDetailCustom.stopRecordingSucceeded());
    });

    test('confirmStopRecording restores data state when stop returns false', () async {
      repository
        ..setDonation(donation)
        ..setStopResult(false);
      await cubit.init(donation);

      await cubit.confirmStopRecording();

      expect(repository.stopCalled, isTrue);
      expect(cubit.state, isA<DataState<ExternalDonationDetailUIModel, ExternalDonationDetailCustom>>());
    });
  });
}
