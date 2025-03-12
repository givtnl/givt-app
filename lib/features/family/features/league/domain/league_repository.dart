import 'dart:async';

import 'package:givt_app/features/family/features/auth/data/family_auth_repository.dart';
import 'package:givt_app/features/family/features/league/domain/models/league_item.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';

class LeagueRepository {
  LeagueRepository(
    this._api,
    this._reflectAndShareRepository,
    this._authRepository,
  ) {
    _init();
  }

  final FamilyAPIService _api;
  final ReflectAndShareRepository _reflectAndShareRepository;
  final FamilyAuthRepository _authRepository;

  final StreamController<List<LeagueItem>> _leagueStreamController =
      StreamController<List<LeagueItem>>.broadcast();

  Stream<List<LeagueItem>> onLeagueChanged() => _leagueStreamController.stream;

  List<LeagueItem> _league = [];

  void _init() {
    _authRepository.authenticatedUserStream().listen((user) {
      if (user != null) {
        _resetLeague();
        fetchLeague();
      } else {
        _resetLeague();
      }
    });
    _reflectAndShareRepository.onGameStatsUpdated.listen((_) async {
      // especially after the very first game in a week it seems to take a bit of time before the BE has updated the league
      await Future.delayed(const Duration(seconds: 1));
      unawaited(fetchLeague());
    });
  }

  void _resetLeague() {
    _league = [];
    _leagueStreamController.add(_league);
  }

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
