import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/external_donations/create/cubit/external_donation_create_cubit.dart';
import 'package:givt_app/features/external_donations/create/widgets/external_donation_organisation_search_content.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class OrganisationSearchPage extends StatefulWidget {
  const OrganisationSearchPage({required this.cubit, super.key});

  final ExternalDonationCreateCubit cubit;

  @override
  State<OrganisationSearchPage> createState() => _OrganisationSearchPageState();
}

class _OrganisationSearchPageState extends State<OrganisationSearchPage> {
  final OrganisationBloc _organisationBloc = getIt<OrganisationBloc>();
  var _fetchRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_fetchRequested) {
      return;
    }
    _fetchRequested = true;
    final user = context.read<AuthCubit>().state.user;
    _organisationBloc
      ..add(
        OrganisationFetch(
          Country.fromCode(user.country),
          type: CollectGroupType.none.index,
        ),
      )
      ..add(const OrganisationFilterQueryChanged(''));
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        title: context.l10n.externalDonationsCreateSearchTitle,
        leading: const GivtBackButtonFlat(),
      ),
      body: ExternalDonationOrganisationSearchContent(
        bloc: _organisationBloc,
        onOrganisationSelected: (organisation) {
          widget.cubit.selectKnownOrganisation(organisation);
          AnalyticsHelper.logEvent(
            eventName: AnalyticsEventName.externalDonationsCreateOrganisationSelected,
            eventProperties: {'organisation_name': organisation.orgName},
          );
          Navigator.of(context).pop();
        },
        onCustomNameSelected: (name) {
          widget.cubit.selectCustomOrganisation(name);
          AnalyticsHelper.logEvent(
            eventName: AnalyticsEventName.externalDonationsCreateCustomOrganisationAdded,
            eventProperties: {'organisation_name': name},
          );
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
