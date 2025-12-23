import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/auth/bloc/family_auth_cubit.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/cubit/give_cubit.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/cubit/medium_cubit.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/pages/organisation_list_family_page.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/pages/parent_amount_page.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/utils/family_auth_utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class GiveFromListPage extends StatelessWidget {
  const GiveFromListPage({this.shouldAuthenticate = false, super.key});

  final bool shouldAuthenticate;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final give = getIt<GiveCubit>();
    final user = context.read<FamilyAuthCubit>().user!;
    return BlocConsumer<GiveCubit, GiveState>(
      bloc: give,
      listener: (context, state) {
        if (state is GiveFromBrowser) {
          context.pushReplacementNamed(
            FamilyPages.parentGive.name,
          );
        }
        if (state is GiveError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(locals.somethingWentWrong),
            ),
          );
        }
      },
      builder: (context, giveState) => giveState is GiveLoading
          ? const Scaffold(body: CustomCircularProgressIndicator())
          : OrganisationListFamilyPage(
              countryCode: user.country,
              onTapListItem: (CollectGroup collectGroup) {
                _navigateToGivingScreen(context, collectGroup);
              },
            ),
    );
  }

  Future<void> _navigateToGivingScreen(
    BuildContext context,
    CollectGroup collectGroup,
  ) async {
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AnalyticsEventName.parentGivingFlowOrganisationClicked,
        eventProperties: {
          'organisation': collectGroup.orgName,
        },
      ),
    );
    getIt<MediumCubit>().setMediumId(collectGroup.nameSpace);
    final dynamic result = await Navigator.push(
      context,
      ParentAmountPage(
        currency: r'$',
        organisationName: collectGroup.orgName,
        icon: CollectGroupType.getFunIconByType(collectGroup.type),
      ).toRoute(context),
    );
    if (result != null && result is int && context.mounted) {
      unawaited(
        AnalyticsHelper.logEvent(
          eventName: AnalyticsEventName.parentGiveWithAmountClicked,
          eventProperties: {
            'amount': result,
            'organisation': collectGroup.orgName,
            'mediumid': collectGroup.nameSpace,
          },
        ),
      );
      if (shouldAuthenticate) {
        // Add authentication when clicking the Give button
        await FamilyAuthUtils.authenticateUser(
          context,
          checkAuthRequest: FamilyCheckAuthRequest(
            navigate: (context) async =>
                _createTransaction(context, result, collectGroup),
          ),
        );
      } else {
        await _createTransaction(context, result, collectGroup);
      }
    }
  }

  Future<void> _createTransaction(
      BuildContext context, int result, CollectGroup collectGroup) async {
    await getIt<GiveCubit>().createTransaction(
      userId: context.read<FamilyAuthCubit>().user!.guid,
      amount: result,
      orgName: collectGroup.orgName,
      mediumId: collectGroup.nameSpace,
    );
  }
}
