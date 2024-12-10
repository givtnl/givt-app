import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/recommendation/organisations/models/organisation.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_text_styles.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';

class OrganisationHeader extends StatelessWidget {
  const OrganisationHeader({
    required this.organisation,
    this.isActOfService = false,
    super.key,
  });

  final Organisation organisation;
  final bool isActOfService;
  @override
  Widget build(BuildContext context) {
    final fontsize = FunTextStyles.labelSmall.fontSize ?? 16;
    return Container(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: organisation.tags
                  .take(3)
                  .map(
                    (tag) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: tag.area.accentColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 4,
                          bottom: 4,
                          left: 16,
                          right: 8,
                        ),
                        child: LabelSmallText(
                          tag.displayText,
                          color: tag.area.textColor,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          if (!isActOfService)
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                constraints: BoxConstraints(
                  maxHeight: organisation.tags.length * (8 + fontsize),
                ),
                child: Image.network(
                  organisation.organisationLogoURL,
                  fit: BoxFit.contain,
                  alignment: Alignment.centerRight,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
