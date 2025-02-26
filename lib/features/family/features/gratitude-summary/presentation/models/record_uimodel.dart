import 'package:record/record.dart';

class RecordUIModel {

  const RecordUIModel({this.amplitude, this.isRecording = false});
  final Amplitude? amplitude;
  final bool isRecording;
}