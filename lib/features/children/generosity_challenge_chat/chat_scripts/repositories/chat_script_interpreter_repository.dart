import 'dart:convert';

import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/day_chat_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin ChatScriptInterpreterRepository {
  Future<List<DayChatState>> loadDayChatStates();
  Future<void> saveDayChatStates(List<DayChatState> dayChatStates);
  Future<void> clearDayChatStates();

  ChatScriptItem loadChatHistory();
  Future<void> saveChatHistory(ChatScriptItem chatHistory);
}

class ChatScriptInterpreterRepositoryImpl with ChatScriptInterpreterRepository {
  ChatScriptInterpreterRepositoryImpl(
    this.sharedPreferences,
  );

  static const String chatHistoryKey = 'chatHistory';
  static const String dayChatStatesKey = 'dayChatStates';

  final SharedPreferences sharedPreferences;

  @override
  Future<List<DayChatState>> loadDayChatStates() async {
    final encodedString = sharedPreferences.getString(dayChatStatesKey) ?? '';
    if (encodedString.isNotEmpty) {
      final result = (jsonDecode(encodedString) as List<dynamic>)
          .map<DayChatState>(
            (dayChatState) =>
                DayChatState.fromMap(dayChatState as Map<String, dynamic>),
          )
          .toList();
      return result;
    } else {
      final dayChatStates = List<DayChatState>.filled(
        GenerosityChallengeHelper.generosityChallengeDays,
        const DayChatState.empty(),
      );
      await saveDayChatStates(dayChatStates);
      return dayChatStates;
    }
  }

  @override
  Future<void> saveDayChatStates(List<DayChatState> dayChatStates) async {
    final daysJsonList =
        dayChatStates.map((dayChatState) => dayChatState.toMap()).toList();

    await sharedPreferences.setString(
      dayChatStatesKey,
      jsonEncode(daysJsonList),
    );
  }

  @override
  Future<void> clearDayChatStates() async {
    await sharedPreferences.setString(
      dayChatStatesKey,
      '',
    );
  }

  @override
  ChatScriptItem loadChatHistory() {
    final encodedString = sharedPreferences.getString(chatHistoryKey) ?? '';
    ChatScriptItem chatHistory;
    if (encodedString.isNotEmpty) {
      final historyMap = jsonDecode(encodedString) as Map<String, dynamic>;
      chatHistory = ChatScriptItem.fromMap(historyMap);
    } else {
      chatHistory = const ChatScriptItem.empty();
    }
    return chatHistory;
  }

  @override
  Future<void> saveChatHistory(ChatScriptItem chatHistory) async {
    await sharedPreferences.setString(
      chatHistoryKey,
      jsonEncode(chatHistory.toMap()),
    );
  }
}
