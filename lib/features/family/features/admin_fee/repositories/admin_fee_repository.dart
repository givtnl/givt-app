import 'dart:async';

import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/admin_fee/models/admin_fee.dart';
import 'package:givt_app/features/family/network/api_service.dart';

class AdminFeeRepository {
  AdminFeeRepository(this._familyAPIService) {
    fetchAdminFee();
  }

  final FamilyAPIService _familyAPIService;
  AdminFee? _adminFee;

  AdminFee get adminFee => _adminFee ?? AdminFee.initial();

  Future<void> fetchAdminFee() async {
    try {
      final response = await _familyAPIService.fetchAdminFee();
      _adminFee = AdminFee.fromMap(response);
    } catch (e, s) {
      _adminFee = AdminFee.initial();
      unawaited(
        LoggingInfo.instance.warning(
          'Failed to fetch admin fee: $e\n\n$s',
        ),
      );
    }
  }

  double getTotalFee(double amount) {
    final extraAmount =
        amount > 1 ? (amount - 1) * adminFee.amountPerExtraDollar : 0;
    final total = extraAmount + adminFee.startAmount;
    return total > adminFee.maxAmount ? adminFee.maxAmount : total;
  }
}
