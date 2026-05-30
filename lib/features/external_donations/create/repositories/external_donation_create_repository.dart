import 'package:givt_app/features/external_donations/create/models/external_donation_create_draft.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation.dart';
import 'package:givt_app/features/personal_summary/add_external_donation/models/external_donation_frequency.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/repositories/collect_group_repository.dart';
import 'package:givt_app/shared/repositories/givt_repository.dart';

/// Builds POST bodies for `POST /givtservice/v1/externaldonations`.
///
/// **API contract (COR-1029 + ENG-651):**
/// - `amount`, `description`, `frequency` (`Once`, `Weekly`, `Monthly`, …)
/// - `taxDeductable` — sent for custom organisations; omitted for known orgs
/// - `collectGroupId` — optional known-org namespace
/// - `creationDate` — one-off gift date, or recurring last-gift anchor day
/// - `startDate` — recurring series start (first day of selected month/year);
///   backend generates historical + upcoming transaction records
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
      'active': true,
    };

    final namespace = draft.selectedOrganisation?.nameSpace;
    if (namespace != null && namespace.isNotEmpty && !draft.isCustomOrganisation) {
      body['collectGroupId'] = namespace;
    }

    if (draft.isCustomOrganisation) {
      body['taxDeductable'] = draft.taxDeductible;
    }

    if (draft.isOneOff == true && draft.dateMade != null) {
      body['creationDate'] = draft.dateMade!.toUtc().toIso8601String();
    }

    if (draft.isOneOff == false) {
      if (draft.lastGiftDate != null) {
        body['creationDate'] = draft.lastGiftDate!.toUtc().toIso8601String();
      }
      if (draft.startMonthYear != null) {
        body['startDate'] = DateTime(
          draft.startMonthYear!.year,
          draft.startMonthYear!.month,
        ).toUtc().toIso8601String();
      }
    }

    return body;
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

  void updateLastGiftDate(DateTime date);

  void updateStartMonthYear(DateTime monthYear);

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
    _draft = _draft.copyWith(dateMade: date);
  }

  @override
  void updateLastGiftDate(DateTime date) {
    _draft = _draft.copyWith(lastGiftDate: date);
  }

  @override
  void updateStartMonthYear(DateTime monthYear) {
    _draft = _draft.copyWith(
      startMonthYear: DateTime(monthYear.year, monthYear.month),
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
