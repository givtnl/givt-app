import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/donation_overview/models/donation_status.dart';
import 'package:givt_app/features/donation_overview/repositories/donation_overview_repository.dart';
import 'package:givt_app/features/permit_biometric/models/permit_biometric_request.dart';
import 'package:go_router/go_router.dart';

/// Helper function to navigate after mandate signing.
/// If there are pending donations, navigates to review donations page.
/// Otherwise, skips directly to the next step (gift aid for UK, biometric for EU).
Future<void> navigateAfterMandateSigning(
  BuildContext context,
  String countryCode,
) async {
  final repository = getIt<DonationOverviewRepository>();
  
  // Load donations to check for pending ones
  await repository.loadDonations();
  
  // Filter for pending donations
  final allDonations = repository.getDonations();
  final pendingDonations = allDonations.where((donation) {
    final statusType = donation.status.type;
    return statusType == DonationStatusType.created ||
        statusType == DonationStatusType.inProcess;
  }).toList();
  
  // If there are pending donations, go to review page
  if (pendingDonations.isNotEmpty) {
    context.goNamed(Pages.reviewDonations.name);
    return;
  }
  
  // Otherwise, skip directly to the next step
  if (Country.unitedKingdomCodes().contains(countryCode)) {
    // UK users go to Gift Aid
    context.goNamed(Pages.giftAid.name);
  } else {
    // EU users go to Biometric permission
    context.pushNamed(
      Pages.permitBiometric.name,
      extra: PermitBiometricRequest.registration(
        redirect: (context) =>
            context.goNamed(Pages.registrationSuccess.name),
      ),
    );
  }
}
