import 'dart:async';

class RegistrationRepository {
  RegistrationRepository();

  final StreamController<void> _registrationFlowFinishedController =
      StreamController<void>.broadcast();

  Stream<void> onRegistrationFlowFinished() =>
      _registrationFlowFinishedController.stream;

  void userHasFinishedRegistrationFlow() {
    _registrationFlowFinishedController.add(null);
  }
}
