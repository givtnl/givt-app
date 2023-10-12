import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/give/give.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class EnterAmountBottomSheet extends StatefulWidget {
  const EnterAmountBottomSheet({
    required this.collectGroupNameSpace,
    super.key,
  });

  final String collectGroupNameSpace;

  @override
  State<EnterAmountBottomSheet> createState() => _EnterAmountBottomSheetState();
}

class _EnterAmountBottomSheetState extends State<EnterAmountBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final auth = context.watch<AuthCubit>().state;
    return BlocListener<GiveBloc, GiveState>(
      listener: (context, state) {
        if (state.status == GiveStatus.readyToGive) {
          context.goNamed(
            Pages.give.name,
            extra: context.read<GiveBloc>(),
          );
        }
        if (state.status == GiveStatus.success) {
          context.read<GiveBloc>().add(
                GiveOrganisationSelected(
                  widget.collectGroupNameSpace,
                  auth.user.guid,
                ),
              );
        }
      },
      child: BottomSheetLayout(
        title: Text(
          locals.amount,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        child: ChooseAmount(
          country: Country.fromCode(auth.user.country),
          amountLimit: auth.user.amountLimit,
          hasGiven: false,
          arePresetsEnabled: auth.presets.isEnabled,
          presets: auth.presets.presets,
          showAddCollectionButton: false,
          onAmountChanged:
              (firstCollection, secondCollection, thirdCollection) {
            context.read<GiveBloc>().add(
                  GiveAmountChanged(
                    firstCollectionAmount: firstCollection,
                    secondCollectionAmount: secondCollection,
                    thirdCollectionAmount: thirdCollection,
                  ),
                );
          },
        ),
      ),
    );
  }
}
