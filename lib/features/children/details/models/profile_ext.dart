import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/details/models/giving_allowance.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';

class ProfileExt extends Equatable {
  const ProfileExt({
    required this.profile,
    required this.givingAllowance,
    required this.dateOfBirth,
    required this.firstName,
  });

  const ProfileExt.empty()
      : this(
          profile: const Profile.empty(),
          givingAllowance: const GivingAllowance.empty(),
          dateOfBirth: '',
          firstName: '',
        );

  factory ProfileExt.fromMap(Profile profile, Map<String, dynamic> map) {
    final walletMap = map['wallet'] as Map<String, dynamic>;
    final givingAllowanceMap =
        walletMap['givingAllowance'] as Map<String, dynamic>;
    final givingAllowance = GivingAllowance.fromMap(givingAllowanceMap);
    return ProfileExt(
      profile: profile,
      givingAllowance: givingAllowance,
      dateOfBirth: map['dateOfBirth'] as String,
      firstName: map['firstName'] as String,
    );
  }

  final Profile profile;
  final GivingAllowance givingAllowance;
  final String dateOfBirth;
  final String firstName;

  @override
  List<Object?> get props => [profile, givingAllowance, dateOfBirth, firstName];
}
