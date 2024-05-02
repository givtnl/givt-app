import 'dart:convert';

import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/cubit/family_values_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/family_value.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin FamilyValuesRepository {
  Future<bool> rememberValues({
    required List<Map<String, dynamic>> body,
  });
  Future<List<FamilyValue>> getRememberedValues();
}

class FamilyValuesRepositoryImpl with FamilyValuesRepository {
  FamilyValuesRepositoryImpl(this.prefs);

  final SharedPreferences prefs;

  @override
  Future<bool> rememberValues({
    required List<Map<String, dynamic>> body,
  }) async {
    await prefs.setString(FamilyValuesCubit.familyValuesKey, jsonEncode(body));
    return true;
  }

  @override
  Future<List<FamilyValue>> getRememberedValues() async {
    final familyValuesJson = prefs.getString(FamilyValuesCubit.familyValuesKey);
    if (familyValuesJson == null) {
      return [];
    }
    final familyValuesList = jsonDecode(familyValuesJson) as List<dynamic>;
    return familyValuesList
        .map((e) => FamilyValue.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
