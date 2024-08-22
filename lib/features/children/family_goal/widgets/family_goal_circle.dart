import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/overview/cubit/family_overview_cubit.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class FamilyGoalCircle extends StatefulWidget {
  const FamilyGoalCircle({
    this.amount = 0,
    this.showConfetti = false,
    super.key,
  });

  final int amount;
  final bool showConfetti;

  @override
  State<FamilyGoalCircle> createState() => _FamilyGoalCircleState();
}

class _FamilyGoalCircleState extends State<FamilyGoalCircle> {
  static const _avatarSize = 100.0;

  List<Profile> get _profiles {
    return (context.read<FamilyOverviewCubit>().state
            as FamilyOverviewUpdatedState)
        .profiles;
  }

  String get _familyLeaderId {
    return context.read<AuthCubit>().state.user.guid;
  }

  Profile get _familyLeader {
    return _profiles.firstWhere((profile) => profile.id == _familyLeaderId);
  }

  List<Profile> get _otherMembers {
    return [..._profiles]
      ..removeWhere((profile) => profile.id == _familyLeaderId);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: SizedBox.square(
        dimension: size.width,
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: SvgPicture.asset(
                  'assets/images/family_goal_circle_bg.svg',
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.amount > 0) const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SvgPicture.asset(
                        'assets/images/family_goal_circle_flag.svg',
                        width: 64,
                        height: 64,
                      ),
                    ),
                    if (widget.amount > 0)
                      Text(
                        '\$ ${widget.amount}',
                        style: GoogleFonts.mulish(
                          textStyle: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppTheme.givtGreen40,
                              ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            ),
            ..._fillFamilyCircleWithMembers(),
            if (widget.showConfetti)
              Positioned.fill(
                child: Lottie.asset(
                  'assets/lotties/confetti.json',
                  fit: BoxFit.fitWidth,
                  // repeat: false,
                  width: double.infinity,
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Positioned> _fillFamilyCircleWithMembers() {
    switch (_profiles.length) {
      case 2:
        return _familyCircleWithTwoMembers();
      case 3:
        return _familyCircleWithTreeMembers();
      case 4:
        return _familyCircleWithFourMembers();
      case 5:
        return _familyCircleWithFiveMembers();
      case 6:
        return _familyCircleWithSixMembers();
      default:
        return _familyCircleWithSixPlusMembers();
    }
  }

  List<Positioned> _familyCircleWithTwoMembers() {
    return <Positioned>[
      Positioned.fill(
        child: Row(
          children: [
            SvgPicture.network(
              _familyLeader.pictureURL,
              width: _avatarSize,
              height: _avatarSize,
            ),
            const Spacer(),
            SvgPicture.network(
              _otherMembers.first.pictureURL,
              width: _avatarSize,
              height: _avatarSize,
            ),
          ],
        ),
      ),
    ];
  }

  List<Positioned> _familyCircleWithTreeMembers() {
    final size = MediaQuery.sizeOf(context);
    return <Positioned>[
      Positioned.fill(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SvgPicture.network(
                _familyLeader.pictureURL,
                width: _avatarSize,
                height: _avatarSize,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      Positioned(
        bottom: size.width * 0.22,
        left: 0,
        right: 0,
        child: Row(
          children: [
            SvgPicture.network(
              _otherMembers[1].pictureURL,
              width: _avatarSize,
              height: _avatarSize,
            ),
            const Spacer(),
            SvgPicture.network(
              _otherMembers[0].pictureURL,
              width: _avatarSize,
              height: _avatarSize,
            ),
          ],
        ),
      ),
    ];
  }

  List<Positioned> _familyCircleWithFourMembers() {
    return <Positioned>[
      Positioned.fill(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SvgPicture.network(
                _familyLeader.pictureURL,
                width: _avatarSize,
                height: _avatarSize,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SvgPicture.network(
                _otherMembers[1].pictureURL,
                width: _avatarSize,
                height: _avatarSize,
              ),
            ),
          ],
        ),
      ),
      Positioned.fill(
        child: Row(
          children: [
            SvgPicture.network(
              _otherMembers[2].pictureURL,
              width: _avatarSize,
              height: _avatarSize,
            ),
            const Spacer(),
            SvgPicture.network(
              _otherMembers[0].pictureURL,
              width: _avatarSize,
              height: _avatarSize,
            ),
          ],
        ),
      ),
    ];
  }

  List<Positioned> _familyCircleWithFiveMembers() {
    final size = MediaQuery.sizeOf(context);
    return <Positioned>[
      Positioned.fill(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SvgPicture.network(
                _familyLeader.pictureURL,
                width: _avatarSize,
                height: _avatarSize,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      Positioned(
        top: size.width * 0.25,
        left: 0,
        right: 0,
        child: Row(
          children: [
            SvgPicture.network(
              _otherMembers[3].pictureURL,
              width: _avatarSize,
              height: _avatarSize,
            ),
            const Spacer(),
            SvgPicture.network(
              _otherMembers[0].pictureURL,
              width: _avatarSize,
              height: _avatarSize,
            ),
          ],
        ),
      ),
      Positioned(
        bottom: size.width * 0.15,
        left: 0,
        right: 0,
        child: Row(
          children: [
            const Spacer(),
            SvgPicture.network(
              _otherMembers[2].pictureURL,
              width: _avatarSize,
              height: _avatarSize,
            ),
            const Spacer(flex: 2),
            SvgPicture.network(
              _otherMembers[1].pictureURL,
              width: _avatarSize,
              height: _avatarSize,
            ),
            const Spacer(),
          ],
        ),
      ),
    ];
  }

  List<Positioned> _familyCircleWithSixMembers() {
    final size = MediaQuery.sizeOf(context);
    return <Positioned>[
      Positioned.fill(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SvgPicture.network(
                _familyLeader.pictureURL,
                width: _avatarSize,
                height: _avatarSize,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SvgPicture.network(
                _otherMembers[2].pictureURL,
                width: _avatarSize,
                height: _avatarSize,
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: size.width * 0.22,
        left: 0,
        right: 0,
        child: Row(
          children: [
            SvgPicture.network(
              _otherMembers[4].pictureURL,
              width: _avatarSize,
              height: _avatarSize,
            ),
            const Spacer(),
            SvgPicture.network(
              _otherMembers[0].pictureURL,
              width: _avatarSize,
              height: _avatarSize,
            ),
          ],
        ),
      ),
      Positioned(
        bottom: size.width * 0.22,
        left: 0,
        right: 0,
        child: Row(
          children: [
            SvgPicture.network(
              _otherMembers[3].pictureURL,
              width: _avatarSize,
              height: _avatarSize,
            ),
            const Spacer(),
            SvgPicture.network(
              _otherMembers[1].pictureURL,
              width: _avatarSize,
              height: _avatarSize,
            ),
          ],
        ),
      ),
    ];
  }

  List<Positioned> _familyCircleWithSixPlusMembers() {
    final size = MediaQuery.sizeOf(context);
    final moreProfilesNumber = _otherMembers.length - 4;
    return <Positioned>[
      Positioned.fill(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SvgPicture.network(
                _familyLeader.pictureURL,
                width: _avatarSize,
                height: _avatarSize,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CircleAvatar(
                radius: _avatarSize / 2,
                backgroundColor: AppTheme.sliderIndicatorNotFilled,
                child: Text(
                  context.l10n.familyGoalCircleMore(moreProfilesNumber),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.givtBlue,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: size.width * 0.22,
        left: 0,
        right: 0,
        child: Row(
          children: [
            SvgPicture.network(
              _otherMembers[4].pictureURL,
              width: _avatarSize,
              height: _avatarSize,
            ),
            const Spacer(),
            SvgPicture.network(
              _otherMembers[0].pictureURL,
              width: _avatarSize,
              height: _avatarSize,
            ),
          ],
        ),
      ),
      Positioned(
        bottom: size.width * 0.22,
        left: 0,
        right: 0,
        child: Row(
          children: [
            SvgPicture.network(
              _otherMembers[3].pictureURL,
              width: _avatarSize,
              height: _avatarSize,
            ),
            const Spacer(),
            SvgPicture.network(
              _otherMembers[1].pictureURL,
              width: _avatarSize,
              height: _avatarSize,
            ),
          ],
        ),
      ),
    ];
  }
}
