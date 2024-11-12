import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/cubit/give_cubit.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/cubit/medium_cubit.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/pages/organisation_list_family_page.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/pages/parent_amount_page.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class GiveFromListPage extends StatelessWidget {
  const GiveFromListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final give = getIt<GiveCubit>();
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
        eventName: AmplitudeEvents.parentGivingFlowOrganisationClicked,
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
        colorCombo: CollectGroupType.getColorComboByType(collectGroup.type),
        icon: CollectGroupType.getIconByTypeUS(collectGroup.type),
      ).toRoute(context),
    );
    if (result != null && result is int && context.mounted) {
      unawaited(
        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.parentGiveWithAmountClicked,
          eventProperties: {
            'amount': result,
            'organisation': collectGroup.orgName,
            'mediumid': collectGroup.nameSpace,
          },
        ),
      );
      await getIt<GiveCubit>().createTransaction(
        userId: context.read<AuthCubit>().state.user.guid,
        amount: result,
        orgName: collectGroup.orgName,
        mediumId: collectGroup.nameSpace,
      );
    }
  }
}
