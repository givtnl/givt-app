import 'package:equatable/equatable.dart';

class AdvertisementMetaInfo extends Equatable {
  const AdvertisementMetaInfo({
    required this.creationDate,
    required this.changedDate,
    required this.featured,
    required this.availableLanguages,
    required this.country,
  });

  final DateTime creationDate;
  final DateTime changedDate;
  final bool featured;
  final String availableLanguages;
  final String country;

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
