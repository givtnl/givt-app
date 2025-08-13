// This page implements the BarcodeLevelScanPage, which allows users to scan barcodes for the game level.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/generosity_hunt/cubit/scan_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
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

  final MobileScannerController _cameraController = MobileScannerController(
    returnImage: true,
  );
  bool _barcodeFound = false;

  // Spinning state
  bool _isSpinning = false;
  String? _spinningImage;

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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final userId = context.read<ProfilesCubit>().state.activeProfile.id;
    cubit.init(userId);
  }

  @override
  Widget build(BuildContext context) {
    return BaseStateConsumer(
      cubit: cubit,
      onInitial: (context) => const Center(child: CircularProgressIndicator()),
      onCustom: _onCustom,
      onData: (context, state) {
        return FunScaffold(
          canPop: false,
          minimumPadding: EdgeInsets.zero,
          appBar: FunTopAppBar(
            title: 'Level ${state.level?.level}',
            actions: [
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.xmark,
                  semanticLabel: 'Close',
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: _barcodeScannerBody(),
              ),
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
                      children:
                          List.generate(state.level?.itemsNeeded ?? 0, (index) {
                        // Show checkmark if item is scanned (index < scannedItems)
                        if (index < state.scannedItems) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: FunIcon.checkmark(
                              circleColor: FamilyAppTheme.primary50,
                              iconColor: Colors.white,
                              circleSize: 44,
                              iconSize: 24,
                              padding: EdgeInsets.zero,
                            ),
                          );
                        }

                        // Show numbered circle for unscanned items
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
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
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    TitleMediumText(
                      state.levelFinished
                          ? 'You did it!'
                          : state.itemScanned
                              ? 'You did it!\nOnly ${state.level!.itemsNeeded - state.scannedItems} to go!'
                              : state.level?.assignment ?? '',
                      textAlign: TextAlign.center,
                    ),
                    if (state.levelFinished || state.itemScanned)
                      const SizedBox(height: 16),

                    if (state.levelFinished)
                      FunButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        text: 'Continue',
                        analyticsEvent:
                            AnalyticsEvent(AmplitudeEvents.continueClicked),
                      ),

                    if (state.itemScanned && !state.levelFinished)
                      FunButton(
                        onTap: cubit.restartScan,
                        text: "Let's go",
                        analyticsEvent:
                            AnalyticsEvent(AmplitudeEvents.continueClicked),
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

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _startProductSpin() async {
    setState(() {
      _isSpinning = true;
      _spinningImage = null;
    });

    // Shuffle the images for random order
    final images = List<String>.from(_productImages)..shuffle();
    const spinInterval = Duration(milliseconds: 60); // Fast spin
    var tick = 0;
    var currentImage = images[0];

    while (_isSpinning) {
      await Future.delayed(spinInterval);
      setState(() {
        currentImage = images[tick % images.length];
        _spinningImage = currentImage;
      });
      tick++;
    }
  }

  Widget _barcodeScannerBody() {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: MobileScanner(
              controller: _cameraController,
              onDetect: cubit.onBarcodeDetected,
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
        ],
      ),
    );
  }

  void _onCustom(BuildContext context, ScanCustom custom) {
    switch (custom) {
      case ScanCustomBarcodeFound():
        _startProductSpin();
      case ScanCustomSuccessFullScan():
        _successFullScan(custom.itemsRemaining, custom.creditsEarned);
      case ScanCustomNotRecognized():
        _showNotRecognized();
      case ScanCustomStopSpinner():
        _stopSpinner();
      case ScanCustomProductAlreadyScanned():
        _showProductAlreadyScanned();
      case ScanCustomWrongProductScanned():
        _showWrongProductScanned();
    }
  }

  void _stopSpinner() {
    setState(() {
      _isSpinning = false;
    });
  }

  void _showNotRecognized() {
    _spinningImage = null;
    _isSpinning = false;

    FunBottomSheet(
      title: 'Oops, not recognized',
      content: const BodyMediumText(''), // TODO
      primaryButton: FunButton(
        onTap: () {
          cubit.restartScan();
          Navigator.pop(context);
        },
        text: 'Try again',
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.generosityHuntScanTryAgainClicked,
        ),
      ),
    ).show(
      context,
      isDismissible: false,
    );
  }

  void _showProductAlreadyScanned() {
    _spinningImage = null;
    _isSpinning = false;

    FunBottomSheet(
      title: 'Product already scanned',
      content: const BodyMediumText(''),
      primaryButton: FunButton(
        onTap: () {
          cubit.restartScan();
          Navigator.pop(context);
        },
        text: 'Try again',
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.generosityHuntScanTryAgainClicked,
        ),
      ),
    ).show(
      context,
      isDismissible: false,
    );
  }

  void _showWrongProductScanned() {
    _spinningImage = null;
    _isSpinning = false;

    FunBottomSheet(
      title: 'Wrong product scanned',
      content: const BodyMediumText(''),
      primaryButton: FunButton(
        onTap: () {
          cubit.restartScan();
          Navigator.pop(context);
        },
        text: 'Try again',
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.generosityHuntScanTryAgainClicked,
        ),
      ),
    ).show(
      context,
      isDismissible: false,
    );
  }

  void _successFullScan(int itemsRemaining, int credits) {
    setState(() {
      _isSpinning = false;
      _spinningImage = null;
    });

    // Show confetti
    if (!mounted) return;
    ConfettiHelper.show(context);

    FunBottomSheet(
      title: '+$credits Givt Credits!',
      content: const BodyMediumText(''),
      primaryButton: FunButton(
        onTap: () {
          if (itemsRemaining == 0) {
            cubit.completeLevel();
          }
          Navigator.pop(context);
        },
        text: 'Claim',
        analyticsEvent: AnalyticsEvent(
          AmplitudeEvents.generosityHuntScanClaimClicked,
        ),
      ),
    ).show(context);
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
