import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/personal_summary/overview/bloc/personal_summary_bloc.dart';
import 'package:givt_app/features/personal_summary/overview/dialogs/dialogs.dart';
import 'package:givt_app/features/personal_summary/overview/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/warning_dialog.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalSummary extends StatelessWidget {
  const PersonalSummary({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final user = context.watch<AuthCubit>().state.user;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isShown =
          getIt<SharedPreferences>().getBool(Util.testimonialsSummaryKey) ??
              false;
      if (!isShown) {
        _showFirstUseDialogs(context);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(locals.budgetMenuView),
      ),
      backgroundColor: AppTheme.givtLightGray,
      body: BlocListener<PersonalSummaryBloc, PersonalSummaryState>(
        listener: (context, state) {
          if (state.status == PersonalSummaryStatus.noInternet) {
            showDialog<void>(
              context: context,
              builder: (_) => WarningDialog(
                title: locals.noInternetConnectionTitle,
                content: locals.noInternet,
                onConfirm: () => context.pop(),
              ),
            );
          }
          if (state.status == PersonalSummaryStatus.error) {
            showDialog<void>(
              context: context,
              builder: (_) => WarningDialog(
                title: locals.saveFailed,
                content: locals.updatePersonalInfoError,
                onConfirm: () => context.pop(),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<PersonalSummaryBloc, PersonalSummaryState>(
            builder: (context, state) {
              if (state.status == PersonalSummaryStatus.loading ||
                  state.status == PersonalSummaryStatus.initial) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              return Column(
                children: [
                  MonthHeader(
                    dateTime: state.dateTime,
                    onLeftArrowPressed: (increase) =>
                        context.read<PersonalSummaryBloc>().add(
                              PersonalSummaryMonthChange(increase: increase),
                            ),
                    onRightArrowPressed: (decrease) =>
                        context.read<PersonalSummaryBloc>().add(
                              PersonalSummaryMonthChange(increase: decrease),
                            ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        NarrowCard(isLeft: true, userCountry: user.country),
                        Visibility(
                          visible: state.givingGoal.amount != 0,
                          child: const MonthlyGivingGoalProgress(),
                        ),
                        Visibility(
                          visible: state.givingGoal.amount == 0,
                          child: NarrowCard(
                            isLeft: false,
                            userCountry: user.country,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Hide inactive button
                  // _buildGiveNowButton(
                  //   locals: locals,
                  //   onTap: () {},
                  // ),
                  const MonthlyHistoryCard(),
                  const MonthlyPastTwelveMonthsCard(),
                  const AnnualSummaryCard(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGiveNowButton({
    required AppLocalizations locals,
    required VoidCallback onTap,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor: AppTheme.givtBlue,
          ),
          child: Text(
            locals.budgetSummaryGiveNow,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );

  void _showFirstUseDialogs(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<PersonalSummaryBloc>(),
        child: const FirstUseSummaryDialog(),
      ),
    );
  }
}
