import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/impact_groups/cubit/impact_groups_cubit.dart';
import 'package:givt_app/features/impact_groups/models/impact_group.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ImpactGroupRecieveInviteSheet extends StatelessWidget {
  const ImpactGroupRecieveInviteSheet(
      {required this.invitdImpactGroup, super.key});
  final ImpactGroup invitdImpactGroup;
  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'You have been invited\nto the ${invitdImpactGroup.name}',
            textAlign: TextAlign.center,
            style: GoogleFonts.mulish(
              textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          SvgPicture.asset('assets/images/family_superheroes.svg'),
          BlocBuilder<ImpactGroupsCubit, ImpactGroupsState>(
            builder: (context, state) {
              final groupId = state.impactGroups
                  .firstWhere(
                      (element) => element.status == ImpactGroupStatus.invited)
                  .id;
              return ElevatedButton(
                onPressed: () {
                  context
                      .read<ImpactGroupsCubit>()
                      .acceptGroupInvite(groupId: groupId);

                  if (user.needRegistration) {
                    final createStripe = user.personalInfoRegistered &&
                        (user.country == Country.us.countryCode);
                    context
                      ..goNamed(
                        Pages.registration.name,
                        queryParameters: {
                          'email': user.email,
                          'createStripe': createStripe.toString(),
                        },
                      )
                      ..pop();
                  } else {
                    context
                      ..goNamed(Pages.joinImpactGroupSuccess.name)
                      ..pop();
                  }
                },
                child: const Text('Accept the invite'),
              );
            },
          ),
        ],
      ),
    );
  }
}
