import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_secondary_button.dart';

class GivtBottomSheet extends StatelessWidget {
  const GivtBottomSheet({
    required this.title,
    required this.icon,
    required this.content,
    this.headlineContent,
    this.primaryButton,
    this.secondaryButton,
    this.closeAction,
    super.key,
  });

  final String title;
  final Widget icon;
  final Widget content;
  final Widget? headlineContent;

  final GivtElevatedButton? primaryButton;
  final GivtElevatedSecondaryButton? secondaryButton;

  final VoidCallback? closeAction;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImpactGroupsCubit, ImpactGroupsState>(
      builder: (context, state) {
        return Stack(
          children: [            
            SafeArea(
              minimum: const EdgeInsets.fromLTRB(24, 32, 24, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Icon
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: icon,
                  ),
                  const SizedBox(height: 24),

                  // Content
                  content,

                  // Extra text above buttons
                  showHeadlineContent(),

                  // Buttons
                  showPrimaryButton(),
                  showSecondaryButton(),
                ],
              ),
            ),

            showCloseButton(),
          ],
        );
      },
    );
  }

  Widget showCloseButton() {
    if (closeAction == null) return const SizedBox.shrink();

    return Positioned(
      top: 12,
      right: 12,
      child: IconButton(
        icon: const FaIcon(FontAwesomeIcons.xmark),
        onPressed: closeAction,
      ),
    );
  }

  Widget showHeadlineContent() {
    if (headlineContent == null) return const SizedBox(height: 24);

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: headlineContent,
    );
  }

  Widget showPrimaryButton() {
    if (primaryButton == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: primaryButton,
    );
  }

  Widget showSecondaryButton() {
    if (secondaryButton == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: secondaryButton,
    );
  }
}
