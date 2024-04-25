import 'dart:convert';
import 'package:flutter/services.dart' as root_bundle;

import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/repositories/chat_scripts_repository.dart';

class ChatScriptsAssetRepositoryImpl with ChatScriptsRepository {
  @override
  Future<ChatScriptItem> loadChatScript({required int chatScriptIndex}) async {
    final path =
        'assets/jsons/generosity_challenge/chat_scripts/chat_script_day_$chatScriptIndex.json';

    final json = await root_bundle.rootBundle.loadString(path);

    final chatScriptMap = jsonDecode(json) as Map<String, dynamic>;
    return ChatScriptItem.fromMapInherited(chatScriptMap);
  }
}
