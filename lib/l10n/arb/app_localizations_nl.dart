import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get ibanPlaceHolder => 'IBAN-rekeningnummer';

  @override
  String get amountLimitExceeded => 'Hé gulle gever, dit bedrag is hoger dan je geeflimiet. Pas de limiet aan of verlaag het bedrag.';

  @override
  String get belgium => 'België';

  @override
  String get insertAmount => 'Weet je al hoeveel je wil geven? \n Voer een bedrag in.';

  @override
  String get netherlands => 'Nederland';

  @override
  String get notificationTitle => 'Givt';

  @override
  String get selectReceiverTitle => 'Ontvanger selecteren';

  @override
  String get slimPayInformation => 'Om te kunnen geven met Givt moet je een machtiging (SlimPay eMandate) afgeven.';

  @override
  String get savingSettings => 'Je hoeft nu even niks\n te doen terwijl wij\n je gegevens opslaan.';

  @override
  String get continueKey => 'Doorgaan';

  @override
  String get slimPayInfoDetail => 'Givt werkt samen met SlimPay voor het verwerken van transacties. SlimPay is gespecialiseerd in het verwerken van machtigingen en automatische incasso’s voor digitale platforms. Dit doet SlimPay voor Givt tegen de laagste kosten in de markt en met hoge snelheid.\n \n\n SlimPay is voor Givt de ideale partner omdat zij het geven zonder contant geld eenvoudig en veilig maakt. Zij staat als betaalinstelling onder toezicht van de Nederlandsche Bank en andere Nationale Europese Banken.\n \n\n Het geïncasseerde geld wordt verzameld op een rekening bij SlimPay. Givt zorgt ervoor dat het geld verdeeld wordt.';

  @override
  String get slimPayInfoDetailTitle => 'Wat is SlimPay?';

  @override
  String get continueRegistration => 'Je gebruikersaccount werd al aangemaakt, maar het is niet gelukt om de registratie helemaal af te ronden. \n \n\n We willen graag dat je Givt kunt gebruiken, dus vragen we je om in te loggen en je registratie compleet te maken.';

  @override
  String get contactFailedButton => 'Niet gelukt?';

  @override
  String get unregisterButton => 'Mijn account opzeggen';

  @override
  String get unregisterUnderstood => 'Ik begrijp het';

  @override
  String givtIsBeingProcessed(Object value0) {
    return 'Bedankt voor je Givt aan $value0!\n Kijk voor de status in je overzicht.';
  }

  @override
  String get offlineGegevenGivtMessage => 'Bedankt voor je Givt!\n \n\n Zodra er een goede verbinding is met de Givt-server, wordt je Givt verwerkt.\n Kijk voor de status in je overzicht.';

  @override
  String offlineGegevenGivtMessageWithOrg(Object value0) {
    return 'Bedankt voor je Givt!\n \n\n Zodra er een goede verbinding is met de Givt-server, wordt je Givt aan $value0 verwerkt.\n Kijk voor de status in je overzicht.';
  }

  @override
  String get pincode => 'Toegangscode';

  @override
  String get pincodeTitleChangingPin => 'Hier beheer je het gebruik van je toegangscode om in de Givt-app in te loggen.';

  @override
  String get pincodeChangePinMenu => 'Wijzig toegangscode';

  @override
  String get pincodeSetPinTitle => 'Toegangscode instellen';

  @override
  String get pincodeSetPinMessage => 'Stel hier je toegangscode in';

  @override
  String get pincodeEnterPinAgain => 'Voer je toegangscode nogmaals in';

  @override
  String get pincodeDoNotMatch => 'Codes zijn niet gelijk aan elkaar. Probeer je het nog een keer?';

  @override
  String get pincodeSuccessfullTitle => 'Gelukt!';

  @override
  String get pincodeSuccessfullMessage => 'Je toegangscode is succesvol opgeslagen.';

  @override
  String get pincodeForgotten => 'Inloggen met e-mail en wachtwoord';

  @override
  String get pincodeForgottenTitle => 'Toegangscode vergeten';

  @override
  String get pincodeForgottenMessage => 'Log in met je e-mailadres om toegang tot je account te krijgen.';

  @override
  String get pincodeWrongPinTitle => 'Foute toegangscode';

  @override
  String get pincodeWrongPinFirstTry => 'Eerste poging klopt niet.\n Probeer het nog een keer.';

  @override
  String get pincodeWrongPinSecondTry => 'Tweede poging klopt niet.\n Probeer het nog een keer.';

  @override
  String get pincodeWrongPinThirdTry => 'Je hebt drie verkeerde pogingen gedaan. Log in met je e-mailadres en wachtwoord.';

  @override
  String get wrongPasswordLockedOut => 'Je hebt drie verkeerde pogingen gedaan, je kunt 15 minuten niet inloggen. Probeer straks opnieuw of vraag een nieuw wachtwoord aan.';

  @override
  String confirmGivtSafari(Object value0) {
    return 'Bedankt voor je Givt aan $value0! Bevestig door op de knop te drukken en kijk voor de status in je overzicht.';
  }

  @override
  String get confirmGivtSafariNoOrg => 'Bedankt voor je Givt! Bevestig door op de knop te drukken en kijk voor de status in je overzicht.';

  @override
  String get menuSettingsSwitchAccounts => 'Wisselen van account';

  @override
  String get prepareIUnderstand => 'Ik snap het';

  @override
  String get amountLimitExceededGb => 'This amount is higher than £250. Please choose a lower amount.';

  @override
  String giftOverviewGiftAidBanner(Object value0) {
    return 'Gift Aided $value0';
  }

  @override
  String get maximumAmountReachedGb => 'Woah, you\'ve reached the maximum donation limit. In the UK you can give a maximum of £250 per donation.';

  @override
  String get faqWhyBluetoothEnabledQ => 'Waarom moet bluetooth ingeschakeld zijn tijdens het gebruik van Givt?';

  @override
  String get faqWhyBluetoothEnabledA => 'Je telefoon pikt het bluetooth signaal op van de zender die in het collectemiddel zit. Het gaat hierbij om een eenrichtingsverkeer en er hoeft dus geen verbinding te worden gemaakt, zoals je dat misschien gewend bent bij een bluetooth carkit of headset. Het is een veilige en makkelijke manier voor de telefoon om te weten welk collectemiddel het is. Op het moment dat de zender dichtbij is en het signaal door je telefoon wordt opgepikt, is je Givt gelukt!';

  @override
  String get collect => 'Collecte';

  @override
  String get offlineGegevenGivtsMessage => 'Bedankt voor je Givts!\n \n\n Zodra er een goede verbinding is met de Givt-server, worden je Givts verwerkt.\n Kijk voor de status in je overzicht.';

  @override
  String offlineGegevenGivtsMessageWithOrg(Object value0) {
    return 'Bedankt voor je Givts!\n \n\n Zodra er een goede verbinding is met de Givt-server, worden je Givts aan $value0 verwerkt.\n Kijk voor de status in je overzicht.';
  }

  @override
  String get changeDonation => 'Wijzig je donatie';

  @override
  String get cancelGivts => 'annuleer je Givt';

  @override
  String get areYouSureToCancelGivts => 'Weet je het zeker? Tik op OK om te bevestigen.';

  @override
  String get feedbackTitle => 'Feedback of vragen?';

  @override
  String get noMessage => 'Je hebt geen bericht ingevoerd.';

  @override
  String get feedbackMailSent => 'Bedankt voor je bericht! We nemen zo snel mogelijk contact met je op.';

  @override
  String get typeMessage => 'Schrijf hier je bericht!';

  @override
  String get safariGivtTransaction => 'Deze Givt wordt in een transactie omgezet.';

  @override
  String get safariMandateSignedPopup => 'Jouw giften worden van dit IBAN afgeschreven. Niet akkoord? Annuleer dan deze Givt en maak een nieuwe account aan.';

  @override
  String get didNotSignMandateYet => 'Om gewoon te kunnen geven, moet je een mandaat hebben afgegeven. Op dit moment is het niet mogelijk om een mandaat af te geven. Probeer later opnieuw.';

  @override
  String get appVersion => 'App versie:';

  @override
  String get shareGivtText => 'Deel Givt';

  @override
  String get shareGivtTextLong => 'Hey! Wil je ook gewoon blijven geven?';

  @override
  String get givtGewoonBlijvenGeven => 'Givt - Gewoon blijven geven.';

  @override
  String get updatesDoneTitle => 'Klaar om te geven?';

  @override
  String get updatesDoneSubtitle => 'Givt is volledig up-to-date, veel plezier met geven.';

  @override
  String get featureShareTitle => 'Deel Givt met iedereen!';

  @override
  String get featureShareSubtitle => 'Givt delen, da\'s een makkie. Dat kan je onderaan in het menu.';

  @override
  String get askMeLater => 'Vraag het me later';

  @override
  String get giveDifferently => 'Kies uit de lijst';

  @override
  String get churches => 'Kerken';

  @override
  String get stichtingen => 'Goede doelen';

  @override
  String get acties => 'Acties';

  @override
  String get overig => 'Overig';

  @override
  String get signMandateLaterTitle => 'Ok, we vragen het je later opnieuw!';

  @override
  String get signMandateLater => 'Je hebt gekozen om het mandaat later aan te vragen, dit zal gebeuren bij de volgende keer dat je wil geven.';

  @override
  String get suggestie => 'Geven aan:';

  @override
  String get codeCanNotBeScanned => 'Helaas, met deze code kan je niet geven in de Givt-app.';

  @override
  String get giveDifferentScan => 'Scan de QR-code';

  @override
  String get giveDiffQrText => 'Nu goed mikken!';

  @override
  String get qrCodeOrganisationNotFound => 'Het scannen is gelukt, maar de organisatie is nog even verdwaald. Probeer het later opnieuw.';

  @override
  String get noCameraAccess => 'Om de code te scannen heeft Givt je camera nodig. Ga naar de app-instellingen op je smartphone om Givt toegang te verlenen.';

  @override
  String get nsCameraUsageDescription => 'We willen graag de camera gebruiken om de code te scannen.';

  @override
  String get openSettings => 'Open instellingen';

  @override
  String get needEmailToGiveSubtext => 'Om je giften goed af te kunnen handelen, hebben we je e-mailadres nodig.';

  @override
  String get completeRegistrationAfterGiveFirst => 'Leuk dat je hebt gegeven met Givt!\n \n\n We willen graag dat je Givt verder\n kunt gebruiken, dus vragen we je om\n je registratie compleet te maken.';

  @override
  String get termsUpdate => 'De algemene voorwaarden zijn bijgewerkt';

  @override
  String get agreeToUpdateTerms => 'Bij het doorgaan ga je akkoord met de nieuwe voorwaarden.';

  @override
  String get iWantToReadIt => 'Ik wil het lezen';

  @override
  String get termsTextVersion => '1.9';

  @override
  String get locationPermission => 'We hebben toegang tot je locatie nodig om het signaal van de Givt-zender te ontvangen.';

  @override
  String get locationEnabledMessage => 'Activeer je locatie met hoge nauwkeurigheid om met Givt te kunnen geven. (Na je gift kan je die weer uitzetten.)';

  @override
  String get changeGivingLimit => 'Geeflimiet aanpassen';

  @override
  String get somethingWentWrong2 => 'Er gaat iets mis.';

  @override
  String get chooseLowerAmount => 'Bedrag aanpassen';

  @override
  String get turnOnBluetooth => 'Bluetooth aanzetten';

  @override
  String get errorTldCheck => 'Helaas, met dit e-mailadres lukt het registreren niet. Controleer je nog even op typefouten?';

  @override
  String get addCollectConfirm => 'Wil je een tweede collecte toevoegen?';

  @override
  String get faQvraag0 => 'Feedback of vragen?';

  @override
  String get faQantwoord0 => 'Je kunt ons een bericht sturen door in het app-menu naar \"Over Givt / Contact\" te gaan en daar je vraag te stellen. We zijn natuurlijk ook bereikbaar via +31 320 320 115 of support@givtapp.net.';

  @override
  String get personalPageHeader => 'Wijzig hieronder je gegevens.';

  @override
  String get personalPageSubHeader => 'Wil je graag je naam veranderen? Stuur dan een mailtje naar support@givtapp.net.';

  @override
  String get titlePersonalInfo => 'Mijn gegevens';

  @override
  String get personalInfoTempUser => 'Hé, snelle gever! Je gebruikt een tijdelijk account. We hebben je gegevens dus nog niet ontvangen.';

  @override
  String get updatePersonalInfoError => 'We kunnen op dit moment je gegevens niet opslaan op de server, probeer je het later even opnieuw?';

  @override
  String get updatePersonalInfoSuccess => 'Gelukt!';

  @override
  String get loadingTitle => 'Even wachten...';

  @override
  String get loadingMessage => 'We zijn je gegevens aan het laden ...';

  @override
  String get buttonChange => 'Wijzigen';

  @override
  String get welcomeContinue => 'Aan de slag';

  @override
  String get enterEmail => 'Aan de slag';

  @override
  String get finalizeRegistrationPopupText => 'Om je giften op het juiste adres te kunnen bezorgen, moet je nog even je registratie voltooien.';

  @override
  String get finalizeRegistration => 'Registratie voltooien';

  @override
  String get importantReminder => 'Belangrijke herinnering';

  @override
  String get multipleCollections => 'Meerdere collectes';

  @override
  String get questionAndroidLocation => 'Waarom heeft Givt mijn locatiegegevens nodig?';

  @override
  String get answerAndroidLocation => 'Wanneer je een Android telefoon gebruikt, kan de Givt-app de zender in de collectezak alleen detecteren wanneer jouw locatiegegevens bekend zijn. Om met Givt te kunnen geven, heeft Givt dus jouw locatiegegevens nodig. Verder doen we helemaal niets met die locatiegegevens.';

  @override
  String get shareTheGivtButton => 'Deel met mijn vrienden';

  @override
  String shareTheGivtText(Object value0) {
    return 'Ik heb zonet gegeven aan $value0 met Givt!';
  }

  @override
  String get shareTheGivtTextNoOrg => 'Ik heb zonet gegeven met Givt!';

  @override
  String get joinGivt => 'Doe je ook mee? givtapp.net/download';

  @override
  String get firstUseWelcomeSubTitle => 'Swipe voor meer informatie';

  @override
  String get firstUseWelcomeTitle => 'Welkom!';

  @override
  String get firstUseLabelTitle1 => 'Met één machtiging overal geven';

  @override
  String get firstUseLabelTitle2 => 'Makkelijk, veilig en anoniem geven';

  @override
  String get firstUseLabelTitle3 => 'Altijd en overal geven';

  @override
  String get yesSuccess => 'Yes, gelukt!';

  @override
  String get toGiveWeNeedYourEmailAddress => 'Om te geven met Givt is\n alvast je e-mailadres nodig';

  @override
  String get weWontSendAnySpam => '(we sturen geen spam, beloofd)';

  @override
  String get swipeDownOpenGivt => 'Veeg omlaag om de Givt-app opnieuw te openen.';

  @override
  String get moreInfo => 'Meer info';

  @override
  String get germany => 'Duitsland';

  @override
  String get extraBluetoothText => 'Lijkt je Bluetooth al aan te staan? Dan is het toch even nodig om Bluetooth uit en opnieuw aan te zetten.';

  @override
  String get openMailbox => 'Open mailbox';

  @override
  String get personalInfo => 'Persoonlijke gegevens';

  @override
  String get cameraPermission => 'We hebben toegang tot je camera nodig om een qr-code te kunnen scannen.';

  @override
  String get downloadYearOverview => 'Wil je het giftenoverzicht van 2017 voor je belastingaangifte downloaden?';

  @override
  String get sendOverViewTo => 'We sturen het overzicht naar';

  @override
  String get yearOverviewAvailable => 'Jaaroverzicht beschikbaar';

  @override
  String get checkHereForYearOverview => 'Hier kun je je jaaroverzicht opvragen';

  @override
  String get couldNotSendTaxOverview => 'Het lukt nu even niet om je giftenoverzicht op te vragen, probeer het later even opnieuw. Contacteer support@givtapp.net als dit probleem blijft optreden.';

  @override
  String get searchHere => 'Zoeken ...';

  @override
  String get noInternet => 'Oeps! Het lijkt erop dat je niet verbonden bent met internet. Probeer het nog eens wanneer je wel verbinding met internet hebt.';

  @override
  String get noInternetConnectionTitle => 'Geen internetverbinding';

  @override
  String get serverNotReachable => 'Het is nu helaas niet mogelijk om je registratie af te ronden, het lijkt aan onze server te liggen. Probeer je het later nog eens?\n Deze melding al vaker gekregen? Dan zijn we hier waarschijnlijk niet van op de hoogte. Help ons Givt verbeteren en laat een bericht achter, dan gaan we ermee aan de slag.';

  @override
  String get sendMessage => 'Bericht sturen';

  @override
  String get answerWhyAreMyDataStored => 'Lees hieronder welke gegevens we waarvoor nodig hebben:\n \n\n Adresgegevens: We hebben je adresgegevens nodig om het mandaat aan te kunnen maken, zonder deze gegevens is het mandaat niet geldig en kun je je registratie niet afronden. Welke gegevens hiervoor nodig zijn, is wettelijk bepaald.\n \n\n Mobiele nummer: We gebruiken je mobiele nummer enkel voor support doeleinden.\n \n\n Betalingsgegevens: Je betalingsgegevens hebben we nodig om je gedane gift af te kunnen schrijven.\n \n\n E-mailadres: We gebruiken je e-mailadres om je Givt-account aan te maken. Je logt in met je e-mailadres en je wachtwoord. Ook sturen we je af en toe een update maar hier kun je je ook altijd weer voor uitschrijven.\n Hierover kun je meer lezen in onze privacyverklaring die je vindt onderaan deze faq.';

  @override
  String get logoffSession => 'Uitloggen';

  @override
  String get alreadyAnAccount => 'Heb je al een account?';

  @override
  String get unitedKingdom => 'Verenigd Koninkrijk';

  @override
  String get cancelShort => 'Annuleer';

  @override
  String get cantCancelGiftAfter15Minutes => 'Helaas, deze gift kan je niet meer annuleren vanuit de Givt-app.';

  @override
  String get unknownErrorCancelGivt => 'Door een onbekende fout kunnen we je gift niet annuleren. Neem contact op met ons op support@givtapp.net voor meer informatie.';

  @override
  String transactionCancelled(Object value0) {
    return 'De gift naar $value0 zal geannuleerd worden.';
  }

  @override
  String get cancelled => 'Geannuleerd';

  @override
  String get undo => 'Ongedaan maken';

  @override
  String get faqVraag16 => 'Kan ik mijn giften annuleren?';

  @override
  String get faqAntwoord16 => 'Je kan via het giftenoverzicht je gift annuleren door naar links te swipen (vegen). Als je de Gift niet meer kan verwijderen is deze al verwerkt. Let op: dit kan alleen als je je registratie in de Givt-app hebt voltooid.\n \n\n Je kunt je giften ook op een later moment herroepen. Er vinden geen overschrijvingen plaats tijdens het geven met Givt, dit gebeurt achteraf door middel van een automatische incasso. Alle automatische incasso’s zijn achteraf via je eigen bank te herroepen.';

  @override
  String get selectContextCollect => 'Geef in de kerk, aan de deur of op straat';

  @override
  String get giveContextQr => 'Geef door middel van een QR-code';

  @override
  String get selectContextList => 'Kies een doel uit de lijst';

  @override
  String get selectContext => 'Kies hoe je wilt geven';

  @override
  String get chooseWhoYouWantToGiveTo => 'Kies aan wie je wil geven';

  @override
  String get cancelGiftAlertTitle => 'Gift annuleren?';

  @override
  String get cancelGiftAlertMessage => 'Weet je zeker dat je deze gift wil annuleren?';

  @override
  String get gotIt => 'Ik snap het';

  @override
  String get cancelFeatureTitle => 'Je kunt een gift annuleren door naar links te vegen';

  @override
  String get cancelFeatureMessage => 'Tik op het scherm om dit bericht te verbergen';

  @override
  String get giveSubtitle => 'Je kunt op verschillende manieren ‘Givten’. Hier kun je kiezen wat op dit moment het best bij jou past.';

  @override
  String get confirm => 'Bevestig';

  @override
  String safariGivingToOrganisation(Object value0) {
    return 'Je hebt nu gegeven aan $value0. Hieronder vind je het overzicht van je gift.';
  }

  @override
  String get safariGiving => 'Je hebt nu gegeven. Hieronder vind je het overzicht van je gift.';

  @override
  String get giveSituationShowcaseTitle => 'Kies in het volgende scherm hoe je wil geven';

  @override
  String get soonMessage => 'Binnenkort...';

  @override
  String get giveWithYourPhone => 'Beweeg je telefoon';

  @override
  String get celebrateTitle => 'Nog eventjes wachten...';

  @override
  String get celebrateMessage => 'Zwier je smartphone in de lucht voor de aftelklok op 0 staat. \n Wat er dan gebeurt? Dat merk je vanzelf...';

  @override
  String get afterCelebrationTitle => 'Zwaaien maar!';

  @override
  String get afterCelebrationMessage => 'Het is zover, zwaai er op los! \n (We zijn niet verantwoordelijk voor eventuele elleboogstoten.)';

  @override
  String get errorContactGivt => 'Er is een fout opgetreden, gelieve contact op te nemen met support@givtapp.net .';

  @override
  String get mandateFailPersonalInformation => 'Er lijkt iets mis te zijn met je ingevulde gegevens. Controleer je even in het menu, onder \'Mijn gegevens\'? Daar kun je je gegevens ook aanpassen.';

  @override
  String mandateSmsCode(Object value0, Object value1) {
    return 'We sturen een sms-code naar $value0. Het mandaat wordt aangevraagd op naam van $value1. Correct? Ga dan gerust verder.';
  }

  @override
  String get mandateSigningCode => 'Als het goed is, krijg je zometeen een code. Vul die hieronder in om de machtiging te ondertekenen.';

  @override
  String get readCode => 'Jouw code:';

  @override
  String get readMandate => 'Bekijk mandaat';

  @override
  String get mandatePdfFileName => 'mandaat';

  @override
  String get writeStoragePermission => 'Om deze PDF te kunnen bekijken, hebben we even toegang tot de opslag van je telefoon nodig zodat we de PDF kunnen opslaan en laten zien.';

  @override
  String get legalTextSlimPay => 'Door verder te gaan, zal u een machtiging ondertekenen voor het mandaat van Givt B.V om uw account te debiteren. U moet de accounthouder zijn of gemachtigd zijn om namens de accounthouder te handelen.\n \n\n Uw persoonlijke gegevens worden verwerkt door SlimPay, een gelicentieerde betalingsinstelling, om de betalingstransactie uit te voeren namens Givt B.V., en om fraude te voorkomen volgens Europese regelgeving.';

  @override
  String get resendCode => 'Verstuur de code opnieuw';

  @override
  String get wrongCodeMandateSigning => 'De code lijkt niet juist te zijn. Probeer het opnieuw of vraag een nieuwe code aan.';

  @override
  String get back => 'Terug';

  @override
  String get amountLowest => 'Twee Euro Vijftig';

  @override
  String get amountMiddle => 'Zeven Euro Vijftig';

  @override
  String get amountHighest => 'Twaalf Euro Vijftig';

  @override
  String get divider => 'Komma';

  @override
  String givtEventText(Object value0) {
    return 'Hey! Je bent op een locatie waar Givt wordt ondersteund. Wil jij toevallig geven aan $value0?';
  }

  @override
  String get searchingEventText => 'We zoeken even waar je bent, wacht je even?';

  @override
  String get weDoNotFindYou => 'Jammer genoeg kunnen we je niet terugvinden. Je kan kiezen om te selecteren uit een lijst of teruggaan om nog eens opnieuw te proberen.';

  @override
  String get selectLocationContext => 'Geef op locatie';

  @override
  String get changePassword => 'Wachtwoord wijzigen';

  @override
  String get allowGivtLocationTitle => 'Sta Givt toe je locatie te gebruiken';

  @override
  String get allowGivtLocationMessage => 'We hebben je locatie nodig om te bepalen aan wie je wilt geven.\n Ga naar Instellingen > Privacy > Locatievoorzieningen > Zet Locatievoorzieningen aan en stel \'Bij gebruik van app\' in voor Givt.';

  @override
  String get faqVraag10 => 'Hoe verander ik mijn wachtwoord?';

  @override
  String get faqAntwoord10 => 'Wanneer je je wachtwoord wilt wijzigen, kun je binnen het menu van de app kiezen voor ‘Mijn gegevens’. Onderaan kies je voor ‘Wachtwoord wijzigen’, wij sturen vervolgens naar jouw geregistreerde e-mailadres een e-mail met een link waarmee je jouw wachtwoord kunt wijzigen.';

  @override
  String get editPersonalSucces => 'Je persoonlijke gegevens zijn succesvol aangepast';

  @override
  String get editPersonalFail => 'Oops, we konden je persoonlijke gegevens niet aanpassen';

  @override
  String get changeEmail => 'E-mailadres wijzigen';

  @override
  String get changeIban => 'IBAN wijzigen';

  @override
  String get smsSuccess => 'Code verstuurd via SMS';

  @override
  String get smsFailed => 'Probeer later opnieuw';

  @override
  String get kerkdienstGemistQuestion => 'Hoe kan ik geven met Givt via 3de-partijen?';

  @override
  String get kerkdienstGemistAnswer => 'Wanneer je via de Kerkdienst Gemist-app naar een kerkdienst aan het kijken bent, kun je ook meteen geven met Givt. Onderaan de pagina vind je een Givt-knop die je doorstuurt naar de Givt-app. Kies een bedrag, en klaar!';

  @override
  String externalSuggestionLabel(Object value0, Object value1) {
    return 'We zien dat je geeft vanuit $value0. Wil je geven aan $value1?';
  }

  @override
  String get chooseHowIGive => 'Nee, ik wil zelf kiezen hoe ik geef';

  @override
  String get andersGeven => 'Anders geven';

  @override
  String get kerkdienstGemist => 'Kerkdienst Gemist';

  @override
  String get changePhone => 'Mobiel nummer wijzigen';

  @override
  String get artists => 'Artiesten';

  @override
  String get changeAddress => 'Adres wijzigen';

  @override
  String get selectLocationContextLong => 'Geef op locatie';

  @override
  String get givtAtLocationDisabledTitle => 'Geen locaties beschikbaar';

  @override
  String get givtAtLocationDisabledMessage => 'Hé, niet te snel! Op dit moment zijn er geen organisaties waar je op locatie kan geven.';

  @override
  String get tempAccountLogin => 'Je gebruikt een tijdelijk account zonder wachtwoord. Je wordt nu ingelogd en daarna gelijk gevraagd om je registratie af te ronden.';

  @override
  String get sortCodePlaceholder => 'Sort code';

  @override
  String get bankAccountNumberPlaceholder => 'Bank account number';

  @override
  String get bacsSetupTitle => 'Instellen van incasso-instructie';

  @override
  String get bacsSetupBody => 'Je tekent een machtiging voor incidentele afschrijvingen. We incasseren alleen bedragen die je geeft met de Givt-app.\n \n\n Door verder te gaan, gaat u ermee akkoord dat u de accounthouder bent en dat u de enige persoon bent die inningen voor dit account kan autoriseren.\n \n\n De details van uw incasso-instructie machtiging worden u binnen 3 werkdagen of uiterlijk 10 werkdagen vóór de eerste collecte per e-mail toegestuurd.';

  @override
  String get bacsUnderstoodNotice => 'Ik heb de voorinlichting gelezen en goedgekeurd';

  @override
  String get bacsVerifyTitle => 'Controleer je gegevens';

  @override
  String get bacsVerifyBody => 'Zijn deze gegevens correct? Zo niet, annuleer de registratie en verander je persoonlijke gegevens.\n \n\n De bedrijfsnaam die op je transactie zal te zien zijn is \'Givt Ltd.\'.';

  @override
  String get bacsReadDdGuarantee => 'Lees de incasso garantie';

  @override
  String get bacsDdGuarantee => '- The Guarantee is offered by all banks and building societies that accept instructions to pay Direct Debits.\n - If there are any changes to the way this ad hoc Direct Debit Instruction is used, the organisation will notify you (normally 10 working days) in advance of your account being debited or as otherwise agreed. \n - If an error is made in the payment of your Direct Debit, by the organisation, or your bank or building society, you are entitled to a full and immediate refund of the amount paid from your bank or building society.\n - If you receive a refund you are not entitled to, you must pay it back when the organisation asks you to.\n - You can cancel a Direct Debit at any time by simply contacting your bank or building society. Written confirmation may be required. Please also notify the organisation.';

  @override
  String get bacsAdvanceNotice => 'You are signing an ad hoc, non-recurring Direct Debit Instruction mandate. Only on your specific request will debits be executed by the organisation. All the normal Direct Debit safeguards and guarantees apply. No changes in the use of this Direct Debit Instruction can be made without notifying you at least five (5) working days in advance of your account being debited.\n In the event of any error, you are entitled to an immediate refund from your bank or building society. \n You have the right to cancel a Direct Debit Instruction at any time by writing to your bank or building society, with a copy to us.';

  @override
  String get bacsAdvanceNoticeTitle => 'Voorinlichting';

  @override
  String get bacsDdGuaranteeTitle => 'Automatische incasso garantie';

  @override
  String bacsVerifyBodyDetails(Object value0, Object value1, Object value2, Object value3, Object value4) {
    return 'Naam: $value0\n Adres: $value1\n Email adres: $value2\n Sortcode: $value3 \n Account nummer: $value4\n Frequentie type: Incidenteel, wanneer je de Givt-app gebruikt om te geven';
  }

  @override
  String get bacsHelpTitle => 'Hulp nodig?';

  @override
  String get bacsHelpBody => 'Kan je iets niet vinden of heb je gewoon een vraag? Aarzel dan niet om ons te contacteren op het nummer: +31 320 320 115 of stuur ons een mailtje naar support@givtapp.net en we nemen spoedig contact met je op!';

  @override
  String bacsSortcodeAccountnumber(Object value0, Object value1) {
    return 'Sortcode: $value0\n Account nummer: $value1';
  }

  @override
  String get cantFetchPersonalInformation => 'We kunnen op dit moment je gegevens niet opvragen van de server, probeer je het later even opnieuw?';

  @override
  String get givingContextCollectionBag => 'Collectemiddel';

  @override
  String get givingContextQrCode => 'QR-code';

  @override
  String get givingContextLocation => 'Locatie';

  @override
  String get givingContextCollectionBagList => 'Lijst';

  @override
  String get amountPresetsTitle => 'Voorkeursbedragen';

  @override
  String get amountPresetsBody => 'Stel hieronder je voorkeursbedragen in.';

  @override
  String get amountPresetsResetAll => 'Herstel waarden';

  @override
  String get amountPresetsErrGivingLimit => 'Het bedrag is hoger dan je geeflimiet';

  @override
  String amountPresetsErr25C(Object value0) {
    return 'Het bedrag moet minstens $value0 zijn';
  }

  @override
  String get amountPresetsErrEmpty => 'Vul een bedrag in';

  @override
  String alertBacsMessage(Object value0) {
    return 'Doordat je $value0 als landkeuze hebt aangegeven, gaan we ervan uit dat je het liefst wil geven d.m.v. een SEPA-machtiging (€), daar hebben wij je IBAN voor nodig. Wil je toch liever BACS (£) gebruiken, dan hebben we je Sort Code en Account Number nodig.';
  }

  @override
  String alertSepaMessage(Object value0) {
    return 'Doordat je $value0 als landkeuze hebt aangegeven, gaan we ervan uit dat je het liefst wil geven d.m.v. BACS Direct Debit (£), daar hebben wij je Sort Code en Account Number voor nodig. Wil je toch liever SEPA (€) gebruiken, dan hebben we je IBAN nodig.';
  }

  @override
  String get important => 'Belangrijk';

  @override
  String get fingerprintTitle => 'Vingerafdruk';

  @override
  String get touchId => 'Touch ID';

  @override
  String get faceId => 'Face ID';

  @override
  String get touchIdUsage => 'Hier beheer je het gebruik van je Touch ID om in de Givt-app in te loggen.';

  @override
  String get faceIdUsage => 'Hier beheer je het gebruik van je Face ID om in de Givt-app in te loggen.';

  @override
  String get fingerprintUsage => 'Hier beheer je het gebruik van je vingerafdruk om in de Givt-app in te loggen.';

  @override
  String get authenticationIssueTitle => 'Authenticatieprobleem';

  @override
  String get authenticationIssueMessage => 'We konden je niet goed identificeren. Probeer je het later even opnieuw?';

  @override
  String get authenticationIssueFallbackMessage => 'We konden je niet goed identificeren. Log in met je toegangscode of wachtwoord.';

  @override
  String get cancelledAuthorizationMessage => 'Je hebt de authenticatie geannuleerd. Wil je toch liever inloggen met je toegangscode/wachtwoord?';

  @override
  String get offlineGiftsTitle => 'Offline giften';

  @override
  String get offlineGiftsMessage => 'Om ervoor te zorgen dat je giften op tijd aankomen, is het even nodig om je internetverbinding aan te zetten zodat de giften die je hebt gedaan, verstuurd kunnen worden naar de server.';

  @override
  String get enrollFingerprint => 'Plaats nu je vinger op de vingerafdruk-sensor.';

  @override
  String fingerprintMessageAlert(Object value0, Object value1) {
    return 'Gebruik $value0 om in te loggen voor $value1';
  }

  @override
  String get loginFingerprint => 'Login met je vingerafdruk';

  @override
  String get loginFingerprintCancel => 'Inloggen met toegangscode/wachtwoord';

  @override
  String get fingerprintStateScanning => 'Raak de sensor aan';

  @override
  String get fingerprintStateSuccess => 'Vingerafdruk herkend';

  @override
  String get fingerprintStateFailure => 'Vingeradruk niet herkend.\n Probeer opnieuw.';

  @override
  String get activateBluetooth => 'Bluetooth activeren';

  @override
  String get amountTooHigh => 'Bedrag te hoog';

  @override
  String get activateLocation => 'Locatie activeren';

  @override
  String get loginFailure => 'Fout bij inloggen';

  @override
  String get requestFailed => 'Aanvraag mislukt';

  @override
  String get resetPasswordSent => 'Je krijgt een e-mail met daarin een link om je wachtwoord opnieuw in te stellen. Heb je na 5 minuten nog steeds de e-mail niet ontvangen? Kijk dan even in je spam.';

  @override
  String get success => 'Gelukt!';

  @override
  String get notSoFast => 'Niet zo snel, gulle gever';

  @override
  String get giftBetween30Sec => 'Je hebt al eens binnen de 30 seconden gegeven. Wacht je nog even?';

  @override
  String get android8ActivateLocation => 'Activeer je locatie en zorg ervoor dat de modus op ‘Hoge nauwkeurigheid’ staat. (Na je gift kan je die gewoon weer uitzetten.)';

  @override
  String get android9ActivateLocation => 'Activeer je locatie en zorg ervoor dat de ‘Locatienauwkeurigheid’ actief is.';

  @override
  String get nonExistingEmail => 'Dit e-mailadres komt ons niet bekend voor. Is het mogelijk dat je een ander e-mailadres hebt opgegeven?';

  @override
  String get secondCollection => 'Tweede collecte';

  @override
  String get amountTooLow => 'Bedrag te laag';

  @override
  String get qrScanFailed => 'Mikken mislukt';

  @override
  String get temporaryAccount => 'Tijdelijk account';

  @override
  String get temporaryDisabled => 'Tijdelijk geblokkeerd';

  @override
  String get cancelFailed => 'Annuleren mislukt';

  @override
  String get accessDenied => 'Toegang geweigerd';

  @override
  String get unknownError => 'Onbekende fout';

  @override
  String get mandateFailed => 'Machtiging mislukt';

  @override
  String qrScannedOutOfApp(Object value0) {
    return 'Hey! Wat leuk dat je wil geven met een QR-code! Klopt het dat je wil geven aan $value0?';
  }

  @override
  String get saveFailed => 'Opslaan mislukt';

  @override
  String get invalidEmail => 'Ongeldig e-mailadres';

  @override
  String get giftsOverviewSent => 'We hebben je giftenoverzicht verstuurd naar je mailbox.';

  @override
  String get giftWasBetween30S => 'Je gift is niet doorgezet omdat het minder dan 30 sec. geleden is sinds je vorige gift.';

  @override
  String get promotionalQr => 'Deze code verwijst naar onze webpagina. Hiermee kan je helaas niet geven in de Givt-app.';

  @override
  String get promotionalQrTitle => 'Promo QR-code';

  @override
  String get downloadYearOverviewByChoice => 'Wil je een giftenoverzicht van een volledig jaar downloaden voor je belastingaangifte ? Kies hieronder het jaar en we versturen het overzicht naar';

  @override
  String giveOutOfApp(Object value0) {
    return 'He! Leuk dat je wil geven met Givt! Klopt het dat je wil geven aan $value0?';
  }

  @override
  String get mandateFailTryAgainLater => 'Er gaat iets mis bij het aanmaken van de machtiging. Probeer je later nog eens opnieuw?';

  @override
  String get featureButtonSkip => 'Sla over';

  @override
  String get featureMenuText => 'De app van A tot Z';

  @override
  String get featureMultipleNew => 'Hallo, we willen je graag enkele nieuwe features voorstellen.';

  @override
  String get featureReadMore => 'Lees meer';

  @override
  String featureStepTitle(Object value0, Object value1) {
    return 'Feature $value0 van $value1';
  }

  @override
  String get noticeSmsCode => 'Let op!\n De sms-code die je zult ontvangen, moet je invullen op het SlimPay scherm in je webpagina, dus niet in de app. Na het tekenen van de machtiging, ga je automatisch terug naar de Givt-app.';

  @override
  String get featurePush1Title => 'Pushnotificaties';

  @override
  String get featurePush2Title => 'We helpen je erdoorheen';

  @override
  String get featurePush3Title => 'Zorg dat ze aan staan';

  @override
  String get featurePush1Message => 'Een pushnotificatie geeft ons de mogelijkheid om jou iets belangrijks te vertellen terwijl de app op de achtergrond is.';

  @override
  String get featurePush2Message => 'Mocht er iets niet kloppen met je account of misgaan met je giften, kunnen we dat makkelijk en snel communiceren.';

  @override
  String get featurePush3Message => 'En laat ze gerust aan staan. We communiceren alleen zaken die dringend zijn.';

  @override
  String get featurePushInappnot => 'Tap hier om meer te weten te komen over pushnotificaties';

  @override
  String get featurePushNotenabledAction => 'Inschakelen';

  @override
  String get featurePushEnabledAction => 'Ik begrijp het';

  @override
  String get termsTextGb => 'GIVT LTD \n \n\n Terms of use – Givt app \n Last updated: 12-04-2019\n Version: 1.3\n \n\n 1.  General \n These terms of use describe the conditions under which the mobile application Givt (\"Givt\") can be utilized. Givt allows the User (anonymously) to give donations through his/her smartphone, for example churches, funds or charities that are members of Givt Ltd. Givt Limited is registered as a Small Payment Institution with the Financial Conduct Authority (FRN: 11396586).\n \n\n These terms of use apply to the use of Givt. Through the use of Givt (which means the download and the installation thereof), you (\"User\") accept these terms of use and our privacy policy (https://www.givtapp.net/en/terms-of-use-givt-app/). These terms of use and our privacy policy are also available on our website to download and print. We may revise these terms of use from time to time. \n \n\n 2.  License and intellectual property rights \n \n\n 2.1 All rights to Givt, the accompanying documentation and all modifications and extensions thereto as well as the enforcement thereof are and remain vested in Givt. User is granted solely the user rights and authorities and/or permissions ensuing from the effect of this agreement or which are assigned in writing, and you may not otherwise use, reproduce or publicly release Givt. \n \n\n 2.2 Givt grants the User a non-exclusive, non-sublicensable and non-transmittable license to use Givt. The User is not allowed to use Givt for commercial purposes. \n \n\n 2.3  The User may not provide Givt to third parties nor sell, rent, decompile, submit to reverse engineer or modify it without prior permission from Givt. Nor should the User, or let others, remove or bypass the technical provisions that are intended to protect Givt. \n \n\n 2.4  Givt has the right to adjust Givt at all times, modify or remove data, to deny the User the use of Givt by termination of the license, limitation of the use of Givt or deny access to Givt in whole or in part, temporarily or permanently. Givt will inform the User about this in an appropriate manner. \n \n\n 2.5  The User acquires no right, title or interest to the intellectual property rights and/or similar rights to (the means of) Givt, including the underlying software and content.\n \n\n 3.  The use of Givt \n \n\n 3.1  The User can only give donations to churches, charities, funds and/or other legal entities that are affiliated with Givt and have a relation with Givt.The donations are done anonymously. \n \n\n 3.2  The use of Givt is at your own risk and expense and should be used in accordance with the purposes for which it is intended. It is prohibited to reverse engineer the source code of Givt or to decompile and/or modify Givt, to make a copy of Givt available to any third party or to remove, delete or render illegible any designations of Givt as the party holding rights to Givt or parts thereof.\n \n\n 3.3 The User is responsible for the correct delivery of data such as name and address details, bank account number and other information as requested by Givt to ensure the use of Givt. \n \n\n 3.4 If the User is under the age of 18 he/she shall have the consent of his/her parent or legal guardian for the use of Givt. By accepting these terms of use, the User guarantees that he/she is 18 years of age or has the permission of his/her parents or legal representative. \n \n\n 3.5  Givt is available for the operating systems Android and iOS. In addition to the provisions set out below, Apple’s App Store or Google Play may attach conditions to the acquisition of Givt, its use and related matters. For further information, see the terms of use and privacy policy of Apple’s App Store and Google Play as well as any other applicable terms and conditions appearing on the website of the respective provider. This end user licence is applicable to the agreement between User and Givt and does not apply between User and the provider of the platform through which you acquired Givt. That provider may hold you liable for violation of provisions in this end user licence, however.\n \n\n 3.6 After the User has downloaded Givt, the User is requested to register. In doing so, the User must provide the following information: (i) name (ii) address, (iii) phone number, (iv) bank account number, and (iii) e-mail address. The privacy policy of Givt is applied to the processing of personal data via Givt. The User must immediately adjust the changes of data in Givt at the moment these changes occur.  \n \n\n 3.7 The User may, after installing the Givt app, also choose to only enter an e-mail address and immediately use the app to donate. After the donation, the User will be asked to complete the registration procedure. If the User wishes to do so later, Givt ensures to only use the User\'s e-mail address to remind the User to finish the registration procedure until this procedure is finalized.\n \n\n 3.8  The User takes on own expenses to have the necessary equipment, software system and (internet) connection to make use of Givt. \n \n\n 3.9  Givt provides the related services based on the information the User submits. The User is obliged to provide correct and complete information, which is not false or misleading. The User may not provide data with respect to names or bank accounts for which the User is not authorized to use. Givt and the Processor have the right to validate and verify the information the User has provided. \n \n\n 3.10  The User may at any time terminate the use of Givt, by deleting his account via the menu in the app or via mail to support@givtapp.net. Deleting the app from the smartphone without following aforementioned steps will not result in deletion of the User’s data. Givt can terminate the relationship with the User if the User does not comply with these terms and conditions or if Givt has not been used for 18 consecutive months. On request Givt can send a listing of all donation data. \n \n\n 3.11  Givt does not charge fees for the use of Givt. \n \n\n 3.12 Givt has the right to adjust the offered functionalities from time to time to improve, to change or to fix errors. Givt will always work to fix errors within the Givt software, but cannot guarantee that all errors, whether or not in a timely fashion, be restored. \n \n\n 4.  Processing transactions and Protecting your money\n \n\n 4.1  Givt does not provide banking or payment services. To facilitate the processing of donations from the User, Givt has entered into an agreement with ipagoo llp, an Electronic Money Institution, authorised and regulated by the Financial Conduct Authority (FRN 900122) (“ipagoo”)(the \"Processor\"). Givt will, after the collection of donations, ensure the payment of donations to the user-designated beneficiary. The transaction data will be processed and forwarded to the Givt Processor. The Processor will initiate payment transactions whereas Givt is responsible for the transaction of the relevant amounts to the bank account of the Church/Charity as being the user-designated beneficiary of the donation.\n \n\n 4.2  The User agrees that Givt may pass the User’s (transaction and bank) data to the Processor, along with all other necessary account and personal information of the User, in order to enable the Processor to initiate the payment transactions and processing. Givt reserves the right to change of Processor at any time. The User agrees that Givt may forward the relevant information and data about the User as defined in article 4.2 to the new Processor to be able to continue processing payment transactions. \n \n\n 4.3  Givt and the Processor will process data of the User in accordance with the law and regulations that applies to data protection. For further information on how personal data are collected, processed and used, Givt refers the User to its privacy policy. These can be found at: (www.givtapp.net/en/privacystatementgivt-service/).\n \n\n 4.4  The donations of the User will pass through Givt as intermediary. Givt will ensure that the funds will be transferred to the beneficiary, with whom Givt has an agreement. \n \n\n 4.5  The User can at all times, within the terms of the User\'s bank, and the direct debit scheme, revert a debit. \n \n\n 4.6  Givt and/or the Processor can refuse a donation if there are reasonable grounds to believe that a user is acting in violation of these terms or if there are reasonable grounds to believe that a donation is possibly suspicious or illegal. In this case Givt will inform the User as soon as possible, unless prohibited by law. \n \n\n 4.7  Donations with Givt are subject to the following limits: GBP 1000 per donation and GBP 25000 per calendar year.\n \n\n 4.8  The User agrees that Givt (transaction) may pass data of the User to the local tax authorities, along with all other necessary account and personal information of the User, in order to assist the User with his/her annual tax return. \n \n\n 4.9 We will hold your money in a Payment Account, provided by ipagoo. The Payment Account is designated as a “Client Funds Account” and segregated from our own assets. The money contained in the Client Funds Account cannot be used by Givt, invested or lent to third parties, or in any way form part of Givt’s assets.\n \n\n 4.10 Current Regulatory Provisions exclude money placed on a Payment Account from the UK Financial Services Compensation Scheme (FSCS).\n \n\n 4.11 Money placed or held in the Client Funds Account shall not constitute a deposit (within the meaning of Article 5 of Directive 2006/48/EC) and does not earn interest.\n 4.12 Deposits and, in particular, withdrawals from the Client Funds Account will only be made in the following circumstances:\n \n\n In the case of deposits:\n \n\n ● To receive money intended for onward payment to the designated charity/charities or church(es)\n ● To replenish the account where fees or other costs associated with running the account have been deducted\n ● To receive refunds in the event that prior instruction to make a payment by you is cancelled, in accordance with these Terms and Conditions\n \n\n In the case of withdrawals:\n \n\n ● To pay designated charities and churches, in accordance with your instructions\n ● To pay fees or other costs associated with running the account\n ● To return money to you, in the event that prior instruction to make a payment by you is cancelled, in accordance with these Terms and Conditions.\n \n\n 5.  Security, theft and loss \n \n\n 5.1  The User shall take all reasonable precautions safekeeping his/her login credentials of Givt to avoid loss, theft, misappropriation or unauthorized use of Givt on his/her smartphone.\n \n\n 5.2  The User is responsible for the security of his/her smartphone. Givt considers any donation from the Givt account as a user-approved transaction, regardless of the rights of the User under article 4.5.\n \n\n 5.3  The User shall inform Givt immediately via info@givtapp.net or 0320-320115 once his/her smartphone is lost or stolen. Upon receipt of a message Givt will block the account to prevent (further) misuse. \n \n\n 6. Updates\n \n\n 6.1 Givt releases updates from time to time, which can rectify errors or improve the functioning of Givt. Available updates for Givt will be announced by means of notification through Apple’s App Store and Google Play and it is User’s sole responsibility to monitor these notifications and keep informed about new updates.\n \n\n 6.2 An update can stipulate conditions, which differ from the provisions in this agreement. This will always be notified to User in advance so that User has the opportunity to refuse the update. By installing such an update, User agrees to these deviating conditions, which will then form part of this agreement. If User does not agree to the changed conditions, he/she has to cease using Givt and has to delete Givt from his/her smartphone or tablet.\n \n\n 7.  Liability \n \n\n 7.1  Givt has been compiled with the utmost care. Although Givt strives to make Givt available 24 hours a day, it accepts no liability if, for any reason, Givt is not available at any given time or for a certain period of time. Givt reserves the right to temporarily or permanently discontinue Givt (unannounced). The User cannot derive any rights from this. \n \n\n 7.2  Givt is not liable for damage or injury resulting from the use of Givt. The limitations of liability as mentioned in this article shall lapse if the liability for damage is the result of intent or gross negligence on the part of Givt.\n \n\n 7.3  The User safeguards Givt for all possible claims from third parties (for example, beneficiaries of the donations or the tax authority) as a result of the use of the Givt or not correctly meeting the agreements made concerning legal or contractual obligations with Givt. The User will pay all damages and costs to Givt as a result of such claims.\n \n\n 8.  Other provisions \n \n\n 8.1  This agreement comes into effect on commencement of the use of Givt and will remain in force for an undetermined period from that moment. This agreement may be terminated by User as well as by Givt at any moment, subject to one month’s notice. This agreement will end by operation of law in the event you are declared bankrupt, you apply for a moratorium on payments or a general attachment is levied against your assets, in the event of your death, or in the event you go into liquidation, are wound up or dissolved. Following the termination of this agreement (for whatever reason), you shall cease and desist from all further use of Givt. You must then delete all copies (including back-up copies) of Givt from all your systems.\n \n\n 8.2 If any provision of these terms and conditions is void or destroyed, this will not affect the validity of the agreement as a whole, and other provisions of these terms remain in force. In that case, the parties will decide on a new replacement provision or provisions which will be in line with the intention of the original agreement as far as is legally possible.\n \n\n 8.3  The User is not allowed to transfer the rights and/or obligations arising from the use of Givt and these terms to third parties without prior written permission of Givt. Conversely, Givt is allowed to do so. \n \n\n 8.4  We will endeavor to resolve the dispute amicably. Any disputes arising from or in connection with these terms and conditions are finally settled in the Courts of England and Wales. \n \n\n 8.5  The Law of England and Wales is applicable on these terms of use. \n \n\n 8.6  The terms of use shall not affect the User\'s statutory rights as a consumer.\n \n\n 8.7  Givt features an internal complaints procedure. Givt handles complaints efficiently and as soon as reasonably possible. Any complaint about the implementation of these conditions by Givt must be submitted in writing at Givt (via support@givtapp.net).';

  @override
  String get firstCollect => '1ste collecte';

  @override
  String get secondCollect => '2de collecte';

  @override
  String get thirdCollect => '3de collecte';

  @override
  String get addCollect => 'Collecte toevoegen';

  @override
  String get termsTextVersionGb => '1.3';

  @override
  String get accountDisabledError => 'Oeps, het lijkt erop dat je account is gedeactiveerd. Neem snel contact op met support@givtapp.net!';

  @override
  String get featureNewgui1Title => 'De gebruikersinterface';

  @override
  String get featureNewgui2Title => 'Voortgangsbalk';

  @override
  String get featureNewgui3Title => 'Meerdere collectes';

  @override
  String get featureNewgui1Message => 'Snel en makkelijk een bedrag intoetsen en collectes toevoegen of verwijderen in het eerste scherm.';

  @override
  String get featureNewgui2Message => 'Aan de hand van de voortgangsbalk bovenaan weet je precies waar je bent in het geefproces.';

  @override
  String get featureNewgui3Message => 'Collectes toevoegen of verwijderen met één druk op de knop.';

  @override
  String get featureNewguiAction => 'Oké, begrepen!';

  @override
  String get featureMultipleInappnot => 'Hallo! We hebben iets nieuws voor je klaar staan. Heb je even?';

  @override
  String get policyTextGb => 'Latest Amendment: 03-03-2021\n Version 1.9\n \n\n Givt Limited Privacy Policy  \n \n\n Introduction\n This Privacy Policy outlines Givt Limited’s (\" we \", \" our \" or \" the Company \") practices with respect to information collected from our Application (“App”) or from users that otherwise share personal information with us (collectively: \"Users\"). \n \n\n Grounds for data collection \n \n\n Processing of your personal information (meaning, any information which may potentially allow your identification with reasonable means; hereinafter \"Personal Information\") is necessary for the performance of our contractual obligations towards you and providing you with our services, to protect our legitimate interests and for compliance with legal and financial regulatory obligations to which we are subject.\n \n\n When you use our App or register yourself or an organisation you represent with us, you consent to the collection, storage, use, disclosure and other uses of your Personal Information as described in this Privacy Policy.\n \n\n We encourage our Users to carefully read the Privacy Policy and use it to make informed decisions. \n \n\n What information do we collect?\n \n\n We collect two types of data and information from Users. \n \n\n The first type of information is un-identified and non-identifiable information pertaining to a User(s), which may be made available or gathered via your use of the App (“ Non-personal Information ”). We are not aware of the identity of a User from which the Non-personal Information was collected. Non-personal Information which is being collected may include your aggregated usage information and technical information transmitted by your device, including certain software and hardware information (e.g. language preference, access time, etc.) in order to enhance the functionality of our App.\n \n\n The second type of information is Personal Information, which is personally identifiable information, namely information that identifies an individual or may with reasonable effort identify an individual. Such information includes:\n Device Information: We collect Personal Information from your device. Such information includes geolocation data, IP address, unique identifiers (e.g. MAC address and UUID) and other information which relates to your activity through the App.\n Service User Information: We collect additional information for individuals who would like to use our Services. This is gathered through the App and includes all the information needed for register for our service: \n Name and address, \n Date of birth, \n email address, \n secured password details, and \n bank details for the purposes of making payments.\n Contact information: If you choose to contact us you will be asked to provide us certain details such as: full name; e-mail or physical address, and other relevant information. This may be for yourself or for people in the organisation you represent.\n  \n How do we receive information about you?\n We receive your Personal Information from various sources:\n \n\n When you voluntarily provide us your personal details in order to register on our App;\n When you use or access our App in connection with your use of our services;\n From third party providers, services and public registers (for example, traffic analytics vendors).\n Through diagnostic information from the App. The App will send us anonymous information about its functioning. This information contains non-personal data from your smartphone like its type and operating system, but also the version information of the App. This data is solely used for purposes of improving our Service or allowing better responses to your questions. This information will never be shared with third-parties. \n What do we do with the information we collect?\n We do not rent, sell, or share Users’ information with third parties except as described in this Privacy Policy.\n \n\n We may use the information for the following:\n To provide the services through the App – we will use a minimum of name and bank details to perform the services of effecting payment(s) via the App. Such information is never shared with intended recipients of donations.;\n Communicating with you – sending you notices regarding our services, providing you with technical information and responding to any customer service issue you may have; to keep you informed of our latest updates and services;\n Conducting statistical and analytical activities, intended to improve the App and/or the App.\n \n\n In addition to the different uses listed above, we may transfer or disclose Personal Information to our subsidiaries, affiliated companies and subcontractors in relation to services that we provide to you.\n \n\n We may also disclose information if we have good faith to believe that disclosure of such information is helpful or reasonably necessary to: (i) comply with any applicable law, regulation, legal process or governmental request; (ii) enforce our policies (including our Agreement), including investigations of potential violations thereof; (iii) investigate, detect, prevent, or take action regarding illegal activities or other wrongdoing, suspected fraud or security issues; (iv) to establish or exercise our rights to defend against legal claims; (v) prevent harm to the rights, property or safety of us, our users, yourself or any third party; or (vi) for the purpose of collaborating with law enforcement agencies and/or in case we find it necessary in order to enforce intellectual property or other legal rights.\n \n\n User Rights\n You may request to: \n Receive confirmation as to whether or not personal information concerning you is being processed, and access your stored personal information, together with supplementary information. \n Receive a copy of personal information you directly volunteer to us in a structured, commonly used and machine-readable format. \n Request rectification of your personal information that is in our control.\n Request erasure of your personal information. \n Object to the processing of personal information by us. \n Request to restrict processing of your personal information by us.\n Lodge a complaint with a supervisory authority.\n \n\n However, please note that these rights are not absolute, and may be subject to our own legitimate interests and regulatory requirements. \n \n\n If you wish to exercise any of the aforementioned rights, or receive more information, please contact our Data Protection Officer (“DPO”) using the details provided below:\n \n\n Our Data Protection Compliance Officer is.\n \n\n If you have any questions about this Privacy Policy, please contact us:\n \n\n By email: support@givt.app\n By visiting this page on our Website: https://www.givtapp.net/en-gb/faq/\n By phone number: +44 20 3790 8068\n \n\n Retention\n We will retain your personal information for as long as necessary to provide our services, and as necessary to comply with our legal obligations, resolve disputes, and enforce our policies. Retention periods will be determined taking into account the type of information that is collected and the purpose for which it is collected, bearing in mind the requirements applicable to the situation and the need to destroy outdated, unused information at the earliest reasonable time. Under applicable regulations, we will keep records containing client personal data, account opening documents, communications and anything else as required by applicable laws and regulations. \n \n\n We may rectify, replenish or remove incomplete or inaccurate information, at any time and at our own discretion.\n \n\n Use of Location Services\n \n\n The App may use the location services as provided by the operating system on the smartphone. With these services, the App may determine the location of the user. The location data will not be sent anywhere outside the smartphone, and is solely used to determine whether the user is in a location where it’s possible to use the App for donating. The locations where one can use App are downloaded to the smartphone prior to using the location services.\n \n\n How do we safeguard your information?\n \n\n We take security measures to reduce misuse of and unauthorized access to personal data. We take the following measures in particular:\n \n\n Access to personal data requires the use of a username and password\n Access to personal data requires the use of a username and login token\n We make use of secure connections (Secure Sockets Layer of SSL) to encrypt all information between you and our website when entering your personal data.\n We keep logs of all requests for personal data.\n \n\n Although we take reasonable steps to safeguard information, we cannot be responsible for the acts of those who gain unauthorized access or abuse our App, and we make no warranty, express, implied or otherwise, that we will prevent such access.\n \n\n Transfer of data outside the EEA \n Please note that some data recipients may be located outside the EEA. In such cases we will transfer your data only to such countries as approved by the European Commission as providing adequate level of data protection, or enter into legal agreements ensuring an adequate level of data protection.\n \n\n Advertisements\n We do not use third-party advertising technology to serve advertisements when you access the App. \n \n\n Marketing\n We may use your Personal Information, such as your name, email address to send you a Newsletter about our products and services. You may opt out of receiving this Newsletter at any time by contacting our DPO.\n Providing Data to Third Parties\n We may provide your information to our partners. These partners are involved in the execution of the agreement. In all cases, these parties are necessary to provide the services. These are not the collecting authorities, as we protect the anonymity of users.\n You agree that the transaction data are anonymous and can be used for data collection, statistics, reviews and comparisons. Only the summary will be shared with other customers and we ensure you that none of your data will be traceable to individuals.\n \n\n We will also never sell data to third parties. We are only committed to make it easier for the donor to give to charities of their choosing.\n \n\n Updates or amendments to this Privacy Policy\n We reserve the right to periodically amend or revise the Privacy Policy; material changes will be effective immediately upon the display of the revised Privacy policy. The last revision will be reflected in the \"Last modified\" section. Your continued use of our Services following the notification of such amendments on our Website or through the App, constitutes your acknowledgment and consent of such amendments to the Privacy Policy and your agreement to be bound by the terms of such amendments.\n \n\n How to contact us\n \n\n If you have any general questions about the App or the information we collect about you and how we use it, you can contact us at: support@givt.app\n \n\n or\n \n\n By visiting this page on our Website: https://www.givtapp.net/en-gb/faq/\n By phone number: +44 20 3790 8068\n \n\n Givt Ltd. is a part of Givt B.V. Our office is located on the Bongerd 159 in Lelystad, the Netherlands.\n Company Number (CRN): 11396586';

  @override
  String get amount => 'Hoeveel wil je geven?';

  @override
  String get amountLimit => 'Bepaal hier het maximale bedrag \n dat je per keer wilt kunnen geven.';

  @override
  String get cancel => 'Annuleren';

  @override
  String get changePincode => 'Toegangscode wijzigen';

  @override
  String get checkInbox => 'Gelukt! Check je mailbox.';

  @override
  String get city => 'Woonplaats';

  @override
  String get contactFailed => 'Werkt het niet goed? \n Probeer opnieuw of selecteer \n de ontvanger handmatig.';

  @override
  String get country => 'Land';

  @override
  String get email => 'E-mailadres';

  @override
  String get errorTextRegister => 'Er gaat iets mis bij de registratie. Probeer het eens met een ander e-mailadres.';

  @override
  String get fieldsNotCorrect => 'Eén van de velden is nog \n niet helemaal correct ingevuld.';

  @override
  String get firstName => 'Voornaam';

  @override
  String get forgotPassword => 'Wachtwoord vergeten?';

  @override
  String get forgotPasswordText => 'Als je hier je e-mailadres invult, dan sturen wij een e-mail waarmee je een nieuw wachtwoord kunt aanmaken.\n \n\n Als je de e-mail niet meteen vindt, kijk dan even in je spam.';

  @override
  String get give => 'Geven';

  @override
  String get selectReceiverButton => 'Selecteer';

  @override
  String get giveLimit => 'Geeflimiet';

  @override
  String get givingSuccess => 'Bedankt voor je Givt!\n Kijk voor de status in je overzicht.';

  @override
  String get information => 'Gegevens';

  @override
  String get lastName => 'Achternaam';

  @override
  String get loggingIn => 'Je hoeft nu even niks\n te doen terwijl wij\n je gegevens ophalen.';

  @override
  String get login => 'Inloggen';

  @override
  String get loginPincode => 'Vul je toegangscode in.';

  @override
  String get loginText => 'Om toegang tot je account te krijgen, willen we graag zeker weten dat jij het bent.';

  @override
  String get logOut => 'Uitloggen';

  @override
  String get makeContact => 'Dit is het Givt-moment. \n Beweeg nu je telefoon langs de\n collectebus, -zak of -mand.';

  @override
  String get next => 'Volgende';

  @override
  String get noThanks => 'Nee, bedankt';

  @override
  String get notifications => 'Notificaties';

  @override
  String get password => 'Wachtwoord';

  @override
  String get passwordRule => 'Het wachtwoord moet uit ten minste 7 tekens bestaan, waaronder een hoofdletter en een cijfer.';

  @override
  String get phoneNumber => 'Mobiel nummer';

  @override
  String get postalCode => 'Postcode';

  @override
  String get ready => 'Klaar';

  @override
  String get register => 'Registreren';

  @override
  String get registerBusy => 'We hebben even \n een momentje nodig \n om je registratie te verwerken.';

  @override
  String get registerPage => 'Maak een account aan zodat je altijd toegang tot je Givt-gegevens hebt.';

  @override
  String get registerPersonalPage => 'Om je giften te kunnen afhandelen,\n moeten we nog een paar dingen van je weten.';

  @override
  String get registerPincode => 'Vul je toegangscode in.';

  @override
  String get registrationSuccess => 'Je registratie is gelukt. \n Veel geefplezier!';

  @override
  String get security => 'Beveiliging';

  @override
  String get send => 'Verstuur';

  @override
  String get settings => 'Instellingen';

  @override
  String get somethingWentWrong => 'Oeps, er gaat iets mis.';

  @override
  String get streetAndHouseNumber => 'Straat en huisnummer';

  @override
  String get tryAgain => 'Opnieuw proberen';

  @override
  String get welcome => 'Welkom bij Givt.';

  @override
  String get wrongCredentials => 'Dit e-mailadres of wachtwoord komt ons niet bekend voor. Is het mogelijk dat je een ander e-mailadres en/of wachtwoord hebt opgegeven?';

  @override
  String get yesPlease => 'Ja, graag';

  @override
  String get bluetoothErrorMessage => 'Activeer Bluetooth om gewoon aan de collecte te blijven geven.';

  @override
  String get connectionError => 'Ai! Geen verbinding met de server, maar het komt goed. Drink rustig een kopje thee en controleer voor de zekerheid je instellingen.';

  @override
  String get save => 'Opslaan';

  @override
  String get acceptPolicy => 'Prima, mijn gegevens mogen \n door Givt worden vastgelegd.';

  @override
  String get close => 'Sluiten';

  @override
  String get sendViaEmail => 'Verstuur via e-mail';

  @override
  String get termsTitle => 'Onze algemene voorwaarden';

  @override
  String get shortSummaryTitleTerms => 'Hier gaat het om:';

  @override
  String get fullVersionTitleTerms => 'Algemene Voorwaarden';

  @override
  String get termsText => 'Gebruiksvoorwaarden – Givt-app\n\nLaatst bijgewerkt: 24-11-2023\n\nVersie: 1.10\n\n\n\n1. Algemeen\n\nDeze gebruiksvoorwaarden beschrijven de voorwaarden waaronder gebruik kan worden gemaakt van de mobiele applicatie Givt (“Givt”). Givt stelt de Gebruiker in staat om (anoniem) donaties te geven via zijn/haar smartphone aan bijvoorbeeld kerken, fondsen of stichtingen die zijn aangesloten bij Givt.  Givt wordt beheerd door Givt B.V., een besloten vennootschap, gevestigd te Lelystad (8243 PR), aan de Noordersluisweg 27, ingeschreven in het handelsregister van de Kamer van Koophandel onder nummer 64534421 (“Givt B.V.”). Deze gebruiksvoorwaarden zijn van toepassing op het gebruik van Givt. Door het gebruik van Givt (waaronder mede wordt verstaan het downloaden en de installatie daarvan), aanvaard jij als gebruiker (“Gebruiker”) deze gebruiksvoorwaarden en onze privacyverklaring (www.givtapp.net/privacyverklaringgivt). Deze gebruiksvoorwaarden en onze privacyverklaring zijn tevens te raadplegen, downloaden en printen op onze website. Wij kunnen deze gebruiksvoorwaarden van tijd tot tijd aanpassen.\n\n\n\n2. Licentie en intellectuele eigendomsrechten\n\n2.1 Alle rechten op Givt, de bijbehorende documentatie en alle wijzigingen en uitbreidingen hierop en de handhaving hiervan liggen en blijven bij Givt B.V. De Gebruiker verkrijgt uitsluitend de gebruiksrechten en bevoegdheden die voortvloeien uit de strekking van deze voorwaarden en voor het overige mag u Givt niet gebruiken, verveelvoudigen of openbaar maken.\n\n2.2 Givt B.V. verleent aan de Gebruiker een niet-exclusieve, niet-sublicentieerbare en niet-overdraagbare licentie voor het gebruik van Givt. Het is de Gebruiker niet toegestaan om Givt te gebruiken voor commerciële doeleinden. \n\n2.3 De Gebruiker mag Givt niet aan derden ter beschikking stellen, verkopen, verhuren, decompileren, onderwerpen aan reverse engineering of aanpassen zonder voorafgaande toestemming van Givt B.V. Evenmin mag de Gebruiker de technische voorzieningen die bedoeld zijn om Givt te beschermen (laten) verwijderen of (laten) omzeilen. \n\n2.4 Givt B.V. heeft te allen tijde het recht om Givt aan te passen, gegevens te wijzigen of verwijderen, de Gebruiker het gebruik van Givt te ontzeggen door de licentie te beëindigen, het gebruik van Givt te beperken of de toegang tot Givt geheel of gedeeltelijk, tijdelijk of blijvend te ontzeggen. Givt B.V. zal de Gebruiker hierover op een haar passende wijze informeren. \n\n2.5 De Gebruiker verwerft geen enkel(e) recht, titel of belang in of op de intellectuele eigendomsrechten en/of vergelijkbare rechten op (de inhoud van) Givt, waaronder de onderliggende software en content.\n\n3. Gebruik van Givt\n\n3.1 De Gebruiker kan alleen donaties geven aan kerken, stichtingen, fondsen en/of andere (rechts)personen die zijn aangesloten bij Givt en een relatie zijn aangegaan met Givt B.V. De donaties worden anoniem gedaan. \n\n3.2 Het gebruik van Givt is voor eigen rekening en risico en dient te worden gebruikt in overeenstemming met de doeleinden waarvoor zij bestemd is. Het is niet toegestaan de broncode van Givt te reverse engineeren of Givt te decompileren en/of te wijzigen, Givt beschikbaar te stellen aan derden of enige aanduidingen van Givt B.V. als rechthebbende op Givt of delen daarvan te verwijderen of onleesbaar te maken.\n\n3.3 De Gebruiker is verantwoordelijk voor de juiste verstrekking van gegevens zoals NAW-gegevens, bankrekeningnummer en andere gegevens zoals gevraagd door Givt B.V. om het gebruik van Givt te waarborgen. \n\n3.4 Indien de Gebruiker jonger is dan 18 jaar dient hij/zij voor het gebruik van Givt de toestemming van zijn/haar ouder of wettelijke vertegenwoordiger te hebben. Door deze gebruiksvoorwaarden te accepteren, garandeert de Gebruiker dat hij/zij 18 jaar of ouder is of toestemming heeft van zijn/haar ouders of wettelijke vertegenwoordiger. \n\n3.5 Givt is beschikbaar voor de besturingssystemen Android en iOS. Naast de hieronder opgenomen bepalingen kan Apple’s App Store of Google Play voorwaarden stellen aan het verkrijgen van Givt, het gebruiken daarvan en aanverwante zaken. Raadpleeg hiervoor de gebruiksvoorwaarden en privacyverklaring van Apple’s App Store en Google Play en eventueel van toepassing zijnde voorwaarden op de website van de betreffende aanbieder. Deze gebruikersvoorwaarden zijn van toepassing op de overeenkomst tussen de Gebruiker en Givt B.V. en gelden niet tussen de Gebruiker en de aanbieder van het platform via welke u Givt heeft verkregen. Deze aanbieders kunnen de Gebruiker echter wel aanspreken op overtreding van bepalingen in deze gebruikersvoorwaarden. \n\n3.6 Nadat de Gebruiker Givt heeft gedownload, dient de Gebruiker zich te registreren. Daarbij moet de Gebruiker de volgende informatie verstrekken: (i) NAW-gegevens, (ii) telefoonnummer, (iii) bankrekeningnummer en (iv) e-mailadres. Op de verwerking van persoonsgegevens via Givt is de privacyverklaring van Givt B.V. van toepassing. Bij eventuele wijzigingen van gegevens dient de Gebruiker onmiddellijk dit aan te passen via Givt.\n\n3.7 De Gebruiker kan na het downloaden van Givt er ook voor kiezen om alleen een e-mailadres op te geven en daarna gelijk de app te gebruiken om te doneren. Na de donatie zal een voltooiing van de registratie worden gevraagd. Indien de Gebruiker dit later wenst te doen, verbindt Givt B.V. zich ertoe het e-mailadres van de Gebruiker enkel en alleen te gebruiken om de Gebruiker aan de nog te voltooien registratieprocedure te herinneren tot het moment waarop de Gebruiker de volledige registratieprocedure heeft afgerond.\n\n3.8 Om van Givt gebruik te kunnen maken, dient de Gebruiker zelf op eigen kosten zorg te dragen voor de daarvoor noodzakelijke apparatuur, systeemprogrammatuur en (internet)verbinding. \n\n3.9 Givt B.V. levert de gerelateerde diensten op basis van de informatie die de Gebruiker verstrekt. De Gebruiker is verplicht correcte en volledige informatie te verstrekken, die niet vals of misleidend is. De Gebruiker mag geen gegevens verstrekken met betrekking tot namen of bankrekeningen waarvoor de Gebruiker niet bevoegd is om deze te gebruiken. Givt B.V. en de Processor hebben het recht informatie die de Gebruiker heeft verstrekt, te valideren en te verifiëren.  \n\n3.10 De Gebruiker kan het gebruik van Givt op ieder gewenst moment beëindigen, door zijn Givt account te verwijderen via het menu in de app, of via mail aan support@givtapp.net. Het verwijderen van de app op de smartphone zonder deze stappen te doorlopen, resulteert niet in een automatische verwijdering van de gegevens van de Gebruiker. Givt B.V. kan de relatie met de Gebruiker beëindigen indien de Gebruiker deze voorwaarden niet naleeft of indien Givt voor 18 achtereenvolgende maanden niet wordt gebruikt. Op verzoek stuurt Givt B.V. een overzicht van alle donatiegegevens.\n\n3.11 Givt B.V. brengt geen vergoeding in rekening voor het gebruik van Givt. \n\n3.12 Givt B.V. heeft het recht de aangeboden functionaliteiten van tijd tot tijd aan te passen om deze te verbeteren of te wijzigen en om fouten te herstellen. Givt B.V. zal zich inspannen om eventuele fouten in de Givt-software op te lossen, maar kan niet garanderen dat alle fouten, al dan niet tijdig, worden hersteld.\n\n\n\n4. Verwerking transacties\n\n4.1 Givt B.V. is geen bank/financiële instelling en verleent geen bancaire of betalingsverwerkende diensten. Om de donaties van de Gebruiker te verwerken, heeft Givt B.V. daarom een overeenkomst gesloten met een betaaldienstverlener genaamd SlimPay, een financiële instelling (de “Processor”), waarin is afgesproken dat Givt B.V. de transactiegegevens naar de Processor verstuurt, om donaties te initiëren en af te handelen. Givt B.V. zal, na de collectie van de donaties, zorgdragen voor de afdracht van de donaties aan de door de Gebruiker aangestelde begunstigde(n). De transactiedata zullen door Givt worden verwerkt en doorgestuurd naar de Processor. De Processor zal de betalingstransacties initiëren en Givt B.V. is verantwoordelijk om de relevante bedragen over te maken naar een bankrekening van de kerk/stichting zoals door de Gebruiker aangewezen als begunstigde van de donatie.\n\n4.2 De Gebruiker gaat ermee akkoord dat Givt B.V. de Gebruikers (transactie- en bank-)gegevens mag doorgeven aan de Processor, samen met alle andere noodzakelijke account- en persoonlijke informatie van de Gebruiker, om de Processor in staat te stellen de betalingstransacties te kunnen initiëren en verwerken. Givt B.V. behoudt zich het recht voor om op elk moment van Processor te veranderen. De Gebruiker gaat ermee akkoord dat Givt B.V. relevante informatie over de Gebruiker en de gegevens zoals omschreven in artikel 4.2 mag doorsturen naar de nieuwe Processor om betalingstransacties te kunnen blijven verwerken. \n\n4.3 Givt B.V. en de Processor zullen de gegevens van de Gebruiker verwerken in overeenstemming met de wet­ en regelgeving die geldt voor gegevensbescherming. Voor verdere informatie over hoe persoonsgegevens worden verzameld, verwerkt en gebruikt, verwijst Givt B.V. de Gebruiker naar haar privacybeleid. Deze kan online (www.givtapp.net/privacyverklaringgivt) teruggevonden worden. \n\n4.4 De donaties van de Gebruiker verlopen via Givt B.V. als intermediair. Vervolgens zal Givt B.V. ervoor zorgdragen dat de gelden worden overgemaakt naar de begunstigde(n), met wie Givt B.V. een overeenkomst heeft afgesloten. \n\n4.5 Om een donatie via Givt uit te voeren, dient de Gebruiker een machtiging af te geven aan Givt B.V. en/of de Processor (voor een automatische SEPA incasso). De Gebruiker kan te allen tijde – binnen de voorwaarden zoals gehanteerd door de Gebruikers bank – een automatische incasso terugdraaien. \n\n4.6 Een donatie kan door Givt B.V. en/of de Processor worden geweigerd als er redelijke gronden zijn om aan te nemen dat een Gebruiker in strijd met deze voorwaarden handelt of als er redelijke gronden zijn om aan te nemen dat een donatie mogelijk verdacht of illegaal is. Givt B.V. stelt de Gebruiker hiervan zo spoedig mogelijk op de hoogte, tenzij dit wettelijk is verboden. \n\n4.7 Gebruikers van de Givt app zullen geen kosten worden berekend voor hun donaties via ons platform. Givt en de ontvangende partij hebben aparte afspraken gemaakt omtrent vergoedingen in de door hen geldende overeenkomst.\n\n4.8 De Gebruiker gaat ermee akkoord dat Givt B.V. de Gebruikers (transactie-)gegevens mag doorgeven aan de lokale belastingautoriteiten, samen met alle andere noodzakelijke account- en persoonlijke informatie van de Gebruiker, om de Gebruiker te assisteren met zijn/haar jaarlijkse belastingaangifte.   \n\n\n\n5. Beveiliging, diefstal en verlies \n\n5.1 De Gebruiker dient alle redelijke voorzorgsmaatregelen te nemen om zijn/haar inloggegevens tot Givt veilig te bewaren om verlies, diefstal, verduistering of ongeautoriseerd gebruik van Givt of zijn/haar smartphone te vermijden. \n\n5.2 De Gebruiker is verantwoordelijk voor de beveiliging van zijn/haar smartphone. Givt B.V. beschouwt elke donatie vanuit de Givt-account van de Gebruiker als een door de Gebruiker goedgekeurde transactie, ongeacht de rechten die de Gebruiker toekomen onder artikel 4.5.\n\n5.3 De Gebruiker dient Givt B.V. onmiddellijk op de hoogte te brengen via support@givtapp.net of +31 320 320 115, zodra zijn/haar smartphone is verloren of gestolen. Bij ontvangst van een melding blokkeert Givt B.V. het account om (verder) misbruik te voorkomen. \n\n\n6. Updates\n\n6.1 Givt B.V. brengt van tijd tot tijd updates uit ter verbetering van de gebruikerservaring, die fouten kunnen herstellen of het functioneren van Givt verbeteren. Beschikbare updates voor Givt zullen kenbaar worden gemaakt via notificatie langs Apple’s App Store en Google Play, waarbij het uitsluitend de verantwoordelijkheid van de Gebruiker is deze notificaties bij te houden. \n\n6.2 Een update kan voorwaarden stellen die afwijken van het in deze voorwaarden bepaalde. Dit wordt aan de Gebruiker altijd vooraf gemeld en de Gebruiker heeft dan gelegenheid de update te weigeren. Door installatie van een dergelijke update gaat de Gebruiker akkoord met deze afwijkende voorwaarden, welke dan deel uit zullen maken van deze gebruikersvoorwaarden. Indien de Gebruiker niet akkoord gaat met de gewijzigde voorwaarden, dient hij/zij het gebruik van Givt te staken en Givt te verwijderen van zijn/haar mobiele telefoon en/of tablet.\n\n\n\n7. Aansprakelijkheid  \n\n7.1 Givt is met de grootste zorg samengesteld. Hoewel Givt B.V. ernaar streeft Givt 24 uur per dag beschikbaar te maken, aanvaardt zij geen aansprakelijkheid indien, om welke reden dan ook, Givt niet beschikbaar is op een bepaald moment of voor een bepaalde periode. Givt B.V. houdt zich het recht voor Givt (onaangekondigd) tijdelijk of permanent te staken, zonder dat de Gebruiker daar enige rechten uit kan ontlenen.\n\n7.2 Givt B.V. is niet aansprakelijk voor schade of letsel welke voortvloeit uit het gebruik van Givt. De beperkingen van aansprakelijkheid zoals genoemd in dit artikel komen te vervallen indien de aansprakelijkheid voor schade het gevolg is van opzet of grove schuld aan de zijde van Givt B.V. \n\n7.3 De Gebruiker vrijwaart Givt B.V. voor alle mogelijke aanspraken van derden (bijvoorbeeld begunstigden van de donaties of de belastingdienst) als gevolg van het gebruik van Givt of het niet of op niet correcte wijze nakomen van wettelijke of contractuele verplichtingen jegens Givt B.V. De Gebruiker zal Givt B.V. alle schade en kosten vergoeden die Givt B.V. als gevolg van dergelijke aanspraken lijdt.\n\n\n\n8. Overige Bepalingen  \n\n8.1 Deze gebruikersvoorwaarden treden in werking bij ingebruikname van Givt en blijven dan voor onbepaalde tijd van kracht. De overeenkomst mag door zowel de Gebruiker als Givt B.V. op ieder moment worden opgezegd met een opzegtermijn van een maand. Deze overeenkomst eindigt van rechtswege indien de Gebruiker: (i) in staat van faillissement wordt verklaard, (ii) surséance van betaling aanvraagt of er algeheel beslag op Gebruikers vermogen wordt gelegd, (iii) de Gebruiker overlijdt, (iv) in liquidatie treedt, opgeheven wordt of wordt ontbonden. Na beëindiging van de overeenkomst (om welke reden dan ook) dient de Gebruiker ieder gebruik van Givt te staken en gestaakt te houden. De Gebruiker dient dan alle kopieën (inclusief reservekopieën) van Givt te verwijderen van al zijn/haar systemen. \n\n8.2 Indien enige bepaling van deze voorwaarden nietig is of vernietigd wordt, tast dit niet de geldigheid van de gehele overeenkomst aan en zullen overige bepalingen van deze voorwaarden van kracht blijven. Partijen zullen in dat geval ter vervanging (een) nieuwe bepaling(en) vaststellen, waarmee zoveel als rechtens mogelijk is aan de bedoeling van de oorspronkelijke overeenkomst gestalte wordt gegeven.\n\n8.3 Het is de Gebruiker niet toegestaan rechten en/of verplichtingen voortvloeiende uit het gebruik van Givt en deze voorwaarden over te dragen aan derden zonder voorafgaande schriftelijke toestemming van Givt B.V. Omgekeerd is dit Givt B.V. wel toegestaan. \n\n8.4 Eventuele geschillen die voortvloeien uit of in verband met deze voorwaarden worden definitief beslecht door de rechtbank van Lelystad. Voordat het geschil naar de rechter zal worden verwezen, zullen U en Wij ons inspannen om het geschil in der minne op te lossen. \n\n8.5 Op deze Gebruiksvoorwaarden is Nederlands recht van toepassing. \n\n8.6 De Gebruiksvoorwaarden doen geen afbreuk aan de Gebruikers dwingendrechtelijke rechten als consument. \n\n8.7 Givt B.V. beschikt over een interne klachtenprocedure. Givt B.V. behandelt klachten efficiënt en zo spoedig als redelijkerwijs mogelijk is. Als de Gebruiker een klacht heeft over de tenuitvoerlegging van deze voorwaarden door Givt B.V., moet de Gebruiker deze schriftelijk indienen bij Givt B.V. (via support@givtapp.net).\n\n';

  @override
  String get prepareMobileTitle => 'Eerst even dit';

  @override
  String get prepareMobileExplained => 'Voor een optimaal gebruik van Givt vragen we je toestemming om notificaties te versturen.';

  @override
  String get prepareMobileSummary => 'Zo weet je waar en wanneer \n je kunt geven.';

  @override
  String get policyText => 'Laatst bijgewerkt: 03-03-2020\n \n\n Versie: 1.9\n \n\n Privacyverklaring Givt B.V.\n \n\n Via de dienst Givt - bestaande uit zowel een app als een online platform - worden privacygevoelige gegevens oftewel persoonsgegevens verwerkt. Givt B.V. acht een zorgvuldige omgang met persoonsgegevens van groot belang. Persoonlijke gegevens worden door ons dan ook zorgvuldig verwerkt en beveiligd. \n \n\n Bij onze verwerking houden wij ons aan de eisen die de Algemene Verordening Gegevensbescherming (EU 2016/679, ook wel gekend als AVG) stelt. Dat betekent onder andere dat wij:\n - duidelijk vermelden met welke doeleinden wij persoonsgegevens verwerken. Dat doen wij via deze privacyverklaring;\n - onze verzameling van persoonsgegevens beperken tot alleen de persoonsgegevens die nodig zijn voor legitieme doeleinden;\n - u eerst vragen om uitdrukkelijke toestemming om uw persoonsgegevens (of persoonsgegevens van anderen in de organisatie die u vertegenwoordigt) te verwerken in gevallen waarin uw toestemming is vereist;\n - passende beveiligingsmaatregelen nemen om uw persoonsgegevens te beschermen en dat ook eisen van partijen die in onze opdracht persoonsgegevens verwerken;\n - uw recht respecteren om uw persoonsgegevens op uw aanvraag ter inzage te bieden, te corrigeren of te verwijderen.\n \n\n Givt B.V. is de verantwoordelijke voor de gegevensverwerking. Onze verwerking is aangemeld bij het College Bescherming Persoonsgegevens onder het nummer M1640707. In deze privacyverklaring leggen wij uit welke persoonsgegevens wij verzamelen en gebruiken en met welk doel. Wij raden u aan deze zorgvuldig te lezen.\n \n\n Deze privacyverklaring is voor het laatst aangepast op 02-03-2021.\n \n\n Gebruik van persoonsgegevens\n Door het gebruiken van onze dienst laat u bepaalde gegevens bij ons achter. Dat kunnen persoonsgegevens zijn. Wij bewaren en gebruiken uitsluitend de persoonsgegevens (of persoonsgegevens van anderen in de organisatie die u vertegenwoordigt) die rechtstreeks door u worden opgegeven, in het kader van de door u gevraagde dienst, of waarvan bij opgave duidelijk is dat ze aan ons worden verstrekt om te verwerken. \n Wij gebruiken de volgende gegevens voor de in deze privacyverklaring genoemde doelen:\n - NAW gegevens \n - Telefoonnummer \n - E-mailadres \n - Betalingsgegevens \n \n\n Registreren\n Bij bepaalde onderdelen van onze dienst moet u zich of de organisatie die u vertegenwoordigt eerst registreren. Na registratie bewaren wij via de door u gekozen gebruikersnaam de door u opgegeven persoonsgegevens. Wij bewaren deze gegevens zodat u deze niet elke keer opnieuw hoeft in te vullen, zodat wij u kunnen contacteren in het kader van uitvoering van de overeenkomst en om een overzicht te geven van het gebruik van onze diensten. \n Wij zullen de aan uw gebruikersnaam gekoppelde gegevens niet aan derden verstrekken, tenzij dat noodzakelijk is in het kader van de uitvoering van de overeenkomst die u met ons sluit of indien dit wettelijk verplicht is. In geval van een vermoeden van fraude of misbruik van onze online dienst-infrastructuur kunnen wij persoonsgegevens aan de bevoegde autoriteiten overhandigen.\n \n\n Reclame\n Wij kunnen u, naast de informatie via onze online dienst-infrastructuur, op de hoogte brengen van onze nieuwe producten en diensten:\n - per e-mail\n \n\n Contactformulier en nieuwsbrief\n Wij bieden een nieuwsbrief waarmee wij geïnteresseerden willen informeren over onze producten en/of diensten. Iedere nieuwsbrief bevat een link waarmee u zich kunt afmelden. Uw e-mailadres wordt automatisch toegevoegd aan de lijst van abonnees. \n Als u een contactformulier op de website invult, of ons een e-mail stuurt, dan worden de gegevens die u ons toestuurt bewaard zolang als naar de aard van het formulier of de inhoud van uw e-mail nodig is voor de volledige beantwoording en afhandeling daarvan.\n \n\n Publicatie\n Wij publiceren uw klantgegevens niet.\n \n\n Verstrekking aan derden\n Wij kunnen uw gegevens doorgeven aan onze partners. Deze partners zijn betrokken bij de uitvoering van de overeenkomst. Dit zijn in alle gevallen partners die nodig zijn om de diensten te kunnen bieden. Voor donateurs betreft dit niet de collecterende instanties, aangezien wij de anonimiteit van de donateur in hun richting waarborgen. \n \n\n U gaat ermee akkoord dat de transactiegegevens kunnen worden geanonimiseerd en kunnen worden gebruikt voor data-verzameling, statistiek-overzichten en vergelijkingen. Alleen de totalen zullen worden gedeeld met andere klanten en wij dragen ervoor zorg dat geen van uw gegevens herleidbaar tot individuen zullen zijn. \n \n\n Ook zullen we gegevens nooit verkopen aan derden en alleen maar inzetten om het voor de donateur makkelijker te maken om te geven en op een manier betrokken te zijn bij de goede doelen zoals zij dat wensen.\n \n\n Beveiliging\n Wij nemen beveiligingsmaatregelen om misbruik van en ongeautoriseerde toegang tot persoonsgegevens te beperken. In het bijzonder nemen wij de volgende maatregelen: \n - Toegang tot persoonsgegevens wordt afgeschermd met een gebruikersnaam en wachtwoord\n - Toegang tot persoonsgegevens wordt afgeschermd met een gebruikersnaam en een login token\n - Wij maken gebruik van beveiligde verbindingen (TLS/SSL of Transport Layer Security/Secure Sockets Layer) waarmee alle informatie tussen u en onze online dienst-infrastructuur wordt afgeschermd wanneer u persoonsgegevens invoert\n - Wij houden logs bij van alle opvragingen van persoonsgegevens\n \n\n Gebruik van locatiegegevens\n In de app kan er worden gebruik gemaakt van de locatiegegevens die het besturingssysteem van de betreffende smartphone voorziet. Met deze gegevens kan de app bepalen waar de gebruiker is. Deze locatiegegevens worden niet verstuurd naar ergens buiten de smartphone en enkel gebruikt om te bepalen of de gebruiker op een locatie is waar Givt kan worden gebruikt om te geven. De locaties waar Givt kan worden gebruikt, worden vooraf gedownload naar de smartphone.\n \n\n Diagnostische informatie van de app\n De app verstuurt geanonimiseerde informatie over de werking. Deze informatie bevat niet-persoonsgebonden gegevens van uw smartphone zoals het type en het besturingssysteem, maar ook de versie van de app. Deze gegevens worden uitsluitend gebruikt om de service van Givt te kunnen verbeteren of om uw vragen sneller te kunnen beantwoorden. Deze informatie wordt nooit verstrekt aan derden.\n \n\n Wijzigingen in deze privacyverklaring\n Wij behouden ons het recht voor om wijzigingen aan te brengen in deze privacyverklaring. Het verdient aanbeveling om deze privacyverklaring geregeld te raadplegen, zodat u van deze wijzigingen op de hoogte bent.\n \n\n Inzage en wijzigen van uw gegevens\n Voor vragen over ons privacybeleid of vragen omtrent inzage en wijzigingen in (of verwijdering van) uw persoonsgegevens kunt u te allen tijde contact met ons opnemen via onderstaande gegevens:\n \n\n Givt B.V.\n Bongerd 159\n 8212 BJ LELYSTAD\n 0031 320 320 115\n KVKnr: 64534421';

  @override
  String get needHelpTitle => 'Hulp nodig?';

  @override
  String get findAnswersToYourQuestions => 'Vind hier antwoorden op je vragen \n en handige tips';

  @override
  String get questionHowDoesRegisteringWorks => 'Hoe werkt het registreren?';

  @override
  String get questionWhyAreMyDataStored => 'Waarom worden mijn \n persoonsgegevens vastgelegd?';

  @override
  String get faQvraag1 => 'Wat is Givt eigenlijk?';

  @override
  String get faQvraag2 => 'Hoe werkt Givt?';

  @override
  String get faQvraag3 => 'Hoe wijzig ik mijn instellingen \n of gegevens?';

  @override
  String get faQvraag4 => 'Aan welke organisaties kan ik geven?';

  @override
  String get faQvraag5 => 'Hoe wordt mijn gift afgeschreven?';

  @override
  String get faQvraag6 => 'Wat kan ik allemaal met Givt?';

  @override
  String get faQvraag7 => 'Hoe veilig is geven met Givt?';

  @override
  String get faQvraag8 => 'Hoe kan ik mijn account opzeggen?';

  @override
  String get faQantwoord1 => 'Geven met je smartphone\n Givt is dé oplossing voor het meedoen aan de collecte zonder contant geld. Iedereen heeft een smartphone, met de Givt-app gebruik je deze tijdens de collecte om heel makkelijk een bedrag te geven. De Givt-app vind je gratis in de App Store en in Google Play.\n \n\n Persoonlijk en bewust\n Het geven van geld is niet zomaar een financiële transactie, het is vaak een persoonlijk en bewust moment. Vandaar dat wij de Givt-app zo ontwikkelen dat het net zo natuurlijk aanvoelt als het geven van contant geld.\n \n\n Waarom ‘Givt’?\n De naam Givt is gekozen omdat het zowel om ‘giving’ gaat, alsook om de ‘gift’ op zich. We zochten naar een moderne en compacte naam, die vriendelijk en speels oogt.\n \n\n Als je goed naar het logo kijkt, zie je dat het groene balkje met de letter ‘v’ samen een collectezak vormen, wat een idee geeft van de functie van de app. Het geven aan de collectezak geeft de roots van onze app aan. Hier is in 2016 de ontwikkeling begonnen. Inmiddels kan Givt op velerlei manieren ingezet worden. \n \n\n Achter Givt zit een team van specialisten, verdeeld over Nederland, België en Engeland, die allemaal actief bezig zijn met de ontwikkeling en verbetering van Givt.';

  @override
  String get faQantwoord2 => 'De eerste stap\n Je hebt de app al geïnstalleerd, dat is de eerste stap. Registreer jezelf eenmalig als gebruiker door je gegevens in te vullen. Vervolgens werkt het net zo makkelijk als het geven van contant geld.\n \n\n Open de app, selecteer het bedrag dat je wilt geven en kies vervolgens de manier van geven:\n – beweeg je telefoon langs een collectemiddel\n – scan een QR-code\n – selecteer een doel uit een lijst\n – of geef op locatie\n \n\n Het gekozen bedrag wordt opgeslagen, van je bankrekening afgeschreven en aan de collecterende organisatie overgemaakt. \n \n\n Wanneer je op het moment van geven geen internetverbinding hebt, wordt de opdracht op een later moment bij het heropenen van de app verstuurd. Bijvoorbeeld als je thuis bent en weer gebruik maakt van WiFi.';

  @override
  String get faQantwoord3 => 'Je kunt je app-menu bereiken door links bovenin het bedragscherm op het menu te drukken. Om je instellingen te wijzigen wordt je gevraagd in te loggen met je e-mailadres en wachtwoord of een andere beveiligingsmethode (vingerafdruk of FaceID) als je die hebt ingesteld.\n \n\n In je menu kun je het overzicht van je giften inzien, je geeflimiet aanpassen, je persoonlijke gegevens wijzigen, je voorkeursbedragen aanpassen, een extra beveilgingsmethode instellen (vingerafdruk of FaceID) of je account opzeggen.';

  @override
  String get faQantwoord4 => 'Je kunt Givt gebruiken bij alle organisaties die bij ons zijn aangesloten. Dit varieert van kerken, tot goede doelen, evenementen, musea en (straat)artiesten. Er komen elke week meer bij, check de pagina www.givtapp.net/waar-givt-gebruiken voor het totale overzicht.\n \n\n Nog niet aangesloten?\n Als de kerk of organisatie waaraan je wilt geven nog niet is aangesloten bij Givt, laat het ons weten, dan nemen we contact met ze op!';

  @override
  String get faQantwoord5 => 'Tijdens de registratie in de Givt-app machtig je als gebruiker tot het incasseren van alle giften die je in de app doet. De transacties worden afgehandeld door SlimPay; een partij die gespecialiseerd is in de behandeling van machtigingen.\n Er vinden geen afschrijvingen plaats tijdens het geven met Givt, dit gebeurt achteraf door middel van een automatische incasso. Op je bankafschrift zal je zien dat je gift afgeschreven is door Givt B.V. Alle automatische incasso’s zijn achteraf via je eigen bank te herroepen.';

  @override
  String get faQantwoord6 => 'Givt staat niet stil, maar blijft zich ontwikkelen. We hebben het mogelijk gemaakt om in de kerk, tijdens evenementen en aan (straat)artiesten te geven zonder contant geld. Givt biedt een heleboel opties om te geven.\n \n\n Belastingaangifte\n Aan het einde van het jaar kan je een overzicht van je giften opvragen, wel zo gemakkelijk voor de belastingaangifte. In dit overzicht staan alleen de giften die je hebt gedaan aan een algemeen nut beogende instelling (ANBI), een culturele ANBI of aan een sociaal belang behartigende instelling (SBBI). Uiteindelijk streven we ernaar dat alle giften automatisch worden ingevuld bij de belastingaangifte.';

  @override
  String get faQantwoord7 => 'Givt hecht grote waarde aan veiligheid. We zijn ons ervan bewust dat onze dienstverlenende rol tussen donateurs en collecterende organisaties gebaseerd is op vertrouwen.\n \n\n Een belangrijk deel van geven met Givt is dat een donateur anoniem blijft voor de collecterende organisatie. Om dit te waarborgen zullen wij nooit gegevens doorverkopen en zullen de verzamelde gegevens alleen intern gebruikt worden om een optimale service te kunnen bieden.\n \n\n De transacties worden afgehandeld door SlimPay; een bank gespecialiseerd in de behandeling van machtigingen. SlimPay staat onder toezicht van meerdere nationale banken in Europa, waaronder De Nederlandse Bank (DNB).\n \n\n Bij het installeren van de Givt-app, machtigt de gebruiker tot het incasseren van de donaties die er met de app gedaan worden. Het is goed om te benadrukken dat er geen transacties plaatsvinden tijdens het geven met Givt. De transacties vinden achteraf plaats door middel van een automatische incasso. Aangezien deze achteraf te herroepen zijn, is het volledig veilig en ongevoelig voor fraude.\n \n\n Organisaties kunnen inloggen op het Givt-dashboard. Dit geeft een overzicht van alle financiële transacties, vanaf het moment van geven tot aan de volledige verwerking van de betaling. Zo is elk bedrag van begin tot eind te volgen. Organisaties kunnen zien hoeveel mensen gebruik hebben gemaakt van Givt maar natuurlijk niet wie dat zijn.';

  @override
  String get faQantwoord8 => 'Dat vinden we jammer om te horen! We horen graag waarom.\n Je kunt je Givt-account opzeggen door in je menu te kiezen voor ‘Account opzeggen’.\n \n\n Mocht je Givt in de toekomst weer willen gebruiken, dan zul je een nieuw account moeten maken.';

  @override
  String get privacyTitle => 'Privacyverklaring';

  @override
  String get acceptTerms => 'Bij het doorgaan ga je akkoord met de algemene voorwaarden.';

  @override
  String get mandateSigingFailed => 'Het tekenen van de machtiging is helaas niet gelukt. Probeer later opnieuw vanuit het menu. Blijft deze melding opduiken? Contacteer dan support@givtapp.net.';

  @override
  String get awaitingMandateStatus => 'We hebben héél even nodig \n om je machtiging te verwerken.';

  @override
  String get requestMandateFailed => 'Het is op dit moment niet mogelijk om een machtiging aan te vragen. Probeer je het later even opnieuw?';

  @override
  String get faqHowDoesGivingWork => 'Hoe kan ik geven?';

  @override
  String get faqHowDoesManualGivingWork => 'Hoe werkt handmatig geven?';

  @override
  String givtNotEnough(Object value0) {
    return 'Helaas, we kunnen alleen bedragen boven $value0 verwerken.';
  }

  @override
  String get slimPayInformationPart2 => 'Er wordt alleen geïncasseerd, wanneer je zelf een bedrag geeft met Givt.\n \n\n Omdat we met een machtiging werken, is het eventueel mogelijk om achteraf een gift te herroepen.';

  @override
  String get unregister => 'Account opzeggen';

  @override
  String get unregisterInfo => 'Wat jammer dat je ons wilt verlaten! We zullen al jouw persoonlijke gegevens verwijderen.\n \n\n Hier is één uitzondering op: als je gegeven hebt aan een ANBI-geregistreerde organisatie zijn we verplicht om de informatie over de gift en je NAW-gegevens te bewaren voor minimaal 7 jaar. Je e-mailadres en telefoonnummer verwijderen we sowieso.';

  @override
  String get unregisterSad => 'Jammer dat je gaat,\n hopelijk zien we je weer terug.';

  @override
  String get historyTitle => 'Giftenoverzicht';

  @override
  String get historyInfoTitle => 'Info over de gift';

  @override
  String get historyAmountAccepted => 'Wordt verwerkt';

  @override
  String get historyAmountCancelled => 'Geannuleerd door gever';

  @override
  String get historyAmountDenied => 'Geweigerd door bank';

  @override
  String get historyAmountCollected => 'Verwerkt';

  @override
  String get loginSuccess => 'Veel geefplezier!';

  @override
  String get historyIsEmpty => 'Hier komen jouw giften te staan, maar het geld moet eerst nog rollen';

  @override
  String get errorEmailTooLong => 'Sorry, dit e-mailadres is te lang.';

  @override
  String get updateAlertTitle => 'Update beschikbaar';

  @override
  String get updateAlertMessage => 'Er is een nieuwe versie van Givt beschikbaar, wil je hem nu installeren?';

  @override
  String get criticalUpdateTitle => 'Kritieke update';

  @override
  String get criticalUpdateMessage => 'Er is een kritieke update beschikbaar, deze is nodig voor het correct functioneren van de Givt-app.';

  @override
  String organisationProposalMessage(Object value0) {
    return 'Wil je geven aan $value0?';
  }

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nee';

  @override
  String get faQvraag9 => 'Waar kan ik het overzicht van mijn giften bekijken?';

  @override
  String get faQantwoord9 => 'Druk op het menu linksbovenin om je app-menu te openen. Om toegang te krijgen wordt je gevraagd in te loggen met je e-mailadres en wachtwoord. Kies voor \'Giftenoverzicht\' om een overzicht van je giften weer te geven. Je kunt hier ook een jaarlijks giftenoverzicht downloaden voor de belastingaangifte.\n \n\n De giften staan in een lijst met naam van de ontvanger, tijd en datum. Aan de gekleurde streep (links van je gift) zie je direct wat de status is: wordt verwerkt, verwerkt, geweigerd door bank of geannuleerd door gever.';

  @override
  String get faqQuestion11 => 'Hoe stel ik mijn Touch ID of Face ID in?';

  @override
  String get faqAnswer11 => 'Je kunt je app-menu bereiken door links bovenin het bedragscherm op het menu te drukken. Kies daar voor ‘Vingerafdruk’/’Touch ID’ of ‘FaceID’ (enkel beschikbaar voor iPhone), afhankelijk van hoe je de Givt-app wilt beveiligen. \n \n\n Wanneer deze instelling actief is, kun je je TouchID/FaceID in plaats van je e-mailadres en wachtwoord gebruiken om in te loggen.';

  @override
  String get answerHowDoesRegistrationWork => 'Om te starten met geven, is alleen je e-mailadres nodig. Zodra je dat hebt ingevuld, kun je gewoon beginnen met geven. \n \n\n Opgelet: je moet je nog verder registreren om ervoor te zorgen dat al je gedane en toekomstige giften verwerkt kunnen worden. Ga hiervoor naar het menu in de app en kies voor \'Registratie voltooien\'. Je maakt hierbij een Givt-account aan, vult enkele persoonlijke gegevens in en je geeft een machtiging tot het incasseren van alle giften die je in de app doet. De transacties worden afgehandeld door SlimPay; een partij die gespecialiseerd is in de behandeling van machtigingen. \n \n\n Wanneer je eenmaal geregistreerd bent, kan je gewoon blijven geven met de Givt-app. De inloggegevens van je Givt-account heb je alleen nodig om je instellingen in te zien of te wijzigen.';

  @override
  String get answerHowDoesGivingWork => 'Geven met Givt is heel eenvoudig. Eenmaal geregistreerd, hoef je alleen de app te openen, een bedrag te kiezen en vervolgens kies je de manier van geven:\n – beweeg je telefoon langs een collectemiddel\n – scan een QR-code\n – selecteer een doel uit een lijst\n – of geef op locatie\n \n\n Vergeet niet om je registratie te voltooien, zodat je giften op het juiste adres bezorgd kunnen worden.';

  @override
  String get answerHowDoesManualGivingWork => 'Lukt het je niet om te geven aan een collectebus, -zak of -mand?\n Dan kan je er altijd voor kiezen om handmatig de ontvanger te selecteren.\n Klik bij het geven op de ‘Lijst’ optie. Daar worden alle organisaties waar je Givt kan gebruiken opgedeeld in 4 eenvoudige categorieën: kerken, goede doelen, acties en artiesten. Kies een ontvanger uit een van deze lijsten en druk op ‘Geven’.\n Zo, je Givt is gelukt!';

  @override
  String get informationPersonalData => 'Givt heeft deze persoonlijke gegevens nodig om je giften te kunnen verwerken. Wij gaan zorgvuldig met deze gegevens om. Dit kun je teruglezen in onze privacyverklaring.';

  @override
  String get informationAboutUs => 'Givt is een product van Givt B.V.\n \n\n Je kan ons vinden op de Bongerd 159 te Lelystad, Nederland. Voor vragen of klachten zijn we te bereiken via +31 320 320 115 of support@givtapp.net.\n \n\n In de Kamer van Koophandel zijn we geregistreerd onder KVKnr.: 64534421.';

  @override
  String get titleAboutGivt => 'Over Givt / Contact';

  @override
  String get sendAnnualReview => 'Verstuur jaaroverzicht';

  @override
  String get infoAnnualReview => 'Verkrijg hier het jaaroverzicht van je giften in 2016. \n Dit jaaroverzicht kan je gebruiken bij je belastingaangifte.';

  @override
  String get sendByEmail => 'Verstuur per e-mail';

  @override
  String get whyPersonalData => 'Waarom deze persoonlijke gegevens?';

  @override
  String get readPrivacy => 'Lees privacyverklaring';

  @override
  String get faqQuestion12 => 'Hoe lang duurt het voor mijn gift wordt afgeschreven?';

  @override
  String get faqAnswer12 => 'Jouw gift wordt binnen twee werkdagen van je bankrekening afgeschreven.';

  @override
  String get faqQuestion14 => 'Hoe kan ik geven aan meerdere collectes?';

  @override
  String get faqAnswer14 => 'Zijn er meerdere collectes in één dienst? Ook dan kun je geven in één vlotte beweging. \n \n\n Door op de ‘Collecte toevoegen’-knop te drukken, kun je tot drie collectes activeren. Bij iedere collecte kun je een zelfgekozen bedrag invoeren. Klik op de collecte die je wilt aanpassen en vul een bedrag in of maak gebruik van de voorkeursbedragen. Het verwijderen van een collecte doe je door te drukken op het min-teken, rechts van het bedrag. \n \n\n De verschillende collectedoelen worden onderscheiden door nummer 1, 2 of 3. Jouw kerk weet welk collectenummer overeenkomt met welk collectedoel. Al bij de eerste collectezak of -mand waar je aan geeft, worden alle giften verstuurd. In het giften-overzicht kun je al je giften terugvinden.\n \n\n Wil je toch een collecte overslaan? Laat dan die collecte open (€ 0,00) of verwijder deze door te drukken op het min-teken, rechts van het bedrag.';

  @override
  String get featureMultipleCollections => 'Nieuws! Je kan nu met één beweging tot drie verschillende doelen een handje helpen. Is het deze maand toch iets te hard gegaan, sla er dan eentje over of verwijder een collecte met een dubbele tap. Wil je meer weten, check dan onze FAQ.';

  @override
  String get featureIGetItButton => 'Gewoon blijven geven';

  @override
  String get ballonActiveerCollecte => 'Je kunt hier tot drie collectes toevoegen';

  @override
  String get ballonVerwijderCollecte => 'Een collecte wordt verwijderd door snel twee keer te tikken';

  @override
  String get needEmailToGive => 'Om te geven met Givt hebben we iets van identificatie nodig';

  @override
  String get giveFirst => 'Eerst geven';

  @override
  String get go => 'Verder';

  @override
  String get faQvraag15 => 'Is geven met Givt ook belastingaftrekbaar?';

  @override
  String get faQantwoord15 => 'Ja, je gift met Givt is belastingaftrekbaar indien die aan een algemeen nut beogende instelling (ANBI), een culturele ANBI of aan een sociaal belang behartigende instelling (SBBI) wordt gedaan.\n \n\n Het verzamelen van je giften voor de belastingaangifte is altijd een hele klus. Als je geeft met Givt hoeft dat niet meer. Je kunt namelijk voor elk jaar een overzicht van al jouw giften die zijn gegeven met Givt downloaden. Dit overzicht kun je dan mooi gebruiken als bewijs bij je belastingaangifte. Zo gepiept dus!';

  @override
  String get giveDiffWalkthrough => 'Lukt het niet? Tik dan hier om een organisatie uit de lijst te selecteren.';

  @override
  String get faQvraag17 => 'Staat je vraag er niet tussen?';

  @override
  String get faQantwoord17 => 'Stuur ons dan een bericht via de app (\"Over Givt / Contact\" in het menu), via mail naar support@givtapp.net of bel ons op +31 320 320 115.';

  @override
  String get noCameraAccessCelebration => 'Om de vliegensvlugge en flitsende geefactie te ondersteunen hebben we toegang nodig tot je camera.';

  @override
  String get yesCool => 'Ja, leuk!';

  @override
  String get faQvraag18 => 'Hoe gaat Givt met mijn persoonsgegevens om? (AVG)';

  @override
  String get faqAntwoord18 => 'Givt voldoet volledig aan de eisen die gesteld worden vanuit de AVG-wetgeving. AVG staat voor Algemene Verordening Gegevensbescherming.\n \n\n Ben je benieuwd wat dat precies voor jou betekent? Het betekent dat wij zorgvuldig met jouw gegevens omgaan. Namelijk dat jij het recht hebt te weten welke gegevens we van jou bewaren, dat je het recht hebt om deze gegevens te wijzigen, het recht hebt om van ons te eisen dat wij jouw gegevens niet bewaren en dat je mag weten waarom wij je gegevens nodig hebben.\n \n\n Wil je hier meer over weten, lees dan onze privacyverklaring.\n \n\n AVG is ook wel bekend onder de Engelse naam: General Data Protection Regulation (GDPR).';

  @override
  String get fingerprintCancel => 'Annuleer';

  @override
  String get faQuestAnonymity => 'Hoe wordt mijn anonimiteit gewaarborgd?';

  @override
  String get faQanswerAnonymity => 'Anoniem is een sleutelwoord bij Givt. Wij vinden het belangrijk dat je als gever anoniem blijft voor de ontvanger en we dragen er grote zorg voor dat deze ontvangende partij dus nooit terug zal kunnen zien van wie de gift afkomstig is. \n Enkel de totaalbedragen zullen worden gedeeld met de ontvangende partij. Gegevens van jou als gebruiker zullen ook nooit doorverkocht worden aan derden, deze worden alleen ingezet om het voor jou makkelijker te maken om te geven en om op een manier betrokken te zijn bij de goede doelen zoals jij dat prettig vindt.\n \n\n Wil je hier meer over lezen? Lees dan onze privacyverklaring (scroll helemaal naar beneden in deze FAQ waar je de privacyverklaring gelijk kan openen).';

  @override
  String get amountPresetsChangingPresets => 'Om sneller te kunnen geven kun je voorkeursbedragen toevoegen aan je toetsenbord. Hier beheer je het gebruik daarvan.';

  @override
  String get amountPresetsChangePresetsMenu => 'Wijzig voorkeursbedragen';

  @override
  String get featureNewguiInappnot => 'Tap hier om meer te weten te komen over de vernieuwde gebruikersinterface!';

  @override
  String get givtCompanyInfo => 'Givt B.V.';

  @override
  String get givtCompanyInfoGb => 'Givt Ltd.';

  @override
  String get celebrationHappyToSeeYou => 'We gaan samen je Givt vieren!';

  @override
  String get celebrationQueueText => 'Je mag de app gewoon op dit scherm laten staan. Wij sturen een pushnotificatie wanneer het aftellen begint.';

  @override
  String get celebrationQueueCancel => 'Geven zonder Flash Givt';

  @override
  String get celebrationEnablePushNotification => 'Schakel pushnotificaties in';

  @override
  String get faqButtonAccessibilityLabel => 'Veelgestelde vragen';

  @override
  String get progressBarStepOne => 'Stap 1';

  @override
  String get progressBarStepTwo => 'Stap 2';

  @override
  String get progressBarStepThree => 'Stap 3';

  @override
  String removeCollectButtonAccessibilityLabel(Object value0) {
    return 'Verwijder de $value0';
  }

  @override
  String get removeBtnAccessabilityLabel => 'Wis';

  @override
  String get progressBarStepFour => 'Stap 4';

  @override
  String get changeBankAccountNumberAndSortCode => 'Wijzig bankgegevens';

  @override
  String get updateBacsAccountDetailsError => 'Alas, the Sortcode or Account number is invalid. You can change the Sortcode and/or Account number under ‘Personal information’ in the menu.';

  @override
  String get ddiFailedTitle => 'DDI request failed';

  @override
  String get ddiFailedMessage => 'At the moment it is not possible to request a Direct Debit Instruction. Please try again in a few minutes.';

  @override
  String get faQantwoord5Gb => 'Handling transactions\n The transactions are handled by EazyCollect; a payment institution specialised in processing BACS Direct Debit Instructions. Just like Givt Ltd., EazyCollect is under the supervision of the Financial Conduct Authority.\n \n\n Revertible afterwards\n The transactions take place afterwards via a direct debit under Givt Ltd. We want to emphasise that no transactions take place in the moment of giving. Since these transactions are revocable, it is completely safe and immune to fraud.';

  @override
  String get faQvraag15Gb => 'Can I Gift Aid my donations?';

  @override
  String get faQantwoord15Gb => 'Yes, you can Gift Aid your donations (This is currently under active development.)\n \n\n Since the first of May 2019, it is possible for an intermediary like Givt Ltd. to make Gift Aid declarations on behalf of a donor. It’s hassle-free! You simply authorise Givt Ltd. once to make Gift Aid declarations through the Givt app.';

  @override
  String get answerHowDoesRegistrationWorkGb => 'To use Givt, you have to register in the Givt app. Go to your app menu and choose ‘Finish registration’. You set up a Givt account, fill in some personal details and give permission to debit the donations made with the app. With this Givt account, you don’t have to fill in all your personal details every time you want to donate.\n \n\n Of course it is also very important to us that everything is safe and risk-free. Each user has a personal account with its own password. When your registration is complete, you are ready to give. You only need your login details to see or change your settings.';

  @override
  String get faQantwoord7Gb => 'Registered Small Payment Institution\n Givt Ltd. is registered with the Financial Conduct Authority as a Small Payment Institution (823261). This means you can be confident that the way we conduct our business is transparent and secure and that the people running the company have been thoroughly checked.\n \n\n Personal safety\n It is very important to us that everything is safe and risk free. Each user has a personal account with its own password. You need to log in to view or change your settings.\n \n\n Handling transactions\n The transactions are handled by SmartDebit; a payment institution specialised in processing BACS Direct Debit Instructions. Just like Givt Ltd., SmartDebit is under the supervision of the Financial Conduct Authority.\n \n\n Immune to fraud\n When installing Givt, the user gives the app authorisation to debit their account. We want to emphasise that no transactions take place in the moment of giving. The transactions take place afterwards via a direct debit under Givt Ltd. Since these transactions are revocable, it is completely safe and immune to fraud.\n \n\n Overview\n Individual users can see an overview of their donations in the app. Organisations can log in to the Givt dashboard. This dashboard gives an overview of all financial transactions, from the moment of giving up to the full processing of the payment. In this way any collection can be followed from start to finish. Organisations can see how many people used Givt, but not who they are.';

  @override
  String get faQantwoord18Gb => 'Givt fully complies with the GDPR requirements. GDPR stands for General Data Protection Regulation.\n \n\n Wondering what this means for you? It means that we handle your information with care, that you have the right to know which information we keep on record, have the right to change this information, have the right to demand from us that we do not store your information, and that you may know why we need your personal information.\n \n\n If you would like to know more, please read our privacy statement.';

  @override
  String get giftAidSetting => 'Ik wil Gift Aid (blijven) gebruiken';

  @override
  String get giftAidInfo => 'Enkel UK belastingsplichtigen kunnen gebruik maken van Gift Aid. Elk jaar herinneren we je aan je keuze. Wanneer je Gift Aid activeert na 1 maart zal het tellen voor zowel maart als het volgende aanslagjaar.';

  @override
  String get giftAidHeaderDisclaimer => 'Wanneer je de optie activeert ga je akkoord met het volgende:';

  @override
  String get giftAidBodyDisclaimer => 'Ik ben een UK belastingsbetaler en begrijp dat, als ik minder belastingen in het huidige belastingsjaar dan dat ik donaties heb gedaan met behulp van Gift aid, dat het mijn plicht is om het verschil bij te betalen.';

  @override
  String get giftAidInfoTitle => 'Wat is Gift Aid?';

  @override
  String get giftAidInfoBody => 'Donating through Gift Aid means charities and community amateur sports clubs (CASCs) can claim an extra 25p for every £1 you give. It will not cost you any extra. \n \n\n Gift Aid treats the donations as being made after deduction of income tax at the basic rate. The charity you give to can reclaim this basic rate income tax paid on the gift from HMRC. Your donations will qualify as long as they’re not more than 4 times what you have paid in tax in that tax year. \n  \n For more info, please go to: www.gov.uk/donating-to-charity/gift-aid';

  @override
  String get faqAnswer12Gb => 'Your donation will be withdrawn from your bank account within five working days. The first time you make a donation with Givt, the donation will be withdrawn after two weeks, as it takes extra time to set up your registration.';

  @override
  String get faqVraagDdi => 'Does the Direct Debit mean I signed up to monthly deductions?';

  @override
  String get faqAntwoordDdi => 'NO! You sign a direct debit so we can deduct the donations you have made using the Givt app. The deductions we make are incidental, user-driven deductions.\n \n\n We will not debit your account unless you make a donation using the Givt app.';

  @override
  String get giftAidUnsavedChanges => 'Je hebt wijzigingen die niet opgeslaan zijn. Wil je terug om deze op te slaan of wil je deze wijzigingen ongedaan maken?';

  @override
  String get giftAidChangeLater => 'Je kunt deze optie later nog wijzigen via het menu onder \'Persoonlijke gegevens\'';

  @override
  String get dismiss => 'Ongedaan maken';

  @override
  String get importantMessage => 'Belangrijke melding';

  @override
  String get celebrationQueueCancelAlertBody => 'Weet je zeker dat je je Givt niet wil vieren?';

  @override
  String get celebrationQueueCancelAlertTitle => 'Jammer!';

  @override
  String get historyInfoLegendaAccessibilityLabel => 'Info legende';

  @override
  String get historyDownloadAnnualOverviewAccessibilityLabel => 'Download jaaroverzicht van giften (mail)';

  @override
  String get bluetoothErrorMessageEvent => 'Met Bluetooth kan je dankzij locatie-zenders toch je locatie vinden indien er geen/slechte GPS-verbinding is.\n Activeer deze nu.';

  @override
  String get processCashedGivtNamespaceInvalid => 'We zien dat je een nog niet verwerkte gift hebt aan een organisatie die jammergenoeg Givt niet meer gebruikt. Deze wordt gewoon verwijderd.';

  @override
  String get suggestionNamespaceInvalid => 'Je laatst geselecteerde doel ondersteunt Givt niet meer.';

  @override
  String get charity => 'Goed doel';

  @override
  String get artist => 'Artiest';

  @override
  String get church => 'Kerk';

  @override
  String get campaign => 'Actie';

  @override
  String get giveYetDifferently => 'Uit de lijst kiezen';

  @override
  String giveToNearestBeacon(Object value0) {
    return 'Geef aan: $value0';
  }

  @override
  String get jersey => 'Jersey';

  @override
  String get guernsey => 'Guernsey';

  @override
  String get countryStringBe => 'België';

  @override
  String get countryStringNl => 'Nederland';

  @override
  String get countryStringDe => 'Duitsland';

  @override
  String get countryStringGb => 'Verenigd Koninkrijk';

  @override
  String get countryStringFr => 'Frankrijk';

  @override
  String get countryStringIt => 'Italië';

  @override
  String get countryStringLu => 'Luxemburg';

  @override
  String get countryStringGr => 'Griekenland';

  @override
  String get countryStringPt => 'Portugal';

  @override
  String get countryStringEs => 'Spanje';

  @override
  String get countryStringFi => 'Finland';

  @override
  String get countryStringAt => 'Oostenrijk';

  @override
  String get countryStringCy => 'Cyprus';

  @override
  String get countryStringEe => 'Estland';

  @override
  String get countryStringLv => 'Letland';

  @override
  String get countryStringLt => 'Litouwen';

  @override
  String get countryStringMt => 'Malta';

  @override
  String get countryStringSi => 'Slovenië';

  @override
  String get countryStringSk => 'Slowakije';

  @override
  String get countryStringIe => 'Ierland';

  @override
  String get countryStringAd => 'Andorra';

  @override
  String get errorChangePostalCode => 'Je gebruikt een postcode die onbekend is. Ga naar \"Mijn gegevens\" in het menu.';

  @override
  String get informationAboutUsGb => 'Givt is a product of Givt LTD.\n \n\n We are located at the Blackthorn House in Birmingham, England. For questions or complaints you can reach us via 020 3790 8068 or support@givt.app.\n \n\n We are registered under the Company Registration Number 11396586.';

  @override
  String get bluetoothErrorMessageAction => 'Ik doe het';

  @override
  String get bluetoothErrorMessageCancel => 'Liever niet';

  @override
  String get authoriseBluetooth => 'Geef Givt toegang tot Bluetooth';

  @override
  String get authoriseBluetoothErrorMessage => 'Geef Givt toegang tot je Bluetooth om gewoon aan de collecte te blijven geven.';

  @override
  String get authoriseBluetoothExtraText => 'Ga naar Instellingen > Privacy > Bluetooth en selecteer \"Givt\".';

  @override
  String get unregisterError => 'Helaas, we kunnen op dit moment je account niet opzeggen. Probeer je het later nog een keer?';

  @override
  String get unregisterMandateError => 'Helaas, we kunnen op dit moment je account niet opzeggen omdat het niet lukt om je machtiging op te zeggen. Neem aub contact op met ons.';

  @override
  String get unregisterErrorTitle => 'Opzeggen mislukt';

  @override
  String get setupRecurringGiftTitle => 'Plan je gift';

  @override
  String get setupRecurringGiftText3 => 'vanaf';

  @override
  String get setupRecurringGiftText4 => 'tot';

  @override
  String get setupRecurringGiftText5 => 'of';

  @override
  String get add => 'Toevoegen';

  @override
  String get subMenuItemFirstDestinationThenAmount => 'Eenmalige gift';

  @override
  String get faqQuestionFirstTargetThenAmount1 => 'Wat is \"geven aan een goed doel\"?';

  @override
  String get faqAnswerFirstTargetThenAmount1 => '\"Geven aan een goed doel\" is een nieuwe functionaliteit in je Givt-app. Het werkt net zoals je het van de app gewoon bent, maar nu kan je eerst je goede doel kiezen en daarna hoeveel je wil geven.';

  @override
  String get faqQuestionFirstTargetThenAmount2 => 'Waarom kan ik enkel maar een goed doel uit de lijst selecteren?';

  @override
  String get faqAnswerFirstTargetThenAmount2 => 'Het \"geven aan een goed doel\" is splinternieuw en nog in volle opbouw. Beetje bij beetje zullen wij dus nieuwe functionaliteiten toevoegen.';

  @override
  String get setupRecurringGiftText2 => 'geven aan';

  @override
  String get setupRecurringGiftText1 => 'Ik wil graag elk(e)';

  @override
  String get setupRecurringGiftWeek => 'week';

  @override
  String get setupRecurringGiftMonth => 'maand';

  @override
  String get setupRecurringGiftQuarter => 'kwartaal';

  @override
  String get setupRecurringGiftYear => 'jaar';

  @override
  String get setupRecurringGiftWeekPlural => 'weken';

  @override
  String get setupRecurringGiftMonthPlural => 'maanden';

  @override
  String get setupRecurringGiftQuarterPlural => 'kwartalen';

  @override
  String get setupRecurringGiftYearPlural => 'jaren';

  @override
  String get menuItemRecurringDonation => 'Terugkerende giften';

  @override
  String get setupRecurringGiftHalfYear => 'half jaar';

  @override
  String get setupRecurringGiftText6 => 'keer';

  @override
  String get loginAndTryAgain => 'Gelieve in te loggen en opnieuw te proberen.';

  @override
  String givtIsBeingProcessedRecurring(Object value0, Object value1, Object value2, Object value3, Object value4) {
    return 'Bedankt voor je Givt(s) aan $value0!\n Bekijk het overzicht van je geplande Givts onder \'Overzicht\'. \n De eerste geplande Givt van $value1 $value2 zal worden afgeschreven op $value3.\n Daarna zullen we iedere $value4 afschrijven.';
  }

  @override
  String get overviewRecurringDonations => 'Terugkerende giften';

  @override
  String get titleRecurringGifts => 'Terugkerende giften';

  @override
  String get recurringGiftsSetupCreate => 'Plan je';

  @override
  String get recurringGiftsSetupRecurringGift => 'terugkerende gift';

  @override
  String get recurringDonationYouGive => 'geef je';

  @override
  String recurringDonationStops(Object value0) {
    return 'Dit stopt op $value0';
  }

  @override
  String get selectRecipient => 'Selecteer ontvanger';

  @override
  String get setupRecurringDonationFailed => 'Het instellen van de terugkerende gift is helaas niet gelukt. Probeer het later eens opnieuw.';

  @override
  String get emptyRecurringDonationList => 'Al je terugkerende giften komen hier terecht';

  @override
  String cancelRecurringDonationAlertTitle(Object value0) {
    return 'Weet je zeker dat je wil stoppen met geven aan $value0?';
  }

  @override
  String get cancelRecurringDonationAlertMessage => 'De giften die je al hebt gedaan, worden niet geannuleerd.';

  @override
  String get cancelRecurringDonation => 'Stopzetten';

  @override
  String get setupRecurringGiftText7 => 'Elk(e)';

  @override
  String get cancelRecurringDonationFailed => 'Het annuleren van de terugkerende gift is helaas niet gelukt. Probeer het later eens opnieuw.';

  @override
  String get pushnotificationRequestScreenTitle => 'Pushnotificaties';

  @override
  String get pushnotificationRequestScreenDescription => 'We sturen graag even een berichtje wanneer je volgende gift wordt afgeschreven. We hebben nu nog geen toestemming om berichten te sturen. Pas je dat even aan?';

  @override
  String get pushnotificationRequestScreenButtonYes => 'Yes, ga ik regelen';

  @override
  String get reportMissingOrganisationListItem => 'Ontbrekende organisatie melden';

  @override
  String get reportMissingOrganisationPrefilledText => 'Hallo! Ik wil heel graag geven aan:';

  @override
  String get featureRecurringDonations1Title => 'Stel je terugkerende donaties aan goede doelen in';

  @override
  String get featureRecurringDonations2Title => 'Inzicht en controle';

  @override
  String get featureRecurringDonations3Title => 'Giftenoverzicht';

  @override
  String get featureRecurringDonations1Description => 'Je kunt nu terugkerende donaties met een einddatum instellen.';

  @override
  String get featureRecurringDonations2Description => 'Bekijk welke terugkerende donaties je hebt ingesteld en stop ze wanneer jij wilt.';

  @override
  String get featureRecurringDonations3Description => 'Al je eenmalige en terugkerende donaties in één overzicht. Handig voor jezelf en voor de belastingaangifte.';

  @override
  String get featureRecurringDonations3Button => 'Laat het me zien!';

  @override
  String get featureRecurringDonationsNotification => 'Hallo! Wil je ook graag een terugkerende gift instellen met de app? Bekijk snel wat we hebben gemaakt.';

  @override
  String get setupRecurringDonationFailedDuplicate => 'Het instellen van de terugkerende gift is helaas niet gelukt. Je hebt al een gift aan deze organisatie met dezelfde herhalingsperiode.';

  @override
  String get setupRecurringDonationFailedDuplicateTitle => 'Dubbele gift';

  @override
  String get goToListWithRecurringDonationDonations => 'Overzicht';

  @override
  String get recurringDonationsEmptyDetailOverview => 'Hier komen jouw giften te staan, maar het geld moet eerst nog rollen';

  @override
  String get recurringDonationFutureDetailSameYear => 'Eerstvolgende gift';

  @override
  String get recurringDonationFutureDetailDifferentYear => 'Eerstvolgende gift in';

  @override
  String get pushnotificationRequestScreenPrimaryDescription => 'We sturen graag even een berichtje wanneer je volgende gift wordt afgeschreven. We hebben nu nog geen toestemming om berichten te sturen. Geef je toestemming?';

  @override
  String get pushnotificationRequestScreenPrimaryButtonYes => 'Oké, goed!';

  @override
  String get discoverSearchButton => 'Zoeken';

  @override
  String get discoverDiscoverButton => 'Bekijk alle';

  @override
  String get discoverSegmentNow => 'Geef';

  @override
  String get discoverSegmentWho => 'Ontdek';

  @override
  String get discoverHomeDiscoverTitle => 'Kies categorie';

  @override
  String get discoverOrAmountActionSheetOnce => 'Eénmalige gift';

  @override
  String get discoverOrAmountActionSheetRecurring => 'Terugkerende gift';

  @override
  String reccurringGivtIsBeingProcessed(Object value0) {
    return 'Bedankt voor je terugkerende gift aan $value0! \n Om alle informatie hierover te zien, ga je naar \'Terugkerende giften\' in het menu.';
  }

  @override
  String get setupRecurringGiftTextPlaceholderDate => 'dd / mm / jj';

  @override
  String get setupRecurringGiftTextPlaceholderTimes => 'x';

  @override
  String get amountLimitExceededRecurringDonation => 'Hé gulle gever, dit bedrag is hoger dan je geeflimiet. Wil je toch doorgaan of wil je je gift aanpassen?';

  @override
  String get appStoreRestart => '';

  @override
  String sepaVerifyBodyDetails(Object value0, Object value1, Object value2, Object value3) {
    return 'Naam: $value0\n Adres: $value1\n Email adres: $value2\n IBAN: $value3 \n We gebruiken de machtiging enkel wanneer je de Givt-app gebruikt om te geven';
  }

  @override
  String get sepaVerifyBody => 'Zijn deze gegevens correct? Zo niet, annuleer de registratie en verander je persoonlijke gegevens.';

  @override
  String get signMandate => 'Teken machtiging';

  @override
  String get signMandateDisclaimer => 'Bij doorgaan wordt een machtiging getekend met bovenstaande gegevens. Deze zal verstuurd worden via mail.';

  @override
  String get budgetSummaryBalance => 'Deze maand gegeven';

  @override
  String get budgetSummarySetGoal => 'Stel een streefbedrag in om jezelf te motiveren.';

  @override
  String get budgetSummaryGiveNow => 'Ik wil nu geven!';

  @override
  String get budgetSummaryGivt => 'Via Givt';

  @override
  String get budgetSummaryNotGivt => 'Niet via Givt';

  @override
  String get budgetSummaryShowAll => 'Toon alles';

  @override
  String get budgetSummaryMonth => 'Per maand';

  @override
  String get budgetSummaryYear => 'Per jaar';

  @override
  String get budgetExternalGiftsTitle => 'Donaties buiten Givt';

  @override
  String get budgetExternalGiftsInfo => 'Je overzicht is pas compleet als al je giften erin staan. Voeg toe wat je niet via Givt geeft. Je vindt alles terug in je samenvatting.';

  @override
  String get budgetExternalGiftsSubTitle => 'Donaties buiten Givt';

  @override
  String get budgetExternalGiftsOrg => 'Naam organisatie';

  @override
  String get budgetExternalGiftsTime => 'Periode';

  @override
  String get budgetExternalGiftsAmount => 'Bedrag';

  @override
  String get budgetExternalGiftsAdd => 'Toevoegen';

  @override
  String get budgetExternalGiftsSave => 'Opslaan';

  @override
  String get budgetGivingGoalTitle => 'Streefbedrag instellen';

  @override
  String get budgetGivingGoalInfo => 'Geef bewust. Weeg elke maand af of je geefgedrag past bij je persoonlijke ambities.';

  @override
  String get budgetGivingGoalMine => 'Mijn streefbedrag';

  @override
  String get budgetGivingGoalTime => 'Periode';

  @override
  String get budgetSummaryGivingGoalMonth => 'Streefbedrag per maand';

  @override
  String get budgetSummaryGivingGoalEdit => 'Streefbedrag aanpassen';

  @override
  String get budgetSummaryGivingGoalRest => 'Resterend streefbedrag';

  @override
  String get budgetSummaryGivingGoal => 'Streefbedrag:';

  @override
  String get budgetMenuView => 'Mijn persoonlijke samenvatting';

  @override
  String get budgetSummarySetGoalBold => 'Bewust geven?';

  @override
  String get budgetExternalGiftsInfoBold => 'Inzicht in wat je geeft';

  @override
  String get budgetGivingGoalInfoBold => 'Stel jezelf een doel';

  @override
  String get budgetGivingGoalRemove => 'Verwijder streefbedrag';

  @override
  String get budgetSummaryNoGifts => 'Je hebt deze maand (nog) geen giften';

  @override
  String get budgetTestimonialSummary => '”Ik heb meer inzicht in wat ik geef sinds ik de samenvatting voor al mijn giften gebruik. Ik geef hierdoor bewuster.”';

  @override
  String get budgetTestimonialGivingGoal => '”Mijn streefbedrag motiveert mij om regelmatig stil te staan bij mijn geefgedrag.”';

  @override
  String get budgetTestimonialExternalGifts => '”Ik vind het fijn dat ik mijn giften die ik niet via Givt doe in de app kan noteren. Nu kan ik makkelijk afwegen wat ik nog wil geven.”';

  @override
  String get budgetTestimonialYearlyOverview => '”Ik vind het jaaroverzicht van Givt top! Omdat ik ook giften doe buiten Givt, ben ik blij dat ik die nu ook kan toevoegen. Al mijn giften in één overzicht, super makkelijk voor mijn belastingaangifte.”';

  @override
  String get budgetPushMonthly => 'Kijk wat je tot nu toe gegeven hebt.';

  @override
  String get budgetPushYearly => 'Bekijk je jaaroverzicht en zie wat je tot nu toe al gegeven hebt.';

  @override
  String get budgetTooltipGivingGoal => 'Geef bewust. Weeg elke maand af of je geefgedrag past bij je persoonlijke ambities.';

  @override
  String get budgetTooltipExternalGifts => 'Je overzicht is pas compleet als al je giften erin staan. Voeg toe wat je niet via Givt geeft. Je vindt alles terug in deze samenvatting.';

  @override
  String get budgetTooltipYearly => 'Één overzicht voor de belastingaangifte? Bekijk hier het overzicht van al je giften.';

  @override
  String get budgetPushMonthlyBold => 'Je maandelijkse samenvatting staat klaar.';

  @override
  String get budgetPushYearlyBold => '2021 is bijna voorbij... Je balans al opgemaakt?';

  @override
  String get budgetExternalGiftsListAddEditButton => 'Beheer je externe giften';

  @override
  String get budgetExternalGiftsFrequencyOnce => 'Eenmalig';

  @override
  String get budgetExternalGiftsFrequencyMonthly => 'Elke maand';

  @override
  String get budgetExternalGiftsFrequencyQuarterly => 'Elk kwartaal';

  @override
  String get budgetExternalGiftsFrequencyHalfYearly => 'Elke 6 maanden';

  @override
  String get budgetExternalGiftsFrequencyYearly => 'Elk jaar';

  @override
  String get budgetExternalGiftsEdit => 'Wijzigen';

  @override
  String get budgetTestimonialSummaryName => 'Willem:';

  @override
  String get budgetTestimonialGivingGoalName => 'Danielle:';

  @override
  String get budgetTestimonialExternalGiftsName => 'John:';

  @override
  String get budgetTestimonialYearlyOverviewName => 'Jonathan:';

  @override
  String get budgetTestimonialSummaryAction => 'Bekijk je samenvatting';

  @override
  String get budgetTestimonialGivingGoalAction => 'Stel je streefbedrag in';

  @override
  String get budgetTestimonialExternalGiftsAction => 'Voeg externe giften toe';

  @override
  String get budgetSummaryGivingGoalReached => 'Streefbedrag behaald';

  @override
  String get budgetExternalDonationToHighAlertTitle => 'Dat is gul!';

  @override
  String get budgetExternalDonationToHighAlertMessage => 'Hé gulle gever, dit bedrag is hoger dan wat we hier nu voorzien. Kies een lager bedrag of laat ons weten dat we dit maximum van 99 999 moeten aanpassen!';

  @override
  String get budgetExternalDonationToLongAlertTitle => 'Da\'s lang!';

  @override
  String get budgetExternalDonationToLongAlertMessage => 'Hold your horses! Je kunt hier maximaal 30 tekens invullen.';

  @override
  String get budgetSummaryNoGiftsExternal => 'Donaties buiten Givt? Voeg ze hier toe';

  @override
  String get budgetYearlyOverviewGivenThroughGivt => 'Totaal via Givt';

  @override
  String get budgetYearlyOverviewGivenThroughNotGivt => 'Totaal niet via Givt';

  @override
  String get budgetYearlyOverviewGivenTotal => 'Totaal';

  @override
  String get budgetYearlyOverviewGivenTotalTax => 'Totaal ANBI';

  @override
  String get budgetYearlyOverviewDetailThroughGivt => 'Via Givt';

  @override
  String get budgetYearlyOverviewDetailAmount => 'Bedrag';

  @override
  String get budgetYearlyOverviewDetailDeductable => 'Aftrekbaar';

  @override
  String get budgetYearlyOverviewDetailTotal => 'Totaal';

  @override
  String get budgetYearlyOverviewDetailTotalDeductable => 'Totaal belastingsaftrekbaar';

  @override
  String get budgetYearlyOverviewDetailNotThroughGivt => 'Niet via Givt';

  @override
  String get budgetYearlyOverviewDetailTotalThroughGivt => '(via Givt)';

  @override
  String get budgetYearlyOverviewDetailTotalNotThroughGivt => '(niet via Givt)';

  @override
  String get budgetYearlyOverviewDetailTipBold => 'TIP: voeg je externe giften toe';

  @override
  String get budgetYearlyOverviewDetailTipNormal => 'om een volledig overzicht te krijgen van wat je geeft, zowel via de Givt-app als niet via de Givt-app.';

  @override
  String get budgetYearlyOverviewDetailReceiveViaMail => 'Per mail ontvangen';

  @override
  String get budgetYearlyOverviewDownloadButton => 'Download jaaroverzicht';

  @override
  String get budgetExternalDonationsTaxDeductableSwitch => 'Aftrekbaar voor de belastingen';

  @override
  String get budgetYearlyOverviewGivingGoalPerYear => 'Streefbedrag per jaar';

  @override
  String get budgetYearlyOverviewGivenIn => 'Gegeven in';

  @override
  String get budgetYearlyOverviewRelativeTo => 'Ten opzichte van totaal';

  @override
  String get budgetYearlyOverviewVersus => 'Tegenover';

  @override
  String get budgetYearlyOverviewPerOrganisation => 'Per organisatie';

  @override
  String get budgetSummaryNoGiftsYearlyOverview => 'Je hebt dit jaar (nog) geen giften';

  @override
  String budgetPushYearlyNearlyEndBold(Object value0) {
    return '$value0 is bijna voorbij... Je balans al opgemaakt?';
  }

  @override
  String get budgetPushYearlyNearlyEnd => 'Bekijk je jaaroverzicht en zie wat je tot nu toe gegeven hebt.';

  @override
  String get budgetPushYearlyNewYearBold => 'Gelukkig Nieuwjaar! Je balans al opgemaakt?';

  @override
  String get budgetPushYearlyNewYear => 'Bekijk je jaaroverzicht en zie wat je het afgelopen jaar gegeven hebt.';

  @override
  String get budgetPushYearlyFinalBold => 'Je jaaroverzicht is nu finaal!';

  @override
  String get budgetPushYearlyFinal => 'Bekijk je jaaroverzicht en zie wat je het afgelopen jaar gegeven hebt.';

  @override
  String get budgetTestimonialYearlyOverviewAction => 'Ga naar het overzicht';

  @override
  String get duplicateAccountOrganisationMessage => 'Weet je zeker dat je jouw persoonlijke rekeningnummer gebruikt? Controleer even in het menu onder \'Mijn gegevens\'. Daar kun je je gegevens ook aanpassen.';

  @override
  String get usRegistrationCreditCardDetailsNumberPlaceholder => 'Creditcard nummer';

  @override
  String get usRegistrationCreditCardDetailsExpiryDatePlaceholder => 'MM/YY';

  @override
  String get usRegistrationCreditCardDetailsSecurityCodePlaceholder => 'CVV';

  @override
  String get usRegistrationPersonalDetailsPhoneNumberPlaceholder => 'Mobiel nummer (+1)';

  @override
  String get usRegistrationPersonalDetailsPasswordPlaceholder => 'Paswoord';

  @override
  String get usRegistrationPersonalDetailsFirstnamePlaceholder => 'Voornaam';

  @override
  String get usRegistrationPersonalDetailsLastnamePlaceholder => 'Achternaam';

  @override
  String get usRegistrationTaxTitle => 'We hebben nog enkele details nodig voor je jaarlijkse samenvatting.';

  @override
  String get usRegistrationTaxSubtitle => 'Je naam en postcode worden enkel gebruikt om de samenvatting aan te maken. Standaard blijf je anoniem voor de ontvanger.';

  @override
  String get policyTextUs => 'Latest Amendment: [13-03-2023]\n Version [1.1]\n Givt Inc. Privacy Policy  \n \n\n Introduction\n This Privacy Policy outlines Givt Inc.’s (“we,” “our,” or “the Company”) practices with respect to information collected from our Application\n (“App”) or from users that otherwise share personal information with us (collectively: “Users”). Click here for the Terms of Use that apply when you use the Givt app.\n \n\n Grounds for data collection\n Processing of your personal information (meaning, any information relating to an identified or identifiable individual; hereinafter “Personal\n Information”) is necessary for the performance of our contractual obligations towards you and providing you with our services, to protect\n our legitimate interests and for compliance with legal and financial regulatory obligations to which we are subject.\n When you use our App or register yourself or an organization you represent with us, you consent to the collection, storage, use, disclosure and other uses of your Personal Information as described in this Privacy Policy.\n We encourage our Users to carefully read the Privacy Policy and use it to make informed decisions.\n \n\n What information do we collect?\n We collect two types of data and information from Users. The first type of information is un-identified and non-identifiable information pertaining to a User(s), which may be made available or gathered via your use of the App (“Non-personal Information”). We are not aware of the identity of a User from which the Non-personal Information was collected. Non-personal Information which is being collected may include your aggregated usage information and technical information transmitted by your device, including certain software and\n hardware information (e.g. language preference, access time, etc.) in order to enhance the functionality of our App.\n The second type of information is Personal Information, which is personally identifiable information, namely information that identifies an\n individual or may with reasonable effort identify an individual. Such information includes:\n ● Device Information: We collect Personal Information from your device. Such information includes geolocation data, IP address, unique identifiers (e.g. MAC address and UUID) and other information which relates to your activity through the App.\n ● Service User Information: We collect additional information for individuals who would like to use our Services. This is gathered\n through the App and includes all the information needed to register for our service:\n – Name and address,\n – Date of birth,\n – email address,\n – secured password details, and\n – bank details for the purposes of making payments.\n ● Contact information: If you choose to contact us you will be asked to provide us with certain details such as: full name; e-mail or physical address, and other relevant information. This may be for yourself or for people in the organization you represent.\n \n\n \n\n How do we receive information about you?\n \n\n We receive your Personal Information from various sources:\n \n\n ● When you voluntarily provide us with your personal details in order to register on our App;\n ● When you use or access our App in connection with your use of our services;\n When you use or access our Dashboard in connection with your organization’s use of our services;\n ● From third party providers, services and public registers (for example, traffic analytics vendors); and,\n ● Through diagnostic information from the App. The App will send us anonymous information about its functioning. This information contains non-personal data from your smartphone like its type and operating system, but also the version information of the App. This data is solely used for purposes of improving our Service or allowing better responses to your questions.\n What do we do with the information we collect?\n We may use the information for the following:\n ● To provide the services through the App – we will use a minimum of name and bank details to perform the services of effecting payment(s) via the App. Payment information is never shared with intended recipients of donations;\n ● Communicating with you – sending you notices regarding our services, providing you with technical information and responding to\n any customer service issue you may have; to keep you informed of our latest updates and services;\n ● Conducting statistical and analytical activities, intended to improve the App and/or the App.\n ● For marketing and advertising purposes, such as developing and providing promotional and advertising materials that may be relevant,\n valuable or otherwise of interest to you.\n In addition to the different uses listed above, we may transfer or disclose Personal Information to our subsidiaries, affiliated companies and subcontractors in relation to services that we provide to you. We may also disclose information if we have good faith to believe that\n disclosure of such information is helpful or reasonably necessary to: (i) comply with any applicable law, regulation, legal process or governmental request; (ii) enforce our policies (including our Agreement), including investigations of potential violations thereof; (iii) investigate, detect, prevent, or take action regarding illegal activities or other wrongdoing, suspected fraud or security issues; (iv) to establish or exercise our rights to defend against legal claims; (v) prevent harm to the rights, property or safety of us, our users, yourself or any third party; or (vi) for the purpose of collaborating with law enforcement agencies and/or in case we find it necessary in order to enforce intellectual property or other legal rights.\n \n\n \n\n Providing Data to Third Parties\n When you make a donation, personal information about you, your name, the amount, campaign and email address is shared with the intended recipient of your donation. In some cases, you may have the option to remain anonymous. If you choose to remain anonymous, your personal information will not be shared with the intended recipient of your donation.\n We may provide your information to our partners. For example, we may share any information we receive with vendors and service providers retained in connection with the provision of the App. If you use the App to make a donation, your payment-related information, such as credit card or other financial information, is collected by our third-party payment processor on our behalf. In all cases, these parties are necessary to provide the services.\n We may collect, use, and share anonymous data for statistical purposes, reviews, and comparisons; no such data will be traceable to individuals.\n We are committed to making it easier for donors to give to charities of their choosing, and we will never sell data to third parties.\n We may access, preserve, and disclose your information if we believe doing so is required or appropriate to: (a) comply with law enforcement requests and legal process, such as a court order or subpoena; (b) respond to your requests; or (c) protect your, our, or others’ rights, property, or safety.\n We may transfer your information to service providers, advisors, potential transactional partners, or other third parties in connection with the consideration, negotiation, or completion of a corporate transaction in which we are acquired by or merged with another company or we sell, liquidate, or transfer all or a portion of our assets. The use of your information following any of these events will be governed by the provisions of this Privacy Policy in effect at the time the applicable information was collected.\n We may also disclose your information with your permission.\n \n\n User Rights\n You may request to:\n 1.Receive confirmation as to whether or not personal information concerning you is being processed, and access your stored personal information, together with supplementary information.\n 2.Receive a copy of personal information you directly volunteer to us in a structured, commonly used and machine-readable format.\n 3.Request rectification of your personal information that is in our control.\n 4.Request erasure of your personal information.\n 5.Object to the processing of personal information by us.\n 6.Request portability of your personal information.\n 7.Request to restrict processing of your personal information by us.\n 8.Lodge a complaint with a supervisory authority.\n \n\n However, please note that these rights are not absolute, and may be subject to our own legitimate interests and regulatory requirements.\n Before fulfilling your request, we may ask you to provide reasonable information to verify your identity.\n \n\n Retention\n We will retain your personal information for as long as necessary to provide our services, and as necessary to comply with our legal\n obligations, resolve disputes, and enforce our policies. Retention periods will be determined taking into account the type of information that is collected and the purpose for which it is collected, bearing in mind the requirements applicable to \n Use of Location Services\n The App may use the location services as provided by the operating system on the smartphone. With these services, the App may determine the location of the user. The location data will not be sent anywhere outside the smartphone, and is solely used to determine whether the user is in a location where it’s possible to use the App for donating. The locations where one can use App are downloaded to the smartphone prior to using the location services.\n \n\n How do we safeguard your information?\n We take security measures to reduce misuse of and unauthorized access to personal data. Although we take reasonable steps to safeguard information, we cannot be responsible for the acts of those who gain unauthorized access or abuse our App, and we make no warranty, express, implied or otherwise, that we will prevent such access.\n \n\n Transfer of data outside the EEA\n Please note that some data recipients may be located outside the EEA. In such cases we will transfer your data only to such countries as approved by the European Commission as providing adequate level of data protection, or enter into legal agreements ensuring an adequate level of data protection. Data collected from Users located in the United States is stored in the United States.\n \n\n Advertisements\n We do not use third-party advertising technology to serve advertisements when you access the App.\n \n\n Marketing\n We may use your Personal Information, such as your name, email address to send you a Newsletter about our products and services. You may opt out of receiving this Newsletter at any time by unsubscribing via the link in the newsletter.\n Children’s Privacy\n We do not knowingly collect, maintain, or use personal information from children under 13 years of age, and no part of our App is directed to children. If you learn that a child has provided us with personal information in violation of this Privacy Policy, then you may alert us at\n support@givt.app.\n Third Parties\n The App may contain links to other websites, products, or services that we do not own or operate. We are not responsible for the privacy\n practices of these third parties. Please be aware that this Privacy Policy does not apply to your activities on these third-party services or any information you disclose to these third parties. We encourage you to read their privacy policies before providing any information to them.\n \n\n Updates or amendments to this Privacy Policy\n We reserve the right to periodically amend or revise the Privacy Policy; material changes will be effective immediately upon the display of the revised Privacy policy. The last revision will be reflected in the “Last modified” section. If we materially change the ways in which we use or share personal information collected from you, we will notify you through the App, by email, or other communication. Your continued use of our Services following the notification of such amendments on our Website or through the App, constitutes your acknowledgment and consent of such amendments to the Privacy Policy and your agreement to be bound by the terms of such amendments.\n \n\n How to contact us\n If you have any general questions about the App or the information we collect about you and how we use it, you can contact us at:\n support@givt.app or by phone at +1 918-615-9611.';

  @override
  String get termsTextUs => 'GIVT Inc.\n \n\n Terms of use – Givt app \n Last updated: 20-01-2022\n Version: 1.0\n \n\n 1.  General \n These terms of use describe the conditions under which the mobile application Givt (\"Givt\") can be utilised. Givt allows the User (anonymously) to give donations through their smartphone, for example churches, fundraising campaigns or charities that are members of Givt Inc.\n \n\n These terms of use apply to the use of Givt. Through the use of Givt (which means the download and the installation thereof), you (\"the User\") accept these terms of use and our privacy policy (https://givt.app/privacy-policy). These terms of use and our privacy policy are also available on our website to download and print. We may revise these terms of use from time to time.';

  @override
  String get termsTextUsVersion => '1';

  @override
  String get informationAboutUsUs => 'Givt is a product of Givt Inc\n \n\n We are located in the Atlanta Financial Center, 3343 Peachtree Rd NE Ste 145-1032, Atlanta, GA 30326. For questions or complaints you can reach us via +1 918-615-9611 or support@givt.app\n \n\n We are incorporated in Delaware.';

  @override
  String get faQantwoord0Us => 'In the app-menu under \"About Givt / Contact\" there\'s a text field where you can type a message and send it to us. Of course you can also contact us by calling +1 918-615-9611 or by sending an e-mail to support@givt.app .';

  @override
  String get usRegistrationPersonalDetailsPostalCodePlaceholder => 'Postcode';

  @override
  String amountPresetsErrMinAmount(Object value0) {
    return 'Het bedrag moet minstens $value0 zijn';
  }

  @override
  String get unregisterInfoUs => 'We’re sad to see you go!';

  @override
  String get invalidQRcodeTitle => 'QR-code niet actief';

  @override
  String invalidQRcodeMessage(Object value0) {
    return 'Helaas, deze QR-code is niet meer actief. Wil je toch graag geven aan de algemene collecte van $value0?';
  }

  @override
  String get errorOccurred => 'Er is een fout opgetreden';

  @override
  String get registrationErrorTitle => 'Registratie kan niet worden voltooid';

  @override
  String get noDonationsFoundOnRegistrationMessage => 'We konden geen donaties ophalen maar hebben minstens één donatie nodig om je registratie af te ronden. Neem contact met ons op via Over Givt/Contact in het menu of op het e-mailadres support@givt.app.';

  @override
  String get cantCancelAlreadyProcessed => 'Helaas kan je deze gift niet meer annuleren omdat deze al verwerkt is.';

  @override
  String get shareDataSwitch => 'I want to share the necessary personal data with the organisation I donate to, so I can receive a tax statement.';

  @override
  String get shareDataInfo => 'When you enable this option, you agree to share your personal information. With this information, the organisation that receives your donation will be able to provide you with a tax statement.';

  @override
  String get shareDataDisclaimer => 'When you disable this option, your donations will remain anonymous for that organisation.';

  @override
  String get shareDataAlertTitle => 'Do you want a tax statement?';

  @override
  String get shareDataAlertMessage => 'To receive a tax statement, you need to share your personal information with the organisation you donate to.';

  @override
  String get countryStringUs => 'Amerika';

  @override
  String get enterPaymentDetails => 'Enter Payment Details';

  @override
  String get moreInformationAboutStripe => 'More Information About Stripe';

  @override
  String get moreInformationAboutStripeParagraphOne => 'We do not save or process credit card details directly; all payment transactions are securely handled by our trusted third-party payment gateway, Stripe.';

  @override
  String get moreInformationAboutStripeParagraphTwo => 'In your user profile, we only display the last four digits and brand of your credit card for reference purposes, and your credit card information is never stored in our system. For more information on how we handle your personal data and ensure its security, please refer to our privacy policy.';

  @override
  String get addTermExample => 'Here I put in text';

  @override
  String get vpcErrorText => 'Cannot get VPC. Please try again later.';

  @override
  String get vpcSuccessText => 'Now you have given VPC, let’s get your children\'s profiles set up!';

  @override
  String get setupChildProfileButtonText => 'Set up child profile(s)';

  @override
  String get vpcIntroFamilyText => 'We’ve made it easy for your children to take part in giving.\n\nIf you have multiple children, set up all your child profiles now. If you come out of the app you will need to give verifiable permission again.';

  @override
  String get enterCardDetailsButtonText => 'Enter card details';

  @override
  String get vpcIntroSafetyText => 'Before you create your child’s profile, we must obtain verifiable parental consent. This is achieved by making a \$1 transaction when you enter your card details.';

  @override
  String get seeDirectNoticeButtonText => 'See our direct notice';

  @override
  String get directNoticeText => 'Givt Direct Notice to Parents  \nIn order to allow your child to use Givt, an application through which younger users can direct donations, linked to and controlled by your Givt account, we have collected your online contact information, as well as your and your child’s name, for the purpose of obtaining your consent to collect, use, and disclose personal information from your child. \nParental consent is required for Givt to collect, use, or disclose your child\'s personal information. Givt will not collect, use, or disclose personal information from your child if you do not provide consent. As a parent, you provide your consent by completing a nominal payment card charge in your account on the Givt app. If you do not provide consent within a reasonable time, Givt will delete your information from its records, however Givt will retain any information it has collected from you as a standard Givt user, subject to Givt’s standard privacy policy www.givt.app/privacy-policy/ \nThe Givt Privacy Policy for Children Under the Age of 13 www.givt.app/privacy-policy-givt4kids/ provides details regarding how and what personal information we collect, use, and disclose from children under 13 using Givt (the “Application”). \nInformation We Collect from Children\nWe only collect as much information about a child as is reasonably necessary for the child to participate in an activity, and we do not condition his or her participation on the disclosure of more personal information than is reasonably necessary.  \nInformation We Collect Directly \nWe may request information from your child, but this information is optional. We specify whether information is required or optional when we request it. For example, if a child chooses to provide it, we collect information about the child’s choices and preferences, the child’s donation choices, and any good deeds that the child records. \nAutomatic Information Collection and Tracking\nWe use technology to automatically collect information from our users, including children, when they access and navigate through the Application and use certain of its features. The information we collect through these technologies may include: \nOne or more persistent identifiers that can be used to recognize a user over time and across different websites and online services, such as IP address and unique identifiers (e.g. MAC address and UUID); and,\nInformation that identifies a device\'s location (geolocation information).\nWe also may combine non-personal information we collect through these technologies with personal information about you or your child that we collect online.  \nHow We Use Your Child\'s Information\nWe use the personal information we collect from your child to: \nfacilitate donations that your child chooses;\ncommunicate with him or her about activities or features of the Application,;\ncustomize the content presented to a child using the Application;\nRecommend donation opportunities that may be of interest to your child; and,\ntrack his or her use of the Application. \nWe use the information we collect automatically through technology (see Automatic Information Collection and Tracking) and other non-personal information we collect to improve our Application and to deliver a better and more personalized experience by enabling us to:\nEstimate our audience size and usage patterns.\nStore information about the child\'s preferences, allowing us to customize the content according to individual interests.\nWe use geolocation information we collect to determine whether the user is in a location where it’s possible to use the Application for donating. \nOur Practices for Disclosing Children\'s Information\nWe may disclose aggregated information about many of our users, and information that does not identify any individual or device. In addition, we may disclose children\'s personal information:\nTo third parties we use to support the internal operations of our Application.\nIf we are required to do so by law or legal process, such as to comply with any court order or subpoena or to respond to any government or regulatory request.\nIf we believe disclosure is necessary or appropriate to protect the rights, property, or safety of Givt, our customers or others, including to:\nprotect the safety of a child;\nprotect the safety and security of the Application; or\nenable us to take precautions against liability.\nTo law enforcement agencies or for an investigation related to public safety. \nIf Givt is involved in a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of Givt\'s assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding or event, we may transfer the personal information we have collected or maintain to the buyer or other successor. \nSocial Features \nThe Application allows parents to view information about their child’s donation activities and any good deeds that the child records, and parents may provide certain responses to this information. \nAccessing and Correcting Your Child\'s Personal Information\nAt any time, you may review the child\'s personal information maintained by us, require us to correct or delete the personal information, and/or refuse to permit us from further collecting or using the child\'s information.  \nYou can review, change, or delete your child\'s personal information by:\nLogging into your account and accessing the profile page relating to your child.\nSending us an email at support@givt.app. To protect your and your child’s privacy and security, we may require you to take certain steps or provide additional information to verify your identity before we provide any information or make corrections. \nOperators That Collect or Maintain Information from Children\nGivt Inc. is the operator that collects and maintains personal information from children through the Application.Givt can be contacted at support@givt.app, by mail at 100 S Cincinnati Ave, Fifth Floor, Tulsa, OK 74103. , or by phone at +1 918-615-9611.';

  @override
  String get familyMenuItem => 'Family';

  @override
  String get mobileNumberUsDigits => '1231231234';

  @override
  String get createChildNameErrorTextFirstPart1 => 'Name must be at least ';

  @override
  String get createChildNameErrorTextFirstPart2 => ' characters.';

  @override
  String get createChildDateErrorText => 'Please select date of birth.';

  @override
  String get createChildAllowanceErrorText => 'Giving allowance must be greater than zero.';

  @override
  String get createChildErrorText => 'Cannot create child profile. Please try again later.';

  @override
  String get createChildGivingAllowanceInfoButton => 'More about giving allowance';

  @override
  String get createChildPageTitle => 'Please enter some information about your child';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get createChildGivingAllowanceHint => 'Giving allowance';

  @override
  String get createChildProfileButton => 'Create child profile';

  @override
  String get createChildGivingAllowanceTitle => 'Recurring Giving Allowance';

  @override
  String get createChildGivingAllowanceText => 'Empower your child with the joy of giving by setting up a Monthly Giving Allowance. This not only fosters a habit of generosity but also imparts important financial skills.\n\nFunds will be added to your child\'s wallet immediately upon set up and replenished monthly, enabling them to learn about budgeting and decision-making while experiencing the fulfilment of making a difference.\n\nShould you wish to stop the giving allowance please reach out to us at support@givt.app';

  @override
  String get createChildAddProfileButton => 'Add child profile';

  @override
  String get childOverviewTotalAvailable => 'Total available:';

  @override
  String get childOverviewPendingApproval => 'Pending approval:';

  @override
  String get vpcSuccessTitle => 'Great!';

  @override
  String get cannotSeeAllowance => 'Cannot see the giving allowance? ';

  @override
  String get allowanceTakesTime => 'It can take a couple hours to be processed through our system.';

  @override
  String get childInWalletPostfix => ' in Wallet';

  @override
  String get childNextTopUpPrefix => 'The next top up: ';

  @override
  String get childEditProfileErrorText => 'Cannot update child profile. Please try again later.';

  @override
  String get childEditProfile => 'Edit Profile';

  @override
  String get childMonthlyGivingAllowanceRange => 'Monthly giving allowance can be an amount between \$1 to \$999.';

  @override
  String get childrenMyFamily => 'My Family';

  @override
  String get childHistoryBy => 'by';

  @override
  String get childHistoryTo => 'to';

  @override
  String get childHistoryToBeApproved => 'To be approved';

  @override
  String get childHistoryCanContinueMakingADifference => 'can continue making a difference';

  @override
  String get childHistoryYay => 'Yay!';

  @override
  String get childHistoryAllGivts => 'All givts';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String childParentalApprovalApprovedTitle(Object value0) {
    return 'Yes, $value0 has made a difference!';
  }

  @override
  String get childParentalApprovalApprovedSubTitle => 'Thank you';

  @override
  String childParentalApprovalConfirmationTitle(Object value0) {
    return '$value0 would love to give';
  }

  @override
  String childParentalApprovalConfirmationSubTitle(Object value0, Object value1) {
    return 'to $value0\n$value1';
  }

  @override
  String get childParentalApprovalConfirmationDecline => 'Decline';

  @override
  String get childParentalApprovalConfirmationApprove => 'Approve';

  @override
  String childParentalApprovalDeclinedTitle(Object value0) {
    return 'You have declined $value0’s request';
  }

  @override
  String get childParentalApprovalDeclinedSubTitle => 'Maybe next time?';

  @override
  String get childParentalApprovalErrorTitle => 'Oops, something went wrong!';

  @override
  String get childParentalApprovalErrorSubTitle => 'Please try again later';

  @override
  String get signUpPageTitle => '';

  @override
  String get downloadKey => 'Download';

  @override
  String get surname => 'Achternaam';

  @override
  String get goodToKnow => 'Good to know';

  @override
  String get childKey => 'Child';

  @override
  String get parentKey => 'Parent';

  @override
  String get pleaseEnterChildName => 'Please enter the child\'s name';

  @override
  String get pleaseEnterChildAge => 'Please enter the child\'s age';

  @override
  String get pleaseEnterValidName => 'Please enter a valid name';

  @override
  String get nameTooLong => 'Name is too long';

  @override
  String get pleaseEnterValidAge => 'Please enter a valid age';

  @override
  String get addAdultInstead => 'Please add an adult instead';

  @override
  String get ageKey => 'Age';

  @override
  String get setUpFamily => 'Set up Family';

  @override
  String get whoWillBeJoiningYou => 'Who will be joining you?';

  @override
  String get congratulationsKey => 'Congratulations';

  @override
  String get g4kKey => 'Givt4Kids';

  @override
  String get childrenCanExperienceTheJoyOfGiving => 'so your children can\nexperience the joy of giving!';

  @override
  String get iWillDoThisLater => 'I will do this later';

  @override
  String get oneLastThing => 'One last thing\n';

  @override
  String get vpcToEnsureItsYou => 'To ensure it\'s really you, we\'ll collect\n';

  @override
  String get vpcCost => '\$0.50';

  @override
  String get vpcGreenLightChildInformation => ' from your card.\n\nThis gives us the green light to securely\n collect your child\'s information.';

  @override
  String get addMember => 'Add member';

  @override
  String get addAnotherMember => '+ Add another member';

  @override
  String get emptyChildrenDonations => 'Your children\'s donations\nwill appear here';

  @override
  String get holdOnRegistration => 'Hold on, we are creating your account...';

  @override
  String get holdOnSetUpFamily => 'Please hang tight while we set up your\nfamily space...';

  @override
  String get seeMyFamily => 'See My Family';

  @override
  String get membersAreAdded => 'Members are added!';

  @override
  String get vpcNoFundsWaiting => 'Waiting...';

  @override
  String get vpcNoFundsSorry => 'Sorry';

  @override
  String get vpcNoFundsError => 'We still couldn\'t take the funds from your bank account. Please check your balance and try again.';

  @override
  String get vpcNoFundsAlmostDone => 'Almost done...';

  @override
  String get vpcNoFundsInitial => 'Your payment method has been declined. Check with your bank and try again.';

  @override
  String get vpcNoFundsTrying => 'Trying to collect funds...';

  @override
  String get vpcNoFundsWoohoo => 'Woohoo!';

  @override
  String get vpcNoFundsSuccess => 'Nice job! We can now collect the \$0.50 for verification and add the funds to your child\'s giving allowance.';

  @override
  String get vpcNoFundsInfo1 => 'We couldn\'t take the ';

  @override
  String get vpcNoFundsInfo2 => '\$0.50';

  @override
  String get vpcNoFundsInfo3 => ' for verification and the ';

  @override
  String get vpcNoFundsInfo4 => ' for your child\'s giving allowance from your bank account. Please check your balance and try again.';

  @override
  String get almostDone => 'Almost done...';

  @override
  String get weHadTroubleGettingAllowance => 'We had trouble getting money from your account for the giving allowance(s).';

  @override
  String get noWorriesWeWillTryAgain => 'No worries, we will try again tomorrow!';

  @override
  String get allowanceOopsCouldntGetAllowances => 'Oops! We couldn\'t get the allowance amount from your account.';

  @override
  String get weWillTryAgainTmr => 'We will try again tomorrow';

  @override
  String get weWillTryAgainNxtMonth => 'We will try again next month';

  @override
  String get editChildWeWIllTryAgain => 'We will try again on: ';

  @override
  String get editChildAllowancePendingInfo => 'You will be able to edit the allowance once the pending issue is resolved.';

  @override
  String get familyGoalStepperCause => '1. Cause';

  @override
  String get familyGoalStepperAmount => '2. Amount';

  @override
  String get familyGoalStepperConfirm => '3. Confirm';

  @override
  String familyGoalCircleMore(Object value0) {
    return '+$value0 more';
  }

  @override
  String get familyGoalOverviewTitle => 'Create a Family Goal';

  @override
  String get familyGoalConfirmationTitle => 'Launch the Family Goal';

  @override
  String get familyGoalCauseTitle => 'Find a cause';

  @override
  String get familyGoalAmountTitle => 'Set your giving goal';

  @override
  String get familyGoalStartMakingHabit => 'Start making giving a habit in your family';

  @override
  String get familyGoalCreate => 'Create';

  @override
  String get familyGoalConfirmedTitle => 'Family Goal launched!';

  @override
  String get familyGoalToSupport => 'to support';

  @override
  String get familyGoalShareWithFamily => 'Share this with your family and make a difference together';

  @override
  String get familyGoalLaunch => 'Launch';

  @override
  String get familyGoalHowMuch => 'How much do you want to raise?';

  @override
  String get familyGoalAmountHint => 'Most families start out with an amount of \$100';

  @override
  String get certExceptionTitle => 'A little hiccup';

  @override
  String get certExceptionBody => 'We couldn\'t connect to the server. But no worries, try again later and we\'ll get things sorted out!';

  @override
  String get yourFamilyGoalKey => 'Your Family Goal';

  @override
  String get familyGoalPrefix => 'Family Goal: ';

  @override
  String get editPaymentDetailsSuccess => 'Successfully updated!';

  @override
  String get editPaymentDetailsFailure => 'Ooops...\nSomething went wrong!';

  @override
  String get editPaymentDetailsCanceled => 'Payment details update was cancelled.';

  @override
  String permitBiometricQuestionWithType(Object value0) {
    return 'Wil je gebruik maken van $value0?';
  }

  @override
  String get permitBiometricExplanation => 'Versnel het inlogproces en houd je account veilig';

  @override
  String get permitBiometricSkip => 'Overslaan';

  @override
  String permitBiometricActivateWithType(Object value0) {
    return 'Activeer $value0';
  }

  @override
  String get addAdultMemberDescriptionTitle => 'The parent wil be invited to join the Family. They will be able to:';

  @override
  String get addAdultMemberDescriptionItem1 => 'Login to Givt';

  @override
  String get addAdultMemberDescriptionItem2 => 'Approve donations of the children';

  @override
  String get addAdultMemberDescriptionItem3 => 'Make an impact together';

  @override
  String get joinImpactGroupCongrats => 'Congrats, you’re in!\n';

  @override
  String get youHaveBeenInvitedToImpactGroup => 'You have been invited\nto the ';

  @override
  String get acceptInviteKey => 'Accept the invite';

  @override
  String get about => 'About';

  @override
  String get familyGroup => 'Family Group';

  @override
  String get goal => 'Goal';

  @override
  String theFamilyWithName(Object value0) {
    return 'The $value0';
  }

  @override
  String get members => 'members';

  @override
  String get completedLabel => 'Completed!';

  @override
  String get chooseGroup => 'Choose Group';

  @override
  String get oopsNoNameForOrganisation => 'Oops, did not get a name for the goal.';

  @override
  String get groups => 'Groups';

  @override
  String get yourFamilyGroupWillAppearHere => 'Your Family Group and other\ngroups will appear here';

  @override
  String get genericSuccessTitle => 'Consider it done!';

  @override
  String monthlyAllowanceEditSuccessDescription(Object value0) {
    return 'Your child will receive $value0 each month. You can edit this amount any time.';
  }

  @override
  String get editGivingAllowanceDescription => 'Which amount should be added to your child’s Wallet each month?';

  @override
  String get editGivingAllowanceHint => 'Choose an amount between \$1 to \$999.';

  @override
  String get topUp => 'Top Up';

  @override
  String get topUpCardInfo => 'Add a one-time amount to your\nchild\'s Wallet';

  @override
  String get topUpScreenInfo => 'How much would you like to add to\nyour child\'s Wallet?';

  @override
  String get topUpFundsFailureText => 'We are having trouble getting the\nfunds from your card.\nPlease try again.';

  @override
  String topUpSuccessText(Object value0) {
    return '$value0 has been added to\nyour child’s Wallet';
  }

  @override
  String get plusAddMembers => '+ Add members';
}
