import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/record_answer_uimodel.dart';
import 'package:givt_app/features/family/features/reflect/domain/models/roles.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class InterviewCubit extends CommonCubit<RecordAnswerUIModel, GameProfile> {
  InterviewCubit(this._reflectAndShareRepository)
      : super(const BaseState.initial());

  final ReflectAndShareRepository _reflectAndShareRepository;

  List<GameProfile> _reporters = [];
  int _currentReporterIndex = 0;
  int _currentQuestionIndex = 0;
  bool _allQuestionsAsked = false;
  bool hasCountDownStarted = false;

  void init() {
    _reporters = getReporters();
    _currentReporterIndex = 0;
    _currentQuestionIndex = 0;
    _allQuestionsAsked = false;
    _emitData();
  }

  List<GameProfile> getReporters() =>
      _reflectAndShareRepository.getCurrentReporters();

  GameProfile getSidekick() => _reflectAndShareRepository.getCurrentSidekick();

  // Get current reporter's question based on the indices
  String getCurrentQuestion() {
    final reporter = _reporters[_currentReporterIndex];
    return (reporter.role as Reporter).questions![_currentQuestionIndex];
  }

  // Get current reporter
  GameProfile getCurrentReporter() => _reporters[_currentReporterIndex];

  // Check if we have asked all questions
  bool allQuestionsAsked() => _allQuestionsAsked;

  // Check if it is the last question for all reporters
  bool _isLastQuestion() {
    return _currentQuestionIndex == (getMaxQuestionCount() - 1) &&
        _currentReporterIndex == (_reporters.length - 1);
  }

  // Get the maximum number of questions a reporter has
  int getMaxQuestionCount() {
    return _reporters
        .map((r) => (r.role! as Reporter).questions!.length)
        .fold(0, (max, len) => len > max ? len : max);
  }

  // Advance to the next reporter/question
  void advanceToNext() {
    if (_currentReporterIndex < _reporters.length - 1) {
      _currentReporterIndex++;
    } else if (_currentQuestionIndex < getMaxQuestionCount() - 1) {
      _currentReporterIndex = 0; // Go back to the first reporter
      _currentQuestionIndex++;
    } else {
      _allQuestionsAsked = true; // No more questions to ask
    }
    _emitData();
  }

  void interviewFinished() {
    emitCustom(getSidekick());
  }

  void onCountdownStarted() {
    hasCountDownStarted = true;
    _emitData();
  }

  // Get button text for current state
  String getButtonText() {
    if (!hasCountDownStarted) return "Start Interview";
    if (_isLastQuestion()) return "Finish";
    return "Next Reporter";
  }

  void _emitData() {
    emitData(RecordAnswerUIModel(
      reporter: getCurrentReporter(),
      question: getCurrentQuestion(),
      buttonText: getButtonText(),
    ));
  }
}
