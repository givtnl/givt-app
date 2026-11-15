part of 'give_bloc.dart';

abstract class GiveEvent extends Equatable {
  const GiveEvent();

  @override
  List<Object?> get props => [];
}

class GiveForYouSubmitDonations extends GiveEvent {
  const GiveForYouSubmitDonations({
    required this.nameSpace,
    required this.userGUID,
    required this.donations,
  });

  final String nameSpace;
  final String userGUID;
  final List<GivtTransaction> donations;

  @override
  List<Object?> get props => [nameSpace, userGUID, donations];
}