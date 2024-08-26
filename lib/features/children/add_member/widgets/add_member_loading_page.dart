import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/children/add_member/cubit/add_member_cubit.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/extensions/extensions.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/shared/widgets/family_scaffold.dart';
import 'package:givt_app/shared/widgets/setting_up_family_space_loading_widget.dart';
import 'package:givt_app/utils/snack_bar_helper.dart';

class AddMemberLoadingPage extends StatelessWidget {
  const AddMemberLoadingPage({super.key});
  void _popToProfileSelection(BuildContext context) {
    Navigator.of(context).popUntil(
      (route) => FamilyPages.profileSelection.name == route.settings.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AddMemberCubit>(),
      child: BlocListener<AddMemberCubit, AddMemberState>(
        listener: (context, state) {
          if (state.status == AddMemberStateStatus.success) {
            //  _popToProfileSelection(context);
            Navigator.push(
              context,
              FamilyScaffold(
                  body: Column(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: walletIcon(width: 140, height: 140),
                  ),
                  const TitleMediumText(
                    'Almost done...',
                  ),
                  const SizedBox(height: 8),
                  const BodyMediumText(
                    'Your payment method has been declined. Check with your bank and try again.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  BodyMediumText.primary40(
                    "But don't worry, we've saved your family members.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  const Spacer(),
                  GivtElevatedButton(
                    text: 'Continue',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              )).toRoute(context),
            ).then(
              (value) => _popToProfileSelection(context),
            );
          } else if (state.status == AddMemberStateStatus.successCached) {
            // 'Almost done screen Your payment method has been declined. Check with your bank and try again.' then pop to profile selection
            Navigator.push(
              context,
              FamilyScaffold(
                  body: Column(
                children: [
                  walletIcon(),
                  const TitleMediumText(
                    'Almost done...',
                  ),
                  const BodyMediumText(
                    'Your payment method has been declined. Check with your bank and try again.',
                  ),
                  const Spacer(),
                  GivtElevatedButton(
                    text: 'Continue',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              )).toRoute(context),
            ).then(
              (value) => _popToProfileSelection(context),
            );
          } else if (state.status == AddMemberStateStatus.successNoAllowances) {
            // 'We had trouble getting money from your account for the giving allowance(s).'
            _popToProfileSelection(context);
          } else if (state.status == AddMemberStateStatus.error) {
            _popToProfileSelection(context);
            SnackBarHelper.showMessage(context, text: state.error);
          } else {
            _popToProfileSelection(context);
            SnackBarHelper.showMessage(
              context,
              text: state.status.toString(),
            );
          }
        },
        child: const FamilyScaffold(
          body: SettingUpFamilySpaceLoadingWidget(),
        ),
      ),
    );
  }
}
