import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/design/components/content/fun_progressbar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';

class GenerosityHuntCountdownContainer extends StatefulWidget {
  const GenerosityHuntCountdownContainer({super.key});

  @override
  State<GenerosityHuntCountdownContainer> createState() =>
      _GenerosityHuntCountdownContainerState();
}

class _GenerosityHuntCountdownContainerState
    extends State<GenerosityHuntCountdownContainer> {
  
  late Timer _timer;
  int _currentProgress = 0;

  @override
  void initState() {
    super.initState();
    _calculateProgress();
    // Update progress every day
    _timer = Timer.periodic(const Duration(days: 1), (_) {
      _calculateProgress();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateProgress() {
    final now = DateTime.now();
    
    // Start date: August 3, 2025, 00:00 Tulsa timezone (UTC-6)
    // Tulsa is in Central Time (UTC-6), so August 3, 2025 00:00 Tulsa = August 3, 2025 06:00 UTC
    final startDate = DateTime.utc(2025, 8, 3, 6, 0); // 00:00 Tulsa time = 06:00 UTC
    
    // End date is 30 days later
    final endDate = startDate.add(const Duration(days: 30));
    
    int progress;
    
    if (now.isBefore(startDate)) {
      // If date hasn't started yet, show 30 days
      progress = 30;
    } else if (now.isAfter(endDate)) {
      // If past end date, show 0 days
      progress = 0;
    } else {
      // Calculate days difference from start date
      final difference = now.difference(startDate).inDays;
      progress = 30 - difference;
    }
    
    if (mounted) {
      setState(() {
        _currentProgress = progress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LabelLargeText.primary40(
                'Play the Generosity Hunt',
              ),
            ],
          ),
          const SizedBox(height: 12),
          FunProgressbar.generosityHunt(
            key: const ValueKey('Generosity-Hunt-Progressbar'),
            currentProgress: _currentProgress,
            total: 30,
            suffix: 'days left',
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
