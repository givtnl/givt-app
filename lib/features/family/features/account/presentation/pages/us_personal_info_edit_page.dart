import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/auth/local_auth_info.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/account/presentation/widgets/us_change_email_address_bottom_sheet.dart';
import 'package:givt_app/features/family/features/account/presentation/widgets/us_change_phone_number_bottom_sheet.dart';
import 'package:givt_app/features/family/features/auth/bloc/family_auth_cubit.dart';
import 'package:givt_app/features/family/features/auth/presentation/models/family_auth_state.dart';
import 'package:givt_app/features/family/features/creditcard_setup/cubit/stripe_cubit.dart';
import 'package:givt_app/features/family/features/reset_password/presentation/pages/reset_password_sheet.dart';
import 'package:givt_app/features/family/helpers/logout_helper.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/overlays/bloc/fun_bottom_sheet_with_async_action_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/overlays/fun_bottom_sheet_with_async_action.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/family/utils/family_auth_utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/pages/fingerprint_bottom_sheet.dart';
import 'package:givt_app/shared/widgets/parent_avatar.dart';
import 'package:givt_app/shared/widgets/us_about_givt_bottom_sheet.dart';
import 'package:givt_app/utils/stripe_helper.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class USPersonalInfoEditPage extends StatefulWidget {
  const USPersonalInfoEditPage({
    super.key,
  });

  @override
  State<USPersonalInfoEditPage> createState() => _USPersonalInfoEditPageState();
}

