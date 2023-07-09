import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/overview/models/givt_group.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:intl/intl.dart';

class GivtListItem extends StatelessWidget {
  const GivtListItem({
    required this.givtGroup,
    required this.onDismiss,
    required this.confirmDismiss,
    super.key,
  });

  final GivtGroup givtGroup;
  final void Function(DismissDirection)? onDismiss;
  final Future<bool> Function(DismissDirection)? confirmDismiss;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final country = context.read<AuthCubit>().state.user.country;
    final currency = NumberFormat.simpleCurrency(
      name: country == Country.us.countryCode
          ? 'USD'
          : Country.unitedKingdomCodes().contains(country)
              ? 'GBP'
              : 'EUR',
    );
    return Dismissible(
      key: Key(givtGroup.timeStamp.toString()),
      direction: DismissDirection.endToStart,
      background: const ColoredBox(
        color: AppTheme.givtRed,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
      confirmDismiss: confirmDismiss,
      onDismissed: onDismiss,
      child: Container(
        height: size.height * 0.11,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: _getStatusColor(givtGroup.status),
              width: 10,
            ),
          ),
        ),
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
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
                        DateFormat('dd').format(givtGroup.timeStamp!),
                        style: const TextStyle(
                          color: AppTheme.givtBlue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  DateFormat('hh:mm').format(givtGroup.timeStamp!),
                  style: const TextStyle(
                    color: AppTheme.givtBlue,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Visibility(
                      visible: givtGroup.isGiftAidEnabled,
                      child: Image.asset(
                        'assets/images/gift_aid_yellow.png',
                        height: 20,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      givtGroup.organisationName,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                ...givtGroup.givts.map(
                  (collection) => ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: size.width * 0.75,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${context.l10n.collect} ${collection.collectId}',
                          textAlign: TextAlign.start,
                        ),
                        Expanded(child: Container()),
                        Text(
                          '${currency.currencySymbol} ${collection.amount.toStringAsFixed(2)}',
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 3:
        return AppTheme.givtLightGreen;
      case 4:
        return AppTheme.givtRed;
      case 5:
        return AppTheme.givtLightGray;
    }
    return AppTheme.givtPurple;
  }
}
