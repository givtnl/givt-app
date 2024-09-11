import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get ibanPlaceHolder => 'IBAN';

  @override
  String get amountLimitExceeded => 'Dieser Betrag ist höher als dein gewählter Maximalbetrag. Bitte pass den Maximalbetrag an oder wähle einen niedrigeren Betrag.';

  @override
  String get belgium => 'Belgien';

  @override
  String get insertAmount => 'Weißt du, wieviel du spenden möchtest? Dann wähle einen Betrag.';

  @override
  String get netherlands => 'Niederlande';

  @override
  String get notificationTitle => 'Givt';

  @override
  String get selectReceiverTitle => 'Empfänger auswählen';

  @override
  String get slimPayInformation => 'Wir möchten, dass du Givt so einfach wie möglich nutzen kannst.';

  @override
  String get savingSettings => 'Lehn dich zurück und entspann dich, wir speichern derweil die Einstellungen.';

  @override
  String get continueKey => 'Continue';

  @override
  String get slimPayInfoDetail => 'Givt arbeitet bei der Ausführung der Transaktionen mit SlimPay zusammen. SlimPay ist spezialisiert auf die Abwicklung von Mandaten und automatischen Geldüberweisungen auf digitalen Plattformen. SlimPay führt diese Aufträge für Givt zu den niedrigsten Preisen auf diesem Markt und mit hoher Geschwindigkeit aus.\n \n\n SlimPay ist ein idealer Partner für Givt, weil sie das bargeldlose Spenden sehr einfach und sicher machen. Als Zahlungsdienstleister werden sie von der Nederlandsche Bank und anderen europäischen Nationalbanken beaufsichtigt.\n \n\n Das Geld wird auf einem SlimPay-Konto gesammelt. \n Givt wird sicherstellen, dass das Geld korrekt ausgegeben wird.';

  @override
  String get slimPayInfoDetailTitle => 'Was ist SlimPay`';

  @override
  String get continueRegistration => 'Dein Benutzerkonto wurde bereits angelegt,\n aber es war leider nicht möglich\n die Registrierung abzuschließen.\n \n\n Wir möchten dir gern dabei helfen, Givt zu nutzen, \n daher bitten wir dich, sich nochmals einzuloggen,\n um die Registrierung abzuschließen.';

  @override
  String get contactFailedButton => 'Nicht geklappt?';

  @override
  String get unregisterButton => 'Meinen Account schließen';

  @override
  String get unregisterUnderstood => 'Ich verstehe';

  @override
  String givtIsBeingProcessed(Object value0) {
    return 'Danke für deine Spende an $value0!\n Den Status kannst du in der Übersicht überprüfen.';
  }

  @override
  String get offlineGegevenGivtMessage => 'Vielen Dank für deine Spende!\n \n\n Sobald es wieder eine gute Verbindung mit dem Givt-Server gibt, wird deine Spende verarbeitet.\n Den Status kannst du jederzeit in der Übersicht überprüfen.';

  @override
  String offlineGegevenGivtMessageWithOrg(Object value0) {
    return 'Vielen Dank für deine Spende an $value0!\n \n\n Sobald es wieder eine gute Verbindung mit dem Givt-Server gibt, wird deine Spende verarbeitet.\n Den Status kannst du jederzeit in der Übersicht überprüfen.';
  }

  @override
  String get pincode => 'PIN';

  @override
  String get pincodeTitleChangingPin => 'Hier kannst du das Passwort anpassen, welches für den Login der Givt App verwendet wird.';

  @override
  String get pincodeChangePinMenu => 'PIN ändern';

  @override
  String get pincodeSetPinTitle => 'PIN festlegen';

  @override
  String get pincodeSetPinMessage => 'Leg deine PIN hier fest';

  @override
  String get pincodeEnterPinAgain => 'Gib deine PIN nochmals ein';

  @override
  String get pincodeDoNotMatch => 'Die PINs stimmen nicht überein. Bitte versuch es nochmals.';

  @override
  String get pincodeSuccessfullTitle => 'Jetzt hat es geklappt!';

  @override
  String get pincodeSuccessfullMessage => 'Deine PIN wurde erfolgreich gespeichert.';

  @override
  String get pincodeForgotten => 'Login mit E-Mail und Passwort';

  @override
  String get pincodeForgottenTitle => 'PIN vergessen';

  @override
  String get pincodeForgottenMessage => 'Nutz deine E-Mail-Adresse, um dich einzuloggen.';

  @override
  String get pincodeWrongPinTitle => 'Falsche PIN';

  @override
  String get pincodeWrongPinFirstTry => 'Erster Versuch fehlgeschlagen. Bitte versuch es noch einmal.';

  @override
  String get pincodeWrongPinSecondTry => 'Zweiter Versuch fehlgeschlagen. Bitte versuch es noch einmal.';

  @override
  String get pincodeWrongPinThirdTry => 'Dritter Versuch fehlgeschlagen. Bitte nutze deine E-Mail-Adresse, um dich einzuloggen.';

  @override
  String get wrongPasswordLockedOut => 'Dritter Versuch fehlgeschlagen. Für die nächsten 15 Minuten kannst du dich nicht einloggen. Bitte versuch es später wieder.';

  @override
  String confirmGivtSafari(Object value0) {
    return 'Vielen Dank für deine Spende an $value0! Bitte bestätige sie durch Drücken der Taste.\n Den Status kannst du jederzeit in der Übersicht überprüfen.';
  }

  @override
  String get confirmGivtSafariNoOrg => 'Vielen Dank für deine Spende! Bitte bestätige sie durch Drücken der Taste.\n Den Status kannst du jederzeit in der Übersicht überprüfen.';

  @override
  String get menuSettingsSwitchAccounts => 'Accounts wechseln';

  @override
  String get prepareIUnderstand => 'Ich habe verstanden';

  @override
  String get amountLimitExceededGb => 'Dieser Betrag ist höher als 250 £. Bitte wähle einen niedrigeren Betrag.';

  @override
  String giftOverviewGiftAidBanner(Object value0) {
    return 'Gift Aided $value0';
  }

  @override
  String get maximumAmountReachedGb => 'Woah, du hast das maximale Spendenlimit erreicht. In Großbritannien können Sie maximal 250 £ pro Spende geben.';

  @override
  String get faqWhyBluetoothEnabledQ => 'Warum muss ich Bluetooth aktivieren, um Givt zu nutzen?';

  @override
  String get faqWhyBluetoothEnabledA => 'Dein Smartphone empfängt ein Signal von einem Beacon in der Spendenbox, dem Klingelbeutel oder dem Kollekten-Korb. Dieses Signal verwendet das Bluetooth-Protokoll. Es kann als Einbahnstraße betrachtet werden, d.h. es gibt im Gegensatz zur Verwendung in einem Bluetooth Car Kit oder Headset keine Verbindung. Dies ist eine sichere und einfache Möglichkeit, dem Smartphone mitzuteilen, welche Spendenbox, welcher Klingelbeutel oder Kollekten-Korb sich in der Nähe befindet. Wenn sich das Signal in der Nähe befindet, nimmt das Telefon das Signal auf und Ihre Spende wird getätigt.';

  @override
  String get collect => 'Kollekte';

  @override
  String get offlineGegevenGivtsMessage => 'Vielen Dank für deine Spende!\n \n\n Sobald es wieder eine gute Verbindung mit dem Givt-Server gibt, wird deine Spende verarbeitet.\n Den Status kannst du jederzeit in der Übersicht überprüfen.';

  @override
  String offlineGegevenGivtsMessageWithOrg(Object value0) {
    return 'Vielen Dank für deine Spende an $value0!\n \n\n Sobald es wieder eine gute Verbindung mit dem Givt-Server gibt, wird deine Spende verarbeitet.\n Den Status kannst du jederzeit in der Übersicht überprüfen.';
  }

  @override
  String get changeDonation => 'Ändere deine Spende';

  @override
  String get cancelGivts => 'Zieh deine Spende zurück';

  @override
  String get areYouSureToCancelGivts => 'Bist du sicher? Zum Bestätigen OK drücken.';

  @override
  String get feedbackTitle => 'Feedback oder Fragen?';

  @override
  String get noMessage => 'Du hast keine Nachricht eingegeben.';

  @override
  String get feedbackMailSent => 'Deine Nachricht haben wir erhalten. Wir werden uns so bald als möglich, mit dir in Verbindung setzen.';

  @override
  String get typeMessage => 'Schreib deine Nachricht hier!';

  @override
  String get safariGivtTransaction => 'Dieses Spende wird in eine Transaktion umgewandelt.';

  @override
  String get safariMandateSignedPopup => 'Deine Spende wird von diesem Konto (IBAN) eingezogen. Sollte dies nicht korrekt sein, so storniere die Spende und registriere dich neu.';

  @override
  String get didNotSignMandateYet => 'Du musst noch ein Mandat unterschreiben. Dies ist notwendig, damit die Spende bis zum Schluss ausgeführt werden kann. Im Moment ist es leider nicht möglich, eines zu unterschreiben. Dein Givt wird fortgesetzt, aber um vollständig verarbeitet werden zu können, muss ein Mandat unterzeichnet werden.';

  @override
  String get appVersion => 'App Version:';

  @override
  String get shareGivtText => 'Givt empfehlen';

  @override
  String get shareGivtTextLong => 'Hey! Willst du weiter spenden?';

  @override
  String get givtGewoonBlijvenGeven => 'Givt - Geben tut so gut';

  @override
  String get updatesDoneTitle => 'Bereit zum Spenden?';

  @override
  String get updatesDoneSubtitle => 'Givt ist nun absolute up-to-date. Viel Spaß beim Geben.';

  @override
  String get featureShareTitle => 'Teile Givt!';

  @override
  String get featureShareSubtitle => 'Das Weiterempfehlen von Givt ist so einfach wie 1, 2, 3. Du kannst die App unten auf der Einstellungsseite teilen.';

  @override
  String get askMeLater => 'Frag mich später';

  @override
  String get giveDifferently => 'Aus der Liste auswählen';

  @override
  String get churches => 'Kirchen';

  @override
  String get stichtingen => 'Wohltätigkeit';

  @override
  String get acties => 'Kampagnen';

  @override
  String get overig => 'Andere';

  @override
  String get signMandateLaterTitle => 'Okay, wir fragen später noch einmal.';

  @override
  String get signMandateLater => 'Du hast dich dazu entschieden, das Mandat später zu unterzeichnen. Du kannst dies beim nächsten Mal tun, wenn du spendest.';

  @override
  String get suggestie => 'Spende an:';

  @override
  String get codeCanNotBeScanned => 'Leider kann dieser Code nicht innerhalb der Givt App verwendet werden.';

  @override
  String get giveDifferentScan => 'QR-Code scannen';

  @override
  String get giveDiffQrText => 'Jetzt gut zielen!';

  @override
  String get qrCodeOrganisationNotFound => 'Der Code wurde gescannt, aber es scheint, dass sich die Organisation verirrt hat. Bitte versuche es später noch einmal.';

  @override
  String get noCameraAccess => 'Wir benötigen deine Kamera, um den Code scannen zu können. Wechsle zu den App-Einstellungen des Handys, um uns deine Zustimmung zu erteilen.';

  @override
  String get nsCameraUsageDescription => 'Wir würden gerne deine Kamera verwenden, um den Code zu scannen.';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get needEmailToGiveSubtext => 'Um deine Spenden korrekt verarbeiten zu können, benötigen wir deine E-Mail-Adresse.';

  @override
  String get completeRegistrationAfterGiveFirst => 'Danke, dass du mit Givt gespendet hast!\n \n\n Wir möchten dir gerne dabei helfen Givt besser zu nutzen, \n daher bitten wir dich die Registrierung abzuschließen.';

  @override
  String get termsUpdate => 'Die Allgemeinen Geschäftsbedingungen wurden aktualisiert.';

  @override
  String get agreeToUpdateTerms => 'Mit dem Fortfahren erklären du dich mit den neuen Allgemeinen Geschäftsbedingungen einverstanden.';

  @override
  String get iWantToReadIt => 'Ich möchte sie lesen';

  @override
  String get termsTextVersion => '1.9';

  @override
  String get locationPermission => 'Wir müssen auf deinen Standort zugreifen, um das Signal vom Givt-Beacon empfangen zu können.';

  @override
  String get locationEnabledMessage => 'Bitte aktiviere deinen Standort, um mit Givt spenden zu können. (Nach der Spende kannst du ihn wieder deaktivieren.)';

  @override
  String get changeGivingLimit => 'Maximalbetrag anpassen';

  @override
  String get somethingWentWrong2 => 'Etwas ist schief gelaufen.';

  @override
  String get chooseLowerAmount => 'Ändere den Betrag';

  @override
  String get turnOnBluetooth => 'Bluetooth einschalten';

  @override
  String get errorTldCheck => 'Du kannst dich leider nicht mit dieser E-Mail-Adresse registrieren. Überprüfst du sie auf Tippfehler?';

  @override
  String get addCollectConfirm => 'Möchtest du eine zweiten Spendenziel hinzufügen?';

  @override
  String get faQvraag0 => 'Feedback oder Fragen?';

  @override
  String get faQantwoord0 => 'Im App-Menü unter \"Über Givt / Kontakt\" gibt es ein Textfeld, mit dem du eine Nachricht an uns senden kannst. Natürlich kannst du uns auch telefonisch unter +49 391-50547299 oder per Mail an support@givtapp.net erreichen.';

  @override
  String get personalPageHeader => 'Ändere deine Zugangsdaten hier.';

  @override
  String get personalPageSubHeader => 'Möchtest du deinen Namen ändern? Schick dazu eine kurze Mail an support@givtapp.net';

  @override
  String get titlePersonalInfo => 'Persönliche Informationen';

  @override
  String get personalInfoTempUser => 'Hallo Spender/-in! Du benutzt ein vorläufiges Konto. Wir haben bisher noch keine persönlichen Daten von dir erhalten.';

  @override
  String get updatePersonalInfoError => 'Leider können wir deine persönlichen Daten im Moment nicht aktualisieren. Kannst du es später noch einmal versuchen?';

  @override
  String get updatePersonalInfoSuccess => 'Es hat funktioniert!';

  @override
  String get loadingTitle => 'Bitte warten.....';

  @override
  String get loadingMessage => 'Bitte warte während wir die Daten laden.....';

  @override
  String get buttonChange => 'Ändern';

  @override
  String get welcomeContinue => 'Los geht\'s';

  @override
  String get enterEmail => 'Los geht\'s';

  @override
  String get finalizeRegistrationPopupText => 'Wichtig: Um deine Spenden übermitteln zu können, muss die Registrierung abgeschlossen sein.';

  @override
  String get finalizeRegistration => 'Registrierung abschließen';

  @override
  String get importantReminder => 'Wichtige Erinnerung';

  @override
  String get multipleCollections => 'Mehrere Spendenziele';

  @override
  String get questionAndroidLocation => 'Warum benötigt Givt Zugriff auf meinen Standort?';

  @override
  String get answerAndroidLocation => 'Bei der Verwendung eines Android-Smartphones kann der Givt-Beacon von der Givt-App nur erkannt werden, wenn der Standort bekannt ist. Daher benötigt Givt den Standort, um dir das Spenden zu ermöglichen. Keine Sorge, abgesehen davon verwenden wir den Standort nicht.';

  @override
  String get shareTheGivtButton => 'Teile Givt mit Freunden';

  @override
  String shareTheGivtText(Object value0) {
    return 'Ich habe gerade Givt genutzt, um an $value0 zu spenden!';
  }

  @override
  String get shareTheGivtTextNoOrg => 'Ich habe gerade Givt genutzt, um zu spenden!';

  @override
  String get joinGivt => 'Mach mit via givtapp.net/download.';

  @override
  String get firstUseWelcomeSubTitle => 'Für weitere Informationen bitte wischen.';

  @override
  String get firstUseWelcomeTitle => 'Willkommen!';

  @override
  String get firstUseLabelTitle1 => 'Gib überall mit einem Lastschriftmandat';

  @override
  String get firstUseLabelTitle2 => 'Einfaches, sicheres und anonymes Spenden';

  @override
  String get firstUseLabelTitle3 => 'Spende Immer und überall';

  @override
  String get yesSuccess => 'Super, geschafft!';

  @override
  String get toGiveWeNeedYourEmailAddress => 'Um mit dem Spenden per Givt beginnen zu können, benötigen wir nur deine E-Mail-Adresse.';

  @override
  String get weWontSendAnySpam => '(wir werden auch keinen Spam versenden, versprochen)';

  @override
  String get swipeDownOpenGivt => 'Wische nach unten, um die Givt App zu öffnen.';

  @override
  String get moreInfo => 'Weitere Infos';

  @override
  String get germany => 'Deutschland';

  @override
  String get extraBluetoothText => 'Ist Bluetooth eingeschaltet? Dann musst du es nochmal aus- und dann wieder einschalten.';

  @override
  String get openMailbox => 'Öffne dein Postfach';

  @override
  String get personalInfo => 'Persönliche Infos';

  @override
  String get cameraPermission => 'Wir müssen auf deine Kamera zugreifen, um einen QR-Code scannen zu können.';

  @override
  String get downloadYearOverview => 'Möchtest du deine Spendenübersicht für die Steuererklärung herunterladen?';

  @override
  String get sendOverViewTo => 'Wir senden die Übersicht an';

  @override
  String get yearOverviewAvailable => 'Jährliche Spendenübersicht verfügbar';

  @override
  String get checkHereForYearOverview => 'Hier kannst du deine jährliche Spendenübersicht anfordern';

  @override
  String get couldNotSendTaxOverview => 'Wir können deine jährliche Spendenübersicht nicht abrufen, bitte versuch es später noch einmal. Wende dich an support@givtapp.net, wenn dieses Problem weiterhin besteht.';

  @override
  String get searchHere => 'Suche....';

  @override
  String get noInternet => 'Hoppla! Es sieht so aus, als ob du keinerlei Verbindung zum Internet hättest. Probier es noch einmal, wenn wieder eine Verbindung mit dem Internet besteht.';

  @override
  String get noInternetConnectionTitle => 'Keine Internetverbindung';

  @override
  String get serverNotReachable => 'Leider ist es gerade nicht möglich die Registrierung abzuschließen, unser Server scheint ein Problem zu haben. Kannst du es später noch einmal versuchen?\n Hast du diese Nachricht wiederholt bekommen? Offensichtlich sind wir uns dieses Problems nicht bewusst. Hilf uns Givt zu verbessern, indem du uns eine Nachricht schickst. Wir werden uns dann sofort darum kümmern, versprochen.';

  @override
  String get sendMessage => 'Nachricht senden';

  @override
  String get answerWhyAreMyDataStored => 'Jeden Tag arbeiten wir sehr hart daran, Givt zu verbessern. Dazu verwenden wir die uns zur Verfügung stehenden Daten.\n Für die Erstellung deines Mandates benötigen wir einige Angaben. Andere Informationen werden verwendet, um dein persönliches Konto zu erstellen.\n Wir verwenden deine Daten ebenfalls, um etwaige Support-Fragen zu beantworten.\n In keinem Fall geben wir jedoch deine persönlichen Daten an Dritte weiter.';

  @override
  String get logoffSession => 'Abmelden';

  @override
  String get alreadyAnAccount => 'Hast du bereits einen Account?';

  @override
  String get unitedKingdom => 'Vereinigtes Königreich';

  @override
  String get cancelShort => 'Abbrechen';

  @override
  String get cantCancelGiftAfter15Minutes => 'Leider kannst du diese Spende innerhalb der Givt App nicht mehr stornieren, da diese Spende bereits länger als 15 Minuten her ist.';

  @override
  String get unknownErrorCancelGivt => 'Aufgrund eines unerwarteten Fehlers konnten wir deine Spende nicht stornieren. Wende dich an uns unter support@givtapp.net für weitere Informationen.';

  @override
  String transactionCancelled(Object value0) {
    return 'Die Spende an $value0 wird storniert.';
  }

  @override
  String get cancelled => 'Storniert';

  @override
  String get undo => 'Zurück';

  @override
  String get faqVraag16 => 'Kann ich einen Spende zurückziehen?';

  @override
  String get faqAntwoord16 => 'Wechseln Sie einfach in die Spendenübersicht und wische die betreffende Spende nach links. Die Stornierung ist kostenlos, wenn es auf diese Weise geschieht. Hinweis: Die Spende kann nur storniert werden, wenn die Registrierung in der Givt App abgeschlossen wurde.\n \n\n Im Moment der Spende finden keinerlei Transaktionen statt. Die Transaktionen erfolgen ausschließlich per Lastschrift danach. Da diese Transaktionen der Bank ebenfalls reversibel sind, sind diese absolut sicher und vor Betrug geschützt. Diese Art der Rückabwicklung verursacht aber ggf. Kosten für die Organisation, der du gespendet hast.';

  @override
  String get selectContextCollect => 'Spende in der Kirche, an der Haustür oder auf der Straße';

  @override
  String get giveContextQr => 'Spende, indem du einen QR-Code scannst';

  @override
  String get selectContextList => 'Suche ein Spendenziel aus der Liste aus';

  @override
  String get selectContext => 'Wähle die Art zu Spenden';

  @override
  String get chooseWhoYouWantToGiveTo => 'Wähle dein Spendenziel';

  @override
  String get cancelGiftAlertTitle => 'Die Spende stornieren?';

  @override
  String get cancelGiftAlertMessage => 'Bist du sicher, dass du die Spende stornieren möchtest?';

  @override
  String get gotIt => 'Hab\'s kapiert!';

  @override
  String get cancelFeatureTitle => 'Du kannst eine Spende stornieren, indem du sie nach links wischst';

  @override
  String get cancelFeatureMessage => 'Tippe irgendwo hin, um diese Nachricht zu verlassen';

  @override
  String get giveSubtitle => 'Es gibt mehrere Möglichkeiten, um mit Givt zu spenden. Wähle die, welche am besten zu dir passt.';

  @override
  String get confirm => 'Bestätige';

  @override
  String safariGivingToOrganisation(Object value0) {
    return 'Du hast gerade an $value0 gespendet. Unten findest du eine Spendenübersicht.';
  }

  @override
  String get safariGiving => 'Du hast gerade gespendet. Unten findest du eine Spendenübersicht.';

  @override
  String get giveSituationShowcaseTitle => 'Als nächstes wählst du, wie du geben möchtest';

  @override
  String get soonMessage => 'Bald verfügbar.....';

  @override
  String get giveWithYourPhone => 'Bewege das Handy';

  @override
  String get celebrateTitle => 'Warte...';

  @override
  String get celebrateMessage => 'Werfe das Handy in die Luft (aber halte es fest!), bevor der Timer 0 erreicht. \n Was wird dann passieren? Du erfährst es gleich.....';

  @override
  String get afterCelebrationTitle => 'Und jetzt... Winke!';

  @override
  String get afterCelebrationMessage => 'Jetzt ist die Zeit, winke wie wild! \n (Wir sind nicht verantwortlich für auftretende Ellbogenverletzungen.)';

  @override
  String get errorContactGivt => 'Ein Fehler ist aufgetreten. Bitte kontaktiere uns unter support@givtapp.net';

  @override
  String get mandateFailPersonalInformation => 'Anscheinend stimmt etwas mit den von dir angegebenen Informationen nicht. Könntest du bitte im Menü unter \"Persönliche Informationen\" nachsehen? Bei Bedarf kannst du sie dort auch gleich ändern.';

  @override
  String mandateSmsCode(Object value0, Object value1) {
    return 'Wir senden eine SMS an $value0. Das Mandat wird im Namen von $value1 unterzeichnet. Ist dies korrekt? Dann fahre mit dem nächsten Schritt fort.';
  }

  @override
  String get mandateSigningCode => 'Wenn alles gut geht, erhältst du eine SMS. Bitte trage den enthaltenden Code ein, um Ihr Mandat zu unterzeichnen.';

  @override
  String get readCode => 'Dein Code:';

  @override
  String get readMandate => 'Mandat ansehen';

  @override
  String get mandatePdfFileName => 'Mandat';

  @override
  String get writeStoragePermission => 'Um diese PDF ansehen zu können, benötigen wir den Zugriff auf den Speicher des Telefons, damit wir PDF speichern und anzeigen können.';

  @override
  String get legalTextSlimPay => 'Wenn du fortfährst, wirst du gebeten, ein Mandat zu unterzeichnen, welches Givt B.V. berechtigt, dein Konto zu belasten. Du musst der Kontoinhaber sein oder berechtigt, im Namen des Kontoinhabers zu handeln.\n \n\n Deine persönlichen Daten werden von SlimPay, einem lizenzierten Zahlungsinstitut, verarbeitet, um den Zahlungsvorgang im Namen von Givt B.V. durchzuführen und Betrug gemäß den europäischen Vorschriften zu verhindern.';

  @override
  String get resendCode => 'Code nochmals zusenden';

  @override
  String get wrongCodeMandateSigning => 'Der Code scheint nicht korrekt zu sein. Versuche es nochmals oder lass dir einen neuen Code zusenden.';

  @override
  String get back => 'Zurück';

  @override
  String get amountLowest => 'Zwei Euro fünfzig';

  @override
  String get amountMiddle => 'Sieben Euro fünfzig';

  @override
  String get amountHighest => 'Zwölf Euro fünfzig';

  @override
  String get divider => 'Punkt';

  @override
  String givtEventText(Object value0) {
    return 'Hey! Du befindest dich an einem Ort, an dem Givt unterstützt wird. Möchtest du $value0 etwas spenden?';
  }

  @override
  String get searchingEventText => 'Wir suchen gerade deinen Standort, möchtest du ein wenig warten?';

  @override
  String get weDoNotFindYou => 'Leider können wir deinen Standort im Moment nicht finden. Du kannst aus einer Liste auswählen, an welche Organisation du spenden möchtest oder zurückgehen und es erneut versuchen.';

  @override
  String get selectLocationContext => 'Spende am Standort';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get allowGivtLocationTitle => 'Ermögliche Givt den Zugriff auf deinen Standort.';

  @override
  String get allowGivtLocationMessage => 'Wir benötigen deinen Standort, um festzustellen, an wen du spenden möchtest.\n Wähle Einstellungen > Datenschutz > Standortdienste > Standortdienste ein und stelle Givt auf ‚während der Nutzung der App\'.';

  @override
  String get faqVraag10 => 'Wie kann ich mein Passwort ändern?';

  @override
  String get faqAntwoord10 => 'Wenn du dein Passwort ändern möchtest, kannst du das im Menü \"Persönliche Informationen\" unter der Schaltfläche \"Passwort ändern\" tun. Wir senden dir eine Mail mit einem Link zu einer Webseite, auf der du dein Passwort ändern kannst.';

  @override
  String get editPersonalSucces => 'Deine persönlichen Daten wurden erfolgreich aktualisiert.';

  @override
  String get editPersonalFail => 'Ups, wir konnten deine persönlichen Daten nicht aktualisieren.';

  @override
  String get changeEmail => 'E-Mail Adresse ändern';

  @override
  String get changeIban => 'IBAN ändern';

  @override
  String get smsSuccess => 'Code wurde per SMS gesandt';

  @override
  String get smsFailed => 'Versuch es später noch einmal';

  @override
  String get kerkdienstGemistQuestion => 'Wie kann ich mit Givt über Dritte spenden?';

  @override
  String get kerkdienstGemistAnswer => 'Unsergottesdienst.de\n Wenn du mithilfe der Unsergottesdienst-App Gottesdienste live verfolgst, kannst du mit Givt ganz einfach spenden. Voraussetzung ist natürlich, dass deine Kirche unseren Dienst nutzt. Am Ende der Seite findest du eine kleine Schaltfläche, mit der du zur Givt-App gelangen kannst. Wähle einfach einen Betrag aus, bestätigen mit \"Ja, bitte\" und das war es!';

  @override
  String externalSuggestionLabel(Object value0, Object value1) {
    return 'Wir sehen, dass du mit der $value0 App gibst. Möchtest du an $value1 spenden?';
  }

  @override
  String get chooseHowIGive => 'Nein, ich würde gerne selbst entscheiden, wie ich spende.';

  @override
  String get andersGeven => 'Spende anders';

  @override
  String get kerkdienstGemist => 'Unsergottesdienst.de';

  @override
  String get changePhone => 'Handynummer ändern';

  @override
  String get artists => 'Künstler';

  @override
  String get changeAddress => 'Adresse ändern';

  @override
  String get selectLocationContextLong => 'Spende am Standort';

  @override
  String get givtAtLocationDisabledTitle => 'Kein Givt-Standort verfügbar';

  @override
  String get givtAtLocationDisabledMessage => 'Hey, nicht so schnell! Im Moment sind keine Organisationen verfügbar, bei denen du hier vor Ort spenden könntest.';

  @override
  String get tempAccountLogin => 'Du verwendest ein temporäres Konto ohne Passwort. Du wirst nun automatisch eingeloggt und aufgefordert die Registrierung abzuschließen.';

  @override
  String get sortCodePlaceholder => 'Bankleitzahl';

  @override
  String get bankAccountNumberPlaceholder => 'Kontonummer';

  @override
  String get bacsSetupTitle => 'Einzugsermächtigung erteilen';

  @override
  String get bacsSetupBody => 'Du unterzeichnest eine pauschale Einzugsermächtigung, wir belasten jedoch dein Konto nur, falls du die Givt App zu spenden benutzt.\n \n\n Indem du fortfährst, erklärst du, dass du der Kontoinhaber bist und die einzige Person, die zur Ermächtigung von Belastungen von diesem Konto berechtigt ist.\n \n\n Die Details der Einzugsermächtigung werden dir innerhalb von 3 Werktagen oder spätestens 10 Werktage vor der ersten Einziehung per E-Mail zugesandt.';

  @override
  String get bacsUnderstoodNotice => 'Ich habe die Hinweise zur Vorankündigung gelesen und verstanden.';

  @override
  String get bacsVerifyTitle => 'Überprüfe deine Daten';

  @override
  String get bacsVerifyBody => 'Wenn einer der oben genannten Punkte nicht korrekt ist, brich die Registrierung ab und ändere deine \"persönlichen Daten\".\n \n\n Der Firmenname, der auf Ihrem Kontoauszug auf der Lastschrift erscheint, lautet Givt B.V.';

  @override
  String get bacsReadDdGuarantee => 'Lastschriftgarantie lesen';

  @override
  String get bacsDdGuarantee => '- Die Garantie wird von allen Banken und Bausparkassen angeboten, die Weisungen zur Zahlung von Lastschriften akzeptieren.\n - Bei Änderungen in der Art und Weise, wie diese beiläufige Lastschriftanweisung verwendet wird, wird Sie das Unternehmen ( in der Regel innerhalb von 10 Werktagen) benachrichtigen, bevor dein Konto belastet wird. \n - Wenn bei der Zahlung deiner Lastschrift durch das Unternehmen oder deiner Bank oder Bausparkasse ein Fehler auftritt, haben Sie Anspruch auf eine vollständige und sofortige Rückerstattung des von der Bank oder Bausparkasse eingezogenen Betrages.\n - Falls du eine Rückerstattung erhältst, auf die du keinen Anspruch hast, bist du verpflichtet diese zurückzahlen, falls die Organisation dazu auffordert.\n - Eine Einzugsermächtigung kannst du jederzeit widerrufen, indem du dich einfach an deine Bank oder Bausparkasse wendest. Eine schriftliche Bestätigung kann erforderlich sein. Bitte benachrichtige dann auch die betreffende Organisation.';

  @override
  String get bacsAdvanceNotice => 'Sie unterschreiben eine fallweise, nicht wiederkehrende Weisung zum Lastschriftverfahren. Nur auf Ihren speziellen Wunsch hin werden Abbuchungen von der Organisation durchgeführt. Es gelten alle üblichen Sicherheitsvorkehrungen und Garantien für Lastschriften. Es können keine Änderungen an der Nutzung dieser Einzugsermächtigung vorgenommen werden, ohne Sie mindestens fünf (5) Werktage vor der Belastung Ihres Kontos zu informieren.\n Im Falle eines Fehlers haben Sie Anspruch auf eine sofortige Rückerstattung durch Ihre Bank oder Bausparkasse. \n Sie haben das Recht, eine Einzugsermächtigung jederzeit schriftlich an Ihre Bank oder Bausparkasse mit einer Kopie an uns zu widerrufen.';

  @override
  String get bacsAdvanceNoticeTitle => 'Vorankündigung';

  @override
  String get bacsDdGuaranteeTitle => 'Lastschrift-Garantie';

  @override
  String bacsVerifyBodyDetails(Object value0, Object value1, Object value2, Object value3, Object value4) {
    return 'Name: $value0\n Adresse: $value1\n E-Mail-Adresse: $value2\n Bankleitzahl: $value3\n Kontonummer: $value4\n Frequenzart: nach Nutzung, falls du die Givt App zum Spenden benutzt';
  }

  @override
  String get bacsHelpTitle => 'Benötigst du Hilfe?';

  @override
  String get bacsHelpBody => 'Benötigst du Hilfe oder hast du Fragen? Ruf uns unter +49 391 5054 7299 an oder kontaktiere uns unter support@givt.app und wir werden uns mit dir in Verbindung setzen!';

  @override
  String bacsSortcodeAccountnumber(Object value0, Object value1) {
    return 'Bankleitzahl: $value0\n Kontonummer: $value1';
  }

  @override
  String get cantFetchPersonalInformation => 'Wir können deine persönlichen Daten im Moment nicht abrufen, könntest du es später noch einmal versuchen?';

  @override
  String get givingContextCollectionBag => 'Klingelbeutel';

  @override
  String get givingContextQrCode => 'QR-Code';

  @override
  String get givingContextLocation => 'Standort';

  @override
  String get givingContextCollectionBagList => 'Liste';

  @override
  String get amountPresetsTitle => 'Betragsvoreinstellungen';

  @override
  String get amountPresetsBody => 'Stelle unten deine Betragsvoreinstellungen ein.';

  @override
  String get amountPresetsResetAll => 'Werte zurücksetzen';

  @override
  String get amountPresetsErrGivingLimit => 'Der Betrag ist höher als dein Maximalbetrag.';

  @override
  String amountPresetsErr25C(Object value0) {
    return 'Der Betrag muss mindestens 0,25 Euro betragen.';
  }

  @override
  String get amountPresetsErrEmpty => 'Gib einen Betrag ein';

  @override
  String alertBacsMessage(Object value0) {
    return 'Da du $value0 als Länderwahl angegeben haben, gehen wir davon aus, dass du lieber über ein SEPA-Mandat (€) geben möchtest, dafür benötigen wir deine IBAN. Falls du lieber BACS (£) verwenden möchtest, benötigen wir deine Bankleitzahl und Kontonummer.';
  }

  @override
  String alertSepaMessage(Object value0) {
    return 'Da du $value0 als Länderwahl angegeben haben, gehen wir davon aus, dass du lieber über BACS Direct Debit (£) geben möchtest, dafür benötigen wir deine Bankleitzahl und Kontonummer. Falls du stattdessen lieber SEPA (€) nutzen möchtest, benötigen wir deine IBAN.';
  }

  @override
  String get important => 'Wichtig';

  @override
  String get fingerprintTitle => 'Fingerabdruck';

  @override
  String get touchId => 'Touch ID';

  @override
  String get faceId => 'Face ID';

  @override
  String get touchIdUsage => 'Hier änderst du die Verwendung von Touch ID, um dich bei der Givt App anzumelden.';

  @override
  String get faceIdUsage => 'Hier änderst du die Verwendung von Face ID, um dich bei der Givt App anzumelden.';

  @override
  String get fingerprintUsage => 'Hier änderst du die Verwendung des Fingerabdrucks, um dich bei der Givt App anzumelden.';

  @override
  String get authenticationIssueTitle => 'Authentifizierungsproblem';

  @override
  String get authenticationIssueMessage => 'Wir konnten dich nicht richtig identifizieren. Bitte versuche es später noch einmal.';

  @override
  String get authenticationIssueFallbackMessage => 'Wir konnten dich nicht richtig identifizieren. Bitte melde dich mit Zugangscode oder Passwort nochmals ein.';

  @override
  String get cancelledAuthorizationMessage => 'Du hast die Authentifizierung abgebrochen. Möchtest du dich mit deinem Zugangscode / Passwort anmelden?';

  @override
  String get offlineGiftsTitle => 'Offline Spenden';

  @override
  String get offlineGiftsMessage => 'Um sicherzustellen, dass deine Spenden rechtzeitig ankommen, muss eine Internetverbindung aktiviert sein, damit die Spenden an den Server gesendet werden können.';

  @override
  String get enrollFingerprint => 'Leg deinen Finger auf den Sensor.';

  @override
  String fingerprintMessageAlert(Object value0, Object value1) {
    return 'Benutze $value0, um sich für $value1 anzumelden.';
  }

  @override
  String get loginFingerprint => 'Login mit Fingerabdruck';

  @override
  String get loginFingerprintCancel => 'Login mit Passcode / Passwort';

  @override
  String get fingerprintStateScanning => 'Berührungssensor';

  @override
  String get fingerprintStateSuccess => 'Fingerabdruck erkannt';

  @override
  String get fingerprintStateFailure => 'Fingerabdruck nicht erkannt. Bitte nochmals versuchen.';

  @override
  String get activateBluetooth => 'Bluetooth aktivieren';

  @override
  String get amountTooHigh => 'Betrag zu hoch';

  @override
  String get activateLocation => 'Standort aktivieren';

  @override
  String get loginFailure => 'Login Fehler';

  @override
  String get requestFailed => 'Anfrage fehlgeschlagen';

  @override
  String get resetPasswordSent => 'Du solltest eine E-Mail mit einem Link erhalten haben, um dein Passwort zurück setzen zu können. Falls du diese E-Mail nicht sofort findest, überprüf bitte auch den Spam-Ordner.';

  @override
  String get success => 'Es hat funktioniert!';

  @override
  String get notSoFast => 'Nicht so schnell, großer Geldgeber.';

  @override
  String get giftBetween30Sec => 'Du hast bereits innerhalb von 30 Sekunden gespendet. Kannst du noch ein wenig warten?';

  @override
  String get android8ActivateLocation => 'Aktiviere den Standort und stelle sicher, dass der Modus \"Hohe Genauigkeit\" ausgewählt wurde.';

  @override
  String get android9ActivateLocation => 'Aktiviere den Standort und stelle sicher, dass \"Standortgenauigkeit\" aktiviert ist.';

  @override
  String get nonExistingEmail => 'Diese E-Mail-Adresse ist uns nicht bekannt. Ist es möglich, dass du dich mit einem anderen E-Mail-Konto registriert hast?';

  @override
  String get secondCollection => 'zweiten Spendenziel';

  @override
  String get amountTooLow => 'Betrag zu gering';

  @override
  String get qrScanFailed => 'Zielvorgabe fehlgeschlagen';

  @override
  String get temporaryAccount => 'Vorübergehendes Konto';

  @override
  String get temporaryDisabled => 'Vorübergehend gesperrt';

  @override
  String get cancelFailed => 'Stornieren fehlgeschlagen';

  @override
  String get accessDenied => 'Zugang verweigert';

  @override
  String get unknownError => 'Unbekannter Fehler';

  @override
  String get mandateFailed => 'Autorisierung fehlgeschlagen';

  @override
  String qrScannedOutOfApp(Object value0) {
    return 'Hey! Prima, dass du mit einem QR-Code spenden möchtest! Bist du sicher, dass du $value0 etwas spenden möchtest?';
  }

  @override
  String get saveFailed => 'Speichern fehlgeschlagen';

  @override
  String get invalidEmail => 'Ungültige E-Mail-Adresse';

  @override
  String get giftsOverviewSent => 'Wir haben die Spendenübersicht an deine Mailbox geschickt.';

  @override
  String get giftWasBetween30S => 'Deine Spende wurde nicht verarbeitet, weil seit der letzten Spende weniger als 30 Sekunden vergangen sind.';

  @override
  String get promotionalQr => 'Dieser Code leitet dich zu unserer Webseite weiter. Er kann nicht zum Spenden per Givt App verwendet werden.';

  @override
  String get promotionalQrTitle => 'Promo QR-Code';

  @override
  String get downloadYearOverviewByChoice => 'Möchtest du eine Jahresübersicht deiner getätigten Spenden herunterladen? Wähle dazu das Jahr aus und wir senden die Übersicht an';

  @override
  String giveOutOfApp(Object value0) {
    return 'Hey! Schön, dass du mit Givt spenden willst! Bist du sicher, dass du an $value0 etwas spenden möchtest?';
  }

  @override
  String get mandateFailTryAgainLater => 'Bei der Erstellung des Mandats ist etwas schief gelaufen. Kannst du es später noch einmal versuchen?';

  @override
  String get featureButtonSkip => 'Überspringen';

  @override
  String get featureMenuText => 'Deine App von A bis Z';

  @override
  String get featureMultipleNew => 'Hallo, wir möchten dir ein paar neue Features vorstellen.';

  @override
  String get featureReadMore => 'Lies weiter';

  @override
  String featureStepTitle(Object value0, Object value1) {
    return 'Feature $value0 von $value1';
  }

  @override
  String get noticeSmsCode => 'Wichtig!\n Bitte beachte, dass der SMS-Code auf der Webseite ausgefüllt werden muss und nicht in der App. Wenn du das Mandat unterschrieben hast, wirst du anschließend automatisch zur App weitergeleitet.';

  @override
  String get featurePush1Title => 'Push-Benachrichtigungen';

  @override
  String get featurePush2Title => 'Wir helfen dir weiter';

  @override
  String get featurePush3Title => 'Vergewissere dich, dass sie eingeschaltet sind.';

  @override
  String get featurePush1Message => 'Mithilfe von Push-Benachrichtigungen können wir dir etwas Wichtiges mitteilen. Auch wenn die App gerade nicht läuft.';

  @override
  String get featurePush2Message => 'Wenn etwas mit dem Konto oder deinen Spenden nicht stimmen sollte, können wir es dir so einfach und schnell mitteilen.';

  @override
  String get featurePush3Message => 'Und sei unbesorgt, die Benachrichtigungen aktiviert zu lassen. Wir informieren nur über dringende Angelegenheiten.';

  @override
  String get featurePushInappnot => 'Hier klicken, um mehr über Push-Benachrichtigungen zu erfahren.';

  @override
  String get featurePushNotenabledAction => 'Einschalten';

  @override
  String get featurePushEnabledAction => 'Ich verstehe';

  @override
  String get termsTextGb => 'GIVT LTD \n\nTerms of use – Givt app \nLast updated: 24-11-2023\nVersion: 1.5\n\n1.  \tGeneral \nThese terms of use describe the conditions under which the mobile application Givt (\"Givt\") can be utilised. Givt allows the User (anonymously) to give donations through their smartphone, for example churches, fundraising campaigns or charities that are members of Givt Ltd.  \n\nThese terms of use apply to the use of Givt. Through the use of Givt (which means the download and the installation thereof), you (\"the User\") accept these terms of use and our privacy policy (https://givt.co.uk/privacystatementgivt-service). These terms of use and our privacy policy are also available on our website to download and print. We may revise these terms of use from time to time. \n\n2.  \tLicense and intellectual property rights \n\n2.1\tAll rights to Givt, the accompanying documentation and all modifications and extensions thereto as well as the enforcement thereof are and remain the property of Givt. The User is granted solely the rights and authorities and/or permissions ensuing from the effect of this agreement or which are assigned in writing, and you may not otherwise use, reproduce or publicly release Givt. \n\n2.2\tGivt grants the User a non-exclusive, non-sublicensable and non-transmittable license to use Givt. The User is not allowed to use Givt for commercial purposes. \n\n2.3  \tThe User may not provide Givt to third parties nor sell, rent, decompile, submit to reverse engineer or modify it without prior permission from Givt. Nor should the User, or let others, remove or bypass the technical provisions that are intended to protect Givt. \n\n2.4 \tGivt has the right to change Givt at any time, modify or remove data, deny the User the use of Givt by termination of the license, limitation of the use of Givt or deny access to Givt in whole or in part, temporarily or permanently. Givt will inform the User about this in an appropriate manner. \n\n2.5 \tThe User acquires no right, title or interest to the intellectual property rights and/or similar rights to (the means of) Givt, including the underlying software and content.\n\n3. \tThe use of Givt \n\n3.1 \tThe User can only give donations to churches, charities, fundraising campaigns and/or other legal entities that are affiliated with Givt. The donations are done anonymously. \n\n3.2  \tThe use of Givt is at your own risk and expense and should be used in accordance with the purposes for which it is intended. It is prohibited to reverse engineer the source code of Givt or to decompile and/or modify Givt, to make a copy of Givt available to any third party or to remove, delete or render illegible any designations of Givt as the party holding rights to Givt or parts thereof.\n\n3.3\tThe User is responsible for the correct submission of data such as name and address details, bank account number and other information as requested by Givt to ensure the use of Givt. \n\n3.4\tIf the User is under the age of 18 they must have the consent of their parent or legal guardian in order to use Givt. By accepting these terms of use, the User guarantees that they are 18 years of age or have the permission of their parents or legal representative. \n\n3.5 \tGivt is available for the operating systems Android and iOS. In addition to the provisions set out below, Apple’s App Store or Google Play may attach conditions to the acquisition of Givt, its use and related matters. For further information, see the terms of use and privacy policy of Apple’s App Store and Google Play as well as any other applicable terms and conditions appearing on the website of the respective provider. This end user licence is applicable to the agreement between the User and Givt and does not apply between the User and the provider of the platform through which you acquired Givt. That provider may hold you liable for violation of provisions in this end user licence, however.\n\n3.6\tAfter the User has downloaded Givt, the User is requested to register. In doing so, the User must provide the following information: (i) name (ii) address, (iii) phone number, (iv) bank account number, and (v) e-mail address. The privacy policy of Givt is applied to the processing of personal data via Givt. The User must inform Givt immediately if any of this data changes by correcting the information within the app.\n\n3.7\tThe User may, after installing the Givt app, also choose to only enter an e-mail address and immediately use the app to donate. After the donation, the User will be asked to complete the registration procedure. If the User wishes to do so later, Givt ensures to only use the User\'s e-mail address to remind the User to finish the registration procedure until this procedure is finalised.\n\n3.8 \tThe User is responsible for any expenses related to the equipment, software system and (internet) connection to make use of Givt.\n\n3.9 \tGivt provides the related services based on the information the User submits. The User is obliged to provide correct and complete information, which is not false or misleading. The User may not provide data with respect to names or bank accounts for which the User is not authorised to use. Givt and the Processor have the right to validate and verify the information the User has provided. \n\n3.10 \tThe User may at any time terminate the use of Givt, by deleting their account via the menu in the app or via mail to support@givt.app. Deleting the app from the smartphone without following aforementioned steps will not result in deletion of the User’s data. Givt can terminate the relationship with the User if the User does not comply with these terms and conditions or if Givt has not been used for 18 consecutive months. On request Givt can send a listing of all donation data. \n\n3.11 \tGivt does not charge fees for the use of Givt. \n\n3.12\tGivt has the right to adjust the offered functionalities from time to time to improve, to change or to fix errors. Givt will always work to fix errors within the Givt software, but cannot guarantee that all errors, whether or not in a timely fashion, be restored. \n\n4. \tProcessing transactions and Protecting your money\n\n4.1 \tGivt does not provide banking or payment services. To facilitate the processing of donations from the User, Givt has entered into an agreement with Access Paysuite Ltd, an Electronic Money Institution, authorised and regulated by the Financial Conduct Authority (FRN 730815) (“Access PaySuite”)(the \"Processor\"). Givt will, after the collection of donations, ensure the payment of donations to the user-designated beneficiary. The transaction data will be processed and forwarded to the Givt Processor. The Processor will initiate payment transactions whereas Givt is responsible for the transaction of the relevant amounts to the bank account of the Church/Charity as being the user-designated beneficiary of the donation.\n\n4.2 \tThe User agrees that Givt may pass the User’s (transaction and bank) data to the Processor, along with all other necessary account and personal information of the User, in order to enable the Processor to initiate the payment transactions and processing. Givt reserves the right to change the Processor at any time. The User agrees that Givt may forward the relevant information and data about the User as defined in article 4.2 to the new Processor to be able to continue processing payment transactions. \n\n4.3 \tGivt and the Processor will process the data of the User in accordance with the law and regulations that apply to data protection. For further information on how personal data is collected, processed and used, Givt refers the User to its privacy policy. This can be found at: (https://givt.co.uk/privacystatementgivt-service/).\n\n4.4 \tThe donations of the User will pass through Access PaySuite. Givt will ensure that the funds will be transferred to the beneficiary, with whom Givt has an agreement. \n\n4.5 \tThe User can reverse a debit at any time, within the terms of the User\'s bank, and the direct debit scheme. \n\n4.6 \tGivt and/or the Processor can refuse a donation if there are reasonable grounds to believe that a user is acting in violation of these terms or if there are reasonable grounds to believe that a donation is possibly suspicious or illegal. In this case Givt will inform the User as soon as possible, unless prohibited by law. \n\n4.7\tUsers of the Givt app will not be charged for their donations through our platform. Givt and the receiving party have made separate compensation arrangements pursuant to the agreement in effect between them.\n\n4.8 \tThe User agrees that Givt may pass transactional data of the User to the HMRC, along with all other necessary account and personal information of the User, in order to assist the User with their annual tax return.   \n\n4.9\tWe will hold your money in a Client Funds Account, provided by Access PaySuite. The account is segregated from our own assets. The money contained in the Client Funds Account cannot be used by Givt, invested or lent to third parties, or in any way form part of Givt’s assets.\n\n4.10\tCurrent Regulatory Provisions exclude money placed on a Client Funds Account from the UK Financial Services Compensation Scheme (FSCS).\n\n4.11\tMoney placed or held in the Client Funds Account shall not constitute a deposit (within the meaning of Article 5 of Directive 2006/48/EC) and does not earn interest.\n4.12\tDeposits and, in particular, withdrawals from the Client Funds Account will only be made in the following circumstances:\n\nIn the case of deposits:\n\nTo receive money intended for onward payment to the designated charity/charities or church(es)\nTo replenish the account where fees or other costs associated with running the account have been deducted\nTo receive refunds in the event that prior instruction to make a payment by you is cancelled, in accordance with these Terms and Conditions\n\nIn the case of withdrawals:\n\nTo pay designated charities and churches, in accordance with your instructions\nTo pay fees or other costs associated with running the account\nTo return money to you, in the event that prior instruction to make a payment by you is canceled, in accordance with these Terms and Conditions.\n\n5. \tSecurity, theft and loss \n\n5.1 \tThe User shall take all reasonable precautions safekeeping their login credentials for Givt to avoid loss, theft, misappropriation or unauthorised use of Givt on their device.\n\n5.2 \tThe User is responsible for the security of their device. Givt considers any donation from the Givt account as a user-approved transaction, regardless of the rights of the User under article 4.5.\n\n5.3 \tThe User shall inform Givt immediately via info@givt.app or +44 20 3790 8068 once their device is lost or stolen. Upon receipt of a message Givt will block the account to prevent (further) misuse. \n\n6.\tUpdates\n\n6.1\tGivt releases updates from time to time, which can rectify errors or improve the functionality of Givt. Available updates for Givt will be announced by means of notification through Apple’s App Store and Google Play and it is the User’s sole responsibility to monitor these notifications and keep informed about new updates.\n\n6.2\tAn update can stipulate conditions, which differ from the provisions in this agreement. The User will always be notified in advance so that they have the opportunity to refuse the update. By installing such an update, the User agrees to these new conditions, which will then form part of this agreement. If User does not agree to the changed conditions, they will have to cease using Givt and delete Givt from their device.\n\n7. \tLiability \n\n7.1 \tGivt has been compiled with the utmost care. Although Givt strives to make Givt available 24 hours a day, it accepts no liability if, for any reason, Givt is not available at any given time or for a certain period of time. Givt reserves the right to temporarily or permanently discontinue Givt (unannounced). The User cannot derive any rights from this. \n\n7.2 \tGivt is not liable for damage or injury resulting from the use of Givt. The limitations of liability as mentioned in this article shall lapse if the liability for damage is the result of intent or gross negligence on the part of Givt.\n\n7.3 \tThe User indemnifies Givt against any claim from third parties (for example, beneficiaries of the donations or HMRC) as a result of the use of the Givt or not correctly meeting the agreements made concerning legal or contractual obligations with Givt. The User will pay all damages and costs to Givt as a result of such claims.\n\n8. \tOther provisions \n\n8.1 \tThis agreement comes into effect on commencement of the use of Givt and will remain in force for an undetermined period from that moment. This agreement may be terminated by the User as well as by Givt at any moment, subject to one month’s notice. This agreement will end by operation of law in the event you are declared bankrupt, you apply for a moratorium on payments or a general attachment is levied against your assets, in the event of your death, or in the event you go into liquidation, are wound up or dissolved. Following the termination of this agreement (for whatever reason), you shall cease and desist from all further use of Givt. You must then delete all copies (including back-up copies) of Givt from all your devices.\n\n8.2\tIf any provision of these terms and conditions is void or destroyed, this will not affect the validity of the agreement as a whole, and other provisions of these terms remain in force. In that case, the parties will decide on a new replacement provision or provisions which will be in line with the intention of the original agreement as far as is legally possible.\n\n8.3 \tThe User is not allowed to transfer the rights and/or obligations arising from the use of Givt and these terms to third parties without prior written permission of Givt. Conversely, Givt is allowed to do so. \n\n8.4 \tWe will endeavor to resolve the dispute amicably. Any disputes arising from or in connection with these terms and conditions are finally settled in the Courts of England and Wales. \n\n8.5  \tThe Law of England and Wales is applicable on these terms of use. \n\n8.6 \tThe terms of use shall not affect the User\'s statutory rights as a consumer.\n\n8.7 \tGivt features an internal complaints procedure. Givt handles complaints efficiently and as soon as reasonably possible. Any complaint about the implementation of these conditions by Givt must be submitted in writing at Givt (via support@givt.app).\n\n\n';

  @override
  String get firstCollect => '1. Spendenziel';

  @override
  String get secondCollect => '2. Spendenziel';

  @override
  String get thirdCollect => '3. Spendenziel';

  @override
  String get addCollect => 'Spendenziel hinzüfügen';

  @override
  String get termsTextVersionGb => '1.3';

  @override
  String get accountDisabledError => 'Leider sieht es so aus, als ob dein Konto deaktiviert wurde. Keine Sorge! Sende einfach eine kurze Mail an support@givtapp.net.';

  @override
  String get featureNewgui1Title => 'Die Benutzeroberfläche';

  @override
  String get featureNewgui2Title => 'Fortschrittsbalken';

  @override
  String get featureNewgui3Title => 'Mehrere Spendenziele';

  @override
  String get featureNewgui1Message => 'Im ersten Fenster kannst du schnell & einfach einen Betrag und weitere Spendenziele hinzufügen oder entfernen.';

  @override
  String get featureNewgui2Message => 'Anhand des Fortschrittsbalkens weißt du immer, wo du dich im Spendenprozess befindest.';

  @override
  String get featureNewgui3Message => 'Mit einem einzigen Tastendruck kannst du weitere Spendenziele hinzufügen oder entfernen.';

  @override
  String get featureNewguiAction => 'Okay, verstanden!';

  @override
  String get featureMultipleInappnot => 'Hi! Wir haben etwas Neues für dich. Hast du kurz Zeit?';

  @override
  String get policyTextGb => 'Latest Amendment: 24-09-2021\n Version 1.9\n \n\n Givt Limited Privacy Policy  \n \n\n Introduction\n This Privacy Policy outlines Givt Limited’s (\" we \", \" our \" or \" the Company \") practices with respect to information collected from our Application (“App”) or from users that otherwise share personal information with us (collectively: \"Users\"). \n \n\n Grounds for data collection \n \n\n Processing of your personal information (meaning, any information which may potentially allow your identification with reasonable means; hereinafter \"Personal Information\") is necessary for the performance of our contractual obligations towards you and providing you with our services, to protect our legitimate interests and for compliance with legal and financial regulatory obligations to which we are subject.\n \n\n When you use our App or register yourself or an organisation you represent with us, you consent to the collection, storage, use, disclosure and other uses of your Personal Information as described in this Privacy Policy.\n \n\n We encourage our Users to carefully read the Privacy Policy and use it to make informed decisions. \n \n\n What information do we collect?\n \n\n We collect two types of data and information from Users. \n \n\n The first type of information is un-identified and non-identifiable information pertaining to a User(s), which may be made available or gathered via your use of the App (“ Non-personal Information ”). We are not aware of the identity of a User from which the Non-personal Information was collected. Non-personal Information which is being collected may include your aggregated usage information and technical information transmitted by your device, including certain software and hardware information (e.g. language preference, access time, etc.) in order to enhance the functionality of our App.\n \n\n The second type of information is Personal Information, which is personally identifiable information, namely information that identifies an individual or may with reasonable effort identify an individual. Such information includes:\n Device Information: We collect Personal Information from your device. Such information includes geolocation data, IP address, unique identifiers (e.g. MAC address and UUID) and other information which relates to your activity through the App.\n Service User Information: We collect additional information for individuals who would like to use our Services. This is gathered through the App and includes all the information needed to register for our service: \n Name and address, \n Date of birth, \n e-mail address, \n secured password details, and \n bank details for the purposes of making payments.\n Contact information: If you choose to contact us you will be asked to provide us with certain details such as: full name; e-mail or physical address, and other relevant information. This may be for yourself or for people in the organisation you represent.\n  \n How do we receive information about you?\n We receive your Personal Information from various sources:\n \n\n When you voluntarily provide us your personal details in order to register on our App;\n When you use or access our App in connection with your use of our services;\n From third party providers, services and public registers (for example, traffic analytics vendors).\n Through diagnostic information from the App. The App will send us anonymous information about its functioning. This information contains non-personal data from your smartphone like its type and operating system, but also the version information of the App. This data is solely used for purposes of improving our Service or allowing better responses to your questions. This information will never be shared with third-parties. \n What do we do with the information we collect?\n We do not rent, sell, or share Users’ information with third parties except as described in this Privacy Policy.\n \n\n We may use the information for the following:\n To provide the services through the App – we will use a minimum of name and bank details to perform the services of effecting payment(s) via the App. Such information is never shared with intended recipients of donations.;\n Communicating with you – sending you notices regarding our services, providing you with technical information and responding to any customer service issue you may have; to keep you informed of our latest updates and services;\n Conducting statistical and analytical activities, intended to improve the App and/or the App.\n \n\n In addition to the different uses listed above, we may transfer or disclose Personal Information to our subsidiaries, affiliated companies and subcontractors in relation to services that we provide to you.\n \n\n We may also disclose information if we have good faith to believe that disclosure of such information is helpful or reasonably necessary to: (i) comply with any applicable law, regulation, legal process or governmental request; (ii) enforce our policies (including our Agreement), including investigations of potential violations thereof; (iii) investigate, detect, prevent, or take action regarding illegal activities or other wrongdoing, suspected fraud or security issues; (iv) to establish or exercise our rights to defend against legal claims; (v) prevent harm to the rights, property or safety of us, our users, yourself or any third party; or (vi) for the purpose of collaborating with law enforcement agencies and/or in case we find it necessary in order to enforce intellectual property or other legal rights.\n \n\n User Rights\n You may request to: \n Receive confirmation as to whether or not personal information concerning you is being processed, and access your stored personal information, together with supplementary information. \n Receive a copy of personal information you directly volunteer to us in a structured, commonly used and machine-readable format. \n Request rectification of your personal information that is in our control.\n Request erasure of your personal information. \n Object to the processing of personal information by us. \n Request to restrict processing of your personal information by us.\n Lodge a complaint with a supervisory authority.\n \n\n However, please note that these rights are not absolute, and may be subject to our own legitimate interests and regulatory requirements. \n \n\n If you have any questions about this Privacy Policy, please contact us:\n \n\n By e-mail: support@givt.app\n By visiting this page on our Website: https://givt.co.uk/faq-3/\n By phone number: +44 20 3790 8068.\n \n\n Retention\n We will retain your personal information for as long as necessary to provide our services, and as necessary to comply with our legal obligations, resolve disputes, and enforce our policies. Retention periods will be determined taking into account the type of information that is collected and the purpose for which it is collected, bearing in mind the requirements applicable to the situation and the need to destroy outdated, unused information at the earliest reasonable time. Under applicable regulations, we will keep records containing client personal data, account opening documents, communications and anything else as required by applicable laws and regulations. \n \n\n We may rectify, replenish or remove incomplete or inaccurate information, at any time and at our own discretion.\n \n\n Use of Location Services\n \n\n The App may use the location services as provided by the operating system on the smartphone. With these services, the App may determine the location of the user. The location data will not be sent anywhere outside the smartphone, and is solely used to determine whether the user is in a location where it’s possible to use the App for donating. The locations where one can use App are downloaded to the smartphone prior to using the location services.\n \n\n How do we safeguard your information?\n \n\n We take security measures to reduce misuse of and unauthorised access to personal data. We take the following measures in particular:\n \n\n Access to personal data requires the use of a username and password\n Access to personal data requires the use of a username and login token\n We make use of secure connections (Secure Sockets Layer of SSL) to encrypt all information between you and our website when entering your personal data.\n We keep logs of all requests for personal data.\n \n\n Although we take reasonable steps to safeguard information, we cannot be responsible for the acts of those who gain unauthorised access or abuse our App, and we make no warranty, express, implied or otherwise, that we will prevent such access.\n \n\n Transfer of data outside the EEA \n Please note that some data recipients may be located outside the EEA. In such cases we will transfer your data only to such countries as approved by the European Commission as providing adequate level of data protection, or enter into legal agreements ensuring an adequate level of data protection.\n \n\n Advertisements\n We do not use third-party advertising technology to serve advertisements when you access the App. \n \n\n Marketing\n We may use your Personal Information, such as your name, email address to send you a Newsletter about our products and services. You may opt out of receiving this Newsletter at any time by unsubscribing via the link.\n \n\n Providing Data to Third Parties\n We may provide your information to our partners. These partners are involved in the execution of the agreement. In all cases, these parties are necessary to provide the services. These are not the collecting authorities, as we protect the anonymity of users.\n You agree that the transaction data are anonymous and can be used for data collection, statistics, reviews and comparisons. Only the summary will be shared with other customers and we ensure you that none of your data will be traceable to individuals.\n \n\n We will also never sell data to third parties. We are only committed to make it easier for the donor to give to charities of their choosing.\n \n\n Updates or amendments to this Privacy Policy\n We reserve the right to periodically amend or revise the Privacy Policy; material changes will be effective immediately upon the display of the revised Privacy policy. The last revision will be reflected in the \"Last modified\" section. Your continued use of our Services following the notification of such amendments on our Website or through the App, constitutes your acknowledgment and consent of such amendments to the Privacy Policy and your agreement to be bound by the terms of such amendments.\n \n\n How to contact us\n \n\n If you have any general questions about the App or the information we collect about you and how we use it, you can contact us at: support@givt.app\n \n\n or\n \n\n By visiting this page on our Website: https://givt.co.uk/faq-3/\n By phone number: +44 20 3790 8068.\n \n\n Givt Ltd. is a part of Givt B.V., our office is located on the Bongerd 159 in Lelystad, the Netherlands.\n Company Number (CRN): 11396586';

  @override
  String get amount => 'Betrag wählen';

  @override
  String get amountLimit => 'Bestimme den maximalen Betrag einer Spende.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get changePincode => 'Ändere deinen Zugangscode';

  @override
  String get checkInbox => 'Es hat funktioniert! Überprüfe deinen Posteingang.';

  @override
  String get city => 'Stadt';

  @override
  String get contactFailed => 'Etwas ist schief gelaufen. Versuche es noch einmal oder wähle den Empfänger manuell aus.';

  @override
  String get country => 'Land';

  @override
  String get email => 'E-Mail-Adresse';

  @override
  String get errorTextRegister => 'Bei der Erstellung des Kontos ist etwas schief gelaufen. Versuch es mit einer anderen E-Mail-Adresse.';

  @override
  String get fieldsNotCorrect => 'Eines der eingegebenen Felder ist nicht korrekt.';

  @override
  String get firstName => 'Vorname';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get forgotPasswordText => 'Gib deine E-Mail-Adresse ein. Wir senden dir eine E-Mail mit den Informationen, die du benötigst um dein Passwort ändern zu können.\n \n\n Falls Sie du die E-Mail nicht sofort finden kannst, überprüfe bitte auch den Spam-Ordner.';

  @override
  String get give => 'Spende';

  @override
  String get selectReceiverButton => 'Wähle den Empfänger aus';

  @override
  String get giveLimit => 'Maximalbetrag';

  @override
  String get givingSuccess => 'Vielen Dank für deine Spende!\n Du kannst den Status jederzeit in der Übersicht überprüfen.';

  @override
  String get information => 'Persönliche Information';

  @override
  String get lastName => 'Nachname';

  @override
  String get loggingIn => 'Einloggen.....';

  @override
  String get login => 'Login';

  @override
  String get loginPincode => 'Geben Sie Ihren Zugangs-Code ein';

  @override
  String get loginText => 'Um Zugang zu dem Konto zu erhalten, möchten wir erst sicher gehen, dass du auch wirklich du bist.';

  @override
  String get logOut => 'Abmelden';

  @override
  String get makeContact => 'Das ist der Givt-Moment.\n Führe dein Handy in Richtung der \n Sammelbox, Klingelbeutel oder dem Kollekten-Korb.';

  @override
  String get next => 'Weiter';

  @override
  String get noThanks => 'Nein, danke';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get password => 'Passwort';

  @override
  String get passwordRule => 'Das Passwort sollte mindestens 7 Zeichen lang sein und mindestens aus einem Großbuchstaben und einer Ziffer bestehen.';

  @override
  String get phoneNumber => 'Handynummer';

  @override
  String get postalCode => 'PLZ';

  @override
  String get ready => 'Fertig';

  @override
  String get register => 'Anmelden';

  @override
  String get registerBusy => 'Anmelden ...';

  @override
  String get registerPage => 'Melde dich an, um auf deine Givt-Informationen zugreifen zu können.';

  @override
  String get registerPersonalPage => 'Um deine Spende verarbeiten zu können, \n benötigen wir einige persönliche Informationen.';

  @override
  String get registerPincode => 'Gib deinen Zugangs-Code ein.';

  @override
  String get registrationSuccess => 'Registrierung erfolgreich.\n Viel Spaß beim Spenden!';

  @override
  String get security => 'Sicherheit';

  @override
  String get send => 'Senden';

  @override
  String get settings => 'Einstellungen';

  @override
  String get somethingWentWrong => 'Ups, etwas ist schief gelaufen.';

  @override
  String get streetAndHouseNumber => 'Straßenname und -nummer';

  @override
  String get tryAgain => 'Versuche es nochmal';

  @override
  String get welcome => 'Willkommen';

  @override
  String get wrongCredentials => 'Ungültige E-Mail-Adresse oder Passwort. Ist es möglich, dass du dich mit einem anderen E-Mail-Konto registriert hast?';

  @override
  String get yesPlease => 'Ja, bitte';

  @override
  String get bluetoothErrorMessage => 'Aktiviere dein Bluetooth, damit du bei einer Kollekte etwas geben kannst.';

  @override
  String get connectionError => 'Derzeit können wir keine Verbindung zum Server herstellen. Keine Sorge, trink eine Tasse Tee und / oder überprüfe deine Einstellungen.';

  @override
  String get save => 'Speichern';

  @override
  String get acceptPolicy => 'Ok, Givt ist berechtigt, meine Daten zu speichern.';

  @override
  String get close => 'Schließen';

  @override
  String get sendViaEmail => 'Per E-Mail versenden';

  @override
  String get termsTitle => 'Unsere Nutzungsbedingungen';

  @override
  String get shortSummaryTitleTerms => 'Es kommt auf Folgendes an:';

  @override
  String get fullVersionTitleTerms => 'Nutzungsbedingungen';

  @override
  String get termsText => 'Nutzungsbedingungen - Givt App\n Letzte Aktualisierung: 12.04.2018\n Deutsche Übersetzung der Version 1.9\n \n\n 1. Allgemeines\n Diese Nutzungsbedingungen beschreiben die Bedingungen, unter denen die mobile Anwendung Givt (\"Givt\") verwendet werden kann. Mit Givt kann der Benutzer (anonym) über sein Smartphone an, z. B. Kirchen, Spendenaktionen und Wohltätigkeitsorganisationen, die Mitglieder von Givt sind spenden. Givt wird von Givt B.V. verwaltet, einem privaten Unternehmen mit Sitz in Lelystad (8212 BJ), Bongerd 159, das im Handelsregister der Handelskammer unter der Nummer 64534421 (\"Givt B.V.\") eingetragen ist. Diese Nutzungsbedingungen gelten für die Nutzung von Givt. Durch die Verwendung von Givt (d.h. des Herunterladens und der Installation) akzeptieren Sie (\"der Benutzer\") diese Nutzungsbedingungen und unsere Datenschutzrichtlinie (https://www.givtapp.de/datenschutz/). Diese Nutzungsbedingungen und unsere Datenschutzbestimmungen können auch auf unserer Website heruntergeladen und ausgedruckt werden. Wir können diese Nutzungsbedingungen von Zeit zu Zeit überarbeiten.\n \n\n 2. Lizenz- und geistige Eigentumsrechte\n \n\n 2.1. Alle Rechte an Givt, der zugehörigen Dokumentation und allen Änderungen\n und Erweiterungen davon sowie deren Durchsetzung sind und bleiben\n das Eigentum von Givt B.V. Dem Benutzer werden ausschließlich die Rechte und Befugnisse und / oder Berechtigungen gewährt, die sich aus der Wirkung dieser Vereinbarung ergeben oder die schriftlich erteilt sind, und Sie dürfen Givt nicht anderweitig verwenden, reproduzieren oder veröffentlichen.\n \n\n 2.2. Givt B.V. gewährt dem Benutzer eine nicht exklusive, nicht unterlizenzierbare und\n nicht übertragbare Lizenz zur Nutzung von Givt. Der Benutzer darf Givt nicht für\n kommerzielle Zwecke verwenden.\n \n\n 2.3. Der Benutzer darf Givt weder an Dritte weitergeben noch verkaufen, vermieten, dekompilieren, Reverse Engineering unterziehen oder ändern ohne vorherige Genehmigung von Givt B.V. Der Benutzer darf auch nicht die Technik entfernen oder umgehen welche dazu bestimmt ist, Givt zu schützen.\n \n\n 2.4. Givt B.V. hat das Recht, Givt jederzeit zu ändern, d.h. Daten zu ändern oder zu entfernen,\n dem Benutzer die Nutzung von Givt durch Beendigung der Lizenz, Einschränkung der\n Nutzung von Givt oder Verweigerung des Zugangs zu Givt ganz oder teilweise, vorübergehend oder\n permanent zu verweigern. Die Givt B.V. wird den Benutzer in geeigneter Weise darüber informieren.\n \n\n 2.5. Der Benutzer erwirbt kein Recht, keinen Titel oder kein Interesse an den Rechten des geistigen Eigentums\n und / oder ähnliche Rechte an (den Mitteln von) Givt, einschließlich des Basiswerts an\n Software und Inhalten.\n \n\n 3. Die Verwendung von Givt\n \n\n 3.1. Der Benutzer kann nur Spenden an Kirchen, Wohltätigkeitsorganisationen und Spendenaktionen von\n Kampagnen und / oder andere juristische Personen veranlassen, die mit Givt verbunden sind. Das Spenden erfolgt anonym.\n \n\n 3.2. Die Verwendung von Givt erfolgt auf eigenes Risiko und auf eigene Kosten und sollte in Übereinstimmung mit den Zwecken für die es bestimmt ist erfolgen. Es ist verboten, Reverse Engineering des Quellcodes von Givt zu betreiben oder Givt zu dekompillieren und / oder zu ändern, eine Kopie von Givt Dritten zugänglich zu machen oder Bezeichnungen von Givt B.V. als Partei, die die Rechte an Givt besitzt, unleserlich zu machen oder Teile davon zu entfernen oder zu löschen.\n \n\n 3.3. Der Benutzer ist für die korrekte Angabe von Daten wie Name und Adressdaten, Bankkontonummer und andere Informationen, die von Givt B.V. benötigt werden, um die Verwendung von Givt sicherzustellen, verantwortlich.\n \n\n 3.4. Wenn der Benutzer jünger als 18 Jahre ist, muss er die Zustimmung eines\n Elternteils oder Erziehungsberechtigten haben, um Givt zu nutzen. Durch Akzeptieren dieser Nutzungsbedingungen garantiert der Benutzer, dass er 18 Jahre alt ist oder die Erlaubnis seiner Eltern oder seines gesetzlichen Vertreters hat.\n \n\n 3.5. Givt ist für die Betriebssysteme Android und iOS verfügbar. Zusätzlich zu\n den unten aufgeführten Bestimmungen können im App Store von Apple oder bei Google Play Bedingungen für den Erwerb von Givt, seine Verwendung und damit verbundene Angelegenheiten beigefügt werden. Weitere Informationen finden Sie in den Nutzungsbedingungen und Datenschutzbestimmungen sowie alle anderen geltenden Geschäftsbedingungen des App Store von Apple und Google Play auf den Webseiten des jeweiligen Anbieters. Diese Endbenutzerlizenz gilt für die Vereinbarung zwischen dem Benutzer und Givt B.V. und nicht zwischen dem Benutzer und dem Anbieter der Plattform, über die Sie Givt erworben haben. Dieser Anbieter kann Sie jedoch für Verstöße gegen Bestimmungen dieser Endbenutzerlizenz haftbar machen.\n \n\n 3.6. Nachdem der Benutzer Givt heruntergeladen hat, wird er aufgefordert, sich zu registrieren.\n Dabei muss der Benutzer die folgenden Informationen angeben: (i) Name (ii)\n Adresse, (iii) Telefonnummer, (iv) Bankkontonummer und (v) E-Mail\n Adresse. Die Datenschutzerklärung von Givt B.V. gilt für die Verarbeitung von\n personenbezogene Daten via Givt. Der Benutzer muss Givt unverzüglich durch Korrektur der Informationen in der App informieren, wenn Datenänderungen vorliegen.\n \n\n 3.7. Der Benutzer kann nach der Installation der Givt-App auch nur durch eingeben seiner E-Mail-Adresse sofort die App nutzen, um zu spenden. Nach der Spende wird der Benutzer jedoch aufgefordert, den Registrierungsvorgang abzuschließen. Wenn der Benutzer dies später tun möchte, stellt Givt B.V. sicher, dass nur die E-Mail-Adresse des Benutzers verwendet wird, um den Benutzer daran zu erinnern, den Registrierungsvorgang abzuschließen, bis dieser Vorgang endgültig abgeschlossen ist.\n \n\n 3.8. Der Benutzer ist für alle Kosten im Zusammenhang mit der Ausstattung, Software und der System- und (Internet-) Verbindung zur Nutzung von Givt verantwortlich.\n \n\n 3.9. Givt B.V. bietet die zugehörigen Dienste basierend auf den Informationen des Benutzers an, welche dieser zur Verfügung stellt. Der Nutzer ist verpflichtet, korrekte und vollständige Angaben zu machen, welche nicht falsch oder irreführend sind. Der Benutzer darf keine Daten in Bezug auf auf Namen oder Bankkonten, zu deren Verwendung der Benutzer nicht berechtigt ist preisgeben. Givt B.V. und der Verarbeiter haben das Recht, die Informationen, die der Benutzer zur Verfügung gestellt hat, zu validieren und zu verifizieren.\n \n\n 3.10. Der Benutzer kann die Nutzung von Givt jederzeit durch Löschen seines\n Kontos über das Menü in der App oder per E-Mail an support@givt.app beenden. \n Das Löschen der App allein auf dem Smartphone, ohne die oben genannten Schritte ausgeführt zu haben, führt nicht zum Löschen der Benutzerdaten. Givt kann die Beziehung mit dem Benutzer beenden, wenn der Benutzer diese Allgemeinen Geschäftsbedingungen nicht einhält oder wenn Givt 18 aufeinanderfolgende Monate nicht verwendet wurde. Auf Anfrage kann Givt\n eine Liste aller Spendendaten schicken.\n \n\n 3.11. Givt B.V. berechnet keine Nutzungsgebühren für die Nutzung von Givt.\n \n\n 3.12. Givt B.V. hat das Recht, die angebotenen Funktionen von Zeit zu Zeit anzupassen, zu verbessern, zu ändern oder Fehler zu beheben. Givt B.V. wird immer daran arbeiten, Fehler innerhalb der Givt-Software zu beheben, kann aber nicht garantieren, dass alle Fehler zeitnah behoben werden können.\n \n\n 4. Transaktionen verarbeiten\n \n\n 4.1. Givt B.V. ist keine Bank / Finanzinstitut und bietet keine Bankgeschäfte oder\n Zahlungsabwicklungsdienste an. Um die Bearbeitung von Spenden des Benutzers zu erleichtern, hat Givt B.V. eine Vereinbarung mit einem Zahlungsdienst-Anbieter namens SlimPay geschlossen. SlimPay ist ein Finanzinstitut (der \"Verarbeiter\") mit dem vereinbart wurde, dass Givt B.V. die Transaktionsinformationen an den Verarbeiter sendet, um Spenden zu initiieren und zu bearbeiten. Givt B.V. wird nach dem Sammeln der Spenden sicher stellen, dass die Spenden an die vom Benutzer benannten Begünstigten weitergeleitet werden. Die Transaktionsdaten werden verarbeitet und\n an den Givt-Verarbeiter weitergeleitet. Der Verarbeiter leitet die Zahlungstransaktionen ein, während Givt B.V. für die Transaktion der\n relevante Beträge auf das Bankkonto der Kirche / Stiftung als\n den vom Benutzer bestimmten Empfänger der Spende verantwortlich ist.\n \n\n 4.2. Der Benutzer erklärt sich damit einverstanden, dass Givt B.V. die (Transaktions- und Bank-)Daten des Benutzers an den Verarbeiter weitergeben kann, zusammen mit allen anderen erforderlichen Konto- und persönlichen\n Informationen des Benutzers, damit der Verarbeiter die \n Zahlungsvorgänge und -abwicklung initiieren kann. Givt B.V. behält sich das Recht vor, jederzeit einen Wechsel des Verarbeiters vorzunehmen. Der Nutzer erklärt sich damit einverstanden, dass Givt B.V. relevante Informationen und Daten über den Benutzer gemäß Artikel 3.6 an den neuen Verarbeiter weitergibt, um weiterhin Zahlungsvorgänge verarbeiten zu können.\n \n\n 4.3. Givt B.V. und der Verarbeiter verarbeiten die Daten des Benutzers in Übereinstimmung mit den Gesetzen und Vorschriften, die für den Datenschutz gelten. Für weitere Informationen darüber, wie personenbezogene Daten gesammelt, verarbeitet und verwendet werden, verweist Givt B.V. den Benutzer auf seine Datenschutzerklärung. Diese Erklärung finden Sie online\n (www.givtapp.net/de/privacystatementgivt-service/).\n \n\n 4.4. Die Spenden des Nutzers gehen über Givt B.V. als Vermittler. \n Givt B.V. wird sicherstellen, dass die Mittel an den Begünstigten überwiesen werden, mit wem Givt B.V. eine Vereinbarung hat.\n \n\n 4.5. Der Benutzer muss Givt B.V. und / oder den Verarbeiter autorisieren (für die automatische SEPA Lastschrift), um eine Spende mit Givt zu tätigen. Der Benutzer kann jederzeit innerhalb der\n Bedingungen der Bank des Benutzers eine Lastschrift zurückziehen.\n \n\n 4.6. Givt B.V. und / oder der Verarbeiter können eine Spende ablehnen, wenn \n Grund zu der Annahme besteht, dass ein Benutzer gegen diese Bedingungen verstößt oder Grund zu der Annahme besteht, dass eine Spende möglicherweise verdächtig oder illegal ist. In diesem Fall wird Givt B.V. den Benutzer so bald wie möglich darüber informieren, es sei denn dies ist \n gesetzlich verboten.\n \n\n 4.7. Spenden mit Givt unterliegen folgenden Beschränkungen: EUR 1000 pro\n Spende und EUR 25000 pro Kalenderjahr.\n \n\n 4.8. Der Benutzer erklärt sich damit einverstanden, dass Givt B.V. (Transaktions-)Daten des Benutzers an lokale Steuerbehörden weitergeben kann, zusammen mit allen anderen notwendigen Konto- und persönlichen\n Informationen des Nutzers, um den Nutzer bei seiner jährlichen Steuererklärung zu unterstützen.\n \n\n 5. Sicherheit, Diebstahl und Verlust\n \n\n 5.1. Der Benutzer trifft alle angemessenen Vorkehrungen, um sein Login-Anmeldeinformationen für Givt sicher aufzubewahren, um Verlust, Diebstahl, Veruntreuung oder unbefugte Verwendung von Givt bei der Nutzung auf seinem Smartphone zu vermeiden.\n \n\n 5.2. Der Benutzer ist für die Sicherheit seines Smartphones verantwortlich. Givt B.V. betrachtet jede Spende vom Givt-Konto als vom Benutzer genehmigte\n Transaktion, unabhängig von den Rechten des Nutzers gemäß Artikel 4.5.\n \n\n 5.3. Der Benutzer hat Givt B.V. unverzüglich via info@givt.app oder +31 320 320 115 zu informieren sobald sein Smartphone verloren geht oder gestohlen wird. Nach Erhalt einer Nachricht an Givt B.V. wird das betroffene Konto gesperrt, um (weiteren) Missbrauch zu verhindern.\n \n\n 6. Aktualisierungen\n \n\n 6.1. Givt B.V. veröffentlicht von Zeit zu Zeit Updates, die Fehler beheben können oder die Funktionalität von Givt verbessern. Verfügbare Updates für Givt werden\n durch Benachrichtigung über Apples App Store und Google Play angekündigt\n und es liegt in der alleinigen Verantwortung des Benutzers, diese Benachrichtigungen zu überwachen und über neue Updates auf dem Laufenden zu bleiben.\n \n\n 6.2. Ein Update kann Bedingungen enthalten, die von den hier beschriebenen Bestimmungen abweichen können.\n Dies wird dem Benutzer immer im Voraus mitgeteilt, damit er\n die Möglichkeit hat, das Update abzulehnen. Durch die Installation eines solchen Updates stimmt der Benutzer diesen neuen Bedingungen zu, die dann Teil dieser Vereinbarung sind. Wenn der Benutzer den geänderten Bedingungen nicht zustimmt, darf er Givt nicht mehr verwenden und muss Givt von seinem Gerät löschen.\n \n\n 7. Haftung\n \n\n 7.1. Givt wurde mit größter Sorgfalt zusammengestellt. Obwohl Givt B.V. sich bemüht Givt 24 Stunden am Tag zur Verfügung zu stellen, übernimmt Givt B.V. keine Haftung, wenn aus irgendeinem Grund Givt zu einem bestimmten Zeitpunkt oder für einen bestimmten Zeitraum nicht verfügbar ist. Givt\n B.V. behält sich das Recht vor, Givt vorübergehend oder dauerhaft einzustellen\n (unangemeldet). Der Benutzer kann daraus keine Rechte ableiten.\n \n\n 7.2. Givt B.V. haftet nicht für Schäden oder Verletzungen, die durch die Verwendung von Givt entstehen. Die in diesem Artikel erwähnten Haftungsbeschränkungen erlöschen, wenn die \n Schäden aus Vorsatz oder grober Fahrlässigkeit von Givt B.V. resultieren.\n \n\n 7.3. Der Nutzer stellt Givt B.V. von jeglichen Ansprüchen Dritter frei (z.\n B. Begünstigung der Spenden oder der Steuerbehörde), die als Ergebnis der Verwendung von Givt oder der nicht ordnungsgemäßen Einhaltung der getroffenen Vereinbarungen in Bezug auf rechtliche oder vertragliche Verpflichtungen mit der Givt B.V. entstehen. Der Benutzer zahlt\n alle Schäden und Kosten, die Givt B.V. aufgrund solcher Ansprüche entstehen.\n \n\n 8. Sonstige Bestimmungen\n \n\n 8.1. Diese Vereinbarung tritt mit Beginn der Nutzung von Givt in Kraft und\n bleibt für einen unbestimmten Zeitraum von diesem Moment an in Kraft. Diese\n Vereinbarung kann sowohl vom Benutzer als auch von Givt B.V. jederzeit mit einer Frist von einem Monat gekündigt werden. Diese Vereinbarung endet kraft Gesetzes für den Fall, dass Sie für bankrott erklärt werden, ein Zahlungsmoratorium beantragt haben oder eine allgemeine Pfändung von Vermögenswerten gegen Sie erhoben wird, im Falle Ihres Todes oder im Falle Ihrer Liquidation, Abwicklung oder Auflösung. Nach Beendigung dieser Vereinbarung (aus welchem ​​Grund auch immer), werden Sie jede weitere Verwendung von Givt einstellen und unterlassen. Sie müssen dann alle Kopien (einschließlich Sicherungskopien) von Givt von allen Ihren Geräten löschen.\n \n\n 8.2. Wenn eine Bestimmung dieser Allgemeinen Geschäftsbedingungen nichtig ist oder für ungültig erklärt wird, ist die Gültigkeit der Vereinbarung als Ganze und andere Bestimmungen davon nicht beeinträchtigt. Diese Bedingungen bleiben in Kraft. In diesem Fall entscheiden die Parteien über eine neue\n Ersatzbestimmung oder -Bestimmungen, welche der Absicht \n der ursprünglichen Vereinbarung, soweit dies rechtlich möglich ist, entsprechen.\n \n\n 8.3. Der Nutzer ist nicht berechtigt, die sich durch die Verwendung von Givt und diesen Bedingungen ergebenden Rechte und / oder Pflichten ohne vorherige schriftliche Genehmigung von Givt B.V. an Dritte zu übertragen.\n Umgekehrt ist Givt B.V. dazu berechtigt.\n \n\n 8.4. Alle Streitigkeiten, die sich aus oder im Zusammenhang mit diesen Bedingungen ergeben, sind endgültig im Gericht von Lelystad angesiedelt. Bevor der Streit vor Gericht gebracht wird, werden wir uns bemühen, den Streit gütlich beizulegen.\n \n\n 8.5. Für diese Nutzungsbedingungen gilt das niederländische Recht.\n \n\n 8.6. Die Nutzungsbedingungen berühren nicht die gesetzlichen Rechte des Nutzers als Verbraucher.\n \n\n 8.7. Givt B.V. verfügt über ein internes Beschwerdeverfahren. Givt B.V. behandelt Beschwerden effizient und so schnell wie möglich. Jede Beschwerde\n über die Umsetzung dieser Bedingungen durch Givt B.V. muss \n schriftlich bei Givt B.V. eingereicht werden (via support@givt.app).';

  @override
  String get prepareMobileTitle => 'Bevor du beginnst';

  @override
  String get prepareMobileExplained => 'Für eine optimale Erfahrung mit Givt benötigen wir deine Erlaubnis, um dir Benachrichtigungen senden zu können.';

  @override
  String get prepareMobileSummary => 'Auf diese Weise weißt du immer, wo und wann du spenden kannst.';

  @override
  String get policyText => 'Datenschutzerklärung von Givt B.V.\n \n\n Übersetzung vom Original 1.9 (3. März 2021)\n \n\n Über seinen Service verarbeitet Givt datenschutzrelevante oder personenbezogene Daten. Givt B.V. schätzt die Privatsphäre seiner Kunden und achtet bei der Verarbeitung und dem Schutz personenbezogener Daten auf die gebotene Sorgfalt.\n \n\n Während der Verarbeitung halten wir uns an die Anforderungen der Datenschutzgrundverordnung (EU 2016/679, auch als DSGVO bekannt). Das heißt wir:\n - Geben unsere Zwecke klar an, bevor wir personenbezogene Daten verarbeiten, indem wir diese Datenschutzerklärung verwenden.\n - Beschränken unsere Erhebung personenbezogener Daten auf ausschließlich die personenbezogenen Daten, die für legitime Zwecke benötigt werden.\n - Bitten zunächst um die ausdrückliche Erlaubnis, Ihre persönlichen Daten (und Daten anderer Personen in der von Ihnen vertretenen Organisation) in Fällen zu verarbeiten, in denen Ihre Erlaubnis erforderlich ist.\n - Ergreifen geeignete Sicherheitsmaßnahmen, um Ihre persönlichen Daten zu schützen, und wir fordern dies auch von Parteien, die personenbezogene Daten in unserem Namen verarbeiten.\n - Respektieren Ihr Recht, Ihre bei uns gespeicherten personenbezogenen Daten einzusehen, zu korrigieren oder zu löschen.\n \n\n Givt B.V. ist für die gesamte Datenverarbeitung verantwortlich. Unsere Datenverarbeitung ist bei der niederländischen Datenschutzbehörde unter der Nummer M1640707 registriert. In dieser Datenschutzerklärung erläutern wir, welche personenbezogenen Daten wir zu welchen Zwecken erheben. Wir empfehlen Ihnen, diese sorgfältig zu lesen.\n \n\n Diese Datenschutzerklärung wurde zuletzt am 03.03.2021 geändert.\n \n\n Verwendung personenbezogener Daten\n Durch die Nutzung unseres Dienstes stellen Sie uns bestimmte Daten zur Verfügung. Dies können personenbezogene Daten sein (und Daten anderer Personen in der von Ihnen vertretenen Organisation). Wir speichern und verwenden nur die personenbezogenen Daten, die direkt von Ihnen bereitgestellt wurden oder für die klar ist, dass sie uns zur Verarbeitung zur Verfügung gestellt wurden.\n Wir verwenden die folgenden Daten für die in dieser Datenschutzerklärung genannten Zwecke:\n - Name und Adresse\n - Telefonnummer\n - E-Mail-Addresse\n - Zahlungsdetails\n \n\n Anmeldung\n Für bestimmte Funktionen unseres Dienstes müssen Sie sich oder die Organisation, welche Sie vertreten, im Voraus registrieren. Nach Ihrer Registrierung behalten wir Ihren Benutzernamen und die von Ihnen angegebenen persönlichen Daten. Wir werden diese Daten speichern, damit Sie sie nicht bei jedem Besuch unserer Website diese erneut eingeben müssen, um Sie im Zusammenhang mit der Ausführung des Vertrags, der Rechnungsstellung und der Zahlung zu kontaktieren und einen Überblick über die von Ihnen angebotenen Produkte und Dienstleistungen zu erhalten, welche Sie bei uns gekauft haben.\n Wir werden die mit Ihrem Benutzernamen verknüpften Daten nicht an Dritte weitergeben, es sei denn, dies ist für die Ausführung des von Ihnen mit uns geschlossenen Vertrags erforderlich oder gesetzlich vorgeschrieben. Bei Verdacht auf Betrug oder Missbrauch unserer Website können wir personenbezogene Daten an die berechtigten Behörden weitergeben.\n  \n \n\n Werbung\n Neben den Anzeigen auf der Website können wir Sie über neue Produkte oder Dienstleistungen informieren:\n - per E-Mail\n \n\n Kontaktformular und Newsletter\n Wir haben einen Newsletter, um Interessenten über unsere Produkte und / oder Dienstleistungen zu informieren. Jeder Newsletter enthält einen Link, über den Sie unseren Newsletter abbestellen können. Ihre E-Mail-Adresse wird automatisch zur Liste der Abonnenten hinzugefügt.\n Wenn Sie das Kontaktformular auf der Website ausfüllen oder uns eine E-Mail senden, werden die von Ihnen angegebenen Daten so lange gespeichert, wie dies je nach Art des Formulars oder Inhalt Ihrer E-Mail erforderlich ist, um Ihnen vollständig zu antworten und Ihre Nachricht oder E-Mail richtig zu behandeln.\n \n\n Veröffentlichung\n Wir werden Ihre Daten nicht veröffentlichen.\n \n\n Bereitstellung von Daten an Dritte\n Wir können Ihre Informationen an unsere Partner weitergeben. Diese Partner sind an die Ausführung der Vereinbarung gebunden. In allen Fällen sind diese Parteien zur Erbringung der geschuldeten Dienstleistungen erforderlich. Personenbezogene Daten werden nicht an andere sammelnde Parteien weitergegeben, da wir die Anonymität der Spender schützen.\n \n\n Sie stimmen zu, dass die Transaktionsdaten anonym sind und für die Datenerfassung, Statistik, Überprüfung und Vergleiche verwendet werden können. Nur die Zusammenfassung wird an andere Kunden weitergegeben, und wir stellen sicher, dass keine Ihrer Daten auf eine Einzelperson zurückführbar sind.\n Wir werden auch niemals Daten an Dritte verkaufen. Wir sind nur bestrebt, es dem Spender zu erleichtern, an Wohltätigkeitsorganisationen ihrer Wahl zu spenden.\n \n\n Sicherheit\n Wir ergreifen Sicherheitsmaßnahmen, um den Missbrauch und den unbefugten Zugriff auf personenbezogene Daten zu verringern. Wir ergreifen insbesondere folgende Maßnahmen:\n - Der Zugriff auf personenbezogene Daten erfordert die Verwendung eines Benutzernamens und eines Passworts\n - Für den Zugriff auf personenbezogene Daten müssen ein Benutzername und ein Anmeldetoken verwendet werden\n - Wir verwenden sichere Verbindungen (Secure Sockets Layer of SSL), um alle Informationen zwischen Ihnen und unserer Website bei der Eingabe Ihrer persönlichen Daten zu verschlüsseln.\n - Wir führen Protokolle aller Anfragen nach personenbezogenen Daten.\n \n\n Nutzung von Ortungsdiensten\n Die App verwendet möglicherweise die vom Betriebssystem auf dem Smartphone bereitgestellten Ortungsdienste. Mit diesen Diensten kann die App den Standort des Benutzers bestimmen. Diese Standortdaten werden nicht an eine Stelle außerhalb des Smartphones gesendet, sondern nur verwendet, um festzustellen, ob sich der Benutzer an einem Ort befindet, an dem Givt für Spenden verwendet werden kann. Die Standorte, an denen Givt verwendet werden kann, werden vor der Verwendung der Ortungsdienste auf das Smartphone heruntergeladen.\n \n\n Diagnoseinformationen aus der App\n Die App sendet anonymisierte Informationen über die Funktionalität der App. Diese Informationen enthalten keine personenbezogene Daten, sondern nur Allgemeine Informationen Ihres Smartphones wie Typ und Betriebssystem, aber auch die Versionsnummer der App. Diese Daten werden ausschließlich dazu verwendet, den Service von Givt zu verbessern oder bessere Antworten auf Ihre Fragen zu ermöglichen. Diese Informationen werden niemals an Dritte weitergegeben.\n \n\n Änderungen dieser Datenschutzerklärung\n Wir behalten uns das Recht vor, diese Erklärung zu ändern. Wir empfehlen Ihnen, diese Erklärung regelmäßig zu überprüfen, damit Sie über Änderungen auf dem Laufenden bleiben.\n \n\n Überprüfung und Änderung Ihrer Daten\n Sie können uns jederzeit kontaktieren, wenn Sie Fragen zu unserer Datenschutzerklärung haben oder Ihre persönlichen Daten überprüfen, ändern oder löschen möchten.\n \n\n Givt B.V.\n Bongerd 159\n 8212 BJ LELYSTAD\n +31 320 320 115\n KvK: 64534421';

  @override
  String get needHelpTitle => 'Benötigst du Hilfe?';

  @override
  String get findAnswersToYourQuestions => 'Hier findest du Antworten auf häufige Fragen und nützliche Tipps';

  @override
  String get questionHowDoesRegisteringWorks => 'Wie funktioniert die Registrierung?';

  @override
  String get questionWhyAreMyDataStored => 'Warum speichert Givt meine personenbezogenen Daten?';

  @override
  String get faQvraag1 => 'Was ist Givt?';

  @override
  String get faQvraag2 => 'Wie funktioniert Givt?';

  @override
  String get faQvraag3 => 'Wie kann ich meine Einstellungen oder persönlichen Daten ändern?';

  @override
  String get faQvraag4 => 'Wo kann ich Givt einsetzen?';

  @override
  String get faQvraag5 => 'Wie wird meine Spende abgebucht?';

  @override
  String get faQvraag6 => 'Welche Möglichkeiten gibt es mit Givt?';

  @override
  String get faQvraag7 => 'Wie sicher ist es, mit Givt zu spenden?';

  @override
  String get faQvraag8 => 'Wie kann ich mein Givt-Konto löschen?';

  @override
  String get faQantwoord1 => 'Spende mit deinem Handy\n Givt ist die Lösung für das Spenden mit deinem Smartphone, wenn du kein Bargeld bei dir hast. Jeder besitzt ein Smartphone und mit der Givt-App können Sie ganz einfach mitmachen.\n Spenden ist ein persönlicher und bewusster Moment, da wir glauben, dass eine Spende nicht nur eine rein finanzielle Transaktion ist. Die Verwendung von Givt fühlt sich so natürlich an wie das Geben von Bargeld.\n \n\n Warum \"Givt\"?\n Der Name Givt wurde gewählt, weil es sowohl um das Geben als auch um das Schenken eines Geschenks geht. Wir suchten nach einem modernen und kompakten Namen, der freundlich und verspielt wirkt. In unserem Logo werden Sie möglicherweise feststellen, dass der grüne Balken in Kombination mit dem Buchstaben \"v\" die Form eines Klingelbeutels bildet, die eine Vorstellung von der Funktion der App vermitteln soll.\n \n\n Niederlande, Belgien, Vereinigtes Königreich und Deutschland\n Hinter Givt steht ein multinationales Team von Spezialisten, das auf die Niederlande, Belgien, Vereinigte Königreich und Deutschland das verteilt ist. Jeder von uns arbeitet aktiv an der Entwicklung und Verbesserung von Givt. Erfahre mehr über uns auf www.givtapp.de';

  @override
  String get faQantwoord2 => 'Der erste Schritt war die Installation der App. Damit Givt effektiv funktioniert, ist es wichtig, dass Bluetooth aktiviert ist und dein Handy über eine funktionierende Internetverbindung verfügt.\n \n\n Dann registrieren dich, indem du deine Daten eingibst und ein Mandat unterzeichnest.\n Nun bist du bereit zu geben! Öffne die App, wähle einen Betrag und scann einen QR-Code, beweg dein Telefon in Richtung Kingelbeutel oder Korb oder wähle ein Ziel aus der Liste aus.\n Der von dir gewählte Betrag wird gespeichert, von deinem Konto abgebucht und an die Kirche oder die sammelnde Wohltätigkeitsorganisation verteilt.\n \n\n Wenn du zum Zeitpunkt der Spende keine Internetverbindung hast, wird die Spende zu einem späteren Zeitpunkt gesendet, wenn wieder eine Internetverbindung besteht und die App erneut öffnen z.B. wenn du dich in einem WLAN befindest.';

  @override
  String get faQantwoord3 => 'Du kannst auf das App-Menü zugreifen, indem du auf das Menü oben links im Bildschirm \"Betrag\" tippst. Um deine Einstellungen zu ändern, musst du dich zunächst mit deiner E-Mail-Adresse und Passwort oder falls aktiviert via PIN, Fingerabdruck / Touch-ID oder FaceID anmelden. Im Menü findest du eine Übersicht über deine Spenden, kannst deinen Maximalbetrag anpassen, deine persönlichen Daten überprüfen und / oder ändern, die Betragsvoreinstellungen ändern, Fingerabdruck / Touch-ID oder FaceID festlegen oder das Givt-Konto kündigen.';

  @override
  String get faQantwoord4 => 'Immer mehr Organisationen\n Du kannst Givt bei allen Organisationen verwenden, die bei uns registriert sind. Jede Woche treten weitere Organisationen bei. Die neueste Übersicht findest du unter www.givtapp.net/en/where-to-use-givt.\n \n\n Noch nicht registriert?\n Falls Ihre Organisation noch nicht mit Givt verbunden ist, kontaktieren Sie uns bitte unter +49 391 5054 7299 oder info@givtapp.net.';

  @override
  String get faQantwoord5 => 'SlimPay\n Bei der Installation von Givt erteilt der Benutzer der App die Berechtigung, sein Konto zu belasten. Die Transaktionen werden von Slimpay abgewickelt - einer Bank, die sich auf die Bearbeitung von Mandaten spezialisiert hat.\n \n\n Danach widerruflich\n Im Moment des Gebens finden keine Transaktionen statt. Die Transaktionen erfolgen anschließend per Lastschrift. Da diese Transaktionen widerruflich sind, ist sie absolut sicher und immun gegen Betrug.';

  @override
  String get faQantwoord6 => 'Entwickelt sich stets weiter\n Givt entwickelt seinen Service immer weiter. Im Moment können Sie während einer Kollekte problemlos mit dem Smartphone geben, aber hier hört es nicht auf. Neugierig, woran wir arbeiten? Besuche uns bei einer unserer Demos am Freitagnachmittag.\n \n\n Steuererklärung\n Am Ende des Jahres kannst du eine Übersicht über alle deine getätigten Spenden anfordern, was dir bei der Erstellung einer Steuererklärung das Leben erleichtert. Letztendlich arbeiten wir daran, dass alle Spenden automatisch in die Erklärung eingetragen werden.';

  @override
  String get faQantwoord7 => 'Sicher und risikofrei\n Es ist uns sehr wichtig, dass alles so sicher wie irgend möglich und risikofrei ist. Jede(r) Nutzer/-in hat ein persönliches Konto mit einem eigenen Passwort. Man muss sich daher anmelden, um die eignen Einstellungen anzuzeigen oder ändern zu können.\n \n\n Transaktionen abwickeln\n Die Transaktionen werden von Slimpay abgewickelt - einer Bank, die sich auf die Bearbeitung von Mandaten spezialisiert hat. SlimPay steht unter der Aufsicht mehrerer nationaler Banken in Europa, einschließlich der niederländischen Zentralbank (DNB).\n \n\n Immun gegen Betrug\n Bei der Installation von Givt erteilen die Nutzer der App die Berechtigung, das Konto zu belasten.\n Wir möchten betonen, dass im Moment des Gebens keinerlei Transaktionen stattfinden. Die Transaktionen erfolgen anschließend ausschließlich per Lastschrift. Da diese Transaktionen widerruflich sind, ist sie absolut sicher und immun gegen Betrug.\n \n\n Überblick\n Unternehmen können sich beim Givt-Dashboard anmelden. Dieses Dashboard bietet einen Überblick über alle Finanztransaktionen vom Zeitpunkt der Spende bis zur vollständigen Verarbeitung der Zahlung. Auf diese Weise kann jede Sammlung von Anfang bis Ende nachverfolgt werden.\n Organisationen können sehen, wie viele Personen Givt verwendet haben, aber nicht wer genau gespendet hat.';

  @override
  String get faQantwoord8 => 'Es tut uns leid, das zu hören! Wir würden gerne wissen warum?\n \n\n Falls du Givt nicht mehr verwenden möchtest, kannst du alle Givt-Dienste abbestellen.\n Um sich abzumelden, gehe über das Benutzermenü zu den Einstellungen und wähle \"Mein Konto kündigen\".';

  @override
  String get privacyTitle => 'Datenschutzerklärung';

  @override
  String get acceptTerms => 'Indem du fortfährst, stimmst du unseren Allgemeinen Geschäftsbedingungen zu.';

  @override
  String get mandateSigingFailed => 'Das Mandat konnte nicht unterschrieben werden. Versuche es später noch einmal über das Menü. Erscheint diese Nachricht immer wieder? Kontaktiere uns via support@givtapp.net .';

  @override
  String get awaitingMandateStatus => 'Wir benötigen einen Moment um dein Mandat zu bearbeiten.';

  @override
  String get requestMandateFailed => 'Derzeit ist es leider nicht möglich, ein Mandat zu beantragen. Bitte versuche es in einigen Minuten erneut.';

  @override
  String get faqHowDoesGivingWork => 'Wie kann ich geben?';

  @override
  String get faqHowDoesManualGivingWork => 'Wie kann ich den Empfänger auswählen?';

  @override
  String givtNotEnough(Object value0) {
    return 'Tut mir Leid, aber der Mindestbetrag den wir verarbeiten können beträgt $value0.';
  }

  @override
  String get slimPayInformationPart2 => 'Deshalb bitten wir dich diesmal, ein SEPA eMandate zu unterzeichnen.\n \n\n Da wir mit Mandaten arbeiten, hast du die Möglichkeit, deine Spende ggf. zu widerrufen, wenn du dies wünschst.';

  @override
  String get unregister => 'Account löschen';

  @override
  String get unregisterInfo => 'Wir sind traurig, dich gehen zu sehen! Wir werden all deine persönlichen Daten löschen.\n \n\n Es gibt eine Ausnahme: Wenn Sie an eine von PBO registrierte Organisation gespendet haben, sind wir verpflichtet, die Informationen über Ihre Spende, Ihren Namen und Ihre Adresse mindestens 7 Jahre lang aufzubewahren. Ihre E-Mail-Adresse und Telefonnummer werden jedoch gelöscht.';

  @override
  String get unregisterSad => 'Wir sind sehr traurig, dass du gehst und hoffen, dass wir dich bald wiedersehen.';

  @override
  String get historyTitle => 'Spendenhistorie';

  @override
  String get historyInfoTitle => 'Spendendetails';

  @override
  String get historyAmountAccepted => 'In Bearbeitung';

  @override
  String get historyAmountCancelled => 'Vom Benutzer abgebrochen';

  @override
  String get historyAmountDenied => 'Von der Bank abgelehnt';

  @override
  String get historyAmountCollected => 'Bearbeitet';

  @override
  String get loginSuccess => 'Viel Spaß beim Spenden!';

  @override
  String get historyIsEmpty => 'Hier findest du Informationen zu deinen getätigten Spenden, aber zuerst musst du natürlich erstmal mit dem Spenden beginnen';

  @override
  String get errorEmailTooLong => 'Entschuldigung, deine E-Mail-Adresse ist zu lang.';

  @override
  String get updateAlertTitle => 'Update verfügbar';

  @override
  String get updateAlertMessage => 'Eine neue Version von Givt ist verfügbar. Möchtest du sie jetzt aktualisieren?';

  @override
  String get criticalUpdateTitle => 'Wichtiges Update';

  @override
  String get criticalUpdateMessage => 'Ein neues kritisches Update ist verfügbar. Dies ist für das ordnungsgemäße Funktionieren der Givt-App unbedingt erforderlich.';

  @override
  String organisationProposalMessage(Object value0) {
    return 'Möchtest du an $value0 spenden?';
  }

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get faQvraag9 => 'Wo kann ich eine Übersicht über meine Spenden sehen?';

  @override
  String get faQantwoord9 => 'Drücke auf das Menü oben links im Bildschirm \"Betrag\", um auf das App-Menü zuzugreifen. Um Zugang zu erhalten, musst du dich mit deiner E-Mail-Adresse und Passwort oder Passcode anmelden. Wähle \"Spendenverlauf\", um einen Überblick über die letzten Aktivitäten zu erhalten. Diese Liste besteht aus dem Namen des Empfängers, der Uhrzeit und dem Datum der Spende. Die farbige Linie zeigt den Status der Spende an: In Bearbeitung, verarbeitet, von der Bank abgelehnt oder vom Benutzer storniert.\n Du kannst am Ende eines jeden Jahres eine Übersicht über deine getätigten Spenden für deine Steuererklärung anfordern.';

  @override
  String get faqQuestion11 => 'Wie aktiviere ich einen Passcode, meine Touch-ID oder FaceID?';

  @override
  String get faqAnswer11 => 'Gehe in die Einstellungen, indem du oben links auf dem Bildschirm auf Menü klickst. Dort kannst du die Givt-App mit einem Fingerabdruck /Touch-ID oder FaceID (nur auf bestimmten iPhones verfügbar) schützen.\n \n\n Wenn eine dieser Einstellungen aktiviert ist, kannst du damit direkt auf deine Einstellungen zugreifen, anstatt erst deine E-Mail-Adresse und Ihr Kennwort zu verwenden.';

  @override
  String get answerHowDoesRegistrationWork => 'Um Givt nutzen zu können, musst du dich in der Givt-App registrieren. Gehe dazu in das App-Menü und wähle \"Registrierung beenden\". Du richtest ein Givt-Konto ein, gibst einige persönliche Daten an und erteilst die Erlaubnis, die mit der App getätigten Spenden zu sammeln. Die Transaktionen werden von Slimpay abgewickelt - einer Bank, die sich auf die Behandlung von Berechtigungen spezialisiert hat. Wenn deine Registrierung abgeschlossen ist, kannst du spenden. Du benötigst dann nur noch deine Anmeldedaten, um z.B. Einstellungen anzuzeigen oder ggf. zu ändern.';

  @override
  String get answerHowDoesGivingWork => 'Von nun an kannst du mit Leichtigkeit geben. Öffne dazu die App, wähle einen Betrag aus, den du geben möchtest und wähle eine der vier folgenden Möglichkeiten aus: Du kannst dein Gerät an eine Sammelbüchse halten, einen QR-Code scannen, den Empfänger manuell aus einer Liste auswählen oder falls verfügbar direkt an deinem Standort spenden.\n Vergiss nicht, die Registrierung abzuschließen, damit deine Spenden an die richtige Wohltätigkeitsorganisation weitergeleitet werden können!';

  @override
  String get answerHowDoesManualGivingWork => 'Falls es nicht möglich ist einer Sammelbüchse etwas geben zu können, kannst du den Empfänger auch manuell auswählen. Wähle einfach einen Betrag und klicke auf \"Weiter\". Wähle als Nächstes \"Aus der Liste auswählen\" und dann \"Kirchen\", \"Wohltätigkeitsorganisationen\", \"Kampagnen\" oder \"Künstler\". Wähle nun einen Empfänger aus einer dieser Kategorien aus und klicke auf \"Spende\".';

  @override
  String get informationPersonalData => 'Givt benötigt diese persönlichen Daten, um deine Spenden verarbeiten zu können. Wir gehen vorsichtig mit diesen Informationen um. Das kannst du in unserer Datenschutzerklärung nachlesen.';

  @override
  String get informationAboutUs => 'Givt ist ein Produkt der Givt B.V.\n \n\n Du findest uns in Bongerd 159 in Lelystad, Niederlande. Für Fragen und Beschwerden erreichst du uns unter +49 391 5054 7299 oder support@givtapp.net.\n \n\n Wir sind im Handelsregister der Niederländischen Handelskammer unter der Nummer 64534421 registriert.';

  @override
  String get titleAboutGivt => 'Über Givt / Kontakt';

  @override
  String get sendAnnualReview => 'Jahresübersicht senden';

  @override
  String get infoAnnualReview => 'Hier kannst du eine Jahresübersicht deiner getätigten Spenden abrufen.\n Die Jahresübersicht kannst du für die Steuererklärung verwenden.';

  @override
  String get sendByEmail => 'Per E-Mail versenden';

  @override
  String get whyPersonalData => 'Warum überhaupt persönliche Daten?';

  @override
  String get readPrivacy => 'Datenschutzerklärung lesen';

  @override
  String get faqQuestion12 => 'Wie lange dauert es, bis meine Spende von meinem Bankkonto abgebucht wird?';

  @override
  String get faqAnswer12 => 'Deine Spende wird innerhalb von zwei Werktagen vom Bankkonto abgebucht.';

  @override
  String get faqQuestion14 => 'Wie kann ich meine Spende gleichzeitig in mehrere Sammlungen geben?';

  @override
  String get faqAnswer14 => 'Gibt es mehrere Sammlungen in einem Gottesdienst? Selbst dann kannst du leicht & bequem in einem Zug spenden!\n Durch Drücken der Schaltfläche \"Sammlung hinzufügen\" können bis zu drei Sammlungen aktiviert werden. Für jede Sammlung kann ein eigener Betrag festgelegt werden. Wähle die Sammlung aus, die angepasst werden soll und gib einen spezifischen Betrag ein oder verwende deine Voreinstellungen. Eine Sammlung kann gelöscht werden, indem man auf das Minuszeichen rechts neben dem Betrag klickt.\n \n\n Die Nummern 1, 2 oder 3 unterscheiden die verschiedenen Sammlungen. Keine Sorge, die Kirche weiß, welche Nummer welchem ​​Sammlungszweck entspricht. Mehrere Sammlungen sind sehr praktisch, da alle deine Gaben sofort mit der ersten Spende verschickt werden. In der Übersicht findest du eine detaillierte Aufschlüsselung aller deiner Spenden.\n \n\n Möchtest du eine Sammlung überspringen? Lass diese einfach offen oder entferne sie.';

  @override
  String get featureMultipleCollections => 'Neuigkeiten! Jetzt können drei Sammlungen gleichzeitig bedient werden. Wird es diesen Monat etwas eng? Lass einfach eine Sammlung aus oder entfernen sie. Möchtest du mehr erfahren? Schau in unsere FAQ.';

  @override
  String get featureIGetItButton => 'Immer spendenbereit';

  @override
  String get ballonActiveerCollecte => 'Hier kannst du bis zu drei Sammlungen hinzufügen';

  @override
  String get ballonVerwijderCollecte => 'Eine Sammlung kann durch zweimaliges schnelles Tippen entfernt werden';

  @override
  String get needEmailToGive => 'Wir brauchen eine Identifikation, um dir das Spenden mit Givt zu ermöglichen';

  @override
  String get giveFirst => 'Gib zuerst';

  @override
  String get go => 'Los geht\'s';

  @override
  String get faQvraag15 => 'Sind meine Givt-Spenden steuerlich absetzbar?';

  @override
  String get faQantwoord15 => 'Ja, deine Givt-Spenden sind steuerlich absetzbar. Bis 300€ musst du dir keine weiteren Gedanken machen. Ab dieser Summe solltest du dich aber in Kontakt mit der betreffenden Organisation begeben, welcher du gespendet hast, um eine Spendenquittung zu beantragen. Da es darüberhinaus ziemlich mühsam ist, alle getätigten Spenden für deine Steuererklärung zu sammeln, bietet dir die Givt-App die Möglichkeit, jährlich eine Übersicht all deiner Spenden herunterzuladen. Gehe dazu in deine Spenden im App-Menü, um die Übersicht herunterzuladen. Diese Übersicht kannst du dann für deine Steuererklärung verwenden.';

  @override
  String get giveDiffWalkthrough => 'Hast du Probleme? Tippe hier, um eine Organisation aus der Liste auszuwählen.';

  @override
  String get faQvraag17 => 'Kannst du deine Frage hier nicht finden?';

  @override
  String get faQantwoord17 => 'Sende uns eine Nachricht direkt aus der App (\"Über Givt / Kontakt\"), eine E-Mail an support@givtapp.net oder rufe uns unter +49 391 5054 7299 an.';

  @override
  String get noCameraAccessCelebration => 'Um dieses Spendenereignis unterstützen zu können, benötigen wir Zugriff auf deine Kamera.';

  @override
  String get yesCool => 'Ja, klar!';

  @override
  String get faQvraag18 => 'Wie geht Givt mit meinen persönlichen Daten um? (DSGVO)';

  @override
  String get faqAntwoord18 => 'Givt erfüllt die DSGVO-Anforderungen vollständig. DSGVO steht für Datenschutz-Grundverordnung.\n \n\n Du fragst dich, was das für dich konkret bedeutet? Dies bedeutet, dass wir deine Informationen mit Sorgfalt behandeln, dass du das Recht hast zu wissen, welche Informationen wir aufzeichnen, das Recht hast, diese Informationen zu ändern, das Recht hast, von uns zu verlangen, dass wir deine Informationen löschen, und dass du im besten Fall sogar weißt, warum wir deine persönlichen Daten benötigen.\n \n\n Warum wir persönliche Daten benötigen:\n Adressinformationen: Wir benötigen deine Adressinformationen, um ein Mandat zu erstellen. Das Mandat ist ohne diese Informationen nicht gültig und die Registrierung kann ohne diese Informationen nicht abgeschlossen werden. Die erforderlichen Daten sind gesetzlich festgelegt. HZahlungsdetails: Wir benötigen deine Zahlungsinformationen, um die Spenden abbuchen zu können. E-Mail-Adresse: Wir verwenden deine E-Mail-Adresse, um damit dein Givt-Konto zu erstellen. Du kannst deine E-Mail-Adresse und Passwort verwenden, um dich anzumelden.\n \n\n Wenn du mehr wissen möchtest, lies bitte unsere Datenschutzerklärung.';

  @override
  String get fingerprintCancel => 'Abbrechen';

  @override
  String get faQuestAnonymity => 'Wie wird meine Anonymität von Givt garantiert?';

  @override
  String get faQanswerAnonymity => 'Givt stellt sicher, dass die empfangende Partei niemals sehen kann, wer genau die Spende getätigt hat, und dass du als Benutzer komplett anonym mit Givt spenden kannst. Nur die Gesamtbeträge werden mit der empfangenden Partei geteilt. Daten von dir als Benutzer werden niemals an Dritte weitergegeben oder verkauft. Sie werden nur verwendet, um das Geben zu erleichtern und sich auf eine tolle Art & Weise für wohltätige Zwecke zu engagieren.\n \n\n Möchtest du mehr darüber erfahren? Dann lies unsere Datenschutzerklärung (scrolle nach unten zur letzten Frage am Ende dieser FAQ).';

  @override
  String get amountPresetsChangingPresets => 'Du kannst hier Beträge vordefinieren und zu deiner Tastatur hinzufügen.';

  @override
  String get amountPresetsChangePresetsMenu => 'Vordefinierte Beträge anpassen';

  @override
  String get featureNewguiInappnot => 'Tippe hier, um mehr über die neue Benutzeroberfläche zu erfahren!';

  @override
  String get givtCompanyInfo => 'Givt ist ein Produkt der Givt B.V.\n \n\n Du findest uns im Bongerd 159, Lelystad, Niederlande. Für Fragen und Beschwerden erreichen du uns unter +49 391 5054 7299 oder via support@givtapp.net.\n \n\n Wir sind im Handelsregister der Niederländischen Handelskammer unter der Nummer 64534421 registriert.';

  @override
  String get givtCompanyInfoGb => 'N.A. for German';

  @override
  String get celebrationHappyToSeeYou => 'Feiern wir gemeinsam Givt!';

  @override
  String get celebrationQueueText => 'Lass einfach die App geöffnet und wir werden sicherstellen, dass dein Telefon eine Push-Benachrichtigung erhält, den Countdown zu starten.';

  @override
  String get celebrationQueueCancel => 'Ohne Blitzspende spenden';

  @override
  String get celebrationEnablePushNotification => 'Push-Nachrichten aktivieren';

  @override
  String get faqButtonAccessibilityLabel => 'Häufig gestellte Fragen';

  @override
  String get progressBarStepOne => 'Schritt 1';

  @override
  String get progressBarStepTwo => 'Schritt 2';

  @override
  String get progressBarStepThree => 'Schritt 3';

  @override
  String removeCollectButtonAccessibilityLabel(Object value0) {
    return 'Entferne $value0';
  }

  @override
  String get removeBtnAccessabilityLabel => 'Löschen';

  @override
  String get progressBarStepFour => 'Schritt 4';

  @override
  String get changeBankAccountNumberAndSortCode => 'Bankdaten ändern';

  @override
  String get updateBacsAccountDetailsError => 'Oha, die Bankleitzahl oder die Kontonummer ist ungültig. Du kannst die Bankleitzahl und/oder Kontonummer unter dem Menüpunkt \'Persönliche Daten\' ändern.';

  @override
  String get ddiFailedTitle => 'Lastschrift-Anfrage fehlgeschlagen';

  @override
  String get ddiFailedMessage => 'Im Moment kann keine Lastschrift-Anfrage durchgeführt werden. Bitte versuche es in ein paar Minuten noch einmal.';

  @override
  String get faQantwoord5Gb => 'Handling transactions\n The transactions are handled by Access PaySuite; a payment institution specialised in processing BACS Direct Debit Instructions. Access PaySuite is under the supervision of the Financial Conduct Authority.\n \n\n Revertible afterwards\n The transactions take place afterwards via a direct debit under Givt Ltd. We want to emphasise that no transactions take place in the moment of giving. Since these transactions are revocable, it is completely safe and immune to fraud.';

  @override
  String get faQvraag15Gb => 'Can I Gift Aid my donations?';

  @override
  String get faQantwoord15Gb => 'Yes, you can. In the Givt app you can enable Gift Aid. You can also always see how much Gift Aid has been claimed on your donations.\n \n\n Donating through Gift Aid means charities can claim an extra 25p for every £1 you give. It will not cost you any extra.';

  @override
  String get answerHowDoesRegistrationWorkGb => 'To start giving, all you need is an e-mail address. Once you have entered this, you are ready to give.\n \n\n Please note: you need to fully register to ensure that all your previous and future donations can be processed. Go to the menu in the app and choose ‘Complete registration’. Here, you set up a Givt account by filling in your personal information and by us giving permission to debit the donations made in the app. Those transactions are processed by Access PaySuite, who are specialised in direct debits. \n \n\n When your registration is complete, you are ready to give with the Givt app. You only need your login details to see or change your settings.';

  @override
  String get faQantwoord7Gb => ' Personal safety\n It is very important to us that everything is safe and risk free. Each user has a personal account with its own password. You need to log in to view or change your settings.\n \n\n Handling transactions\n The transactions are handled by Access PaySuite; a payment institution specialised in processing BACS Direct Debit Instructions. Access PaySuite is under the supervision of the Financial Conduct Authority.\n \n\n Immune to fraud\n When installing Givt, the user gives the app authorisation to debit their account. We want to emphasise that no transactions take place in the moment of giving. The transactions take place afterwards via a direct debit under Givt Ltd. Since these transactions are revocable, it is completely safe and immune to fraud.\n \n\n Overview\n Individual users can see an overview of their donations in the app. Organisations can log in to the Givt dashboard. This dashboard gives an overview of all financial transactions, from the moment of giving up to the full processing of the payment. In this way any collection can be followed from start to finish. Organisations can see how many people used Givt, but not who they are.';

  @override
  String get faQantwoord18Gb => 'Givt fully complies with the GDPR requirements. GDPR stands for General Data Protection Regulation.\n \n\n Wondering what this means for you? It means that we handle your information with care, that you have the right to know which information we keep on record, have the right to change this information, have the right to demand from us that we do not store your information, and that you may know why we need your personal information.\n \n\n If you would like to know more, please read our privacy statement.';

  @override
  String get giftAidSetting => 'N.A. in Germany';

  @override
  String get giftAidInfo => 'N.A. in Germany';

  @override
  String get giftAidHeaderDisclaimer => 'N.A. in Germany';

  @override
  String get giftAidBodyDisclaimer => 'N.A. in Germany';

  @override
  String get giftAidInfoTitle => 'N.A. in Germany';

  @override
  String get giftAidInfoBody => 'N.A. in Germany';

  @override
  String get faqAnswer12Gb => 'Your donation will be withdrawn from your bank account within five working days. The first time you make a donation with Givt, the donation will be withdrawn after two weeks, as it takes extra time to set up your registration.';

  @override
  String get faqVraagDdi => 'Does the Direct Debit mean I signed up to monthly deductions?';

  @override
  String get faqAntwoordDdi => 'NO! You sign a direct debit so we can deduct the donations you have made using the Givt app. The deductions we make are incidental, user-driven deductions.\n \n\n We will not debit your account unless you make a donation using the Givt app.';

  @override
  String get giftAidUnsavedChanges => 'N.A. in Germany';

  @override
  String get giftAidChangeLater => 'N.A. in Germany';

  @override
  String get dismiss => 'Schließen';

  @override
  String get importantMessage => 'Wichtige Nachricht';

  @override
  String get celebrationQueueCancelAlertBody => 'Sicher, dass du nicht mit uns feiern willst?';

  @override
  String get celebrationQueueCancelAlertTitle => 'Zu schade!';

  @override
  String get historyInfoLegendaAccessibilityLabel => 'Info Erklärung';

  @override
  String get historyDownloadAnnualOverviewAccessibilityLabel => 'Jährliche Spendenübersicht herunterladen (E-Mail)';

  @override
  String get bluetoothErrorMessageEvent => 'Mit Bluetooth kannst du dank Location-Beacons deinen Standort auch ohne / mit schlechter GPS-Verbindung finden.\n Aktiviere jetzt dein Bluetooth!';

  @override
  String get processCashedGivtNamespaceInvalid => 'Wir sehen, dass du einer Organisation, die Givt leider nicht mehr verwendet, ein nicht verarbeitete Spende gemacht hast. Diese Spende wird annulliert.';

  @override
  String get suggestionNamespaceInvalid => 'Dein zuletzt ausgewähltes Spendenziel unterstützt Givt nicht mehr.';

  @override
  String get charity => 'Charity';

  @override
  String get artist => 'Künstler';

  @override
  String get church => 'Kirche';

  @override
  String get campaign => 'Kampagne';

  @override
  String get giveYetDifferently => 'Wähle aus der Liste';

  @override
  String giveToNearestBeacon(Object value0) {
    return 'Spende an: $value0';
  }

  @override
  String get jersey => 'Jersey';

  @override
  String get guernsey => 'Guernsey';

  @override
  String get countryStringBe => 'Belgien';

  @override
  String get countryStringNl => 'Niederlande';

  @override
  String get countryStringDe => 'Deutschland';

  @override
  String get countryStringGb => 'Vereinigtes Königreich';

  @override
  String get countryStringFr => 'Frankreich';

  @override
  String get countryStringIt => 'Italien';

  @override
  String get countryStringLu => 'Luxemburg';

  @override
  String get countryStringGr => 'Griechenland';

  @override
  String get countryStringPt => 'Portugal';

  @override
  String get countryStringEs => 'Spanien';

  @override
  String get countryStringFi => 'Finnland';

  @override
  String get countryStringAt => 'Österreich';

  @override
  String get countryStringCy => 'Zypern';

  @override
  String get countryStringEe => 'Estland';

  @override
  String get countryStringLv => 'Lettland';

  @override
  String get countryStringLt => 'Litauen';

  @override
  String get countryStringMt => 'Malta';

  @override
  String get countryStringSi => 'Slowenien';

  @override
  String get countryStringSk => 'Slowakei';

  @override
  String get countryStringIe => 'Irland';

  @override
  String get countryStringAd => 'Andorra';

  @override
  String get errorChangePostalCode => 'Du hast eine unbekannte Postleitzahl eingegeben. Bitte ändere diese unter \"Persönliche Informationen\" im Menü.';

  @override
  String get informationAboutUsGb => 'Givt is a product of Givt LTD.\n \n\n We are located at the Suite 2A, Blackthorn House in St Pauls Square, Birmingham, England. For questions or complaints you can reach us via +44 20 3790 8068 or support@givt.app.\n \n\n We are registered under the Company Registration Number 11396586.';

  @override
  String get bluetoothErrorMessageAction => 'Ich mach es';

  @override
  String get bluetoothErrorMessageCancel => 'Lieber nicht';

  @override
  String get authoriseBluetooth => 'Autorisiere Givt zur Verwendung von Bluetooth';

  @override
  String get authoriseBluetoothErrorMessage => 'Gib Givt die Erlaubnis, auf dein Bluetooth zuzugreifen, damit du einer Sammlung etwas geben kannst.';

  @override
  String get authoriseBluetoothExtraText => 'Gehe zu Einstellungen > Datenschutz > Bluetooth und wähle \'Givt\'.';

  @override
  String get unregisterError => 'Leider können wir die Registrierung deines Kontos nicht aufheben. Kannst du es später noch einmal versuchen?';

  @override
  String get unregisterMandateError => 'Leider können wir die Registrierung deines Kontos nicht aufheben, da wir dein Mandat oder die Lastschriftanweisung nicht kündigen können. Bitte kontaktiere uns.';

  @override
  String get unregisterErrorTitle => 'Beenden fehlgeschlagen';

  @override
  String get setupRecurringGiftTitle => 'Richte eine wiederkehrende Spende ein';

  @override
  String get setupRecurringGiftText3 => 'von';

  @override
  String get setupRecurringGiftText4 => 'bis';

  @override
  String get setupRecurringGiftText5 => 'oder';

  @override
  String get add => 'Hinzufügen';

  @override
  String get subMenuItemFirstDestinationThenAmount => 'Einem guten Zweck geben';

  @override
  String get faqQuestionFirstTargetThenAmount1 => 'Was ist \"Für einen guten Zweck geben\"?';

  @override
  String get faqAnswerFirstTargetThenAmount1 => '\"Für einen guten Zweck geben\" ist eine neue Funktion in deiner Givt-App. Es funktioniert genau so, wie du es bei uns gewohnt bist, aber jetzt wähle zuerst den guten Spendenzweck und dann die Höhe. Wie praktisch!';

  @override
  String get faqQuestionFirstTargetThenAmount2 => 'Warum kann ich nur einen guten Grund aus der Liste auswählen?';

  @override
  String get faqAnswerFirstTargetThenAmount2 => '\"Für einen guten Zweck geben\" ist brandneu und befindet sich noch im Aufbau. Mit der Zeit werden ständig neue Funktionen hinzugefügt.';

  @override
  String get setupRecurringGiftText2 => 'spenden an';

  @override
  String get setupRecurringGiftText1 => 'Ich möchte jede';

  @override
  String get setupRecurringGiftWeek => 'Woche';

  @override
  String get setupRecurringGiftMonth => 'Monat';

  @override
  String get setupRecurringGiftQuarter => 'Quartal';

  @override
  String get setupRecurringGiftYear => 'Jahr';

  @override
  String get setupRecurringGiftWeekPlural => 'Wochen';

  @override
  String get setupRecurringGiftMonthPlural => 'Monate';

  @override
  String get setupRecurringGiftQuarterPlural => 'Quartale';

  @override
  String get setupRecurringGiftYearPlural => 'Jahre';

  @override
  String get menuItemRecurringDonation => 'Wiederkehrende Spende';

  @override
  String get setupRecurringGiftHalfYear => 'Halbes Jahr';

  @override
  String get setupRecurringGiftText6 => 'Mal';

  @override
  String get loginAndTryAgain => 'Bitte melde dich an und versuche es erneut.';

  @override
  String givtIsBeingProcessedRecurring(Object value0, Object value1, Object value2, Object value3, Object value4) {
    return 'Vielen Dank für deine(n) Givt (s) an $value0!\n Du kannst die Übersicht der wiederkehrenden Spenden unter \"Übersicht\" einsehen.\n Die erste wiederkehrende Spende von $value1 $value2 wird am $value3 initiiert.\n Danach wird es jeweils zum $value4 eingezogen.';
  }

  @override
  String get overviewRecurringDonations => 'Wiederkehrende Spenden';

  @override
  String get titleRecurringGifts => 'Wiederkehrende Spenden';

  @override
  String get recurringGiftsSetupCreate => 'Plane deine';

  @override
  String get recurringGiftsSetupRecurringGift => 'wiederkehrende Spende';

  @override
  String get recurringDonationYouGive => 'Du gibst';

  @override
  String recurringDonationStops(Object value0) {
    return 'Diese enden am $value0';
  }

  @override
  String get selectRecipient => 'Empfänger auswählen';

  @override
  String get setupRecurringDonationFailed => 'Die wiederkehrende Spende wurde nicht erfolgreich eingerichtet. Bitte versuche es später noch einmal.';

  @override
  String get emptyRecurringDonationList => 'Alle deine wiederkehrenden Spenden werden hier angezeigt.';

  @override
  String cancelRecurringDonationAlertTitle(Object value0) {
    return 'Bist du sicher, dass du an $value0 nicht mehr spenden willst?';
  }

  @override
  String get cancelRecurringDonationAlertMessage => 'Die bereits getätigten Spenden werden nicht storniert.';

  @override
  String get cancelRecurringDonation => 'Anhalten';

  @override
  String get setupRecurringGiftText7 => 'Jede(s)';

  @override
  String get cancelRecurringDonationFailed => 'Die wiederkehrende Spende konnte nicht storniert werden. Bitte versuche es später noch einmal.';

  @override
  String get pushnotificationRequestScreenTitle => 'Push-Nachrichten';

  @override
  String get pushnotificationRequestScreenDescription => 'Wir möchten dich auf dem Laufenden halten, wann die nächste Spende von deinem Konto abgebucht wird. Im Moment haben wir keine Erlaubnis, dir Nachrichten zu senden. Könntest du diese Einstellung bitte ändern?';

  @override
  String get pushnotificationRequestScreenButtonYes => 'Ja, ich werde meine Einstellungen ändern';

  @override
  String get reportMissingOrganisationListItem => 'Fehlende Organisation melden';

  @override
  String get reportMissingOrganisationPrefilledText => 'Hallo! Ich würde wirklich gerne geben an:';

  @override
  String get featureRecurringDonations1Title => 'Plane deine wiederkehrenden Spenden an Wohltätigkeitsorganisationen';

  @override
  String get featureRecurringDonations2Title => 'Du hast die volle Kontrolle';

  @override
  String get featureRecurringDonations3Title => 'Übersicht';

  @override
  String get featureRecurringDonations1Description => 'Du kannst jetzt deine wiederkehrenden Spenden planen, wobei das Enddatum bereits feststeht.';

  @override
  String get featureRecurringDonations2Description => 'Du kannst alle geplanten wiederkehrenden Spenden sehen und diese jederzeit stoppen.';

  @override
  String get featureRecurringDonations3Description => 'Alle deine einmaligen und wiederkehrenden Spenden in einer Übersicht. Nützlich für dich selbst zur Info und für steuerliche Zwecke.';

  @override
  String get featureRecurringDonations3Button => 'Zeig es mir!';

  @override
  String get featureRecurringDonationsNotification => 'Hallo! Möchtest du mit der App wiederkehrende Spende einrichten? Wirf einen kurzen Blick auf das, was wir gebaut haben.';

  @override
  String get setupRecurringDonationFailedDuplicate => 'Die wiederkehrende Spende konnte nicht erfolgreich eingerichtet werden. Du hast bereits eine Spende an diese Organisation im gleichen angegebenen Zeitintervall geleistet.';

  @override
  String get setupRecurringDonationFailedDuplicateTitle => 'Doppelte Spende';

  @override
  String get goToListWithRecurringDonationDonations => 'Übersicht';

  @override
  String get recurringDonationsEmptyDetailOverview => 'Hier findest du Informationen zu deinen Spenden, jedoch aber erst nach der ersten Spende';

  @override
  String get recurringDonationFutureDetailSameYear => 'Kommende Spende';

  @override
  String get recurringDonationFutureDetailDifferentYear => 'Kommende Spende in';

  @override
  String get pushnotificationRequestScreenPrimaryDescription => 'Wir möchten dich auf dem Laufenden halten, wann die nächste Spende von deinem Konto abgebucht wird. Im Moment haben wir keine Erlaubnis, dir Nachrichten zu senden. Könntest du das bitte zulassen?';

  @override
  String get pushnotificationRequestScreenPrimaryButtonYes => 'Ok, gut!';

  @override
  String get discoverSearchButton => 'Suchen';

  @override
  String get discoverDiscoverButton => 'Alles zeigen';

  @override
  String get discoverSegmentNow => 'Spende';

  @override
  String get discoverSegmentWho => 'Entdecken';

  @override
  String get discoverHomeDiscoverTitle => 'Kategorie wählen';

  @override
  String get discoverOrAmountActionSheetOnce => 'Einmalige Spende';

  @override
  String get discoverOrAmountActionSheetRecurring => 'Wiederkehrende Spende';

  @override
  String reccurringGivtIsBeingProcessed(Object value0) {
    return 'Vielen Dank für deine wiederkehrende Spende an $value0!\n Um alle Informationen zu sehen, gehe ins Menü \'Wiederkehrende Spenden\'.';
  }

  @override
  String get setupRecurringGiftTextPlaceholderDate => 'tt / mm / jj';

  @override
  String get setupRecurringGiftTextPlaceholderTimes => 'x';

  @override
  String get amountLimitExceededRecurringDonation => 'Dieser Betrag ist höher als der von dir gewählte Höchstbetrag. Möchtest du fortfahren oder den Betrag ändern?';

  @override
  String get appStoreRestart => 'AppStoreRestart';

  @override
  String sepaVerifyBodyDetails(Object value0, Object value1, Object value2, Object value3) {
    return 'Name: $value0\n Adresse: $value1\n E-Mail-Adresse: $value2\n IBAN: $value3\n Wir verwenden das eMandate nur, wenn du mit der Givt-App spendest';
  }

  @override
  String get sepaVerifyBody => 'Wenn einer der oben genannten Punkte nicht korrekt ist, brich die Registrierung ab und ändere deine \"persönlichen Daten\".';

  @override
  String get signMandate => 'Mandat unterschreiben';

  @override
  String get signMandateDisclaimer => 'Wenn du fortfährst, unterschreibe das eMandate mit den oben genannten Details.\n Das Mandat wird dir dann per Mail zugesandt.';

  @override
  String get budgetSummaryBalance => 'In diesem Monat gegeben';

  @override
  String get budgetSummarySetGoal => 'Setze ein Ziel, um dich zu motivieren.';

  @override
  String get budgetSummaryGiveNow => 'Gib jetzt!';

  @override
  String get budgetSummaryGivt => 'Gegeben mit Givt';

  @override
  String get budgetSummaryNotGivt => 'Außerhalb von Givt gegeben';

  @override
  String get budgetSummaryShowAll => 'Zeige alles';

  @override
  String get budgetSummaryMonth => 'Pro Monat';

  @override
  String get budgetSummaryYear => 'Jährlich';

  @override
  String get budgetExternalGiftsTitle => 'Spenden außerhalb von Givt';

  @override
  String get budgetExternalGiftsInfo => 'Verschaffe dir einen vollständigen Überblick über alle Spenden. Füge auch alle Spenden hinzu, welche du außerhalb von Givt geleistet hast. Dann findest du alles bequem in einer Zusammenfassung.';

  @override
  String get budgetExternalGiftsSubTitle => 'Spenden außerhalb von Givt';

  @override
  String get budgetExternalGiftsOrg => 'Organisation benennen';

  @override
  String get budgetExternalGiftsTime => 'Zeitraum';

  @override
  String get budgetExternalGiftsAmount => 'Summe';

  @override
  String get budgetExternalGiftsAdd => 'Hinzufügen';

  @override
  String get budgetExternalGiftsSave => 'speichern';

  @override
  String get budgetGivingGoalTitle => 'Ein Spendenziel setzen';

  @override
  String get budgetGivingGoalInfo => 'Gib bewusst. Überlege jeden Monat, ob dein Spendenverhalten deinen persönlichen Ambitionen entspricht.';

  @override
  String get budgetGivingGoalMine => 'Mein Ziel zu geben';

  @override
  String get budgetGivingGoalTime => 'Zeitraum';

  @override
  String get budgetSummaryGivingGoalMonth => 'Monatliches Spendenziel';

  @override
  String get budgetSummaryGivingGoalEdit => 'Bearbeite das Spendenziel';

  @override
  String get budgetSummaryGivingGoalRest => 'Verbleibendes Spendenziel';

  @override
  String get budgetSummaryGivingGoal => 'Spendenziel:';

  @override
  String get budgetMenuView => 'Meine persönliche Zusammenfassung';

  @override
  String get budgetSummarySetGoalBold => 'Gib bewusst';

  @override
  String get budgetExternalGiftsInfoBold => 'Gewinne einen Einblick über das, was du gibst';

  @override
  String get budgetGivingGoalInfoBold => 'Setze ein Spendenziel';

  @override
  String get budgetGivingGoalRemove => 'Entferne das Spendenziel';

  @override
  String get budgetSummaryNoGifts => 'Du hast diesen Monat (noch) keine Spenden getätigt';

  @override
  String get budgetTestimonialSummary => '\"Seit ich die Zusammenfassung verwende, habe ich mehr Einblick über das, was ich gebe. Ich gebe deswegen viel bewusster.\"';

  @override
  String get budgetTestimonialGivingGoal => '\"Mein Spendenziel motiviert mich, regelmäßig über mein Spendenverhalten nachzudenken.\"';

  @override
  String get budgetTestimonialExternalGifts => '„Ich finde es gut, dass ich meine Beiträge außerhalb von Givt in der App eintragen kann. Jetzt kann ich mir leichter überlegen, was ich noch geben möchte. “';

  @override
  String get budgetTestimonialYearlyOverview => '„Ich finde die jährliche Übersicht von Givt großartig! Da ich auch außerhalb von Givt spende, freue ich mich, dass ich sie jetzt auch hinzufügen kann. Alle meine Spenden in einer Übersicht, super einfach für meine Steuererklärung. “';

  @override
  String get budgetPushMonthly => 'Sieh, was du diesen Monat gegeben hast.';

  @override
  String get budgetPushYearly => 'Sieh deine jährliche Übersicht an und schau, was du bisher gegeben hast.';

  @override
  String get budgetTooltipGivingGoal => 'Gib bewusst. Überlege jeden Monat, ob dein Spendenverhalten deinen persönlichen Ambitionen entspricht.';

  @override
  String get budgetTooltipExternalGifts => 'Deine Übersicht ist nur dann vollständig, wenn all deine Spenden darin enthalten sind. Füge hinzu, was du nicht per Givt geben hast. Dann findest du alles in einer übersichtlichen Zusammenfassung.';

  @override
  String get budgetTooltipYearly => 'Eine Übersicht für deine Steuererklärung? Schau hier eine Übersicht aller deiner Spenden an.';

  @override
  String get budgetPushMonthlyBold => 'Deine monatliche Zusammenfassung für Givt ist fertig.';

  @override
  String get budgetPushYearlyBold => '2021 ist fast vorbei ... Hast du deinen anvisierten Betrag erreicht?';

  @override
  String get budgetExternalGiftsListAddEditButton => 'Externe Spenden verwalten';

  @override
  String get budgetExternalGiftsFrequencyOnce => 'Einmalig';

  @override
  String get budgetExternalGiftsFrequencyMonthly => 'Jeden Monat';

  @override
  String get budgetExternalGiftsFrequencyQuarterly => 'Alle 3 Monate';

  @override
  String get budgetExternalGiftsFrequencyHalfYearly => 'Alle 6 Monate';

  @override
  String get budgetExternalGiftsFrequencyYearly => 'Jedes Jahr';

  @override
  String get budgetExternalGiftsEdit => 'Bearbeiten';

  @override
  String get budgetTestimonialSummaryName => 'Willem:';

  @override
  String get budgetTestimonialGivingGoalName => 'Danielle:';

  @override
  String get budgetTestimonialExternalGiftsName => 'John:';

  @override
  String get budgetTestimonialYearlyOverviewName => 'Jonathan:';

  @override
  String get budgetTestimonialSummaryAction => 'Deine Zusammenfassung anzeigen';

  @override
  String get budgetTestimonialGivingGoalAction => 'Richte dein Spendenziel ein';

  @override
  String get budgetTestimonialExternalGiftsAction => 'Externe Spenden hinzufügen';

  @override
  String get budgetSummaryGivingGoalReached => 'Spendenziel erreicht';

  @override
  String get budgetExternalDonationToHighAlertTitle => 'Oh, Du bist ein Großspender?';

  @override
  String get budgetExternalDonationToHighAlertMessage => 'Hallo Großspender! Dein Beitrag ist höher, als wir erwartet haben. Senke bitte den Betrag oder lass\' uns wissen, das wir das Maximum in Höhe von 99 999 verändern sollen.';

  @override
  String get budgetExternalDonationToLongAlertTitle => 'Zu viel!';

  @override
  String get budgetExternalDonationToLongAlertMessage => 'Langsam, langsam! Dieses Feld verträgt maximal 30 Zeichen!';

  @override
  String get budgetSummaryNoGiftsExternal => 'Spenden außerhalb von Givt, diesen Monat? Hier hinzufügen';

  @override
  String get budgetYearlyOverviewGivenThroughGivt => 'Gesamtbetrag via Givt';

  @override
  String get budgetYearlyOverviewGivenThroughNotGivt => 'Gesamtbetrag außerhalb Givt';

  @override
  String get budgetYearlyOverviewGivenTotal => 'Gesamtbetrag';

  @override
  String get budgetYearlyOverviewGivenTotalTax => 'steuerlich absetzbarer Gesamtbetrag';

  @override
  String get budgetYearlyOverviewDetailThroughGivt => 'via Givt';

  @override
  String get budgetYearlyOverviewDetailAmount => 'Betrag';

  @override
  String get budgetYearlyOverviewDetailDeductable => 'Abzugsfähig';

  @override
  String get budgetYearlyOverviewDetailTotal => 'Gesamtbetrag';

  @override
  String get budgetYearlyOverviewDetailTotalDeductable => 'Gesamt abzugsfähig';

  @override
  String get budgetYearlyOverviewDetailNotThroughGivt => 'außerhalb Givt';

  @override
  String get budgetYearlyOverviewDetailTotalThroughGivt => '(via Givt)';

  @override
  String get budgetYearlyOverviewDetailTotalNotThroughGivt => '(außerhalb Givt)';

  @override
  String get budgetYearlyOverviewDetailTipBold => 'TIPP: Füge deine externen Spenden hinzu';

  @override
  String get budgetYearlyOverviewDetailTipNormal => 'um einen Gesamtüberblick über das zu bekommen, was du gibst. Sowohl deine Spenden via Givt-App, als auch über alle anderen getätigten Spenden.';

  @override
  String get budgetYearlyOverviewDetailReceiveViaMail => 'Empfangen per E-Mail';

  @override
  String get budgetYearlyOverviewDownloadButton => 'Jahresübersicht herunterladen';

  @override
  String get budgetExternalDonationsTaxDeductableSwitch => 'Abzugsfähig';

  @override
  String get budgetYearlyOverviewGivingGoalPerYear => 'Jährliches Spendenziel';

  @override
  String get budgetYearlyOverviewGivenIn => 'Gegeben in';

  @override
  String get budgetYearlyOverviewRelativeTo => 'Relativ zur Gesamtmenge in';

  @override
  String get budgetYearlyOverviewVersus => 'Gegenüber';

  @override
  String get budgetYearlyOverviewPerOrganisation => 'pro Organisation';

  @override
  String get budgetSummaryNoGiftsYearlyOverview => 'Du hast diesen Jahr (noch) keine Spenden getätigt';

  @override
  String budgetPushYearlyNearlyEndBold(Object value0) {
    return '$value0 ist fast vorbei... Hast du dein Guthaben schon ausgeglichen?';
  }

  @override
  String get budgetPushYearlyNearlyEnd => 'Sieh dir deine Jahresübersicht an und schau, was du bisher gegeben hast.';

  @override
  String get budgetPushYearlyNewYearBold => 'Hast du dein Guthaben schon ausgeglichen?';

  @override
  String get budgetPushYearlyNewYear => 'Sieh dir deine Jahresübersicht an und schau, was du im letzten Jahr gegeben hast.';

  @override
  String get budgetPushYearlyFinalBold => 'Deine Jahresübersicht ist jetzt fertig!';

  @override
  String get budgetPushYearlyFinal => 'Sieh dir deine Jahresübersicht an und schau, was du im letzten Jahr gegeben hast.';

  @override
  String get budgetTestimonialYearlyOverviewAction => 'Zur Übersicht';

  @override
  String get duplicateAccountOrganisationMessage => 'Bist du sicher, dass du deine eigenen Bankdaten verwendest? Könntest du bitte im Menü unter \"Persönliche Informationen\" nachsehen? Bei Bedarf kannst du sie dort auch gleich ändern.';

  @override
  String get usRegistrationCreditCardDetailsNumberPlaceholder => 'Credit card number';

  @override
  String get usRegistrationCreditCardDetailsExpiryDatePlaceholder => 'MM/YY';

  @override
  String get usRegistrationCreditCardDetailsSecurityCodePlaceholder => 'CVV';

  @override
  String get usRegistrationPersonalDetailsPhoneNumberPlaceholder => 'Mobile number (+1)';

  @override
  String get usRegistrationPersonalDetailsPasswordPlaceholder => 'Password';

  @override
  String get usRegistrationPersonalDetailsFirstnamePlaceholder => 'First name';

  @override
  String get usRegistrationPersonalDetailsLastnamePlaceholder => 'Nachname';

  @override
  String get usRegistrationTaxTitle => 'A few more details for your annual statement.';

  @override
  String get usRegistrationTaxSubtitle => 'Your name and Zip code will only be used to create your statement. By default, you will remain anonymous to the recipient.';

  @override
  String get policyTextUs => 'Latest Amendment: 19-01-2022\n Version 1.0\n \n\n Givt Inc. (Atlanta Financial Centre)\n 3343 Peachtree Rd NE Ste \n 145-1032 Atlanta\n \n\n Privacy Policy  \n \n\n Introduction\n This Privacy Policy outlines Givt Inc.\'s (\" we \", \" our \" or \" the Company \") practices with respect to information collected from our Application (“App”) or from users that otherwise share personal information with us (collectively: \"Users\"). \n \n\n Grounds for data collection \n \n\n Processing of your personal information (meaning, any information which may potentially allow your identification with reasonable means; hereinafter \"Personal Information\") is necessary for the performance of our contractual obligations towards you and providing you with our services, to protect our legitimate interests and for compliance with legal and financial regulatory obligations to which we are subject.\n \n\n When you use our App or register yourself or an organisation you represent with us, you consent to the collection, storage, use, disclosure and other uses of your Personal Information as described in this Privacy Policy.\n \n\n We encourage our Users to carefully read the Privacy Policy and use it to make informed decisions. \n \n\n What information do we collect?\n \n\n We collect two types of data and information from Users. \n \n\n The first type of information is un-identified and non-identifiable information pertaining to a User(s), which may be made available or gathered via your use of the App (“ Non-personal Information ”). We are not aware of the identity of a User from which the Non-personal Information was collected. Non-personal Information which is being collected may include your aggregated usage information and technical information transmitted by your device, including certain software and hardware information (e.g. language preference, access time, etc.) in order to enhance the functionality of our App.\n \n\n The second type of information is Personal Information, which is personally identifiable information, namely information that identifies an individual or may with reasonable effort identify an individual. Such information includes:\n Device Information: We collect Personal Information from your device. Such information includes geolocation data, IP address, unique identifiers (e.g. MAC address and UUID) and other information which relates to your activity through the App.\n Service User Information: We collect additional information for individuals who would like to use our Services. This is gathered through the App and includes all the information needed to register for our service: \n Name and address, \n Date of birth, \n email address, \n secured password details, and \n bank details for the purposes of making payments.\n Contact information: If you choose to contact us you will be asked to provide us with certain details such as: full name; e-mail or physical address, and other relevant information. This may be for yourself or for people in the organisation you represent.';

  @override
  String get termsTextUs => 'GIVT Inc.\n \n\n Terms of use – Givt app \n Last updated: 20-01-2022\n Version: 1.0\n \n\n 1.  General \n These terms of use describe the conditions under which the mobile application Givt (\"Givt\") can be utilised. Givt allows the User (anonymously) to give donations through their smartphone, for example churches, fundraising campaigns or charities that are members of Givt Inc.\n \n\n These terms of use apply to the use of Givt. Through the use of Givt (which means the download and the installation thereof), you (\"the User\") accept these terms of use and our privacy policy (https://givt.app/privacy-policy). These terms of use and our privacy policy are also available on our website to download and print. We may revise these terms of use from time to time.';

  @override
  String get termsTextUsVersion => '1';

  @override
  String get informationAboutUsUs => 'Givt is a product of Givt Inc\n \n\n We are located in the Atlanta Financial Center, 3343 Peachtree Rd NE Ste 145-1032, Atlanta, GA 30326. For questions or complaints you can reach us via +1 918-615-9611 or support@givt.app\n \n\n We are incorporated in Delaware.';

  @override
  String get faQantwoord0Us => 'In the app-menu under \"About Givt / Contact\" there\'s a text field where you can type a message and send it to us. Of course you can also contact us by calling +1 918-615-9611 or by sending an e-mail to support@givt.app.';

  @override
  String get usRegistrationPersonalDetailsPostalCodePlaceholder => 'Zip code';

  @override
  String amountPresetsErrMinAmount(Object value0) {
    return 'Der Betrag muss mindestens $value0 Euro betragen.';
  }

  @override
  String get unregisterInfoUs => 'We’re sad to see you go!';

  @override
  String get invalidQRcodeTitle => 'QR-Code nicht gültig';

  @override
  String invalidQRcodeMessage(Object value0) {
    return 'Dieser QR-Code ist nicht mehr aktiv. Möchtest du stattdessen an $value0 spenden?';
  }

  @override
  String get errorOccurred => 'Ein Fehler ist aufgetreten';

  @override
  String get registrationErrorTitle => 'Die Registrierung kann nicht abgeschlossen werden';

  @override
  String get noDonationsFoundOnRegistrationMessage => 'Wir konnten keine Spenden abrufen. Bitte kontaktieren Sie den Support unter support@givt.app, um Ihre Registrierung abzuschließen';

  @override
  String get cantCancelAlreadyProcessed => 'Leider können Sie diese Spende nicht stornieren, da sie bereits bearbeitet wurde.';

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
  String get countryStringUs => 'United States of America';

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
  String get surname => 'Nachname';

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
    return 'Mit $value0 entsperren?';
  }

  @override
  String get permitBiometricExplanation => 'Beschleunigen Sie den Anmeldevorgang und halten Sie Ihr Konto sicher';

  @override
  String get permitBiometricSkip => 'Für jetzt überspringen';

  @override
  String permitBiometricActivateWithType(Object value0) {
    return '$value0 aktivieren';
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
