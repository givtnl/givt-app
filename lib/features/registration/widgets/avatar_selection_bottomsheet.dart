import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/avatars/cubit/avatars_cubit.dart';
import 'package:givt_app/features/family/features/avatars/widgets/avatar_item.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_button.dart';
import 'package:givt_app/features/family/shared/design/components/overlays/fun_bottom_sheet.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:go_router/go_router.dart';

class AvatarSelectionBottomsheet extends StatelessWidget {
  const AvatarSelectionBottomsheet({required this.id, super.key});

  final String id;
  @override
  Widget build(BuildContext context) {
    final cubit = getIt<AvatarsCubit>();

    return FunBottomSheet(
      title: 'Select your avatar',
      content: Column(
        children: [
          const SizedBox(height: 24),
          SingleChildScrollView(
            child: BlocBuilder<AvatarsCubit, AvatarsState>(
              bloc: cubit,
              builder: (context, state) {
                if (state.status != AvatarsStatus.loaded) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: state.avatars.length,
                  itemBuilder: (context, index) {
                    return AvatarItem(
                      onSelectProfilePicture: (profilePicture) =>
                          cubit.selectAvatar(
                        id,
                        state.avatars[index],
                      ),
                      filename: state.avatars[index].fileName,
                      url: state.avatars[index].pictureURL,
                      isSelected:
                          state.avatars[index] == state.getAvatarByKey(id),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          FunButton(
            text: context.l10n.save,
            onTap: () => context.pop(),
            rightIcon: FontAwesomeIcons.arrowRight,
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.avatarSaved,
              parameters: {
                'filename': cubit.state.getAvatarByKey(id).fileName,
              },
            ),
          ),
        ],
      ),
      closeAction: () => context.pop(),
    );
  }

  static void show(BuildContext context, String id) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      builder: (context) => AvatarSelectionBottomsheet(id: id),
    );
  }
}
