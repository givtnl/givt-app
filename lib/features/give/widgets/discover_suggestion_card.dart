import 'package:flutter/material.dart';

class DiscoverSuggestionCard extends StatelessWidget {
  const DiscoverSuggestionCard({
    required this.color,
    required this.title,
    required this.activeIcon,
    required this.icon,
    required this.onTap,
    required this.width,
    required this.height,
    this.visible = true,
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
              padding: const EdgeInsets.only(left: 6, right: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
                border: const Border(
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
                      vertical: 6,
                      horizontal: 6,
                    ),
                    child: Image.asset(
                      icon,
                      width: size.width * 0.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
