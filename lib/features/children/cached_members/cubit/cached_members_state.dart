part of 'cached_members_cubit.dart';

enum CachedMembersStateStatus {
  loading,
  noFundsInitial,
  noFundsSuccess,
  error,
}

class CachedMembersState extends Equatable {
  const CachedMembersState({
    this.status = CachedMembersStateStatus.noFundsInitial,
    this.familyLeader = const Member.empty(),
    this.members = const [],
  });

  final CachedMembersStateStatus status;
  final Member familyLeader;
  final List<Member> members;

  List<Member> get children {
    return members.where((p) => p.type == ProfileType.Child).toList();
  }

  List<Member> get adults {
    return <Member>[
      familyLeader,
      ...members.where((p) => p.type == ProfileType.Parent),
    ];
  }

  CachedMembersState copyWith({
    CachedMembersStateStatus? status,
    Member? familyLeader,
    List<Member>? members,
  }) {
    return CachedMembersState(
      status: status ?? this.status,
      familyLeader: familyLeader ?? this.familyLeader,
      members: members ?? this.members,
    );
  }

  @override
  List<Object> get props => [status, familyLeader, members];
}
