class GenerosityRegistrationResult {
  const GenerosityRegistrationResult({
    this.success = false,
    this.wasRegisteredBeforeChallenge = false,
  });

  factory GenerosityRegistrationResult.success() {
    return const GenerosityRegistrationResult(
      success: true,
    );
  }

  factory GenerosityRegistrationResult.alreadyRegistered() {
    return const GenerosityRegistrationResult(
      success: true,
      wasRegisteredBeforeChallenge: true,
    );
  }

  factory GenerosityRegistrationResult.failure() {
    return const GenerosityRegistrationResult();
  }

  final bool success;
  final bool wasRegisteredBeforeChallenge;
}
