import 'package:givt_app/app.dart';
import 'package:givt_app/bootstrap.dart';

void main() {
  bootstrap(
    builder: () => const App(),
    environmentVariables: {
      'AMPLITUDE_KEY': 'f4fa9ab88de04c56a346aaa36c172a9a',
      'API_URL_US': 'dev-backend.givt.app',
      'API_URL_EU': 'dev-backend.givtapp.net',
    },
  );
}
