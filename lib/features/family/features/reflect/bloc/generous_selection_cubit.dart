import 'package:givt_app/features/family/features/reflect/data/gratitude_category.dart';
import 'package:givt_app/features/family/features/reflect/data/gratitude_tags_data.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/gratitude_selection_uimodel.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class GenerousSelectionCubit
    extends CommonCubit<TagSelectionUimodel, GameProfile> {
  GenerousSelectionCubit(this._reflectAndShareRepository)
      : super(const BaseState.initial());

  final ReflectAndShareRepository _reflectAndShareRepository;

  List<TagCategory> generousPowers = GratitudeTagsData.generousPowers;

  late GameProfile reporter;

  void init(GameProfile reporter) {
    this.reporter = reporter;
    _emitData();
  }

  void saveGenerousPowerForCurrentSuperhero(TagCategory? power) {
    _reflectAndShareRepository.saveGenerousPowerForCurrentSuperhero(power);
  }

  void onClickTile(TagCategory? power) {
    saveGenerousPowerForCurrentSuperhero(power);
    _emitData();
  }

  TagCategory? getSelectedCategory() {
    return _reflectAndShareRepository.getGenerousPowerForCurrentSuperhero();
  }

  void _emitData() {
    emitData(
      TagSelectionUimodel(
        reporter: reporter,
        sideKick: _reflectAndShareRepository.getCurrentSidekick(),
        tagList: generousPowers,
        selectedTag: getSelectedCategory(),
        superheroName:
            _reflectAndShareRepository.getCurrentSuperhero().firstName,
      ),
    );
  }
}
