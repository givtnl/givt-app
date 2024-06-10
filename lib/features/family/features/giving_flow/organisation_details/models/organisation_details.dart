import 'package:equatable/equatable.dart';

class OrganisationDetails extends Equatable {
  const OrganisationDetails({
    required this.collectGroupId,
    required this.name,
    this.logoLink,
    this.thankYou,
  });

  factory OrganisationDetails.fromMap(Map<String, dynamic> map) {
    return OrganisationDetails(
      collectGroupId: map['collectGroupId'] as String,
      name: map['title'] as String,
      logoLink: map['organisationLogoLink'] as String?,
      thankYou: map['thankYou'] as String?,
    );
  }

  const OrganisationDetails.empty()
      : this(
          collectGroupId: '',
          name: 'Mock Organisation Long Name',
        );

  const OrganisationDetails.error()
      : this(
          collectGroupId: '',
          name: 'Something went wrong \n Please try again later',
        );

  final String collectGroupId;
  final String name;
  final String? logoLink;
  final String? thankYou;

  @override
  List<Object?> get props => [collectGroupId, name];

  OrganisationDetails copyWith({
    String? collectGroupId,
    String? name,
    String? logoLink,
    String? thankYou,
  }) {
    return OrganisationDetails(
      collectGroupId: collectGroupId ?? this.collectGroupId,
      name: name ?? this.name,
      logoLink: logoLink ?? this.logoLink,
      thankYou: thankYou ?? this.thankYou,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organisationId': collectGroupId,
      'organisationName': name,
    };
  }
}
