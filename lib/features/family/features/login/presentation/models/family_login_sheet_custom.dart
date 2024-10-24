/// Represents different dialog states during family login process.
///
/// This sealed class hierarchy ensures type-safe handling of various
/// login attempt scenarios:
/// - Two attempts remaining
/// - One attempt remaining
/// - General failure
/// - Account locked out
///
/// Usage:
/// ```dart
/// EmitCustom(FamilyLoginSheetCustom.showTwoAttemptsLeftDialog());
/// ```
sealed class FamilyLoginSheetCustom {
  const FamilyLoginSheetCustom();

  const factory FamilyLoginSheetCustom.showTwoAttemptsLeftDialog() =
      TwoAttemptsLeftDialog;

  const factory FamilyLoginSheetCustom.showOneAttemptLeftDialog() =
      OneAttemptLeftDialog;

  const factory FamilyLoginSheetCustom.showFailureDialog() = FailureDialog;

  const factory FamilyLoginSheetCustom.showLockedOutDialog() = LockedOutDialog;

  const factory FamilyLoginSheetCustom.successRedirect() = LoginSuccess;
}

class TwoAttemptsLeftDialog extends FamilyLoginSheetCustom {
  const TwoAttemptsLeftDialog();
}

class OneAttemptLeftDialog extends FamilyLoginSheetCustom {
  const OneAttemptLeftDialog();
}

class FailureDialog extends FamilyLoginSheetCustom {
  const FailureDialog();
}

class LockedOutDialog extends FamilyLoginSheetCustom {
  const LockedOutDialog();
}

class LoginSuccess extends FamilyLoginSheetCustom {
  const LoginSuccess();
}
