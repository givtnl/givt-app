import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/amount_presets/models/models.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_text_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/models/models.dart';
import 'package:givt_app/features/give/utils/for_you_donation_transactions.dart';
import 'package:givt_app/features/give/widgets/for_you_more_general_goals_sheet.dart';
import 'package:givt_app/features/give/widgets/numeric_keyboard.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/warning_dialog.dart';
import 'package:givt_app/shared/models/organisation_goals.dart';
import 'package:givt_app/shared/repositories/organisation_goals_repository.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class ForYouGivingPage extends StatefulWidget {
  const ForYouGivingPage({
    required this.flowContext,
    super.key,
  });

  final ForYouFlowContext flowContext;

  @override
  State<ForYouGivingPage> createState() => _ForYouGivingPageState();
}

class _ForYouGivingPageState extends State<ForYouGivingPage> {
  final ScrollController _scrollController = ScrollController();
  final List<TextEditingController> _controllers = [];
  final List<GlobalKey> _accordionKeys = [];
  List<ForYouGoalLineKind> _goalLines = [];
  int _expandedIndex = 0;
  int _selectedField = 0;
  bool _isLoadingGoals = true;
  bool _didStartGoalInitialization = false;
  OrganisationGoalsResponse? _goalsResponse;

  String _decimalSeparator = ',';

  Set<String> get _addedGeneralMediumIds => {
    for (final line in _goalLines)
      if (line case ForYouGeneralGoalLine(:final qr)) qr.mediumId,
  };

  List<OrganisationQrCode> get _sheetAvailableQrCodes {
    final qrCodes = _goalsResponse?.qrCodes ?? const <OrganisationQrCode>[];
    return qrCodes
        .where(
          (q) => q.mediumId.isNotEmpty && q.allocationName.trim().isNotEmpty,
        )
        .where((q) => !_addedGeneralMediumIds.contains(q.mediumId))
        .toList();
  }

