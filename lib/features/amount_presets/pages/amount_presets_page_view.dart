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
  late Country countryCode;

  @override
  void initState() {
    countryCode = Country.fromCode(context.read<AuthCubit>().state.user.country);

    final presets = context.read<AuthCubit>().state.presets;
    firstPreset = TextEditingController(
      text: Util.formatNumberComma(presets.presets[0].amount, countryCode),
    );
    secondPreset = TextEditingController(
      text: Util.formatNumberComma(presets.presets[1].amount, countryCode),
    );
    thirdPreset = TextEditingController(
      text: Util.formatNumberComma(presets.presets[2].amount, countryCode),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.sizeOf(context);
    final amountLimit = context.read<AuthCubit>().state.user.amountLimit;

    final lowerLimit = Util.getLowerLimitByCountry(countryCode);
    final currency = NumberFormat.simpleCurrency(
      name: countryCode.currency,
    ).currencySymbol;

    return Form(
      key: formKey,
      child: SingleChildScrollView(
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
            SizedBox(
              height: size.height * 0.20,
            ),
            if (context.watch<AuthCubit>().state.status == AuthStatus.loading)
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
      ),
    );
  }
}
