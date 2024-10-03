import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/give_button.dart';
import 'package:givt_app/features/family/features/home_screen/widgets/gratitude_game_button.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_avatar_bar_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/grateful_avatar_bar.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class FamilyHomeScreen extends StatelessWidget {
  const FamilyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      minimumPadding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
      appBar: const FunTopAppBar(title: null),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  SvgPicture.asset(
                    'assets/family/images/home_screen/background.svg',
                    width: MediaQuery.of(context).size.width,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const TitleLargeText(
                      'Hey {Family Group Name}!',
                      textAlign: TextAlign.center,
                    ),
                    GratefulAvatarBar(
                      uiModel: GratefulAvatarBarUIModel(),
                      onAvatarTapped: (index) {},
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                GratitudeGameButton(
                  onPressed: () {},
                ),
                const SizedBox(height: 24),
                GiveButton(
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
