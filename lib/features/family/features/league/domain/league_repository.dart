import 'dart:async';

import 'package:givt_app/features/family/features/league/domain/models/league_item.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';

class LeagueRepository {
  LeagueRepository(this._api);

  final FamilyAPIService _api;

  final StreamController<List<LeagueItem>> _leagueStreamController =
      StreamController<List<LeagueItem>>.broadcast();

  Stream<List<LeagueItem>> onLeagueChanged() => _leagueStreamController.stream;

  List<LeagueItem> _league = [];

  Future<List<LeagueItem>> refreshLeagues() async {
    return fetchLeague();
  }

  Future<List<LeagueItem>> getLeague() async {
    if (_league.isEmpty) {
      return fetchLeague();
    } else {
      return _league;
    }
  }

  Future<List<LeagueItem>> fetchLeague() async {
    final response = await _api.fetchLeague();
    final list = <LeagueItem>[];
    for (final item in response) {
      list.add(LeagueItem.fromMap(item as Map<String, dynamic>));
    }
    list.removeWhere((element) => !element.isValid());
    _league = list;
    _leagueStreamController.add(list);
    return list;
  }
}
