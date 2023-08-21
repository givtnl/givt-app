import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/shared/models/stripe_response.dart';

part 'stripe_state.dart';

class StripeCubit extends Cubit<StripeState> {
  StripeCubit({required this.authRepositoy, required this.authCubit})
      : super(StripeInitial());

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
    } catch (e) {
      emit(
        state.copyWith(stripeStatus: StripeObjectStatus.failure),
      );
    }
  }

  Future<void> stripeRegistrationComplete() async {
    emit(state.copyWith(stripeStatus: StripeObjectStatus.success));
  }
}
