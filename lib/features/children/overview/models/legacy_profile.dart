import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/overview/models/wallet.dart';
import 'package:givt_app/features/children/shared/profile_type.dart';

class LegacyProfile extends Equatable {
  const LegacyProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.comment,
    required this.wallet,
    required this.pictureURL,
    this.type = ProfileType.Child,
  });

  const LegacyProfile.empty()
      : this(
          id: '',
          firstName: '',
          lastName: '',
          nickname: '',
          comment: '',
          wallet: const Wallet.empty(),
          pictureURL: '',
        );

  factory LegacyProfile.fromMap(Map<String, dynamic> map) {
    final picture = map['picture'] as Map<String, dynamic>;

    return LegacyProfile(
      id: map['id'] as String,
      firstName: (map['firstName'] ?? '') as String,
      lastName: (map['lastName'] ?? '') as String,
      nickname: (map['nickname'] ?? '') as String,
      comment: (map['comment'] ?? '') as String,
      wallet: Wallet.fromMap(map['wallet'] as Map<String, dynamic>),
      pictureURL: (picture['pictureURL'] ?? '') as String,
      type: ProfileType.getByTypeName((map['type'] ?? '') as String),
    );
  }

  LegacyProfile copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? nickname,
    String? comment,
    Wallet? wallet,
    String? pictureURL,
    ProfileType? type,
  }) {
    return LegacyProfile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickname: nickname ?? this.nickname,
      comment: comment ?? this.comment,
      wallet: wallet ?? this.wallet,
      pictureURL: pictureURL ?? this.pictureURL,
      type: type ?? this.type,
    );
  }

  final String id;
  final String firstName;
  final String lastName;
  final String nickname;
  final String comment;
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
