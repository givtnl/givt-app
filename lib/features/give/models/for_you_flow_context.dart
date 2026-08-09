import 'package:equatable/equatable.dart';
import 'package:givt_app/shared/models/collect_group.dart';

enum ForYouEntrySource {
  location,
  qrCode,
  collectionDevice,
  search,
  favorite,
  emptyState,
}

class ForYouFlowContext extends Equatable {
  const ForYouFlowContext({
    required this.source,
    this.selectedOrganisation,
    this.entryMediumId,
    this.restrictToEntryQrGoal = false,
    this.initialAmount,
  });

  final ForYouEntrySource source;
  final CollectGroup? selectedOrganisation;
  final String? entryMediumId;
  final bool restrictToEntryQrGoal;
  final double? initialAmount;

  ForYouFlowContext copyWith({
    ForYouEntrySource? source,
    CollectGroup? selectedOrganisation,
    String? entryMediumId,
    bool? restrictToEntryQrGoal,
    double? initialAmount,
  }) {
    return ForYouFlowContext(
      source: source ?? this.source,
      selectedOrganisation: selectedOrganisation ?? this.selectedOrganisation,
      entryMediumId: entryMediumId ?? this.entryMediumId,
      restrictToEntryQrGoal: restrictToEntryQrGoal ?? this.restrictToEntryQrGoal,
      initialAmount: initialAmount ?? this.initialAmount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'source': source.name,
      'selectedOrganisation': selectedOrganisation?.toJson(),
      'entryMediumId': entryMediumId,
      'restrictToEntryQrGoal': restrictToEntryQrGoal,
      'initialAmount': initialAmount,
    };
  }

  factory ForYouFlowContext.fromMap(Map<String, dynamic> map) {
    final sourceName = map['source'] as String?;
    final resolvedSource = ForYouEntrySource.values.firstWhere(
      (value) => value.name == sourceName,
      orElse: () => ForYouEntrySource.search,
    );

    final selectedOrgRaw = map['selectedOrganisation'];
    final selectedOrganisation = selectedOrgRaw is Map<String, dynamic>
        ? CollectGroup.fromJson(selectedOrgRaw)
        : null;

    final entryMediumId = map['entryMediumId'] as String?;
    final restrictToEntryQrGoal = map['restrictToEntryQrGoal'] as bool? ?? false;
    final initialAmountRaw = map['initialAmount'];
    final initialAmount = initialAmountRaw is num
        ? initialAmountRaw.toDouble()
        : double.tryParse(initialAmountRaw?.toString() ?? '');

    return ForYouFlowContext(
      source: resolvedSource,
      selectedOrganisation: selectedOrganisation,
      entryMediumId: entryMediumId,
      restrictToEntryQrGoal: restrictToEntryQrGoal,
      initialAmount: initialAmount,
    );
  }

  @override
  List<Object?> get props => [
    source,
    selectedOrganisation,
    entryMediumId,
    restrictToEntryQrGoal,
    initialAmount,
  ];
}
