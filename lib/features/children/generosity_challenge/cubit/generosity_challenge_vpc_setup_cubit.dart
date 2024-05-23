import 'dart:async';

import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_vpc_setup_custom.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/generosity_challenge_repository.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/generosity_challenge_vpc_repository.dart';
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
    final isAlreadyRegistered =
        await _generosityChallengeRepository.isAlreadyRegistered();
    if (isAlreadyRegistered) {
      _skipVPC();
    } else {
      unawaited(_handleVPC());
    }
  }

  Future<Member?> _retrieveFirstParentData(
    Map<String, dynamic> userData,
  ) async {
    try {
      final firstname = userData[ChatScriptSaveKey.firstName.value] as String;
      final lastname = userData[ChatScriptSaveKey.lastName.value] as String;
      final email = userData[ChatScriptSaveKey.email.value] as String;
      return Member(
        firstName: firstname,
        lastName: lastname,
        email: email,
        type: ProfileType.Parent,
      );
    } catch (e, s) {
      _showInitialScreenWithError();
      unawaited(LoggingInfo.instance.error(
        'GenerosityChallengeVPCSetupCubit: _retrieveFirstParentData\n\n$e',
        methodName: s.toString(),
      ));
    }
    return null;
  }

  List<Member> _retrieveChildrenData(Map<String, dynamic> userData) {
    final children = <Member>[];
    final lastname = userData[ChatScriptSaveKey.lastName.value] as String;
    for (var i = 1; i < 5; i++) {
      final firstname = userData['child${i}FirstName'] as String?;
      final age = userData['child${i}Age'] as int?;
      if (firstname != null && age != null) {
        children.add(
          Member(
            firstName: firstname,
            lastName: lastname,
            age: age,
            type: ProfileType.Child,
          ),
        );
      }
    }
    return children;
  }

  void _skipVPC() {
    _navigateToLogin();
  }

  void _navigateToLogin() {
    emitCustom(const GenerosityChallengeVpcSetupCustom.navigateToLogin());
  }

  Future<void> _handleVPC() async {
    try {
      final userData = _generosityChallengeRepository.loadUserData();
      final parent = await _retrieveFirstParentData(userData);
      if (parent == null) {
        _navigateToLogin();
        await LoggingInfo.instance.error(
          'GenerosityChallengeVPCSetupCubit: parent data is not complete',
        );
      } else {
        final children = _retrieveChildrenData(userData);
        await _vpcRepository.addMembers([parent, ...children]);
        _navigateToFamilyOverview();
      }
    } catch (e, s) {
      _showInitialScreenWithError();
      unawaited(
        LoggingInfo.instance.error(
          'GenerosityChallengeVPCSetupCubit: onClickReadyForVPC\n\n$e',
          methodName: s.toString(),
        ),
      );
    }
  }

  void _navigateToFamilyOverview() {
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
