import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/shared/widgets/custom_green_elevated_button.dart';

class CommonSuccessPage extends StatelessWidget {
  const CommonSuccessPage({
    required this.buttonText,
    this.title,
    this.text,
    this.onClickButton,
    super.key,
  });

  final String buttonText;
  final String? title;
  final String? text;
  final void Function()? onClickButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Flexible(
                child: Text(
                  title!,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
            if (text != null)
              Flexible(
                child: Text(
                  text!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            registeredCheckBackground(),
            registeredCheck(),
          ],
        ),
        CustomGreenElevatedButton(
          title: buttonText,
          onPressed: onClickButton ?? () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
