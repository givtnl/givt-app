import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/infra/infra_cubit.dart';
import 'package:givt_app/shared/models/analytics_event.dart';

/// Handles [PersonalInfoEditBloc] side effects (modals, refresh on success)
/// for both [PersonalInfoEditPage] and standalone bottom sheets.
class PersonalInfoEditFeedbackListener extends StatelessWidget {
  const PersonalInfoEditFeedbackListener({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return BlocListener<PersonalInfoEditBloc, PersonalInfoEditState>(
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

        if (state.status == PersonalInfoEditStatus.success) {
          context.read<AuthCubit>().refreshUser().whenComplete(() {
            if (!context.mounted) return;
            Navigator.of(context).pop();
          });
        }
      },
      child: child,
    );
  }

  static void _showInfoModal(
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
    ).show(context);
  }

  static void _showEmailAlreadyInUseModal(
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
    ).show(context);
  }

  static void _showSupportRequestConfirmationModal(BuildContext context) {
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
}
