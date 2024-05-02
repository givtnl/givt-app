import 'package:equatable/equatable.dart';

import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/day_chat_status.dart';

class DayChatState extends Equatable {
  const DayChatState({
    required this.status,
    this.chatScriptItemIndex = -1,
  });

  factory DayChatState.fromMap(Map<String, dynamic> map) {
    return DayChatState(
      status: DayChatStatus.fromString((map['status'] ?? '').toString()),
      chatScriptItemIndex: map['chatScriptItemIndex'] as int,
    );
  }

  const DayChatState.empty()
      : status = DayChatStatus.unavailable,
        chatScriptItemIndex = -1;

  final DayChatStatus status;
  final int chatScriptItemIndex;

  @override
  List<Object> get props => [status, chatScriptItemIndex];

  DayChatState copyWith({
    DayChatStatus? status,
    int? chatScriptItemIndex,
  }) {
    return DayChatState(
      status: status ?? this.status,
      chatScriptItemIndex: chatScriptItemIndex ?? this.chatScriptItemIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
      'chatScriptItemIndex': chatScriptItemIndex,
    };
  }
}
