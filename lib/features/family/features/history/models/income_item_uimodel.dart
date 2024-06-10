import 'dart:ui';

import 'package:givt_app/features/family/features/history/models/income.dart';
import 'package:givt_app/features/family/helpers/helpers.dart';
import 'package:givt_app/features/family/utils/utils.dart';

class IncomeItemUIModel {
  const IncomeItemUIModel({required this.income});

  final Income income;

  String get leadingSVGAsset => 'assets/images/donation_states_added.svg';
  double get amount => income.amount;
  Color get amountColor => const Color(0xFF06509B);
  bool get amountShowPlus => true;
  String get title => 'Awesome! Your parents added more to your Wallet.';
  String get dateText => income.date.formatDate();
  Color get backgroundColor => FamilyAppTheme.historyAllowanceColor;
}
