import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/overview/bloc/givt_bloc.dart';
import 'package:givt_app/l10n/l10n.dart';

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
          return ListView.builder(
            itemCount: state.givts.length,
            itemBuilder: (context, index) {
              final givt = state.givts[index];
              return ListTile(
                title: Text(givt.amount.toString()),
                subtitle: Text(givt.organisationName),
                trailing: Text(givt.amount.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
