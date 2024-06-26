import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/family/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';

class StartScanNfcButton extends StatelessWidget {
  const StartScanNfcButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GivtElevatedButton(
        onTap: () {
          context.read<ScanNfcCubit>().readTag();
        },
        text: 'Start',
      ),
    );
  }
}
