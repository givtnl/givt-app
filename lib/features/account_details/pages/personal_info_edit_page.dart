import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/account_details/account_settings_actions.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/account_details/pages/change_address_bottom_sheet.dart';
import 'package:givt_app/features/account_details/pages/change_bank_details_bottom_sheet.dart';
import 'package:givt_app/features/account_details/pages/change_email_address_bottom_sheet.dart';
import 'package:givt_app/features/account_details/pages/change_name_bottom_sheet.dart';
import 'package:givt_app/features/account_details/pages/change_phone_number_bottom_sheet.dart';
import 'package:givt_app/features/account_details/widgets/account_settings_avatar.dart';
import 'package:givt_app/features/account_details/widgets/account_settings_list_item.dart';
import 'package:givt_app/features/account_details/widgets/account_settings_section_header.dart';
import 'package:givt_app/features/account_details/widgets/personal_info_edit_feedback_listener.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/creditcard_setup/cubit/stripe_cubit.dart';
import 'package:givt_app/features/family/features/reset_password/presentation/pages/reset_password_sheet.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/design_system/design_system.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/shared/widgets/sort_code_text_formatter.dart';
import 'package:givt_app/utils/stripe_helper.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class PersonalInfoEditPage extends StatelessWidget {
  const PersonalInfoEditPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final user = context.watch<AuthCubit>().state.user;

    return FunScaffold(
      minimumPadding: EdgeInsets.zero,
      appBar: FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        title: locals.accountSettingsTitle,
        leading: const GivtBackButtonFlat(),
      ),
      body: PersonalInfoEditFeedbackListener(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Center(
                child: AccountSettingsAvatar(user: user),
              ),
              const SizedBox(height: 24),
              _PersonalDetailsSection(
                user: user,
                onShowBottomSheet: (bottomSheet) =>
                    _showModalBottomSheet(context, bottomSheet: bottomSheet),
                onOpenStripePayment: () => _openStripePayment(context),
              ),
              const SizedBox(height: 24),
              _SecuritySection(
                user: user,
                onShowBottomSheet: (bottomSheet) =>
                    _showModalBottomSheet(context, bottomSheet: bottomSheet),
              ),
              if (!user.needRegistration) ...[
                const SizedBox(height: 24),
                _PreferencesSection(user: user),
              ],
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FunButton(
                  text: locals.unregister,
                  variant: FunButtonVariant.destructiveSecondary,
                  onTap: () => AccountSettingsActions.openUnregister(context),
                  analyticsEvent: AnalyticsEventName
                      .accountSettingsTerminateClicked
                      .toEvent(),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openStripePayment(BuildContext context) async {
    await AnalyticsHelper.logEvent(
      eventName: AnalyticsEventName.editPaymentDetailsClicked,
    );

    if (!context.mounted) return;
    await getIt<StripeCubit>().fetchSetupIntent();

    if (!context.mounted) return;

    try {
      await StripeHelper(context).showPaymentSheet();

      if (!context.mounted) return;
      await context.read<AuthCubit>().refreshUser();
    } on StripeException catch (e, stackTrace) {
      await AnalyticsHelper.logEvent(
        eventName: AnalyticsEventName.editPaymentDetailsCanceled,
      );
      LoggingInfo.instance.info(
        e.toString(),
        methodName: stackTrace.toString(),
      );
    }
  }

  Future<void> _showModalBottomSheet(
    BuildContext context, {
    required Widget bottomSheet,
  }) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => BlocProvider.value(
          value: context.read<PersonalInfoEditBloc>(),
          child: bottomSheet,
        ),
      );
}

class _PersonalDetailsSection extends StatelessWidget {
  const _PersonalDetailsSection({
    required this.user,
    required this.onShowBottomSheet,
    required this.onOpenStripePayment,
  });

