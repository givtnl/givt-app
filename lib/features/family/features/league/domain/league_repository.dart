import 'package:givt_app/features/family/network/family_api_service.dart';

class LeagueRepository {
  const LeagueRepository({required this.api});

  final FamilyAPIService api;

  Future<dynamic> getLeagues() async {
    //return api.getLeagues();
  }
}
