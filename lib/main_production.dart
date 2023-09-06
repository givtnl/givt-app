import 'package:givt_app/app/app.dart';
import 'package:givt_app/app/bootstrap.dart';
import 'package:givt_app/app/firebase_options.dart';

void main() {
  bootstrap(
    name: 'givtapp-ebde1',
    options: DefaultFirebaseOptions.currentPlatform,
    builder: () => const App(),
  );
}
