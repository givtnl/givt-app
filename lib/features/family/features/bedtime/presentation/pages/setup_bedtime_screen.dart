import 'package:flutter/material.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/features/bedtime/blocs/setup_bedtime_cubit.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class SetupBedtimeScreen extends StatefulWidget {
  const SetupBedtimeScreen({super.key});

  @override
  State<SetupBedtimeScreen> createState() => _SetupBedtimeScreenState();
}

class _SetupBedtimeScreenState extends State<SetupBedtimeScreen> {
  final SetupBedtimeCubit _cubit = getIt<SetupBedtimeCubit>();

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      body: BaseStateConsumer(
        cubit: _cubit,
        onInitial: (context) {
          return Stack(children: [

          ]);
        },
      ),
    );
  }
}
