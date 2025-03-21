import 'dart:async';

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/family/features/add_member/models/member.dart';

mixin AddMemberRepository {
  Future<void> addMembers(List<Member> members, {required bool isRGA});

  Stream<void> onMemberAdded();
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

    try {
      await apiService.addMember(body);
    } finally {
      //always add even if there are errors
      _memberAddedStreamController.add(null);

      if (members.any((e) => e.allowance != null && e.allowance! > 0)) {
        // We add this second event to the stream delayed
        // because money-related calls require an update from Stripe for the BE
        // which takes a bit of time
        Future.delayed(const Duration(seconds: 2), () {
          _memberAddedStreamController.add(null);
        });
      }
    }
  }

  @override
  Stream<void> onMemberAdded() => _memberAddedStreamController.stream;
}
