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
        type = CollecGroupType.none,
        locations = const [],
        multiUseAllocations = const [],
        qrCodes = const [];

  factory CollectGroup.fromJson(Map<String, dynamic> json) {
    final locations = <Location>[];
    final multiUseAllocations = <MultiUseAllocation>[];
    final qrCodes = <QrCode>[];

    // if (json['Locations'] != null) {
    //   for (final location in json['Locations'] as List<Map<String, dynamic>>) {
    //     locations.add(Location.fromJson(location));
    //   }
    // }

    // if (json['MultiUseAllocations'] != null) {
    //   for (final multiUseAllocation
    //       in json['MultiUseAllocations'] as List<Map<String, dynamic>>) {
    //     multiUseAllocations
    //         .add(MultiUseAllocation.fromJson(multiUseAllocation));
    //   }
    // }

    // if (json['qrCodes'] != null) {
    //   for (final qrCode in json['qrCodes']) {
    //     qrCodes.add(QrCode.fromJson(qrCode));
    //   }
    // }

    return CollectGroup(
      nameSpace: json['EddyNameSpace'] as String,
      orgName: json['OrgName'] as String,
      hasCelebration: json['Celebrations'] as bool,
      type: CollecGroupType.values.firstWhere(
        (e) => e.value == json['CollectGroupType'],
      ),
      locations: locations,
      multiUseAllocations: multiUseAllocations,
      qrCodes: qrCodes,
    );
  }

  final String nameSpace;
  final String orgName;
  final bool hasCelebration;
  final CollecGroupType type;
  final List<Location> locations;
  final List<MultiUseAllocation> multiUseAllocations;
  final List<QrCode> qrCodes;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['EddyNameSpace'] = nameSpace;
    data['OrgName'] = orgName;
    data['Celebrations'] = hasCelebration;
    data['CollectGroupType'] = type.value;
    data['type'] = type.value;
    data['Locations'] = locations.map((e) => e.toJson()).toList();
    data['MultiUseAllocations'] =
        multiUseAllocations.map((e) => e.toJson()).toList();
    data['qrCodes'] = qrCodes.map((e) => e.toJson()).toList();
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
