import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';

class ChatScriptImageMessage extends ChatScriptItem {
  const ChatScriptImageMessage({
    required this.image,
    required super.type,
    required super.side,
  });

  ChatScriptImageMessage.fromMap(super.map)
      : image = map['image'].toString(),
        super.fromMap();

  final String image;

  @override
  List<Object?> get props => [type, side, image];
}
