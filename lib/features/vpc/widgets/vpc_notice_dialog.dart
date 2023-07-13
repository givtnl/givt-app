import 'package:flutter/material.dart';
import 'package:givt_app/features/vpc/data/vpc_notice.dart';

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
        color: const Color(0xFF184869),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                VPCNotice.noticeText,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Positioned(
            top: 5,
            right: 10,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
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
