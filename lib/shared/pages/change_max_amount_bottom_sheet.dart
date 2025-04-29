import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class ChangeMaxAmountBottomSheet extends StatelessWidget {
  const ChangeMaxAmountBottomSheet({
    required this.icon,
    required this.maxAmount,
    super.key,
  });

  final int maxAmount;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonalInfoEditBloc(
        authRepository: getIt(),
        loggedInUserExt: context.read<AuthCubit>().state.user,
      ),
      child: _ChangeMaxAmountBottomSheetView(
        icon: icon,
        maxAmount: maxAmount,
      ),
    );
  }
}

class _ChangeMaxAmountBottomSheetView extends StatefulWidget {
  const _ChangeMaxAmountBottomSheetView({
    required this.icon,
    required this.maxAmount,
  });

  final int maxAmount;
  final IconData icon;

  @override
  State<_ChangeMaxAmountBottomSheetView> createState() =>
      _ChangeMaxAmountBottomSheetViewState();
}

class _ChangeMaxAmountBottomSheetViewState
    extends State<_ChangeMaxAmountBottomSheetView> {
  final int maxAmountLimit = 99999;
  final int minAmountLimit = 0;
  final int amountStep = 5;

  late TextEditingController amountController;
  bool get isEnabled {
    final enteredAmount = int.parse(amountController.text);
    if (enteredAmount == 0) {
      amountController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: amountController.text.length,
      );
      return false;
    }
    if (enteredAmount == widget.maxAmount) {
      return false;
    }
    return true;
  }

  void increaseAmount() {
    final enteredAmount = int.parse(amountController.text);
    if (enteredAmount == maxAmountLimit) {
      return;
    }
    setState(() {
      amountController.text = (enteredAmount + amountStep).toString();
    });
  }

  void decreaseAmount() {
    final enteredAmount = int.parse(amountController.text);
    if (enteredAmount == minAmountLimit) {
      return;
    }
    setState(() {
      amountController.text = (enteredAmount - amountStep).toString();
    });
  }

  @override
  void initState() {
    amountController = TextEditingController(text: widget.maxAmount.toString());
    super.initState();
  }

  // Track whether we're showing the success state
  bool _showSuccess = false;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return BlocConsumer<PersonalInfoEditBloc, PersonalInfoEditState>(
      listener: (context, state) {
        if (state.status == PersonalInfoEditStatus.success) {
          setState(() {
            _showSuccess = true;
          });
          // Wait a moment before closing to show the success state
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              context
                  .read<AuthCubit>()
                  .refreshUser()
                  .whenComplete(() => context.pop());
            }
          });
        }
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
        if (state.status == PersonalInfoEditStatus.error) {
          showDialog<void>(
            context: context,
            builder: (_) => WarningDialog(
              title: locals.errorOccurred,
              content: locals.errorContactGivt,
              onConfirm: () => context.pop(),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status == PersonalInfoEditStatus.loading) {
          return _buildLoadingSheet(context);
        }

        if (_showSuccess) {
          return _buildSuccessSheet(context);
        }

        return _buildEditSheet(context);
      },
    );
  }

  /// Builds the loading state UI
  Widget _buildLoadingSheet(BuildContext context) {
    return FunBottomSheet(
      title: context.l10n.giveLimit,
      icon: const CustomCircularProgressIndicator(),
      content: Column(
        children: [
          BodyMediumText(
            context.l10n.loadingTitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds the success state UI
  Widget _buildSuccessSheet(BuildContext context) {
    final locals = context.l10n;
    return FunBottomSheet(
      title: locals.giveLimit,
      icon: primaryCircleWithIcon(
        circleSize: 140,
        iconData: FontAwesomeIcons.check,
        iconSize: 48,
      ),
      content: Column(
        children: [
          BodyMediumText(
            context.l10n.success,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds the amount control UI
  Widget _buildAmountControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton.filled(
          onPressed: decreaseAmount,
          icon: const Icon(
            FontAwesomeIcons.circleMinus,
            color: AppTheme.givtLightGreen,
          ),
          iconSize: 48,
          padding: EdgeInsets.zero,
        ),
        _buildAmountField(context),
        IconButton.filled(
          onPressed: increaseAmount,
          icon: const Icon(
            FontAwesomeIcons.circlePlus,
          ),
          color: AppTheme.givtLightGreen,
          iconSize: 48,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }

  /// Builds the amount input field
  Widget _buildAmountField(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.givtLightGreen,
            width: 7,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            widget.icon,
            size: 16,
          ),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
            width: 80,
            child: TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                if (value.isEmpty) {
                  amountController.text = minAmountLimit.toString();
                }
                setState(() {});
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 27,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the primary action button
  FunButton _buildActionButton(BuildContext context) {
    final locals = context.l10n;
    return FunButton(
      isDisabled: !isEnabled,
      onTap: isEnabled
          ? () {
              context.read<PersonalInfoEditBloc>().add(
                    PersonalInfoEditChangeMaxAmount(
                      newAmountLimit: int.parse(
                        amountController.text,
                      ),
                    ),
                  );
            }
          : null,
      text: locals.save,
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.maxAmountSaveClicked,
        parameters: {'new_max_amount': amountController.text},
      ),
    );
  }

  /// Builds the main editing interface
  Widget _buildEditSheet(BuildContext context) {
    final locals = context.l10n;
    return FunBottomSheet(
      title: locals.giveLimit,
      closeAction: () => context.pop(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          BodyMediumText(
            locals.amountLimit,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 40,
          ),
          _buildAmountControls(context),
          const SizedBox(height: 24),
        ],
      ),
      primaryButton: _buildActionButton(context),
    );
  }
}
