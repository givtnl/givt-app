import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:givt_app/features/children/generosity_challenge/models/color_combo.dart';

sealed class Role {
  const Role({required this.color, required this.name});

  const factory Role.superhero({String secretWord}) = SuperHero;

  const factory Role.reporter({List<String> questions}) = Reporter;

  const factory Role.sidekick() = Sidekick;

  final ColorCombo color;
  final String name;
}

class SuperHero extends Role {
  const SuperHero({
    this.secretWord,
    super.color = ColorCombo.primary,
    super.name = 'superhero',
  });

  final String? secretWord;
}

class Reporter extends Role {
  const Reporter({
    this.questions,
    super.color = ColorCombo.secondary,
    super.name = 'reporter',
  });

  final List<String>? questions;
}

class Sidekick extends Role {
  const Sidekick({
    super.color = ColorCombo.tertiary,
    super.name = 'sidekick',
  });
}
