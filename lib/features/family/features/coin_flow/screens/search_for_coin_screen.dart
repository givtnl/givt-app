import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/coin_flow/cubit/search_coin_cubit.dart';
import 'package:givt_app/features/family/features/coin_flow/widgets/coin_error_page.dart';
import 'package:givt_app/features/family/features/coin_flow/widgets/coin_found_page.dart';
import 'package:givt_app/features/family/features/coin_flow/widgets/coin_search_page.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app/shared/widgets/buttons/fun_button.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class SearchForCoinScreen extends StatelessWidget {
  const SearchForCoinScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final coinCubit = context.read<SearchCoinCubit>();
    return BlocBuilder<SearchCoinCubit, SearchCoinState>(
      builder: (context, coinState) {
        return BlocConsumer<OrganisationDetailsCubit, OrganisationDetailsState>(
          listener: (context, orgState) async {
            if (orgState is OrganisationDetailsSetState) {
              log('Organisation is set: ${orgState.organisation.name}');
              coinCubit.stopAnimation();
            }
            if (orgState is OrganisationDetailsErrorState) {
              coinCubit.error();
              SnackBarHelper.showMessage(
                context,
                text: 'Error setting organisation. Please try again later.',
                isError: true,
              );
            }
          },
          builder: (BuildContext context, orgState) {
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
              ),
              body: coinState.status == CoinAnimationStatus.animating
                  ? const SearchingForCoinPage()
                  : coinState.status == CoinAnimationStatus.error
                      ? const CoinErrorPage()
                      : const CoinFoundPage(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton:
                  coinState.status == CoinAnimationStatus.stopped
                      ? FunButton(
                          text: 'Assign the coin',
                          onTap: () {
                            AnalyticsHelper.logEvent(
                              eventName: AmplitudeEvents.assignCoinPressed,
                            );

                            // TODO(MAIKEL):  Is it still needed to check?
                            // final isLoggedIn =
                            //     context.read<AuthCubit>().state is LoggedInState;
                            // final pageName = isLoggedIn
                            //     ? Pages.profileSelection.name
                            //     : Pages.login.name;
                            final pageName = FamilyPages.profileSelection.name;

                            context.read<FlowsCubit>().startDeepLinkCoinFlow();

                            context.pushNamed(pageName);
                          },
                        )
                      : null,
            );
          },
        );
      },
    );
  }
}
