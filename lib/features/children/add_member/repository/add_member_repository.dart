import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/add_member/models/child.dart';

mixin AddMemberRepository {
  Future<bool> addMembers(List<Child> children);
}

class AddMemberRepositoryImpl with AddMemberRepository {
  AddMemberRepositoryImpl(this.apiService);
  final APIService apiService;

  @override
  Future<bool> addMembers(List<Child> children) async {
    final List<Map<String, dynamic>> profilesJsonList =
        children.map((child) => child.toJson()).toList();
    final body = {
      'profiles': profilesJsonList,
    };

    final response = await apiService.addMember(body);
    return response;
  }
}
