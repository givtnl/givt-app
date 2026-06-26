import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/core/failures/failure.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/personal_summary/giving_goal_setup/models/giving_goal_setup_extra.dart';
import 'package:givt_app/features/personal_summary/giving_goal_setup/widgets/giving_goal_monthly_hint_banner.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/models/giving_goal.dart';
import 'package:givt_app/shared/repositories/giving_goal_repository.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class GivingGoalSetupPage extends StatefulWidget {
  const GivingGoalSetupPage({super.key});

  @override
  State<GivingGoalSetupPage> createState() => _GivingGoalSetupPageState();
}

class _GivingGoalSetupPageState extends State<GivingGoalSetupPage> {
  late final TextEditingController _amountController;
  final GivingGoalRepository _givingGoalRepository =
      getIt<GivingGoalRepository>();
  late final Country _country;
  final int _year = DateTime.now().year;
  String? _goalId;
  bool _isSaving = false;
  var _dependenciesReady = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dependenciesReady) {
      return;
    }
    _dependenciesReady = true;

    _country = Country.fromCode(context.read<AuthCubit>().state.user.country);

    final extra = GoRouterState.of(context).extra;
    final initialAmount = extra is GivingGoalSetupExtra
        ? extra.initialYearlyAmount
        : 0;
    _goalId = extra is GivingGoalSetupExtra ? extra.goalId : null;

    _amountController = TextEditingController(
      text: initialAmount > 0 ? initialAmount.toString() : '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  int? get _parsedAmount {
    final text = _amountController.text.trim();
    if (text.isEmpty) {
      return null;
    }
    return int.tryParse(text);
  }

  bool get _canConfirm {
    final amount = _parsedAmount;
    return amount != null && amount > 0 && amount <= 99999;
  }

  String? _monthlyHintText(BuildContext context) {
    final amount = _parsedAmount;
    if (amount == null || amount <= 0) {
      return null;
    }
    final monthlyAmount = (amount / 12).round();
    final currencySymbol =
        Util.getCurrencySymbol(countryCode: _country.countryCode);
    final formattedMonthly =
        '$currencySymbol${Util.formatNumberComma(monthlyAmount.toDouble(), _country)}';
    return context.l10n.personalSummaryGivingGoalSetupMonthlyHint(
      formattedMonthly,
    );
  }

  Future<void> _onConfirm() async {
    final amount = _parsedAmount;
    if (amount == null || _isSaving) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final body = GivingGoal(
        amount: amount,
        frequency: GivingGoalFrequency.annually,
      ).toJson();

      if (_goalId != null) {
        await _givingGoalRepository.updateGivingGoal(
          id: _goalId!,
          body: body,
        );
      } else {
        final goal = await _givingGoalRepository.addGivingGoal(body: body);
        _goalId = goal.id;
      }

      if (!mounted) {
        return;
      }

      await context.pushNamed(
        Pages.givingGoalSetupSuccess.name,
        extra: _year,
      );
      if (!mounted) {
        return;
      }
      context.pop(true);
    } on GivtServerFailure {
      _showError(context, isNoInternet: false);
      if (mounted) {
        setState(() => _isSaving = false);
      }
    } on SocketException {
      _showError(context, isNoInternet: true);
      if (mounted) {
        setState(() => _isSaving = false);
      }
    } catch (error, stackTrace) {
      LoggingInfo.instance.error(
        error.toString(),
        methodName: stackTrace.toString(),
      );
      _showError(context, isNoInternet: false);
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _onRemove() async {
    if (_goalId == null || _isSaving) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _givingGoalRepository.removeGivingGoal();
      if (!mounted) {
        return;
      }
      context.pop(true);
    } on GivtServerFailure {
      _showError(context, isNoInternet: false);
      if (mounted) {
        setState(() => _isSaving = false);
      }
    } on SocketException {
      _showError(context, isNoInternet: true);
      if (mounted) {
        setState(() => _isSaving = false);
      }
    } catch (error, stackTrace) {
      LoggingInfo.instance.error(
        error.toString(),
        methodName: stackTrace.toString(),
      );
      _showError(context, isNoInternet: false);
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showError(BuildContext context, {required bool isNoInternet}) {
    SnackBarHelper.showMessage(
      context,
      text: isNoInternet
          ? context.l10n.noInternet
          : context.l10n.somethingWentWrong,
      isError: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_dependenciesReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final locals = context.l10n;
    final theme = FunTheme.of(context);
    final currencySymbol =
        Util.getCurrencySymbol(countryCode: _country.countryCode);
    final monthlyHint = _monthlyHintText(context);

    return PopScope(
      canPop: !_isSaving,
      child: FunScaffold(
        appBar: FunTopAppBar(
          variant: FunTopAppBarVariant.white,
          title: locals.personalSummaryGivingGoalSetupTitle,
          leading: const SizedBox(width: 48),
          actions: [
            IconButton(
              icon: FaIcon(
                FontAwesomeIcons.xmark,
                color: theme.primary30,
              ),
              onPressed: _isSaving
                  ? null
                  : () {
                      AnalyticsHelper.logEvent(
                        eventName: AnalyticsEventName
                            .personalSummaryGivingGoalSetupCloseClicked,
                      );
                      context.pop();
                    },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    TitleMediumText(
                      locals.personalSummaryGivingGoalSetupQuestion(_year),
                      textAlign: TextAlign.center,
                      color: theme.secondary30,
                    ),
                    const SizedBox(height: 32),
                    FunInput(
                      controller: _amountController,
                      label: locals.personalSummaryGivingGoalSetupInputLabel,
                      hintText: locals.personalSummaryGivingGoalSetupAmountHint,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          Util.numberInputFieldRegExp(),
                        ),
                      ],
                      onChanged: (_) => setState(() {}),
                      prefixText: currencySymbol,
                      readOnly: _isSaving,
                    ),
                  ],
                ),
              ),
            ),
            if (monthlyHint != null) ...[
              GivingGoalMonthlyHintBanner(text: monthlyHint),
              const SizedBox(height: 12),
            ],
            if (_goalId != null) ...[
              FunButton(
                text: locals.budgetGivingGoalRemove,
                variant: FunButtonVariant.tertiary,
                isDisabled: _isSaving,
                analyticsEvent: AnalyticsEvent(
                  AnalyticsEventName.removeGivingGoalClicked,
                ),
                onTap: _isSaving ? null : () => unawaited(_onRemove()),
              ),
              const SizedBox(height: 12),
            ],
            FunButton(
              text: locals.confirm,
              isLoading: _isSaving,
              isDisabled: !_canConfirm || _isSaving,
              analyticsEvent: AnalyticsEvent(
                AnalyticsEventName.givingGoalSaved,
              ),
              onTap: !_canConfirm || _isSaving
                  ? null
                  : () => unawaited(_onConfirm()),
            ),
          ],
        ),
      ),
    );
  }
}
