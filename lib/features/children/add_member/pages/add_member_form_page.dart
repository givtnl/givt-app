// ignore_for_file: prefer_const_constructors

import 'dart:ui';

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
  List<Key> _memberKeys = [];

  @override
  void initState() {
    for (int i = 0; i < _nrOfMembers; i++) {
      _memberKeys.add(GlobalKey());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddMemberCubit, AddMemberState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).viewInsets.bottom,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    setUpFamilyHeader(),
                    SizedBox(height: 20),
                    for (int i = 0; i < _memberKeys.length; i++)
                      Dismissible(
                        key: _memberKeys[i],
                        onDismissed: (direction) {
                          setState(() {
                            _nrOfMembers--;
                            _memberKeys.removeAt(i);
                          });
                        },
                        child: AddMemberForm(
                          addDivider: i > 0,
                        ),
                      ),
                    SizedBox(height: 20),
                    addButton(),
                    continueButton()
                  ],
                ),
              ),
            ),
          ],
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
        side: BorderSide(
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

  Widget continueButton({bool enabled = true}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton(
        onPressed: enabled
            ? () {
                context.read<AddMemberCubit>().validateForms();
              }
            : () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? AppTheme.givtLightGreen : Colors.grey,
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
