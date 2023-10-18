import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/features/children/overview/models/wallet.dart';

import 'package:givt_app/utils/utils.dart';

class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.comment,
    required this.wallet,
    required this.pictureURL,
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
        );

  factory Profile.fromMap(Map<String, dynamic> map) {
    final pictureMap = map['picture'] as Map<String, dynamic>;
    return Profile(
      id: map['id'] as String,
      firstName: (map['firstName'] ?? '') as String,
      lastName: (map['lastName'] ?? '') as String,
      nickname: (map['nickname'] ?? '') as String,
      comment: (map['comment'] ?? '') as String,
      wallet: Wallet.fromMap(map['wallet'] as Map<String, dynamic>),
      pictureURL: pictureMap['pictureURL'] as String,
    );
  }

  final String id;
  final String firstName;
  final String lastName;
  final String nickname;
  final String comment;
  final Wallet wallet;
  final String pictureURL;

  @override
  List<Object?> get props =>
      [id, firstName, lastName, nickname, comment, wallet, pictureURL];

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
      }
    };
  }

  static String number = 'kid_profiles_nr';

  //temporary workaround solution
  Color get monsterColor {
    final Color monsterColor;
    if (pictureURL.contains('monster1')) {
      monsterColor = AppTheme.childMonsterGreen;
    } else if (pictureURL.contains('monster2')) {
      monsterColor = AppTheme.childMonsterPurple;
    } else if (pictureURL.contains('monster3')) {
      monsterColor = AppTheme.childMonsterBlue;
    } else if (pictureURL.contains('monster4')) {
      monsterColor = AppTheme.childMonsterOrange;
    } else {
      monsterColor = Colors.transparent;
    }
    return monsterColor.withAlpha((255 * 0.1).toInt());
  }
}
