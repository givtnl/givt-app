import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';

class ChatScriptTextMessage extends ChatScriptItem {
  const ChatScriptTextMessage({
    required this.text,
    required super.type,
    required super.side,
  });

  ChatScriptTextMessage.fromMap(super.map)
      : text = map['text'].toString(),
        super.fromMap();

  final String text;

  @override
  List<Object?> get props => [type, side, text];
}
