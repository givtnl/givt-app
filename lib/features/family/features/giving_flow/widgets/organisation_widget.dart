import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/organisation_details/models/organisation_details.dart';
import 'package:givt_app/features/family/shared/widgets/texts/shared_texts.dart';

class OrganisationWidget extends StatelessWidget {
  const OrganisationWidget(
    this.organisation, {
    super.key,
  });

  final OrganisationDetails organisation;

  @override
  Widget build(BuildContext context) {
    final flow = context.read<FlowsCubit>().state;
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 40),
      child: Row(
        children: [
          if (flow.isCoin) SvgPicture.asset('assets/family/images/church.svg'),
          if (flow.isCoin) const SizedBox(width: 24),
          if (flow.isRecommendation && organisation.logoLink != null)
            Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.only(right: 16),
              child: Image.network(
                organisation.logoLink!,
                fit: BoxFit.contain,
              ),
            ),
          BlocBuilder<OrganisationDetailsCubit, OrganisationDetailsState>(
            builder: (context, state) {
              if (state is OrganisationDetailsLoadingState) {
                return const SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(),
                );
              } else {
                return Expanded(
                  child: TitleMediumText(
                    organisation.name,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
