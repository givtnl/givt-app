import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/features/overview/models/models.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

part 'givt_event.dart';
part 'givt_state.dart';

class GivtBloc extends Bloc<GivtEvent, GivtState> {
  GivtBloc(this.givtRepository) : super(const GivtInitial()) {
    on<GivtInit>(_onGivtInit);
  }

  final GivtRepository givtRepository;

  FutureOr<void> _onGivtInit(GivtInit event, Emitter<GivtState> emit) async {
    emit(const GivtLoading());
    try {
      final sortedGivts = _sortGivts(await givtRepository.fetchGivts());
      final groupedGivts = _groupGivts(sortedGivts);

      emit(GivtLoaded(givtGroups: groupedGivts, givts: sortedGivts));
    } catch (e) {
      log(e.toString());
      // emit(const GivtError());
    }
  }

  List<Givt> _sortGivts(List<Givt> unsortedGivts) {
    unsortedGivts.sort((a, b) {
      if (a.timeStamp == null || b.timeStamp == null) {
        return 0;
      }
      if (a.timeStamp!.year > b.timeStamp!.year) {
        return -1;
      } else if (a.timeStamp!.year < b.timeStamp!.year) {
        return 1;
      } else {
        if (a.timeStamp!.month > b.timeStamp!.month) {
          return -1;
        } else if (a.timeStamp!.month < b.timeStamp!.month) {
          return 1;
        } else {
          if (a.timeStamp!.day > b.timeStamp!.day) {
            return -1;
          } else if (a.timeStamp!.day < b.timeStamp!.day) {
            return 1;
          } else {
            if (a.timeStamp!.millisecondsSinceEpoch >
                b.timeStamp!.millisecondsSinceEpoch) {
              return -1;
            } else if (a.timeStamp!.millisecondsSinceEpoch <
                b.timeStamp!.millisecondsSinceEpoch) {
              return 1;
            } else {
              final x = a.organisationName.compareTo(b.organisationName);
              if (x != 0) {
                return x;
              } else {
                if (a.collectId > b.collectId) {
                  return 1;
                } else if (a.collectId < b.collectId) {
                  return -1;
                } else {
                  return 0;
                }
              }
            }
          }
        }
      }
    });
    return unsortedGivts;
  }

  List<GivtGroup> _groupGivts(List<Givt> sortedGivts) {
    final givtGroups = <GivtGroup>[];

    if (sortedGivts.isEmpty) {
      return givtGroups;
    }
    var lastMonth = const GivtGroup.empty();
    var lastGivtGroup = const GivtGroup.empty();

    // Set the first month
    lastMonth = lastMonth.copyWith(
      timeStamp: sortedGivts[0].timeStamp,
    );

    // Check all sorted givts;
    for (final givt in sortedGivts) {
      //add amount to the month amount
      if (lastGivtGroup == const GivtGroup.empty()) {
        lastGivtGroup = GivtGroup(
          timeStamp: givt.timeStamp,
          organisationName: givt.organisationName,
          status: givt.status,
          isGiftAidEnabled: givt.isGiftAidEnabled,
        );
      }

      // Check if current givt needs to be added to the group
      if (givt.organisationName != lastGivtGroup.organisationName ||
          givt.timeStamp!.millisecondsSinceEpoch !=
              lastGivtGroup.timeStamp!.millisecondsSinceEpoch) {
        // If not then add the current group to the list and set lastgivtgroup to null
        givtGroups.add(lastGivtGroup);

        // Create new group with parameters of current givt if group is null
        lastGivtGroup = GivtGroup(
          timeStamp: givt.timeStamp,
          organisationName: givt.organisationName,
          status: givt.status,
          isGiftAidEnabled: givt.isGiftAidEnabled,
        );
      }

      lastGivtGroup = lastGivtGroup.copyWith(
        givts: [
          ...lastGivtGroup.givts,
          givt,
        ],
      );

      // if the current month does not equal the month
      // of the last groups then create a new month
      if (lastMonth.timeStamp!.year != givt.timeStamp!.year ||
          lastMonth.timeStamp!.month != givt.timeStamp!.month) {
        givtGroups.add(lastMonth);
        lastMonth = GivtGroup(
          timeStamp: givt.timeStamp,
        );
      }

      if (givt.status < 4) {
        lastMonth = lastMonth.copyWith(amount: lastMonth.amount + givt.amount);
      }

      //Last but not least add the last group to the givtgroups
      if (sortedGivts.indexOf(givt) == (sortedGivts.length - 1)) {
        givtGroups
          ..add(lastGivtGroup)
          ..add(lastMonth);
      }
    }
    return givtGroups;
  }
}
