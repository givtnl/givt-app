import 'package:givt_app/features/children/generosity_challenge/models/chat_actors_settings.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';

mixin ChatScriptsRepository {
  Future<List<ChatScriptItem>> loadChatScripts();
  Future<ChatActorsSettings> loadChatActorsSettings();
}
