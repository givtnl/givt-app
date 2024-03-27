import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/permit_biometric/cubit/permit_biometric_cubit.dart';
import 'package:givt_app/shared/widgets/custom_green_elevated_button.dart';
import 'package:givt_app/shared/widgets/custom_secondary_border_button.dart';

class PermitBiometricPage extends StatelessWidget {
  const PermitBiometricPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PermitBiometricCubit, PermitBiometricState>(
      listener: (context, state) {
        if (state.isAutoRedirectNeeded) {
          state.permitBiometricRequest.redirect(context);
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
                        //TODO: POEditor
                        text:
                            'Do you want to use ${state.biometricType.name}?\n',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        children: [
                          TextSpan(
                            //TODO: POEditor
                            text:
                                'Speed up the login process and keep you account secure',
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
                      //TODO: POEditor
                      title: 'Skip for now',
                      onPressed: () {
                        context.read<PermitBiometricCubit>().denyBiometric();
                      },
                    ),
                    CustomGreenElevatedButton(
                      //TODO: POEditor
                      title: 'Activate ${state.biometricType.name}',
                      onPressed: () {
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
