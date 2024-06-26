import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/family_value.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/widgets/organisation_detail_bottomsheet.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/widgets/organisation_header.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/models/color_combo.dart';
import 'package:givt_app/shared/widgets/action_container.dart';
import 'package:givt_app/utils/utils.dart';

class OrganisationContainer extends StatelessWidget {
  const OrganisationContainer({
    required this.familyValue,
    required this.image,
    super.key,
  });

  final FamilyValue familyValue;
  final Image image;

  @override
  Widget build(BuildContext context) {
    return ActionContainer(
      onTap: () {
        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.organisationCardClicked,
          eventProperties: {
            'organisation_name': familyValue.organisation.organisationName,
            'family_value': familyValue.displayText,
          },
        );

        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => BlocProvider.value(
            value: context.read<GenerosityChallengeCubit>(),
            child: OrganisationDetailBottomSheet(
              value: familyValue,
            ),
          ),
        );
      },
      borderColor: ColorCombo.primary.borderColor,
      baseBorderSize: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        color: Colors.white,
        child: Column(
          children: [
            OrganisationHeader(
              value: familyValue,
            ),
            Container(
              height: 168,
              width: double.maxFinite,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: image,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                familyValue.organisation.organisationName!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ColorCombo.primary.textColor,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Rouna',
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
