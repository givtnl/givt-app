import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/overview/models/wallet.dart';

class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.comment,
    required this.wallet,
    required this.pictureURL,
    required this.type,
  });

  const Profile.empty()
      : this(
          id: '',
          firstName: '',
          lastName: '',
          nickname: '',
          comment: '',
          wallet: const Wallet.empty(),
          pictureURL: '',
          type: '',
        );

  factory Profile.fromMap(Map<String, dynamic> map) {
    var picture = map['picture'] as Map<String, dynamic>;

    return Profile(
      id: map['id'] as String,
      firstName: (map['firstName'] ?? '') as String,
      lastName: (map['lastName'] ?? '') as String,
      nickname: (map['nickname'] ?? '') as String,
      comment: (map['comment'] ?? '') as String,
      wallet: Wallet.fromMap(map['wallet'] as Map<String, dynamic>),
      pictureURL: (picture['pictureURL'] ?? '') as String,
      type: (map['type'] ?? '') as String,
    );
  }

  final String id;
  final String firstName;
  final String lastName;
  final String nickname;
  final String comment;
  final Wallet wallet;
  final String pictureURL;
  final String type;

  @override
  List<Object?> get props =>
      [id, firstName, lastName, nickname, comment, wallet, pictureURL, type];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'nickname': nickname,
      'comment': comment,
      'wallet': wallet.toJson(),
      'picture': {
        'pictureURL': pictureURL,
      },
      'type': type,
    };
  }

  bool get isAdult => type == 'Parent';
  bool get isChild => type == 'Child';

  static String number = 'kid_profiles_nr';
}
