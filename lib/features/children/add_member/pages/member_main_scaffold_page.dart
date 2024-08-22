import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/add_member/pages/add_member_form_page.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class AddMemberMainScaffold extends StatelessWidget {
  const AddMemberMainScaffold({
    required this.familyAlreadyExists,
    super.key,
  });
  final bool familyAlreadyExists;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              context.pushReplacementNamed(FamilyPages.childrenOverview.name);
              AnalyticsHelper.logEvent(
                eventName: AmplitudeEvents.backClicked,
              );
            },
          ),
        ),
        body: SafeArea(
          child: AddMemberFormPage(
            familyAlreadyExists: familyAlreadyExists,
          ),
        ),
      ),
    );
  }
}
