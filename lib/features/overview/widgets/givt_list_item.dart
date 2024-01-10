import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/overview/models/givt_group.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/util.dart';
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
    final size = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;
    final userCountry = context.read<AuthCubit>().state.user.country;
    final country = Country.fromCode(userCountry);
    final currency = NumberFormat.simpleCurrency(
      name: country.currency,
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
        height: givtGroup.givts.length == 3
            ? size.height * 0.16
            : size.height * 0.11,
        width: size.width,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Util.getStatusColor(givtGroup.status),
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
                  width: size.width * 0.1,
                  height: size.width * 0.1,
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
                        DateFormat('dd').format(givtGroup.timeStamp!.toLocal()),
                        style: textTheme.titleLarge!.copyWith(
                          color: AppTheme.givtBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  DateFormat('HH:mm').format(givtGroup.timeStamp!.toLocal()),
                  style: textTheme.bodySmall!.copyWith(
                    color: AppTheme.givtBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
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
                      Text(
                        givtGroup.organisationName,
                        style: textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ...givtGroup.givts.map(
                    (collection) => ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: size.width * 0.74,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${context.l10n.collect} ${collection.collectId}',
                            textAlign: TextAlign.start,
                          ),
                          Expanded(child: Container()),
                          Text(
                            '${currency.currencySymbol} ${Util.formatNumberComma(
                              collection.amount,
                              country,
                            )}',
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
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
