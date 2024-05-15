import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/family_value.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/widgets/organisation_header.dart';
import 'package:givt_app/features/children/generosity_challenge/models/color_combo.dart';
import 'package:givt_app/shared/widgets/action_container.dart';
import 'package:givt_app/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class OrganisationDetailBottomSheet extends StatelessWidget {
  const OrganisationDetailBottomSheet({required this.value, super.key});

  final FamilyValue value;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            forceMaterialTransparency: true,
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 12, top: 12),
                child: ActionContainer(
                  onTap: () => context.pop(),
                  borderColor: ColorCombo.primary.borderColor,
                  child: Container(
                    color: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: const FaIcon(
                      FontAwesomeIcons.xmark,
                      color: AppTheme.primary40,
                      size: 20,
                    ),
                  ),
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
                      // should be short description
                      Text(
                        value.longDescription,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppTheme.primary20,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Rouna',
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'About us',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppTheme.primary20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Rouna',
                            ),
                      ),
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
            child: GivtElevatedButton(
              text: "Donate",
              // isDisabled: !isDonateButtonActive,
              onTap: () {
                // AnalyticsHelper.logEvent(
                //   eventName: AmplitudeEvent.donateToRecommendedCharityPressed,
                //   eventProperties: {
                //     AnalyticsHelper.charityNameKey: organisation.name,
                //   },
                // );
                // context.pushNamed(Pages.chooseAmountSlider.name);
              },
            ),
          ),
        ),
      ),
    );
  }
}
