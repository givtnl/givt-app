import 'dart:async';

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';

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
    final hasChild = members.any((member) => member.isChild);
    final body = {
      'profiles': profilesJsonList,
      'allowanceType': isRGA ? 0 : 1,
    };

    await apiService.addMember(body);
    _memberAddedStreamController.add(null);

    if (hasChild) {
      _addMemberEventAfterOneSecond();
    }
  }

  // The reason we are adding this event to the stream is
  // because money-related calls require an update from Stripe for the BE
  // which takes a bit of time
  void _addMemberEventAfterOneSecond() {
    Future.delayed(const Duration(seconds: 1), () {
      _memberAddedStreamController.add(null);
    });
  }

  @override
  Stream<void> onMemberAdded() => _memberAddedStreamController.stream;
}
