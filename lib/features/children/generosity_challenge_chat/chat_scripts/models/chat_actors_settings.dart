import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:givt_app/utils/utils.dart';

class ChatActorsSettings extends Equatable {
  const ChatActorsSettings({
    required this.interlocutorName,
    required this.interlocutorAvatar,
    required this.interlocutorBubbleColor,
    required this.userName,
    required this.userAvatar,
    required this.userBubbleColor,
  });

  const ChatActorsSettings.empty()
      : interlocutorName = '',
        interlocutorAvatar = '',
        interlocutorBubbleColor = _defaultInterlocutorBubbleColor,
        userName = '',
        userAvatar = '',
        userBubbleColor = _defaultUserBubbleColor;

  factory ChatActorsSettings.fromMap(Map<String, dynamic> map) {
    return ChatActorsSettings(
      interlocutorName: (map['interlocutorName'] ?? '').toString(),
      interlocutorAvatar: (map['interlocutorAvatar'] ?? '').toString(),
      interlocutorBubbleColor: map['interlocutorBubbleColor'] != null
          ? _parseColorString(map['interlocutorBubbleColor'].toString())
          : _defaultInterlocutorBubbleColor,
      userName: '',
      userAvatar: (map['userAvatar'] ?? '').toString(),
      userBubbleColor: map['userBubbleColor'] != null
          ? _parseColorString(map['userBubbleColor'].toString())
          : _defaultUserBubbleColor,
    );
  }

  //TODO: replace with tertiary90
  static const Color _defaultInterlocutorBubbleColor = AppTheme.tertiary95;
  static const Color _defaultUserBubbleColor = AppTheme.secondary95;

  final String interlocutorName;
  final String interlocutorAvatar;
  final Color interlocutorBubbleColor;
  final String userName;
  final String userAvatar;
  final Color userBubbleColor;

  static Color _parseColorString(String colorString) {
    final valueString = colorString.split('0x')[1];
    final value = int.parse(valueString, radix: 16);
    return Color(value);
  }

  @override
  List<Object> get props {
    return [
      interlocutorName,
      interlocutorAvatar,
      interlocutorBubbleColor,
      userName,
      userAvatar,
      userBubbleColor,
    ];
  }

  ChatActorsSettings copyWith({
    String? interlocutorName,
    String? interlocutorAvatar,
    Color? interlocutorBubbleColor,
    String? userName,
    String? userAvatar,
    Color? userBubbleColor,
  }) {
    return ChatActorsSettings(
      interlocutorName: interlocutorName ?? this.interlocutorName,
      interlocutorAvatar: interlocutorAvatar ?? this.interlocutorAvatar,
      interlocutorBubbleColor:
          interlocutorBubbleColor ?? this.interlocutorBubbleColor,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      userBubbleColor: userBubbleColor ?? this.userBubbleColor,
    );
  }
}
