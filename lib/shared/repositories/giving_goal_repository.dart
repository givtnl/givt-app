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

  Future<GivingGoal> updateGivingGoal({
    required String id,
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
      // The API returns the goal data with an id field
      final result = decodedJson['result'] as Map<String, dynamic>;
      return GivingGoal.fromJson(result);
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
  Future<GivingGoal> updateGivingGoal({
    required String id,
    required Map<String, dynamic> body,
  }) async {
    await apiClient.updateGivingGoal(id: id, body: body);

    // Ensure the ID is included in the response
    final responseBody = Map<String, dynamic>.from(body)..['id'] = id;
    return GivingGoal.fromJson(responseBody);
  }

  @override
  Future<bool> removeGivingGoal() async => apiClient.removeGivingGoal();
}
