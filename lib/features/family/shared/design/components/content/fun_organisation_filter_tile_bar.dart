import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/tiles/filter_tile.dart';
import 'package:givt_app/shared/bloc/organisation/organisation_bloc.dart';

class FunOrganisationFilterTilesBar extends StatelessWidget {
  const FunOrganisationFilterTilesBar({
    this.onFilterChanged,
    this.stratPadding = 24,
    this.removedTypes = const [],
    super.key,
  });
  final double stratPadding;
  final List<String> removedTypes;
  final void Function(CollectGroupType)? onFilterChanged;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganisationBloc, OrganisationState>(
      bloc: getIt<OrganisationBloc>(),
      builder: (context, state) {
        final types = state.organisations.map((e) => e.type).toSet().toList()
          ..removeWhere((item) => removedTypes.contains(item.name));
        if (state.status == OrganisationStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (types.isEmpty) {
          return const SizedBox.shrink();
        }
        return SizedBox(
          height: 116,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(
                width: stratPadding,
              ),
              ...types.map(
                (e) => FilterTile(
                    type: e,
                    edgeInsets: const EdgeInsets.only(right: 8),
                    isSelected: state.selectedType == e.index,
                    onClick: (context) {
                      final typeIndex = state.selectedType == e.index
                          ? CollectGroupType.none.index
                          : e.index;
                      onFilterChanged?.call(CollectGroupType.values[typeIndex]);
                      getIt<OrganisationBloc>().add(
                        OrganisationTypeChanged(typeIndex),
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}
