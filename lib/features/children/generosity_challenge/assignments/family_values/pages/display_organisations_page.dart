import 'package:flutter/material.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/models/family_value.dart';
import 'package:givt_app/features/children/generosity_challenge/assignments/family_values/widgets/organisation_container.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_app_bar.dart';
import 'package:givt_app/features/children/generosity_challenge/widgets/generosity_back_button.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';

class DisplayOrganisations extends StatelessWidget {
  const DisplayOrganisations({
    required this.familyValues,
    super.key,
  });
  final List<FamilyValue> familyValues;
  @override
  Widget build(BuildContext context) {
    final image = [
      ...familyValues
          .map((e) => Image.network(e.orgImagePath, fit: BoxFit.cover)),
    ];
    return Scaffold(
      appBar: const GenerosityAppBar(
        title: 'Day 7',
        leading: GenerosityBackButton(),
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
                    style: FamilyAppTheme().toThemeData().textTheme.titleSmall,
                  ),
                ),
              ),
            ),
            ...familyValues.map(
              (e) => SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                sliver: SliverToBoxAdapter(
                  child: OrganisationContainer(
                    familyValue: e,
                    image: image[familyValues.indexOf(e)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
