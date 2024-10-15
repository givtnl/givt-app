import 'package:givt_app/features/family/features/reflect/data/gratitude_category.dart';
import 'package:givt_app/features/family/features/reflect/data/gratitude_tags_data.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/gratitude_selection_uimodel.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class GratitudeSelectionCubit
    extends CommonCubit<GratitudeSelectionUimodel, GameProfile> {
  GratitudeSelectionCubit(this._reflectAndShareRepository)
      : super(const BaseState.initial());

  final ReflectAndShareRepository _reflectAndShareRepository;

  List<GratitudeCategory> gratitudeCategories =
      GratitudeTagsData.gratitudeCategories;

  void init() {
    _emitData();
  }

  void saveGratitudeInterestsForCurrentSuperhero(GratitudeCategory? gratitude) {
    _reflectAndShareRepository
        .saveGratitudeInterestsForCurrentSuperhero(gratitude);
  }

  void onClickTile(GratitudeCategory? gratitude) {
    saveGratitudeInterestsForCurrentSuperhero(gratitude);
    _emitData();
  }

  GratitudeCategory? getSelectedCategory() {
    return _reflectAndShareRepository
        .getGratitudeInterestsForCurrentSuperhero();
  }

  void _emitData() {
    emitData(
      GratitudeSelectionUimodel(
        gratitudeList: gratitudeCategories,
        selectedGratitude: getSelectedCategory(),
        superheroName:
            _reflectAndShareRepository.getCurrentSuperhero().firstName,
      ),
    );
  }
}
