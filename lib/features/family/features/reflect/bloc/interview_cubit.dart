import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';
import 'package:givt_app/features/family/features/reflect/domain/reflect_and_share_repository.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/interview_custom.dart';
import 'package:givt_app/features/family/features/reflect/presentation/models/record_answer_uimodel.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class InterviewCubit extends CommonCubit<InterviewUIModel, InterviewCustom> {
  InterviewCubit(this._reflectAndShareRepository)
      : super(const BaseState.initial());

  final ReflectAndShareRepository _reflectAndShareRepository;

  List<GameProfile> _reporters = [];
  int _currentReporterIndex = 0;
  int _currentQuestionIndex = 0;
  int _nrOfQuestionsAsked = 0;
  bool _showPassThePhoneScreen = false;

  void init() {
    _reporters = getReporters();
    _currentReporterIndex = 0;
    _currentQuestionIndex = 0;
    _nrOfQuestionsAsked = 0;

    _emitData();
  }

  List<GameProfile> getReporters() =>
      _reflectAndShareRepository.getCurrentReporters();

  GameProfile getSidekick() => _reflectAndShareRepository.getCurrentSidekick();

  // Get current reporter's question based on the indices
  String getCurrentQuestion() {
    final reporter = _reporters[_currentReporterIndex];
    return reporter.reporterRole!.questions![_currentQuestionIndex];
  }

  // Get current reporter
  GameProfile getCurrentReporter() => _reporters[_currentReporterIndex];

  // Check if it is the last question for all reporters
  bool _isLastQuestion() {
    final totalQuestions = _reporters.fold(
      0,
      (previous, element) =>
          previous + (element.reporterRole!).questions!.length,
    );
    return totalQuestions == _nrOfQuestionsAsked;
  }

  bool _nextQuestionIsLast() {
    final totalQuestions = _reporters.fold(
      0,
      (previous, element) =>
          previous + (element.reporterRole!).questions!.length,
    );
    return totalQuestions == _nrOfQuestionsAsked + 1;
  }

  // Advance to the next reporter/question
  void advanceToNext() {
    _reflectAndShareRepository.totalQuestionsAsked++;
    _nrOfQuestionsAsked++;
    if (_isLastQuestion()) {
      finishInterview();
      return;
    } else {
      if (!_hasOnlyOneReporter()) _showPassThePhoneScreen = true;
      if (_currentReporterIndex < _reporters.length - 1) {
        _currentReporterIndex++;
      } else {
        _currentReporterIndex = 0;
        _currentQuestionIndex++;
      }
      _emitData();
    }
  }

  void finishInterview() {
    emitCustom(
        InterviewCustom.goToGratitudeSelection(reporter: getCurrentReporter()));
  }

  void timeForQuestionRanOut() {
    advanceToNext();
  }

  // Get button text for current state
  String getButtonText() {
    if (_nextQuestionIsLast()) return 'Last question';
    return _hasOnlyOneReporter() ? 'Next Question' : 'Next Reporter';
  }

  bool _hasOnlyOneReporter() => _reporters.length == 1;

  void _emitData() {
    if (_showPassThePhoneScreen) {
      emitData(InterviewUIModel.passThePhone(reporter: getCurrentReporter()));
    } else {
      emitData(
        InterviewUIModel.recordAnswer(
          reporter: getCurrentReporter(),
          question: getCurrentQuestion(),
          buttonText: getButtonText(),
        ),
      );
    }
  }

  void onShowQuestionClicked() {
    _showPassThePhoneScreen = false;
    _emitData();
  }
}
