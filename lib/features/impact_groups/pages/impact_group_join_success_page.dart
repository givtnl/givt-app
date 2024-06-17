import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/pages.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/buttons/custom_green_elevated_button.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ImpactGroupJoinSuccessPage extends StatefulWidget {
  const ImpactGroupJoinSuccessPage({
    super.key,
  });

  @override
  State<ImpactGroupJoinSuccessPage> createState() =>
      _ImpactGroupJoinSuccessPageState();
}

class _ImpactGroupJoinSuccessPageState
    extends State<ImpactGroupJoinSuccessPage> {
  var _isGivt4KidsAppInstalled = true;

  @override
  void initState() {
    _initialise();
    super.initState();
  }

  Future<void> _initialise() async {
    final isAppInstalled = await Util.checkIfGivt4KidsAppInstalled();

    setState(() {
      _isGivt4KidsAppInstalled = isAppInstalled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: context.l10n.joinImpactGroupCongrats,
                  style: GoogleFonts.mulish(
                    textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                  children: [
                    TextSpan(
                      text: '${context.l10n.downloadKey} ',
                      style: GoogleFonts.mulish(
                        textStyle:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                      ),
                    ),
                    TextSpan(
                      text: '${context.l10n.g4kKey} ',
                      style: GoogleFonts.mulish(
                        textStyle:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                      ),
                    ),
                    TextSpan(
                      text: context.l10n.childrenCanExperienceTheJoyOfGiving,
                      style: GoogleFonts.mulish(
                        textStyle:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                'assets/images/vpc_success.svg',
                width: size.width * 0.8,
              ),
              if (_isGivt4KidsAppInstalled)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomGreenElevatedButton(
                    title: context.l10n.seeMyFamily,
                    onPressed: () {
                      unawaited(
                        AnalyticsHelper.logEvent(
                          eventName: AmplitudeEvents.seeMyFamilyClicked,
                        ),
                      );
                      context.pushReplacementNamed(
                        FamilyPages.childrenOverview.name,
                      );
                    },
                  ),
                )
              else
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        context.pushReplacementNamed(
                          FamilyPages.childrenOverview.name,
                        );
                        AnalyticsHelper.logEvent(
                          eventName: AmplitudeEvents.iWillDonloadG4KLater,
                        );
                      },
                      child: Text(
                        context.l10n.iWillDoThisLater,
                        style: GoogleFonts.mulish(
                          textStyle:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
