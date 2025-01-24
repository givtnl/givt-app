import 'package:givt_app/features/family/features/box_origin/usecases/box_origin_usecase.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class BoxOriginCubit extends CommonCubit<dynamic, dynamic>
    with BoxOriginUseCase {
  BoxOriginCubit() : super(const BaseState.initial());
}
