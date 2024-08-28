import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/features/reflect/bloc/interview_cubit.dart';
import 'package:givt_app/features/family/features/reflect/presentation/pages/pass_the_phone_screen.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/family_scaffold.dart';

class StartInterviewScreen extends StatefulWidget {
  const StartInterviewScreen({super.key});

  @override
  State<StartInterviewScreen> createState() => _StartInterviewScreenState();
}

class _StartInterviewScreenState extends State<StartInterviewScreen> {
  var cubit = getIt<InterviewCubit>();

  @override
  Widget build(BuildContext context) {
    return FamilyScaffold(
      body: Column(
        children: [
          GivtElevatedButton(
              onTap: () {
                Navigator.push(
                  context,
                  PassThePhone(
                    buttonText: 'Start Interview',
                    user: cubit.getReporters().first,
                    onTap: () {},
                  ).toRoute(context),
                );
              },
              text: '')
        ],
      ),
    );
  }
}
