import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/details/models/giving_allowance.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';

class ProfileExt extends Equatable {
  const ProfileExt({
    required this.profile,
    required this.givingAllowance,
  });

  const ProfileExt.empty()
      : this(
          profile: const Profile.empty(),
          givingAllowance: const GivingAllowance.empty(),
        );

  final Profile profile;
  final GivingAllowance givingAllowance;

  @override
  List<Object?> get props => [profile];
}
