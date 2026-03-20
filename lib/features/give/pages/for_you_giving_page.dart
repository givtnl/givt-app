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
import 'package:givt_app/features/give/widgets/numeric_keyboard.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/warning_dialog.dart';
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
  final List<String> _goalTitles = [];
  int _expandedIndex = 0;
  int _selectedField = 0;
  bool _isLoadingGoals = true;
  bool _didStartGoalInitialization = false;

  String _decimalSeparator = ',';

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
                        ...List.generate(_goalTitles.length, (index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == _goalTitles.length - 1 ? 8 : 10,
                            ),
                            child: _buildAccordion(
                              context,
                              title: _goalTitles[index],
                              subtitle: context.l10n
                                  .forYouGivingCollectionSubtitle(
                                    index + 1,
                                  ),
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
                Align(
                  alignment: Alignment.center,
                  child: FunTextButton(
                    text: context.l10n.forYouGivingMoreGoals,
                    textColor: FunTheme.of(context).primary30,
                    prefixIcon: FaIcon(
                      FontAwesomeIcons.plus,
                      color: FunTheme.of(context).primary30,
                      size: 16,
                    ),
                    analyticsEvent: AnalyticsEventName
                        .forYouGivingContinueTapped
                        .toEvent(),
                    onTap: _openNextAccordion,
                  ),
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
    required String title,
    required String subtitle,
    required int index,
    required String currencySymbol,
    required GlobalKey accordionKey,
  }) {
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

  void _submit(BuildContext context, String namespace) {
    final userGuid = context.read<AuthCubit>().state.user.guid;
    final first = _controllers.isNotEmpty
        ? _parseAmount(_controllers[0].text)
        : 0.0;
    final second = _controllers.length > 1
        ? _parseAmount(_controllers[1].text)
        : 0.0;
    final third = _controllers.length > 2
        ? _parseAmount(_controllers[2].text)
        : 0.0;
    context.read<GiveBloc>().add(
      GiveAmountChanged(
        firstCollectionAmount: first,
        secondCollectionAmount: second,
        thirdCollectionAmount: third,
      ),
    );
    context.read<GiveBloc>().add(
      GiveOrganisationSelected(
        nameSpace: namespace,
        userGUID: userGuid,
      ),
    );
  }

  void _openNextAccordion() {
    setState(() {
      if (_expandedIndex < _goalTitles.length - 1) {
        _expandedIndex += 1;
        _selectedField = _expandedIndex;
      }
    });
    _scrollAccordionIntoView(_expandedIndex);
  }

  void _scrollAccordionIntoView(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ctx = _accordionKeys[index].currentContext;
      if (ctx == null) return;
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

  bool get _isLastAccordion => _expandedIndex >= _goalTitles.length - 1;

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
    final fallbackTitles = List.generate(
      3,
      (index) => context.l10n.forYouGivingCollectionTitle(index + 1),
      growable: false,
    );
    if (organisation == null) {
      _setupGoalInputs(fallbackTitles);
      return;
    }

    try {
      final repository = getIt<OrganisationGoalsRepository>();
      final response = await repository.fetchGoals(organisation.nameSpace);
      final allocationTitles = response.allocations
          .map((allocation) => allocation.allocationName.trim())
          .where((title) => title.isNotEmpty)
          .take(3)
          .toList(growable: false);
      _setupGoalInputs(
        allocationTitles.isEmpty ? fallbackTitles : allocationTitles,
      );
    } on Exception {
      _setupGoalInputs(fallbackTitles);
    }
  }

  void _setupGoalInputs(List<String> titles) {
    if (!mounted) return;
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers
      ..clear()
      ..addAll(
        List.generate(
          titles.length,
          (_) => TextEditingController(text: '0'),
          growable: false,
        ),
      );
    _accordionKeys
      ..clear()
      ..addAll(
        List.generate(
          titles.length,
          (_) => GlobalKey(),
          growable: false,
        ),
      );

    setState(() {
      _goalTitles
        ..clear()
        ..addAll(titles);
      _expandedIndex = 0;
      _selectedField = 0;
      _isLoadingGoals = false;
    });
  }
}
