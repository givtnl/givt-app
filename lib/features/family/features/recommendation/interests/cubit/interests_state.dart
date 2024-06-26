part of 'interests_cubit.dart';

class InterestsState extends Equatable {
  static const int maxInterests = 3;

  const InterestsState({
    required this.location,
    required this.cityName,
    required this.selectedInterests,
    required this.interests,
  });

  final Tag location;
  final String cityName;
  final List<Tag> interests;
  final List<Tag> selectedInterests;

  @override
  List<Object> get props => [location, interests, selectedInterests, cityName];

  InterestsState copyWith({
    Tag? location,
    String? cityName,
    List<Tag>? selectedInterests,
    List<Tag>? interests,
  }) {
    return InterestsState(
      location: location ?? this.location,
      cityName: cityName ?? this.cityName,
      interests: interests ?? this.interests,
      selectedInterests: selectedInterests ?? this.selectedInterests,
    );
  }

  static InterestsState empty() {
    return const InterestsState(
      location: Tag.empty(),
      cityName: '',
      interests: [],
      selectedInterests: [],
    );
  }
}
