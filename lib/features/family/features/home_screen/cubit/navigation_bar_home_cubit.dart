import 'package:givt_app/features/family/features/home_screen/presentation/models/navigation_bar_home_custom.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class NavigationBarHomeCubit
    extends CommonCubit<dynamic, NavigationBarHomeCustom> {
  NavigationBarHomeCubit() : super(const BaseState.initial());

  void onDidChangeDependencies() {

  }
}
