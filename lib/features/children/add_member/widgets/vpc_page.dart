import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/add_member/widgets/notice_dialog.dart';
import 'package:givt_app/features/children/utils/cached_family_utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class VPCPage extends StatelessWidget {
  const VPCPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: context.l10n.oneLastThing,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                  children: [
                    TextSpan(
                      text: context.l10n.vpcToEnsureItsYou,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                    ),
                    TextSpan(
                      text: context.l10n.vpcCost,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                    ),
                    TextSpan(
                      text: context.l10n.vpcGreenLightChildInformation,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                'assets/images/vpc_secure.svg',
                height: size.height * 0.4,
              ),
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      AnalyticsHelper.logEvent(
                          eventName: AmplitudeEvents.directNoticeClicked);
                      showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: AppTheme.givtPurple,
                        showDragHandle: true,
                        useSafeArea: true,
                        builder: (context) => const NoticeDialog(),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Icon(Icons.info_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: 18),
                        ),
                        Text(context.l10n.seeDirectNoticeButtonText,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontSize: 16,
                                )),
                        const Spacer()
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 12),
                    child: ElevatedButton(
                      onPressed: () {
                        context.pop();
                        context.read<AddMemberCubit>().createMember();
                        if (!CachedFamilyUtils.isFamilyCacheExist()) {
                          AnalyticsHelper.logEvent(
                            eventName: AmplitudeEvents.vpcAccepted,
                          );
                        }
                      },
                      child: Text(
                        context.l10n.ready,
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Avenir',
                                  fontWeight: FontWeight.w900,
                                ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
