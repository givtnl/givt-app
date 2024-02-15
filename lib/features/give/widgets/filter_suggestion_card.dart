import 'package:flutter/material.dart';

class FilterSuggestionCard extends StatelessWidget {
  const FilterSuggestionCard({
    required this.isFocused,
    required this.color,
    required this.title,
    required this.activeIcon,
    required this.icon,
    required this.onTap,
    this.visible = true,
    super.key,
  });

  final bool visible;
  final bool isFocused;
  final Color color;
  final String title;
  final String activeIcon;
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Visibility(
      visible: visible,
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(
          width: 85,
          height: 80,
        ),
        child: InkWell(
          onTap: onTap,
          child: Card(
            color: color,
            child: Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                color: isFocused ? Colors.white : color,
                borderRadius: BorderRadius.circular(3.5),
                border: Border(
                  top: BorderSide(
                    color: isFocused ? color : Colors.transparent,
                  ),
                  bottom: BorderSide(
                    color: isFocused ? color : Colors.transparent,
                    width: 5,
                  ),
                  left: BorderSide(
                    color: isFocused ? color : Colors.transparent,
                  ),
                  right: BorderSide(
                    color: isFocused ? color : Colors.transparent,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 5,
                    ),
                    child: Image.asset(
                      isFocused ? activeIcon : icon,
                      width: size.width * (isFocused ? 0.08 : 0.1),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: isFocused ? color : Colors.white,
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
