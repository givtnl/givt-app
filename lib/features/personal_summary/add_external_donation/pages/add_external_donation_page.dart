import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/cubit/add_external_donation_cubit.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/widgets/widgets.dart';
import 'package:givt_app/features/personal_summary/overview/bloc/personal_summary_bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class AddExternalDonationPage extends StatelessWidget {
  const AddExternalDonationPage({super.key,});

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
          taxDeductable: state.currentExternalDonation.taxDeductible,
          frequency: state.currentExternalDonation.frequency,
          onSave: (savedDonation) {
            context
                .read<AddExternalDonationCubit>()
                .addExternalDonation(savedDonation);
          },
        );
      },
    );
  }
}
