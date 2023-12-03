import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/features/account_details/bloc/personal_info_edit_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/widgets.dart';

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
  int current = 1;
  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.sizeOf(context);

    return BottomSheetLayout(
      title: Text(locals.featureStepTitle(current, 3)),
      child: Column(
        children: [
          Feature()
        ],
      ),
    );
  }
}

class Feature extends StatefulWidget {
  const Feature({super.key});

  // final List<>

  @override
  State<Feature> createState() => _FeatureState();
}

class _FeatureState extends State<Feature> {
  int current = 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final locals = context.l10n;
    final images = [
      'pushnot_scherm1.png',
      'pushnot_scherm2.png',
      'pushnot_scherm3.png',
    ];

    final title = [
      locals.featurePush1Title,
      locals.featurePush2Title,
      locals.featurePush3Title,
    ];

    final message = [
      locals.featurePush1Message,
      locals.featurePush2Message,
      locals.featurePush3Message,
    ];

    final colors = [
      const Color(0x0f4d98cf),
      const Color(0x0fF4BF63),
      const Color(0x0fF17057),
    ];

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: size.height * 0.6,
            viewportFraction: 1,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                current = index;
              });
            },
          ),
          items: [
            _buildFeatureItem(
              imagePath: 'assets/images/pushnot_scherm1.png',
              color: const Color(0x0f4d98cf),
              title: locals.featurePush1Title,
              subtitle: locals.featurePush1Message,
            ),
            _buildFeatureItem(
              imagePath: 'assets/images/pushnot_scherm2.png',
              color: const Color(0x0f4d98cf),
              title: locals.featurePush2Title,
              subtitle: locals.featurePush2Message,
            ),
          ],
        ),
        _buildAnimatedBottomIndexes(context),
      ],
    );
  }

  Widget _buildFeatureItem({
    required String imagePath,
    required Color color,
    required String title,
    required String subtitle,
    List<Widget>? action,
  }) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        Container(
          height: size.height * 0.4,
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        if (action != null) ...action,
      ],
    );
  }

  Row _buildAnimatedBottomIndexes(
    BuildContext context,
  ) {
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
              current == entry.key ? 0.9 : 0.4,
            ),
          ),
        );
      }).toList(),
    );
  }
}
