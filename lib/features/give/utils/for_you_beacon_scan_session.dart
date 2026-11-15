/// Tracks For You BLE scan lifecycle so we do not call startScan while Dart
/// or native still considers a session active (Android isScanningNow can lag).
class ForYouBeaconScanSession {
  bool _sessionOpen = false;
  bool _startInFlight = false;
  bool _pendingStart = false;

  bool get sessionOpen => _sessionOpen;

  /// Whether a new startScan must not run yet.
  bool shouldSkipStart({required bool isScanningNow}) {
    return isScanningNow || _sessionOpen || _startInFlight;
  }

  void setPlatformScanning({required bool active}) {
    _sessionOpen = active;
  }

  void onExplicitStop() {
    _sessionOpen = false;
  }

  void onScanStartAccepted() {
    _sessionOpen = true;
  }

  void onScanStartRejectedAsAlreadyRunning() {
    _sessionOpen = true;
  }

  bool beginStartAttempt() {
    if (_startInFlight) {
      _pendingStart = true;
      return false;
    }
    _startInFlight = true;
    return true;
  }

  void endStartAttempt() {
    _startInFlight = false;
  }

  bool takePendingStart() {
    if (!_pendingStart) {
      return false;
    }
    _pendingStart = false;
    return true;
  }

  void reset() {
    _sessionOpen = false;
    _startInFlight = false;
    _pendingStart = false;
  }
}