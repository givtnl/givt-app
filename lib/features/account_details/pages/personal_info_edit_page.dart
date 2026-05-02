import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/account_details/pages/change_address_bottom_sheet.dart';
import 'package:givt_app/features/account_details/pages/change_bank_details_bottom_sheet.dart';
import 'package:givt_app/shared/widgets/sort_code_text_formatter.dart';
import 'package:givt_app/features/account_details/pages/change_email_address_bottom_sheet.dart';
import 'package:givt_app/features/account_details/pages/change_name_bottom_sheet.dart';
import 'package:givt_app/features/account_details/pages/change_phone_number_bottom_sheet.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/reset_password/presentation/pages/reset_password_sheet.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/pages/gift_aid_page.dart';
import 'package:givt_app/shared/bloc/infra/infra_cubit.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class PersonalInfoEditPage extends StatelessWidget {
  const PersonalInfoEditPage({
    this.navigatingFromFamily = false,
    super.key,
  });
  final bool navigatingFromFamily;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;
    final user = context.watch<AuthCubit>().state.user;
    final isUkUser = Country.unitedKingdomCodes().contains(user.country);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (navigatingFromFamily) {
              context.goNamed(FamilyPages.childrenOverview.name);
              return;
            }
            context.pop();
          },
        ),
        title: Text(locals.personalInfo),
      ),
      body: BlocListener<PersonalInfoEditBloc, PersonalInfoEditState>(
        listener: (context, state) {
          if (state.status == PersonalInfoEditStatus.noInternet) {
            _showInfoModal(
              context,
              title: locals.noInternetConnectionTitle,
              subtitle: locals.noInternet,
            );
          }
          if (state.status == PersonalInfoEditStatus.invalidEmail) {
            _showInfoModal(
              context,
              title: locals.invalidEmail,
              subtitle: locals.errorTldCheck,
            );
          }
          if (state.status == PersonalInfoEditStatus.emailUsed) {
            _showEmailAlreadyInUseModal(
              context,
              requestedNewEmail: state.requestedNewEmail ?? '',
            );
          }
          if (state.status == PersonalInfoEditStatus.error) {
            _showInfoModal(
              context,
              title: locals.saveFailed,
              subtitle: locals.updatePersonalInfoError,
            );
          }

          /// if change is success refresh user that used in the cubit
          /// (email change shows success state inside the sheet, then Done pops)
          if (state.status == PersonalInfoEditStatus.success) {
            context.read<AuthCubit>().refreshUser().whenComplete(
              () => context.pop(),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text(
                    locals.personalPageHeader,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              _buildInfoRow(
                icon: const Icon(
                  Icons.person,
                ),
                value: '${user.firstName} ${user.lastName}',
                onTap: () {
                  AnalyticsHelper.logEvent(
                    eventName: AnalyticsEventName.onInfoRowClicked,
                    eventProperties: {'row_type': 'name'},
                  );
                  _showModalBottomSheet(
                    context,
                    bottomSheet: ChangeNameBottomSheet(
                      firstName: user.firstName,
                      lastName: user.lastName,
                    ),
                  );
                },
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
                onTap: () {
                  AnalyticsHelper.logEvent(
                    eventName: AnalyticsEventName.onInfoRowClicked,
                    eventProperties: {'row_type': 'email'},
                  );
                  _showModalBottomSheet(
                    context,
                    bottomSheet: ChangeEmailAddressBottomSheet(
                      email: user.email,
                    ),
                  );
                },
              ),
              _buildInfoRow(
                icon: const Icon(
                  FontAwesomeIcons.house,
                  color: AppTheme.givtLightGreen,
                ),
                value:
                    '${user.address}\n${user.postalCode} ${user.city}, ${Country.getCountry(
                      user.country,
                      locals,
                    )}',
                onTap: () {
                  AnalyticsHelper.logEvent(
                    eventName: AnalyticsEventName.onInfoRowClicked,
                    eventProperties: {'row_type': 'address'},
                  );
                  _showModalBottomSheet(
                    context,
                    bottomSheet: ChangeAddressBottomSheet(
                      address: user.address,
                      postalCode: user.postalCode,
                      city: user.city,
                      country: user.country,
                    ),
                  );
                },
              ),
              _buildInfoRow(
                icon: const Icon(
                  FontAwesomeIcons.phone,
                  color: AppTheme.givtRed,
                ),
                value: user.phoneNumber,
                onTap: () {
                  AnalyticsHelper.logEvent(
                    eventName: AnalyticsEventName.onInfoRowClicked,
                    eventProperties: {'row_type': 'phone'},
                  );
                  _showModalBottomSheet(
                    context,
                    bottomSheet: ChangePhoneNumberBottomSheet(
                      country: user.country,
                      phoneNumber: user.phoneNumber,
                    ),
                  );
                },
              ),
              _buildInfoRow(
                icon: Icon(
                  FontAwesomeIcons.creditCard,
                  color: user.mandateSigned
                      ? AppTheme.givtOrange
                      : AppTheme.givtGraycece,
                ),
                value: isUkUser
                    ? locals.bacsSortcodeAccountnumber(
                        SortCodeTextFormatter.formatForDisplay(user.sortCode),
                        user.accountNumber,
                      )
                    : user.iban,
                onTap: user.mandateSigned
                    ? () {
                        AnalyticsHelper.logEvent(
                          eventName: AnalyticsEventName.onInfoRowClicked,
                          eventProperties: {'row_type': 'bank_details'},
                        );
                        _showModalBottomSheet(
                          context,
                          bottomSheet: ChangeBankDetailsBottomSheet(
                            sortCode: user.sortCode,
                            accountNumber: user.accountNumber,
                            iban: user.iban,
                          ),
                        );
                      }
                    : null,
              ),
              _buildInfoRow(
                visible: isUkUser,
                icon: Image.asset(
                  'assets/images/gift_aid_yellow.png',
                  height: size.height * 0.04,
                ),
                value: 'Gift Aid',
                onTap: () {
                  AnalyticsHelper.logEvent(
                    eventName: AnalyticsEventName.onInfoRowClicked,
                    eventProperties: {'row_type': 'gift_aid'},
                  );
                  _showModalBottomSheet(
                    context,
                    bottomSheet: GiftAidPage(
                      onGiftAidChanged: (useGiftAid) =>
                          context.read<PersonalInfoEditBloc>().add(
                            PersonalInfoEditGiftAid(
                              isGiftAidEnabled: useGiftAid,
                            ),
                          ),
                    ),
                  );
                },
              ),
              _buildInfoRow(
                icon: const Icon(
                  FontAwesomeIcons.lock,
                  color: AppTheme.givtBlue,
                ),
                value: locals.changePassword,
                onTap: () {
                  AnalyticsHelper.logEvent(
                    eventName: AnalyticsEventName.onInfoRowClicked,
                    eventProperties: {'row_type': 'password'},
                  );
                  _showModalBottomSheet(
                    context,
                    bottomSheet: ResetPasswordSheet(
                      initialEmail: user.email,
                    ),
                  );
                },
              ),
              const Divider(
                height: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInfoModal(
    BuildContext context, {
    required String title,
    String? subtitle,
  }) {
    final bloc = context.read<PersonalInfoEditBloc>();
    final navigator = Navigator.of(context);
    void onClose() {
      bloc.add(const PersonalInfoEditStatusReset());
      navigator.pop();
    }

    FunModal(
      title: title,
      subtitle: subtitle,
      closeAction: onClose,
      buttons: [
        FunButton(
          text: context.l10n.confirm,
          analyticsEvent: AnalyticsEvent(AnalyticsEventName.okClicked),
          onTap: onClose,
        ),
      ],
    ).show(context, isDismissible: false);
  }

  void _showEmailAlreadyInUseModal(
    BuildContext context, {
    required String requestedNewEmail,
  }) {
    final locals = context.l10n;
    final bloc = context.read<PersonalInfoEditBloc>();
    void onClose() {
      bloc.add(const PersonalInfoEditStatusReset());
      Navigator.of(context).pop();
    }

    Future<void> createSupportRequest() async {
      final user = context.read<AuthCubit>().state.user;
      final infraCubit = context.read<InfraCubit>();
      final message =
          'The user wants to change their email address and would '
          'like to get in contact to merge their accounts or resolve a '
          'duplicate account. Requested new email address: $requestedNewEmail';
      await infraCubit.contactSupportSafely(
        message: message,
        appLanguage: locals.localeName,
        email: user.email,
        guid: user.guid,
      );
      onClose();
      if (context.mounted && infraCubit.state is InfraSuccess) {
        _showSupportRequestConfirmationModal(context);
      }
    }

    FunModal(
      title: locals.emailAlreadyInUseTitle,
      subtitle: locals.emailAlreadyInUse,
      closeAction: onClose,
      buttons: [
        FunButton(
          text: locals.emailAlreadyInUseContactButton,
          analyticsEvent: AnalyticsEvent(
            AnalyticsEventName.emailAlreadyInUseContactClicked,
          ),
          onTap: createSupportRequest,
        ),
        FunButton(
          variant: FunButtonVariant.secondary,
          fullBorder: true,
          text: locals.emailAlreadyInUseCloseButton,
          analyticsEvent: AnalyticsEvent(
            AnalyticsEventName.emailAlreadyInUseCloseClicked,
          ),
          onTap: onClose,
        ),
      ],
    ).show(context, isDismissible: false);
  }

  void _showSupportRequestConfirmationModal(BuildContext context) {
    final locals = context.l10n;
    void onClose() => Navigator.of(context).pop();

    FunModal(
      icon: FunIcon.checkmark(),
      title: locals.mergeAccountsSupportSentTitle,
      subtitle: locals.mergeAccountsSupportSentBody,
      closeAction: onClose,
      buttons: [
        FunButton(
          text: locals.gotIt,
          analyticsEvent: AnalyticsEvent(
            AnalyticsEventName.mergeAccountsConfirmationClosed,
          ),
          onTap: onClose,
        ),
      ],
    ).show(context);
  }

  Future<void> _showModalBottomSheet(
    BuildContext context, {
    required Widget bottomSheet,
  }) => showModalBottomSheet<void>(
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
  }) => Visibility(
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
