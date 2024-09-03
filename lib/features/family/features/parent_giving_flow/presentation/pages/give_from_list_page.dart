import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/cubit/medium_cubit.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/pages/organisation_list_family_page.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/pages/parent_amount_page.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/give/bloc/give/give_bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class GiveFromListPage extends StatelessWidget {
  const GiveFromListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;

    return BlocConsumer<GiveBloc, GiveState>(
      listener: (context, state) {
        final userGUID = context.read<AuthCubit>().state.user.guid;
        if (state.status == GiveStatus.success) {
          context.read<GiveBloc>().add(
                GiveOrganisationSelected(
                  nameSpace: context.read<MediumCubit>().state.mediumId,
                  userGUID: userGUID,
                ),
              );
        }
        if (state.status == GiveStatus.readyToGive) {
          context.pushReplacementNamed(
            FamilyPages.parentGive.name,
            extra: context.read<GiveBloc>(),
          );
        }
        if (state.status == GiveStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(locals.somethingWentWrong),
            ),
          );
        }
      },
      builder: (context, giveState) => giveState.status == GiveStatus.loading ||
              giveState.status == GiveStatus.processed ||
              giveState.status == GiveStatus.success
          ? const Scaffold(body: CustomCircularProgressIndicator())
          : OrganisationListFamilyPage(
              onTap: (CollectGroup collectGroup) {
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
    context.read<MediumCubit>().setMediumId(collectGroup.nameSpace);
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
      unawaited(AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.parentGiveWithAmountClicked,
        eventProperties: {
          'amount': result,
          'organisation': collectGroup.orgName,
          'mediumid': collectGroup.nameSpace,
        },
      ));
      context.read<GiveBloc>().add(
            GiveAmountChanged(
              firstCollectionAmount: result.toDouble(),
              secondCollectionAmount: 0,
              thirdCollectionAmount: 0,
            ),
          );
    }
  }
}
