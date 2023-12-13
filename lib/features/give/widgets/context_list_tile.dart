import 'package:flutter/material.dart';

class ContextListTile extends StatelessWidget {
  const ContextListTile({
    required this.onTap,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    super.key,
  });

  final Widget? leading;
  final Widget? trailing;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      height: (size.height - 220) / 4,
      child: InkWell(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLeading(size),
                _buildTitleSubtitle(size, context),
                _buildTrailing(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildLeading(Size size) => Padding(
        padding: const EdgeInsets.all(2),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: size.width * 0.25,
            maxHeight: size.width * 0.25,
          ),
          child: leading,
        ),
      );

  Widget _buildTitleSubtitle(Size size, BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width * 0.5,
              child: Container(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Visibility(
              visible: subtitle != null,
              child: SizedBox(
                width: size.width * 0.5,
                child: Text(
                  subtitle ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildTrailing(Size size) => Visibility(
        visible: trailing != null,
        child: Container(
          child: trailing,
        ),
      );
}