  final UserExt user;
  final void Function(Widget bottomSheet) onShowBottomSheet;
  final Future<void> Function() onOpenStripePayment;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final theme = FunTheme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isUkUser = Country.unitedKingdomCodes().contains(user.country);
    final isUsCard = Country.fromCode(user.country).isCreditCard;
    final iconColor = theme.primary20;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AccountSettingsSectionHeader(title: locals.accountSettingsPersonalDetails),
        AccountSettingsListItem(
          value: '${user.firstName} ${user.lastName}',
          leading: FaIcon(FontAwesomeIcons.user, size: 20, color: iconColor),
          analyticsEvent: AnalyticsEventName.onInfoRowClicked.toEvent(
            parameters: {'row_type': 'name'},
          ),
          onTap: () => onShowBottomSheet(
            ChangeNameBottomSheet(
              firstName: user.firstName,
              lastName: user.lastName,
            ),
          ),
        ),
        AccountSettingsListItem(
          value: user.email,
          leading: FaIcon(FontAwesomeIcons.envelope, size: 20, color: iconColor),
          analyticsEvent: AnalyticsEventName.onInfoRowClicked.toEvent(
            parameters: {'row_type': 'email'},
          ),
          onTap: () => onShowBottomSheet(
            ChangeEmailAddressBottomSheet(email: user.email),
          ),
        ),
        AccountSettingsListItem(
          value:
              '${user.address}\n${user.postalCode} ${user.city}, '
              '${Country.getCountry(user.country, locals)}',
          maxLines: 3,
          leading: FaIcon(FontAwesomeIcons.house, size: 20, color: iconColor),
          analyticsEvent: AnalyticsEventName.onInfoRowClicked.toEvent(
            parameters: {'row_type': 'address'},
          ),
          onTap: () => onShowBottomSheet(
            ChangeAddressBottomSheet(
              address: user.address,
              postalCode: user.postalCode,
              city: user.city,
              country: user.country,
            ),
          ),
        ),
        AccountSettingsListItem(
          value: user.phoneNumber,
          leading: FaIcon(FontAwesomeIcons.phone, size: 20, color: iconColor),
          analyticsEvent: AnalyticsEventName.onInfoRowClicked.toEvent(
            parameters: {'row_type': 'phone'},
          ),
          onTap: () => onShowBottomSheet(
            ChangePhoneNumberBottomSheet(
              country: user.country,
              phoneNumber: user.phoneNumber,
            ),
          ),
        ),
        if (isUsCard)
          AccountSettingsListItem(
            value: user.accountNumber.isEmpty
                ? locals.enterPaymentDetails
                : '${user.accountBrand.toUpperCase()} ${user.accountNumber}',
            leading: FaIcon(
              FontAwesomeIcons.creditCard,
              size: 20,
              color: iconColor,
            ),
            analyticsEvent: AnalyticsEventName.onInfoRowClicked.toEvent(
              parameters: {'row_type': 'bank_details'},
            ),
            onTap: onOpenStripePayment,
          )
        else
          AccountSettingsListItem(
            value: isUkUser
                ? locals.bacsSortcodeAccountnumber(
                    SortCodeTextFormatter.formatForDisplay(user.sortCode),
                    user.accountNumber,
                  )
                : user.iban,
            leading: FaIcon(
              FontAwesomeIcons.buildingColumns,
              size: 20,
              color: user.mandateSigned ? iconColor : theme.neutralVariant60,
            ),
            analyticsEvent: user.mandateSigned
                ? AnalyticsEventName.onInfoRowClicked.toEvent(
                    parameters: {'row_type': 'bank_details'},
                  )
                : null,
            onTap: user.mandateSigned
                ? () => onShowBottomSheet(
                      ChangeBankDetailsBottomSheet(
                        sortCode: user.sortCode,
                        accountNumber: user.accountNumber,
                        iban: user.iban,
                      ),
                    )
                : null,
          ),
        if (isUkUser)
          AccountSettingsListItem(
            value: 'Gift Aid',
            leading: Image.asset(
              'assets/images/gift_aid_yellow.png',
              height: size.height * 0.04,
            ),
            analyticsEvent: AnalyticsEventName.onInfoRowClicked.toEvent(
              parameters: {'row_type': 'gift_aid'},
            ),
            onTap: () => context.pushNamed(Pages.manageGiftAid.name),
          ),
      ],
    );
  }
}

