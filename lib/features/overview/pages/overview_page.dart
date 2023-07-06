import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/overview/bloc/givt_bloc.dart';
import 'package:givt_app/features/overview/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_rounded),
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              useSafeArea: true,
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              builder: (context) => Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      locals.historyInfoTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<GivtBloc, GivtState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GivtLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final sections = state.givtGroups
              .where((element) => element.givts.isEmpty)
              .toList();
          return ListView.builder(
            itemCount: _getSectionCount(state),
            itemBuilder: (context, int index) {
              return StickyHeader(
                header: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  color: AppTheme.givtLightPurple,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${DateFormat('MMMM').format(sections[index].timeStamp!)} \'${DateFormat('yy').format(sections[index].timeStamp!)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${sections[index].amount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                content: Column(
                  children: state.givtGroups.map((givtGroup) {
                    if (givtGroup.givts.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    if (givtGroup.timeStamp!.month !=
                        sections[index].timeStamp!.month) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      children: [
                        GivtListItem(givtGroup: givtGroup),
                        const Divider(
                          height: 0,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  int _getSectionCount(GivtState state) {
    var daysCount = 0;
    for (final group in state.givtGroups) {
      if (group.givts.isEmpty) {
        daysCount++;
      }
    }
    return daysCount;
  }
}
