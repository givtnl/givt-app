import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/pledges/overview/repositories/pledges_overview_repository.dart';
import 'package:givt_app/features/pledges/shared/models/pledge.dart';
import 'package:givt_app/features/pledges/shared/pledges_partition.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

part 'pledges_overview_state.dart';

class PledgesOverviewCubit
    extends CommonCubit<PledgesOverviewUIModel, PledgesOverviewCustom> {
  PledgesOverviewCubit(
    this._repository,
  ) : super(const BaseState.loading());

  final PledgesOverviewRepository _repository;

  Future<void> init() async {
    await _loadPledges();
  }

  Future<void> refresh() async {
    await _loadPledges();
  }

  Future<void> _loadPledges() async {
    emitLoading();
    try {
      await _repository.loadPledges();
      if (isClosed) return;

      if (_repository.getError() != null) {
        emitError(null);
        return;
      }

      emitData(_createUIModel());
    } catch (error) {
      LoggingInfo.instance.error(
        'Failed to load pledges: $error',
        methodName: 'PledgesOverviewCubit._loadPledges',
      );
      if (isClosed) return;
      emitError(null);
    }
  }

  PledgesOverviewUIModel _createUIModel() {
    return PledgesOverviewUIModel.fromPledges(_repository.getPledges());
  }
}
