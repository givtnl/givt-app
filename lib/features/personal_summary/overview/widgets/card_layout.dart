import 'package:flutter/material.dart';
import 'package:givt_app/utils/utils.dart';

class CardLayout extends StatelessWidget {
  const CardLayout({
    required this.title,
    required this.child,
    super.key,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final titleWidget = _buildTitle(context, title: title);

    return Card(
      elevation: 10,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget,
          child,
        ],
      ),
    );
  }

  Widget _buildTitle(
    BuildContext context, {
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.givtLightGreen,
        border: Border.all(color: Colors.transparent),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      width: double.maxFinite,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
