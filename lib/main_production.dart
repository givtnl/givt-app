import 'package:givt_app/app.dart';
import 'package:givt_app/bootstrap.dart';

void main() {
  bootstrap(
    () => const App(
      config: {
        'AMPLITUDE_KEY': 'ceb9aaa139ac6028aa34166d6f57923e',
        'API_URL_US': 'backend.givt.app',
        'API_URL_EU': 'backend.givtapp.net',
      },
    ),
  );
}
