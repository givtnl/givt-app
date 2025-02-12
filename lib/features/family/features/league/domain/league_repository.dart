import 'package:givt_app/features/family/network/family_api_service.dart';

class LeagueRepository {
  const LeagueRepository(this._api);

  final FamilyAPIService _api;

  Future<dynamic> getLeagues() async {
    //return api.getLeagues();
  }
}
