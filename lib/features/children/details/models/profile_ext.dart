import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/details/models/giving_allowance.dart';
import 'package:givt_app/features/children/overview/models/legacy_profile.dart';
import 'package:givt_app/features/children/overview/models/wallet.dart';

class ProfileExt extends Equatable {
  const ProfileExt({
    required this.profile,
    required this.givingAllowance,
    required this.dateOfBirth,
    required this.firstName,
    required this.pendingAllowance,
  });

  const ProfileExt.empty()
      : this(
          profile: const LegacyProfile.empty(),
          givingAllowance: const GivingAllowance.empty(),
          dateOfBirth: '',
          firstName: '',
          pendingAllowance: false,
        );

  factory ProfileExt.fromMap(LegacyProfile profile, Map<String, dynamic> map) {
    final walletMap = map['wallet'] as Map<String, dynamic>;
    final givingAllowanceMap =
        walletMap['givingAllowance'] as Map<String, dynamic>;
    final givingAllowance = GivingAllowance.fromMap(givingAllowanceMap);
    final pendingAllowance = walletMap['pendingAllowance'] ?? false;
    final wallet = Wallet.fromMap(walletMap);
    return ProfileExt(
      profile: profile.copyWith(wallet: wallet),
      givingAllowance: givingAllowance,
      dateOfBirth: map['dateOfBirth'] as String,
      firstName: map['firstName'] as String,
      pendingAllowance: pendingAllowance as bool,
    );
  }

  final LegacyProfile profile;
  final GivingAllowance givingAllowance;
  final String dateOfBirth;
  final String firstName;
  final bool pendingAllowance;

  @override
  List<Object?> get props => [profile, givingAllowance, dateOfBirth, firstName];
}
