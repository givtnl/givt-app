import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/shared/models/stripe_response.dart';

part 'stripe_state.dart';

class StripeCubit extends Cubit<StripeState> {
  StripeCubit({
    required this.authRepositoy,
  }) : super(const StripeState());

  final AuthRepository authRepositoy;

  Future<void> fetchSetupIntent() async {
    emit(state.copyWith(stripeStatus: StripeObjectStatus.loading));
    try {
      final response = await authRepositoy.fetchStripeSetupIntent();

      emit(
        state.copyWith(
          stripeStatus: StripeObjectStatus.display,
          stripeObject: response,
        ),
      );
    } catch (e, stackTrace) {
      emit(state.copyWith(stripeStatus: StripeObjectStatus.failure));
      LoggingInfo.instance.error(
        '$e',
        methodName: stackTrace.toString(),
      );
    }
  }

  void stripeRegistrationComplete() =>
      emit(state.copyWith(stripeStatus: StripeObjectStatus.success));
}
