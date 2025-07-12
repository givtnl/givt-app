import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

part 'new_game_custom.dart';
part 'new_game_uimodel.dart';

class NewGameCubit extends CommonCubit<NewGameUIModel, NewGameCustom> {
  NewGameCubit() : super(const BaseState.loading());

  void init() {
    emitData(const NewGameUIModel());
  }
} 