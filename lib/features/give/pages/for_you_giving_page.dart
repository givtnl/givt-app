import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/country.dart';
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
      _sheetAvailableQrCodes.isNotEmpty;

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
    final country = Country.fromCode(
      context.read<AuthCubit>().state.user.country,
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
          onClear: () {
            setState(() {
              _controllers[index].text = '0';
            });
          },
        ),
      ),
    );
  }

  String _accordionSubtitle(
    BuildContext context, {
    required ForYouGoalLineKind line,
    required int index,
    required String currencySymbol,
  }) {
    final base = switch (line) {
      ForYouCollectionGoalLine(:final subtitleIndex) =>
        context.l10n.forYouGivingCollectionSubtitle(subtitleIndex),
      ForYouGeneralGoalLine() => context.l10n.forYouGivingGeneralGoal,
    };
    final raw = _controllers[index].text;
    if (_parseAmount(raw) <= 0) {
      return base;
    }
    final amountDisplay = '$currencySymbol$raw';
    return context.l10n.forYouGivingAccordionSubtitleWithAmount(
      base,
      amountDisplay,
    );
  }

  Widget _buildAmountInput(
    BuildContext context, {
    required String currencySymbol,
    required TextEditingController controller,
    required VoidCallback onClear,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: FunTheme.of(context).neutralVariant90,
          width: FunTheme.of(context).borderWidthThin,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: LabelLargeText(
              '$currencySymbol${controller.text}',
              color: FunTheme.of(context).neutral50,
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
    final allocations = response.allocations
        .where((a) => a.allocationName.trim().isNotEmpty)
        .take(3)
        .toList();
    if (allocations.isEmpty) {
      _setupFallbackLines();
      return;
    }

    final lines = <ForYouGoalLineKind>[
      for (var i = 0; i < allocations.length; i++)
        ForYouCollectionGoalLine(
          title: allocations[i].allocationName.trim(),
          subtitleIndex: i + 1,
          allocation: allocations[i],
        ),
    ];
    _applyLines(lines);
  }

  void _setupFallbackLines() {
    final lines = List<ForYouGoalLineKind>.generate(
      3,
      (i) => ForYouCollectionGoalLine(
        title: context.l10n.forYouGivingCollectionTitle(i + 1),
        subtitleIndex: i + 1,
        allocation: null,
      ),
    );
    _applyLines(lines);
  }

  void _applyLines(List<ForYouGoalLineKind> lines) {
    if (!mounted) {
      return;
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers
      ..clear()
      ..addAll(
        List.generate(
          lines.length,
          (_) => TextEditingController(text: '0'),
          growable: false,
        ),
      );
    _accordionKeys
      ..clear()
      ..addAll(
        List.generate(
          lines.length,
          (_) => GlobalKey(),
          growable: false,
        ),
      );

    setState(() {
      _goalLines = lines;
      _expandedIndex = 0;
      _selectedField = 0;
      _isLoadingGoals = false;
    });
  }
}
