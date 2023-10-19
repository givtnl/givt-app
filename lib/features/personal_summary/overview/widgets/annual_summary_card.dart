import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/personal_summary/overview/bloc/personal_summary_bloc.dart';
import 'package:givt_app/features/personal_summary/overview/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/summary_item.dart';
import 'package:givt_app/utils/utils.dart';

class AnnualSummaryCard extends StatelessWidget {
  const AnnualSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final user = context.read<AuthCubit>().state.user;
    final currency = Util.getCurrencySymbol(countryCode: user.country);
    return CardLayout(
      title: locals.budgetSummaryYear,
      child: BlocBuilder<PersonalSummaryBloc, PersonalSummaryState>(
        builder: (context, state) {
          return SizedBox(
            height: 200,
            child: Container(),
          );
        },
      ),
    );
  }
}
