import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/children/edit_profile/cubit/edit_profile_cubit.dart';

class AvatarItem extends StatelessWidget {
  const AvatarItem({
    required this.url,
    required this.filename,
    required this.isSelected,
    super.key,
  });

  final String url;
  final String filename;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: () {
          context.read<EditProfileCubit>().selectProfilePicture(filename);
        },
        customBorder: const CircleBorder(),
        splashColor: Theme.of(context).primaryColor,
        child: Stack(
          children: [
            SvgPicture.network(url),
            if (isSelected)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 6,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
