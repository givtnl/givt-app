import 'package:equatable/equatable.dart';

class OrganisationDetails extends Equatable {
  const OrganisationDetails({
    required this.collectGroupId,
    required this.name,
    required this.goal,
    this.logoLink,
    this.thankYou,
  });

  factory OrganisationDetails.fromMap(Map<String, dynamic> map) {
    return OrganisationDetails(
      collectGroupId: map['collectGroupId'] as String,
      name: map['title'] as String,
      goal: map['goal'] as String,
      logoLink: map['organisationLogoLink'] as String,
      thankYou: map['thankYou'] as String,
    );
  }

  const OrganisationDetails.empty()
      : this(
          collectGroupId: '',
          name: 'Mock Organisation Long Name',
          goal: 'mock goal',
        );
  const OrganisationDetails.error()
      : this(
          collectGroupId: '',
          name: 'Something went wrong \n Please try again later',
          goal: 'mock goal',
        );

  final String collectGroupId;
  final String name;
  final String goal;
  final String? logoLink;
  final String? thankYou;

  @override
  List<Object?> get props => [collectGroupId, name, goal];
  OrganisationDetails copyWith({
    String? collectGroupId,
    String? name,
    String? goal,
    String? logoLink,
    String? thankYou,
  }) {
    return OrganisationDetails(
      collectGroupId: collectGroupId ?? this.collectGroupId,
      name: name ?? this.name,
      goal: goal ?? this.goal,
      logoLink: logoLink ?? this.logoLink,
      thankYou: thankYou ?? this.thankYou,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organisationId': collectGroupId,
      'organisationName': name,
      'goal': goal,
    };
  }
}
