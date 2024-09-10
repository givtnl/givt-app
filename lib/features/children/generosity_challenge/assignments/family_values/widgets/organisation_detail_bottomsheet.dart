import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/family_value.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/widgets/organisation_header.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/generosity_challenge_cubit.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/buttons/custom_icon_border_button.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class OrganisationDetailBottomSheet extends StatelessWidget {
  const OrganisationDetailBottomSheet({
    required this.value,
    super.key,
  });

  final FamilyValue value;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            forceMaterialTransparency: true,
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 12),
                child: CustomIconBorderButton(
                  child: const FaIcon(
                    FontAwesomeIcons.xmark,
                    color: AppTheme.primary40,
                    size: 20,
                  ),
                  onTap: () => context.pop(),
                ),
              ),
            ],
          ),
          body: Scrollable(
            viewportBuilder: (context, offset) => ListView(
              children: [
                const SizedBox(height: 8),
                OrganisationHeader(
                  value: value,
                ),
                Container(
                  height: 168,
                  width: double.maxFinite,
                  margin:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Image.network(
                    value.orgImagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value.organisation.organisationName ?? '',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.primary20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Rouna',
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        value.longDescription,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppTheme.primary20,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Rouna',
                            ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FunButton(
              text: 'Continue',
              onTap: () {
                context.pushNamed(
                  FamilyPages.chooseAmountSlider.name,
                  extra: [
                    value.organisation,
                    context.read<GenerosityChallengeCubit>(),
                  ],
                );
              },
              analyticsEvent: AnalyticsEvent(
                AmplitudeEvents.organisationDetailsContinueClicked,
                parameters: {
                  'organisation_name': value.organisation.organisationName,
                  'family_value': value.displayText,
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
