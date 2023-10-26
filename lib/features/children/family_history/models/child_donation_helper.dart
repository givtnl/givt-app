import 'dart:ui';

enum DonationState {
  pending,
  approved,
  declined;

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
        return const Color(0xFF006C47);
      case DonationState.pending:
        return const Color(0xFFA77F2C);
      case DonationState.declined:
        return const Color(0xFF780F0F);
    }
  }
}

enum DonationMediumType {
  qr(type: 'QR'),
  nfc(type: 'NFC'),
  unknown(type: '');

  final String type;
  const DonationMediumType({required this.type});
}
