import 'dart:async';

import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/models/models.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/add_member/repository/add_member_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/domain/exceptions/not_logged_in_exception.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/generosity_challenge_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/repositories/chat_history_repository.dart';

class GenerosityChallengeVpcRepository {
  const GenerosityChallengeVpcRepository(
    this._addMemberRepository,
    this._authRepository,
    this._chatHistoryRepository,
    this._generosityChallengeRepository,
  );

  final AddMemberRepository _addMemberRepository;
  final AuthRepository _authRepository;
  final ChatHistoryRepository _chatHistoryRepository;
  final GenerosityChallengeRepository _generosityChallengeRepository;

  Future<void> addMembers(List<Member> list) async {
    try {
      await _authRepository.updateFingerprintCertificate();
    } catch (e, s) {
      unawaited(
        LoggingInfo.instance.info(
          e.toString(),
          methodName: s.toString(),
        ),
      );
    }
    Session? session;
    try {
      session = await _authRepository.refreshToken(refreshUserExt: true);
    } catch (e, s) {
      unawaited(
        LoggingInfo.instance.info(
          e.toString(),
          methodName: s.toString(),
        ),
      );
    }
    if (true == session?.isLoggedIn) {
      await _addMemberRepository.addMembers(list, isRGA: true);
    } else {
      throw const NotLoggedInException();
    }
  }

  Future<void> completeChallenge() async {
    await _generosityChallengeRepository.clearCache();
    await _generosityChallengeRepository.clearUserData();
    await _chatHistoryRepository.saveChatHistory(const ChatScriptItem.empty());
    await GenerosityChallengeHelper.complete();
  }
}
