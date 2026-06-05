import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/external_donations/overview/cubit/external_donations_overview_cubit.dart';
import 'package:givt_app/features/external_donations/overview/repositories/external_donations_overview_repository.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation.dart';
import 'package:givt_app/shared/bloc/base_state.dart';

class _FakeExternalDonationsOverviewRepository
    with ExternalDonationsOverviewRepository {
  List<ExternalDonation> _donations = const [];
  bool _isLoading = false;
  String? _error;

  @override
  bool isLoading() => _isLoading;

  @override
  String? getError() => _error;

  @override
  List<ExternalDonation> getDonations() => _donations;

  @override
  Future<void> loadDonations() async {
    _isLoading = true;
    _isLoading = false;
  }

  void setDonations(List<ExternalDonation> donations) {
    _donations = donations;
  }

  void setError(String error) {
    _error = error;
  }
}

void main() {
  group('ExternalDonationsOverviewCubit', () {
    late _FakeExternalDonationsOverviewRepository repository;
    late ExternalDonationsOverviewCubit cubit;

    setUp(() {
      repository = _FakeExternalDonationsOverviewRepository();
      cubit = ExternalDonationsOverviewCubit(repository);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('emits partitioned donations on init', () async {
      repository.setDonations(const [
        ExternalDonation(
          id: '1',
          amount: 10,
          description: 'Monthly charity',
          frequencyString: 'Monthly',
          creationDate: '2024-01-01T00:00:00.000Z',
          taxDeductible: false,
          active: true,
        ),
        ExternalDonation(
          id: '2',
          amount: 25,
          description: 'One-off charity',
          frequencyString: 'Once',
          creationDate: '2024-02-01T00:00:00.000Z',
          taxDeductible: false,
          active: true,
        ),
      ]);

      await cubit.init();

      final state = cubit.state;
      expect(state, isA<DataState<ExternalDonationsOverviewUIModel, ExternalDonationsOverviewCustom>>());

      final uiModel =
          (state as DataState<ExternalDonationsOverviewUIModel, ExternalDonationsOverviewCustom>).data;
      expect(uiModel.currentDonations, hasLength(1));
      expect(uiModel.pastDonations, hasLength(1));
      expect(uiModel.isEmpty, isFalse);
    });

    test('emits error when repository fails', () async {
      repository.setError('network failure');

      await cubit.init();

      expect(cubit.state, isA<ErrorState<ExternalDonationsOverviewUIModel, ExternalDonationsOverviewCustom>>());
    });
  });
}
