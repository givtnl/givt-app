import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/personal_summary/overview/bloc/personal_summary_bloc.dart';
import 'package:givt_app/features/personal_summary/overview/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class MonthlyHistoryCard extends StatelessWidget {
  const MonthlyHistoryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.sizeOf(context);
    final auth = context.read<AuthCubit>().state;
    final currency = Util.getCurrencySymbol(
      countryCode: auth.user.country,
    );

    final userCountry = Country.fromCode(auth.user.country);

    return BlocBuilder<PersonalSummaryBloc, PersonalSummaryState>(
      builder: (context, state) {
        return CardLayout(
          title: Util.getMonthName(
            state.dateTime,
            Util.getLanguageTageFromLocale(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  locals.budgetSummaryGivt,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: state.monthlyGivts.isNotEmpty
                      ? [
                          ...state.monthlyGivts.take(2).map(
                                (e) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(e.key),
                                    Text(
                                      '$currency ${Util.formatNumberComma(
                                        e.amount,
                                        userCountry,
                                      )}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        ]
                      : [
                          Text(
                            locals.budgetSummaryNoGifts,
                            textAlign: TextAlign.center,
                          ),
                        ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    Text(
                      locals.budgetSummaryNotGivt,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (state.externalDonations.isNotEmpty)
                      ...state.externalDonations.take(2).map(
                            (externalDonation) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(externalDonation.description),
                                Text(
                                  '$currency ${Util.formatNumberComma(
                                    externalDonation.amount,
                                    userCountry,
                                  )}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 10),
                    if (state.externalDonations.isEmpty)
                      Text(
                        locals.budgetSummaryNoGiftsExternal,
                        textAlign: TextAlign.center,
                      ),
                    Row(
                      children: [
                        const Text('...'),
                        Expanded(
                          child: Container(),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: _buildAddExternalDonation(
                            onPressed: () => context.goNamed(
                              Pages.addExternalDonation.name,
                              extra: context.read<PersonalSummaryBloc>(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (state.monthlyGivts.length > 2 ||
                  state.externalDonations.length > 2)
                Align(
                  child: TextButton(
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (_) => _buildMonthlyHistoryDialog(
                        country: userCountry,
                        context: context,
                        size: size,
                        locals: locals,
                        state: state,
                        countryCharacter: currency,
                      ),
                    ),
                    child: Text(
                      locals.budgetSummaryShowAll,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddExternalDonation({
    required VoidCallback onPressed,
  }) =>
      TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(5),
          backgroundColor: AppTheme.givtLightGreen,
          shape: const CircleBorder(),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      );

  Widget _buildMonthlyHistoryDialog({
    required BuildContext context,
    required Size size,
    required AppLocalizations locals,
    required PersonalSummaryState state,
    required String countryCharacter,
    required Country country,
  }) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: size.height * 0.1,
          maxHeight: size.height * 0.5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.givtGraycece,
                border: Border.all(color: Colors.transparent),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              width: double.maxFinite,
              child: Text(
                Util.getMonthName(
                  state.dateTime,
                  Util.getLanguageTageFromLocale(context),
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locals.budgetSummaryGivt,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...state.monthlyGivts.map(
                      (e) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.key),
                          Text(
                            '$countryCharacter ${Util.formatNumberComma(
                              e.amount,
                              country,
                            )}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      locals.budgetSummaryNotGivt,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...state.externalDonations.map(
                      (e) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.description),
                          Text(
                            '$countryCharacter ${Util.formatNumberComma(
                              e.amount,
                              country,
                            )}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildManageExternalDonations(
              locals,
              onPressed: () {
                /// always pop the dialog before navigating
                context
                  ..pop()
                  ..goNamed(
                    Pages.addExternalDonation.name,
                    extra: context.read<PersonalSummaryBloc>(),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManageExternalDonations(
    AppLocalizations locals, {
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          backgroundColor: AppTheme.givtBlue,
        ),
        child: Text(
          locals.budgetExternalGiftsListAddEditButton,
        ),
      ),
    );
  }
}
