import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class ConfettiDialog extends StatefulWidget {
  const ConfettiDialog({
    required this.duration,
    super.key,
  });

  final Duration duration;

  static Future<void> show(
      BuildContext context, {
        Duration duration = _defaultDuration,
      }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (_) => ConfettiDialog(duration: duration),
    );
  }

  static const Duration _defaultDuration = Duration(milliseconds: 2000);

  @override
  State<ConfettiDialog> createState() => _ConfettiDialogState();
}

class _ConfettiDialogState extends State<ConfettiDialog> {
  @override
  void initState() {
    super.initState();
    _schedulePop();
  }

  Future<void> _schedulePop() =>
      Future.delayed(widget.duration, () => context.pop());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/lotties/confetti.json',
        fit: BoxFit.fitWidth,
        width: double.infinity,
      ),
    );
  }
}
