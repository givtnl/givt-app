import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/external_donations/overview/repositories/external_donations_overview_repository.dart';
import 'package:givt_app/features/external_donations/shared/external_donations_partition.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

part 'external_donations_overview_state.dart';

class ExternalDonationsOverviewCubit extends CommonCubit<
    ExternalDonationsOverviewUIModel, ExternalDonationsOverviewCustom> {
  ExternalDonationsOverviewCubit(
    this._repository,
  ) : super(const BaseState.loading());

  final ExternalDonationsOverviewRepository _repository;

  Future<void> init() async {
    await _loadDonations();
  }

  Future<void> refresh() async {
    await _loadDonations();
  }

  Future<void> _loadDonations() async {
    emitLoading();
    try {
      await _repository.loadDonations();
      if (isClosed) return;

      if (_repository.getError() != null) {
        emitError(null);
        return;
      }

      emitData(_createUIModel());
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to load external donations: $error',
        methodName: 'ExternalDonationsOverviewCubit._loadDonations',
      );
      if (isClosed) return;
      emitError(null);
    }
  }

  ExternalDonationsOverviewUIModel _createUIModel() {
    final donations = _repository.getDonations();
    return ExternalDonationsOverviewUIModel(
      currentDonations: ExternalDonationsPartition.current(donations),
      pastDonations: ExternalDonationsPartition.past(donations),
    );
  }
}
