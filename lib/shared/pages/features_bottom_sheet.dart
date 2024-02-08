import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:givt_app/utils/utils.dart';

class FeaturesBottomSheet extends StatelessWidget {
  const FeaturesBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonalInfoEditBloc(
        authRepositoy: getIt(),
        loggedInUserExt: context.read<AuthCubit>().state.user,
      ),
      child: const _FeaturesBottomSheetView(),
    );
  }
}

class _FeaturesBottomSheetView extends StatefulWidget {
  const _FeaturesBottomSheetView();

  @override
  State<_FeaturesBottomSheetView> createState() =>
      _FeaturesBottomSheetViewState();
}

class _FeaturesBottomSheetViewState extends State<_FeaturesBottomSheetView> {
  late PageController pageViewController;
  int current = 1;

  @override
  void initState() {
    super.initState();
    pageViewController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final isDutch = context.l10n.localeName.toLowerCase().contains('nl');
    return BottomSheetLayout(
      title: Text(locals.featureStepTitle(current, 3)),
      child: PageView(
        controller: pageViewController,
        children: [
          Feature(
            actionText: locals.prepareIUnderstand,
            action: () async {
              /// Request permission for push notifications
              await FirebaseMessaging.instance.requestPermission();

              await pageViewController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              setState(() {
                current++;
              });
            },
            imageName: const [
              'pushnot_scherm1.png',
              'pushnot_scherm2.png',
              'pushnot_scherm3.png',
            ],
            titles: [
              locals.featurePush1Title,
              locals.featurePush2Title,
              locals.featurePush3Title,
            ],
            messages: [
              locals.featurePush1Message,
              locals.featurePush2Message,
              locals.featurePush3Message,
            ],
          ),
          Feature(
            actionText: locals.featureNewguiAction,
            action: () {
              pageViewController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              setState(() {
                current++;
              });
            },
            imageName: [
              if (isDutch) 'ui_new_scherm1.png' else 'ui_new_scherm1_en.png',
              'ui_new_scherm2.png',
              'ui_new_scherm3.png',
            ],
            titles: [
              locals.featureNewgui1Title,
              locals.featureNewgui2Title,
              locals.featureNewgui3Title,
            ],
            messages: [
              locals.featureNewgui1Message,
              locals.featureNewgui2Message,
              locals.featureNewgui3Message,
            ],
          ),
          Feature(
            actionText: locals.featureNewguiAction,
            action: () => Navigator.of(context).pop(),
            imageName: [
              if (isDutch)
                'recurring_donations_01_nl.png'
              else
                'recurring_donations_01_gb.png',
              if (isDutch)
                'recurring_donations_02_nl.png'
              else
                'recurring_donations_02_gb.png',
              if (isDutch)
                'recurring_donations_03_nl.png'
              else
                'recurring_donations_03_gb.png',
            ],
            titles: [
              locals.featureNewgui1Title,
              locals.featureNewgui2Title,
              locals.featureNewgui3Title,
            ],
            messages: [
              locals.featureNewgui1Message,
              locals.featureNewgui2Message,
              locals.featureNewgui3Message,
            ],
          ),
        ],
      ),
    );
  }
}

class Feature extends StatefulWidget {
  const Feature({
    required this.imageName,
    required this.titles,
    required this.messages,
    required this.actionText,
    required this.action,
    super.key,
  });

  final List<String> imageName;
  final List<String> titles;
  final List<String> messages;
  final String actionText;
  final VoidCallback action;

  @override
  State<Feature> createState() => _FeatureState();
}

class _FeatureState extends State<Feature> {
  int current = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    const colors = [
      AppTheme.givtLightBlue,
      AppTheme.givtYellow,
      AppTheme.givtOrange,
    ];

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: size.height * 0.7,
              viewportFraction: 1,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              onPageChanged: (index, _) {
                setState(() {
                  current = index;
                });
              },
            ),
            items: widget.imageName
                .asMap()
                .entries
                .map(
                  (entry) => FeatureCarouselItem(
                    imagePath: entry.value,
                    color: colors[entry.key],
                    title: widget.titles[entry.key],
                    subtitle: widget.messages[entry.key],
                  ),
                )
                .toList(),
          ),
          _buildAnimatedBottomIndexes(
            context,
            imageNames: widget.imageName,
            currentIndex: current,
          ),
          const SizedBox(height: 16),
          Visibility(
            visible: current == widget.imageName.length - 1,
            child: ElevatedButton(
              onPressed: widget.action,
              child: Text(widget.actionText),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureCarouselItem extends StatelessWidget {
  const FeatureCarouselItem({
    required this.imagePath,
    required this.color,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String imagePath;
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Container(
          height: size.height * 0.4,
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Image.asset(
            'assets/images/$imagePath',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildAnimatedBottomIndexes(
  BuildContext context, {
  required List<String> imageNames,
  required int currentIndex,
}) {
  final size = MediaQuery.sizeOf(context);
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: imageNames.asMap().entries.map((entry) {
      return Container(
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
      );
    }).toList(),
  );
}
