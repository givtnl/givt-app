import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    final selectedValuesJson =
        state.selectedValues.map((e) => e.toJson()).toList();

    await valuesRepository.rememberValues(body: selectedValuesJson);
  }
}