  bool get _showMoreGoalsLink =>
      !_isLoadingGoals &&
      _goalsResponse != null &&
      _goalsResponse!.qrCodes.isNotEmpty &&
      _sheetAvailableQrCodes.isNotEmpty &&
      !widget.flowContext.restrictToEntryQrGoal;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didStartGoalInitialization) {
      return;
    }
    _didStartGoalInitialization = true;
    _initializeGoals();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final organisation = widget.flowContext.selectedOrganisation;
    final auth = context.watch<AuthCubit>().state;
    final country = Country.fromCode(
      auth.user.country,
    );
    final currencySymbol = Util.getCurrencySymbol(
      countryCode: country.countryCode,
    );
    if (country.countryCode == Country.us.countryCode ||
        Country.unitedKingdomCodes().contains(country.countryCode)) {
      _decimalSeparator = '.';
    }

    if (organisation == null) {
      return FunScaffold(
        appBar: FunTopAppBar(
          variant: FunTopAppBarVariant.white,
          leading: const GivtBackButtonFlat(),
          title: context.l10n.somethingWentWrong,
        ),
        body: Center(
          child: BodyMediumText(context.l10n.somethingWentWrong),
        ),
      );
    }

    return BlocListener<GiveBloc, GiveState>(
      listener: (context, state) {
        if (state.status == GiveStatus.noInternetConnection) {
          context.goNamed(
            Pages.giveSucess.name,
            extra: {
              'isRecurringDonation': false,
              'orgName': organisation.orgName,
            },
          );
        }
        if (state.status == GiveStatus.error) {
          showDialog<void>(
            context: context,
            builder: (_) => WarningDialog(
              title: context.l10n.errorOccurred,
              content: context.l10n.errorContactGivt,
              onConfirm: () => context.pop(),
            ),
          );
        }
        if (state.status ==
            GiveStatus.donatedToSameOrganisationInLessThan30Seconds) {
          showDialog<void>(
            context: context,
            builder: (_) => WarningDialog(
              title: context.l10n.notSoFast,
              content: context.l10n.giftBetween30Sec,
              onConfirm: () => context.pop(),
            ),
          );
        }
        if (state.status == GiveStatus.readyToGive ||
            state.status == GiveStatus.processed) {
          context.goNamed(
            Pages.give.name,
            extra: context.read<GiveBloc>(),
          );
        }
      },
      child: FunScaffold(
        appBar: FunTopAppBar(
          variant: FunTopAppBarVariant.white,
          leading: const GivtBackButtonFlat(),
          title: organisation.orgName,
        ),
        body: BlocBuilder<GiveBloc, GiveState>(
          builder: (context, state) {
            final isLoading = state.status == GiveStatus.loading;
            if (_isLoadingGoals) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ...List.generate(_goalLines.length, (index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == _goalLines.length - 1 ? 8 : 10,
                            ),
                            child: _buildAccordion(
                              context,
                              line: _goalLines[index],
                              index: index,
                              currencySymbol: currencySymbol,
                              accordionKey: _accordionKeys[index],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                if (_showMoreGoalsLink)
                  FunTextButton(
                    text: context.l10n.forYouGivingMoreGoals,
                    textColor: FunTheme.of(context).primary30,
                    prefixIcon: FaIcon(
                      FontAwesomeIcons.plus,
                      color: FunTheme.of(context).primary30,
                      size: 16,
                    ),
                    analyticsEvent: AnalyticsEventName
                        .forYouGivingMoreGoalsLinkTapped
                        .toEvent(),
                    onTap: () => _onMoreGoalsTapped(context),
                  ),
                const SizedBox(height: 8),
                NumericKeyboard(
                  currencySymbol: currencySymbol,
                  presets: auth.presets.isEnabled
                      ? auth.presets.presets
                      : const <Preset>[],
                  onPresetTap: onPresetTapped,
                  onKeyboardTap: onNumberTapped,
                  leftButtonFn: onCommaTapped,
                  rightButtonFn: onBackspaceTapped,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (!_isLastAccordion) ...[
                      Expanded(
                        child: FunButton(
                          text: context.l10n.forYouGivingCompleteMyGiving,
                          variant: FunButtonVariant.secondary,
                          isDisabled: !_hasAnyAmount || isLoading,
                          analyticsEvent: AnalyticsEventName
                              .forYouGivingContinueTapped
                              .toEvent(),
                          onTap: () => _submit(context, organisation.nameSpace),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FunButton(
                          text: context.l10n.next,
                          isDisabled: isLoading,
                          isLoading: false,
                          analyticsEvent: AnalyticsEventName
                              .forYouGivingContinueTapped
                              .toEvent(),
                          onTap: _openNextAccordion,
                        ),
                      ),
                    ] else
                      Expanded(
                        child: FunButton(
                          text: context.l10n.forYouGivingCompleteMyGiving,
                          isDisabled: !_hasAnyAmount || isLoading,
                          isLoading: isLoading,
                          analyticsEvent: AnalyticsEventName
                              .forYouGivingContinueTapped
                              .toEvent(),
                          onTap: () => _submit(context, organisation.nameSpace),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAccordion(
    BuildContext context, {
    required ForYouGoalLineKind line,
    required int index,
    required String currencySymbol,
    required GlobalKey accordionKey,
  }) {
    final title = switch (line) {
      ForYouCollectionGoalLine(:final title) => title,
      ForYouGeneralGoalLine(:final qr) => qr.allocationName.trim(),
    };
    final subtitle = _accordionSubtitle(
      context,
      line: line,
      index: index,
      currencySymbol: currencySymbol,
    );

    return Container(
      key: accordionKey,
      child: FunAccordion(
        title: title,
        subtitle: subtitle,
        isExpanded: _expandedIndex == index,
        state: _expandedIndex == index
            ? FunAccordionState.active
            : FunAccordionState.collapsed,
        onHeaderTap: () {
          setState(() {
            _expandedIndex = index;
            _selectedField = index;
          });
          _scrollAccordionIntoView(index);
        },
        content: _buildAmountInput(
          context,
          currencySymbol: currencySymbol,
          controller: _controllers[index],
          isExpanded: _expandedIndex == index,
          amount: _parseAmount(_controllers[index].text),
          onClear: () {
            setState(() {
              _controllers[index].text = '0';
            });
          },
        ),
      ),
    );
  }

  String? _accordionSubtitle(
    BuildContext context, {
    required ForYouGoalLineKind line,
    required int index,
    required String currencySymbol,
  }) {
    final base = switch (line) {
      ForYouCollectionGoalLine(:final subtitleIndex, :final allocation) =>
        allocation == null || allocation.allocationName.trim().isEmpty
            ? null
            : context.l10n.forYouGivingCollectionSubtitle(subtitleIndex),
      ForYouGeneralGoalLine() => context.l10n.forYouGivingGeneralGoal,
    };

    final raw = _controllers[index].text;
    final amount = _parseAmount(raw);
    final amountDisplay = '$currencySymbol$raw';

    if (base == null) {
      return amount > 0 ? amountDisplay : null;
    }

    if (amount <= 0) {
      return base;
    }

    return context.l10n.forYouGivingAccordionSubtitleWithAmount(
      base,
      amountDisplay,
    );
  }

  Widget _buildAmountInput(
    BuildContext context, {
    required String currencySymbol,
    required TextEditingController controller,
    required bool isExpanded,
    required double amount,
    required VoidCallback onClear,
  }) {
    final theme = FunTheme.of(context);
    final isComplete = amount > 0;
    final borderColor = isComplete
        ? theme.primary30
        : isExpanded
            ? theme.primary70
            : theme.neutralVariant90;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: FunTheme.of(context).borderWidthThin,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: LabelLargeText(
              '$currencySymbol${controller.text}',
              color: FunTheme.of(context).primary20,
            ),
          ),
          IconButton(
            onPressed: onClear,
            icon: const Icon(Icons.remove_circle_outline),
          ),
        ],
      ),
    );
  }

  Future<void> _onMoreGoalsTapped(BuildContext context) async {
    final available = _sheetAvailableQrCodes;
    if (available.isEmpty) {
      return;
    }
    await ForYouMoreGeneralGoalsSheet.show(
      context: context,
      availableGoals: available,
      onConfirm: _appendGeneralGoals,
    );
  }

  void _appendGeneralGoals(List<OrganisationQrCode> selected) {
    if (selected.isEmpty || !mounted) {
      return;
    }
    setState(() {
      for (final qr in selected) {
        _goalLines.add(ForYouGeneralGoalLine(qr));
        _controllers.add(TextEditingController(text: '0'));
        _accordionKeys.add(GlobalKey());
      }
      final firstNew = _goalLines.length - selected.length;
      _expandedIndex = firstNew;
      _selectedField = firstNew;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _scrollAccordionIntoView(_expandedIndex);
    });
  }

  void _submit(BuildContext context, String namespace) {
    final userGuid = context.read<AuthCubit>().state.user.guid;
    final amounts = _controllers.map((c) => _parseAmount(c.text)).toList();
    final donations = buildForYouDonationTransactions(
      userGuid: userGuid,
      collectGroupNamespace: namespace,
      lines: _goalLines,
      amounts: amounts,
      collectionGoalsMediumIdOverride: widget.flowContext.entryMediumId,
    );
    if (donations.isEmpty) {
      return;
    }
    context.read<GiveBloc>().add(
      GiveForYouSubmitDonations(
        nameSpace: namespace,
        userGUID: userGuid,
        donations: donations,
      ),
    );
  }

  void _openNextAccordion() {
    setState(() {
      if (_expandedIndex < _goalLines.length - 1) {
        _expandedIndex += 1;
        _selectedField = _expandedIndex;
      }
    });
    _scrollAccordionIntoView(_expandedIndex);
  }

  void _scrollAccordionIntoView(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (index < 0 || index >= _accordionKeys.length) {
        return;
      }
      final ctx = _accordionKeys[index].currentContext;
      if (ctx == null) {
        return;
      }
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        alignment: 0.1,
      );
    });
  }

  double _parseAmount(String value) {
    final normalized = value.replaceAll(_decimalSeparator, '.');
    return double.tryParse(normalized) ?? 0;
  }

  bool get _hasAnyAmount =>
      _controllers.any((controller) => _parseAmount(controller.text) > 0);

  bool get _isLastAccordion => _expandedIndex >= _goalLines.length - 1;

  void onBackspaceTapped() {
    final controller = _controllers[_selectedField];
    if (controller.text.length <= 1) {
      setState(() {
        controller.text = '0';
      });
      return;
    }
    setState(() {
      controller.text = controller.text.substring(
        0,
        controller.text.length - 1,
      );
    });
  }

  void onCommaTapped() {
    final controller = _controllers[_selectedField];
    if (controller.text.contains(_decimalSeparator)) {
      return;
    }
    setState(() {
      controller.text = '${controller.text}$_decimalSeparator';
    });
  }

  void onNumberTapped(String value) {
    final controller = _controllers[_selectedField];
    setState(() {
      if (controller.text == '0') {
        controller.text = value;
      } else {
        controller.text = '${controller.text}$value';
      }
    });
  }

  void onPresetTapped(String amount) {
    setState(() {
      _controllers[_selectedField].text = amount;
    });
  }

  Future<void> _initializeGoals() async {
    final organisation = widget.flowContext.selectedOrganisation;
    if (organisation == null) {
      _setupFallbackLines();
      return;
    }

    try {
      final repository = getIt<OrganisationGoalsRepository>();
      final response = await repository.fetchGoals(organisation.nameSpace);
      if (!mounted) {
        return;
      }
      _goalsResponse = response;
      final restrict = widget.flowContext.restrictToEntryQrGoal;
      final entryMediumId = widget.flowContext.entryMediumId?.trim() ?? '';
      if (restrict && entryMediumId.isNotEmpty) {
        final match = response.qrCodes
            .where((q) => q.mediumId.trim() == entryMediumId)
            .toList();
        if (match.isNotEmpty) {
          _applyLines([ForYouGeneralGoalLine(match.first)]);
          return;
        }
      }
      _setupCollectionLinesFromResponse(response);
    } on Exception {
      if (!mounted) {
        return;
      }
      _goalsResponse = const OrganisationGoalsResponse();
      _setupFallbackLines();
    }
  }

  void _setupCollectionLinesFromResponse(OrganisationGoalsResponse response) {
    var lines = <ForYouGoalLineKind>[];
    final indexedAllocations = _extractIndexedAllocations(response.allocations);

    if (indexedAllocations.isEmpty) {
      final organisation = widget.flowContext.selectedOrganisation;
      final type = organisation?.type ?? CollectGroupType.none;
      final fallbackCount = _fallbackCollectionGoalCount(type);

      lines = [
        for (var i = 0; i < fallbackCount; i++)
          ForYouCollectionGoalLine(
            title: context.l10n.forYouGivingCollectionTitle(i + 1),
            subtitleIndex: i + 1,
            allocation: null,
          ),
      ];
    } else {
      lines = [
        for (final indexedAllocation in indexedAllocations)
          ForYouCollectionGoalLine(
            title: _resolveCollectionTitle(
              indexedAllocation.allocation,
              index: indexedAllocation.goalIndex,
            ),
            subtitleIndex: indexedAllocation.goalIndex,
            allocation: indexedAllocation.allocation,
          ),
      ];
    }

    _applyLines(lines);
  }

  List<_IndexedAllocation> _extractIndexedAllocations(
    List<OrganisationAllocation> allocations,
  ) {
    final perGoal = <int, OrganisationAllocation>{};

    for (var listIndex = 0; listIndex < allocations.length; listIndex++) {
      final allocation = allocations[listIndex];
      final parsedGoalIndex = int.tryParse(allocation.collectId);
      final resolvedGoalIndex =
          parsedGoalIndex != null && parsedGoalIndex >= 1 && parsedGoalIndex <= 3
          ? parsedGoalIndex
          : listIndex + 1;
      if (resolvedGoalIndex < 1 || resolvedGoalIndex > 3) {
        continue;
      }
      perGoal.putIfAbsent(resolvedGoalIndex, () => allocation);
    }

    final sortedGoalIndexes = perGoal.keys.toList()..sort();
    return [
      for (final goalIndex in sortedGoalIndexes)
        _IndexedAllocation(
          goalIndex: goalIndex,
          allocation: perGoal[goalIndex]!,
        ),
    ];
  }

  String _resolveCollectionTitle(
    OrganisationAllocation allocation, {
    required int index,
  }) {
    final allocationName = allocation.allocationName.trim();
    if (_isPlaceholderCollectionName(allocationName, fallbackIndex: index)) {
      return context.l10n.forYouGivingCollectionTitle(index);
    }
    return allocationName;
  }

  bool _isPlaceholderCollectionName(
    String allocationName, {
    required int fallbackIndex,
  }) {
    if (allocationName.isEmpty) {
      return true;
    }
    final normalizedName = allocationName.toLowerCase();
    final fallbackTitle = context.l10n
        .forYouGivingCollectionTitle(fallbackIndex)
        .trim()
        .toLowerCase();
    final fallbackSubtitle = context.l10n
        .forYouGivingCollectionSubtitle(fallbackIndex)
        .trim()
        .toLowerCase();
    return normalizedName == fallbackTitle ||
        normalizedName == fallbackSubtitle;
  }

  void _setupFallbackLines() {
    final organisation = widget.flowContext.selectedOrganisation;
    final collectGroupType = organisation?.type ?? CollectGroupType.none;
    final fallbackCount = _fallbackCollectionGoalCount(collectGroupType);
    final lines = <ForYouGoalLineKind>[
      for (var i = 0; i < fallbackCount; i++)
        ForYouCollectionGoalLine(
          title: context.l10n.forYouGivingCollectionTitle(i + 1),
          subtitleIndex: i + 1,
          allocation: null,
        ),
    ];
    _applyLines(lines);
  }

  int _fallbackCollectionGoalCount(CollectGroupType collectGroupType) {
    switch (collectGroupType) {
      case CollectGroupType.church:
        return 3;
      case CollectGroupType.charities:
      case CollectGroupType.campaign:
      case CollectGroupType.artists:
        return 1;
      default:
        return 3;
    }
  }

  void _applyLines(List<ForYouGoalLineKind> lines) {
    if (!mounted) {
      return;
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
    for (var i = 0; i < lines.length; i++) {
      _controllers.add(TextEditingController(text: '0'));
    }
    _accordionKeys.clear();
    for (var i = 0; i < lines.length; i++) {
      _accordionKeys.add(GlobalKey());
    }

    setState(() {
      _goalLines = lines;
      _expandedIndex = 0;
      _selectedField = 0;
      _isLoadingGoals = false;
    });
  }
}

class _IndexedAllocation {
  const _IndexedAllocation({
    required this.goalIndex,
    required this.allocation,
  });

  final int goalIndex;
  final OrganisationAllocation allocation;
}
