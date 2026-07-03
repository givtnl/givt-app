part of 'pledges_overview_cubit.dart';

class PledgesOverviewUIModel {
  const PledgesOverviewUIModel({
    required this.currentGroups,
    required this.pastGroups,
  });

  factory PledgesOverviewUIModel.fromPledges(
    List<Pledge> pledges, {
    DateTime? now,
  }) {
    if (pledges.isEmpty) {
      return const PledgesOverviewUIModel(
        currentGroups: [],
        pastGroups: [],
      );
    }

    final cards = _toOverviewCards(pledges);
    final currentCards = <PledgeOverviewCard>[];
    final pastCards = <PledgeOverviewCard>[];
    for (final card in cards) {
      if (PledgesPartition.isPast(card.representative, now: now)) {
        pastCards.add(card);
      } else {
        currentCards.add(card);
      }
    }

    return PledgesOverviewUIModel(
      currentGroups: _groupCardsByCollectGroup(
        currentCards,
        _compareCardsByNextExecutionDate,
      ),
      pastGroups: _groupCardsByCollectGroup(
        pastCards,
        _compareCardsByEndDateDesc,
      ),
    );
  }

  static List<PledgeOverviewCard> _toOverviewCards(List<Pledge> pledges) {
    final grouped = <String, List<Pledge>>{};
    for (final pledge in pledges) {
      grouped.putIfAbsent(pledge.pledgeGroupId, () => []).add(pledge);
    }
    return grouped.values
        .map(PledgeOverviewCard.fromPledges)
        .toList();
  }

  static List<PledgeGroupSection> _groupCardsByCollectGroup(
    List<PledgeOverviewCard> cards,
    int Function(PledgeOverviewCard, PledgeOverviewCard) compare,
  ) {
    if (cards.isEmpty) {
      return const [];
    }

    final grouped = <String, List<PledgeOverviewCard>>{};
    for (final card in cards) {
      grouped.putIfAbsent(card.collectGroup.name, () => []).add(card);
    }

    final groupNames = grouped.keys.toList()..sort();
    return groupNames.map((groupName) {
      final sectionCards = List<PledgeOverviewCard>.from(grouped[groupName]!)
        ..sort(compare);

      return PledgeGroupSection(
        groupName: groupName,
        cards: sectionCards,
      );
    }).toList();
  }

  static int _compareCardsByNextExecutionDate(
    PledgeOverviewCard a,
    PledgeOverviewCard b,
  ) {
    final aDate = a.earliestNextExecution;
    final bDate = b.earliestNextExecution;
    if (aDate == null && bDate == null) return 0;
    if (aDate == null) return 1;
    if (bDate == null) return -1;
    return aDate.compareTo(bDate);
  }

  static int _compareCardsByEndDateDesc(
    PledgeOverviewCard a,
    PledgeOverviewCard b,
  ) {
    final aDate = a.representative.endDateTime;
    final bDate = b.representative.endDateTime;
    if (aDate == null && bDate == null) return 0;
    if (aDate == null) return 1;
    if (bDate == null) return -1;
    return bDate.compareTo(aDate);
  }

  final List<PledgeGroupSection> currentGroups;
  final List<PledgeGroupSection> pastGroups;

  bool get isEmpty => currentGroups.isEmpty && pastGroups.isEmpty;

  bool get hasCurrentPledges => currentGroups.isNotEmpty;

  bool get hasPastPledges => pastGroups.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PledgesOverviewUIModel &&
        other.currentGroups == currentGroups &&
        other.pastGroups == pastGroups;
  }

  @override
  int get hashCode => Object.hash(currentGroups, pastGroups);
}

class PledgeGroupSection {
  const PledgeGroupSection({
    required this.groupName,
    required this.cards,
  });

  final String groupName;
  final List<PledgeOverviewCard> cards;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PledgeGroupSection &&
        other.groupName == groupName &&
        other.cards == cards;
  }

  @override
  int get hashCode => Object.hash(groupName, cards);
}

sealed class PledgesOverviewCustom {
  const PledgesOverviewCustom();
}
