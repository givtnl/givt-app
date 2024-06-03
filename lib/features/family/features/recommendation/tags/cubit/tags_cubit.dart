import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';
import 'package:givt_app/features/family/features/recommendation/tags/repositories/tags_repository.dart';
import 'package:givt_app/utils/utils.dart';

part 'tags_state.dart';

class TagsCubit extends Cubit<TagsState> {
  TagsCubit(this._tagsRepository) : super(const TagsStateInitial());

  final TagsRepository _tagsRepository;
  void clearCitySelection() {
    return emit(
      TagsStateFetched(
        tags: state.tags,
        selectedLocation: state.selectedLocation,
        status: LocationSelectionStatus.general,
        selectedCity: '',
      ),
    );
  }

  void goToCitySelection() {
    return emit(
      TagsStateFetched(
        tags: state.tags,
        selectedLocation: state.selectedLocation,
        status: LocationSelectionStatus.city,
      ),
    );
  }

  void selectCity(Map<String, String> city) {
    final previousCity = (state as TagsStateFetched).selectedCity;
    final currentTapCity = city['cityName'].toString();

    if (previousCity != currentTapCity) {
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.citySelected,
        eventProperties: {
          AnalyticsHelper.cityKey: currentTapCity,
        },
      );
    }
    return emit(
      TagsStateFetched(
        tags: state.tags,
        selectedLocation: state.selectedLocation,
        status: LocationSelectionStatus.city,
        selectedCity: previousCity == currentTapCity ? '' : currentTapCity,
      ),
    );
  }

  void selectLocation({
    required Tag location,
    bool logAmplitude = true,
  }) {
    if (state is TagsStateFetched) {
      if (logAmplitude) {
        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.locationSelected,
          eventProperties: {
            AnalyticsHelper.locationKey: location.displayText,
          },
        );
      }

      emit(
        TagsStateFetched(
          tags: state.tags,
          selectedLocation:
              location == (state as TagsStateFetched).selectedLocation
                  ? const Tag.empty()
                  : location,
        ),
      );
    }
  }

  Future<void> fetchTags() async {
    emit(const TagsStateFetching());

    try {
      final List<Tag> response = await _tagsRepository.fetchTags();

      emit(TagsStateFetched(tags: response));
    } catch (error, stackTrace) {
      LoggingInfo.instance.error(
        'Error while fetching tags: $error',
        methodName: stackTrace.toString(),
      );
      emit(TagsStateError(errorMessage: error.toString()));
    }
  }
}
