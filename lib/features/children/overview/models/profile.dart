import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/overview/models/wallet.dart';
import 'package:givt_app/features/children/shared/profile_type.dart';

class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.comment,
    required this.pendingAllowance,
    required this.wallet,
    required this.pictureURL,
    this.type = ProfileType.Child,
  });

  const Profile.empty()
      : this(
          id: '',
          firstName: '',
          lastName: '',
          nickname: '',
          comment: '',
          pendingAllowance: false,
          wallet: const Wallet.empty(),
          pictureURL: '',
        );

  factory Profile.fromMap(Map<String, dynamic> map) {
    final picture = map['picture'] as Map<String, dynamic>;

    return Profile(
      id: map['id'] as String,
      firstName: (map['firstName'] ?? '') as String,
      lastName: (map['lastName'] ?? '') as String,
      nickname: (map['nickname'] ?? '') as String,
      comment: (map['comment'] ?? '') as String,
      pendingAllowance: (map['pendingAllowance'] ?? false) as bool,
      wallet: Wallet.fromMap(map['wallet'] as Map<String, dynamic>),
      pictureURL: (picture['pictureURL'] ?? '') as String,
      type: ProfileType.getByTypeName((map['type'] ?? '') as String),
    );
  }

  final String id;
  final String firstName;
  final String lastName;
  final String nickname;
  final String comment;
  final bool pendingAllowance;
  final Wallet wallet;
  final String pictureURL;
  final ProfileType type;

  @override
  List<Object?> get props =>
      [id, firstName, lastName, nickname, comment, wallet, pictureURL, type];

  bool get isAdult => type == ProfileType.Parent;
  bool get isChild => type == ProfileType.Child;

  static String number = 'kid_profiles_nr';
}
