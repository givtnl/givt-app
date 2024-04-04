part of 'edit_stripe_cubit.dart';

class EditStripeState extends Equatable {
  const EditStripeState({
    this.stripeStatus = StripeObjectStatus.initial,
    this.stripeObject = const StripeResponse.empty(),
  });
  final StripeObjectStatus stripeStatus;
  final StripeResponse stripeObject;

  @override
  List<Object> get props => [stripeStatus, stripeObject];

  EditStripeState copyWith({
    StripeObjectStatus? stripeStatus,
    StripeResponse? stripeObject,
  }) {
    return EditStripeState(
      stripeStatus: stripeStatus ?? this.stripeStatus,
      stripeObject: stripeObject ?? this.stripeObject,
    );
  }
}
