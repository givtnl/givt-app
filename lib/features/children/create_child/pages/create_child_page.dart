import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/create_child/cubit/create_child_cubit.dart';
import 'package:givt_app/features/children/create_child/models/child.dart';
import 'package:givt_app/features/children/create_child/widgets/family_text_form_field.dart';
import 'package:givt_app/features/children/edit_child/widgets/giving_allowance_info_button.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class CreateChildPage extends StatefulWidget {
  const CreateChildPage({super.key});

  @override
  State<CreateChildPage> createState() => _CreateChildPageState();
}

class _CreateChildPageState extends State<CreateChildPage> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  //final _allowanceController = TextEditingController();

  void _createChildProfile() {
    final name = _nameController.text.trim();
    final age = int.parse(_ageController.text);
    final birthYear = DateTime.now().year - age;
    final dateOfBirth = DateTime(birthYear, 1, 1);

    final child = Child(
      firstName: name,
      dateOfBirth: dateOfBirth,
      allowance: 0,
    );
    context.read<CreateChildCubit>().rememberChild(child: child);
    //todo improve amplitude event
    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.createChildProfileClicked,
      eventProperties: {
        'name': name,
        'age': age,
        //'allowance': 0,
      },
    );
    context.goNamed(Pages.giveVPC.name);
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    // final currency = NumberFormat.simpleCurrency(
    //   name: Util.getCurrencyName(country: Country.fromCode(user.country)),
    // );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            context.pop();
            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.backClicked,
            );
          },
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<CreateChildCubit, CreateChildState>(
          listener: (context, state) {
            if (state is CreateChildExternalErrorState) {
              SnackBarHelper.showMessage(
                context,
                text: state.errorMessage,
                isError: true,
              );
            } else if (state is CreateChildSuccessState) {
              context.goNamed(Pages.childrenOverview.name);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Set up Family\n',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                      children: [
                        TextSpan(
                          text: 'Who will be joining you?',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          FamilyTextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the child's name";
                              }
                              if (value.length < 2) {
                                return 'Please enter a valid name';
                              }
                              if (value.length > 20) {
                                return 'Name is too long';
                              }
                              return null;
                            },
                            controller: _nameController,
                            hintText: context.l10n.firstName,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          FamilyTextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the child's age";
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid age';
                              }
                              if (int.parse(value) > 18) {
                                return 'Please add an adult instead';
                              }
                              return null;
                            },
                            controller: _ageController,
                            hintText: 'Age',
                            keyboardType: TextInputType.number,
                          ),
                        ]),
                      )),

                  const GivingAllowanceInfoButton(),
                  // Add a spacer if the keyboard is not visible
                  if (View.of(context).viewInsets.bottom <= 0) const Spacer(),
                  if (View.of(context).viewInsets.bottom > 0)
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _createChildProfile();
                        }
                      },
                      child: Text(
                        "Continue",
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (View.of(context).viewInsets.bottom <= 0)
          ? Padding(
              padding: const EdgeInsets.only(left: 35, right: 35, bottom: 30),
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _createChildProfile();
                  }
                },
                child: Text(
                  "Continue",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
