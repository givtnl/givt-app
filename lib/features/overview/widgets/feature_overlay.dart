import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/overview/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeatureOverlay extends StatefulWidget {
  const FeatureOverlay({required this.onDismiss, super.key});

  final VoidCallback onDismiss;

  @override
  State<FeatureOverlay> createState() => _FeatureOverlayState();
}

class _FeatureOverlayState extends State<FeatureOverlay> {
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    shouldDisplay();
  }

  Future<void> shouldDisplay() async {
    final prefs = getIt<SharedPreferences>();
    final hasBeenShown = prefs.getBool(Util.cancelFeatureOverlayKey) ?? false;

    if (!hasBeenShown) {
      setState(() {
        isVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        getIt<SharedPreferences>().setBool(Util.cancelFeatureOverlayKey, true);
        widget.onDismiss();
      },
      child: Visibility(
        visible: isVisible,
        child: Stack(
          children: [
            ClipPath(
              clipper: InvertedClipper(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                color: AppTheme.givtLightBlue.withOpacity(0.9),
              ),
            ),
            Positioned.fromRect(
              rect: Rect.fromLTWH(
                0,
                size.height / 2,
                size.width,
                200,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locals.cancelFeatureTitle,
                      style: textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      locals.cancelFeatureMessage,
                      style: textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
