import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/details/cubit/child_details_cubit.dart';
import 'package:givt_app/features/children/edit_child/cubit/edit_child_cubit.dart';
import 'package:givt_app/features/children/edit_child/models/edit_child.dart';
import 'package:givt_app/features/children/edit_child/widgets/create_child_text_field.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/children/utils/child_date_utils.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/components/navigation/fun_top_app_bar.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/loading/full_screen_loading_widget.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class EditChildPage extends StatefulWidget {
  const EditChildPage({
    super.key,
  });

  @override
  State<EditChildPage> createState() => _EditChildPageState();
}

class _EditChildPageState extends State<EditChildPage> {
  final _nameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  void _editChild() {
    context.read<EditChildCubit>().editChild(name: _nameController.text.trim());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  void _updateInputFields(
    Profile profileDetails,
    EditChild child,
    String currencySymbol,
  ) {
    _nameController.text = child.firstName;
    _dateOfBirthController.text = ChildDateUtils.dateFormatter.format(
      DateTime.parse(profileDetails.dateOfBirth),
    );
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
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else if (state is EditChildInputState) {
          _updateInputFields(
            state.profileDetails,
            state.child,
            currency.currencySymbol,
          );
        } else if (state is EditChildInputErrorState) {
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
        return FunScaffold(
          appBar: FunTopAppBar(
            title: context.l10n.childEditProfile,
            leading: const GivtBackButtonFlat(),
          ),
          body: state is EditChildUploadingState
              ? const FullScreenLoadingWidget()
              : state is EditChildInputState ||
                      state is EditChildInputErrorState
                  ? SingleChildScrollView(
                      child: Column(
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
                        ],
                      ),
                    )
                  : Container(),
          floatingActionButton: FunButton(
            onTap: state is! EditChildUploadingState ? _editChild : null,
            text: context.l10n.save,
            analyticsEvent: AnalyticsEvent(
              AmplitudeEvents.childEditSaveClicked,
            ),
          ),
        );
      },
    );
  }
}
