import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/add_member/widgets/add_member_form.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

class CreateMemberPage extends StatefulWidget {
  const CreateMemberPage({super.key});

  @override
  State<CreateMemberPage> createState() => _CreateMemberPageState();
}

class _CreateMemberPageState extends State<CreateMemberPage> {
  int _nrOfMembers = 1;
  final List<Key> _memberKeys = [];

  @override
  void initState() {
    for (var i = 0; i < _nrOfMembers; i++) {
      _memberKeys.add(GlobalKey());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddMemberCubit, AddMemberState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      setUpFamilyHeader(),
                      const SizedBox(height: 20),
                      for (int i = 0; i < _memberKeys.length; i++)
                        AddMemberForm(
                          firstMember: i == 0,
                          onRemove: () {
                            setState(() {
                              _nrOfMembers--;
                              _memberKeys.removeAt(i);
                            });
                          },
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              addButton(),
              continueButton(),
            ],
          ),
        );
      },
    );
  }

  Widget setUpFamilyHeader() => Center(
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
  Widget addButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _nrOfMembers++;
          _memberKeys.add(GlobalKey());
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(
          color: AppTheme.givtLightGreen,
          width: 2,
        ),
      ),
      child: Text(
        '+ Add another member',
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: AppTheme.givtLightGreen,
              fontWeight: FontWeight.w900,
              fontFamily: 'Avenir',
              fontSize: 18,
            ),
      ),
    );
  }

  Widget continueButton() {
    // TODO: check if all forms are valid
    const enabled = true;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton(
        onPressed: enabled
            ? () {
                context.read<AddMemberCubit>().validateForms();
              }
            : null,
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
