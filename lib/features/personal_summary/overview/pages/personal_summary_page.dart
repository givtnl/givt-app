import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/personal_summary/overview/bloc/personal_summary_bloc.dart';
import 'package:givt_app/features/personal_summary/overview/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/warning_dialog.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class PersonalSummary extends StatelessWidget {
  const PersonalSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final user = context.watch<AuthCubit>().state.user;
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
              if (state.status == PersonalSummaryStatus.loading) {
                return const Center(child: CircularProgressIndicator());
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
                        NarrowCard(isLeft: false, userCountry: user.country),
                      ],
                    ),
                  ),
                  // Hide inactive button
                  // _buildGiveNowButton(
                  //   locals: locals,
                  //   onTap: () {},
                  // ),
                  const MonthlyHistory(),
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

  // Widget _buildMonthlyHistory({
  //   required BuildContext context,
  //   required Size size,
  //   required AppLocalizations locals,
  //   required PersonalSummaryState state,
  //   required String countryCharacter,
  //   required Country userCountry,
  // }) {
  //   return Container(
  //     width: size.width * 0.9,
  //     margin: const EdgeInsets.symmetric(vertical: 10),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       border: Border.all(color: Colors.transparent),
  //       borderRadius: const BorderRadius.all(Radius.circular(10)),
  //       boxShadow: const [
  //         BoxShadow(
  //           color: AppTheme.givtGraycece,
  //           offset: Offset(0, 5),
  //           blurRadius: 10,
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(10),
  //           decoration: BoxDecoration(
  //             color: AppTheme.givtLightGreen,
  //             border: Border.all(color: Colors.transparent),
  //             borderRadius: const BorderRadius.only(
  //               topLeft: Radius.circular(10),
  //               topRight: Radius.circular(10),
  //             ),
  //           ),
  //           width: double.maxFinite,
  //           child: Text(
  //             Util.getMonthName(
  //               state.dateTime,
  //               Util.getLanguageTageFromLocale(context),
  //             ),
  //             textAlign: TextAlign.center,
  //             style: const TextStyle(
  //               color: Colors.white,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8),
  //           child: Text(
  //             locals.budgetSummaryGivt,
  //             style: const TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 10),
  //           child: Column(
  //             children: state.monthlyGivts.isNotEmpty
  //                 ? [
  //                     ...state.monthlyGivts.take(2).map(
  //                           (e) => Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Text(e.organisationName),
  //                               Text(
  //                                 '$countryCharacter ${Util.formatNumberComma(e.amount, userCountry)}',
  //                                 style: const TextStyle(
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                   ]
  //                 : [
  //                     Text(
  //                       locals.budgetSummaryNoGifts,
  //                       textAlign: TextAlign.center,
  //                     ),
  //                   ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 10),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Divider(),
  //               Text(
  //                 locals.budgetSummaryNotGivt,
  //                 style: const TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //               if (state.externalDonations.isNotEmpty)
  //                 ...state.externalDonations.take(2).map(
  //                       (externalDonation) => Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Text(externalDonation.description),
  //                           Text(
  //                             '$countryCharacter ${Util.formatNumberComma(externalDonation.amount, userCountry)}',
  //                             style: const TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //               const SizedBox(height: 10),
  //               if (state.externalDonations.isEmpty)
  //                 Text(
  //                   locals.budgetSummaryNoGiftsExternal,
  //                   textAlign: TextAlign.center,
  //                 ),
  //               Row(
  //                 children: [
  //                   const Text('...'),
  //                   Expanded(
  //                     child: Container(),
  //                   ),
  //                   Align(
  //                     alignment: Alignment.centerRight,
  //                     child: _buildAddExternalDonation(
  //                       onPressed: () => context.goNamed(
  //                         Pages.addExternalDonation.name,
  //                         extra: context.read<PersonalSummaryBloc>(),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //         if (state.monthlyGivts.length > 2 ||
  //             state.externalDonations.length > 2)
  //           Align(
  //             child: TextButton(
  //               onPressed: () => showDialog<String>(
  //                 context: context,
  //                 builder: (_) => _buildMonthlyHistoryDialog(
  //                   country: userCountry,
  //                   context: context,
  //                   size: size,
  //                   locals: locals,
  //                   state: state,
  //                   countryCharacter: countryCharacter,
  //                 ),
  //               ),
  //               child: Text(
  //                 locals.budgetSummaryShowAll,
  //                 style: const TextStyle(
  //                   decoration: TextDecoration.underline,
  //                 ),
  //               ),
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }
}
