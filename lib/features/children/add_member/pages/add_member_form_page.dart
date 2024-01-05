import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/children/add_member/widgets/add_member_form.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';

class CreateMemberPage extends StatelessWidget {
  const CreateMemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddMemberCubit, AddMemberState>(
      builder: (context, state) {
        final addMembersCubit = context.read<AddMemberCubit>();
        final List<Key> memberKeys = [];
        int nrOfMembers = context.read<AddMemberCubit>().state.nrOfForms;

        for (var i = 0; i < nrOfMembers; i++) {
          memberKeys.add(GlobalKey());
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      setUpFamilyHeader(context),
                      const SizedBox(height: 20),
                      for (int i = 0; i < memberKeys.length; i++)
                        AddMemberForm(
                          firstMember: i == 0,
                          onRemove: addMembersCubit.decreaseNrOfForms,
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              addButton(context),
              continueButton(context),
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

  Widget addButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
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

  Widget continueButton(BuildContext context) {
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
