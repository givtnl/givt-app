part of 'generosity_challenge_cubit.dart';

enum GenerosityChallengeStatus {
  initial,
  loading,
  overview,
  dailyAssigmentIntro,
  dailyAssigmentConfirm,
  completed,
}

enum UnlockDayTimeDifference { minutes, days }

class GenerosityChallengeState extends Equatable {
  const GenerosityChallengeState({
    required this.status,
    required this.unlockDayTimeDifference,
    required this.activeDayIndex,
    required this.detailedDayIndex,
    required this.days,
    required this.chatScripts,
    required this.chatActorsSettings,
    required this.availableChatDayIndex,
    this.assignmentDynamicDescription,
    this.showMayor = false,
    this.blockAppLifeCycleRefresh = false,
  });

  const GenerosityChallengeState.initial({
    this.status = GenerosityChallengeStatus.initial,
    this.unlockDayTimeDifference = UnlockDayTimeDifference.days,
    this.assignmentDynamicDescription,
    this.activeDayIndex = -1,
    this.detailedDayIndex = -1,
    this.days = const [],
    this.chatScripts = const [],
    this.chatActorsSettings = const ChatActorsSettings.empty(),
    this.availableChatDayIndex = -1,
    this.showMayor = false,
    this.blockAppLifeCycleRefresh = false,
  });

  final List<Day> days;
  final int activeDayIndex;
  final int detailedDayIndex;
  final UnlockDayTimeDifference unlockDayTimeDifference;
  final GenerosityChallengeStatus status;
  final String? assignmentDynamicDescription;
  final List<ChatScriptItem> chatScripts;
  final ChatActorsSettings chatActorsSettings;
  final int availableChatDayIndex;
  final bool showMayor;
  final bool blockAppLifeCycleRefresh;

  bool get hasActiveDay => activeDayIndex != -1;

  bool get isLastCompleted =>
      days.lastIndexWhere((day) => day.isCompleted) == detailedDayIndex;

  bool get hasAvailableChat => availableChat != const ChatScriptItem.empty();

  ChatScriptItem get availableChat {
    if (availableChatDayIndex == -1) {
      return const ChatScriptItem.empty();
    }

    return days[availableChatDayIndex].currentChatItem !=
            const ChatScriptItem.empty()
        ? days[availableChatDayIndex].currentChatItem
        : chatScripts[availableChatDayIndex];
  }

  ChatScriptItem get availableChatOriginScript => availableChatDayIndex != -1
      ? chatScripts[availableChatDayIndex]
      : const ChatScriptItem.empty();

  bool get isChatContinuing =>
      availableChat != const ChatScriptItem.empty() &&
      availableChat != availableChatOriginScript;

  bool get islastDay =>
      detailedDayIndex == GenerosityChallengeHelper.generosityChallengeDays - 1;

  GenerosityChallengeState copyWith({
    List<Day>? days,
    int? activeDayIndex,
    int? detailedDayIndex,
    GenerosityChallengeStatus? status,
    UnlockDayTimeDifference? unlockDayTimeDifference,
    String? assignmentDynamicDescription,
    List<ChatScriptItem>? chatScripts,
    ChatActorsSettings? chatActorsSettings,
    int? availableChatDayIndex,
    bool? showMayor,
    bool? blockAppLifeCycleRefresh,
  }) {
    return GenerosityChallengeState(
      days: days ?? this.days,
      activeDayIndex: activeDayIndex ?? this.activeDayIndex,
      detailedDayIndex: detailedDayIndex ?? this.detailedDayIndex,
      status: status ?? this.status,
      unlockDayTimeDifference:
          unlockDayTimeDifference ?? this.unlockDayTimeDifference,
      assignmentDynamicDescription:
          assignmentDynamicDescription ?? this.assignmentDynamicDescription,
      chatScripts: chatScripts ?? this.chatScripts,
      chatActorsSettings: chatActorsSettings ?? this.chatActorsSettings,
      availableChatDayIndex:
          availableChatDayIndex ?? this.availableChatDayIndex,
      showMayor: showMayor ?? this.showMayor,
      blockAppLifeCycleRefresh:
          blockAppLifeCycleRefresh ?? this.blockAppLifeCycleRefresh,
    );
  }

  @override
  List<Object?> get props => [
        days,
        activeDayIndex,
        detailedDayIndex,
        status,
        unlockDayTimeDifference,
        assignmentDynamicDescription,
        chatScripts,
        chatActorsSettings,
        availableChatDayIndex,
        availableChat,
        showMayor,
        blockAppLifeCycleRefresh,
      ];
}
