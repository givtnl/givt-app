import 'dart:developer';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/route_utils.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/create_child/cubit/create_child_cubit.dart';
import 'package:givt_app/features/children/create_child/models/child.dart';
import 'package:givt_app/features/children/create_child/widgets/create_child_text_field.dart';
import 'package:givt_app/features/children/create_child/widgets/giving_allowance_info_bottom_sheet.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CreateChildPage extends StatefulWidget {
  const CreateChildPage({super.key});

  @override
  State<CreateChildPage> createState() => _CreateChildPageState();
}

class _CreateChildPageState extends State<CreateChildPage> {
  Future<void> _showDataPickerDialog() async {
    final today = DateTime.now();
    final maximumDate = today;
    final minimumDate = DateTime(today.year - 18);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: minimumDate,
      lastDate: maximumDate,
    );

    if (pickedDate != null) {
      log('picked date: ${pickedDate.toIso8601String()}');
      _selectedDate = pickedDate;
      _setDateOfBirthText(_selectedDate);
    }
  }

  final _nameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _allowanceController = TextEditingController();
  final _dateFormatter = DateFormat('MM-dd-yyyy');
  var _selectedDate = DateTime.now();

  void _setDateOfBirthText(DateTime? date) {
    _dateOfBirthController.text =
        date != null ? _dateFormatter.format(date) : '';
  }

  void _createChildProfile() {
    final name = _nameController.text.trim();
    final dateOfBirth =
        _dateOfBirthController.text.isNotEmpty ? _selectedDate : null;

    final allowance = _allowanceController.text.isNotEmpty
        ? int.parse(
            _allowanceController.text
                .trim()
                .substring(1), // removing currency sign
          )
        : null;

    final user = context.read<AuthCubit>().state.user;
    final child = Child(
      parentId: user.guid,
      firstName: name,
      dateOfBirth: dateOfBirth,
      allowance: allowance,
    );
    context.read<CreateChildCubit>().createChild(child: child);
    AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.createChildProfileClicked,
        eventProperties: {
          'name': name,
          'dateOfBirth': dateOfBirth?.toIso8601String(),
          'allowance': allowance,
        });
  }

  void _updateInputFields(Child? child, String currencySymbol) {
    _nameController.text = child?.firstName ?? '';
    _setDateOfBirthText(child?.dateOfBirth);
    var allowanceText = '';
    if (child != null && child.allowance != null) {
      allowanceText = '$currencySymbol${child.allowance}';
    }
    _allowanceController.text = allowanceText;
  }

  Widget _createGivingAllowanceInfoButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: TextButton.icon(
        icon: const Icon(
          Icons.info_rounded,
          size: 20,
          color: AppTheme.sliderIndicatorFilled,
        ),
        label: Text(
          AppLocalizations.of(context).createChildGivingAllowanceInfoButton,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppTheme.sliderIndicatorFilled,
              ),
        ),
        onPressed: () {
          AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.infoGivingAllowanceClicked);
          showModalBottomSheet<void>(
            context: context,
            backgroundColor: AppTheme.givtPurple,
            showDragHandle: true,
            useSafeArea: true,
            builder: (context) => const GivingAllowanceInfoBottomSheet(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final user = context.read<AuthCubit>().state.user;
    final currency = NumberFormat.simpleCurrency(
      name: Util.getCurrencyName(country: Country.fromCode(user.country)),
    );

    return Scaffold(
      body: BlocConsumer<CreateChildCubit, CreateChildState>(
        listener: (context, state) {
          log('create child state changed on $state');
          if (state is CreateChildExternalErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage,
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Theme.of(context).errorColor,
              ),
            );
          } else if (state is CreateChildInputState ||
              state is CreateChildInputErrorState) {
            _updateInputFields(state.child, currency.currencySymbol);
          } else if (state is CreateChildSuccessState) {
            context.goNamed(Pages.childrenOverview.name);
          }
        },
        builder: (context, state) {
          if (state is CreateChildUploadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CreateChildInputState ||
              state is CreateChildInputErrorState) {
            final locals = AppLocalizations.of(context);
            return Container(
              padding: const EdgeInsets.only(top: 35),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: size.height * 0.035,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      height: size.height * 0.82,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              locals.createChildPageTitle,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: AppTheme.sliderIndicatorFilled),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          CreateChildTextField(
                            maxLength: 20,
                            errorText: state is CreateChildInputErrorState
                                ? state.nameErrorMessage
                                : null,
                            controller: _nameController,
                            labelText: locals.firstName,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CreateChildTextField(
                            controller: _dateOfBirthController,
                            errorText: state is CreateChildInputErrorState
                                ? state.dateErrorMessage
                                : null,
                            labelText: locals.dateOfBirth,
                            onTap: _showDataPickerDialog,
                            showCursor: true,
                            textInputAction: TextInputAction.next,
                            readOnly: true,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          CreateChildTextField(
                            labelText: locals.createChildGivingAllowanceHint,
                            errorText: state is CreateChildInputErrorState
                                ? state.allowanceErrorMessage
                                : null,
                            controller: _allowanceController,
                            maxLength: 4,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              CurrencyTextInputFormatter(
                                locale: currency.locale,
                                decimalDigits: 0,
                                turnOffGrouping: true,
                                enableNegative: false,
                                symbol: currency.currencySymbol,
                              )
                            ],
                            keyboardType: TextInputType.number,
                          ),
                          _createGivingAllowanceInfoButton(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 35,
                        right: 35,
                        bottom: 30,
                      ),
                      child: ElevatedButton(
                        onPressed: _createChildProfile,
                        child: Text(
                          locals.createChildProfileButton,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
