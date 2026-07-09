import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/features/pledges/overview/cubit/pledges_overview_cubit.dart';
import 'package:givt_app/features/pledges/overview/repositories/pledges_overview_repository.dart';
import 'package:givt_app/features/pledges/shared/models/pledge.dart';
import 'package:givt_app/shared/bloc/base_state.dart';

class _FakePledgesOverviewRepository with PledgesOverviewRepository {
  List<Pledge> _pledges = const [];
  String? _error;

  @override
  bool isLoading() => false;

  @override
  String? getError() => _error;

  @override
  List<Pledge> getPledges() => _pledges;

  @override
  Future<void> loadPledges() async {}

  void setPledges(List<Pledge> pledges) {
    _pledges = pledges;
  }

  void setError(String error) {
    _error = error;
  }
}

Pledge _pledge({
  required String id,
  required String pledgeGroupId,
  required String collectGroupName,
  required String pledgeGroupName,
  required String goalName,
  required double amount,
  String frequency = 'Monthly',
  String? nextExecutionDate,
  String? endDate,
  double? goalAmount,
  double paidAmount = 0,
}) {
  return Pledge(
    id: id,
    goalId: 'goal-$id',
    pledgeGroupId: pledgeGroupId,
    type: 'Recurring',
    amount: amount,
    frequency: frequency,
    collectGroup: PledgeCollectGroup(
      id: 'cg-$collectGroupName',
      namespace: 'org.example',
      name: collectGroupName,
    ),
    pledgeGroupName: pledgeGroupName,
    goalName: goalName,
    goalAmount: goalAmount,
    paidAmount: paidAmount,
    nextExecutionDate: nextExecutionDate,
    endDate: endDate,
  );
}

