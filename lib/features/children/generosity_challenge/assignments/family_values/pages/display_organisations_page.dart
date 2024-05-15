import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/family_value.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/widgets/organisation_container.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class DisplayOrganisations extends StatelessWidget {
  const DisplayOrganisations({required this.familyValues, super.key});
  final List<FamilyValue> familyValues;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GenerosityAppBar(
        title: 'Day 7',
        leading: BackButton(
          onPressed: context.pop,
          color: AppTheme.givtGreen40,
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
              ),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    'Which organisation would you\nlike to give to?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.givtGreen40,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Rouna',
                        ),
                  ),
                ),
              ),
            ),
            ...familyValues.map(
              (e) => SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverToBoxAdapter(
                    child: OrganisationContainer(familyValue: e)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
