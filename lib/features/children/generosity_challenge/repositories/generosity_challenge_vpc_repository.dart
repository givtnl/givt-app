import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:givt_app/features/children/add_member/repository/add_member_repository.dart';

class GenerosityChallengeVpcRepository {
  const GenerosityChallengeVpcRepository(
    this._addMemberRepository,
    this._authRepository,
  );

  final AddMemberRepository _addMemberRepository;
  final AuthRepository _authRepository;

  Future<void> addMembers(List<Member> list) async {

  }
}
