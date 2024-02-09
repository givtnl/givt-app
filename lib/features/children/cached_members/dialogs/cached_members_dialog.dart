import 'package:flutter/material.dart';
import 'package:givt_app/features/children/cached_members/widgets/cached_members_dialog_content.dart';

class CachedMembersDialog extends StatelessWidget {
  const CachedMembersDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Center(
      child: SizedBox.square(
        dimension: size.width * 0.8,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          color: Colors.white,
          elevation: 7,
          child: const CachedMembersDialogContent(),
        ),
      ),
    );
  }
}
