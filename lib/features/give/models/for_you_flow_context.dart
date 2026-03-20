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
  });

  final ForYouEntrySource source;
  final CollectGroup? selectedOrganisation;

  ForYouFlowContext copyWith({
    ForYouEntrySource? source,
    CollectGroup? selectedOrganisation,
  }) {
    return ForYouFlowContext(
      source: source ?? this.source,
      selectedOrganisation: selectedOrganisation ?? this.selectedOrganisation,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'source': source.name,
      'selectedOrganisation': selectedOrganisation?.toJson(),
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

    return ForYouFlowContext(
      source: resolvedSource,
      selectedOrganisation: selectedOrganisation,
    );
  }

  @override
  List<Object?> get props => [source, selectedOrganisation];
}
