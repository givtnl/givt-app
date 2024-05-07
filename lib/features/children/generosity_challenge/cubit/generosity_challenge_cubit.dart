import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/generosity_challenge/models/chat_actors_settings.dart';
import 'package:givt_app/features/children/generosity_challenge/models/day.dart';
import 'package:givt_app/features/children/generosity_challenge/models/enums/day_chat_status.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/chat_scripts_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/generosity_challenge_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';

part 'generosity_challenge_state.dart';

class GenerosityChallengeCubit extends Cubit<GenerosityChallengeState> {
  GenerosityChallengeCubit(
    this._generosityChallengeRepository,
    this._chatScriptsRepository,
  ) : super(const GenerosityChallengeState.initial());

  final GenerosityChallengeRepository _generosityChallengeRepository;
  final ChatScriptsRepository _chatScriptsRepository;

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
        ),
      );

  Future<void> completeActiveDay() async {
    emit(state.copyWith(status: GenerosityChallengeStatus.loading));

    state.days[state.activeDayIndex] = state.days[state.activeDayIndex]
        .copyWith(dateCompleted: DateTime.now().toIso8601String());

    await _generosityChallengeRepository.saveToCache(state.days);
    _refreshState(days: state.days);
  }

  Future<void> undoCompletedDay(int index) async {
    emit(state.copyWith(status: GenerosityChallengeStatus.loading));

    state.days[index] = state.days[index].copyWith(dateCompleted: '');

    await _generosityChallengeRepository.saveToCache(state.days);
    _refreshState(days: state.days);
  }

  Future<void> onChatCompleted() async {
    final availableChatDay = state.days[state.availableChatDayIndex];
    state.days[state.availableChatDayIndex] = availableChatDay.copyWith(
      chatStatus: DayChatStatus.completed,
      // status: availableChatDay.status == DayChatStatus.available
      //     ? DayChatStatus.postChat
      //     : DayChatStatus.completed,
      //TODO: switch to postChat branch here when ready
      currentChatItem: const ChatScriptItem.empty(),
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

  int _findAvailableChatDayIndex(List<Day> days, int activeChatIndex) {
    for (var dayIndex = 0; dayIndex < days.length; dayIndex++) {
      final day = days[dayIndex];

      if (!day.isCompleted && dayIndex > activeChatIndex) {
        break;
      }

      if (day.chatStatus != DayChatStatus.completed) {
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
        final lastCompletedDateTime =
            DateTime.parse(days[lastCompletedDayIndex].dateCompleted);
        final diff = lastCompletedDateTime.difference(DateTime.now());
        final timeDifference =
            state.unlockDayTimeDifference == UnlockDayTimeDifference.days
                ? diff.inDays
                : diff.inMinutes;
        if (timeDifference != 0) {
          return nextActiveDayIndex;
        } else {
          //no active day yet
          return -1;
        }
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

  Future<void> toggleTimeDifference(int index) async {
    final newTimeDifference = index == 0
        ? UnlockDayTimeDifference.days
        : UnlockDayTimeDifference.minutes;

    emit(state.copyWith(unlockDayTimeDifference: newTimeDifference));
    final days = await _generosityChallengeRepository.loadFromCache();
    _refreshState(days: days);
  }
}