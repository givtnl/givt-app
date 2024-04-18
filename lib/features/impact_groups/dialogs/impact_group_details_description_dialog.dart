import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/utils/utils.dart';
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
      barrierColor: AppTheme.impactGroupDialogBarrierColor,
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
        // height: size.width * 0.95,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          color: Colors.white,
          elevation: 7,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      //TODO: POEditor
                      'About',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.w700,
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
                        child: SvgPicture.asset(
                          'assets/images/close_icon.svg',
                          alignment: Alignment.centerRight,
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
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w600,
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
