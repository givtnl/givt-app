import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/shared/design/components/actions/fun_button.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_input_dropdown.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:intl/intl.dart';

class OrganisationAllocationFilters extends StatefulWidget {
  const OrganisationAllocationFilters({
    required this.bloc,
    super.key,
  });

  final OrganisationBloc bloc;

  @override
  State<OrganisationAllocationFilters> createState() =>
      _OrganisationAllocationFiltersState();
}

class _OrganisationAllocationFiltersState
    extends State<OrganisationAllocationFilters> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganisationBloc, OrganisationState>(
      bloc: widget.bloc,
      builder: (context, state) {
        // Get all unique allocation names from all organisations
        final allAllocations = <String>{};
        for (final org in state.organisations) {
          for (final allocation in org.multiUseAllocations) {
            if (allocation.name.isNotEmpty) {
              allAllocations.add(allocation.name);
            }
          }
        }
        final allocationList = allAllocations.toList()..sort();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: FamilyAppTheme.neutralVariant95,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Allocation dropdown
              if (allocationList.isNotEmpty) ...[
                const Text(
                  'Filter by Allocation',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: FamilyAppTheme.primary20,
                  ),
                ),
                const SizedBox(height: 8),
                FunInputDropdown<String?>(
                  items: [null, ...allocationList],
                  value: state.selectedAllocation,
                  hint: const Text('All allocations'),
                  onChanged: (value) {
                    AnalyticsHelper.logEvent(
                      eventName: AmplitudeEvents.parentGiveAllocationFilterChanged,
                      eventProperties: {
                        'allocation': value ?? 'all',
                      },
                    );
                    widget.bloc.add(
                      OrganisationAllocationFilterChanged(value),
                    );
                  },
                  itemBuilder: (context, item) {
                    return Text(
                      item ?? 'All allocations',
                      style: const TextStyle(
                        fontSize: 14,
                        color: FamilyAppTheme.primary20,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Non-allocated toggle
              FunButton(
                text: state.showOnlyNonAllocated
                    ? 'Show All'
                    : 'Show Non-Allocated Only',
                onTap: () {
                  AnalyticsHelper.logEvent(
                    eventName: AmplitudeEvents.parentGiveNonAllocatedFilterToggled,
                    eventProperties: {
                      'enabled': !state.showOnlyNonAllocated,
                    },
                  );
                  widget.bloc.add(
                    const OrganisationNonAllocatedFilterToggled(),
                  );
                },
                isDisabled: false,
                isOutlined: !state.showOnlyNonAllocated,
              ),
              const SizedBox(height: 16),

              // Date range filters
              const Text(
                'Filter by Date Range',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: FamilyAppTheme.primary20,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildDateButton(
                      label: 'Start Date',
                      date: state.filterStartDate ?? _startDate,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: state.filterStartDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            _startDate = picked;
                          });
                          AnalyticsHelper.logEvent(
                            eventName: AmplitudeEvents.parentGiveDateFilterChanged,
                            eventProperties: {
                              'filter_type': 'start_date',
                              'date': picked.toIso8601String(),
                            },
                          );
                          widget.bloc.add(
                            OrganisationDateFilterChanged(
                              startDate: picked,
                              endDate: state.filterEndDate ?? _endDate,
                            ),
                          );
                        }
                      },
                      onClear: state.filterStartDate != null
                          ? () {
                              setState(() {
                                _startDate = null;
                              });
                              widget.bloc.add(
                                OrganisationDateFilterChanged(
                                  startDate: null,
                                  endDate: state.filterEndDate,
                                ),
                              );
                            }
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDateButton(
                      label: 'End Date',
                      date: state.filterEndDate ?? _endDate,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: state.filterEndDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            _endDate = picked;
                          });
                          AnalyticsHelper.logEvent(
                            eventName: AmplitudeEvents.parentGiveDateFilterChanged,
                            eventProperties: {
                              'filter_type': 'end_date',
                              'date': picked.toIso8601String(),
                            },
                          );
                          widget.bloc.add(
                            OrganisationDateFilterChanged(
                              startDate: state.filterStartDate ?? _startDate,
                              endDate: picked,
                            ),
                          );
                        }
                      },
                      onClear: state.filterEndDate != null
                          ? () {
                              setState(() {
                                _endDate = null;
                              });
                              widget.bloc.add(
                                OrganisationDateFilterChanged(
                                  startDate: state.filterStartDate,
                                  endDate: null,
                                ),
                              );
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateButton({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: FamilyAppTheme.primary40,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: FamilyAppTheme.primary40,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date != null
                        ? DateFormat('MMM d, yyyy').format(date)
                        : 'Select',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: FamilyAppTheme.primary20,
                    ),
                  ),
                ],
              ),
            ),
            if (onClear != null)
              GestureDetector(
                onTap: onClear,
                child: const Icon(
                  Icons.clear,
                  size: 20,
                  color: FamilyAppTheme.primary40,
                ),
              )
            else
              const Icon(
                Icons.calendar_today,
                size: 20,
                color: FamilyAppTheme.primary40,
              ),
          ],
        ),
      ),
    );
  }
}
