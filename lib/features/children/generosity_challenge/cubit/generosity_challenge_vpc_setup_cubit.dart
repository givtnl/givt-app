import 'dart:async';

import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/add_member/utils/member_utils.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_vpc_setup_custom.dart';
import 'package:givt_app/features/children/generosity_challenge/domain/exceptions/not_logged_in_exception.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/generosity_challenge_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/generosity_challenge_vpc_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/utils/generosity_challenge_helper.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_save_key.dart';
import 'package:givt_app/features/children/shared/profile_type.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class GenerosityChallengeVpcSetupCubit
    extends CommonCubit<dynamic, GenerosityChallengeVpcSetupCustom> {
  GenerosityChallengeVpcSetupCubit(
    this._generosityChallengeRepository,
    this._vpcRepository,
  ) : super(const BaseState.initial());

  final GenerosityChallengeRepository _generosityChallengeRepository;
  final GenerosityChallengeVpcRepository _vpcRepository;

  Future<void> onClickReadyForVPC() async {
    emitLoading();
    final wasRegisteredBeforeChallenge =
        await _generosityChallengeRepository.wasRegisteredBeforeChallenge();
    if (wasRegisteredBeforeChallenge) {
      _skipVPC();
    } else {
      await _handleVPC();
    }
  }

  List<Member> _retrieveChildrenData(Map<String, dynamic> userData) {
    final children = <Member>[];
    final lastname = userData[ChatScriptSaveKey.lastName.value] as String;
    final allowance =
        userData[ChatScriptSaveKey.allowanceAmount.value] as String?;
    for (var i = 1; i < 5; i++) {
      final firstname = userData['child${i}FirstName'] as String?;
      final age = userData['child${i}Age'] as String?;
      if (firstname != null && age != null) {
        children.add(
          Member(
            firstName: firstname,
            lastName: lastname,
            allowance: int.tryParse(allowance ?? ''),
            age: int.tryParse(age),
            dateOfBirth: getDateOfBirthFromAge(int.tryParse(age) ?? 0),
            type: ProfileType.Child,
          ),
        );
      }
    }
    return children;
  }

  void _skipVPC() {
    _navigateToWelcome();
  }

  Future<void> _handleVPC() async {
    try {
      final userData = _generosityChallengeRepository.loadUserData();
      final children = _retrieveChildrenData(userData);
      final email = GenerosityChallengeHelper.getChallengeEmail(userData);

      if (email.isEmpty) {
        _logAndSkipVPC();
        return;
      }

      final password = userData[ChatScriptSaveKey.password.value] as String;

      await _vpcRepository.login(email: email, password: password);
      await _vpcRepository.addMembers(children);

      _navigateToFamilyOverview();
    } on NotLoggedInException {
      _navigateToWelcome();
    } catch (e, s) {
      _handleError(e, s);
    }
  }

  void _logAndSkipVPC() {
    _skipVPC();
    LoggingInfo.instance.error(
      'Error handling VPC and getting user email in Generosity Challenge',
      methodName: '_handleVPC',
    );
  }

  void _handleError(Object e, StackTrace s) {
    _showInitialScreenWithError();
    LoggingInfo.instance.error(
      'GenerosityChallengeVPCSetupCubit: onClickReadyForVPC\n\n$e',
      methodName: s.toString(),
    );
  }

  void _navigateToWelcome() {
    _vpcRepository.completeChallenge();
    emitCustom(const GenerosityChallengeVpcSetupCustom.navigateToWelcome());
  }

  void _navigateToFamilyOverview() {
    _vpcRepository.completeChallenge();
    emitCustom(
      const GenerosityChallengeVpcSetupCustom.navigateToFamilyOverview(),
    );
  }

  void _showInitialScreenWithError() {
    emitInitial();
    emitSnackbarMessage(
      'Something went wrong, please check your internet connection and try again.',
      isError: true,
    );
  }
}
