import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';

class CommonSuccessPage extends StatelessWidget {
  const CommonSuccessPage({
    required this.buttonText,
    this.title,
    this.text,
    this.appBarTitle = 'Success',
    this.onClickButton,
    this.image,
    super.key,
  });

  final String buttonText;
  final String? title;
  final String? text;
  final Widget? image;
  final String appBarTitle;

  final void Function()? onClickButton;

  @override
  Widget build(BuildContext context) {
    final theme = const FamilyAppTheme().toThemeData();
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: FunTopAppBar(
          title: appBarTitle,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      image ?? registeredCheckAvatar(),
                      if (title != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            title!,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 8),
                      if (text != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: BodyMediumText(
                            text!,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FunButton(
                    text: buttonText,
                    onTap: onClickButton ?? () => Navigator.of(context).pop(),
                    analyticsEvent: AnalyticsEvent(
                      AmplitudeEvents.readyClicked,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
