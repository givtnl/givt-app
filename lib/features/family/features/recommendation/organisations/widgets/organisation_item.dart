import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/giving_flow/collectgroup_details/cubit/collectgroup_details_cubit.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/widgets/organisation_detail_bottomsheet.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/widgets/organisation_header.dart';
import 'package:givt_app/features/family/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/action_container.dart';
import 'package:givt_app/utils/utils.dart';

class OrganisationItem extends StatelessWidget {
  const OrganisationItem({
    required this.organisation,
    this.onDonateClicked,
    this.isActOfService = false,
    super.key,
  });

  final bool isActOfService;
  final Organisation organisation;
  final void Function()? onDonateClicked;

  @override
  Widget build(BuildContext context) {
    return ActionContainer(
      margin: const EdgeInsets.symmetric(vertical: 8),
      borderColor: Theme.of(context).colorScheme.primaryContainer,
      onTap: () {
        final generatedMediumId =
            base64.encode(organisation.namespace.codeUnits);
        context
            .read<CollectGroupDetailsCubit>()
            .getOrganisationDetails(generatedMediumId);

        context.read<ScanNfcCubit>().stopScanningSession();

        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => OrganisationDetailBottomSheet(
            organisation: organisation,
            onClick: onDonateClicked,
            isActOfService: isActOfService,
          ),
        );
      },
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.charityCardPressed,
        parameters: {
          AnalyticsHelper.charityNameKey: organisation.name,
        },
      ),
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
                  color: FamilyAppTheme.recommendationItemText,
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
