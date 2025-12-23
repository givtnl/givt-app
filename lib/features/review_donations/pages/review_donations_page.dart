import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/donation_overview/models/donation_group.dart';
import 'package:givt_app/features/donation_overview/models/donation_item.dart';
import 'package:givt_app/features/donation_overview/widgets/donation_list_item.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/review_donations/cubit/review_donations_cubit.dart';
import 'package:givt_app/features/review_donations/models/review_donations_uimodel.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';

class ReviewDonationsPage extends StatefulWidget {
  const ReviewDonationsPage({
    super.key,
  });

  @override
  State<ReviewDonationsPage> createState() => _ReviewDonationsPageState();
}

class _ReviewDonationsPageState extends State<ReviewDonationsPage> {
  late final ReviewDonationsCubit _cubit;
  late final String country;

  @override
  void initState() {
    super.initState();

    country = context.read<AuthCubit>().state.user.country;
    _cubit = getIt<ReviewDonationsCubit>();
    _cubit.init();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _cubit,
      onData: _buildScaffold,
      onLoading: (context) => _buildLoadingScaffold(),
      onError: _buildErrorScaffold,
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    ReviewDonationsUIModel reviewDonationsUIModel,
  ) {
    final locals = context.l10n;
    final user = context.read<AuthCubit>().state.user;
    final countryObj = Country.fromCode(user.country);
    final currencySymbol = Util.getCurrencySymbol(countryCode: user.country);
    final formattedTotal = Util.formatNumberComma(
      reviewDonationsUIModel.totalAmount,
      countryObj,
    );

    // Group donations similar to donation overview
    final donationGroups = _groupDonations(
      reviewDonationsUIModel.pendingDonations,
    );

    // Calculate business days
    final businessDays = _getBusinessDays(user.country);

    return FunScaffold(
      canPop: false,
      minimumPadding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
      appBar: FunTopAppBar.white(
        title: locals.reviewDonationsTitle,
      ),
      body: Column(
        children: [
          // Description text
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: BodySmallText(
              locals.reviewDonationsDescription,
              textAlign: TextAlign.center,
            ),
          ),

          // Total amount banner - matches MonthlyHeader styling
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(0, 24, 0, 0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: FamilyAppTheme.primary80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleSmallText(
                  locals.donationTotal,
                  color: FamilyAppTheme.primary20,
                ),
                TitleSmallText(
                  '$currencySymbol $formattedTotal',
                  color: FamilyAppTheme.primary20,
                ),
              ],
            ),
          ),

          // Donations list
          Expanded(
            child: donationGroups.isEmpty
                ? const Center(
                    child: BodyMediumText(
                      'No pending donations',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: donationGroups.length,
                    itemBuilder: (context, index) {
                      final donationGroup = donationGroups[index];
                      return Column(
                        children: [
                          DonationListItem(
                            donationGroup: donationGroup,
                            analyticsEvent: AnalyticsEvent(
                              AnalyticsEventName.seeDonationHistoryPressed,
                              parameters: {
                                'donation': donationGroup.toJson(),
                              },
                            ),
                          ),
                          const Divider(
                            height: 0,
                            color: FamilyAppTheme.neutralVariant95,
                          ),
                        ],
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FunButton(
              onTap: () {
                context.pushNamed(
                  Pages.donationsProcessedSuccess.name,
                  queryParameters: {
                    'amount': reviewDonationsUIModel.totalAmount.toString(),
                    'businessDays': businessDays.toString(),
                  },
                );
              },
              text: locals.buttonContinue,
              analyticsEvent: AnalyticsEvent(
                AnalyticsEventName.continueClicked,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScaffold() {
    return FunScaffold(
      appBar: FunTopAppBar.white(
        title: context.l10n.reviewDonationsTitle,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorScaffold(BuildContext context, String? error) {
    return FunScaffold(
      appBar: FunTopAppBar.white(
        title: context.l10n.reviewDonationsTitle,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: FamilyAppTheme.error50,
              ),
              const SizedBox(height: 16),
              TitleMediumText(
                error ?? 'An error occurred',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Groups donations by timestamp and organization (similar to DonationOverviewUIModel)
  List<DonationGroup> _groupDonations(List<DonationItem> pendingDonations) {
    final donationGroups = <DonationGroup>[];
    final groupMap = <String, List<DonationItem>>{};

    for (final donation in pendingDonations) {
      if (donation.timeStamp != null) {
        // Create a key based on timestamp and organization
        final groupKey =
            '${donation.timeStamp!.millisecondsSinceEpoch}_${donation.organisationName}';
        groupMap.putIfAbsent(groupKey, () => []).add(donation);
      }
    }

    // Convert to DonationGroup objects
    groupMap.forEach((key, groupDonations) {
      if (groupDonations.isNotEmpty) {
        final firstDonation = groupDonations.first;
        final groupAmount = groupDonations.fold<double>(
          0,
          (sum, d) => sum + d.amount,
        );

        donationGroups.add(
          DonationGroup(
            timeStamp: firstDonation.timeStamp,
            organisationName: firstDonation.organisationName,
            donations: groupDonations,
            amount: groupAmount,
            isGiftAidEnabled: firstDonation.isGiftAidEnabled,
            organisationTaxDeductible: firstDonation.organisationTaxDeductible,
            isOnlineGiving: firstDonation.donationType == 7,
            isRecurringDonation: firstDonation.donationType == 1,
          ),
        );
      }
    });

    // Sort donation groups by timestamp (newest first)
    donationGroups.sort((a, b) {
      if (a.timeStamp == null && b.timeStamp == null) return 0;
      if (a.timeStamp == null) return 1;
      if (b.timeStamp == null) return -1;
      return b.timeStamp!.compareTo(a.timeStamp!);
    });

    return donationGroups;
  }

  /// Returns business days based on country: 10 for UK, 3 for EU/Others
  int _getBusinessDays(String countryCode) {
    if (Country.unitedKingdomCodes().contains(countryCode)) {
      return 10;
    }
    return 3;
  }
}
