part of 'personal_info_edit_bloc.dart';

enum PersonalInfoEditStatus {
  initial,
  loading,
  success,
  error,
  noInternet,
  invalidEmail,
  emailUsed,
}

class PersonalInfoEditState extends Equatable {
  const PersonalInfoEditState({
    this.status = PersonalInfoEditStatus.initial,
    this.loggedInUserExt = const UserExt.empty(),
    this.error = '',
  });

  final PersonalInfoEditStatus status;
  final UserExt loggedInUserExt;
  final String error;

  PersonalInfoEditState copyWith({
    PersonalInfoEditStatus? status,
    UserExt? loggedInUserExt,
    String? error,
  }) {
    return PersonalInfoEditState(
      status: status ?? this.status,
      loggedInUserExt: loggedInUserExt ?? this.loggedInUserExt,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [status, loggedInUserExt, error];
}
