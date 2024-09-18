import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/grateful_avatar_bar_uimodel.dart';

class GratefulAvatarBar extends StatelessWidget {
  const GratefulAvatarBar({
    required this.uiModel,
    required this.onAvatarTapped,
    super.key,
  });

  final GratefulAvatarBarUIModel uiModel;
  final void Function(int index) onAvatarTapped;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
