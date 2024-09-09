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
  int _nrOfQuestionsAsked = 0;
  bool hasCountDownStarted = false;

  void init() {
    _reporters = getReporters();
    _currentReporterIndex = 0;
    _currentQuestionIndex = 0;
    _nrOfQuestionsAsked = 0;
    hasCountDownStarted = false;

    _emitData();
  }

  List<GameProfile> getReporters() =>
      _reflectAndShareRepository.getCurrentReporters();

  GameProfile getSidekick() => _reflectAndShareRepository.getCurrentSidekick();

  // Get current reporter's question based on the indices
  String getCurrentQuestion() {
    final reporter = _reporters[_currentReporterIndex];
    return (reporter.role! as Reporter).questions![_currentQuestionIndex];
  }

  // Get current reporter
  GameProfile getCurrentReporter() => _reporters[_currentReporterIndex];

  bool _allQuestionsAsked() {
    // Check if all reporters have no more questions
    return _reporters.every((reporter) {
      final reporterQuestions = (reporter.role! as Reporter).questions!;
      return _currentQuestionIndex >= reporterQuestions.length;
    });
  }

  // Check if it is the last question for all reporters
  bool _isLastQuestion() {
    final totalQuestions = _reporters.fold(
      0,
      (previous, element) =>
          previous + (element.role! as Reporter).questions!.length,
    );
    return totalQuestions == _nrOfQuestionsAsked;
  }

  bool _nextQuestionIsLast() {
    final totalQuestions = _reporters.fold(
      0,
      (previous, element) =>
          previous + (element.role! as Reporter).questions!.length,
    );
    return totalQuestions == _nrOfQuestionsAsked + 1;
  }

  // Advance to the next reporter/question
  void advanceToNext() {
    _nrOfQuestionsAsked++;
    if (_isLastQuestion()) {
      interviewFinished();
      return;
    } else if (_currentReporterIndex < _reporters.length - 1) {
      _currentReporterIndex++;
    } else {
      _currentReporterIndex = 0;
      _currentQuestionIndex++;
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
    if (!hasCountDownStarted) return 'Start Interview';
    if (_nextQuestionIsLast()) return 'Finish';
    return _reporters.length == 1 ? 'Next Question' : 'Next Reporter';
  }

  void _emitData() {
    emitData(
      RecordAnswerUIModel(
        reporter: getCurrentReporter(),
        question: getCurrentQuestion(),
        buttonText: getButtonText(),
      ),
    );
  }
}
