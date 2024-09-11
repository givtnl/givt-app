import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';

class CollectGroupDetails extends Equatable {
  const CollectGroupDetails({
    required this.collectGroupId,
    required this.name,
    this.logoLink,
    this.thankYou,
    this.type
  });

  factory CollectGroupDetails.fromMap(Map<String, dynamic> map) {
    return CollectGroupDetails(
      collectGroupId: map['collectGroupId'] as String,
      name: map['title'] as String,
      logoLink: map['organisationLogoLink'] as String?,
      thankYou: map['thankYou'] as String?,
      type: map['type'] != null ? CollectGroupType.fromInt(map['type'] as int) : CollectGroupType.charities,
    );
  }

  const CollectGroupDetails.empty()
      : this(
          collectGroupId: '',
          name: 'Mock Organisation Long Name',
        );

  const CollectGroupDetails.error()
      : this(
          collectGroupId: '',
          name: 'Something went wrong \n Please try again later',
        );

  final String collectGroupId;
  final String name;
  final String? logoLink;
  final String? thankYou;
  final CollectGroupType? type;

  @override
  List<Object?> get props => [collectGroupId, name];

  CollectGroupDetails copyWith({
    String? collectGroupId,
    String? name,
    String? logoLink,
    String? thankYou,
    CollectGroupType? type,
  }) {
    return CollectGroupDetails(
      collectGroupId: collectGroupId ?? this.collectGroupId,
      name: name ?? this.name,
      logoLink: logoLink ?? this.logoLink,
      thankYou: thankYou ?? this.thankYou,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organisationId': collectGroupId,
      'organisationName': name,
    };
  }
}
