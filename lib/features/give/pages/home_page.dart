import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static MaterialPageRoute<dynamic> route() {
    return MaterialPageRoute(
      builder: (_) => const HomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthCubit>().state as AuthSuccess;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              auth.user.email,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
