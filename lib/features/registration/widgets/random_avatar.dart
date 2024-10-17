import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/family/features/avatars/cubit/avatars_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';

class RandomAvatar extends StatefulWidget {
  const RandomAvatar({
    required this.id,
    required this.onClick,
    super.key,
  });
  final String id;
  final void Function() onClick;
  @override
  State<RandomAvatar> createState() => _RandomAvatarState();
}

class _RandomAvatarState extends State<RandomAvatar> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getIt<AvatarsCubit>().assignRandomAvatarUrl(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<AvatarsCubit, AvatarsState>(
      bloc: getIt<AvatarsCubit>(),
      builder: (context, state) {
        if (state.status != AvatarsStatus.loaded) {
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
                child: SvgPicture.network(
                  getIt<AvatarsCubit>().getAvatarByKey(widget.id).pictureURL,
                  width: size.width * 0.25,
                  height: size.width * 0.25,
                ),
              ),
              const Positioned(
                  top: 0,
                  right: 0,
                  child: FaIcon(FontAwesomeIcons.pen, size: 20)),
            ],
          ),
        );
      },
    );
  }
}
