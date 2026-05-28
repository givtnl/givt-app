import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/account_details/pages/change_address_bottom_sheet.dart';
import 'package:givt_app/features/account_details/pages/change_bank_details_bottom_sheet.dart';
import 'package:givt_app/features/account_details/pages/change_email_address_bottom_sheet.dart';
import 'package:givt_app/features/account_details/pages/change_name_bottom_sheet.dart';
import 'package:givt_app/features/account_details/pages/change_phone_number_bottom_sheet.dart';
import 'package:givt_app/features/account_details/widgets/personal_info_edit_feedback_listener.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/creditcard_setup/cubit/stripe_cubit.dart';
import 'package:givt_app/features/family/features/reset_password/presentation/pages/reset_password_sheet.dart';
import 'package:givt_app/l10n/l10n.dart';
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
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;
    final user = context.watch<AuthCubit>().state.user;
    final isUkUser = Country.unitedKingdomCodes().contains(user.country);
    final isUsCard = Country.fromCode(user.country).isCreditCard;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: Text(locals.personalInfo),
      ),
      body: PersonalInfoEditFeedbackListener(
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
                    '${user.address}\n${user.postalCode} ${user.city}, '
                    '${Country.getCountry(user.country, locals)}',
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
              isUsCard
                  ? _buildInfoRow(
                      icon: const Icon(
                        FontAwesomeIcons.creditCard,
                        color: AppTheme.givtOrange,
                      ),
                      value: user.accountNumber.isEmpty
                          ? locals.enterPaymentDetails
                          : '${user.accountBrand.toUpperCase()} ${user.accountNumber}',
                      onTap: () async {
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
                            eventName:
                                AnalyticsEventName.editPaymentDetailsCanceled,
                          );
                          LoggingInfo.instance.info(
                            e.toString(),
                            methodName: stackTrace.toString(),
                          );
                        }
                      },
                    )
                  : _buildInfoRow(
                      icon: Icon(
                        FontAwesomeIcons.creditCard,
                        color: user.mandateSigned
                            ? AppTheme.givtOrange
                            : AppTheme.givtGraycece,
                      ),
                      value: isUkUser
                          ? locals.bacsSortcodeAccountnumber(
                              SortCodeTextFormatter.formatForDisplay(
                                user.sortCode,
                              ),
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
                  context.pushNamed(Pages.manageGiftAid.name);
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
