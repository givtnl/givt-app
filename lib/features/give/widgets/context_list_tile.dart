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

    return SizedBox(
      width: size.width * 0.95,
      child: InkWell(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          elevation: 10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLeading(size),
              _buildTitleSubtitle(size, context),
              _buildTrailing(),
            ],
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

  Padding _buildTitleSubtitle(Size size, BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width * 0.5,
              child: Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 20,
                ),
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

  Widget _buildTrailing() => Visibility(
        visible: trailing != null,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 5,
                top: 40,
              ),
              child: trailing,
            ),
          ],
        ),
      );
}
