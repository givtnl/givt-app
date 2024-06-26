import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:givt_app/core/failures/failure.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/overview/models/models.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

part 'givt_event.dart';
part 'givt_state.dart';

class GivtBloc extends Bloc<GivtEvent, GivtState> {
  GivtBloc(this.givtRepository) : super(const GivtInitial()) {
    on<GivtInit>(_onGivtInit);

    on<GiveDelete>(_onGivtDelete);

    on<GivtDownloadOverviewByYear>(_onGivtDownloadOverviewByYear);
  }

  final GivtRepository givtRepository;

  FutureOr<void> _onGivtDelete(
    GiveDelete event,
    Emitter<GivtState> emit,
  ) async {
    try {
      await LoggingInfo.instance.info('Cancelling transaction(s)');
      final givtGroup = state.givtGroups.firstWhere(
        (element) => element.timeStamp! == event.timestamp,
      );
      await givtRepository
          .deleteGivt(
        givtGroup.givts.map((givt) => givt.id).toList(),
      )
          .then((value) {
        if (value) {
          LoggingInfo.instance.info('Transaction(s) cancelled');
          add(const GivtInit());
        }
      });
    } on GivtServerFailure catch (e) {
      await LoggingInfo.instance.info(e.body.toString());
      await LoggingInfo.instance.error(e.body.toString());
      emit(GivtError(e.body.toString()));
    } on SocketException catch (e) {
      await LoggingInfo.instance
          .error('No internet connection to cancel transactions');
      log(e.toString());
      emit(const GivtNoInternet());
    } catch (e) {
      await LoggingInfo.instance
          .error(e.toString(), methodName: StackTrace.current.toString());
      log(e.toString());
    }
  }

  FutureOr<void> _onGivtInit(GivtInit event, Emitter<GivtState> emit) async {
    emit(const GivtLoading());
    try {
      final sortedGivts = _sortGivts(await givtRepository.fetchGivts());
      final groupedGivts = _groupGivts(sortedGivts);
      final groupGivtAids = _groupGivtAids(sortedGivts);

      emit(
        GivtLoaded(
          givtGroups: groupedGivts,
          givts: sortedGivts,
          givtAided: groupGivtAids,
        ),
      );
    } on SocketException catch (e) {
      log(e.toString());
      emit(const GivtNoInternet());
    } catch (e, stackTrace) {
      await LoggingInfo.instance
          .error(e.toString(), methodName: stackTrace.toString());
      emit(const GivtUnknown());
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
      taxYear: sortedGivts[0].taxYear,
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
          taxYear: givt.taxYear,
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
          taxYear: givt.taxYear,
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
          taxYear: givt.taxYear,
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

  Map<int, double> _groupGivtAids(List<Givt> sortedGivts) {
    if (sortedGivts.isEmpty) {
      return {};
    }
    final giftAidGroups = <int, double>{};
    var taxYear = 0;
    var taxYearAmount = 0.0;

    for (final givt in sortedGivts) {
      if (givt.isGiftAidEnabled && givt.taxYear != 0 && givt.status == 3) {
        if (taxYear == 0) {
          taxYear = givt.taxYear;
          taxYearAmount = givt.amount;
        } else {
          if (taxYear == givt.taxYear) {
            taxYearAmount += givt.amount;
          } else {
            giftAidGroups[taxYear] = taxYearAmount;
            taxYear = givt.taxYear;
            taxYearAmount = givt.amount;
          }
        }
      }
      if (sortedGivts.indexOf(givt) == (sortedGivts.length - 1)) {
        giftAidGroups[taxYear] = taxYearAmount;
      }
    }
    return giftAidGroups;
  }

  FutureOr<void> _onGivtDownloadOverviewByYear(
    GivtDownloadOverviewByYear event,
    Emitter<GivtState> emit,
  ) async {
    try {
      final fromDate = DateTime.parse('${event.year}-01-01').toIso8601String();
      final tillDate = DateTime.parse('${int.parse(event.year) + 1}-01-01')
          .toIso8601String();

      await givtRepository.downloadYearlyOverview(
        body: {'fromDate': fromDate, 'tillDate': tillDate},
      );
      emit(
        GivtDownloadedSuccess(
          givts: state.givts,
          givtGroups: state.givtGroups,
          givtAided: state.givtAided,
        ),
      );
    } on GivtServerFailure catch (e, stackTrace) {
      await LoggingInfo.instance.error(
        e.body.toString(),
        methodName: stackTrace.toString(),
      );
      emit(GivtError(e.body.toString()));
    }
  }
}
