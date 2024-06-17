import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/logging/logging_service.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/add_member/widgets/add_member_form.dart';
import 'package:givt_app/features/children/add_member/widgets/vpc_page.dart';
import 'package:givt_app/features/family/app/pages.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/buttons/custom_green_elevated_button.dart';
import 'package:givt_app/shared/widgets/buttons/custom_secondary_border_button.dart';
import 'package:givt_app/shared/widgets/setting_up_family_space_loading_widget.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class CreateMemberPage extends StatefulWidget {
  const CreateMemberPage({
    required this.familyAlreadyExists,
    super.key,
  });
  final bool familyAlreadyExists;
  @override
  State<CreateMemberPage> createState() => _CreateMemberPageState();
}

class _CreateMemberPageState extends State<CreateMemberPage> {
  final List<Widget> _forms = [];
  final Map<GlobalKey, FocusNode> _ageFocusNodes = {};

  late final ScrollController _scrollController;

  final _scrollAnimationDuration = const Duration(milliseconds: 300);

  void _addMemberForm({
    bool isFirst = false,
  }) {
    final key = GlobalKey();
    final ageFocusNode = FocusNode();
    _ageFocusNodes[key] = ageFocusNode;
    _forms.add(
      AddMemberForm(
        firstMember: isFirst,
        key: key,
        ageFocusNode: ageFocusNode,
        onRemove: () {
          setState(() {
            _forms.removeWhere((element) => element.key == key);
            _ageFocusNodes[key]?.dispose();
            _ageFocusNodes.remove(key);
          });
          context.read<AddMemberCubit>().decreaseNrOfForms();
        },
      ),
    );
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardBarColor: AppTheme.keyboardBackgroundColor,
      nextFocus: false,
      actions: [
        for (final node in _ageFocusNodes.values)
          KeyboardActionsItem(
            focusNode: node,
            toolbarButtons: [
              (node) {
                return GestureDetector(
                  onTap: () => node.unfocus(),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      'DONE',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                );
              },
            ],
          ),
      ],
    );
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _addMemberForm(isFirst: true);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _ageFocusNodes.forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddMemberCubit, AddMemberState>(
      listener: (context, state) {
        LoggingInfo.instance.info(
          'State: ${state.status}, formStatus: ${state.formStatus}',
          methodName: 'listener',
        );
        if (state.status == AddMemberStateStatus.error) {
          SnackBarHelper.showMessage(
            context,
            text: state.error,
            isError: true,
          );
          context.goNamed(FamilyPages.childrenOverview.name);
        }
        if (state.status == AddMemberStateStatus.vpc) {
          LoggingInfo.instance.info(
            'Show VPC bottom sheet',
            methodName: 'listener',
          );
          showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (_) => BlocProvider.value(
              value: context.read<AddMemberCubit>(),
              child: const VPCPage(),
            ),
          ).then((value) {
            if (context.read<AddMemberCubit>().state.status ==
                AddMemberStateStatus.loading) {
              return;
            }
            context.read<AddMemberCubit>().dismissedVPC();
          });
        }
        if (state.status == AddMemberStateStatus.continueWithoutVPC) {
          LoggingInfo.instance.info(
            'Continue without VPC',
            methodName: 'listener',
          );
          context.read<AddMemberCubit>().createMember();
        }
        if (state.nrOfForms == state.members.length &&
            state.formStatus == AddMemberFormStatus.initial) {
          LoggingInfo.instance.info(
            'All forms filled',
            methodName: 'listener',
          );
          context.read<AddMemberCubit>().allFormsFilled();
          return;
        }

        if (state.status == AddMemberStateStatus.success ||
            state.status == AddMemberStateStatus.successCached ||
            state.status == AddMemberStateStatus.successNoAllowances) {
          context.goNamed(FamilyPages.profileSelection.name);
        }
      },
      builder: (context, state) {
        if (state.status == AddMemberStateStatus.loading) {
          return const SettingUpFamilySpaceLoadingWidget();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: KeyboardActions(
                  config: _buildConfig(context),
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            setUpFamilyHeader(context),
                            const SizedBox(height: 20),
                            ..._forms,
                          ],
                        ),
                      ),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          children: [
                            const Spacer(),
                            CustomSecondaryBorderButton(
                              title: context.l10n.addAnotherMember,
                              onPressed: () {
                                setState(() {
                                  _addMemberForm();
                                  _scrollDown();
                                });
                                context
                                    .read<AddMemberCubit>()
                                    .increaseNrOfForms();
                              },
                            ),
                            CustomGreenElevatedButton(
                              title: context.l10n.continueKey,
                              onPressed:
                                  context.read<AddMemberCubit>().validateForms,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget setUpFamilyHeader(BuildContext context) => Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: widget.familyAlreadyExists
                ? '${context.l10n.addMember}\n'
                : '${context.l10n.setUpFamily}\n',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
            children: [
              TextSpan(
                text: context.l10n.whoWillBeJoiningYou,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
              ),
            ],
          ),
        ),
      );

  void _scrollDown() {
    final Duration scrollDelay;
    if (MediaQuery.of(context).viewInsets.bottom == 0) {
      //need to wait a bit longer until keyboard will appear
      scrollDelay = const Duration(milliseconds: 700);
    } else {
      scrollDelay = const Duration(milliseconds: 400);
    }

    Future.delayed(scrollDelay, () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: _scrollAnimationDuration,
        curve: Curves.linearToEaseOut,
      );
    });
  }
}
