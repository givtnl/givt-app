import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/personal_summary/overview/bloc/personal_summary_bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

class NarrowCard extends StatelessWidget {
  const NarrowCard({
    required this.isLeft,
    required this.userCountry,
    super.key,
  });

  final bool isLeft;
  final String userCountry;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.sizeOf(context);
    final currency = Util.getCurrencySymbol(
      countryCode: userCountry,
    );

    final state = context.watch<PersonalSummaryBloc>().state;

    return Container(
      decoration: BoxDecoration(
        color: isLeft ? AppTheme.givtLightGreen : Colors.white,
        border: Border.all(color: Colors.transparent),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: SizedBox(
        height: 150,
        width: isLeft ? size.width * 0.32 : size.width * 0.4,
        child: isLeft
            ? Column(
                children: [
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$currency ${Util.formatNumberComma(state.totalSumPerMonth, Country.fromCode(userCountry))}',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      locals.budgetSummaryBalance,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    'assets/images/givy_money.png',
                    height: 60,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: locals.budgetSummarySetGoalBold,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppTheme.givtBlue,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppTheme.fontFamily,
                          ),
                        ),
                        TextSpan(
                          text: locals.budgetSummarySetGoal,
                          style: const TextStyle(
                            color: AppTheme.givtBlue,
                            fontFamily: AppTheme.fontFamily,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
