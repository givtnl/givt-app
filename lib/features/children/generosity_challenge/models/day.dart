import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/generosity_challenge/models/enums/day_chat_status.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';

class Day extends Equatable {
  const Day({
    required this.dateCompleted,
    required this.chatStatus,
    required this.currentChatItem,
  });

  const Day.empty()
      : dateCompleted = '',
        chatStatus = DayChatStatus.available,
        currentChatItem = const ChatScriptItem.empty();

  factory Day.fromMap(Map<String, dynamic> map) => Day(
        dateCompleted: (map['dateCompleted'] ?? '').toString(),
        chatStatus: DayChatStatus.fromString((map['status'] ?? '').toString()),
        currentChatItem:
            ChatScriptItem.fromMap(map['currentItem'] as Map<String, dynamic>),
      );

  final String dateCompleted;
  final DayChatStatus chatStatus;
  final ChatScriptItem currentChatItem;

  Map<String, dynamic> toMap() {
    return {
      'dateCompleted': dateCompleted,
      'status': chatStatus.name,
      'currentItem': currentChatItem.toMap(),
    };
  }

  bool get isCompleted => dateCompleted.isNotEmpty;

  @override
  List<Object> get props => [dateCompleted, chatStatus, currentChatItem];

  Day copyWith({
    String? dateCompleted,
    DayChatStatus? chatStatus,
    ChatScriptItem? currentChatItem,
  }) {
    return Day(
      dateCompleted: dateCompleted ?? this.dateCompleted,
      chatStatus: chatStatus ?? this.chatStatus,
      currentChatItem: currentChatItem ?? this.currentChatItem,
    );
  }
}
