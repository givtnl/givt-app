import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:givt_app/app/app.dart';
import 'package:givt_app/app/bootstrap.dart';
import 'package:givt_app/app/firebase_options_dev.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'givt-dev-pre',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await bootstrap(
    builder: () => const App(),
  );
}
