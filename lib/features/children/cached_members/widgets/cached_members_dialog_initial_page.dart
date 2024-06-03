import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/cached_members/cubit/cached_members_cubit.dart';
import 'package:givt_app/features/children/shared/presentation/widgets/no_funds_initial_dialog.dart';

class CachedMembersDialogInitialPage extends StatelessWidget {
  const CachedMembersDialogInitialPage({super.key,});

  @override
  Widget build(BuildContext context) {
    return NoFundsInitialDialog(
      onClickContinue: () {
        context.read<CachedMembersCubit>().overviewCached();
      },
    );
  }
}
