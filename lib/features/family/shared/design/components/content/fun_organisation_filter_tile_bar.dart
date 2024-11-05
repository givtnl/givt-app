import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/family/app/injection.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/tiles/filter_tile.dart';
import 'package:givt_app/shared/bloc/organisation/organisation_bloc.dart';

class FunOrganisationFilterTilesBar extends StatelessWidget {
  const FunOrganisationFilterTilesBar(
      {this.stratPadding = 24, this.removedTypes = const [], super.key});
  final double stratPadding;
  final List<String> removedTypes;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganisationBloc, OrganisationState>(
      bloc: getIt<OrganisationBloc>(),
      builder: (context, state) {
        final types = state.organisations.map((e) => e.type).toSet().toList();
        types.removeWhere((item) => removedTypes.contains(item.name));
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
                  onClick: (context) => getIt<OrganisationBloc>().add(
                    OrganisationTypeChanged(
                      e.index,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
