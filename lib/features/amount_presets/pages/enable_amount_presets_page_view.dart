import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

class EnableAmountPresetsPageView extends StatefulWidget {
  const EnableAmountPresetsPageView({
    required this.changeAmountPresets,
    required this.onAmountPresetsChanged,
    super.key,
  });

  final VoidCallback changeAmountPresets;
  final void Function({bool changed}) onAmountPresetsChanged;

  @override
  State<EnableAmountPresetsPageView> createState() =>
      _EnableAmountPresetsPageViewState();
}

class _EnableAmountPresetsPageViewState
    extends State<EnableAmountPresetsPageView> {
  bool useAmountPresets = false;

  @override
  void initState() {
    useAmountPresets = context.read<AuthCubit>().state.presets.isEnabled;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          locals.amountPresetsChangingPresets,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        const Divider(),
        ListTile(
          dense: true,
          title: Text(
            locals.amountPresetsTitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing: Switch(
            value: useAmountPresets,
            activeColor: AppTheme.givtLightGreen,
            onChanged: (value) {
              widget.onAmountPresetsChanged(changed: value);
              setState(() {
                useAmountPresets = value;
              });
            },
          ),
        ),
        const Divider(),
        ListTile(
          dense: true,
          onTap: useAmountPresets ? widget.changeAmountPresets : null,
          title: Text(
            locals.amountPresetsChangePresetsMenu,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: useAmountPresets ? AppTheme.givtBlue : Colors.grey,
                ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: useAmountPresets ? AppTheme.givtBlue : Colors.grey,
          ),
        ),
        const Divider(),
      ],
    );
  }
}
