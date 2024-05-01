import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/generosity_challenge/cubit/daily_assignment_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/shared/widgets/givt_elevated_button.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class SelectFamilyValues extends StatelessWidget {
  const SelectFamilyValues({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GenerosityAppBar(
        title: 'Day 2',
        leading: BackButton(
          onPressed: context.pop,
          color: AppTheme.givtGreen40,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Select Family Values'),
              GivtElevatedButton(
                  onTap: () {
                    context.read<DailyAssignmentCubit>().completedFlow();
                    context.pop();
                  },
                  text: 'Done')
            ],
          ),
        ),
      ),
    );
  }
}
