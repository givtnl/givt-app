import 'dart:async';

import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/admin_fee/domain/models/admin_fee.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';

class AdminFeeRepository {
  AdminFeeRepository(this._familyAPIService) {
    fetchAdminFee();
  }

  final FamilyAPIService _familyAPIService;
  final StreamController<AdminFee> _adminFeeStreamController =
      StreamController<AdminFee>.broadcast();
  AdminFee? _adminFee;
  DateTime? _lastFetchDate;

  Stream<AdminFee> adminFeeStream() => _adminFeeStreamController.stream;

  AdminFee get adminFee {
    if (_adminFee == null) {
      fetchAdminFee();
      return AdminFee.initial();
    } else {
      if (_shouldRefreshData()) {
        fetchAdminFee();
      }
      return _adminFee!;
    }
  }

  bool _shouldRefreshData() {
    return _lastFetchDate == null ||
        DateTime.now().difference(_lastFetchDate!).inHours > 1;
  }

  Future<void> fetchAdminFee() async {
    try {
      final response = await _familyAPIService.fetchAdminFee();
      _adminFee = AdminFee.fromMap(response);
      _lastFetchDate = DateTime.now();
      _adminFeeStreamController.add(_adminFee!);
    } catch (e, s) {
      _adminFee = AdminFee.initial();
      LoggingInfo.instance.warning(
        'Failed to fetch admin fee: $e\n\n$s',
      );
    }
  }
}
