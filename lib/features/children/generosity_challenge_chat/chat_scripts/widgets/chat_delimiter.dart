import 'package:flutter/material.dart';
import 'package:givt_app/utils/utils.dart';

class ChatDelimiter extends StatelessWidget {
  const ChatDelimiter({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            width: double.maxFinite,
            height: 2,
            //TODO: replace with neutral90
            color: AppTheme.neutralVariant90,
          ),
          SizedBox(
            width: double.maxFinite,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 16,
                    fontFamily: 'Rouna',
                    fontWeight: FontWeight.w700,
                    //TODO: replace with neutral40
                    color: AppTheme.neutralVariant50,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
