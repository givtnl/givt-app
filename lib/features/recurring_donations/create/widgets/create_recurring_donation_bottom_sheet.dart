import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/give/give.dart';
import 'package:givt_app/features/give/bloc/organisation/organisation.dart';
import 'package:givt_app/features/give/pages/organization_list_page.dart';
import 'package:givt_app/features/recurring_donations/create/cubit/create_recurring_donation_cubit.dart';
import 'package:givt_app/features/recurring_donations/create/models/recurring_donation_frequency.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:intl/intl.dart';

class CreateRecurringDonationBottomSheet extends StatelessWidget {
  const CreateRecurringDonationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateRecurringDonationCubit(),
      child: const CreateRecurringDonationBottomSheetView(),
    );
  }
}

class CreateRecurringDonationBottomSheetView extends StatefulWidget {
  const CreateRecurringDonationBottomSheetView({super.key});

  @override
  State<CreateRecurringDonationBottomSheetView> createState() =>
      _CreateRecurringDonationBottomSheetViewState();
}

class _CreateRecurringDonationBottomSheetViewState
    extends State<CreateRecurringDonationBottomSheetView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final user = context.read<AuthCubit>().state.user;
    final country = Country.fromCode(user.country);

    final frequncies = [
      locals.setupRecurringGiftWeek,
      locals.setupRecurringGiftMonth,
      locals.setupRecurringGiftQuarter,
      locals.setupRecurringGiftHalfYear,
      locals.setupRecurringGiftYear,
    ];
    final cubit = context.watch<CreateRecurringDonationCubit>();
    return BottomSheetLayout(
      title: Text(locals.setupRecurringGiftTitle),
      bottomSheet: ElevatedButton(
        onPressed: isEnabled
            ? cubit.state.status == CreateRecurringDonationStatus.loading
                ? null
                : () {
                    //todo save recurring donation
                  }
            : null,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: Colors.grey,
        ),
        child: Text(
          locals.give,
        ),
      ),
      child: SingleChildScrollView(
        child: BlocConsumer<CreateRecurringDonationCubit,
            CreateRecurringDonationState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextRow(text: locals.setupRecurringGiftText1),
                Row(
                  children: [
                    Expanded(
                      child:
                          DropdownButtonFormField<RecurringDonationFrequency>(
                        value: state.frequency,
                        onChanged: (RecurringDonationFrequency? newValue) {
                          if (newValue == null) {
                            return;
                          }
                          context
                              .read<CreateRecurringDonationCubit>()
                              .setFrequency(newValue);
                        },
                        items: RecurringDonationFrequency.values
                            .map<DropdownMenuItem<RecurringDonationFrequency>>(
                                (RecurringDonationFrequency value) {
                          return DropdownMenuItem<RecurringDonationFrequency>(
                            value: value,
                            child: Text(frequncies[value.index]),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: Theme.of(context).textTheme.titleLarge,
                        controller: TextEditingController(
                          text: state.amount.toString().replaceAll('.', ','),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
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
                          context
                              .read<CreateRecurringDonationCubit>()
                              .setAmount(double.parse(value));
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Util.getCurrencyIconData(country: country),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _buildTextRow(text: locals.setupRecurringGiftText2),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(5),
                    child: TextFormField(
                      controller: TextEditingController(
                        text: state.recipient.orgName,
                      ),
                      readOnly: true,
                      onTap: () async {
                        final selectedRecipient =
                            await Navigator.of(context).push<CollectGroup>(
                          MaterialPageRoute(
                            builder: (contex) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (_) => OrganisationBloc(
                                    getIt(),
                                    getIt(),
                                    getIt(),
                                  )..add(
                                      OrganisationFetchForSelection(
                                        user.accountType,
                                      ),
                                    ),
                                ),
                                BlocProvider(
                                  create: (_) => GiveBloc(
                                    getIt(),
                                    getIt(),
                                    getIt(),
                                    getIt(),
                                  ),
                                ),
                              ],
                              child: const OrganizationListPage(
                                isSelection: true,
                              ),
                            ),
                          ),
                        );

                        if (selectedRecipient == null) {
                          return;
                        }

                        if (!mounted) {
                          return;
                        }

                        context
                            .read<CreateRecurringDonationCubit>()
                            .setRecipient(selectedRecipient);
                      },
                      decoration: InputDecoration(
                        hintText: locals.selectRecipient,
                        contentPadding: const EdgeInsets.all(20),
                        prefixIcon: state.recipient.orgName.isNotEmpty
                            ? Icon(
                                CollecGroupType.getIconByType(
                                  state.recipient.type,
                                ),
                                color: AppTheme.givtBlue,
                              )
                            : null,
                        errorStyle: const TextStyle(
                          height: 0,
                        ),
                        focusedErrorBorder: const UnderlineInputBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          borderSide: BorderSide(
                            color: AppTheme.givtLightGreen,
                            width: 8,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                          borderSide: BorderSide(
                            color: state.recipient.orgName.isNotEmpty
                                ? AppTheme.givtLightGreen
                                : Colors.transparent,
                            width: 8,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                _buildTextRow(text: locals.setupRecurringGiftText3),
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: DateFormat('dd MMM yyyy').format(state.startDate),
                  ),
                  onTap: () async {
                    final fromDate = await showDatePicker(
                      context: context,
                      initialDate: state.startDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (fromDate == null) {
                      return;
                    }
                    if (!mounted) {
                      return;
                    }
                    context
                        .read<CreateRecurringDonationCubit>()
                        .setStartDate(fromDate);
                  },
                ),
                _buildTextRow(text: locals.setupRecurringGiftText4),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: DateFormat('dd MMM yyyy').format(state.endDate),
                        ),
                        onTap: () async {
                          final untilDate = await showDatePicker(
                            context: context,
                            initialDate: state.endDate,
                            firstDate: state.startDate,
                            lastDate:
                                DateTime.now().add(const Duration(days: 1095)),
                          );
                          if (untilDate == null) {
                            return;
                          }
                          if (!mounted) {
                            return;
                          }
                          context
                              .read<CreateRecurringDonationCubit>()
                              .setEndDate(untilDate);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        locals.setupRecurringGiftText5,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: TextFormField(
                        controller: TextEditingController(
                          text: state.turns.toString(),
                        ),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'X'),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            return;
                          }
                          context
                              .read<CreateRecurringDonationCubit>()
                              .setTurns(int.parse(value));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        locals.setupRecurringGiftText6,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextRow({required String text}) => Column(
        children: [
          const SizedBox(height: 16),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
        ],
      );

  bool get isEnabled {
    final state = context.watch<CreateRecurringDonationCubit>().state;
    final auth = context.watch<AuthCubit>().state;
    final lowerLimit =
        Util.getLowerLimitByCountry(Country.fromCode(auth.user.country));
    return state.recipient.orgName.isNotEmpty &&
        (state.amount >= lowerLimit && state.amount <= auth.user.amountLimit) &&
        state.turns >= 1;
  }
}
