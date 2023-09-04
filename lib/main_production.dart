import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:givt_app/app/app.dart';
import 'package:givt_app/app/bootstrap.dart';
import 'package:givt_app/app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'givtapp-ebde1',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await bootstrap(
    builder: () => const App(),
  );
}
