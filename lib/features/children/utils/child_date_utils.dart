import 'package:intl/intl.dart';

class ChildDateUtils {
  static final today = DateTime.now();
  static final maximumDate = today;
  static final minimumDate = DateTime(today.year - 18);

  static final dateFormatter = DateFormat('MM.dd.yyyy');
}
