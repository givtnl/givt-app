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
  Future<List<ChatScriptItem>> loadChatScripts({
    bool isDebugQuickFlowEnabled = false,
  }) async {
    final chatScripts = <ChatScriptItem>[];
    if (isDebugQuickFlowEnabled) {
      chatScripts
        ..add(ChatScriptItem.fromBranchesMap(await _getChatScriptForDay(0)))
        ..add(ChatScriptItem.fromBranchesMap(await _getChatScriptForDay(1)))
        ..add(ChatScriptItem.fromBranchesMap(await _getChatScriptForDay(6)))
        ..add(ChatScriptItem.fromBranchesMap(await _getChatScriptForDay(7)));
      return chatScripts;
    } else {
      for (var dayIndex = 0;
          dayIndex < GenerosityChallengeHelper.generosityChallengeDays;
          dayIndex++) {
        final chatScriptBranchesMap = await _getChatScriptForDay(dayIndex);

        chatScripts.add(ChatScriptItem.fromBranchesMap(chatScriptBranchesMap));
      }
    }

    return chatScripts;
  }

  Future<Map<String, dynamic>> _getChatScriptForDay(int dayIndex) async {
    final path =
        'assets/jsons/generosity_challenge/chat_scripts/chat_script_day_$dayIndex.json';

    final json = await root_bundle.rootBundle.loadString(path);

    final chatScriptBranchesMap = jsonDecode(json) as Map<String, dynamic>;
    return chatScriptBranchesMap;
  }

  @override
  Future<ChatActorsSettings> loadChatActorsSettings() async {
    final json =
        await root_bundle.rootBundle.loadString(_chatActorsSettingsPath);
    final chatActorsSettingsMap = jsonDecode(json) as Map<String, dynamic>;
    return ChatActorsSettings.fromMap(chatActorsSettingsMap);
  }
}
