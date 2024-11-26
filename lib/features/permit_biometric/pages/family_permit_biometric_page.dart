import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_button.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_top_app_bar.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/permit_biometric/cubit/permit_biometric_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class FamilyPermitBiometricPage extends StatelessWidget {
  const FamilyPermitBiometricPage({
    super.key,
  });

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
        return FunScaffold(
          appBar: FunTopAppBar.white(
          ),
          body: _buildContent(context, state),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, PermitBiometricState state) {
    if (state.status == PermitBiometricStatus.checking) {
      return const Center(child: CustomCircularProgressIndicator());
    }

    return state.status != PermitBiometricStatus.propose
        ? const SizedBox()
        : Column(
            children: [
              TitleLargeText(
                context.l10n.permitBiometricQuestionWithType(
                  state.biometricType.name,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              BodyMediumText(
                context.l10n.permitBiometricExplanation,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SvgPicture.asset(
                state.biometricType == BiometricType.faceId
                    ? 'assets/family/images/face_id_image.svg'
                    : 'assets/images/touch_id_image.svg',
                width: 160,
              ),
              const Spacer(),
              FunButton(
                text: context.l10n.permitBiometricActivateWithType(
                  state.biometricType.name,
                ),
                onTap: () {
                  context.read<PermitBiometricCubit>().enableBiometric();
                },
                analyticsEvent: AnalyticsEvent(
                  state.permitBiometricRequest.isRegistration
                      ? AmplitudeEvents.activateBiometricWhenRegistered
                      : AmplitudeEvents.activateBiometricWhenLoggedIn,
                  parameters: {
                    'biometric_type': state.biometricType.name,
                  },
                ),
              ),
              const SizedBox(height: 8),
              FunButton.secondary(
                text: context.l10n.permitBiometricSkip,
                onTap: () {
                  context.read<PermitBiometricCubit>().denyBiometric();
                },
                analyticsEvent: AnalyticsEvent(
                  state.permitBiometricRequest.isRegistration
                      ? AmplitudeEvents.skipBiometricWhenRegistered
                      : AmplitudeEvents.skipBiometricWhenLoggedIn,
                  parameters: {
                    'biometric_type': state.biometricType.name,
                  },
                ),
              ),
            ],
          );
  }
}
