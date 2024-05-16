import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/children/cached_members/cubit/cached_members_cubit.dart';
import 'package:givt_app/features/children/shared/presentation/widgets/no_funds_error_dialog.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class CachedMembersDialogErrorPage extends StatelessWidget {
  const CachedMembersDialogErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NoFundsErrorDialog(
      onClickRetry: () {
        context.read<CachedMembersCubit>().overviewCached();
      },
    );
  }
}
