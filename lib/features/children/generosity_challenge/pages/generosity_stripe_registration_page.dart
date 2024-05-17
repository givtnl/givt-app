import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_stripe_registration_custom.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_striple_registration_cubit.dart';
import 'package:givt_app/features/children/shared/presentation/widgets/no_funds_error_dialog.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:givt_app/features/registration/pages/credit_card_details_page.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/utils/auth_utils.dart';

class GenerosityStripeRegistrationPage extends StatefulWidget {
  const GenerosityStripeRegistrationPage({
    super.key,
    this.onRegistrationSuccess,
    this.onRegistrationFailed,
    this.onBackPressed,
  });

  final void Function()? onRegistrationSuccess;
  final void Function()? onRegistrationFailed;
  final void Function()? onBackPressed;

  @override
  State<GenerosityStripeRegistrationPage> createState() =>
      _GenerosityStripeRegistrationPageState();
}

class _GenerosityStripeRegistrationPageState
    extends State<GenerosityStripeRegistrationPage> {
  final GenerosityStripeRegistrationCubit _cubit =
      GenerosityStripeRegistrationCubit(getIt(), getIt(), getIt());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) => widget.onBackPressed?.call(),
      canPop: widget.onBackPressed == null,
      child: Scaffold(
        appBar: AppBar(
          actions: const [BackButton()],
        ),
        body: BaseStateConsumer(
          onCustom: (context, custom) => _handleCustom(
              context, custom as GenerosityStripeRegistrationCustom),
          onData: (context, uiModel) {
            //TODO
            return const CircularProgressIndicator();
          },
          bloc: _cubit,
        ),
      ),
    );
  }

  void _handleCustom(
      BuildContext context, GenerosityStripeRegistrationCustom custom) {
    switch (custom) {
      case OpenStripeRegistration():
        Navigator.push(
          context,
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => StripeCubit(
                  authRepositoy: getIt(),
                ),
              ),
            ],
            child: CreditCardDetailsPage(
              onRegistrationFailed: _cubit.onRegistrationFailed,
              onRegistrationSuccess: _cubit.onRegistrationSuccess,
            ),
          ).toRoute(context),
        );
      case OpenLoginPopup():
        AuthUtils.checkToken(
          context,
          checkAuthRequest: CheckAuthRequest(
            navigate: (context) async => _cubit.onLoggedIn(),
          ),
        );
      case StripeRegistrationSuccess():
        widget.onRegistrationSuccess?.call();
      case ShowStripeNoFundsError():
        NoFundsErrorDialog.show(context, onClickRetry: _cubit.onClickRetry);
    }
  }
}
