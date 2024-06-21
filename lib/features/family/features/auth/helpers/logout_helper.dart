
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/profiles/cubit/profiles_cubit.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

void logout(BuildContext context) {
  AnalyticsHelper.logEvent(
    eventName: AmplitudeEvents.logOutPressed,
  );
  context.read<AuthCubit>().logout();
  context.read<ProfilesCubit>().clearProfiles();
  context.read<FlowsCubit>().resetFlow();

  context.goNamed(Pages.welcome.name);
}