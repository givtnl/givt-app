import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:format/format.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/children/generosity_challenge/models/chat_actors_settings.dart';
import 'package:givt_app/features/children/generosity_challenge/models/day.dart';
import 'package:givt_app/features/children/generosity_challenge/models/enums/day_chat_status.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/chat_scripts_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/generosity_challenge_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_item_type.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_save_key.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/repositories/chat_history_repository.dart';

part 'generosity_challenge_state.dart';

class GenerosityChallengeCubit extends Cubit<GenerosityChallengeState> {
  GenerosityChallengeCubit(
    this._generosityChallengeRepository,
    this._chatScriptsRepository,
    this._chatHistoryRepository,
  ) : super(const GenerosityChallengeState.initial()) {
    GenerosityChallengeHelper.updateUrlsAndCountry();
  }

  final GenerosityChallengeRepository _generosityChallengeRepository;
  final ChatScriptsRepository _chatScriptsRepository;
  final ChatHistoryRepository _chatHistoryRepository;

  Future<void> loadFromCache() async {
    emit(state.copyWith(status: GenerosityChallengeStatus.loading));

    final days = await _generosityChallengeRepository.loadFromCache();

    final chatScripts = await _chatScriptsRepository.loadChatScripts();
    final chatActorsSettings =
        await _chatScriptsRepository.loadChatActorsSettings();

    _refreshState(
      days: days,
      chatScripts: chatScripts,
      chatActorsSettings: chatActorsSettings,
    );
  }

  Future<void> clearCache() async {
    await _generosityChallengeRepository.clearCache();
    await loadFromCache();
  }

  Future<void> completeChallenge() async {
    await _generosityChallengeRepository.clearCache();
    await _generosityChallengeRepository.clearUserData();
    await _chatHistoryRepository.saveChatHistory(const ChatScriptItem.empty());
    await GenerosityChallengeHelper.complete();
  }

  Future<void> undoProgress(int dayIndex) async {
    if (dayIndex < 0 ||
        dayIndex >= GenerosityChallengeHelper.generosityChallengeDays) {
      return;
    }

    final newDays = [...state.days]..fillRange(
        dayIndex,
        GenerosityChallengeHelper.generosityChallengeDays,
        const Day.empty(),
      );
    await _generosityChallengeRepository.saveToCache(newDays);
    _refreshState(
      days: newDays,
    );

    final chatHistory = _chatHistoryRepository.loadChatHistory();
    ChatScriptItem? currentItem;

    for (currentItem = chatHistory;
        currentItem != null && currentItem != const ChatScriptItem.empty();
        currentItem = currentItem.next) {
      if (currentItem.type == ChatScriptItemType.delimiter &&
          currentItem.text == 'Day ${dayIndex + 1}') {
        final newHistory = currentItem.next ?? const ChatScriptItem.empty();
        await _chatHistoryRepository.saveChatHistory(newHistory);
        return;
      }
    }
  }

  void overview() => emit(
        state.copyWith(
          status: GenerosityChallengeStatus.overview,
          detailedDayIndex: -1,
        ),
      );

  void dayDetails(int dayIndex) => emit(
        state.copyWith(
          status: GenerosityChallengeStatus.dailyAssigmentIntro,
          detailedDayIndex: dayIndex,
        ),
      );

  void confirmAssignment(String description) => emit(
        state.copyWith(
          status: GenerosityChallengeStatus.dailyAssigmentConfirm,
          assignmentDynamicDescription: description,
          blockAppLifeCycleRefresh: true,
        ),
      );

  Future<void> completeActiveDay(bool isDebug) async {
    emit(
      state.copyWith(
        status: GenerosityChallengeStatus.loading,
        showMayor: true,
      ),
    );
    final userData = loadUserData();
    final name = userData.isNotEmpty ? userData['lastName'].toString() : null;

    GenerosityChallengeHelper.rescheduleNotificationChain(
      isDebug: isDebug,
      name: name,
    );

    state.days[state.activeDayIndex] = state.days[state.activeDayIndex]
        .copyWith(dateCompleted: DateTime.now().toIso8601String());

    await _generosityChallengeRepository.saveToCache(state.days);
    _refreshState(days: state.days);
  }

  Future<void> undoCompletedDay(int index) async {
    emit(
      state.copyWith(
        status: GenerosityChallengeStatus.loading,
        showMayor: false,
      ),
    );

    state.days[index] = state.days[index].copyWith(dateCompleted: '');

    await _generosityChallengeRepository.saveToCache(state.days);
    _refreshState(days: state.days);
  }

