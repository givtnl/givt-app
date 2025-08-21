import 'package:intl/intl.dart';

class ChildDateUtils {
  static final today = DateTime.now();
  static final DateTime maximumDate = today;
  static final minimumDate = DateTime(today.year - 18);

  static final dateFormatter = DateFormat('MM/dd/yyyy');
}
