import 'package:flutter/material.dart';
import 'package:givt_app/features/vpc/data/vpc_notice.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class VPCNoticeDialog extends StatelessWidget {
  const VPCNoticeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(
        top: size.height * 0.07,
        left: 15,
        right: 15,
        bottom: 15,
      ),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.sliderIndicatorFilled,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                VPCNotice.noticeText,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
          Positioned(
            top: 5,
            right: 10,
            child: GestureDetector(
              onTap: context.pop,
              child: const Icon(
                Icons.close_rounded,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
