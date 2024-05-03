import 'dart:convert';

import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/cubit/family_values_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/family_value.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin FamilyValuesRepository {
  Future<void> rememberValues({
    required List<FamilyValue> values,
  });
  Future<List<FamilyValue>> getRememberedValues();
}

class FamilyValuesRepositoryImpl with FamilyValuesRepository {
  FamilyValuesRepositoryImpl(this.prefs);

  final SharedPreferences prefs;

  @override
  Future<void> rememberValues({
    required List<FamilyValue> values,
  }) async {
    final body = values.map((e) => e.toMap()).toList();
    await prefs.setString(FamilyValuesCubit.familyValuesKey, jsonEncode(body));
  }

  @override
  Future<List<FamilyValue>> getRememberedValues() async {
    final familyValuesJson = prefs.getString(FamilyValuesCubit.familyValuesKey);
    if (familyValuesJson == null) {
      return [];
    }
    final familyValuesList = jsonDecode(familyValuesJson) as List<dynamic>;
    return familyValuesList
        .map((e) => FamilyValue.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