  Future<void> onChatCompleted() async {
    final availableChatDay = state.days[state.availableChatDayIndex];
    //based on previos status
    final isMainChatCompleted =
        availableChatDay.chatStatus == DayChatStatus.available;

    final postChat = state.chatScripts[state.availableChatDayIndex].postChat;
    final isPostChatAvailable =
        postChat != null && postChat != const ChatScriptItem.empty();
    state.days[state.availableChatDayIndex] = availableChatDay.copyWith(
      chatStatus: isMainChatCompleted && isPostChatAvailable
          ? DayChatStatus.postChat
          : DayChatStatus.completed,
      currentChatItem: isMainChatCompleted && isPostChatAvailable
          ? state.chatScripts[state.availableChatDayIndex].postChat
          : const ChatScriptItem.empty(),
    );
    await _generosityChallengeRepository.saveToCache(state.days);
    _refreshState(days: state.days);
  }

  Future<void> updateActiveDayChat(ChatScriptItem? item) async {
    final newDays = [...state.days];
    newDays[state.availableChatDayIndex] =
        state.days[state.availableChatDayIndex].copyWith(currentChatItem: item);
    await _generosityChallengeRepository.saveToCache(newDays);
    _refreshState(days: newDays);
  }

  Future<void> saveUserData(ChatScriptItem item) =>
      _generosityChallengeRepository.saveUserData(
        ChatScriptSaveKey.fromString(item.saveKey),
        item.answerText,
      );

  Future<void> saveUserDataByKey(ChatScriptSaveKey key, String value) =>
      _generosityChallengeRepository.saveUserData(key, value);

  Future<String> formatChatTextWithUserData({
    required String source,
  }) async {
    try {
      final userData = _generosityChallengeRepository.loadUserData();
      return format(source, userData);
    } catch (e) {
      return source;
    }
  }

  Future<bool> submitDay5Picture({required bool takenWithCamera}) async {
    try {
      await _generosityChallengeRepository.submitDay5Picture(
        takenWithCamera: takenWithCamera,
      );
      confirmAssignment(
        "Nice! Let's send this to the Mayor.",
      );
      return true;
    } on Exception catch (e) {
      LoggingInfo.instance.error(e.toString());
    }
    return false;
  }

  Future<String> getDay5PicturePath() async {
    try {
      final path = await _generosityChallengeRepository.getDay5PicturePath();
      return path;
    } on Exception catch (e) {
      LoggingInfo.instance.error(e.toString());
      rethrow;
    }
  }

  Map<String, dynamic> loadUserData() =>
      _generosityChallengeRepository.loadUserData();

  int _findAvailableChatDayIndex(List<Day> days, int activeChatIndex) {
    for (var dayIndex = 0; dayIndex < days.length; dayIndex++) {
      final day = days[dayIndex];

      if (!day.isCompleted && dayIndex > activeChatIndex) {
        break;
      }

      if (day.chatStatus == DayChatStatus.available ||
          (day.chatStatus == DayChatStatus.postChat && day.isCompleted)) {
        return dayIndex;
      }
    }

    return -1;
  }

  int _findActiveDayIndex(List<Day> days) {
    final lastCompletedDayIndex = days.lastIndexWhere((day) => day.isCompleted);

    if (lastCompletedDayIndex > -1) {
      final nextActiveDayIndex = lastCompletedDayIndex + 1;
      if (nextActiveDayIndex <
          GenerosityChallengeHelper.generosityChallengeDays) {
        return nextActiveDayIndex;
      } else {
        //the challenge is completed, no active day
        return -1;
      }
    } else {
      //first day of the challenge
      return 0;
    }
  }

  bool _isChallengeCompleted(List<Day> days) {
    return days.indexWhere((day) => !day.isCompleted) == -1;
  }

  void _refreshState({
    required List<Day> days,
    List<ChatScriptItem>? chatScripts,
    ChatActorsSettings? chatActorsSettings,
  }) {
    final activeDayIndex = _findActiveDayIndex(days);
    final isChallengeCompleted = _isChallengeCompleted(days);

    final availableChatDayIndex =
        _findAvailableChatDayIndex(days, activeDayIndex);

    emit(
      state.copyWith(
        days: days,
        activeDayIndex: activeDayIndex,
        status: isChallengeCompleted
            ? GenerosityChallengeStatus.completed
            : GenerosityChallengeStatus.overview,
        chatScripts: chatScripts,
        chatActorsSettings: chatActorsSettings,
        availableChatDayIndex: availableChatDayIndex,
      ),
    );
  }

  void dismissMayorPopup() {
    emit(state.copyWith(showMayor: false));
  }

  int getNrOfChildren() {
    final userdata = _generosityChallengeRepository.loadUserData();
    var nrOfChildren = 0;
    for (var i = 0; i < 4; i++) {
      final child = userdata['child${i}FirstName'];
      if (child != null) {
        nrOfChildren++;
      }
    }
    return nrOfChildren;
  }

  Future<String> getChildName(int i) async {
    final userdata =
        await _generosityChallengeRepository.loadFromKey('child${i}FirstName');
    return userdata;
  }
}
