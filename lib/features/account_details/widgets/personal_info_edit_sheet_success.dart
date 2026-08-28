import 'package:flutter/material.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';

/// Closes a personal-info edit bottom sheet after an in-sheet success state.
/// Reset and refresh are handled by [resetPersonalInfoEditSheetOnDismiss] when
/// the modal future completes.
void completePersonalInfoEditSheet(BuildContext context) {
  Navigator.of(context).pop();
}

/// Clears stale [PersonalInfoEditBloc] state when a bottom sheet is dismissed
/// without using Done (e.g. barrier tap). The account settings page reuses one
/// bloc across sheets, so success must not leak into the next edit flow.
void resetPersonalInfoEditSheetOnDismiss(
  PersonalInfoEditBloc bloc,
  AuthCubit authCubit,
) {
  final status = bloc.state.status;
  final updatedUser = bloc.state.loggedInUserExt;
  bloc.add(const PersonalInfoEditStatusReset());
  if (status == PersonalInfoEditStatus.success ||
      status == PersonalInfoEditStatus.emailChangeSuccess ||
      status == PersonalInfoEditStatus.mandateAlreadySigned) {
    // Apply the just-saved user immediately. [refreshUser] is async and
    // previously left AuthCubit stale, so UK mandate sign could re-POST the
    // old sort code / account number.
    authCubit.updateLocalUser(updatedUser);
    authCubit.refreshUser();
  }
}
