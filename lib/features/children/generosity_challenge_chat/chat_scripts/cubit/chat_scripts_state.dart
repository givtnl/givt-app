part of 'chat_scripts_cubit.dart';

enum ChatScriptsStatus {
  initial,
  loading,
  updated,
  error,
}

class ChatScriptsState extends Equatable {
  const ChatScriptsState({
    required this.status,
    required this.chatScripts,
    required this.dayChatStatuses,
    this.error = '',
  });

  const ChatScriptsState.initial()
      : status = ChatScriptsStatus.initial,
        chatScripts = const [],
        dayChatStatuses = const [],
        error = '';

  final ChatScriptsStatus status;
  final List<ChatScriptItem> chatScripts;
  final List<DayChatStatus> dayChatStatuses;
  final String error;

  int get activeDayChatIndex =>
      dayChatStatuses.indexWhere((status) => status == DayChatStatus.active);

  @override
  List<Object> get props => [
        status,
        chatScripts,
        activeDayChatIndex,
        error,
        dayChatStatuses,
      ];

  ChatScriptsState copyWith({
    ChatScriptsStatus? status,
    List<ChatScriptItem>? chatScripts,
    List<DayChatStatus>? dayChatStatuses,
    String? error,
  }) {
    return ChatScriptsState(
      status: status ?? this.status,
      chatScripts: chatScripts ?? this.chatScripts,
      dayChatStatuses: dayChatStatuses ?? this.dayChatStatuses,
      error: error ?? this.error,
    );
  }
}
