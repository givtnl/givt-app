import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

sealed class Role {
  const Role({required this.color, required this.name});

  const factory Role.superhero({String secretWord}) = SuperHero;

  const factory Role.reporter({List<String> questions}) = Reporter;

  const factory Role.sidekick() = Sidekick;

  final Color color;
  final String name;
}

class SuperHero extends Role {
  const SuperHero({
    this.secretWord,
    super.color = FamilyAppTheme.primary80,
    super.name = 'superhero',
  });

  final String? secretWord;
}

class Reporter extends Role {
  const Reporter({
    this.questions,
    super.color = FamilyAppTheme.secondary90,
    super.name = 'reporter',
  });

  final List<String>? questions;
}

class Sidekick extends Role {
  const Sidekick({
    super.color = FamilyAppTheme.tertiary80,
    super.name = 'sidekick',
  });
}
