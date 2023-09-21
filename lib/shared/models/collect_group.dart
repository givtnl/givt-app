import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/shared/models/models.dart';

class CollectGroup extends Equatable {
  const CollectGroup({
    required this.nameSpace,
    required this.orgName,
    required this.hasCelebration,
    required this.type,
    this.locations = const [],
    this.multiUseAllocations = const [],
    this.qrCodes = const [],
  });

  const CollectGroup.empty()
      : nameSpace = '',
        orgName = '',
        hasCelebration = false,
        type = CollectGroupType.none,
        locations = const [],
        multiUseAllocations = const [],
        qrCodes = const [];

  factory CollectGroup.fromJson(Map<String, dynamic> json) {
    final locations = <Location>[];
    final multiUseAllocations = <MultiUseAllocation>[];
    final qrCodes = <QrCode>[];

    if (json['L'] != null) {
      for (final location in json['L'] as List<dynamic>) {
        var loc = Location.fromJson(location as Map<String, dynamic>);
        if (!loc.beaconId.contains('.')) {
          loc =
              loc.copyWith(beaconId: '${json['NS'] as String}.${loc.beaconId}');
        }
        locations.add(loc);
      }
    }

    if (json['Q'] != null) {
      for (final qrCode in json['Q'] as List<dynamic>) {
        var code = QrCode.fromJson(qrCode as Map<String, dynamic>);
        if (code.name.isEmpty) {
          code = code.copyWith(name: json['N'] as String);
        }
        if (!code.instance.contains('.')) {
          code = code.copyWith(
              instance: '${json['NS'] as String}.${code.instance}');
        }

        qrCodes.add(code);
      }
    }

    return CollectGroup(
      nameSpace: json['NS'] as String,
      orgName: json['N'] as String,
      hasCelebration: json['C'] as bool,
      type: CollectGroupType.values.firstWhere(
        (e) => e.index == json['T'],
      ),
      locations: locations,
      multiUseAllocations: multiUseAllocations,
      qrCodes: qrCodes,
    );
  }

  final String nameSpace;
  final String orgName;
  final bool hasCelebration;
  final CollectGroupType type;
  final List<Location> locations;
  final List<MultiUseAllocation> multiUseAllocations;
  final List<QrCode> qrCodes;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['NS'] = nameSpace;
    data['N'] = orgName;
    data['C'] = hasCelebration;
    data['T'] = type.index;
    data['type'] = type.index;
    data['L'] = locations.map((e) => e.toJson()).toList();
    data['MultiUseAllocations'] =
        multiUseAllocations.map((e) => e.toJson()).toList();
    data['Q'] = qrCodes.map((e) => e.toJson()).toList();
    return data;
  }

  AccountType get accountType {
    final asciiCountry = nameSpace.substring(8, 12);
    if (asciiCountry == '4742' ||
        asciiCountry == '4a45' ||
        asciiCountry == '4747') {
      return AccountType.bacs;
    }
    if (asciiCountry == '5553') {
      return AccountType.creditCard;
    }

    return AccountType.sepa;
  }

  @override
  List<Object?> get props => [
        nameSpace,
        orgName,
        hasCelebration,
        type,
        locations,
        multiUseAllocations,
        qrCodes,
      ];

  static const orgBeaconListKey = 'OrgBeaconList';
}
