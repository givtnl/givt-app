import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/avatars/cubit/avatars_cubit.dart';
import 'package:givt_app/features/family/features/registration/cubit/family_registration_cubit.dart';
import 'package:givt_app/features/family/features/registration/cubit/family_registration_custom.dart';
import 'package:givt_app/features/family/features/registration/widgets/accept_policy_row_us.dart';
import 'package:givt_app/features/family/features/registration/widgets/avatar_selection_bottomsheet.dart';
import 'package:givt_app/features/family/features/registration/widgets/random_avatar.dart';
import 'package:givt_app/features/family/features/registration/widgets/us_mobile_number_form_field.dart';
import 'package:givt_app/features/family/helpers/logout_helper.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/shared/widgets/outlined_text_form_field.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';

class UsSignUpPage extends StatefulWidget {
  const UsSignUpPage({
    super.key,
    this.email = '',
  });

  final String email;

  @override
  State<UsSignUpPage> createState() => _UsSignUpPageState();
}

class _UsSignUpPageState extends State<UsSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;

  bool _acceptPolicy = false;
  bool _obscureText = true;
  Country _selectedCountry = Country.us;

  final _cubit = getIt<FamilyRegistrationCubit>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.init();
  }

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    getIt<AvatarsCubit>().clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: _cubit,
      onLoading: (context) => const Scaffold(
        body: Center(child: CustomCircularProgressIndicator()),
      ),
      onData: registrationForm,
      onCustom: handleCustom,
    );
  }

  Widget registrationForm(BuildContext context, UserExt user) {
    final locals = AppLocalizations.of(context);
    // Show the form
    return FunScaffold(
      canPop: false,
      appBar: FunTopAppBar.primary99(
        leading: GivtBackButtonFlat(
          onPressedExt: () async {
            logout(context, fromLogoutBtn: true);
          },
        ),
        title: 'Enter your details',
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              backgroundColor: AppTheme.givtBlue,
              builder: (_) => const FAQBottomSheet(),
            ),
            icon: const Icon(
              FontAwesomeIcons.question,
              size: 26,
              color: AppTheme.primary30,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                RandomAvatar(
                  id: user.guid,
                  onClick: () {
                    AvatarSelectionBottomsheet.show(
                      context,
                      user.guid,
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildSignUpForm(locals),
                const Spacer(),
                _buildBottomWidgetGroup(locals, user),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void handleCustom(BuildContext context, FamilyRegistrationCustom custom) {
    switch (custom) {
      case FamilyRegistrationCustomSucces():
        context.pushReplacementNamed(FamilyPages.profileSelection.name);
    }
  }

  Future<void> _register(UserExt user) async {
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.registrationFilledInPersonalInfoSheetFilled,
        eventProperties: {
          'id': user.guid,
          'profile_country': _selectedCountry.countryCode,
        },
      ),
    );

    final avatar = getIt<AvatarsCubit>().state.getAvatarByKey(
          user.guid,
        );

    await _cubit.savePersonalInfo(
      email: _emailController.text,
      password: _passwordController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      country: _selectedCountry.countryCode,
      phoneNumber: _phoneNumberController.text,
      appLanguage: Localizations.localeOf(context).languageCode,
      countryCode: _selectedCountry.countryCode,
      profilePicture: avatar.fileName,
    );
  }

  bool get _isEnabled {
    if (_formKey.currentState == null) return false;
    if (_acceptPolicy == true && _formKey.currentState!.validate()) return true;
    return false;
  }

  Widget _buildBottomWidgetGroup(
    AppLocalizations locals,
    UserExt user,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AcceptPolicyRowUs(
          onTap: (value) {
            setState(() {
              _acceptPolicy = value!;
            });
          },
          checkBoxValue: _acceptPolicy,
        ),
        const SizedBox(height: 12),
        FunButton(
          isDisabled: !_isEnabled,
          onTap: _isEnabled ? () => _register(user) : null,
          text: 'Continue',
          analyticsEvent: AnalyticsEvent(
            AmplitudeEvents.registrationContinueAfterPersonalInfoClicked,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm(AppLocalizations locals) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedTextFormField(
            controller: _firstNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '';
              }
              if (!Util.nameFieldsRegEx.hasMatch(value)) {
                return '';
              }
              return null;
            },
            onChanged: (value) => setState(() {
              _formKey.currentState!.validate();
            }),
            hintText: AppLocalizations.of(context).firstName,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            errorStyle: const TextStyle(
              height: 0,
              fontSize: 0,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedTextFormField(
            controller: _lastNameController,
            onChanged: (value) => setState(() {
              _formKey.currentState!.validate();
            }),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '';
              }
              if (!Util.nameFieldsRegEx.hasMatch(value)) {
                return '';
              }
              return null;
            },
            hintText: AppLocalizations.of(context).surname,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            errorStyle: const TextStyle(
              height: 0,
              fontSize: 0,
            ),
          ),
          const SizedBox(height: 16),
          MobileNumberFormFieldUs(
            phone: _phoneNumberController,
            selectedCountryPrefix: _selectedCountry.prefix,
            hintText: 'Mobile number',
            onPhoneChanged: (String value) => setState(() {
              _formKey.currentState!.validate();
            }),
            onPrefixChanged: (String selected) {
              setState(() {
                _selectedCountry = Country.sortedCountries().firstWhere(
                  (Country country) => country.countryCode == selected,
                );
              });
            },
            formatter: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return '';
              }

              if (Country.us == _selectedCountry) {
                if (!Util.usPhoneNumberRegEx
                    .hasMatch(Util.formatPhoneNrUs(value))) {
                  return '';
                }
              }

              return null;
            },
          ),
          const SizedBox(height: 16),
          OutlinedTextFormField(
            controller: _passwordController,
            onChanged: (value) => setState(() {
              _formKey.currentState!.validate();
            }),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '';
              }
              if (value.length < 7) {
                return '';
              }
              if (value.contains(RegExp('[0-9]')) == false) {
                return '';
              }
              if (value.contains(RegExp('[A-Z]')) == false) {
                return '';
              }

              return null;
            },
            errorStyle: const TextStyle(
              height: 0,
              fontSize: 0,
            ),
            obscureText: _obscureText,
            hintText: AppLocalizations.of(context).password,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText
                    ? FontAwesomeIcons.solidEye
                    : FontAwesomeIcons.solidEyeSlash,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          BodySmallText.primary40(
            locals.passwordRule,
          ),
        ],
      ),
    );
  }
}
