import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/family_value.dart';
import 'package:givt_app/features/children/generosity_challenge/repositories/generosity_challenge_repository.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_save_key.dart';

part 'family_values_state.dart';

class FamilyValuesCubit extends Cubit<FamilyValuesState> {
  FamilyValuesCubit({required this.generosityChallengeRepository})
      : super(const FamilyValuesState(selectedValues: []));

  final GenerosityChallengeRepository generosityChallengeRepository;

  static const String familyValuesKey = 'family_values';

  void selectValue(FamilyValue value) {
    final newSelectedValues = [...state.selectedValues];
    if (newSelectedValues.contains(value)) {
      newSelectedValues.remove(value);
    } else if (newSelectedValues.length < FamilyValuesState.maxSelectedValues) {
      newSelectedValues.add(value);
    }

    emit(state.copyWith(selectedValues: newSelectedValues));
  }

  Future<void> rememberValues() async {
    try {
      // I guess it's ugly, but it does what it needs to do ¯\_(ツ)_/¯
      
      await generosityChallengeRepository.saveUserData(
        ChatScriptSaveKey.familyValue1Value,
        state.selectedValues[0].displayText,
      );
      await generosityChallengeRepository.saveUserData(
        ChatScriptSaveKey.familyValue1Key,
        state.selectedValues[0].area.name,
      );
      await generosityChallengeRepository.saveUserData(
        ChatScriptSaveKey.familyValue2Value,
        state.selectedValues[1].displayText,
      );
      await generosityChallengeRepository.saveUserData(
        ChatScriptSaveKey.familyValue2Key,
        state.selectedValues[1].area.name,
      );
      await generosityChallengeRepository.saveUserData(
        ChatScriptSaveKey.familyValue3Value,
        state.selectedValues[2].displayText,
      );
      await generosityChallengeRepository.saveUserData(
        ChatScriptSaveKey.familyValue3Key,
        state.selectedValues[2].area.name,
      );

    } on Exception catch (e) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: 'remebr family values',
      );
    }
  }
}
