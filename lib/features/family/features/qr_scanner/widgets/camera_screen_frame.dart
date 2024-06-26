import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/features/family/shared/widgets/givt_back_button_flat.dart';

class CameraScreenFrame extends StatelessWidget {
  const CameraScreenFrame({
    required this.child,
    required this.feedback,
    super.key,
  });
  final Widget child;
  final String feedback;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.onPrimary,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        title: Text(
          "Scan the QR code",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        automaticallyImplyLeading: false,
        leading: const GivtBackButtonFlat(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 6, child: child),
            Container(
              height: 80,
              color: Theme.of(context).colorScheme.onPrimary,
              child: Center(
                child: Text(
                  feedback,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
