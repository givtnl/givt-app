import 'package:flutter/material.dart';

class DiscoverSuggestionCard extends StatelessWidget {
  const DiscoverSuggestionCard({
    required this.color,
    required this.title,
    required this.activeIcon,
    required this.icon,
    required this.onTap,
    this.visible = true,
    this.width = 85,
    this.height = 80,
    super.key,
  });

  final bool visible;
  final Color color;
  final String title;
  final String activeIcon;
  final String icon;
  final double width;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Visibility(
      visible: visible,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(
          width: width,
          height: height,
        ),
        child: InkWell(
          onTap: onTap,
          child: Card(
            color: color,
            child: Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3.5),
                border: Border(
                  top: BorderSide(
                    color: Colors.transparent,
                  ),
                  bottom: BorderSide(
                    color: Colors.transparent,
                    width: 5,
                  ),
                  left: BorderSide(
                    color: Colors.transparent,
                  ),
                  right: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 5,
                    ),
                    child: Image.asset(
                      icon,
                      width: size.width * (0.1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
