import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/add_member/widgets/add_member_form.dart';
import 'package:givt_app/features/children/add_member/widgets/success_add_member_page.dart';
import 'package:givt_app/features/children/add_member/widgets/vpc_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class CreateMemberPage extends StatefulWidget {
  const CreateMemberPage({super.key});

  @override
  State<CreateMemberPage> createState() => _CreateMemberPageState();
}

class _CreateMemberPageState extends State<CreateMemberPage> {
  final List<AddMemberForm> _forms = [];

  late final ScrollController _scrollController;

  final _scrollAnimationDuration = const Duration(milliseconds: 300);

  void _addMemberForm({
    bool isFirst = false,
  }) {
    final key = GlobalKey();
    _forms.add(
      AddMemberForm(
        firstMember: isFirst,
        key: key,
        onRemove: () {
          setState(() {
            _forms.removeWhere((element) => element.key == key);
          });
          context.read<AddMemberCubit>().decreaseNrOfForms();
        },
      ),
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
    super.dispose();
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        for (var i = 0; i < _forms.length; i++)
          KeyboardActionsItem(
            focusNode: _forms[i].ageFocusNode,
            toolbarButtons: [
              (node) {
                return GestureDetector(
                  onTap: () => node.unfocus(),
                  child: const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Text('DONE'),
                  ),
                );
              },
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddMemberCubit, AddMemberState>(
      listener: (context, state) {
        if (state.status == AddMemberStateStatus.error) {
          SnackBarHelper.showMessage(
            context,
            text: state.error,
            isError: true,
          );
          context.goNamed(Pages.childrenOverview.name);
        }
        if (state.status == AddMemberStateStatus.vpc) {
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
        if (state.nrOfForms == state.members.length &&
            state.formStatus == AddMemberFormStatus.initial) {
          context.read<AddMemberCubit>().allFormsFilled();
          return;
        }
      },
      builder: (context, state) {
        if (state.status == AddMemberStateStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == AddMemberStateStatus.success) {
          return const AddMemeberSuccessPage();
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
                            addButton(context),
                            continueButton(context),
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
            text: '${context.l10n.setUpFamily}\n',
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

  Widget addButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _addMemberForm();
          _scrollDown();
        });
        context.read<AddMemberCubit>().increaseNrOfForms();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(
          color: AppTheme.givtLightGreen,
          width: 2,
        ),
      ),
      child: Text(
        context.l10n.addAnotherMember,
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: AppTheme.givtLightGreen,
              fontWeight: FontWeight.w900,
              fontFamily: 'Avenir',
              fontSize: 18,
            ),
      ),
    );
  }

  Widget continueButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton(
        onPressed: context.read<AddMemberCubit>().validateForms,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.givtLightGreen,
          disabledBackgroundColor: Colors.grey,
        ),
        child: Text(
          context.l10n.continueKey,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontFamily: 'Avenir',
                fontSize: 18,
              ),
        ),
      ),
    );
  }
}
