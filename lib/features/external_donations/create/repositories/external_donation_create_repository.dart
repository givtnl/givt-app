import 'package:givt_app/features/external_donations/create/models/external_donation_create_draft.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation.dart';
import 'package:givt_app/features/external_donations/shared/models/external_donation_frequency.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

/// Builds POST bodies for `POST /givtservice/v1/externaldonations`.
///
/// **API contract (COR-1029 + ENG-651):**
/// - `amount`, `description`, `frequency` (`Once`, `Weekly`, `Monthly`, …)
/// - `taxDeductable` — user-selected tax relief flag (custom and known orgs)
/// - `startDate` — one-off gift date (`dateMade`), or recurring series start
///
/// Does not send `active` (defaults on server) or `collectGroupId`.
class ExternalDonationCreatePayloadBuilder {
  const ExternalDonationCreatePayloadBuilder._();

  static Map<String, dynamic> build(ExternalDonationCreateDraft draft) {
    final amount = draft.parsedAmount!;
    final frequency = draft.isOneOff == true
        ? ExternalDonationFrequency.once
        : draft.frequency!;

    final body = <String, dynamic>{
      'amount': amount,
      'description': draft.organisationName.trim(),
      'frequency': ExternalDonation.frequencyEnumToString(frequency),
      'taxDeductable': draft.taxDeductible,
    };

    final startDate = _startDate(draft);
    if (startDate != null) {
      body['startDate'] = _formatStartDate(startDate);
    }

    return body;
  }

  static DateTime? _startDate(ExternalDonationCreateDraft draft) {
    if (draft.isOneOff == true) {
      return draft.dateMade;
    }
    if (draft.isOneOff == false && draft.seriesStartDate != null) {
      return draft.seriesStartDate;
    }
    return null;
  }

  /// Selected calendar date at local midnight as ISO-8601 without a timezone offset.
  static String _formatStartDate(DateTime date) {
    return DateTime(date.year, date.month, date.day).toIso8601String();
  }
}

mixin ExternalDonationCreateRepository {
  ExternalDonationCreateDraft getDraft();

  void resetDraft();

  void selectKnownOrganisation(CollectGroup organisation);

  void selectCustomOrganisation(String name);

  void updateAmount(String amount);

  void updateTaxDeductible(bool value);

  void selectOneOff();

  void selectRecurring(ExternalDonationFrequency frequency);

  void updateDateMade(DateTime date);

  void updateSeriesStartDate(DateTime date);

  Future<ExternalDonation?> submit();

  Future<void> ensureOrganisationsLoaded();
}

class ExternalDonationCreateRepositoryImpl
    with ExternalDonationCreateRepository {
  ExternalDonationCreateRepositoryImpl(
    this._givtRepository,
    this._collectGroupRepository,
  );

  final GivtRepository _givtRepository;
  final CollectGroupRepository _collectGroupRepository;

  ExternalDonationCreateDraft _draft = const ExternalDonationCreateDraft();

  @override
  ExternalDonationCreateDraft getDraft() => _draft;

  @override
  void resetDraft() {
    _draft = const ExternalDonationCreateDraft();
  }

  @override
  void selectKnownOrganisation(CollectGroup organisation) {
    _draft = _draft.copyWith(
      organisationName: organisation.orgName,
      selectedOrganisation: organisation,
      isCustomOrganisation: false,
      taxDeductible: false,
    );
  }

  @override
  void selectCustomOrganisation(String name) {
    _draft = _draft.copyWith(
      organisationName: name.trim(),
      clearSelectedOrganisation: true,
      isCustomOrganisation: true,
      taxDeductible: false,
    );
  }

  @override
  void updateAmount(String amount) {
    _draft = _draft.copyWith(amountInput: amount);
  }

  @override
  void updateTaxDeductible(bool value) {
    _draft = _draft.copyWith(taxDeductible: value);
  }

  @override
  void selectOneOff() {
    _draft = _draft.copyWith(
      isOneOff: true,
      clearFrequency: true,
      clearDates: true,
    );
  }

  @override
  void selectRecurring(ExternalDonationFrequency frequency) {
    _draft = _draft.copyWith(
      isOneOff: false,
      frequency: frequency,
      clearDates: true,
    );
  }

  @override
  void updateDateMade(DateTime date) {
    _draft = _draft.copyWith(
      dateMade: DateTime(date.year, date.month, date.day),
    );
  }

  @override
  void updateSeriesStartDate(DateTime date) {
    _draft = _draft.copyWith(
      seriesStartDate: DateTime(date.year, date.month, date.day),
    );
  }

  @override
  Future<ExternalDonation?> submit() async {
    final body = ExternalDonationCreatePayloadBuilder.build(_draft);
    return _givtRepository.addExternalDonation(body: body);
  }

  @override
  Future<void> ensureOrganisationsLoaded() async {
    await _collectGroupRepository.fetchCollectGroupList();
  }
}
