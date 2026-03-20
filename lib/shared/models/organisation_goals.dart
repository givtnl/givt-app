import 'package:equatable/equatable.dart';

class OrganisationGoalsSummary extends Equatable {
  const OrganisationGoalsSummary({
    required this.allocationsCount,
    required this.qrCodesCount,
  });

  const OrganisationGoalsSummary.empty()
    : allocationsCount = 0,
      qrCodesCount = 0;

  final int allocationsCount;
  final int qrCodesCount;

  @override
  List<Object> get props => [allocationsCount, qrCodesCount];
}

class OrganisationGoalsResponse extends Equatable {
  const OrganisationGoalsResponse({
    this.allocations = const [],
    this.qrCodes = const [],
  });

  factory OrganisationGoalsResponse.fromJson(Map<String, dynamic> json) {
    final allocationsJson = json['allocations'] as List<dynamic>? ?? [];
    final qrCodesJson = json['qrCodes'] as List<dynamic>? ?? [];
    return OrganisationGoalsResponse(
      allocations: allocationsJson
          .map(
            (item) =>
                OrganisationAllocation.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      qrCodes: qrCodesJson
          .map(
            (item) => OrganisationQrCode.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  final List<OrganisationAllocation> allocations;
  final List<OrganisationQrCode> qrCodes;

  OrganisationGoalsSummary toSummary() {
    return OrganisationGoalsSummary(
      allocationsCount: allocations.length,
      qrCodesCount: qrCodes.length,
    );
  }

  @override
  List<Object> get props => [allocations, qrCodes];
}

class OrganisationAllocation extends Equatable {
  const OrganisationAllocation({
    required this.collectId,
    required this.allocationName,
    required this.collectGroupId,
  });

  factory OrganisationAllocation.fromJson(Map<String, dynamic> json) {
    return OrganisationAllocation(
      collectId: '${json['collectId'] ?? ''}',
      allocationName: '${json['allocationName'] ?? ''}',
      collectGroupId: '${json['collectGroupId'] ?? ''}',
    );
  }

  final String collectId;
  final String allocationName;
  final String collectGroupId;

  @override
  List<Object> get props => [collectId, allocationName, collectGroupId];
}

class OrganisationQrCode extends Equatable {
  const OrganisationQrCode({
    required this.mediumId,
    required this.allocationName,
    required this.collectGroupId,
  });

  factory OrganisationQrCode.fromJson(Map<String, dynamic> json) {
    return OrganisationQrCode(
      mediumId: '${json['mediumId'] ?? ''}',
      allocationName: '${json['allocationName'] ?? ''}',
      collectGroupId: '${json['collectGroupId'] ?? ''}',
    );
  }

  final String mediumId;
  final String allocationName;
  final String collectGroupId;

  @override
  List<Object> get props => [mediumId, allocationName, collectGroupId];
}
