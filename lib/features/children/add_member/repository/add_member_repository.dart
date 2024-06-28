import 'dart:async';

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';

mixin AddMemberRepository {
  Future<void> addMembers(List<Member> members, {required bool isRGA});

  Stream<void> memberAddedStream();
}

class AddMemberRepositoryImpl with AddMemberRepository {
  AddMemberRepositoryImpl(this.apiService);

  final APIService apiService;

  final StreamController<void> _memberAddedStreamController =
      StreamController<void>.broadcast();

  @override
  Future<void> addMembers(List<Member> members, {required bool isRGA}) async {
    final profilesJsonList = members.map((member) => member.toJson()).toList();
    final body = {
      'profiles': profilesJsonList,
      'allowanceType': isRGA ? 0 : 1,
    };

    await apiService.addMember(body);
    _memberAddedStreamController.add(null);
  }

  @override
  Stream<void> memberAddedStream() => _memberAddedStreamController.stream;
}
