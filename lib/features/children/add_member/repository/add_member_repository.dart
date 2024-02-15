import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';

mixin AddMemberRepository {
  Future<void> addMembers(List<Member> members);
}

class AddMemberRepositoryImpl with AddMemberRepository {
  AddMemberRepositoryImpl(this.apiService);
  final APIService apiService;

  @override
  Future<void> addMembers(List<Member> members) async {
    final profilesJsonList = members.map((member) => member.toJson()).toList();
    final body = {
      'profiles': profilesJsonList,
    };

    await apiService.addMember(body);
  }
}
