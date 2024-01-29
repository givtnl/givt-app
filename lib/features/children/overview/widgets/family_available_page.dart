import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/family_history/family_history.dart';
import 'package:givt_app/features/children/overview/models/profile.dart';
import 'package:givt_app/features/children/overview/widgets/profiles_overview_widget.dart';

class FamilyAvailablePage extends StatelessWidget {
  const FamilyAvailablePage({
    required this.profiles,
    super.key,
  });

  final List<Profile> profiles;

  @override
  Widget build(BuildContext context) {
    final currentUserFirstName = context.read<AuthCubit>().state.user.firstName;
    // The Givt user profile is first in the list
    final sortedAdultProfiles = profiles.where((p) => p.isAdult).toList()
      ..sort((a, b) {
        final compareNames = a.firstName.compareTo(b.firstName);
        return a.firstName == currentUserFirstName
            ? -1
            : b.firstName == currentUserFirstName
                ? 1
                : compareNames;
      });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfilesOverviewWidget(
          profiles: sortedAdultProfiles,
        ),
        const SizedBox(height: 20),
        ProfilesOverviewWidget(
          profiles: profiles.where((p) => p.isChild).toList(),
        ),
        const SizedBox(height: 32),
        const Expanded(
          child: FamilyHistory(),
        )
      ],
    );
  }
}
