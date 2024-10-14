import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/widgets/organisation_header.dart';
import 'package:givt_app/features/family/features/topup/screens/empty_wallet_bottom_sheet.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_close_button.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class OrganisationDetailBottomSheet extends StatelessWidget {
  const OrganisationDetailBottomSheet({
    required this.organisation,
    this.onDonateClicked,
    this.isActOfService = false,
    super.key,
  });

  final double height = 100;
  final Organisation organisation;
  final bool isActOfService;
  final void Function()? onDonateClicked;

  @override
  Widget build(BuildContext context) {
    final isDonateButtonActive =
        context.watch<ProfilesCubit>().state.activeProfile.wallet.balance > 0;

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
                      TitleMediumText(
                        organisation.name,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        organisation.shortDescription,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 12),
                      BodySmallText(
                        organisation.longDescription,
                        textAlign: TextAlign.start,
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
            padding: const EdgeInsets.only(bottom: 12, left: 24, right: 24),
            child: FunButton(
              text: isActOfService ? "I'm going to do this" : 'Donate',
              onTap: onDonateClicked ??
                  () {
                    if (!isDonateButtonActive) {
                      EmptyWalletBottomSheet.show(context);
                      return;
                    }
                    context
                        .pushNamed(FamilyPages.familyChooseAmountSlider.name);
                  },
              analyticsEvent: AnalyticsEvent(
                AmplitudeEvents.donateToRecommendedCharityPressed,
                parameters: {
                  AnalyticsHelper.charityNameKey: organisation.name,
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
