import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:givt_app/shared/models/stripe_response.dart';

part 'edit_stripe_state.dart';

class EditStripeCubit extends Cubit<EditStripeState> {
  EditStripeCubit({
    required this.authRepositoy,
  }) : super(const EditStripeState());

  final AuthRepositoy authRepositoy;

  Future<void> fetchStripeCustomerUpdateURLs() async {
    emit(state.copyWith(stripeStatus: StripeObjectStatus.loading));
    try {
      final response = await authRepositoy.updateStripeCustomer();

      emit(
        state.copyWith(
          stripeStatus: StripeObjectStatus.display,
          stripeObject: response,
        ),
      );
    } catch (e, stackTrace) {
      await LoggingInfo.instance.error('$e', methodName: stackTrace.toString());
      emit(state.copyWith(stripeStatus: StripeObjectStatus.failure));
    }
  }

  void stripeUpdateComplete() =>
      emit(state.copyWith(stripeStatus: StripeObjectStatus.success));

  void stripeUpdateCanceled() =>
      emit(state.copyWith(stripeStatus: StripeObjectStatus.canceled));
}
