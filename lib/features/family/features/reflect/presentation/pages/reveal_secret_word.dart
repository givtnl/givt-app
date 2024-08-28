import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/shared/widgets/family_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:scratcher/widgets.dart';

class RevealSecretWordScreen extends StatefulWidget {
  const RevealSecretWordScreen({
    required this.word,
    super.key,
  });
  final String word;

  @override
  State<RevealSecretWordScreen> createState() => _RevealSecretWordScreenState();
}

class _RevealSecretWordScreenState extends State<RevealSecretWordScreen> {
  bool _isScratched = false;

  @override
  Widget build(BuildContext context) {
    return FamilyScaffold(
      appBar: const GenerosityAppBar(
        title: 'Secret Word',
        leading: null,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          const TitleLargeText(
            'Scratch to reveal\nyour secret word!',
            textAlign: TextAlign.center,
            color: FamilyAppTheme.primary30,
          ),

          const Spacer(),
          Scratcher(
            brushSize: 30,
            threshold: 50,
            color: Colors.grey,
            onChange: (value) => setState(() {
              _isScratched = value > 20;
            }),
            //  onThreshold: () => print("Threshold reached, you won!"),
            child: Stack(
              alignment: Alignment.center,
              children: [
                secretWordBackground(
                  width: MediaQuery.sizeOf(context).width,
                ),
                DisplayMediumText(
                  widget.word,
                  textAlign: TextAlign.center,
                  color: FamilyAppTheme.primary30,
                ),
              ],
            ),
          ),
          // Stack(alignment: Alignment.center, children: [
          //   secretWordBackground(
          //     width: MediaQuery.sizeOf(context).width,
          //   ),
          //   Scratcher(
          //     brushSize: 30,
          //     threshold: 50,
          //     color: Colors.grey,
          //     onChange: (value) => setState(() {
          //       _isScratched = value > 20;
          //     }),
          //     onThreshold: () => print("Threshold reached, you won!"),
          //     child: Padding(
          //       padding: const EdgeInsets.all(24),
          //       child: DisplayMediumText(
          //         widget.word,
          //         textAlign: TextAlign.center,
          //         color: FamilyAppTheme.primary30,
          //       ),
          //     ),
          //   ),
          // ]),

          const Spacer(),
          // shuffleButton(),
          const SizedBox(height: 8),
          GivtElevatedButton(
            isDisabled: !_isScratched,
            onTap: () => context.pop(),
            text: 'Ready',
          )
        ],
      ),
    );
  }

  Widget shuffleButton() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LabelLargeText.primary30('Change'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(FontAwesomeIcons.shuffle,
                  size: 24, color: FamilyAppTheme.primary30),
            ),
          ],
        ),
      );
}
