import 'package:flutter/material.dart';
import 'package:givt_app/utils/utils.dart';

typedef OnMonthChanged = void Function(bool isLeft);

class MonthHeader extends StatelessWidget {
  const MonthHeader({
    required this.dateTime,
    required this.onLeftArrowPressed,
    required this.onRightArrowPressed,
    super.key,
  });

  final String dateTime;
  final OnMonthChanged onLeftArrowPressed;
  final OnMonthChanged onRightArrowPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildArrowButton(
            context,
            isLeft: true,
            onPressed: (isLeft) => onLeftArrowPressed(!isLeft),
          ),
          Text(
            Util.getMonthName(
              dateTime,
              Util.getLanguageTageFromLocale(context),
            ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (DateTime.parse(dateTime).month == DateTime.now().month)
            const SizedBox(width: 25)
          else
            _buildArrowButton(
              context,
              isLeft: false,
              onPressed: (isLeft) => onRightArrowPressed(!isLeft),
            ),
        ],
      ),
    );
  }

  Widget _buildArrowButton(
    BuildContext context, {
    required bool isLeft,
    required void Function(bool isLeft) onPressed,
  }) {
    return Container(
      height: 25,
      width: 25,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.transparent),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 5),
            blurRadius: 10,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: IconButton(
        onPressed: () => onPressed(isLeft),
        padding: EdgeInsets.zero,
        alignment: isLeft ? Alignment.centerRight : Alignment.center,
        icon: Icon(
          isLeft ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
          color: AppTheme.givtBlue,
          size: 17,
        ),
      ),
    );
  }
}
