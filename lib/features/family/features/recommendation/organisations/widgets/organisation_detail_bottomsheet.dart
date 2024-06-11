import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/pages.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/widgets/organisation_header.dart';
import 'package:givt_app/features/family/shared/widgets/givt_close_button.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class OrganisationDetailBottomSheet extends StatelessWidget {
  const OrganisationDetailBottomSheet({
    required this.organisation,
    super.key,
  });

  final double height = 100;
  final Organisation organisation;
  @override
  Widget build(BuildContext context) {
    final isDonateButtonActive =
        context.read<ProfilesCubit>().state.activeProfile.wallet.balance > 0;

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
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 12, top: 8),
                child: GivtCloseButton(),
              ),
            ],
          ),
          body: Scrollable(
            viewportBuilder: (context, offset) => ListView(
              children: [
                OrganisationHeader(
                  organisation: organisation,
                ),
                Container(
                  height: 168,
                  width: double.maxFinite,
                  margin:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Image.network(
                    organisation.promoPictureUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        organisation.name,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        organisation.shortDescription,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        organisation.longDescription,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodySmall,
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
              text: 'Donate',
              isDisabled: !isDonateButtonActive,
              onTap: () {
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.donateToRecommendedCharityPressed,
                  eventProperties: {
                    AnalyticsHelper.charityNameKey: organisation.name,
                  },
                );
                context.pushNamed(FamilyPages.chooseAmountSlider.name);
              },
            ),
          ),
        ),
      ),
    );
  }
}
