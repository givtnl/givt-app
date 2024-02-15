import 'dart:developer';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/edit_child/widgets/create_child_text_field.dart';
import 'package:givt_app/features/children/details/cubit/child_details_cubit.dart';
import 'package:givt_app/features/children/details/models/profile_ext.dart';
import 'package:givt_app/features/children/edit_child/cubit/edit_child_cubit.dart';
import 'package:givt_app/features/children/edit_child/models/edit_child.dart';
import 'package:givt_app/features/children/edit_child/widgets/giving_allowance_info_button.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/children/utils/child_date_utils.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class EditChildPage extends StatefulWidget {
  const EditChildPage({super.key});

  @override
  State<EditChildPage> createState() => _EditChildPageState();
}

class _EditChildPageState extends State<EditChildPage> {
  final _nameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _allowanceController = TextEditingController();

  void _editChild() {
    final name = _nameController.text.trim();

    final allowance = _allowanceController.text.isNotEmpty
        ? int.parse(
            _allowanceController.text
                .trim()
                .substring(1), // removing currency sign
          )
        : 0;

    final child = EditChild(
      firstName: name,
      allowance: allowance,
    );
    context.read<EditChildCubit>().editChild(child: child);
  }

  void _updateInputFields(
    ProfileExt profileDetails,
    EditChild child,
    String currencySymbol,
  ) {
    _nameController.text = child.firstName;
    _dateOfBirthController.text = ChildDateUtils.dateFormatter.format(
      DateTime.parse(profileDetails.dateOfBirth),
    );
    final allowanceText =
        '$currencySymbol${child.allowance.toStringAsFixed(0)}';
    _allowanceController.text = allowanceText;
  }

  void _refreshProfiles() {
    context.read<ChildDetailsCubit>().fetchChildDetails();
    context.read<FamilyOverviewCubit>().fetchFamilyProfiles();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;
    final currency = Util.getCurrency(countryCode: user.country);

    return BlocConsumer<EditChildCubit, EditChildState>(
      listener: (context, state) {
        log('edit child state changed on $state');
        if (state is EditChildExternalErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
        } else if (state is EditChildInputState ||
            state is EditChildInputErrorState) {
          _updateInputFields(
            state.profileDetails,
            state.child,
            currency.currencySymbol,
          );
        } else if (state is EditChildSuccessState) {
          _refreshProfiles();
          context.pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.arrow_back_ios_new_sharp),
                    label: Text(
                      context.l10n.cancel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.inputFieldBorderSelected,
                          ),
                    ),
                    onPressed: () {
                      context.pop();
                      AnalyticsHelper.logEvent(
                        eventName: AmplitudeEvents.childEditCancelClicked,
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    context.l10n.childEditProfile,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          body: state is EditChildUploadingState
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.sliderIndicatorFilled,
                  ),
                )
              : state is EditChildInputState ||
                      state is EditChildInputErrorState
                  ? SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CreateChildTextField(
                                    maxLength: 20,
                                    errorText: state is EditChildInputErrorState
                                        ? state.nameErrorMessage
                                        : null,
                                    controller: _nameController,
                                    labelText: context.l10n.firstName,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.name,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CreateChildTextField(
                                    enabled: false,
                                    controller: _dateOfBirthController,
                                    labelText: context.l10n.dateOfBirth,
                                    showCursor: true,
                                    textInputAction: TextInputAction.next,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 40),
                                  CreateChildTextField(
                                    enabled:
                                        !state.profileDetails.pendingAllowance,
                                    labelText: context
                                        .l10n.createChildGivingAllowanceTitle,
                                    errorText: state is EditChildInputErrorState
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
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      state.profileDetails.pendingAllowance
                                          ? context.l10n
                                              .editChildAllowancePendingInfo
                                          : context.l10n
                                              .childMonthlyGivingAllowanceRange,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: AppTheme
                                                .childGivingAllowanceHint,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const GivingAllowanceInfoButton(),
                                  const SizedBox(
                                    height: 80,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(left: 35, right: 35, bottom: 30),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.grey,
              ),
              onPressed: state is! EditChildUploadingState ? _editChild : null,
              child: Text(
                context.l10n.save,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}
