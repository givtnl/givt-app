import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';

/// Closes a personal-info edit bottom sheet after an in-sheet success state.
void completePersonalInfoEditSheet(BuildContext context) {
  context.read<PersonalInfoEditBloc>().add(
        const PersonalInfoEditStatusReset(),
      );
  Navigator.of(context).pop();
  context.read<AuthCubit>().refreshUser();
}
