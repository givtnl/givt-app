import 'dart:convert';

import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin ChatHistoryRepository {
  ChatScriptItem loadChatHistory();
  Future<void> saveChatHistory(ChatScriptItem chatHistory);
}

class ChatHistoryRepositoryImpl with ChatHistoryRepository {
  ChatHistoryRepositoryImpl(
    this.sharedPreferences,
  );

  static const String chatHistoryKey = 'chatHistory';

  final SharedPreferences sharedPreferences;

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
