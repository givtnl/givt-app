import 'package:givt_app/app/app.dart';
import 'package:givt_app/app/bootstrap.dart';
import 'package:givt_app/app/firebase_options_dev.dart';

void main() {
  bootstrap(
    name: 'givt-dev-pre',
    options: DefaultFirebaseOptions.currentPlatform,
    builder: () => const App(),
  );
}
