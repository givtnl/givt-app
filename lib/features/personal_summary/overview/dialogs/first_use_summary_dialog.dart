import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/personal_summary/giving_goal/pages/setup_giving_goal_bottom_sheet.dart';
import 'package:givt_app/features/personal_summary/overview/bloc/personal_summary_bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/models.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstUseSummaryDialog extends StatefulWidget {
  const FirstUseSummaryDialog({
    super.key,
  });

  @override
  State<FirstUseSummaryDialog> createState() => _FirstUseSummaryDialogState();
}

class _FirstUseSummaryDialogState extends State<FirstUseSummaryDialog> {
  int currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.sizeOf(context);

    final names = [
      locals.budgetTestimonialSummaryName,
      locals.budgetTestimonialExternalGiftsName,
      locals.budgetTestimonialGivingGoalName,
    ];

    final content = [
      locals.budgetTestimonialSummary,
      locals.budgetTestimonialExternalGifts,
      locals.budgetTestimonialGivingGoal,
    ];

    final actionButtonStrings = [
      locals.budgetTestimonialSummaryAction,
      locals.budgetTestimonialExternalGiftsAction,
      locals.budgetTestimonialGivingGoalAction,
    ];

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
                            items: Testinomials.summary.map((testimonial) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    testimonial.image,
                                    scale: offsetDy == 120 ? 2.7 : 1.5,
                                  ),
                                  const SizedBox(height: 16),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: names[testimonial.index],
                                          style: textTheme.bodyLarge!.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: content[testimonial.index],
                                          style: textTheme.bodyLarge,
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                            }).toList(),
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
            height: 70,
          ),
          child: Column(
            children: [
              _buildAnimatedBottomIndexes(names, size, context),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    getIt<SharedPreferences>().setBool(
                      Util.testimonialsSummaryKey,
                      true,
                    );
                    Navigator.of(context).pop();
                    switch (currentIndex) {
                      case 1:
                        context.goNamed(
                          Pages.addExternalDonation.name,
                          extra: context.read<PersonalSummaryBloc>(),
                        );
                      case 2:
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          builder: (_) => BlocProvider.value(
                            value: context.read<PersonalSummaryBloc>(),
                            child: const SetupGivingGoalBottomSheet(),
                          ),
                        );
                      default:
                        Navigator.of(context).pop();
                        break;
                    }
                  },
                  child: Text(
                    actionButtonStrings[currentIndex],
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row _buildAnimatedBottomIndexes(
    List<String> list,
    Size size,
    BuildContext context,
  ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: list.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: size.width * 0.05,
              height: size.height * 0.01,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black)
                    .withOpacity(
                  currentIndex == entry.key ? 0.9 : 0.4,
                ),
              ),
            ),
          );
        }).toList(),
      );
}
