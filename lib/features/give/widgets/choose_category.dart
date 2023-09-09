import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class ChooseCategory extends StatelessWidget {
  const ChooseCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final locals = context.l10n;

    return ConstrainedBox(
      constraints: BoxConstraints.expand(
        width: size.width,
        height: size.height,
      ),
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _buildSearchSeeAllCard(
                  context,
                  title: locals.discoverSearchButton,
                  icon: FontAwesomeIcons.magnifyingGlass,
                  onPressed: () => context.goNamed(
                    Pages.chooseCategoryList.name,
                    extra: CollecGroupType.none.index,
                  ),
                ),
              ),
              Expanded(
                child: _buildSearchSeeAllCard(
                  context,
                  title: locals.discoverDiscoverButton,
                  icon: FontAwesomeIcons.compass,
                  onPressed: () => context.goNamed(
                    Pages.chooseCategoryList.name,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FilterSuggestionCard(
                  isFocused: false,
                  color: CollecGroupType.charities.color,
                  title: _getCategoryName(
                    type: CollecGroupType.charities,
                    context: context,
                  ),
                  activeIcon: CollecGroupType.charities.activeIcon,
                  icon: CollecGroupType.charities.icon,
                  width: size.width * 0.4,
                  height: size.height * 0.3,
                  onTap: () => context.goNamed(
                    Pages.chooseCategoryList.name,
                    extra: CollecGroupType.charities.index,
                  ),
                ),
              ),
              Expanded(
                child: FilterSuggestionCard(
                  isFocused: false,
                  color: CollecGroupType.church.color,
                  title: _getCategoryName(
                    type: CollecGroupType.church,
                    context: context,
                  ),
                  activeIcon: CollecGroupType.church.activeIcon,
                  icon: CollecGroupType.church.icon,
                  width: size.width * 0.4,
                  height: size.height * 0.3,
                  onTap: () => context.goNamed(
                    Pages.chooseCategoryList.name,
                    extra: CollecGroupType.church.index,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FilterSuggestionCard(
                  isFocused: false,
                  color: CollecGroupType.campaign.color,
                  title: _getCategoryName(
                    type: CollecGroupType.campaign,
                    context: context,
                  ),
                  activeIcon: CollecGroupType.campaign.activeIcon,
                  icon: CollecGroupType.campaign.icon,
                  width: size.width * 0.4,
                  height: size.height * 0.3,
                  onTap: () => context.goNamed(
                    Pages.chooseCategoryList.name,
                    extra: CollecGroupType.campaign.index,
                  ),
                ),
              ),
              Expanded(
                child: FilterSuggestionCard(
                  visible: Platform.isIOS,
                  isFocused: false,
                  color: CollecGroupType.artists.color,
                  title: _getCategoryName(
                    type: CollecGroupType.artists,
                    context: context,
                  ),
                  activeIcon: CollecGroupType.artists.activeIcon,
                  icon: CollecGroupType.artists.icon,
                  width: size.width * 0.4,
                  height: size.height * 0.3,
                  onTap: () => context.goNamed(
                    Pages.chooseCategoryList.name,
                    extra: CollecGroupType.artists.index,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getCategoryName({
    required CollecGroupType type,
    required BuildContext context,
  }) {
    switch (type) {
      case CollecGroupType.charities:
        return context.l10n.charity;
      case CollecGroupType.church:
        return context.l10n.church;
      case CollecGroupType.campaign:
        return context.l10n.campaign;
      case CollecGroupType.artists:
        return context.l10n.artists;
      default:
        return '';
    }
  }

  Widget _buildSearchSeeAllCard(
    BuildContext context, {
    required VoidCallback onPressed,
    required String title,
    required IconData icon,
  }) =>
      Padding(
        padding: const EdgeInsets.all(5),
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  icon,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ),
      );
}
