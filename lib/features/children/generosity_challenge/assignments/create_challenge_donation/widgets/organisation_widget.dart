import 'package:flutter/material.dart';
import 'package:givt_app/features/give/models/organisation.dart';
import 'package:givt_app/utils/utils.dart';

class OrganisationWidget extends StatelessWidget {
  const OrganisationWidget(this.organisation, {super.key,});

  final Organisation organisation;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 40),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.only(right: 16),
            child: Image.network(
              organisation.organisationLogoLink!,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: Text(
              organisation.organisationName!,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primary20,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    fontFamily: 'Rouna',
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
