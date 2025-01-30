import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/country.dart';
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: FunTopAppBar.primary99(
        title: 'Give',
        leading: const GivtBackButtonFlat(),
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: size.height,
              width: size.width,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (size.height > 780) widget.icon,
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
                        height:
                            FunNumericKeyboard.getHeight(context) + 118 + 54,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: keyboard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget presetRow() => Container(
        height: 54,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            presetButton(25),
            presetButton(50),
            presetButton(75),
            presetButton(100),
          ],
        ),
      );
  Widget presetButton(int amount) => InkWell(
        onTap: () {
          setState(() {
            _amount = amount;
            isActive = true;
            isPresetAmount = true;
          });
        },
        child: Container(
          width: MediaQuery.sizeOf(context).width / 4 - 16,
          height: 44,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: Center(
            child: LabelSmallText.secondary40(
              '\$$amount',
            ),
          ),
        ),
      );

  Widget keyboard() => SizedBox(
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
            presetRow(),
            FunNumericKeyboard(
              currencySymbol: Country.us.currency,
              textColor: FamilyAppTheme.secondary40,
              rightIcon: const Icon(
                FontAwesomeIcons.deleteLeft,
                color: FamilyAppTheme.secondary40,
              ),
              onPresetTap: (amount) {
                setState(() {
                  _amount = int.parse(amount);
                  isActive = true;
                });
              },
              onKeyboardTap: (value) {
                setState(() {
                  if (isActive) {
                    if (isPresetAmount) {
                      _amount = int.parse(value);
                    } else {
                      _amount = _amount * 10 + int.parse(value);
                    }
                  } else {
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
              hideLeftButton: true,
            ),
          ],
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
