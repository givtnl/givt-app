import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/cubit/add_external_donation_cubit.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/widgets/add_edit_external_donation_form.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/widgets/widgets.dart';
import 'package:givt_app/features/personal_summary/overview/bloc/personal_summary_bloc.dart';
import 'package:givt_app/features/personal_summary/overview/pages/personal_summary_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class AddExternalDonationPage extends StatelessWidget {
  const AddExternalDonationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(locals.budgetExternalGiftsTitle),
      ),
      body: _buildBody(context),
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
        BlocBuilder<AddExternalDonationCubit, AddExternalDonationState>(
          builder: (context, state) {
            if (state.externalDonations.isEmpty) {
              return Container();
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.externalDonations.length,
              itemBuilder: (context, index) {
                final externalDonation = state.externalDonations[index];
                return ExternalDonationItem(
                  title: externalDonation.description,
                  amount: externalDonation.amount,
                  onEdit: () => context
                      .read<AddExternalDonationCubit>()
                      .updateCurrentExternalDonation(
                        index: index,
                      ),
                  onDelete: () => context
                      .read<AddExternalDonationCubit>()
                      .removeExternalDonation(
                        index: index,
                      ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildAddExternalDonation(BuildContext context) {
    final locals = context.l10n;
    final country = context.read<AuthCubit>().state.user.country;
    return BlocConsumer<AddExternalDonationCubit, AddExternalDonationState>(
      listener: (context, state) {
        if (state.status == AddExternalDonationStatus.error) {
          showDialog<void>(
            context: context,
            builder: (_) => WarningDialog(
              title: locals.errorOccurred,
              content: locals.errorContactGivt,
              onConfirm: () => context.pop(),
            ),
          );
        }
        if (state.status == AddExternalDonationStatus.success) {
          context.read<PersonalSummaryBloc>().add(const PersonalSummaryInit());
        }
      },
      builder: (context, state) {
        return AddEditExternalDonationForm(
          key: const Key('add_edit_external_donation_form'),
          description: state.currentExternalDonation.description,
          amount: Util.formatNumberComma(
            state.currentExternalDonation.amount,
            Country.fromCode(country),
          ),
          taxDeductable: state.currentExternalDonation.taxDeductable,
          frequency: state.currentExternalDonation.frequency,
          onSave: (savedDonation) {
            context
                .read<AddExternalDonationCubit>()
                .addExternalDonation(savedDonation);
          },
        );
      },
      //   return Card(
      //     elevation: 10,
      //     child: Container(
      //       padding: const EdgeInsets.all(20),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           CustomTextFormField(
      //               hintText: locals.budgetExternalGiftsOrg,
      //               controller: descriptionController,
      //               onChanged: (newValue) => context
      //                   .read<AddExternalDonationCubit>()
      //                   .descriptionChanged(
      //                     value: newValue,
      //                   )),
      //           const SizedBox(height: 20),
      //           Row(
      //             children: [
      //               Expanded(
      //                 child: DropdownButtonFormField<ExternalDonationFrequency>(
      //                   hint: Text(locals.budgetExternalGiftsTime),
      //                   value: state.currentExternalDonation.frequency,
      //                   onChanged: state.isEdit
      //                       ? null
      //                       : (ExternalDonationFrequency? newValue) {
      //                           if (newValue == null) {
      //                             return;
      //                           }
      //                           context
      //                               .read<AddExternalDonationCubit>()
      //                               .frequencyChanged(
      //                                 value: newValue,
      //                               );
      //                         },
      //                   items: ExternalDonationFrequency.values
      //                       .map<DropdownMenuItem<ExternalDonationFrequency>>(
      //                           (ExternalDonationFrequency value) {
      //                     return DropdownMenuItem<ExternalDonationFrequency>(
      //                       value: value,
      //                       alignment: Alignment.centerLeft,
      //                       child: Text(
      //                         frequncies[value.index],
      //                         style: Theme.of(context)
      //                             .textTheme
      //                             .bodyMedium!
      //                             .copyWith(
      //                               color: state.isEdit
      //                                   ? Colors.grey
      //                                   : Theme.of(context)
      //                                       .textTheme
      //                                       .bodyMedium!
      //                                       .color,
      //                             ),
      //                       ),
      //                     );
      //                   }).toList(),
      //                 ),
      //               ),
      //               const SizedBox(width: 20),
      //               Expanded(
      //                 child: TextField(
      //                   keyboardType: const TextInputType.numberWithOptions(
      //                     decimal: true,
      //                   ),
      //                   style: Theme.of(context).textTheme.bodyLarge,
      //                   controller: amountController,
      //                   inputFormatters: [
      //                     FilteringTextInputFormatter.allow(
      //                       /// Allow only numbers and one comma or dot
      //                       /// Like 123, 123.45, 12,05, 12,5
      //                       RegExp(r'^\d+([,.]\d{0,2})?'),
      //                     ),
      //                   ],
      //                   onChanged: (value) {
      //                     if (value.isEmpty) {
      //                       return;
      //                     }
      //                     if (value.contains(',')) {
      //                       value = value.replaceAll(',', '.');
      //                     }
      //                     context
      //                         .read<AddExternalDonationCubit>()
      //                         .amountChanged(
      //                           value: double.parse(value),
      //                         );
      //                   },
      //                   decoration: InputDecoration(
      //                     labelText: locals.budgetExternalGiftsAmount,
      //                     hintText: locals.budgetExternalGiftsAmount,
      //                     prefixIcon: Icon(
      //                       Util.getCurrencyIconData(country: country),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //           const SizedBox(height: 20),
      //           ListTile(
      //             dense: true,
      //             title: Text(
      //               locals.budgetExternalDonationsTaxDeductableSwitch,
      //               style: Theme.of(context).textTheme.bodyLarge,
      //             ),
      //             trailing: Switch(
      //               value: state.currentExternalDonation.taxDeductable,
      //               activeColor: AppTheme.givtLightGreen,
      //               onChanged: (value) => context
      //                   .read<AddExternalDonationCubit>()
      //                   .taxDeductableChanged(
      //                     value: value,
      //                   ),
      //             ),
      //           ),
      //           const SizedBox(height: 20),
      //           _buildAddEditButton(
      //             context,
      //             onPressed:
      //                 state.status == AddExternalDonationStatus.loading ||
      //                         !_isEnabled(state)
      //                     ? null
      //                     : () => context
      //                         .read<AddExternalDonationCubit>()
      //                         .addExternalDonation(),
      //             child: state.status == AddExternalDonationStatus.loading
      //                 ? const CircularProgressIndicator.adaptive()
      //                 : Text(
      //                     state.isEdit
      //                         ? locals.budgetExternalGiftsEdit
      //                         : locals.budgetExternalGiftsAdd,
      //                   ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   );
      // },
    );
  }
}
