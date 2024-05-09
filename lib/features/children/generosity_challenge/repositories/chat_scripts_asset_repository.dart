import 'dart:convert';

import 'package:flutter/services.dart' as root_bundle;
import 'package:givt_app/features/children/generosity_challenge/models/chat_actors_settings.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/chat_scripts_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';

class ChatScriptsAssetRepositoryImpl with ChatScriptsRepository {
  static const String _chatActorsSettingsPath =
      'assets/jsons/generosity_challenge/chat_actors_settings.json';

  @override
  Future<List<ChatScriptItem>> loadChatScripts() async {
    final chatScripts = <ChatScriptItem>[];
    for (var dayIndex = 0;
        dayIndex < GenerosityChallengeHelper.generosityChallengeDays;
        dayIndex++) {
      final path =
          'assets/jsons/generosity_challenge/chat_scripts/chat_script_day_$dayIndex.json';

      final json = await root_bundle.rootBundle.loadString(path);

      final chatScriptBranchesMap = jsonDecode(json) as Map<String, dynamic>;

      chatScripts.add(ChatScriptItem.fromBranchesMap(chatScriptBranchesMap));
    }
    return chatScripts;
  }

  @override
  Future<ChatActorsSettings> loadChatActorsSettings() async {
    final json =
        await root_bundle.rootBundle.loadString(_chatActorsSettingsPath);
    final chatActorsSettingsMap = jsonDecode(json) as Map<String, dynamic>;
    return ChatActorsSettings.fromMap(chatActorsSettingsMap);
  }
}
