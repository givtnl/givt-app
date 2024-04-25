import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_image_message.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_text_message.dart';

import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_item_side.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_item_type.dart';

class ChatScriptItem extends Equatable {
  const ChatScriptItem({
    required this.type,
    required this.side,
    this.next,
  });

  const ChatScriptItem.empty({
    this.type = ChatScriptItemType.textMessage,
    this.side = ChatScriptItemSide.interlocutor,
  }) : next = null;

  factory ChatScriptItem.fromMapInherited(Map<String, dynamic> map) {
    final type = ChatScriptItemType.fromString(map['type'].toString());
    switch (type) {
      case ChatScriptItemType.textMessage:
        return ChatScriptTextMessage.fromMap(map);
      case ChatScriptItemType.imageMessage:
        return ChatScriptImageMessage.fromMap(map);
      case ChatScriptItemType.gifMessage:
      case ChatScriptItemType.inputAnswer:
      case ChatScriptItemType.buttonAnswer:
      case ChatScriptItemType.buttonGroupAnswer:
        return ChatScriptItem.fromMap(map);
    }
  }

  ChatScriptItem.fromMap(Map<String, dynamic> map)
      : this(
          type: ChatScriptItemType.fromString(map['type'].toString()),
          side: ChatScriptItemSide.fromString(map['side'].toString()),
          next: map.containsKey('next')
              ? ChatScriptItem.fromMapInherited(
                  map['next'] as Map<String, dynamic>,
                )
              : null,
        );

  final ChatScriptItemType type;
  final ChatScriptItemSide side;
  final ChatScriptItem? next;

  @override
  List<Object?> get props => [type, side, next];
}
