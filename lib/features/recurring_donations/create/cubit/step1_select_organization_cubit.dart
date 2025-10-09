import 'package:givt_app/features/recurring_donations/create/presentation/models/select_organization_ui_model.dart';
import 'package:givt_app/features/recurring_donations/create/repository/recurring_donation_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/models/user_ext.dart';

enum SelectOrganizationAction {
  navigateToAmount,
}

class Step1SelectOrganizationCubit
    extends CommonCubit<SelectOrganisationUIModel, SelectOrganizationAction> {
  Step1SelectOrganizationCubit(this._repository)
      : super(const BaseState.loading());

  final RecurringDonationRepository _repository;

  Future<void> init(UserExt user, [CollectGroup? collectGroup]) async {
    emitLoading();
    try {
      _repository.init(user.guid, user.country, collectGroup);

      // If this flow is triggered from an organization, we don't need to fetch the organizations
      if (collectGroup != null) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => emitCustom(SelectOrganizationAction.navigateToAmount),
        );
        return;
      }

      final organizations = await _repository.fetchOrganizations();
      _emitData(organizations: organizations);
    } catch (e) {
      emitError(e.toString());
    }
  }

  void selectOrganization(CollectGroup organization) {
    _repository.selectedOrganization = organization;
    emitCustom(SelectOrganizationAction.navigateToAmount);
    _emitData(selectedOrganization: organization);
  }

  void _emitData(
      {List<CollectGroup>? organizations, CollectGroup? selectedOrganization}) {
    SelectOrganisationUIModel? currentData;
    if (state
        is DataState<SelectOrganisationUIModel, SelectOrganizationAction>) {
      currentData = (state
              as DataState<SelectOrganisationUIModel, SelectOrganizationAction>)
          .data;
    }

    emitData(
      SelectOrganisationUIModel(
        organizations: organizations ?? currentData?.organizations ?? [],
        selectedOrganization:
            selectedOrganization ?? currentData?.selectedOrganization,
      ),
    );
  }
}