void main() {
  group('PledgesOverviewCubit', () {
    late _FakePledgesOverviewRepository repository;
    late PledgesOverviewCubit cubit;

    setUp(() {
      repository = _FakePledgesOverviewRepository();
      cubit = PledgesOverviewCubit(repository);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('emits pledges grouped by collect group on init', () async {
      repository.setPledges([
        _pledge(
          id: '1',
          pledgeGroupId: 'pg-b',
          collectGroupName: 'Beta Church',
          pledgeGroupName: 'Campaign B',
          goalName: 'Goal A',
          amount: 10,
          nextExecutionDate: '2026-09-01T00:00:00.000Z',
          endDate: '2026-12-31T00:00:00Z',
        ),
        _pledge(
          id: '2',
          pledgeGroupId: 'pg-a',
          collectGroupName: 'Alpha Church',
          pledgeGroupName: 'Campaign A',
          goalName: 'Goal B',
          amount: 20,
          nextExecutionDate: '2026-08-01T00:00:00.000Z',
          endDate: '2026-12-31T00:00:00Z',
        ),
        _pledge(
          id: '3',
          pledgeGroupId: 'pg-a',
          collectGroupName: 'Alpha Church',
          pledgeGroupName: 'Campaign A',
          goalName: 'Goal C',
          amount: 5,
          nextExecutionDate: '2026-10-01T00:00:00.000Z',
          endDate: '2026-12-31T00:00:00Z',
        ),
      ]);

      await cubit.init();

      final state = cubit.state;
      expect(
        state,
        isA<DataState<PledgesOverviewUIModel, PledgesOverviewCustom>>(),
      );

      final uiModel =
          (state as DataState<PledgesOverviewUIModel, PledgesOverviewCustom>)
              .data;
      expect(uiModel.isEmpty, isFalse);
      expect(uiModel.currentGroups, hasLength(2));
      expect(uiModel.currentGroups.first.groupName, 'Alpha Church');
      expect(uiModel.currentGroups.first.cards, hasLength(1));
      expect(uiModel.currentGroups.first.cards.first.upcomingAmount, 20);
      final nextDate =
          uiModel.currentGroups.first.cards.first.earliestNextExecution;
      expect(nextDate, isNotNull);
      expect(nextDate!.year, 2026);
      expect(nextDate.month, 8);
      expect(nextDate.day, 1);
      expect(uiModel.pastGroups, isEmpty);
    });

    test('emits empty ui model when no pledges', () async {
      repository.setPledges(const []);

      await cubit.init();

      final state = cubit.state;
      expect(
        state,
        isA<DataState<PledgesOverviewUIModel, PledgesOverviewCustom>>(),
      );
      final uiModel =
          (state as DataState<PledgesOverviewUIModel, PledgesOverviewCustom>)
              .data;
      expect(uiModel.isEmpty, isTrue);
    });

    test('emits error when repository fails', () async {
      repository.setError('network failure');

      await cubit.init();

      expect(
        cubit.state,
        isA<ErrorState<PledgesOverviewUIModel, PledgesOverviewCustom>>(),
      );
    });
  });

  group('PledgesOverviewUIModel.fromPledges', () {
    final now = DateTime(2026, 7, 3);

    test('combines goals in the same pledge group into one card', () {
      final uiModel = PledgesOverviewUIModel.fromPledges(
        [
          _pledge(
            id: '1',
            pledgeGroupId: 'pg-1',
            collectGroupName: 'Church',
            pledgeGroupName: 'Actie Kerkbalans 2026',
            goalName: 'Church balance',
            amount: 26,
            frequency: 'Yearly',
            endDate: '2026-12-31T00:00:00Z',
          ),
          _pledge(
            id: '2',
            pledgeGroupId: 'pg-1',
            collectGroupName: 'Church',
            pledgeGroupName: 'Actie Kerkbalans 2026',
            goalName: 'Mission',
            amount: 15,
            frequency: 'Yearly',
            endDate: '2026-12-31T00:00:00Z',
          ),
        ],
        now: now,
      );

      expect(uiModel.currentGroups, hasLength(1));
      expect(uiModel.currentGroups.first.cards, hasLength(1));
      expect(uiModel.currentGroups.first.cards.first.totalAmount, 41);
      expect(uiModel.currentGroups.first.cards.first.pledges, hasLength(2));
    });

    test('sorts groups alphabetically and cards by next execution date', () {
      final uiModel = PledgesOverviewUIModel.fromPledges(
        [
          _pledge(
            id: '1',
            pledgeGroupId: 'pg-z',
            collectGroupName: 'Z Church',
            pledgeGroupName: 'Campaign Z',
            goalName: 'Goal',
            amount: 1,
            nextExecutionDate: '2026-12-01T00:00:00.000Z',
            endDate: '2026-12-31T00:00:00Z',
          ),
          _pledge(
            id: '2',
            pledgeGroupId: 'pg-a',
            collectGroupName: 'A Church',
            pledgeGroupName: 'Campaign A',
            goalName: 'Goal',
            amount: 1,
            nextExecutionDate: '2026-11-01T00:00:00.000Z',
            endDate: '2026-12-31T00:00:00Z',
          ),
          _pledge(
            id: '3',
            pledgeGroupId: 'pg-b',
            collectGroupName: 'A Church',
            pledgeGroupName: 'Campaign B',
            goalName: 'Goal',
            amount: 1,
            endDate: '2026-12-31T00:00:00Z',
          ),
        ],
        now: now,
      );

      expect(uiModel.currentGroups.first.groupName, 'A Church');
      expect(uiModel.currentGroups.last.groupName, 'Z Church');
      expect(uiModel.currentGroups.first.cards, hasLength(2));
      final firstNextDate =
          uiModel.currentGroups.first.cards.first.earliestNextExecution;
      expect(firstNextDate, isNotNull);
      expect(firstNextDate!.year, 2026);
      expect(firstNextDate.month, 11);
      expect(firstNextDate.day, 1);
      expect(
        uiModel.currentGroups.first.cards.last.earliestNextExecution,
        isNull,
      );
    });

    test('moves pledge groups with past end date to past tab', () {
      final uiModel = PledgesOverviewUIModel.fromPledges(
        [
          _pledge(
            id: '1',
            pledgeGroupId: 'pg-current',
            collectGroupName: 'Church',
            pledgeGroupName: 'Current campaign',
            goalName: 'Goal',
            amount: 1,
            endDate: '2026-12-31T00:00:00Z',
          ),
          _pledge(
            id: '2',
            pledgeGroupId: 'pg-past',
            collectGroupName: 'Church',
            pledgeGroupName: 'Past campaign',
            goalName: 'Goal',
            amount: 1,
            endDate: '2025-12-31T00:00:00Z',
          ),
        ],
        now: now,
      );

      expect(uiModel.currentGroups, hasLength(1));
      expect(uiModel.currentGroups.first.cards, hasLength(1));
      expect(
        uiModel.currentGroups.first.cards.first.pledgeGroupName,
        'Current campaign',
      );
      expect(uiModel.pastGroups, hasLength(1));
      expect(uiModel.pastGroups.first.cards, hasLength(1));
      expect(
        uiModel.pastGroups.first.cards.first.pledgeGroupName,
        'Past campaign',
      );
    });
  });
}
