import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/models.dart';

class FirstUseYearlyDialog extends StatefulWidget {
  const FirstUseYearlyDialog({
    required this.onTap,
    super.key,
  });

  final VoidCallback onTap;

  @override
  State<FirstUseYearlyDialog> createState() => _FirstUseYearlyDialogState();
}

class _FirstUseYearlyDialogState extends State<FirstUseYearlyDialog> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.sizeOf(context);

    final textTheme = Theme.of(context).textTheme;

    var offsetDy = 130;
    if (size.height < 600) {
      offsetDy = 120;
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
                      height: constraints.maxHeight * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              enableInfiniteScroll: false,
                              height: size.height * 0.37,
                              viewportFraction: 1,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                            ),
                            items: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    Testinomials.testimonial4.image,
                                    scale: offsetDy == 120 ? 2.7 : 1.5,
                                  ),
                                  const SizedBox(height: 16),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: locals.budgetTooltipYearly,
                                          style: textTheme.bodyLarge!.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: locals
                                              .budgetTestimonialYearlyOverview,
                                          style: textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                widget.onTap();
              },
              child: Text(
                locals.budgetTestimonialYearlyOverviewAction,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
