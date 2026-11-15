part of 'give_bloc.dart';

enum GiveStatus {
  initial,
  loading,
  readyToGive,
  noInternetConnection,
  submissionTimeout,
  donatedToSameOrganisationInLessThan30Seconds,
  processed,
  error,
}

class GiveState extends Equatable {
  const GiveState({
    this.status = GiveStatus.initial,
    this.organisation = const Organisation.empty(),
    this.givtTransactions = const [],
    this.instanceName = '',
    this.afterGivingRedirection = '',
    this.transactionIds = const [],
    this.userGUID = '',
    this.isForYouFlow = false,
    this.submitted = false,
  });

  final GiveStatus status;
  final Organisation organisation;
  final List<GivtTransaction> givtTransactions;
  final String instanceName;
  final String afterGivingRedirection;
  final List<int> transactionIds;
  final String userGUID;
  final bool isForYouFlow;
  final bool submitted;

  GiveState copyWith({
    GiveStatus? status,
    Organisation? organisation,
    String? instanceName,
    String? afterGivingRedirection,
    List<GivtTransaction>? givtTransactions,
    List<int>? transactionIds,
    String? userGUID,
    bool? isForYouFlow,
    bool? submitted,
  }) {
    return GiveState(
      status: status ?? this.status,
      organisation: organisation ?? this.organisation,
      instanceName: instanceName ?? this.instanceName,
      afterGivingRedirection:
          afterGivingRedirection ?? this.afterGivingRedirection,
      givtTransactions: givtTransactions ?? this.givtTransactions,
      transactionIds: transactionIds ?? this.transactionIds,
      userGUID: userGUID ?? this.userGUID,
      isForYouFlow: isForYouFlow ?? this.isForYouFlow,
      submitted: submitted ?? this.submitted,
    );
  }

  @override
  List<Object> get props => [
    status,
    organisation,
    givtTransactions,
    instanceName,
    afterGivingRedirection,
    transactionIds,
    userGUID,
    isForYouFlow,
    submitted,
  ];
}