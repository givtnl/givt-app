import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/amount_presets/widgets/widgets.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ChangeAmountPresetsBottomSheet extends StatefulWidget {
  const ChangeAmountPresetsBottomSheet({
    super.key,
  });

  @override
  State<ChangeAmountPresetsBottomSheet> createState() =>
      _ChangeAmountPresetsBottomSheetState();
}

class _ChangeAmountPresetsBottomSheetState
    extends State<ChangeAmountPresetsBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  bool _useAmountPresets = false;
  bool _showSuccess = false;
  bool _showPresetsSettings = false;
  bool _isLoading = false;

  // Controllers for preset amounts
  late TextEditingController _firstPreset;
  late TextEditingController _secondPreset;
  late TextEditingController _thirdPreset;
  late Country _countryCode;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthCubit>();
    _useAmountPresets = auth.state.presets.isEnabled;
    _countryCode = Country.fromCode(auth.state.user.country);

    final presets = auth.state.presets;
    _firstPreset = TextEditingController(
      text: Util.formatNumberComma(presets.presets[0].amount, _countryCode),
    );
    _secondPreset = TextEditingController(
      text: Util.formatNumberComma(presets.presets[1].amount, _countryCode),
    );
    _thirdPreset = TextEditingController(
      text: Util.formatNumberComma(presets.presets[2].amount, _countryCode),
    );
  }

  @override
  void dispose() {
    _firstPreset.dispose();
    _secondPreset.dispose();
    _thirdPreset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated && _isLoading) {
          setState(() {
            _showSuccess = true;
            _isLoading = false;
          });
          // Wait a moment before closing to show the success state
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              context.pop();
            }
          });
        }
      },
      builder: (context, state) {
        if (_isLoading) {
          return _buildLoadingSheet(context);
        }

        if (_showSuccess) {
          return _buildSuccessSheet(context);
        }

        if (_showPresetsSettings) {
          return _buildPresetsSettingsSheet(context);
        }

        return _buildMainSheet(context);
      },
    );
  }

  /// Builds the loading state UI
  Widget _buildLoadingSheet(BuildContext context) {
    return FunBottomSheet(
      title: context.l10n.amountPresetsTitle,
      icon: const CustomCircularProgressIndicator(),
      content: Column(
        children: [
          BodyMediumText(
            context.l10n.loadingTitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds the success state UI
  Widget _buildSuccessSheet(BuildContext context) {
    final locals = context.l10n;
    return FunBottomSheet(
      title: locals.amountPresetsTitle,
      icon: primaryCircleWithIcon(
        circleSize: 140,
        iconData: FontAwesomeIcons.check,
        iconSize: 48,
      ),
      content: Column(
        children: [
          BodyMediumText(
            context.l10n.success,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds the main sheet UI with enable/disable option
  Widget _buildMainSheet(BuildContext context) {
    final locals = context.l10n;
    return FunBottomSheet(
      title: locals.amountPresetsTitle,
      closeAction: () => context.pop(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          BodyMediumText(
            locals.amountPresetsChangingPresets,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildToggleSwitch(context),
          const SizedBox(height: 16),
          _buildChangePresetsButton(context),
          const SizedBox(height: 24),
        ],
      ),
      primaryButton: FunButton(
        text: locals.save,
        onTap: () {
          _updateAmountPresetsStatus(context);
        },
        analyticsEvent: AmplitudeEvents.onInfoRowClicked.toEvent(
          parameters: {
            'action': 'save_presets_status',
          },
        ),
      ),
    );
  }

  /// Builds the toggle switch for enabling/disabling presets
  Widget _buildToggleSwitch(BuildContext context) {
    final locals = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: BodyMediumText(
              locals.amountPresetsTitle,
            ),
          ),
          Switch(
            value: _useAmountPresets,
            activeColor: AppTheme.givtLightGreen,
            onChanged: (value) {
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvents.amountPresetsToggleClicked,
                eventProperties: {
                  'is_enabled': value,
                },
              );
              setState(() {
                _useAmountPresets = value;
              });
            },
          ),
        ],
      ),
    );
  }

  /// Builds the button to change presets
  Widget _buildChangePresetsButton(BuildContext context) {
    final locals = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: InkWell(
        onTap: _useAmountPresets
            ? () {
                setState(() {
                  _showPresetsSettings = true;
                });
              }
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BodyMediumText(
              locals.amountPresetsChangePresetsMenu,
              color: _useAmountPresets ? null : Colors.grey,
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: _useAmountPresets ? null : Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the preset settings sheet
  Widget _buildPresetsSettingsSheet(BuildContext context) {
    final locals = context.l10n;
    final amountLimit = context.read<AuthCubit>().state.user.amountLimit;
    final lowerLimit = Util.getLowerLimitByCountry(_countryCode);
    final currency = NumberFormat.simpleCurrency(
      name: _countryCode.currency,
    ).currencySymbol;

    return FunBottomSheet(
      title: locals.amountPresetsTitle,
      closeAction: () {
        setState(() {
          _showPresetsSettings = false;
        });
      },
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            BodyMediumText(
              locals.amountPresetsBody,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PresetFormField(
              controller: _firstPreset,
              amountLimit: amountLimit,
              lowerLimit: lowerLimit,
              currency: currency,
              onChanged: (_) => _formKey.currentState!.validate(),
            ),
            const SizedBox(height: 20),
            PresetFormField(
              controller: _secondPreset,
              amountLimit: amountLimit,
              lowerLimit: lowerLimit,
              currency: currency,
              onChanged: (_) => _formKey.currentState!.validate(),
            ),
            const SizedBox(height: 20),
            PresetFormField(
              controller: _thirdPreset,
              amountLimit: amountLimit,
              lowerLimit: lowerLimit,
              currency: currency,
              onChanged: (_) => _formKey.currentState!.validate(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      primaryButton: FunButton(
        text: locals.save,
        onTap: () => _saveAmountPresets(context),
        analyticsEvent: AmplitudeEvents.amountPresetsSaveClicked.toEvent(
          parameters: {
            'preset_1': _firstPreset.text,
            'preset_2': _secondPreset.text,
            'preset_3': _thirdPreset.text,
          },
        ),
      ),
    );
  }

  /// Updates the status (enabled/disabled) of amount presets
  void _updateAmountPresetsStatus(BuildContext context) {
    setState(() {
      _isLoading = true;
    });

    final auth = context.read<AuthCubit>();
    auth.updatePresets(
      presets: auth.state.presets.copyWith(
        isEnabled: _useAmountPresets,
      ),
    );
  }

  /// Saves the amount presets values
  void _saveAmountPresets(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final first = double.parse(_firstPreset.text.replaceAll(',', '.'));
    final second = double.parse(_secondPreset.text.replaceAll(',', '.'));
    final third = double.parse(_thirdPreset.text.replaceAll(',', '.'));

    final auth = context.read<AuthCubit>();
    final presets = auth.state.presets;
    auth.updatePresets(
      presets: presets.copyWith(
        presets: presets.presets.map((preset) {
          switch (preset.id) {
            case 1:
              return preset.copyWith(amount: first);
            case 2:
              return preset.copyWith(amount: second);
            case 3:
              return preset.copyWith(amount: third);
            default:
              return preset;
          }
        }).toList(),
      ),
    );
  }
}