class _SecuritySection extends StatelessWidget {
  const _SecuritySection({
    required this.user,
    required this.onShowBottomSheet,
  });

  final UserExt user;
  final void Function(Widget bottomSheet) onShowBottomSheet;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final theme = FunTheme.of(context);
    final iconColor = theme.primary20;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AccountSettingsSectionHeader(title: locals.accountSettingsSecurity),
        AccountSettingsListItem(
          value: locals.changePassword,
          leading: FaIcon(FontAwesomeIcons.lock, size: 20, color: iconColor),
          analyticsEvent: AnalyticsEventName.onInfoRowClicked.toEvent(
            parameters: {'row_type': 'password'},
          ),
          onTap: () => onShowBottomSheet(
            ResetPasswordSheet(initialEmail: user.email),
          ),
        ),
        _BiometricSettingsRow(user: user),
      ],
    );
  }
}

class _BiometricSettingsRow extends StatelessWidget {
  const _BiometricSettingsRow({required this.user});

  final UserExt user;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final theme = FunTheme.of(context);
    final iconColor = theme.primary20;

    return FutureBuilder<List<bool>>(
      future: Future.wait<bool>([
        LocalAuthInfo.instance.checkFingerprint(),
        LocalAuthInfo.instance.checkFaceId(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final isFingerprintAvailable = snapshot.data![0];
        final isFaceIdAvailable = snapshot.data![1];
        final shouldShow =
            (isFingerprintAvailable || isFaceIdAvailable) && !user.tempUser;

        if (!shouldShow) {
          return const SizedBox.shrink();
        }

        final label = isFingerprintAvailable
            ? Platform.isAndroid
                ? locals.fingerprintTitle
                : locals.touchId
            : locals.faceId;

        return AccountSettingsListItem(
          value: label,
          leading: Platform.isIOS && isFaceIdAvailable
              ? SvgPicture.asset(
                  'assets/images/face_id.svg',
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                )
              : Icon(Icons.fingerprint, size: 20, color: iconColor),
          analyticsEvent: AnalyticsEventName.onInfoRowClicked.toEvent(
            parameters: {'row_type': 'biometric'},
          ),
          onTap: () => AccountSettingsActions.openBiometricSetup(
            context,
            isFingerprint: isFingerprintAvailable,
          ),
        );
      },
    );
  }
}

class _PreferencesSection extends StatelessWidget {
  const _PreferencesSection({required this.user});

  final UserExt user;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final theme = FunTheme.of(context);
    final iconColor = theme.primary20;
    final currencyIcon = Util.getCurrencyIconData(
      country: Country.fromCode(user.country),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AccountSettingsSectionHeader(title: locals.accountSettingsPreferences),
        AccountSettingsListItem(
          value: locals.giveLimit,
          leading: FaIcon(currencyIcon, size: 20, color: iconColor),
          analyticsEvent: AnalyticsEventName.onInfoRowClicked.toEvent(
            parameters: {'row_type': 'max_amount'},
          ),
          onTap: () => AccountSettingsActions.openMaxAmount(context),
        ),
        AccountSettingsListItem(
          value: locals.amountPresetsTitle,
          leading: FaIcon(FontAwesomeIcons.sliders, size: 20, color: iconColor),
          analyticsEvent: AnalyticsEventName.onInfoRowClicked.toEvent(
            parameters: {'row_type': 'amount_presets'},
          ),
          onTap: () => AccountSettingsActions.openAmountPresets(context),
        ),
        AccountSettingsListItem(
          value: locals.platformContributionTitle,
          leading: FaIcon(
            FontAwesomeIcons.handHoldingDollar,
            size: 20,
            color: iconColor,
          ),
          analyticsEvent: AnalyticsEventName.onInfoRowClicked.toEvent(
            parameters: {'row_type': 'platform_contribution'},
          ),
          onTap: () => AccountSettingsActions.openPlatformContribution(context),
        ),
      ],
    );
  }
}
