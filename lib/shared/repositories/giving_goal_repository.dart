import 'dart:async';

import 'package:givt_app/core/failures/failure.dart';
import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/features/personal_summary/overview/models/giving_goal.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin GivingGoalRepository {
  Future<GivingGoal> fetchGivingGoal();

  Future<GivingGoal> addGivingGoal({
    required Map<String, dynamic> body,
  });

  Future<bool> removeGivingGoal();
}

class GivingGoalRepositoryImpl with GivingGoalRepository {
  GivingGoalRepositoryImpl(this.apiClient, this.prefs);

  final APIService apiClient;
  final SharedPreferences prefs;

  @override
  Future<GivingGoal> fetchGivingGoal() async {
    try {
      final decodedJson = await apiClient.fetchGivingGoal();
      return GivingGoal.fromJson(decodedJson['result'] as Map<String, dynamic>);
    } on GivtServerFailure catch (e) {
      // If goal not found (404), return empty goal instead of throwing
      if (e.statusCode == 404) {
        return const GivingGoal.empty();
      }
      rethrow;
    }
  }

  @override
  Future<GivingGoal> addGivingGoal({
    required Map<String, dynamic> body,
  }) async {
    await apiClient.addGivingGoal(body: body);

    return GivingGoal.fromJson(body);
  }

  @override
  Future<bool> removeGivingGoal() async => apiClient.removeGivingGoal();
}
