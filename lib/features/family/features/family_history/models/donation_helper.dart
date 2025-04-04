import 'dart:ui';

import 'package:givt_app/features/family/features/family_history/models/history_item.dart';
import 'package:givt_app/utils/utils.dart';

enum DonationState {
  pending,
  approved,
  declined;

  static const int pageSize = 20;

  static DonationState getState(String? state, HistoryTypes type) {
    if (type == HistoryTypes.adultDonation) {
      switch (state) {
        case 'Processed':
          return DonationState.approved;
        case 'Rejected':
        case 'Cancelled':
          return DonationState.declined;
        case 'ParentApprovalPending':
        case 'Entered':
        case 'ToProcess':
        default:
          return DonationState.pending;
      }
    } else {
      switch (state) {
        case 'Entered':
        case 'ToProcess':
        case 'Processed':
          return DonationState.approved;
        case 'Rejected':
        case 'Cancelled':
          return DonationState.declined;
        case 'ParentApprovalPending':
        default:
        return DonationState.pending;
      }
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
