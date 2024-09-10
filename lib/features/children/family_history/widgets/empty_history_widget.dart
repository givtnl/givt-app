import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/l10n/l10n.dart';

class EmptyHistoryWidget extends StatelessWidget {
  const EmptyHistoryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        Center(
          child: SvgPicture.asset(
            'assets/images/empty_lines.svg',
            width: size.width * 0.95,
          ),
        ),
        Center(
          child: Text(
            context.l10n.emptyChildrenDonations,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w400,
                ),
          ),
        ),
      ],
    );
  }
}
