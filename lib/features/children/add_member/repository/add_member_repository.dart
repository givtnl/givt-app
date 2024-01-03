import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/add_member/models/child.dart';

mixin AddMemberRepository {
  Future<bool> createChild(Child child);
}

class AddMemberRepositoryImpl with AddMemberRepository {
  AddMemberRepositoryImpl(this.apiService);
  final APIService apiService;

  @override
  Future<bool> createChild(Child child) async {
    final body = {
      'profiles': [
        child.toJson(),
      ]
    };
    final response = await apiService.addMember(body);
    return response;
  }
}
