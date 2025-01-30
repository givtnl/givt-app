import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/features/auth/bloc/family_auth_cubit.dart';
import 'package:givt_app/features/family/features/auth/presentation/models/family_auth_state.dart';
import 'package:givt_app/features/family/features/creditcard_setup/pages/credit_card_details.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_numeric_keyboard.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/family/utils/family_auth_utils.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

class ParentAmountPage extends StatefulWidget {
  const ParentAmountPage({
    required this.currency,
    required this.organisationName,
    required this.icon,
    this.authcheck = false,
    super.key,
  });

  final String currency;
  final String organisationName;
  final FunIcon icon;
  final bool authcheck;

  @override
  State<ParentAmountPage> createState() => _ParentAmountPageState();
}

class _ParentAmountPageState extends State<ParentAmountPage> {
  final initialamount = 25;
  bool isActive = false;
  bool isPresetAmount = false;
  late int _amount;

  @override
  void initState() {
    super.initState();
    _amount = initialamount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FunTopAppBar.primary99(
        title: 'Give',
        leading: const GivtBackButtonFlat(),
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Stack(
          children: [
            _contentColumn(),
            _inputBottomColumn(),
          ],
        ),
      ),
    );
  }

  Widget _contentColumn() => Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (MediaQuery.of(context).size.height > 780) widget.icon,
                const SizedBox(height: 16),
                TitleLargeText(
                  widget.organisationName,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const BodyMediumText(
                  'How much would you like to give?',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                DisplayMediumText(
                  '${widget.currency} $_amount',
                  textAlign: TextAlign.center,
                  color: isActive
                      ? FamilyAppTheme.primary40
                      : FamilyAppTheme.neutral70,
                ),
                SizedBox(
                  height: FunNumericKeyboard.getHeight(context) + 118 + 54,
                ),
              ],
            ),
          ),
        ),
      );
  Widget _inputBottomColumn() => Positioned(
        bottom: 0,
        child: SizedBox(
          height: FunNumericKeyboard.getHeight(context) + 118 + 54,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 118,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: FunButton(
                    onTap: widget.authcheck
                        ? () async {
                            await FamilyAuthUtils.authenticateUser(
                              context,
                              checkAuthRequest: FamilyCheckAuthRequest(
                                navigate: (context) async {
                                  _checkCardDetailsAndNavigate(context);
                                },
                              ),
                            );
                          }
                        : () {
                            _checkCardDetailsAndNavigate(context);
                          },
                    text: 'Give',
                    isDisabled: !isActive,
                    analyticsEvent: AnalyticsEvent(
                      AmplitudeEvents.parentGiveClicked,
                    ),
                  ),
                ),
              ),
              FunNumericKeyboard(
                presets: const [25, 50, 75, 100],
                onPresetTap: (amount) {
                  setState(() {
                    _amount = int.parse(amount);
                    isActive = true;
                    isPresetAmount = true;
                  });
                },
                onKeyboardTap: (value) {
                  setState(() {
                    if (isActive) {
                      // overwriting a previously selected preset
                      if (isPresetAmount) {
                        _amount = int.parse(value);
                        isPresetAmount = false;
                      } else {
                        // normal typing
                        _amount = _amount * 10 + int.parse(value);
                      }
                    } else {
                      // overwriting the placeholder amount
                      isActive = true;
                      _amount = int.parse(value);
                    }
                  });
                },
                rightButtonFn: () {
                  setState(() {
                    _amount = _amount ~/ 10;
                    if (_amount < 2) {
                      isActive = false;
                    }
                  });
                },
              ),
            ],
          ),
        ),
      );

  void _checkCardDetailsAndNavigate(BuildContext context) {
    if ((context.read<FamilyAuthCubit>().state as Authenticated)
        .user
        .isMissingcardDetails) {
      CreditCardDetails.show(
        context,
        onSuccess: () => Navigator.of(context).pop(_amount),
      );
      return;
    }
    Navigator.of(context).pop(_amount);
  }
}
