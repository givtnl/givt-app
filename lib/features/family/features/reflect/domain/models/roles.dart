import 'dart:ui';

import 'package:flutter/material.dart';

sealed class Role {
  const Role({this.color});

  const factory Role.superhero({String secretWord}) = SuperHero;

  const factory Role.reporter({List<String> questions}) = Reporter;

  const factory Role.sidekick() = Sidekick;

  final Color? color;
}

class SuperHero extends Role {
  const SuperHero({this.secretWord, super.color = Colors.red});

  final String? secretWord;
}

class Reporter extends Role {
  const Reporter({this.questions, super.color = Colors.blue});

  final List<String>? questions;
}

class Sidekick extends Role {
  const Sidekick({super.color = Colors.green});
}
