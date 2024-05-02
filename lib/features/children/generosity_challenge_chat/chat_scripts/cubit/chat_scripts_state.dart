part of 'chat_scripts_cubit.dart';

enum ChatScriptsStatus {
  initial,
  loading,
  updated,
  waitingForAnswer,
  error,
}

class ChatScriptsState extends Equatable {
  const ChatScriptsState({
    required this.status,
    required this.chatScripts,
    required this.dayChatStates,
    required this.chatHistory,
    required this.chatActorsSettings,
    required this.currentConditionalItem,
    required this.gainedAnswer,
    this.error = '',
  });

  const ChatScriptsState.initial()
      : status = ChatScriptsStatus.initial,
        chatScripts = const [],
        dayChatStates = const [],
        chatHistory = const ChatScriptItem.empty(),
        chatActorsSettings = const ChatActorsSettings.empty(),
        currentConditionalItem = const ChatScriptItem.empty(),
        gainedAnswer = const ChatScriptItem.empty(),
        error = '';

  final ChatScriptsStatus status;
  final List<ChatScriptItem> chatScripts;
  final List<DayChatState> dayChatStates;
  final ChatScriptItem chatHistory;
  final ChatActorsSettings chatActorsSettings;
  final ChatScriptItem currentConditionalItem;
  final ChatScriptItem gainedAnswer;

  final String error;

  int get activeDayChatIndex =>
      dayChatStates.indexWhere((state) => state.status == DayChatStatus.active);

  @override
  List<Object> get props {
    return [
      status,
      chatScripts,
      dayChatStates,
      chatHistory,
      chatActorsSettings,
      currentConditionalItem,
      gainedAnswer,
      error,
    ];
  }

  ChatScriptsState copyWith({
    ChatScriptsStatus? status,
    List<ChatScriptItem>? chatScripts,
    List<DayChatState>? dayChatStates,
    ChatScriptItem? chatHistory,
    ChatActorsSettings? chatActorsSettings,
    ChatScriptItem? currentConditionalItem,
    ChatScriptItem? gainedAnswer,
    String? error,
  }) {
    return ChatScriptsState(
      status: status ?? this.status,
      chatScripts: chatScripts ?? this.chatScripts,
      dayChatStates: dayChatStates ?? this.dayChatStates,
      chatHistory: chatHistory ?? this.chatHistory,
      chatActorsSettings: chatActorsSettings ?? this.chatActorsSettings,
      currentConditionalItem:
          currentConditionalItem ?? this.currentConditionalItem,
      gainedAnswer: gainedAnswer ?? this.gainedAnswer,
      error: error ?? this.error,
    );
  }
}
