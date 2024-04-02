import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/permit_biometric/cubit/permit_biometric_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/custom_green_elevated_button.dart';
import 'package:givt_app/shared/widgets/custom_secondary_border_button.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class PermitBiometricPage extends StatelessWidget {
  const PermitBiometricPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PermitBiometricCubit, PermitBiometricState>(
      listener: (context, state) async {
        if (state.isCheckCompleted) {
          if (state.permitBiometricRequest.isRedirect) {
            state.permitBiometricRequest.redirect(context);
          } else {
            context.pop();
          }
        }
      },
      builder: (BuildContext context, PermitBiometricState state) {
        return Scaffold(
          body: _buildContent(context, state),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, PermitBiometricState state) {
    if (state.status == PermitBiometricStatus.checking) {
      return const Center(child: CircularProgressIndicator());
    }

    return state.status != PermitBiometricStatus.propose
        ? const SizedBox()
        : SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: context.l10n.permitBiometricQuestionWithType(
                          state.biometricType.name,
                        ),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        children: [
                          const TextSpan(text: '\n'),
                          TextSpan(
                            text: context.l10n.permitBiometricExplanation,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SvgPicture.asset(
                      state.biometricType == BiometricType.faceId
                          ? 'assets/images/face_id_image.svg'
                          : 'assets/images/touch_id_image.svg',
                      width: 160,
                    ),
                    const Spacer(),
                    CustomSecondaryBorderButton(
                      title: context.l10n.permitBiometricSkip,
                      onPressed: () {
                        AnalyticsHelper.logEvent(
                          eventName: state.permitBiometricRequest.isRegistration
                              ? AmplitudeEvents.skipBiometricWhenRegistered
                              : AmplitudeEvents.skipBiometricWhenLoggedIn,
                          eventProperties: {
                            'biometric_type': state.biometricType.name,
                          },
                        );
                        context.read<PermitBiometricCubit>().denyBiometric();
                      },
                    ),
                    CustomGreenElevatedButton(
                      title: context.l10n.permitBiometricActivateWithType(
                        state.biometricType.name,
                      ),
                      onPressed: () {
                        AnalyticsHelper.logEvent(
                          eventName: state.permitBiometricRequest.isRegistration
                              ? AmplitudeEvents.activateBiometricWhenRegistered
                              : AmplitudeEvents.activateBiometricWhenLoggedIn,
                          eventProperties: {
                            'biometric_type': state.biometricType.name,
                          },
                        );

                        context.read<PermitBiometricCubit>().enableBiometric();
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
  }
}
