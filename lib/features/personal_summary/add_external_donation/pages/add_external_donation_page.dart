import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/cubit/add_external_donation_cubit.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/models.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/widgets/card_banner.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:givt_app/utils/utils.dart';

class AddExternalDonationPage extends StatelessWidget {
  const AddExternalDonationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final cubit = context.read<AddExternalDonationCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text(locals.budgetExternalGiftsTitle),
      ),
      body: _buildBody(context),
      bottomSheet: cubit.state.status == AddExternalDonationStatus.loading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                /// todo add isEnabled
                onPressed: () async {},
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: Colors.grey,
                ),
                child: Text(locals.budgetExternalGiftsSave),
              ),
            ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildBanner(context),
            const SizedBox(height: 20),
            _buildExternalDonationList(context),
            const SizedBox(height: 20),
            _buildAddExternalDonation(context),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    final locals = context.l10n;
    return CardBanner(
      title: locals.budgetExternalGiftsInfoBold,
      subtitle: locals.budgetExternalGiftsInfo,
    );
  }

  Widget _buildExternalDonationList(BuildContext context) {
    return Column(
      children: [
        Text(
          context.l10n.budgetExternalGiftsSubTitle,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAddExternalDonation(BuildContext context) {
    final locals = context.l10n;
    final frequncies = [
      locals.budgetExternalGiftsFrequencyOnce,
      locals.budgetExternalGiftsFrequencyMonthly,
      locals.budgetExternalGiftsFrequencyQuarterly,
      locals.budgetExternalGiftsFrequencyHalfYearly,
      locals.budgetExternalGiftsFrequencyYearly,
    ];
    final country =
        Country.fromCode(context.read<AuthCubit>().state.user.country);
    return Card(
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              hintText: locals.budgetExternalGiftsOrg,
              controller: TextEditingController(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<ExternalDonationFrequency>(
                    hint: Text(locals.budgetExternalGiftsTime),
                    value: ExternalDonationFrequency.yearly,
                    onChanged: (ExternalDonationFrequency? newValue) {
                      if (newValue == null) {
                        return;
                      }
                    },
                    items: ExternalDonationFrequency.values
                        .map<DropdownMenuItem<ExternalDonationFrequency>>(
                            (ExternalDonationFrequency value) {
                      return DropdownMenuItem<ExternalDonationFrequency>(
                        value: value,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          frequncies[value.index],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                    controller: TextEditingController(),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        /// Allow only numbers and one comma or dot
                        /// Like 123, 123.45, 12,05, 12,5
                        RegExp(r'^\d+([,.]\d{0,2})?'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value.isEmpty) {
                        return;
                      }
                      if (value.contains(',')) {
                        value = value.replaceAll(',', '.');
                      }
                    },
                    decoration: InputDecoration(
                      labelText: locals.budgetExternalGiftsAmount,
                      hintText: locals.budgetExternalGiftsAmount,
                      prefixIcon: Icon(
                        Util.getCurrencyIconData(country: country),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ListTile(
              dense: true,
              title: Text(
                locals.budgetExternalDonationsTaxDeductableSwitch,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: Switch(
                value: false,
                activeColor: AppTheme.givtLightGreen,
                onChanged: (value) {},
              ),
            ),
            const SizedBox(height: 20),
            // todo adjust if it's edit or add mode
            ElevatedButton(
              onPressed: () {},
              child: Text(locals.budgetExternalGiftsAdd),
            ),
          ],
        ),
      ),
    );
  }
}
