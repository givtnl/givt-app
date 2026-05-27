import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/account_details/pages/change_address_bottom_sheet.dart';
import 'package:givt_app/features/account_details/pages/change_bank_details_bottom_sheet.dart';
import 'package:givt_app/features/account_details/pages/change_email_address_bottom_sheet.dart';
import 'package:givt_app/features/account_details/pages/change_name_bottom_sheet.dart';
import 'package:givt_app/features/account_details/pages/change_phone_number_bottom_sheet.dart';
import 'package:givt_app/features/account_details/widgets/personal_info_edit_feedback_listener.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/shared/models/user_ext.dart';

/// Opens the same change bottom sheets as [PersonalInfoEditPage], with a
/// dedicated [PersonalInfoEditBloc] and shared feedback handling.
Future<void> showChangeNameSheetForUser(
  BuildContext context,
  UserExt user,
) =>
    _showSheet(
      context,
      user,
      ChangeNameBottomSheet(
        firstName: user.firstName,
        lastName: user.lastName,
      ),
    );

Future<void> showChangeEmailSheetForUser(
  BuildContext context,
  UserExt user,
) =>
    _showSheet(
      context,
      user,
      ChangeEmailAddressBottomSheet(
        email: user.email,
      ),
    );

Future<void> showChangeAddressSheetForUser(
  BuildContext context,
  UserExt user,
) =>
    _showSheet(
      context,
      user,
      ChangeAddressBottomSheet(
        address: user.address,
        postalCode: user.postalCode,
        city: user.city,
        country: user.country,
      ),
    );

Future<void> showChangePhoneSheetForUser(
  BuildContext context,
  UserExt user,
) =>
    _showSheet(
      context,
      user,
      ChangePhoneNumberBottomSheet(
        country: user.country,
        phoneNumber: user.phoneNumber,
      ),
    );

Future<void> showChangeBankDetailsSheetForUser(
  BuildContext context,
  UserExt user,
) =>
    _showSheet(
      context,
      user,
      ChangeBankDetailsBottomSheet(
        sortCode: user.sortCode,
        accountNumber: user.accountNumber,
        iban: user.iban,
      ),
    );

Future<void> _showSheet(
  BuildContext context,
  UserExt user,
  Widget sheet,
) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => BlocProvider(
        create: (_) => PersonalInfoEditBloc(
          authRepository: getIt<AuthRepository>(),
          loggedInUserExt: user,
        ),
        child: PersonalInfoEditFeedbackListener(
          child: sheet,
        ),
      ),
    );
