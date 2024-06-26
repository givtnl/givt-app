import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/cached_members/cubit/cached_members_cubit.dart';
import 'package:givt_app/features/children/cached_members/dialogs/cached_members_dialog.dart';
import 'package:givt_app/features/children/cached_members/widgets/cached_members_page.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class CachedFamilyOverviewPage extends StatelessWidget {
  const CachedFamilyOverviewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CachedMembersCubit, CachedMembersState>(
      listener: (context, state) {
        if (state.status == CachedMembersStateStatus.noFundsInitial ||
            state.status == CachedMembersStateStatus.noFundsRetrying) {
          final cachedMembersCubit = context.read<CachedMembersCubit>();
          showDialog<void>(
            barrierDismissible: false,
            context: context,
            builder: (context) => BlocProvider.value(
              value: cachedMembersCubit,
              child: const CachedMembersDialog(),
            ),
          );
        }
      },
      builder: (context, state) {
        return Theme(
          data: AppTheme.lightTheme,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Text(
                context.l10n.childrenMyFamily,
                style: GoogleFonts.mulish(
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800, color: AppTheme.givtBlue),
                ),
              ),
              leading: BackButton(
                onPressed: () {
                  context.pop();
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.backClicked,
                  );
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: TextButton(
                    onPressed: null,
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: 16,
                          color: AppTheme.givtBlue.withOpacity(.25),
                        ),
                        Text(
                          context.l10n.addMember,
                          textAlign: TextAlign.start,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.givtBlue.withOpacity(.25),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              automaticallyImplyLeading: false,
            ),
            body: SafeArea(
              child: state.status == CachedMembersStateStatus.loading
                  ? const Center(child: CircularProgressIndicator())
                  : const CachedMembersPage(),
            ),
          ),
        );
      },
    );
  }
}
