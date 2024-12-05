import 'dart:ui';

import 'package:givt_app/utils/utils.dart';

enum DonationState {
  pending,
  approved,
  declined;

  static const int pageSize = 20;

  static DonationState getState(String? state) {
    switch (state) {
      case 'ParentApprovalPending':
        return DonationState.pending;
      case 'Entered':
        return DonationState.approved;
      case 'ToProcess':
        return DonationState.approved;
      case 'Processed':
        return DonationState.approved;
      case 'Rejected':
        return DonationState.declined;
      case 'Cancelled':
        return DonationState.declined;
      default:
        return DonationState.pending;
    }
  }

  static String getDonationStateString(DonationState state) {
    switch (state) {
      case DonationState.pending:
        return 'ParentApprovalPending';
      case DonationState.approved:
        return 'Processed';
      case DonationState.declined:
        return 'Cancelled';
    }
  }

  static String getPicture(DonationState status) {
    switch (status) {
      case DonationState.approved:
        return 'assets/images/donation_states_approved.svg';
      case DonationState.pending:
        return 'assets/images/donation_states_pending.svg';
      case DonationState.declined:
        return 'assets/images/donation_states_declined.svg';
    }
  }

  static Color getAmountColor(DonationState status) {
    switch (status) {
      case DonationState.approved:
        return AppTheme.childHistoryApproved;
      case DonationState.pending:
        return AppTheme.childHistoryPending;
      case DonationState.declined:
        return AppTheme.childHistoryDeclined;
    }
  }
}

enum DonationMediumType {
  qr(type: 'QR'),
  nfc(type: 'NFC'),
  unknown(type: '');

  const DonationMediumType({required this.type});

  final String type;

  static DonationMediumType fromString(String type) {
    return DonationMediumType.values.firstWhere(
      (element) => element.type == type,
      orElse: () => DonationMediumType.unknown,
    );
  }
}
