import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/day_chat_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin ChatScriptInterpreterRepository {
  Future<void> updateDayChatStatus({
    required int dayIndex,
    required DayChatStatus dayChatStatus,
  });

  DayChatStatus getDayChatStatus({required int dayIndex});
}

class ChatScriptInterpreterRepositoryImpl with ChatScriptInterpreterRepository {
  ChatScriptInterpreterRepositoryImpl(
    this.sharedPreferences,
  );

  final SharedPreferences sharedPreferences;

  String _getDayChatStatusKeyString(
    int dayIndex,
  ) {
    return 'day_${dayIndex}_ChatStatusKey';
  }

  @override
  DayChatStatus getDayChatStatus({
    required int dayIndex,
  }) {
    final statusString =
        sharedPreferences.getString(_getDayChatStatusKeyString(dayIndex)) ?? '';
    return DayChatStatus.fromString(statusString);
  }

  @override
  Future<void> updateDayChatStatus({
    required int dayIndex,
    required DayChatStatus dayChatStatus,
  }) async {
    await sharedPreferences.setString(
      _getDayChatStatusKeyString(dayIndex),
      dayChatStatus.name,
    );
  }
}
