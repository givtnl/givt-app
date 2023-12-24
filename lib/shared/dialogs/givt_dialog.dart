import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';

class GivtDialog extends StatelessWidget {
  const GivtDialog({
    required this.content,
    super.key,
  });

  final Widget content;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.sizeOf(context);
    var offsetDy = 100;
    if (size.height < 600) {
      offsetDy = 80;
    }
    return Stack(
      children: [
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: LimitedBox(
            maxWidth: size.width * 0.8,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      height: constraints.maxHeight * 0.4,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                    Positioned(
                      right: -5,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 32,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Positioned.fromRect(
          rect: Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2 + offsetDy),
            width: size.width * 0.6,
            height: 50,
          ),
          child: SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                locals.budgetExternalGiftsListAddEditButton,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
