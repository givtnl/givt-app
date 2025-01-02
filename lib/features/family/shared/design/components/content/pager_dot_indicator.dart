import 'package:flutter/widgets.dart';
import 'package:givt_app/features/family/shared/design/components/content/pager_dot.dart';

class PagerDotIndicator extends StatelessWidget {
  const PagerDotIndicator(
      {required this.count, required this.index, super.key});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        return PagerDot(isSelected: i == index);
      }),
    );
  }
}
