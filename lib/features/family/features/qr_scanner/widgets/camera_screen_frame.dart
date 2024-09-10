import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';

class CameraScreenFrame extends StatelessWidget {
  const CameraScreenFrame({
    required this.child,
    required this.feedback,
    super.key,
  });
  final Widget child;
  final String feedback;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.onPrimary,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        title: const TitleMediumText(
          'Scan the QR code',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        automaticallyImplyLeading: false,
        leading: GivtBackButtonFlat(
          onPressedExt: () {
            context.read<FlowsCubit>().resetFlow();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 6, child: child),
            Container(
              height: 80,
              color: Theme.of(context).colorScheme.onPrimary,
              child: Center(
                child: BodyMediumText(
                  feedback,
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
