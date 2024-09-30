import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/features/profiles/screens/profile_screen.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';

class KidsHomeScreen extends StatelessWidget {
  const KidsHomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FunTopAppBar(
        title: context.read<ProfilesCubit>().state.activeProfile.firstName,
        leading: const GivtBackButtonFlat(),
      ),
      body: const ProfileScreen(),
    );
  }
}
