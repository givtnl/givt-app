import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CommonHistoryItemWidget extends StatelessWidget {
  const CommonHistoryItemWidget({
    required this.leadingSvgAsset,
    required this.amount,
    required this.amountColor,
    this.amountShowPlus = false,
    required this.title,
    required this.dateText,
    this.trailingSvgAsset = '',
    this.trailingSvgAssetOpacity = 0.5,
    this.backgroundColor = Colors.transparent,
    super.key,
  });
  final String leadingSvgAsset;
  final double amount;
  final Color amountColor;
  final bool amountShowPlus;
  final String title;
  final String dateText;
  final String trailingSvgAsset;
  final double trailingSvgAssetOpacity;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: 10.0, horizontal: size.width * 0.05),
      color: backgroundColor,
      child: Row(
        children: [
          SvgPicture.asset(leadingSvgAsset),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                amountShowPlus
                    ? '+ \$${amount.toStringAsFixed(0)}'
                    : '\$${amount.toStringAsFixed(0)}',
                style: TextStyle(
                  color: amountColor,
                  fontFamily: 'Roboto',
                  fontSize: 16,
                ),
              ),
              SizedBox(
                width: trailingSvgAsset.isNotEmpty
                    ? size.width * 0.55
                    : size.width * 0.72,
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                    color: Color(0xFF191C1D),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                dateText,
                style: const TextStyle(
                  color: Color(0xFF404943),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Spacer(),
          trailingSvgAsset.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Opacity(
                    opacity: trailingSvgAssetOpacity,
                    child: SvgPicture.asset(trailingSvgAsset),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
