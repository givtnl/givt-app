import 'package:flutter/cupertino.dart';
import 'package:givt_app/features/family/features/reflect/data/gratitude_category.dart';
import 'package:givt_app/features/family/features/reflect/data/gratitude_tags_data.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/gratitude_selection_uimodel.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';
import 'package:givt_app/shared/widgets/extensions/string_extensions.dart';

class GenerousSelectionCubit
    extends CommonCubit<TagSelectionUimodel, GameProfile> {
  GenerousSelectionCubit(this._reflectAndShareRepository)
      : super(const BaseState.initial());

  final ReflectAndShareRepository _reflectAndShareRepository;

  List<TagCategory> generousPowers = GratitudeTagsData.generousPowers;

  late GameProfile reporter;
  TagCategory? selectedCategory;

  void init(GameProfile reporter) {
    this.reporter = reporter;
    _emitData();
  }

  void saveGenerousPowerForCurrentSuperhero(TagCategory? power) {
    selectedCategory = power;
  }

  void onClickTile(TagCategory? power) {
    saveGenerousPowerForCurrentSuperhero(power);
    _emitData();
  }

  void _emitData() {
    emitData(
      TagSelectionUimodel(
        reporter: reporter,
        sideKick: _reflectAndShareRepository.getCurrentSidekick(),
        tagList: generousPowers,
        selectedTag: selectedCategory,
        superheroName:
            _reflectAndShareRepository.getCurrentSuperhero().firstName,
      ),
    );
  }

  void onClickNext(String? filepath) {
    try {
      _reflectAndShareRepository
          .saveGenerousPowerForCurrentSuperhero(selectedCategory);
    } catch (_) {
      // do nothing
    }

    try {
      if (filepath.isNotNullAndNotEmpty()) {
        _reflectAndShareRepository.shareHeroAudio(filepath!);
      }
    } catch (e, s) {
      // do nothing
      debugPrint('Error sharing audio: $e\n\n$s');
    }
  }
}
