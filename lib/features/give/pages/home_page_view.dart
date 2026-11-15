import 'package:flutter/material.dart';
import 'package:givt_app/features/give/widgets/offline_giving_banner.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';

/// Home tab body: offline queue banner and the For You giving hub.
class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        OfflineGivingBanner(),
        SizedBox(height: 8),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ForYou(),
          ),
        ),
      ],
    );
  }
}