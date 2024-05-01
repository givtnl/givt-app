part of 'family_values_cubit.dart';

class FamilyValuesState extends Equatable {
  const FamilyValuesState({
    required this.selectedValues,
  });

  static const int maxSelectedValues = 3;

  final List<FamilyValue> selectedValues;

  int getUIindex(FamilyValue value) {
    return selectedValues.indexOf(value) + 1;
  }

  @override
  List<Object> get props => [selectedValues];

  FamilyValuesState copyWith({
    List<FamilyValue>? selectedValues,
  }) {
    return FamilyValuesState(
      selectedValues: selectedValues ?? this.selectedValues,
    );
  }
}
