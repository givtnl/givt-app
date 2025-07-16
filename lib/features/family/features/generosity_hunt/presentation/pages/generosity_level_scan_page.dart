// This page implements the BarcodeLevelScanPage, which allows users to scan barcodes for the game level.
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/generosity_hunt/cubit/scan_cubit.dart';
import 'package:givt_app/features/family/features/generosity_hunt/presentation/pages/generosity_hunt_level_introduction_page.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/body_medium_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/animations/confetti_helper.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeLevelScanPage extends StatefulWidget {
  const BarcodeLevelScanPage({
    super.key,
  });

  @override
  State<BarcodeLevelScanPage> createState() => _BarcodeLevelScanPageState();
}

class _BarcodeLevelScanPageState extends State<BarcodeLevelScanPage> {
  final ScanCubit cubit = ScanCubit(getIt());

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cubit.init();
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: cubit,
      onData: (context, state) {
        final level = state.level;
        if (level == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return FunScaffold(
          minimumPadding: EdgeInsets.zero,
          appBar: FunTopAppBar(
            title: 'Level ${level.level}',
            leading: const GivtBackButtonFlat(),
          ),
          body: Column(
            children: [
              Expanded(
                child: _BarcodeScannerBody(),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 24,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Row of circles for each item
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(level.itemsNeeded, (index) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: FamilyAppTheme.neutral70,
                              width: 4,
                            ),
                            color: Colors.white,
                          ),
                          alignment: Alignment.center,
                          child: TitleMediumText(
                            (index + 1).toString(),
                            color: FamilyAppTheme.neutral70,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    TitleMediumText(
                      level.assignment,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BarcodeScannerBody extends StatefulWidget {
  @override
  State<_BarcodeScannerBody> createState() => _BarcodeScannerBodyState();
}

class _BarcodeScannerBodyState extends State<_BarcodeScannerBody> {
  final MobileScannerController _cameraController = MobileScannerController(
    returnImage: true,
  );

  bool _barcodeFound = false;
  String? _barcodeValue;

  // Product images (hardcoded list)
  static const List<String> _productImages = [
    'assets/family/images/barcode_hunt/products/Yogurt.svg',
    'assets/family/images/barcode_hunt/products/Vegtables.svg',
    'assets/family/images/barcode_hunt/products/Toothpaste.svg',
    'assets/family/images/barcode_hunt/products/Toothbrush.svg',
    'assets/family/images/barcode_hunt/products/Soda bottle.svg',
    'assets/family/images/barcode_hunt/products/Rock.svg',
    'assets/family/images/barcode_hunt/products/Meat.svg',
    'assets/family/images/barcode_hunt/products/Ketchup.svg',
    'assets/family/images/barcode_hunt/products/Empty Fridge.svg',
    'assets/family/images/barcode_hunt/products/Eggs.svg',
    'assets/family/images/barcode_hunt/products/Detergent.svg',
    'assets/family/images/barcode_hunt/products/Cookies.svg',
    'assets/family/images/barcode_hunt/products/Cleaning.svg',
    'assets/family/images/barcode_hunt/products/Chocolate.svg',
    'assets/family/images/barcode_hunt/products/Cereal.svg',
    'assets/family/images/barcode_hunt/products/Canned soup.svg',
    'assets/family/images/barcode_hunt/products/Can.svg',
    'assets/family/images/barcode_hunt/products/Can tuna.svg',
    'assets/family/images/barcode_hunt/products/Bread.svg',
    'assets/family/images/barcode_hunt/products/Box-Milk.svg',
    'assets/family/images/barcode_hunt/products/Beverage.svg',
    'assets/family/images/barcode_hunt/products/Banana.svg',
    'assets/family/images/barcode_hunt/products/Bag chips.svg',
  ];

  // Spinning state
  bool _isSpinning = false;
  String? _selectedProductImage;
  String? _spinningImage;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _onBarcodeDetected(BarcodeCapture barcodeCapture) async {
    if (_barcodeFound || _isSpinning) return;
    final barcode = barcodeCapture.barcodes.firstOrNull;
    if (barcode != null && barcode.rawValue != null) {
      setState(() {
        _barcodeFound = true;
        _barcodeValue = barcode.rawValue;
      });
      await _cameraController.pause();
      if (mounted) {
        await _startProductSpin();
      }
    }
  }

  Future<void> _startProductSpin() async {
    setState(() {
      _isSpinning = true;
      _spinningImage = null;
      _selectedProductImage = null;
    });
    // Shuffle the images for random order
    final images = List<String>.from(_productImages)..shuffle();
    const spinDuration = Duration(milliseconds: 2000);
    const spinInterval = Duration(milliseconds: 60); // Fast spin
    var tick = 0;
    var currentImage = images[0];
    final timer = Stopwatch()..start();
    while (timer.elapsed < spinDuration) {
      await Future.delayed(spinInterval);
      setState(() {
        currentImage = images[tick % images.length];
        _spinningImage = currentImage;
      });
      tick++;
    }
    timer.stop();
    // Pick a random product at the end
    final selected = (images..shuffle()).first;
    setState(() {
      _isSpinning = false;
      _selectedProductImage = selected;
      _spinningImage = null;
    });
    if (mounted) {
      ConfettiHelper.show(context);
    }
  }

  void _resetScan() {
    setState(() {
      _barcodeFound = false;
      _barcodeValue = null;
      _selectedProductImage = null;
      _spinningImage = null;
      _isSpinning = false;
    });
    _cameraController.start();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: MobileScanner(
              controller: _cameraController,
              onDetect:
                  (_barcodeFound || _isSpinning) ? null : _onBarcodeDetected,
            ),
          ),
          // Overlay with scan area
          if (!_barcodeFound && !_isSpinning)
            Positioned.fill(
              child: CustomPaint(
                painter: _BarcodeOverlayPainter(),
              ),
            ),
          if (_isSpinning && _spinningImage != null)
            // Spinning product image
            Center(
              child: SvgPicture.asset(
                _spinningImage!,
                width: 120,
                height: 240,
              ),
            ),
          if (_selectedProductImage != null)
            // Final product image with FunCard overlay
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    _selectedProductImage!,
                    width: 120,
                    height: 240,
                  ),
                  Positioned(
                    bottom: -40,
                    child: FunCard(
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.monetization_on,
                              size: 48, color: Color(0xFF4CAF50)),
                          SizedBox(height: 12),
                          BodyMediumText(
                            'You have earned 5 Givt Credits!',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      button: FunButton(
                        onTap: _resetScan,
                        text: 'Claim',
                        analyticsEvent: AnalyticsEvent(
                          AmplitudeEvents.claimRewardClicked,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (_barcodeFound && !_isSpinning && _selectedProductImage == null)
            // Show loading spinner while preparing spin
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (!_barcodeFound && !_isSpinning && _selectedProductImage == null)
            // Optionally, show nothing or a hint
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _BarcodeOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    // Scan area (centered rectangle)
    final scanWidth = size.width * 0.7;
    final scanHeight = size.height * 0.5;
    final left = (size.width - scanWidth) / 2;
    final top = (size.height - scanHeight) / 2;
    final scanRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, scanWidth, scanHeight),
      const Radius.circular(16),
    );

    // Draw dimmed background
    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()..addRRect(scanRect),
    );
    canvas.drawPath(path, paint);

    // Draw scan area border
    final borderPaint = Paint()
      ..color = FamilyAppTheme.primary80
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawRRect(scanRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
