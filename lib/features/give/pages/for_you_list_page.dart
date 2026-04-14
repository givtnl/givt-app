import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/widgets/organisation_list_family_content.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class ForYouListPage extends StatefulWidget {
  const ForYouListPage({
    required this.flowContext,
    super.key,
  });

  final ForYouFlowContext flowContext;

  @override
  State<ForYouListPage> createState() => _ForYouListPageState();
}

class _ForYouListPageState extends State<ForYouListPage> {
  CollectGroup _selectedOrganisation = const CollectGroup.empty();

  bool _favoritesTutorialShownThisVisit = false;
  bool _isFavoritesTutorialDialogOpen = false;

  bool get _isFavoritesOnlyMode =>
      widget.flowContext.source == ForYouEntrySource.emptyState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = context.read<OrganisationBloc>().state;
      _onOrganisationStateChanged(context, state);
    });
  }

  void _onOrganisationStateChanged(
    BuildContext context,
    OrganisationState state,
  ) {
    if (_isFavoritesTutorialDialogOpen &&
        state.favoritedOrganisations.isNotEmpty) {
      final navigator = Navigator.of(context, rootNavigator: true);
      if (navigator.canPop()) {
        navigator.pop();
      }
      return;
    }

    if (_favoritesTutorialShownThisVisit) return;
    if (state.status != OrganisationStatus.filtered) return;
    if (state.favoritedOrganisations.isNotEmpty) return;

    _favoritesTutorialShownThisVisit = true;
    _isFavoritesTutorialDialogOpen = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      AnalyticsHelper.logEvent(
        eventName: AnalyticsEventName.forYouFavoritesTutorialShown,
      );
      FunModal(
        icon: SizedBox(
          height: 140,
          width: double.infinity,
          child: Lottie.asset(
            'assets/lotties/for_you_favorites_tutorial.json',
            fit: BoxFit.contain,
            repeat: false,
          ),
        ),
        title: context.l10n.forYouFavoritesTutorialTitle,
        subtitle: context.l10n.forYouFavoritesTutorialBody,
        buttons: [
          FunButton(
            text: context.l10n.forYouFavoritesTutorialGotIt,
            analyticsEvent:
                AnalyticsEventName.forYouFavoritesTutorialGotItTapped
                    .toEvent(),
            onTap: () => context.pop(),
          ),
        ],
      ).show(context).whenComplete(() {
        if (mounted) {
          setState(() {
            _isFavoritesTutorialDialogOpen = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrganisationBloc, OrganisationState>(
      listener: _onOrganisationStateChanged,
      child: Scaffold(
        appBar: FunTopAppBar(
          variant: FunTopAppBarVariant.white,
          leading: const GivtBackButtonFlat(),
          title: context.l10n.forYouSearchOrganizations,
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OrganisationListFamilyContent(
                  bloc: context.read<OrganisationBloc>(),
                  onTapListItem: (collectGroup) {
                    setState(() {
                      _selectedOrganisation = collectGroup;
                    });
                  },
                  removedCollectGroupTypes: const [],
                  showFavorites: true,
                  autoFocusSearch: true,
                  allowSelection: !_isFavoritesOnlyMode,
                  reSortOnFavoriteToggle: false,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: FunButton(
                text: _isFavoritesOnlyMode
                    ? context.l10n.buttonDone
                    : context.l10n.selectReceiverButton,
                isDisabled: !_isFavoritesOnlyMode &&
                    _selectedOrganisation == const CollectGroup.empty(),
                analyticsEvent: _isFavoritesOnlyMode
                    ? AnalyticsEventName.forYouFavoritesDoneTapped.toEvent()
                    : AnalyticsEventName.forYouOrganisationSelected.toEvent(),
                onTap: () {
                  if (_isFavoritesOnlyMode) {
                    context.pop();
                    return;
                  }

                  if (_selectedOrganisation == const CollectGroup.empty()) {
                    return;
                  }

                  context.goNamed(
                    Pages.forYouGiving.name,
                    extra: widget.flowContext
                        .copyWith(
                          selectedOrganisation: _selectedOrganisation,
                        )
                        .toMap(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
