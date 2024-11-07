import 'package:flutter/material.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/bedtime/blocs/setup_bedtime_cubit.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';

class SetupBedtimeScreen extends StatefulWidget {
  const SetupBedtimeScreen({super.key});

  @override
  State<SetupBedtimeScreen> createState() => _SetupBedtimeScreenState();
}

class _SetupBedtimeScreenState extends State<SetupBedtimeScreen> {
  final SetupBedtimeCubit _cubit = getIt<SetupBedtimeCubit>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return BaseStateConsumer(
        cubit: _cubit,
        onInitial: (context) {
          return ColoredBox(
            color: Colors.black,
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 24 + (144/2),
                    left: (width/2) - (144/2),
                    child: ellipseArc(
                      width: 144,
                      height: 472,
                    ),
                  ),
                  Positioned(
                    top: 24,
                    left: (width/2) - (144/2),
                    child: sunEllipse(
                      width: 144,
                      height: 144
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
  }
}
