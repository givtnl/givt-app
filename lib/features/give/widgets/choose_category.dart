import 'dart:io';

import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';

class ChooseCategory extends StatelessWidget {
  const ChooseCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return ConstrainedBox(
      constraints: BoxConstraints.expand(
        width: size.width,
        height: size.height,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  width: size.height * 0.1,
                  child: FilterSuggestionCard(
                    isFocused: false,
                    color: CollecGroupType.artists.color,
                    title: CollecGroupType.artists.name,
                    activeIcon: CollecGroupType.artists.activeIcon,
                    icon: CollecGroupType.artists.icon,
                    width: size.width * 0.4,
                    onTap: () {},
                  ),
                ),
              ),
              Expanded(
                child: FilterSuggestionCard(
                  isFocused: false,
                  color: CollecGroupType.artists.color,
                  title: CollecGroupType.artists.name,
                  activeIcon: CollecGroupType.artists.activeIcon,
                  icon: CollecGroupType.artists.icon,
                  width: size.width * 0.4,
                  height: size.height * 0.1,
                  onTap: () {},
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
                  title: CollecGroupType.charities.name,
                  activeIcon: CollecGroupType.charities.activeIcon,
                  icon: CollecGroupType.charities.icon,
                  width: size.width * 0.4,
                  height: size.height * 0.2,
                  onTap: () {},
                ),
              ),
              Expanded(
                child: FilterSuggestionCard(
                  isFocused: false,
                  color: CollecGroupType.church.color,
                  title: CollecGroupType.church.name,
                  activeIcon: CollecGroupType.church.activeIcon,
                  icon: CollecGroupType.church.icon,
                  width: size.width * 0.4,
                  height: size.height * 0.2,
                  onTap: () {},
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
                  title: CollecGroupType.campaign.name,
                  activeIcon: CollecGroupType.campaign.activeIcon,
                  icon: CollecGroupType.campaign.icon,
                  width: size.width * 0.4,
                  height: size.height * 0.2,
                  onTap: () {},
                ),
              ),
              Expanded(
                child: FilterSuggestionCard(
                  visible: Platform.isIOS,
                  isFocused: false,
                  color: CollecGroupType.artists.color,
                  title: CollecGroupType.artists.name,
                  activeIcon: CollecGroupType.artists.activeIcon,
                  icon: CollecGroupType.artists.icon,
                  width: size.width * 0.4,
                  height: size.height * 0.2,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
