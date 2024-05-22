import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class ChatConfettiDialog extends StatefulWidget {
  const ChatConfettiDialog({
    required this.duration,
    super.key,
  });

  final Duration duration;

  static Future<void> showChatConfettiDialog(
    BuildContext context, {
    Duration duration = _defaultDuration,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (_) => ChatConfettiDialog(duration: duration),
    );
  }

  static const Duration _defaultDuration = Duration(milliseconds: 2000);

  @override
  State<ChatConfettiDialog> createState() => _ChatConfettiDialogState();
}

class _ChatConfettiDialogState extends State<ChatConfettiDialog> {
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
