import 'dart:async';

import 'package:givt_app/core/failures/failure.dart';

/// Returns true when a donation submission failed due to a timeout rather than
/// a validation or server error.
bool isDonationSubmissionTimeout(Object error) {
  if (error is TimeoutException) {
    return true;
  }
  if (error is GivtServerFailure && error.statusCode == 408) {
    return true;
  }
  return false;
}
