enum GiveResultOutcome {
  success,
  failed,
  unknown,
}

class GiveResultUIModel {
  const GiveResultUIModel({required this.outcome});

  final GiveResultOutcome outcome;

  /// Maps the BFF/legacy integer status to a post-browser outcome.
  ///
  /// `1` Entered, `2` ToProcess, `3` Processed → success.
  /// `4` Rejected, `5` Cancelled → failed.
  /// Any other value → unknown.
  static GiveResultOutcome fromLegacyStatus(int status) {
    switch (status) {
      case 1:
      case 2:
      case 3:
        return GiveResultOutcome.success;
      case 4:
      case 5:
        return GiveResultOutcome.failed;
      default:
        return GiveResultOutcome.unknown;
    }
  }
}
