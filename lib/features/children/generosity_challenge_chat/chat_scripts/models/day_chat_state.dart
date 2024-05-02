import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';

import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/day_chat_status.dart';

class DayChatState extends Equatable {
  const DayChatState({
    required this.status,
    required this.currentItem,
  });

  factory DayChatState.fromMap(Map<String, dynamic> map) {
    return DayChatState(
      status: DayChatStatus.fromString((map['status'] ?? '').toString()),
      currentItem:
          ChatScriptItem.fromMap(map['currentItem'] as Map<String, dynamic>),
    );
  }

  const DayChatState.empty()
      : status = DayChatStatus.unavailable,
        currentItem = const ChatScriptItem.empty();

  final DayChatStatus status;
  final ChatScriptItem currentItem;

  @override
  List<Object> get props => [status, currentItem];

  DayChatState copyWith({
    DayChatStatus? status,
    ChatScriptItem? currentItem,
  }) {
    return DayChatState(
      status: status ?? this.status,
      currentItem: currentItem ?? this.currentItem,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
      'currentItem': currentItem.toMap(),
    };
  }
}
