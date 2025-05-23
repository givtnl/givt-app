import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/avatars/cubit/avatars_cubit.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_avatar.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/l10n/l10n.dart';

class RandomAvatar extends StatefulWidget {
  const RandomAvatar({
    required this.id,
    required this.onClick,
    required this.profileType,
    super.key,
  });

  final String id;
  final void Function() onClick;
  
  /// 0 for child, 1 for parent
  final int profileType;

  @override
  State<RandomAvatar> createState() => _RandomAvatarState();
}

class _RandomAvatarState extends State<RandomAvatar> {
  late final AvatarsCubit _avatarsCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _avatarsCubit = getIt<AvatarsCubit>();
    _avatarsCubit.assignRandomAvatar(widget.id, widget.profileType);
  }

  @override
  void didUpdateWidget(covariant RandomAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profileType != widget.profileType) {
      _avatarsCubit.assignRandomAvatar(widget.id, widget.profileType);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<AvatarsCubit, AvatarsState>(
      bloc: _avatarsCubit,
      builder: (context, state) {
        if (state.status != AvatarsStatus.loaded) {
          if (state.status == AvatarsStatus.error) {
            return Center(
              child: Text(context.l10n.registrationRandomAvatarError),
            );
          }
          return const Center(
            child: CustomCircularProgressIndicator(),
          );
        }
        return InkWell(
          onTap: widget.onClick,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FunAvatar.hero(
                  _avatarsCubit.state.getAvatarByKey(widget.id).fileName,
                  size: size.width * 0.25,
                ),
              ),
              const Positioned(
                top: 0,
                right: 0,
                child: FaIcon(FontAwesomeIcons.pen, size: 20),
              ),
            ],
          ),
        );
      },
    );
  }
}
