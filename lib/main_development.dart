import 'package:givt_app/app.dart';
import 'package:givt_app/bootstrap.dart';

void main() {
  bootstrap(
    () => const App(
      config: {
        'AMPLITUDE_KEY': '',
        'API_URL_US': 'dev-backend.givt.app',
        'API_URL_EU': 'dev-backend.givtapp.net',
      },
    ),
  );
}
