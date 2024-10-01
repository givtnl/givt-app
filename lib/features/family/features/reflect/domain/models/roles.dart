import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

sealed class Role {
  const Role({required this.color, required this.name});

  const factory Role.superhero({String secretWord}) = SuperHero;

  const factory Role.reporter({List<String> questions}) = Reporter;

  const factory Role.sidekick() = Sidekick;

  final RoleColors color;
  final String name;
}

class SuperHero extends Role {
  const SuperHero({
    this.secretWord,
    super.color = RoleColors.primary,
    super.name = 'superhero',
  });

  final String? secretWord;
}

class Reporter extends Role {
  const Reporter({
    this.questions,
    super.color = RoleColors.secondary,
    super.name = 'reporter',
  });

  final List<String>? questions;
}

class Sidekick extends Role {
  const Sidekick({
    super.color = RoleColors.tertiary,
    super.name = 'sidekick',
  });
}

enum RoleColors {
  primary(
    backgroundColor: FamilyAppTheme.primary90,
    accentColor: FamilyAppTheme.primary80,
  ),
  secondary(
    backgroundColor: FamilyAppTheme.secondary90,
    accentColor: FamilyAppTheme.secondary90,
  ),
  highlight(
    backgroundColor: FamilyAppTheme.highlight98,
    accentColor: FamilyAppTheme.highlight95,
  ),
  tertiary(
    backgroundColor: FamilyAppTheme.tertiary90,
    accentColor: FamilyAppTheme.tertiary80,
  ),
  ;

  final Color backgroundColor;
  final Color accentColor;

  const RoleColors({
    required this.backgroundColor,
    required this.accentColor,
  });
}
