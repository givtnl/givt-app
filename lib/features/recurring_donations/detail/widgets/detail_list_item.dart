import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/recurring_donations/detail/models/recurring_donation_detail.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/util.dart';
import 'package:intl/intl.dart';

class DetailInstanceItem extends StatelessWidget {
  const DetailInstanceItem({
    required this.userCountry,
    required this.detail,
    super.key,
  });

  final Country userCountry;
  final RecurringDonationDetail detail;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height * 0.1,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(
            color: Util.getStatusColor(detail.status),
            width: 10,
          ),
        ),
      ),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      margin: const EdgeInsets.only(bottom: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width * 0.1,
                height: size.width * 0.1,
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                decoration: const BoxDecoration(
                  color: AppTheme.givtLightGray,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 5,
                        color: AppTheme.givtLightPurple,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      DateFormat('dd').format(detail.timestamp),
                      style: const TextStyle(
                        color: AppTheme.givtBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: detail.isGiftAidEnabled,
            child: Image.asset(
              'assets/images/gift_aid_yellow.png',
              height: 20,
            ),
          ),
          const SizedBox(width: 15),
          Text(
            Util.getMonthName(
              detail.timestamp.toIso8601String(),
              Util.getLanguageTageFromLocale(context),
            ),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          Text(
            '${NumberFormat.simpleCurrency(
              name: userCountry.currency,
            ).currencySymbol} '
            '${Util.formatNumberComma(
              double.parse(detail.amount.toString()),
              userCountry,
            )}',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
