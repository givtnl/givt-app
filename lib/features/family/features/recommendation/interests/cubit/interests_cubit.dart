import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';
import 'package:givt_app/utils/utils.dart';

part 'interests_state.dart';

class InterestsCubit extends Cubit<InterestsState> {
  InterestsCubit({
    required this.location,
    required this.cityName,
    required this.interests,
  }) : super(
          InterestsState(
            location: location,
            cityName: cityName,
            interests: interests,
            selectedInterests: const [],
          ),
        );
  final Tag location;
  final String cityName;
  final List<Tag> interests;

  void selectInterest(Tag interest) {
    final newSelectedInterests = [...state.selectedInterests];
    if (newSelectedInterests.contains(interest)) {
      newSelectedInterests.remove(interest);
    } else if (newSelectedInterests.length < InterestsState.maxInterests) {
      newSelectedInterests.add(interest);
    }

    AnalyticsHelper.logEvent(
      eventName: AmplitudeEvents.interestSelected,
      eventProperties: {
        AnalyticsHelper.interestKey:
            newSelectedInterests.map((e) => e.displayText).toList().toString(),
      },
    );

    emit(state.copyWith(selectedInterests: newSelectedInterests));
  }

  void clearSelectedInterests() {
    emit(state.copyWith(selectedInterests: []));
  }
}
