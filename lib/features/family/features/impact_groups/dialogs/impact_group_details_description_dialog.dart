import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:go_router/go_router.dart';

class ImpactGroupDetailsDescriptionDialog extends StatelessWidget {
  const ImpactGroupDetailsDescriptionDialog({
    required this.description,
    super.key,
  });

  final String description;

  static Future<void> showImpactGroupDescriptionDialog({
    required BuildContext context,
    required String description,
  }) async {
    await showDialog<void>(
      context: context,
      barrierColor: FamilyAppTheme.impactGroupDialogBarrierColor,
      builder: (_) =>
          ImpactGroupDetailsDescriptionDialog(description: description),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Center(
      child: SizedBox(
        width: size.width * 0.85,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          color: Colors.white,
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'About',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: FamilyAppTheme.primary20,
                          ),
                    ),
                  ),
                  Positioned(
                    top: 7,
                    right: 7,
                    child: GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        child: const Icon(
                          FontAwesomeIcons.xmark,
                          color: FamilyAppTheme.primary20,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 30),
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: FamilyAppTheme.primary20,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
