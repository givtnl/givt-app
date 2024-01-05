import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/add_member/models/profile.dart';

mixin AddMemberRepository {
  Future<bool> addMembers(List<Member> children);
}

class AddMemberRepositoryImpl with AddMemberRepository {
  AddMemberRepositoryImpl(this.apiService);
  final APIService apiService;

  @override
  Future<bool> addMembers(List<Member> profiles) async {
    final List<Map<String, dynamic>> profilesJsonList =
        profiles.map((profile) => profile.toJson()).toList();
    final body = {
      'profiles': profilesJsonList,
    };

    final response = await apiService.addMember(body);
    return response;
  }
}
