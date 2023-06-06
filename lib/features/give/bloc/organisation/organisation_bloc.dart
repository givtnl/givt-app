import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/give/models/models.dart';

part 'organisation_event.dart';
part 'organisation_state.dart';

class OrganisationBloc extends Bloc<OrganisationEvent, OrganisationState> {
  OrganisationBloc() : super(OrganisationInitial()) {
    on<OrganisationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
