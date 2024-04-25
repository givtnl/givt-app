import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';

mixin ChatScriptsRepository {
  Future<ChatScriptItem> loadChatScript({
    required int chatScriptIndex,
  });
}
