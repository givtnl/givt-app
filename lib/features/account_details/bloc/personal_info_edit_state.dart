part of 'personal_info_edit_bloc.dart';

enum PersonalInfoEditStatus {
  initial,
  loading,
  success,
  emailChangeSuccess,
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
    this.requestedNewEmail,
  });

  final PersonalInfoEditStatus status;
  final UserExt loggedInUserExt;
  final String error;
  /// When status is [PersonalInfoEditStatus.emailUsed], the email the user tried to change to.
  final String? requestedNewEmail;

  PersonalInfoEditState copyWith({
    PersonalInfoEditStatus? status,
    UserExt? loggedInUserExt,
    String? error,
    String? requestedNewEmail,
  }) {
    return PersonalInfoEditState(
      status: status ?? this.status,
      loggedInUserExt: loggedInUserExt ?? this.loggedInUserExt,
      error: error ?? this.error,
      requestedNewEmail: requestedNewEmail ?? this.requestedNewEmail,
    );
  }

  @override
  List<Object?> get props => [status, loggedInUserExt, error, requestedNewEmail];
}
