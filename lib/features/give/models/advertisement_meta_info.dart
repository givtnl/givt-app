import 'package:equatable/equatable.dart';

class AdvertisementMetaInfo extends Equatable {
  const AdvertisementMetaInfo({
    required this.creationDate,
    required this.changedDate,
    required this.featured,
    required this.availableLanguages,
    required this.country,
  });

  factory AdvertisementMetaInfo.fromJson(Map<String, dynamic> json) {
    return AdvertisementMetaInfo(
      creationDate: DateTime.parse(json['creationDate'] as String),
      changedDate: DateTime.parse(json['changedDate'] as String),
      featured: json['featured'] as bool,
      availableLanguages: json['availableLanguages'] as String,
      country: json['country'] as String,
    );
  }

  final DateTime creationDate;
  final DateTime changedDate;
  final bool featured;
  final String availableLanguages;
  final String country;

  Map<String, dynamic> toJson() {
    return {
      'creationDate': creationDate.toIso8601String(),
      'changedDate': changedDate.toIso8601String(),
      'featured': featured,
      'availableLanguages': availableLanguages,
      'country': country,
    };
  }

  AdvertisementMetaInfo copyWith({
    DateTime? creationDate,
    DateTime? changedDate,
    bool? featured,
    String? availableLanguages,
    String? country,
  }) {
    return AdvertisementMetaInfo(
      creationDate: creationDate ?? this.creationDate,
      changedDate: changedDate ?? this.changedDate,
      featured: featured ?? this.featured,
      availableLanguages: availableLanguages ?? this.availableLanguages,
      country: country ?? this.country,
    );
  }

  @override
  List<Object> get props => [
        creationDate,
        changedDate,
        featured,
        availableLanguages,
        country,
      ];
}
