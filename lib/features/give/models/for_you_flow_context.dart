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
    this.giveViaListOnly = false,
    this.initialAmount,
  });

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
    final restrictToEntryQrGoal =
        map['restrictToEntryQrGoal'] as bool? ?? false;
    final giveViaListOnly = map['giveViaListOnly'] as bool? ?? false;
    final initialAmountRaw = map['initialAmount'];
    final initialAmount = initialAmountRaw is num
        ? initialAmountRaw.toDouble()
        : double.tryParse(initialAmountRaw?.toString() ?? '');

    return ForYouFlowContext(
      source: resolvedSource,
      selectedOrganisation: selectedOrganisation,
      entryMediumId: entryMediumId,
      restrictToEntryQrGoal: restrictToEntryQrGoal,
      giveViaListOnly: giveViaListOnly,
      initialAmount: initialAmount,
    );
  }

  final ForYouEntrySource source;
  final CollectGroup? selectedOrganisation;
  final String? entryMediumId;
  final bool restrictToEntryQrGoal;

  /// When true, giving continues via list (namespace beacon only) and the
  /// named/active QR goal picker is hidden. Used after an inactive QR scan.
  final bool giveViaListOnly;
  final double? initialAmount;

  /// Continue after a deactivated QR: organisation namespace only, no named QR.
  ForYouFlowContext forGiveViaListAfterInactiveQr(CollectGroup collectGroup) {
    return copyWith(
      selectedOrganisation: collectGroup,
      entryMediumId: collectGroup.nameSpace,
      restrictToEntryQrGoal: false,
      giveViaListOnly: true,
    );
  }

  ForYouFlowContext copyWith({
    ForYouEntrySource? source,
    CollectGroup? selectedOrganisation,
    String? entryMediumId,
    bool? restrictToEntryQrGoal,
    bool? giveViaListOnly,
    double? initialAmount,
  }) {
    return ForYouFlowContext(
      source: source ?? this.source,
      selectedOrganisation: selectedOrganisation ?? this.selectedOrganisation,
      entryMediumId: entryMediumId ?? this.entryMediumId,
      restrictToEntryQrGoal:
          restrictToEntryQrGoal ?? this.restrictToEntryQrGoal,
      giveViaListOnly: giveViaListOnly ?? this.giveViaListOnly,
      initialAmount: initialAmount ?? this.initialAmount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'source': source.name,
      'selectedOrganisation': selectedOrganisation?.toJson(),
      'entryMediumId': entryMediumId,
      'restrictToEntryQrGoal': restrictToEntryQrGoal,
      'giveViaListOnly': giveViaListOnly,
      'initialAmount': initialAmount,
    };
  }

  @override
  List<Object?> get props => [
    source,
    selectedOrganisation,
    entryMediumId,
    restrictToEntryQrGoal,
    giveViaListOnly,
    initialAmount,
  ];
}
