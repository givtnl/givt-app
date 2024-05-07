import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/family_value.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/repositories/family_values_repository.dart';

part 'family_values_state.dart';

class FamilyValuesCubit extends Cubit<FamilyValuesState> {
  FamilyValuesCubit({required this.valuesRepository})
      : super(const FamilyValuesState(selectedValues: []));

  final FamilyValuesRepository valuesRepository;

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
      await valuesRepository.rememberValues(values: state.selectedValues);
    } on Exception catch (e) {
      await LoggingInfo.instance.error(
        e.toString(),
        methodName: 'remebr family values',
      );
    }
  }
}