import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/widgets/organisation_detail_bottomsheet.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/widgets/organisation_header.dart';
import 'package:givt_app/features/family/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/layout/action_container.dart';
import 'package:givt_app/utils/utils.dart';

class OrganisationItem extends StatelessWidget {
  const OrganisationItem({
    required this.organisation, super.key,
  });

  final Organisation organisation;

  @override
  Widget build(BuildContext context) {
    return ActionContainer(
      margin: const EdgeInsets.symmetric(vertical: 8),
      borderColor: Theme.of(context).colorScheme.primaryContainer,
      onTap: () {
        final generatedMediumId =
            base64.encode(organisation.namespace.codeUnits);
        context
            .read<OrganisationDetailsCubit>()
            .getOrganisationDetails(generatedMediumId);

        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.charityCardPressed,
          eventProperties: {
            AnalyticsHelper.charityNameKey: organisation.name,
          },
        );
        context.read<ScanNfcCubit>().stopScanningSession();

        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => OrganisationDetailBottomSheet(
            organisation: organisation,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        color: Colors.white,
        child: Column(
          children: [
            OrganisationHeader(
              organisation: organisation,
            ),
            Container(
              height: 168,
              width: double.maxFinite,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Image.network(
                organisation.promoPictureUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                organisation.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.recommendationItemText,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