class _USPersonalInfoEditPageState extends State<USPersonalInfoEditPage> {
  final FamilyAuthCubit _authCubit = getIt<FamilyAuthCubit>();
  final FunBottomSheetWithAsyncActionCubit _asyncCubit =
      FunBottomSheetWithAsyncActionCubit();

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return Scaffold(
      appBar: FunTopAppBar(
        title: locals.personalInfo,
        leading: const GivtBackButtonFlat(),
      ),
      body: BlocListener<PersonalInfoEditBloc, PersonalInfoEditState>(
        listener: (context, state) {
          if (state.status == PersonalInfoEditStatus.noInternet) {
            showDialog<void>(
              context: context,
              builder: (_) => WarningDialog(
                title: locals.noInternetConnectionTitle,
                content: locals.noInternet,
                onConfirm: () => context.pop(),
              ),
            );
          }
          if (state.status == PersonalInfoEditStatus.invalidEmail) {
            showDialog<void>(
              context: context,
              builder: (_) => WarningDialog(
                title: locals.invalidEmail,
                content: locals.errorTldCheck,
                onConfirm: () => context.pop(),
              ),
            );
          }

          if (state.status == PersonalInfoEditStatus.emailUsed) {
            showDialog<void>(
              context: context,
              builder: (_) => WarningDialog(
                title: locals.invalidEmail,
                content: locals.errorTldCheck,
                onConfirm: () => context.pop(),
              ),
            );
          }

          if (state.status == PersonalInfoEditStatus.error) {
            showDialog<void>(
              context: context,
              builder: (_) => WarningDialog(
                title: locals.saveFailed,
                content: locals.updatePersonalInfoError,
                onConfirm: () => context.pop(),
              ),
            );
          }

          /// if change is success refresh user that used in the cubit
          if (state.status == PersonalInfoEditStatus.success) {
            context
                .read<FamilyAuthCubit>()
                .refreshUser()
                .whenComplete(() => context.pop());
          }
        },
        child: BlocBuilder(
          bloc: _authCubit,
          buildWhen: (previous, current) => current is Authenticated,
          builder: (context, FamilyAuthState state) {
            return _buildLayout(state, context, locals);
          },
        ),
      ),
    );
  }

  SingleChildScrollView _buildLayout(
      FamilyAuthState state, BuildContext context, AppLocalizations locals) {
    final user = (state as Authenticated).user;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ParentAvatar(
              firstName: user.firstName,
              lastName: user.lastName,
              pictureURL: user.profilePicture,
            ),
          ),
          _buildInfoRow(
            context,
            icon: const Text(
              '@',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            value: user.email,
            onTap: () => FunBottomSheetWithAsyncAction.show(
              context,
              cubit: _asyncCubit,
              initialState: USChangeEmailAddressBottomSheet(
                email: user.email,
                asyncCubit: _asyncCubit,
              ),
              successText: 'Changes saved!',
              loadingText: 'Updating profile information',
              analyticsName: 'us_change_email_bottom_sheet',
            ),
          ),
          _buildInfoRow(
            context,
            icon: const Icon(
              FontAwesomeIcons.phone,
            ),
            value: user.phoneNumber,
            onTap: () => FunBottomSheetWithAsyncAction.show(
              context,
              cubit: _asyncCubit,
              initialState: USChangePhoneNumberBottomSheet(
                country: user.country,
                phoneNumber: user.phoneNumber,
                asyncCubit: _asyncCubit,
              ),
              successText: 'Changes saved!',
              loadingText: 'Updating profile information',
              analyticsName: 'us_change_phone_number_bottom_sheet',
            ),
          ),
          _buildInfoRow(
            context,
            icon: const Icon(
              FontAwesomeIcons.creditCard,
            ),
            value: '${user.accountBrand.toUpperCase()} ${user.accountNumber}',
            onTap: () async {
              await AnalyticsHelper.logEvent(
                eventName: AmplitudeEvents.editPaymentDetailsClicked,
              );

              if (!context.mounted) return;
              await getIt<StripeCubit>().fetchSetupIntent();

              if (!context.mounted) return;

              try {
                await StripeHelper(context).showPaymentSheet();

                if (!context.mounted) return;
                await context.read<FamilyAuthCubit>().refreshUser();
              } on StripeException catch (e, stackTrace) {
                await AnalyticsHelper.logEvent(
                  eventName: AmplitudeEvents.editPaymentDetailsCanceled,
                );

                /* Logged as info as stripe is giving exception
               when for example people close the bottomsheet.
               So it's not a real error :)
            */
                LoggingInfo.instance.info(
                  e.toString(),
                  methodName: stackTrace.toString(),
                );
              }
            },
          ),
          _buildInfoRow(
            context,
            icon: const Icon(
              FontAwesomeIcons.lock,
            ),
            value: locals.changePassword,
            onTap: () =>
                ResetPasswordSheet(initialEmail: user.email).show(context),
          ),
          FutureBuilder(
            initialData: false,
            future: Future.wait<bool>([
              LocalAuthInfo.instance.checkFingerprint(),
              LocalAuthInfo.instance.checkFaceId(),
            ]),
            builder: (_, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox.shrink();
              }
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              if (snapshot.data == null) {
                return const SizedBox.shrink();
              }

              final data = snapshot.data! as List<bool>;
              final isFingerprintAvailable = data[0];
              final isFaceIdAvailable = data[1];
              final shouldShow = isFingerprintAvailable || isFaceIdAvailable;

              return Column(
                children: [
                  if (shouldShow)
                    _buildInfoRow(
                      context,
                      value: isFingerprintAvailable
                          ? Platform.isAndroid
                              ? locals.fingerprintTitle
                              : locals.touchId
                          : locals.faceId,
                      icon: Platform.isIOS && isFaceIdAvailable
                          ? SvgPicture.asset(
                              'assets/images/face_id_image.svg',
                              width: 24,
                            )
                          : const Icon(Icons.fingerprint),
                      onTap: () async => FamilyAuthUtils.authenticateUser(
                        context,
                        checkAuthRequest: FamilyCheckAuthRequest(
                          navigate: (context) => showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: true,
                            builder: (_) => FingerprintBottomSheet(
                              isFingerprint: isFingerprintAvailable,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (shouldShow)
                    const Divider(
                      height: 0,
                    ),
                ],
              );
            },
          ),
          const Divider(
            height: 0,
          ),
          _buildInfoRow(
            context,
            icon: const Icon(
              semanticLabel: 'userXmark',
              FontAwesomeIcons.userXmark,
            ),
            value: locals.unregister,
            onTap: () async => context.pushNamed(
              FamilyPages.unregisterUS.name,
            ),
          ),
          const Divider(
            height: 0,
          ),
          _buildInfoRow(
            context,
            icon: const Icon(
              FontAwesomeIcons.circleInfo,
            ),
            value: locals.titleAboutGivt,
            onTap: () => FunBottomSheetWithAsyncAction.show(
              context,
              cubit: _asyncCubit,
              initialState: USAboutGivtBottomSheet(asyncCubit: _asyncCubit),
              successText:
                  'Thanks for reaching out!\nWe will be in touch shortly',
              loadingText: 'Sending message',
              analyticsName: 'us_about_givt_bottom_sheet',
            ),
          ),
          const Divider(
            height: 0,
          ),
          _buildInfoRow(
            context,
            style: Theme.of(context).textTheme.labelMedium,
            icon: const Icon(
              FontAwesomeIcons.rightFromBracket,
            ),
            value: 'Logout',
            onTap: () => logout(context, fromLogoutBtn: true),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 70, right: 70, top: 20),
            child: Text(
              'Would you like to change your name? Send an e-mail to support@givt.app',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: FamilyAppTheme.downloadAppBackground),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
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

  Widget _buildInfoRow(
    BuildContext context, {
    required Widget? icon,
    required String value,
    TextStyle? style,
    VoidCallback? onTap,
    bool visible = true,
  }) =>
      Visibility(
        visible: visible,
        child: Column(
          children: [
            const Divider(
              height: 0,
            ),
            ListTile(
              leading: icon,
              title: Text(
                value,
                style: style ?? Theme.of(context).textTheme.labelMedium,
              ),
              trailing: onTap != null
                  ? const Icon(
                      Icons.arrow_forward_ios,
                    )
                  : null,
              onTap: onTap,
            ),
          ],
        ),
      );
}
