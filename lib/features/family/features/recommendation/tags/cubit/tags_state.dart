part of 'tags_cubit.dart';

abstract class TagsState extends Equatable {
  const TagsState({
    required this.tags,
    this.status = LocationSelectionStatus.general,
  });

  final List<Tag> tags;
  final LocationSelectionStatus status;

  List<Tag> get locations {
    return tags.where((element) => element.type == TagType.LOCATION).toList();
  }

  List<Tag> get interests {
    return tags.where((element) => element.type == TagType.INTERESTS).toList();
  }

  Tag get selectedLocation {
    return const Tag.empty();
  }

  List<Map<String, String>> get hardcodedCities {
    return [
      {"cityName": "Jacksonville", "stateName": "Florida, USA"},
      {"cityName": "Tulsa", "stateName": "Oklahoma, USA"},
    ];
  }

  @override
  List<Object> get props => [tags];
}

class TagsStateInitial extends TagsState {
  const TagsStateInitial() : super(tags: const []);
}

class TagsStateFetching extends TagsState {
  const TagsStateFetching() : super(tags: const []);
}

class TagsStateFetched extends TagsState {
  const TagsStateFetched({
    required super.tags,
    super.status,
    this.selectedCity = '',
    Tag selectedLocation = const Tag.empty(),
  }) : _selectedLocation = selectedLocation;

  @override
  Tag get selectedLocation => _selectedLocation;

  final Tag _selectedLocation;
  final String selectedCity;

  @override
  List<Object> get props => [tags, selectedLocation, selectedCity, status];

  static TagsStateFetched empty() {
    return const TagsStateFetched(
      tags: [],
    );
  }
}

enum LocationSelectionStatus { general, city }

class TagsStateError extends TagsState {
  const TagsStateError({
    required this.errorMessage,
  }) : super(tags: const []);

  final String errorMessage;

  @override
  List<Object> get props => [tags, errorMessage];
}
