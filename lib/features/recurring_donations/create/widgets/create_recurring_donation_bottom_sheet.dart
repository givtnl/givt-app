import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/give/give.dart';
import 'package:givt_app/features/give/bloc/organisation/organisation.dart';
import 'package:givt_app/features/give/pages/organization_list_page.dart';
import 'package:givt_app/features/recurring_donations/create/cubit/create_recurring_donation_cubit.dart';
import 'package:givt_app/features/recurring_donations/create/models/recurring_donation_frequency.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CreateRecurringDonationBottomSheet extends StatelessWidget {
  const CreateRecurringDonationBottomSheet({
    super.key,
    this.recipient,
  });

  final CollectGroup? recipient;

  @override
  Widget build(BuildContext context) {
    final cubit = CreateRecurringDonationCubit(
      getIt(),
      showSuccessScreen: recipient != null,
    );
    if (recipient != null) {
      cubit.setRecipient(recipient!);
    }
    return BlocProvider(
      create: (_) => cubit,
      child: const _CreateRecurringDonationBottomSheetView(),
    );
  }
}

class _CreateRecurringDonationBottomSheetView extends StatefulWidget {
  const _CreateRecurringDonationBottomSheetView();

  @override
  State<_CreateRecurringDonationBottomSheetView> createState() =>
      _CreateRecurringDonationBottomSheetViewState();
}

class _CreateRecurringDonationBottomSheetViewState
    extends State<_CreateRecurringDonationBottomSheetView> {
  late TextEditingController amountController;
  late TextEditingController turnsController;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(
      text:
          context.read<CreateRecurringDonationCubit>().state.amount.toString(),
    );
    turnsController = TextEditingController(
      text: context.read<CreateRecurringDonationCubit>().state.turns.toString(),
    );
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
    final currencySymbol = NumberFormat.simpleCurrency(
      name: country.currency,
    ).currencySymbol;

    if (user.country != Country.us.countryCode ||
        !Country.unitedKingdomCodes().contains(user.country)) {
      amountController.text = amountController.text.replaceAll('.', ',');
    }
    amountController.text = amountController.text;
    return BottomSheetLayout(
      title: Text(locals.setupRecurringGiftTitle),
      bottomSheet: cubit.state.status == CreateRecurringDonationStatus.loading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ElevatedButton(
              onPressed: isEnabled
                  ? () async {
                      cubit.setAmount(
                        double.parse(
                          amountController.text.replaceAll(',', '.'),
                        ),
                      );
                      return cubit.submit(
                        guid: user.guid,
                        country: country.countryCode,
                        lowerLimit: Util.getLowerLimitByCountry(country),
                        maxLimit: user.amountLimit,
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.grey,
              ),
              child: Text(locals.give),
            ),
      child: SingleChildScrollView(
        child: BlocConsumer<CreateRecurringDonationCubit,
            CreateRecurringDonationState>(
          listener: (context, state) {
            if (state.status == CreateRecurringDonationStatus.success) {
              if (state.showSuccessScreen) {
                context.goNamed(
                  Pages.giveSucess.name,
                  extra: {
                    'isRecurringDonation': true,
                    'orgName': state.recipient.orgName,
                  },
                );
                return;
              }
              context.pop();
            }
            if (state.status == CreateRecurringDonationStatus.error) {
              showDialog<void>(
                context: context,
                builder: (_) => WarningDialog(
                  title: context.l10n.errorOccurred,
                  content: context.l10n.setupRecurringDonationFailed,
                  onConfirm: () => context.pop(),
                ),
              );
            }
            if (state.status ==
                CreateRecurringDonationStatus.duplicateDonation) {
              showDialog<void>(
                context: context,
                builder: (_) => WarningDialog(
                  title:
                      context.l10n.setupRecurringDonationFailedDuplicateTitle,
                  content: context.l10n.setupRecurringDonationFailedDuplicate,
                  onConfirm: () => context.pop(),
                ),
              );
            }

            if (state.status == CreateRecurringDonationStatus.amountTooHigh) {
              showDialog<void>(
                context: context,
                builder: (_) => WarningDialog(
                  title: context.l10n.amountTooHigh,
                  content: context.l10n.amountLimitExceededRecurringDonation,
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () => context.pop(),
                      child: Text(context.l10n.chooseLowerAmount),
                    ),
                    CupertinoDialogAction(
                      onPressed: () {
                        context.pop();
                        context.read<CreateRecurringDonationCubit>()
                          ..setAmountTooHighConfirmed()
                          ..submit(
                            guid: user.guid,
                            country: country.countryCode,
                            lowerLimit: Util.getLowerLimitByCountry(country),
                            maxLimit: user.amountLimit,
                          );
                      },
                      child: Text(context.l10n.continueKey),
                    ),
                  ],
                ),
              );
            }

            if (state.status == CreateRecurringDonationStatus.amountTooLow) {
              showDialog<void>(
                context: context,
                builder: (_) {
                  final limitAmount = Util.formatNumberComma(
                    Util.getLowerLimitByCountry(country),
                    country,
                  );
                  return WarningDialog(
                    title: context.l10n.amountTooLow,
                    content: context.l10n.givtNotEnough(
                      '$currencySymbol $limitAmount',
                    ),
                    onConfirm: () => context.pop(),
                  );
                },
              );
            }

            if (state.status == CreateRecurringDonationStatus.notInternet) {
              showDialog<void>(
                context: context,
                builder: (_) => WarningDialog(
                  title: context.l10n.offlineGiftsTitle,
                  content: context.l10n.noInternet,
                  onConfirm: () => context.pop(),
                ),
              );
            }
          },
          builder: (context, state) {
            turnsController.text = state.turns.toString();
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
                        controller: amountController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            Util.numberInputFieldRegExp(),
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
                        /// Because this is a special field and go_router doesn't supports
                        /// results from a route but you have to use the cubits/blocs to manage that
                        /// I opted for using the Navigator directly as it's a simple use case
                        /// and it requried minimal changes for the [organization_list_page.dart]
                        final selectedRecipient =
                            await Navigator.of(context).push<CollectGroup>(
                          MaterialPageRoute(
                            builder: (contex) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (_) => OrganisationBloc(
                                    getIt(),
                                    getIt(),
                                  )..add(
                                      OrganisationFetchForSelection(
                                        Country.fromCode(user.country),
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
                                CollectGroupType.getIconByType(
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
                      lastDate: DateTime.now().add(const Duration(days: 3660)),
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
                                DateTime.now().add(const Duration(days: 3660)),
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
                        controller: turnsController,
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
                const SizedBox(
                  height: 50,
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
    return state.recipient.orgName.isNotEmpty && state.turns >= 1;
  }
}
