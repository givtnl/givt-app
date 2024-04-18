import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ImpactGroupDetailsHeader extends StatelessWidget {
  const ImpactGroupDetailsHeader({
    required this.image,
    required this.title,
    required this.goal,
    this.members = 0,
    super.key,
  });

  final String image;
  final String title;
  final int goal;
  final int members;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.translate(
          offset: const Offset(0, -8),
          child: SvgPicture.asset(
            image,
            width: 60,
            height: 60,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.mulish(
                  textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              Row(
                children: [
                  Text(
                    //TODO POEditor
                    'Goal: \$$goal',
                    style: GoogleFonts.mulish(
                      textStyle:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ),
                  if (members > 0)
                    Text(
                      //TODO POEditor
                      ' · $members members',
                      style: GoogleFonts.mulish(
                        textStyle:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
