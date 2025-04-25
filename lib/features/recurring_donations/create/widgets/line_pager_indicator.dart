import 'package:flutter/material.dart';

/// A line-based page indicator that shows the current position in a sequence of pages.
/// 
/// This widget displays a series of horizontal lines representing each page,
/// with the current page highlighted.
class LinePagerIndicator extends StatelessWidget {
  /// Creates a line pager indicator.
  /// 
  /// [currentPage] is the index of the current page.
  /// [pageCount] is the total number of pages.
  /// [activeColor] is the color of the current page indicator.
  /// [inactiveColor] is the color of the inactive page indicators.
  /// [width] is the width of each indicator.
  /// [activeWidth] is the width of the active indicator.
  /// [height] is the height of each indicator.
  /// [spacing] is the space between indicators.
  const LinePagerIndicator({
    super.key, 
    required this.currentPage,
    required this.pageCount,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.width = 16.0,
    this.activeWidth = 32.0,
    this.height = 4.0,
    this.spacing = 8.0,
  });

  /// The current page index.
  final int currentPage;
  
  /// The total number of pages.
  final int pageCount;
  
  /// Color of the active indicator.
  final Color activeColor;
  
  /// Color of the inactive indicators.
  final Color inactiveColor;
  
  /// Width of the inactive indicators.
  final double width;
  
  /// Width of the active indicator.
  final double activeWidth;
  
  /// Height of all indicators.
  final double height;
  
  /// Spacing between indicators.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        final isActive = index == currentPage;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: isActive ? activeWidth : width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(height / 2),
            color: isActive ? activeColor : inactiveColor,
          ),
        );
      }),
    );
  }
}