import 'package:givt_app/core/network/network.dart';
import 'package:givt_app/features/recurring_donations/create/models/recurring_donation.dart';
import 'package:givt_app/features/recurring_donations/create/presentation/constants/string_keys.dart';
import 'package:givt_app/features/recurring_donations/overview/models/recurring_donation.dart' as overview;
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';

class RecurringDonationRepository {
  RecurringDonationRepository(
    this._collectGroupRepository,
    this._apiService,
  );

  final CollectGroupRepository _collectGroupRepository;
  final APIService _apiService;

  CollectGroup? _selectedOrganization;
  overview.Frequency? _frequency;
  String? _amount;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _numberOfDonations;
  String? _selectedEndOption;
  String? _guid;
  String? _country;

  CollectGroup? get selectedOrganization => _selectedOrganization;
  set selectedOrganization(CollectGroup? value) =>
      _selectedOrganization = value;

  overview.Frequency? get frequency => _frequency;
  set frequency(overview.Frequency? value) => _frequency = value;

  String? get amount => _amount;
  set amount(String? value) => _amount = value;

  DateTime? get startDate => _startDate;
  set startDate(DateTime? value) => _startDate = value;

  DateTime? get endDate => _endDate;
  set endDate(DateTime? value) => _endDate = value;

  String? get numberOfDonations => _numberOfDonations;
  set numberOfDonations(String? value) => _numberOfDonations = value;

  String? get selectedEndOption => _selectedEndOption;
  set selectedEndOption(String? value) => _selectedEndOption = value;

  String? get guid => _guid;
  set guid(String? value) => _guid = value;

  String? get country => _country;
  set country(String? value) => _country = value;

  Future<List<CollectGroup>> fetchOrganizations() {
    return _collectGroupRepository.fetchCollectGroupList();
  }

  Future<bool> createRecurringDonation(
    RecurringDonation recurringDonation,
  ) async {
    final response =
        await _apiService.createRecurringDonation(recurringDonation.toJson());

    return response;
  }

  void init(String guid, String country, CollectGroup? collectGroup) {
    _selectedOrganization = collectGroup;
    _frequency = null;
    _amount = null;
    _startDate = null;
    _endDate = null;
    _numberOfDonations = null;
    _selectedEndOption = null;
    _guid = guid;
    _country = country;
  }

  /// Prefills the creation draft from an ended/cancelled recurring donation so
  /// the user can restart it via the confirm step of the creation flow.
  Future<void> initFromRecurringDonation({
    required overview.RecurringDonation donation,
    required String guid,
    required String country,
  }) async {
    final collectGroups = await _collectGroupRepository.fetchCollectGroupList();
    final collectGroup = collectGroups.firstWhere(
      (group) => group.orgName == donation.collectGroupName,
      orElse: () => const CollectGroup.empty(),
    );

    if (collectGroup.nameSpace.isEmpty) {
      throw StateError(
        'Could not find organization for ${donation.collectGroupName}',
      );
    }

    final today = DateTime.now();
    final tomorrow = DateTime(today.year, today.month, today.day).add(
      const Duration(days: 1),
    );

    _guid = guid;
    _country = country;
    _selectedOrganization = collectGroup;
    _frequency = donation.frequency;
    _amount = _formatAmountForInput(donation.amount);
    _startDate = tomorrow;
    _numberOfDonations = null;
    _endDate = null;
    _selectedEndOption = null;

    if (donation.numberOfTurns == 999) {
      _selectedEndOption = RecurringDonationStringKeys.whenIDecide;
    } else if (donation.endDate != null) {
      _selectedEndOption = RecurringDonationStringKeys.onSpecificDate;
      _endDate = DateTime.parse(donation.endDate!);
    } else {
      _selectedEndOption = RecurringDonationStringKeys.afterNumberOfDonations;
      _numberOfDonations = donation.numberOfTurns.toString();
      _endDate = donation.calculatedEndDate;
    }
  }

  static String _formatAmountForInput(double amount) {
    if (amount == amount.truncateToDouble()) {
      return amount.toInt().toString();
    }

    return amount.toString();
  }
}
