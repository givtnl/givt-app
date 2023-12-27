import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/vpc/cubit/vpc_cubit.dart';
import 'package:givt_app/features/children/vpc/widgets/vpc_notice_dialog.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/app_theme.dart';

class VPCSinglePage extends StatelessWidget {
  const VPCSinglePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'One last thing\n',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
              children: [
                TextSpan(
                  text: 'To ensure it\'s really you, we\'ll collect\n',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                ),
                TextSpan(
                  text: '\$0.50',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                ),
                TextSpan(
                  text:
                      ' from your card.\n\nThis gives us the green light to securely\n collect your child\'s information.',
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
                    builder: (context) => const VPCNoticeDialog(),
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
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 16,
                            )),
                    const Spacer()
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: ElevatedButton(
                  onPressed: () {
                    //TODO Implement new amplitute event

                    // AnalyticsHelper.logEvent(
                    //     eventName: AmplitudeEvents.enterCardDetailsClicked);

                    // TODO: IMPLEMENT NEW LOGIC

                    context.read<VPCCubit>().temporarySuccess();
                  },
                  child: Text(
                    'Done',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
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
    );
  }
}
