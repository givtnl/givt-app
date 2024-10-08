import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
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

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.sizeOf(context);
    return BlocConsumer<PersonalInfoEditBloc, PersonalInfoEditState>(
      listener: (context, state) {
        if (state.status == PersonalInfoEditStatus.success) {
          context
              .read<AuthCubit>()
              .refreshUser()
              .whenComplete(() => context.pop());
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
        return BottomSheetLayout(
          title: Text(locals.giveLimit),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                locals.amountLimit,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton.filled(
                    onPressed: decreaseAmount,
                    icon: const Icon(
                      FontAwesomeIcons.circleMinus,
                    ),
                    color: AppTheme.softenedGivtPurple,
                    iconSize: size.width * 0.1,
                  ),
                  Container(
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
                          size: size.width * 0.04,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: size.width * 0.15,
                          child: TextFormField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              if (value.isEmpty) {
                                amountController.text =
                                    minAmountLimit.toString();
                              }
                              setState(() {});
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontSize: 27,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filled(
                    onPressed: increaseAmount,
                    icon: const Icon(
                      FontAwesomeIcons.circlePlus,
                    ),
                    color: AppTheme.softenedGivtPurple,
                    iconSize: size.width * 0.1,
                  ),
                ],
              ),
              const Spacer(),
              if (context.watch<PersonalInfoEditBloc>().state.status ==
                  PersonalInfoEditStatus.loading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                ElevatedButton(
                  onPressed: isEnabled
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
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: Colors.grey,
                  ),
                  child: Text(locals.save),
                ),
            ],
          ),
        );
      },
    );
  }
}
