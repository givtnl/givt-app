import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/amount_presets/widgets/widgets.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:intl/intl.dart';

class AmountPresetsPageView extends StatefulWidget {
  const AmountPresetsPageView({
    required this.onAmountPresetsChanged,
    super.key,
  });

  final void Function(
    double first,
    double second,
    double third,
  ) onAmountPresetsChanged;

  @override
  State<AmountPresetsPageView> createState() => _AmountPresetsPageViewState();
}

class _AmountPresetsPageViewState extends State<AmountPresetsPageView> {
  late TextEditingController firstPreset;
  late TextEditingController secondPreset;
  late TextEditingController thirdPreset;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    final presets = context.read<AuthCubit>().state.user.presets;
    firstPreset = TextEditingController(
      text: presets.presets[0].amount.toStringAsFixed(2).replaceAll('.', ','),
    );
    secondPreset = TextEditingController(
      text: presets.presets[1].amount.toStringAsFixed(2).replaceAll('.', ','),
    );
    thirdPreset = TextEditingController(
      text: presets.presets[2].amount.toStringAsFixed(2).replaceAll('.', ','),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final amountLimit = context.read<AuthCubit>().state.user.amountLimit;
    final country =
        Country.fromCode(context.read<AuthCubit>().state.user.country);

    final lowerLimit = Util.getLowerLimitByCountry(country);
    final currency = NumberFormat.simpleCurrency(
      name: country.currency,
    ).currencySymbol;

    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            locals.amountPresetsBody,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          PresetFormField(
            controller: firstPreset,
            amountLimit: amountLimit,
            lowerLimit: lowerLimit,
            currency: currency,
            onChanged: (_) => formKey.currentState!.validate(),
          ),
          const SizedBox(
            height: 20,
          ),
          PresetFormField(
            controller: secondPreset,
            amountLimit: amountLimit,
            lowerLimit: lowerLimit,
            currency: currency,
            onChanged: (_) => formKey.currentState!.validate(),
          ),
          const SizedBox(
            height: 20,
          ),
          PresetFormField(
            controller: thirdPreset,
            amountLimit: amountLimit,
            lowerLimit: lowerLimit,
            currency: currency,
            onChanged: (_) => formKey.currentState!.validate(),
          ),
          const Spacer(),
          if (context.watch<AuthCubit>().state is AuthLoading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                widget.onAmountPresetsChanged(
                  double.parse(firstPreset.text.replaceAll(',', '.')),
                  double.parse(secondPreset.text.replaceAll(',', '.')),
                  double.parse(thirdPreset.text.replaceAll(',', '.')),
                );
              },
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.grey,
              ),
              child: Text(locals.save),
            ),
        ],
      ),
    );
  }
}
