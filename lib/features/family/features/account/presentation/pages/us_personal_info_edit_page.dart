import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/account_details/pages/change_email_address_bottom_sheet.dart';
import 'package:givt_app/features/account_details/pages/change_phone_number_bottom_sheet.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/pages/change_password_page.dart';
import 'package:givt_app/features/family/app/pages.dart';
import 'package:givt_app/features/family/features/auth/helpers/logout_helper.dart';
import 'package:givt_app/features/family/shared/widgets/common_icons.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/widgets/parent_avatar.dart';
import 'package:givt_app/utils/stripe_helper.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class USPersonalInfoEditPage extends StatelessWidget {
  const USPersonalInfoEditPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;
    final user = context.watch<AuthCubit>().state.user;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.goNamed(FamilyPages.childrenOverview.name),
        ),
        title: Text(locals.personalInfo),
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
                .read<AuthCubit>()
                .refreshUser()
                .whenComplete(() => context.pop());
          }
        },
        child: SingleChildScrollView(
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
                icon: const Text(
                  '@',
                  style: TextStyle(
                    fontSize: 25,
                    color: AppTheme.givtLightBlue,
                  ),
                ),
                value: user.email,
                onTap: () => _showModalBottomSheet(
                  context,
                  bottomSheet: ChangeEmailAddressBottomSheet(
                    email: user.email,
                  ),
                ),
              ),
              _buildInfoRow(
                icon: const Icon(
                  FontAwesomeIcons.phone,
                  color: AppTheme.givtRed,
                ),
                value: user.phoneNumber,
                onTap: () => _showModalBottomSheet(
                  context,
                  bottomSheet: ChangePhoneNumberBottomSheet(
                    country: user.country,
                    phoneNumber: user.phoneNumber,
                  ),
                ),
              ),
              _buildInfoRow(
                icon: const Icon(
                  FontAwesomeIcons.creditCard,
                  color: AppTheme.givtOrange,
                ),
                value:
                    '${user.accountBrand.toUpperCase()} ${user.accountNumber}',
                onTap: () async {
                  await AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.editPaymentDetailsClicked,
                  );

                  if (!context.mounted) return;
                  await context.read<StripeCubit>().fetchSetupIntent();

                  if (!context.mounted) return;

                  try {
                    await StripeHelper(context).showPaymentSheet();

                    if (!context.mounted) return;
                    await context.read<AuthCubit>().refreshUser();
                  } on StripeException catch (e, stackTrace) {
                    await AnalyticsHelper.logEvent(
                      eventName: AmplitudeEvents.editPaymentDetailsCanceled,
                    );

                    /* Logged as info as stripe is giving exception
                       when for example people close the bottomsheet.
                       So it's not a real error :)
                    */
                    await LoggingInfo.instance.info(
                      e.toString(),
                      methodName: stackTrace.toString(),
                    );
                  }
                },
              ),
              _buildInfoRow(
                icon: const Icon(
                  FontAwesomeIcons.lock,
                  color: AppTheme.givtBlue,
                ),
                value: locals.changePassword,
                onTap: () => _showModalBottomSheet(
                  context,
                  bottomSheet: ChangePasswordPage(
                    email: user.email,
                  ),
                ),
              ),
              const Divider(
                height: 0,
              ),
              _buildInfoRow(
                icon: logoutIcon(),
                value: 'Logout',
                onTap: () => logout(context),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 70, right: 70, top: 20),
                child: Text(
                  'Would you like to change your name? Send an e-mail to support@givt.app',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildInfoRow({
    required Widget? icon,
    required String value,
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
                style: TextStyle(
                  fontSize: 16,
                  color: onTap == null ? AppTheme.givtGraycece : null,
                ),
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
