import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
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
        authRepositoy: getIt(),
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
  late TextEditingController amount;
  bool get isEnabled {
    final enteredAmount = int.parse(amount.text);
    if (enteredAmount == 0) {
      amount.selection = TextSelection(
        baseOffset: 0,
        extentOffset: amount.text.length,
      );
      return false;
    }
    if (enteredAmount == widget.maxAmount) {
      return false;
    }
    return true;
  }

  void increaseAmount() {
    if (int.parse(amount.text) == 99999) {
      return;
    }
    setState(() {
      amount.text = (int.parse(amount.text) + 5).toString();
    });
  }

  void decreaseAmount() {
    if (int.parse(amount.text) == 0) {
      return;
    }
    setState(() {
      amount.text = (int.parse(amount.text) - 5).toString();
    });
  }

  @override
  void initState() {
    amount = TextEditingController(text: widget.maxAmount.toString());
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
                            controller: amount,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                amount.text = '0';
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
                                    amount.text,
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
