import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/family_home_screen.uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_avatar_bar_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/presentation/widgets/grateful_avatar_bar.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_top_app_bar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_large_text.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class FamilyHomeOverlay extends StatelessWidget {
  const FamilyHomeOverlay({
    required this.uiModel,
    required this.onDismiss,
    required this.onAvatarTapped,
    super.key,
  });

  final FamilyHomeScreenUIModel uiModel;
  final void Function() onDismiss;
  final void Function(int index) onAvatarTapped;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 4,
        sigmaY: 4,
      ),
      child: FunScaffold(
        backgroundColor: FamilyAppTheme.primary50.withOpacity(0.5),
        minimumPadding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
        appBar: const FunTopAppBar(
          title: null,
          color: Colors.transparent,
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onDismiss,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TitleLargeText(
                    'Who would like to give?',
                    textAlign: TextAlign.center,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.25),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GratefulAvatarBar(
                  circleSize: 58,
                  textColor: Colors.white,
                  uiModel: GratefulAvatarBarUIModel(
                    avatarUIModels: uiModel.avatars,
                  ),
                  onAvatarTapped: onAvatarTapped,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
