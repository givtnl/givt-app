import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/history/models/income.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/string_datetime_extension.dart';

class IncomeItemUIModel {
  const IncomeItemUIModel(this.context, {required this.income});

  final Income income;
  final BuildContext context;

  String get leadingSVGAsset => 'assets/images/donation_states_added.svg';
  double get amount => income.amount;
  Color get amountColor => const Color(0xFF06509B);
  bool get amountShowPlus => true;
  String get title => 'Awesome! Your parents added more to your Wallet.';
  String get dateText => income.date.formatDate(context.l10n);
  Color get backgroundColor => FamilyAppTheme.historyAllowanceColor;
}
