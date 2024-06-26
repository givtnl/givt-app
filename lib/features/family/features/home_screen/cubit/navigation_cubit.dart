import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());
  void changePage(NavigationDestinationData page) {
    emit(
      state.copyWith(activeDestination: page),
    );
  }
}
