import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation_detail.dart';
import 'package:givt_app/shared/widgets/donation_type_sheet.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/util.dart';
import 'package:intl/intl.dart';

class RecurringDonationsDetailPage extends StatelessWidget {
  RecurringDonationsDetailPage({required this.recurringDonation, super.key});
  final RecurringDonation recurringDonation;
  final RecurringDonationDetail detail = RecurringDonationDetail(
    timestamp: DateTime.now(),
    donationId: '62648',
    //count: 4,
  );
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = context.read<AuthCubit>().state.user;
    final userCountry = Country.fromCode(user.country);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          recurringDonation.collectGroup.orgName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          _buildAppBarItem(
              context: context,
              icon: const Icon(Icons.info_rounded),
              child: const DontaionTypeExplanationSheet())
        ],
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: AppTheme.givtGrayf3f3f3,
        child: Column(
          children: [
            instanceOfDonation(
              size: size,
              context: context,
              userCountry: userCountry,
            ),
            instanceOfDonation(
              size: size,
              context: context,
              userCountry: userCountry,
            ),
            instanceOfDonation(
              size: size,
              context: context,
              userCountry: userCountry,
            ),
          ],
        ),
      ),
    );
  }

  Widget instanceOfDonation({
    required Size size,
    required BuildContext context,
    required Country userCountry,
  }) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height * 0.1,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(
            color: Util.getStatusColor(3),
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
            visible: false,
            // givtGroup.isGiftAidEnabled,
            child: Image.asset(
              'assets/images/gift_aid_yellow.png',
              height: 20,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            Util.getMonthName(detail.timestamp.toIso8601String(),
                Util.getLanguageTageFromLocale(context)),
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
              double.parse(recurringDonation.amountPerTurn.toString()),
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

  Widget _buildAppBarItem({
    // required GivtState state,
    required BuildContext context,
    required Widget child,
    required Icon icon,
    Color? color,
  }) {
    return Visibility(
      visible: true,
      //state.givtGroups.isNotEmpty,
      child: IconButton(
        icon: icon,
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: color ?? AppTheme.givtBlue,
          builder: (context) =>
              Container(padding: const EdgeInsets.all(20), child: child),
        ),
      ),
    );
  }
}
