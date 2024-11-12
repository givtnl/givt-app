import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/overview/models/wallet.dart';
import 'package:givt_app/features/children/shared/profile_type.dart';
import 'package:givt_app/features/family/features/history/models/donation.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';

class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.type,
    required this.nickname,
    required this.comment,
    required this.wallet,
    required this.hasDonations,
    required this.lastDonationItem,
    required this.pictureURL,
    required this.dateOfBirth,
    this.windDownTime,
    this.bedTime,
  });
  factory Profile.fromMap(Map<String, dynamic> map) {
    final pictureMap = map['picture'] as Map<String, dynamic>;

    final donationMap = map['latestDonation'] == null
        ? Donation.empty()
        : Donation.fromMap(map['latestDonation'] as Map<String, dynamic>);

    final walletMap = map['wallet'] == null
        ? const Wallet.empty()
        : Wallet.fromMap(map['wallet'] as Map<String, dynamic>);

    return Profile(
      id: map['id'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String? ?? '',
      nickname: map['nickname'] as String? ?? '',
      comment: map['comment'] as String? ?? '',
      type: map['type'] as String? ?? '',
      hasDonations:
          map['hasDonations'] as bool? ?? map['latestDonation'] != null,
      wallet: walletMap,
      lastDonationItem: donationMap,
      pictureURL: pictureMap['pictureURL'] as String,
      dateOfBirth: map['dateOfBirth'] as String? ?? '',
      windDownTime: map['windDownTime'] as int?,
      bedTime: map['bedTime'] as String?,
    );
  }

  Profile.empty()
      : this(
          id: '',
          firstName: '',
          lastName: '',
          nickname: '',
          comment: '',
          type: '',
          hasDonations: false,
          wallet: const Wallet.empty(),
          lastDonationItem: Donation.empty(),
          pictureURL: '',
          dateOfBirth: '',
        );

  final String id;
  final String firstName;
  final String lastName;
  final String nickname;
  final String comment;
  final String type;
  final bool hasDonations;
  final Wallet wallet;
  final Donation lastDonationItem;
  final String pictureURL;
  final String dateOfBirth;
  final int? windDownTime;
  final String? bedTime;

  ProfileType get profileType => ProfileType.getByTypeName(type);

  String get possessiveName =>
      firstName.endsWith('s') ? "$firstName'" : "$firstName's";

  bool get isAdult => profileType == ProfileType.Parent;

  bool get isChild => profileType == ProfileType.Child;

  static String number = 'kid_profiles_nr';

  int compareNames(Profile other) {
    return firstName.compareTo(other.firstName);
  }

  bool isLoggedInUser(String guid) => id == guid;

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        nickname,
        comment,
        type,
        hasDonations,
        wallet,
        pictureURL,
        dateOfBirth,
        windDownTime,
        bedTime,
      ];

  Profile copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? nickname,
    String? comment,
    String? type,
    bool? hasDonations,
    Wallet? wallet,
    Donation? lastDonationItem,
    String? pictureURL,
    String? dateOfBirth,
    int? windDownTime,
    String? bedTime,
  }) {
    return Profile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickname: nickname ?? this.nickname,
      comment: comment ?? this.comment,
      type: type ?? this.type,
      hasDonations: hasDonations ?? this.hasDonations,
      wallet: wallet ?? this.wallet,
      lastDonationItem: lastDonationItem ?? this.lastDonationItem,
      pictureURL: pictureURL ?? this.pictureURL,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      windDownTime: windDownTime ?? this.windDownTime,
      bedTime: bedTime ?? this.bedTime,
    );
  }

  GameProfile toGameProfile() {
    return GameProfile(
      userId: id,
      firstName: firstName,
      lastName: lastName,
      pictureURL: pictureURL,
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'nickname': nickname,
      'comment': comment,
      'type': type,
      'hasDonations': hasDonations,
      'wallet': wallet.toJson(),
      'latestDonation': lastDonationItem.toJson(),
      'picture': {
        'pictureURL': pictureURL,
      },
      'dateOfBirth': dateOfBirth,
      'windDownTime': windDownTime,
      'bedTime': bedTime,
    };
  }
}
