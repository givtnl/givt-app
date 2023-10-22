import 'package:flutter/material.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:intl/intl.dart';

class MonthlyBarChart extends StatelessWidget {
  const MonthlyBarChart({
    required this.month,
    required this.amount,
    super.key,
  });

  final String month;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.MMM().format(DateTime.parse('$month-01'));
    final isCurrentMonth =
        DateTime.now().month.toString() == month.split('-')[1];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight * amount / 1000;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: height,
                width: 20,
                color: isCurrentMonth
                    ? AppTheme.givtPurple.withOpacity(0.2)
                    : AppTheme.givtPurple,
              ),
              const SizedBox(height: 5),
              Text(
                formattedDate,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }
}
