import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/permit_biometric/models/permit_biometric_request.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/shared/pages/pages.dart';

import 'package:go_router/go_router.dart';

class GiftAidRequestPage extends StatelessWidget {
  const GiftAidRequestPage({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state.status == RegistrationStatus.giftAidChanged) {
          context.pushNamed(
            Pages.permitBiometric.name,
            extra: PermitBiometricRequest.registration(
              redirect: (context) =>
                  context.goNamed(Pages.registrationSuccess.name),
            ),
          );
        }
      },
      child: Scaffold(
        body: GiftAidPage(
          onGiftAidChanged: (useGiftAid) =>
              context.read<RegistrationBloc>().add(
                    RegistrationGiftAidChanged(
                      isGiftAidEnabled: useGiftAid,
                    ),
                  ),
        ),
      ),
    );
  }
}
