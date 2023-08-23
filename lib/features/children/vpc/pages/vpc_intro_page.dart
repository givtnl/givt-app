import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/features/children/vpc/widgets/vpc_intro_item_family.dart';
import 'package:givt_app/features/children/vpc/widgets/vpc_intro_item_g4k.dart';
import 'package:givt_app/features/children/vpc/widgets/vpc_intro_item_safety.dart';
import 'package:givt_app/utils/app_theme.dart';

class VPCIntroPage extends StatefulWidget {
  const VPCIntroPage({super.key});

  @override
  State<VPCIntroPage> createState() => _VPCIntroPageState();
}

class _VPCIntroPageState extends State<VPCIntroPage> {
  final List<Widget> pages = const [
    VPCIntroItemFamily(),
    VPCIntroItemSafety(),
    VPCIntroItemG4K(),
  ];

  var _currentPageIndex = 0;
  final _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 35),
        width: double.infinity,
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: size.height * 0.035,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              height: size.height * 0.865,
              child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: double.infinity,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                  onPageChanged: (index, resaon) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                ),
                items: pages,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: pages.map((page) {
                return GestureDetector(
                  onTap: () {
                    _carouselController.animateToPage(pages.indexOf(page));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: size.width * 0.25,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPageIndex >= pages.indexOf(page)
                          ? AppTheme.sliderIndicatorFilled
                          : AppTheme.sliderIndicatorNotFilled,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
