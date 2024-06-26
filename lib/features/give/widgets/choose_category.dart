import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class ChooseCategory extends StatelessWidget {
  const ChooseCategory({super.key,});

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
                    extra: CollectGroupType.none.index,
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
                child: DiscoverSuggestionCard(
                  color: CollectGroupType.charities.color,
                  title: _getCategoryName(
                    type: CollectGroupType.charities,
                    context: context,
                  ),
                  activeIcon: CollectGroupType.charities.activeIcon,
                  icon: CollectGroupType.charities.icon,
                  width: size.width * 0.4,
                  height: size.height * 0.3,
                  onTap: () => context.goNamed(
                    Pages.chooseCategoryList.name,
                    extra: CollectGroupType.charities.index,
                  ),
                ),
              ),
              Expanded(
                child: DiscoverSuggestionCard(
                  color: CollectGroupType.church.color,
                  title: _getCategoryName(
                    type: CollectGroupType.church,
                    context: context,
                  ),
                  activeIcon: CollectGroupType.church.activeIcon,
                  icon: CollectGroupType.church.icon,
                  width: size.width * 0.4,
                  height: size.height * 0.3,
                  onTap: () => context.goNamed(
                    Pages.chooseCategoryList.name,
                    extra: CollectGroupType.church.index,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: DiscoverSuggestionCard(
                  color: CollectGroupType.campaign.color,
                  title: _getCategoryName(
                    type: CollectGroupType.campaign,
                    context: context,
                  ),
                  activeIcon: CollectGroupType.campaign.activeIcon,
                  icon: CollectGroupType.campaign.icon,
                  width: size.width * 0.4,
                  height: size.height * 0.3,
                  onTap: () => context.goNamed(
                    Pages.chooseCategoryList.name,
                    extra: CollectGroupType.campaign.index,
                  ),
                ),
              ),
              Expanded(
                child: DiscoverSuggestionCard(
                  visible: Platform.isIOS,
                  color: CollectGroupType.artists.color,
                  title: _getCategoryName(
                    type: CollectGroupType.artists,
                    context: context,
                  ),
                  activeIcon: CollectGroupType.artists.activeIcon,
                  icon: CollectGroupType.artists.icon,
                  width: size.width * 0.4,
                  height: size.height * 0.3,
                  onTap: () => context.goNamed(
                    Pages.chooseCategoryList.name,
                    extra: CollectGroupType.artists.index,
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
    required CollectGroupType type,
    required BuildContext context,
  }) {
    switch (type) {
      case CollectGroupType.charities:
        return context.l10n.charity;
      case CollectGroupType.church:
        return context.l10n.church;
      case CollectGroupType.campaign:
        return context.l10n.campaign;
      case CollectGroupType.artists:
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
