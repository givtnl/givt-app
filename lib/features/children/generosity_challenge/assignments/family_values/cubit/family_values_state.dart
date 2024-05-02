part of 'family_values_cubit.dart';

class FamilyValuesState extends Equatable {
  const FamilyValuesState({
    required this.selectedValues,
  });

  static const int maxSelectedValues = 3;

  final List<FamilyValue> selectedValues;

  String get selectedValuesString {
    final formattedValues = <String>[];

    for (var i = 0; i < selectedValues.length; i++) {
      final e = selectedValues[i];
      final formattedString =
          '${i + 1}. ${e.displayText.replaceAll('\n', ' ')}';
      formattedValues.add(formattedString);
    }

    return formattedValues.join('\n');
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
