import 'package:equatable/equatable.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';

class EditChild extends Equatable {
  const EditChild({
    required this.firstName,
    required this.allowance,
  });

  const EditChild.empty()
      : this(
          firstName: '',
          allowance: 0,
        );

  factory EditChild.fromProfileDetails(Profile profileDetails) {
    return EditChild(
      firstName: profileDetails.firstName,
      allowance: profileDetails.wallet.givingAllowance.amount,
    );
  }

  final String firstName;
  final num allowance;

  Map<String, dynamic> toJson() {
    return {
      'childProfile': {
        'firstName': firstName,
      },
      'givingAllowance': {
        'amount': allowance,
      },
    };
  }

  @override
  List<Object> get props => [firstName, allowance];
}
