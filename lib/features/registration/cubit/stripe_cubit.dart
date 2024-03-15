import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/shared/models/stripe_response.dart';

part 'stripe_state.dart';

class StripeCubit extends Cubit<StripeState> {
  StripeCubit({
    required this.authRepositoy,
    required this.authCubit,
  }) : super(const StripeState());

  final AuthRepositoy authRepositoy;
  final AuthCubit authCubit;

  Future<void> fetchStripeCustomerCreationURLs() async {
    final email = authCubit.state.user.email;
    emit(state.copyWith(stripeStatus: StripeObjectStatus.loading));
    try {
      final response = await authRepositoy.registerStripeCustomer(
        email: email,
      );
      emit(
        state.copyWith(
          stripeStatus: StripeObjectStatus.display,
          stripeObject: response,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWith(stripeStatus: StripeObjectStatus.failure));
      await LoggingInfo.instance.error(
        '$e, ALSO user email: $email \nuser country: ${authCubit.state.user.country}',
        methodName: stackTrace.toString(),
      );
    }
  }

  void stripeRegistrationComplete() =>
      emit(state.copyWith(stripeStatus: StripeObjectStatus.success));
}
