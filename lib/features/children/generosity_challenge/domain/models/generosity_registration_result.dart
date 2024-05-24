class GenerosityRegistrationResult {
  const GenerosityRegistrationResult({
    this.success = false,
    this.isAlreadyRegistered = false,
  });

  factory GenerosityRegistrationResult.success() {
    return const GenerosityRegistrationResult(
      success: true,
    );
  }

  factory GenerosityRegistrationResult.alreadyRegistered() {
    return const GenerosityRegistrationResult(
      success: true,
      isAlreadyRegistered: true,
    );
  }

  factory GenerosityRegistrationResult.failure() {
    return const GenerosityRegistrationResult();
  }

  final bool success;
  final bool isAlreadyRegistered;
}
