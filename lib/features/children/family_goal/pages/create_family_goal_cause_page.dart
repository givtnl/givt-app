import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/children/family_goal/cubit/create_family_goal_cubit.dart';
import 'package:givt_app/features/children/family_goal/widgets/family_goal_creation_stepper.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/organisation/organisation.dart';
import 'package:givt_app/shared/widgets/buttons/custom_green_elevated_button.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateFamilyGoalCausePage extends StatefulWidget {
  const CreateFamilyGoalCausePage({
    super.key,
  });

  @override
  State<CreateFamilyGoalCausePage> createState() =>
      _CreateFamilyGoalCausePageState();
}

class _CreateFamilyGoalCausePageState extends State<CreateFamilyGoalCausePage> {
  final focusNode = FocusNode();
  final OrganisationBloc organisationBloc = getIt<OrganisationBloc>();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return BlocBuilder<OrganisationBloc, OrganisationState>(
      builder: (context, state) {
        if (state.selectedType == CollectGroupType.none.index) {
          focusNode.requestFocus();
        }
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              context.l10n.familyGoalCauseTitle,
              style: GoogleFonts.mulish(
                textStyle:
                    Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
              ),
            ),
            leading: BackButton(
              color: AppTheme.givtBlue,
              onPressed: () {
                AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.backClicked,
                );
                context.read<CreateFamilyGoalCubit>().showOverview();
              },
            ),
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FamilyGoalCreationStepper(
                  currentStep: FamilyGoalCreationStatus.cause,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: CupertinoSearchTextField(
                    autocorrect: false,
                    focusNode: focusNode,
                    onChanged: (value) => organisationBloc.add(OrganisationFilterQueryChanged(value)),
                    placeholder: locals.searchHere,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: const Icon(Icons.close),
                  ),
                ),
                if (state.status == OrganisationStatus.filtered)
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (_, index) => const Divider(
                        height: 0.1,
                      ),
                      shrinkWrap: true,
                      itemCount: state.filteredOrganisations.length,
                      itemBuilder: (context, index) {
                        return _buildListTile(
                          type: state.filteredOrganisations[index].type,
                          title: state.filteredOrganisations[index].orgName,
                          isSelected: state.selectedCollectGroup.nameSpace ==
                              state.filteredOrganisations[index].nameSpace,
                          onTap: () {
                            organisationBloc.add(
                                  OrganisationSelectionChanged(
                                    state
                                        .filteredOrganisations[index].nameSpace,
                                  ),
                                );
                          },
                        );
                      },
                    ),
                  )
                else
                  const Center(child: CircularProgressIndicator.adaptive()),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: CustomElevatedButton(
              title: context.l10n.continueKey,
              onPressed: state.selectedCollectGroup.type ==
                      CollectGroupType.none
                  ? null
                  : () {
                      context.read<CreateFamilyGoalCubit>()
                        ..selectCause(
                          meduimId: state.selectedCollectGroup.nameSpace,
                          organisationName: state.selectedCollectGroup.orgName,
                        )
                        ..showAmount();

                      AnalyticsHelper.logEvent(
                        eventName: AmplitudeEvents.familyGoalCauseSet,
                        eventProperties: {
                          'charity_name': state.selectedCollectGroup.orgName,
                        },
                      );
                    },
            ),
          ),
        );
      },
    );
  }

  Widget _buildListTile({
    required VoidCallback onTap,
    required bool isSelected,
    required String title,
    required CollectGroupType type,
  }) =>
      ListTile(
        key: UniqueKey(),
        onTap: onTap,
        selected: isSelected,
        selectedTileColor: AppTheme.givtLightGreen.withOpacity(0.25),
        //temporary solution with svgs
        //let's replace with fontawesomeicons (pro) when possible
        leading: SvgPicture.asset(
          'assets/images/home_with_heart.svg',
          height: 22,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppTheme.givtBlue,
          ),
        ),
      );
}
