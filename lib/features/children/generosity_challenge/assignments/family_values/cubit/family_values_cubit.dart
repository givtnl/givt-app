import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/family_value.dart';

part 'family_values_state.dart';

class FamilyValuesCubit extends Cubit<FamilyValuesState> {
  FamilyValuesCubit() : super(FamilyValuesState(selectedValues: []));

  void selectValue(FamilyValue value) {
    final newSelectedValues = [...state.selectedValues];
    if (newSelectedValues.contains(value)) {
      newSelectedValues.remove(value);
    } else if (newSelectedValues.length < FamilyValuesState.maxSelectedValues) {
      newSelectedValues.add(value);
    }

    // AnalyticsHelper.logEvent(
    //   eventName: AmplitudeEvent.interestSelected,
    //   eventProperties: {
    //     AnalyticsHelper.interestKey:
    //         newSelectedInterests.map((e) => e.displayText).toList().toString(),
    //   },
    // );

    emit(state.copyWith(selectedValues: newSelectedValues));
  }
}
