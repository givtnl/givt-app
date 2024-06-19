import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/app/pages.dart';
import 'package:givt_app/features/family/features/flows/cubit/flow_type.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/features/profiles/widgets/logout_icon_button.dart';
import 'package:givt_app/features/family/features/profiles/widgets/parent_overview_widget.dart';
import 'package:givt_app/features/family/features/profiles/widgets/profile_item.dart';
import 'package:givt_app/features/family/features/profiles/widgets/profiles_empty_state_widget.dart';
import 'package:givt_app/features/family/shared/widgets/coin_widget.dart';
import 'package:givt_app/features/family/shared/widgets/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/givt_back_button.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({
    super.key,
  });

  static const int maxVivibleProfiles = 6;

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final flow = context.read<FlowsCubit>().state;
    context.read<ProfilesCubit>().fetchAllProfiles();

    List<Widget> createGridItems(List<Profile> profiles) {
      final gridItems = <Widget>[];
      for (var i = 0;
          i < profiles.length && i < ProfileSelectionScreen.maxVivibleProfiles;
          i++) {
        gridItems.add(
          GestureDetector(
            onTap: () {
              context.read<ProfilesCubit>().fetchProfile(profiles[i].id, true);
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvents.profilePressed,
                eventProperties: {
                  'profile_name':
                      '${profiles[i].firstName} ${profiles[i].lastName}',
                },
              );

              if (flow.isQRCode) {
                context.pushNamed(FamilyPages.camera.name);
                return;
              }
              if (flow.isRecommendation) {
                context.pushNamed(FamilyPages.recommendationStart.name);
                return;
              }
              if (flow.flowType == FlowType.deepLinkCoin) {
                context.pushNamed(FamilyPages.familyChooseAmountSlider.name);
                return;
              }
              if (flow.isCoin) {
                context.pushNamed(FamilyPages.scanNFC.name);
                return;
              }

              context.pushReplacementNamed(FamilyPages.wallet.name);
            },
            child: ProfileItem(
              name: profiles[i].firstName,
              imageUrl: profiles[i].pictureURL,
            ),
          ),
        );
      }
      return gridItems;
    }

    return BlocConsumer<ProfilesCubit, ProfilesState>(
      listener: (context, state) {
        if (state is ProfilesExternalErrorState) {
          log(state.errorMessage);
          SnackBarHelper.showMessage(
            context,
            text: 'Cannot download profiles. Please try again later.',
            isError: true,
          );
        } else if (state is ProfilesNotSetupState) {
          context.pushNamed(FamilyPages.childrenOverview.name);
        } else if (state is ProfilesNeedsPersonalInfoRegistration) {
          context.pushNamed(FamilyPages.registrationUS.name);
        } else if (state is ProfilesNeedsCreditCardRegistration) {
          context.goNamed(
            FamilyPages.creditCardDetails.name,
            extra: context.read<RegistrationBloc>(),
          );
        }
      },
      listenWhen: (previous, current) => _shouldOnlyListen(current),
      buildWhen: (previous, current) => !_shouldOnlyListen(current),
      builder: (context, state) {
        final gridItems = createGridItems(
          state.profiles.where((e) => e.type == 'Child').toList(),
        );
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: (flow.flowType == FlowType.none &&
                    state is! ProfilesLoadingState)
                ? const LogoutIconButton()
                : const GivtBackButton(),
            title: Text(
              'My Family',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            actions: [
              if (flow.isCoin) const CoinWidget(),
            ],
          ),
          body: state is ProfilesLoadingState
              ? const CustomCircularProgressIndicator()
              : state.children.isEmpty && state.parents.isEmpty
                  ? ProfilesEmptyStateWidget(
                      onRetry: () => context
                          .read<ProfilesCubit>()
                          .fetchAllProfiles(isRetry: true),
                    )
                  : SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            if (flow.flowType == FlowType.none)
                              ParentOverviewWidget(
                                profiles: state.parents,
                              )
                            else
                              SizedBox(
                                height: MediaQuery.sizeOf(context).height * 0.1,
                              ),
                           if(gridItems.isNotEmpty) const Text(
                              'Who would like to give?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppTheme.defaultTextColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            if(gridItems.isNotEmpty) SingleChildScrollView(
                              child: GridView.count(
                                shrinkWrap: true,
                                childAspectRatio: 0.74,
                                crossAxisCount:
                                    gridItems.length < 3 ? gridItems.length : 3,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20,
                                children: gridItems,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        );
      },
    );
  }

  bool _shouldOnlyListen(ProfilesState current) {
    return current is ProfilesNotSetupState ||
        current is ProfilesNeedsPersonalInfoRegistration ||
        current is ProfilesNeedsCreditCardRegistration;
  }

  @override
  void initState() {
    super.initState();
    AnalyticsHelper.setFamilyAppTracking();
  }
}
