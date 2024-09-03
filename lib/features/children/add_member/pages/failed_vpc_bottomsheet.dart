import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/cached_members/cubit/cached_members_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/layout/givt_bottom_sheet.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_secondary_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/stripe_helper.dart';

class VPCFailedCachedMembersBottomsheet extends StatelessWidget {
  VPCFailedCachedMembersBottomsheet({required this.members, super.key});
  final List<Member> members;
  final cacheCubit = getIt<CachedMembersCubit>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              StripeCubit(authRepositoy: getIt<AuthRepository>()),
        ),
        BlocProvider.value(value: cacheCubit),
      ],
      child: BlocBuilder<StripeCubit, StripeState>(
        builder: (context, stripestate) {
          return BlocConsumer<CachedMembersCubit, CachedMembersState>(
            listener: (context, cachestate) {
              if (cachestate.status == CachedMembersStateStatus.clearedCache) {
                Navigator.of(context).pop();
              }
            },
            builder: (context, cachestate) {
              return GivtBottomSheet(
                title: 'Your payment method has been declined',
                icon: (cachestate.status == CachedMembersStateStatus.loading ||
                        stripestate.stripeStatus == StripeObjectStatus.loading)
                    ? const Center(
                        child: CustomCircularProgressIndicator(),
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: FamilyAppTheme.primary95,
                            ),
                          ),
                          walletEmptyIcon(width: 140, height: 140),
                        ],
                      ),
                content: (cachestate.status ==
                            CachedMembersStateStatus.loading ||
                        stripestate.stripeStatus == StripeObjectStatus.loading)
                    ? const SizedBox.shrink()
                    : const BodyMediumText(
                        'Make sure you have enough funds in your account, then try again. Or choose another payment method.',
                        textAlign: TextAlign.center,
                      ),
                primaryButton: GivtElevatedButton(
                  isDisabled: cachestate.status ==
                          CachedMembersStateStatus.loading ||
                      cachestate.status ==
                          CachedMembersStateStatus.noFundsSuccess ||
                      stripestate.stripeStatus == StripeObjectStatus.loading,
                  text: 'Try again',
                  amplitudeEvent:
                      AmplitudeEvents.changePaymentMethodForFailedVPCClicked,
                  onTap: () async {
                    await cacheCubit.tryCreateMembersFromCache(members);
                  },
                ),
                secondaryButton: GivtElevatedSecondaryButton(
                  isDisabled: cachestate.status ==
                          CachedMembersStateStatus.loading ||
                      cachestate.status ==
                          CachedMembersStateStatus.noFundsSuccess ||
                      stripestate.stripeStatus == StripeObjectStatus.loading,
                  text: 'Change payment method',
                  rightIcon: const FaIcon(
                    FontAwesomeIcons.arrowsRotate,
                    size: 24,
                  ),
                  onTap: () async {
                    if (!context.mounted) return;
                    await context.read<StripeCubit>().fetchSetupIntent();

                    if (!context.mounted) return;

                    try {
                      await StripeHelper(context).showPaymentSheet();

                      if (!context.mounted) return;
                      await context.read<AuthCubit>().refreshUser();
                    } on StripeException catch (e, stackTrace) {
                      await AnalyticsHelper.logEvent(
                        eventName: AmplitudeEvents.tryAgainForFailedVPCClicked,
                      );

                      /* Logged as info as stripe is giving exception
                                         when for example people close the bottomsheet.
                                         So it's not a real error :)
                                      */
                      LoggingInfo.instance.info(
                        e.toString(),
                        methodName: stackTrace.toString(),
                      );
                    }
                  },
                  amplitudeEvent: AmplitudeEvents.editPaymentDetailsCanceled,
                ),
              );
            },
          );
        },
      ),
    );
  }

  static void show(BuildContext context, List<Member> cachedMembers,
      VoidCallback onBottomsheetClosed) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      builder: (context) =>
          VPCFailedCachedMembersBottomsheet(members: cachedMembers),
    ).then((value) => onBottomsheetClosed());
  }
}
