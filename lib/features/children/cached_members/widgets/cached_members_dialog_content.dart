import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/cached_members/cubit/cached_members_cubit.dart';
import 'package:givt_app/features/children/cached_members/widgets/cached_members_dialog_error_page.dart';
import 'package:givt_app/features/children/cached_members/widgets/cached_members_dialog_initial_page.dart';
import 'package:givt_app/features/children/cached_members/widgets/cached_members_dialog_retrying_page.dart';
import 'package:givt_app/features/children/cached_members/widgets/cached_members_dialog_success_page.dart';

class CachedMembersDialogContent extends StatelessWidget {
  const CachedMembersDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CachedMembersCubit, CachedMembersState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Stack(
          children: [
            SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: _createPage(state.status),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _createPage(CachedMembersStateStatus status) {
    switch (status) {
      case CachedMembersStateStatus.noFundsInitial:
        return const CachedMembersDialogInitialPage();
      case CachedMembersStateStatus.noFundsRetrying:
        return const CachedMembersDialogRetryingPage();
      case CachedMembersStateStatus.noFundsError:
        return const CachedMembersDialogErrorPage();
      case CachedMembersStateStatus.noFundsSuccess:
        return const CachedMembersDialogSuccessPage();
      // ignore: no_default_cases
      default:
        return Container();
    }
  }
}
