import 'package:flutter/material.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/family/features/parent_giving_flow/presentation/widgets/organisation_list_family_content.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/widgets/extensions/string_extensions.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';

class OrganisationListFamilyPage extends StatefulWidget {
  const OrganisationListFamilyPage({
    required this.countryCode,
    this.onTapListItem,
    this.onTapFunButton,
    this.title = 'Give',
    this.removedCollectGroupTypes = const [],
    this.buttonText,
    this.analyticsEvent,
    super.key,
  });

  final void Function(CollectGroup)? onTapListItem;
  final void Function()? onTapFunButton;
  final String title;
  final List<CollectGroupType> removedCollectGroupTypes;
  final String? buttonText;
  final AnalyticsEvent? analyticsEvent;
  final String countryCode;

  @override
  State<OrganisationListFamilyPage> createState() =>
      _OrganisationListFamilyPageState();
}

class _OrganisationListFamilyPageState extends State<OrganisationListFamilyPage> {
  final OrganisationBloc bloc = getIt<OrganisationBloc>();
  CollectGroup selectedCollectgroup = const CollectGroup.empty();

  @override
  void initState() {
    super.initState();
    bloc.add(
      OrganisationFetch(
        Country.fromCode(widget.countryCode),
        type: CollectGroupType.none.index,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FunScaffold(
      appBar: FunTopAppBar(
        leading: const GivtBackButtonFlat(),
        title: widget.title,
      ),
      body: Column(
        children: [
          Expanded(
            child: OrganisationListFamilyContent(
              bloc: bloc,
              onTapListItem: (collectGroup) {
                widget.onTapListItem?.call(collectGroup);
                setState(() {
                  selectedCollectgroup = collectGroup;
                });
              },
              removedCollectGroupTypes: widget.removedCollectGroupTypes,
            ),
          ),
          if (widget.buttonText.isNotNullAndNotEmpty() &&
              widget.analyticsEvent != null &&
              widget.onTapFunButton != null)
            FunButton(
              isDisabled: selectedCollectgroup == const CollectGroup.empty(),
              onTap: widget.onTapFunButton,
              text: widget.buttonText!,
              analyticsEvent: widget.analyticsEvent!,
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
