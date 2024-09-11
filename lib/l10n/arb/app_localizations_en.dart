import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get ibanPlaceHolder => 'IBAN account number';

  @override
  String get amountLimitExceeded => 'This amount is higher than your chosen maximum amount. Please adjust the maximum donation amount or choose a lower amount.';

  @override
  String get belgium => 'Belgium';

  @override
  String get insertAmount => 'Do you know how much you want to give? \n Choose an amount.';

  @override
  String get netherlands => 'The Netherlands';

  @override
  String get notificationTitle => 'Givt';

  @override
  String get selectReceiverTitle => 'Select recipient';

  @override
  String get slimPayInformation => 'We want your Givt experience to be as smooth as possible.';

  @override
  String get savingSettings => 'Sit back and relax,\n we are saving your settings.';

  @override
  String get continueKey => 'Continue';

  @override
  String get slimPayInfoDetail => 'Givt works together with SlimPay for executing the transactions. SlimPay is specialised in handling mandates and automatic money transfers on digital platforms. SlimPay executes these orders for Givt at the lowest rates on this market and at a high speed.\n \n\n SlimPay is an ideal partner for Givt because they make giving without cash very easy and safe. As a payment company, they are supervised by the Nederlandsche Bank and other European national banks.\n \n\n The money will be collected in a SlimPay account. \n Givt will ensure that the money is distributed correctly.';

  @override
  String get slimPayInfoDetailTitle => 'What is SlimPay?';

  @override
  String get continueRegistration => 'Your user account was already\n created, but it was impossible\n to finalise the registration.\n \n\n We would love for you to use\n Givt, so we ask you to login\n to complete the registration.';

  @override
  String get contactFailedButton => 'Didn\'t work?';

  @override
  String get unregisterButton => 'Terminate my account';

  @override
  String get unregisterUnderstood => 'I understand';

  @override
  String givtIsBeingProcessed(Object value0) {
    return 'Thank you for your Givt to $value0!\n You can check the status in the overview.';
  }

  @override
  String get offlineGegevenGivtMessage => 'Thank you for your Givt!\n \n\n When there\'s a good connection with the Givt-server, your Givt will be processed.\n You can check the status in the overview.';

  @override
  String offlineGegevenGivtMessageWithOrg(Object value0) {
    return 'Thank you for your Givt to $value0!\n \n\n When there\'s a good connection with the Givt-server, your Givt will be processed.\n You can check the status in the overview.';
  }

  @override
  String get pincode => 'Passcode';

  @override
  String get pincodeTitleChangingPin => 'This is where you change the use of your passcode to login into the Givt app.';

  @override
  String get pincodeChangePinMenu => 'Change passcode';

  @override
  String get pincodeSetPinTitle => 'Set passcode';

  @override
  String get pincodeSetPinMessage => 'Set your passcode here';

  @override
  String get pincodeEnterPinAgain => 'Re-enter your passcode';

  @override
  String get pincodeDoNotMatch => 'Codes do not match. Could you try again?';

  @override
  String get pincodeSuccessfullTitle => 'Got it!';

  @override
  String get pincodeSuccessfullMessage => 'Your passcode has been successfully saved.';

  @override
  String get pincodeForgotten => 'Login with e-mail and password';

  @override
  String get pincodeForgottenTitle => 'Forgot passcode';

  @override
  String get pincodeForgottenMessage => 'Login using your e-mail address to access your account.';

  @override
  String get pincodeWrongPinTitle => 'Wrong passcode';

  @override
  String get pincodeWrongPinFirstTry => 'First attempt failed.\n Please try again.';

  @override
  String get pincodeWrongPinSecondTry => 'Second attempt failed.\n Please try again.';

  @override
  String get pincodeWrongPinThirdTry => 'Third attempt failed.\n Login using your e-mail address.';

  @override
  String get wrongPasswordLockedOut => 'Third attempt failed, you cannot login for 15 minutes. Try again later.';

  @override
  String confirmGivtSafari(Object value0) {
    return 'Thank you for your Givt to $value0! Please confirm by pressing the button. You can check the status in the overview.';
  }

  @override
  String get confirmGivtSafariNoOrg => 'Thank you for your Givt! Please confirm by pressing the button. You can check the status in the overview.';

  @override
  String get menuSettingsSwitchAccounts => 'Switch accounts';

  @override
  String get prepareIUnderstand => 'I understand';

  @override
  String get amountLimitExceededGb => 'This amount is higher than £250. Please choose a lower amount.';

  @override
  String giftOverviewGiftAidBanner(Object value0) {
    return 'Gift Aided $value0';
  }

  @override
  String get maximumAmountReachedGb => 'Woah, you\'ve reached the maximum donation limit. In the UK you can give a maximum of £250 per donation.';

  @override
  String get faqWhyBluetoothEnabledQ => 'Why do I have to enable Bluetooth to use Givt?';

  @override
  String get faqWhyBluetoothEnabledA => 'Your phone receives a signal from the beacon inside the collection box, bag or basket. This signal uses the Bluetooth protocol. It can be considered as a one-way traffic, which means there is no connection, in contrast to a Bluetooth car kit or headset. It is a safe and easy way to let your phone know which collection box, bag or basket is nearby. When the beacon is near, the phone picks up the signal and your Givt is completed.';

  @override
  String get collect => 'Collection';

  @override
  String get offlineGegevenGivtsMessage => 'Thank you for your Givts!\n \n\n When there\'s a good connection with the Givt-server, your Givts will be processed.\n You can check the status in the overview.';

  @override
  String offlineGegevenGivtsMessageWithOrg(Object value0) {
    return 'Thank you for your Givts to $value0!\n \n\n When there\'s a good connection with the Givt-server, your Givts will be processed.\n You can check the status in the overview.';
  }

  @override
  String get changeDonation => 'Change your donation';

  @override
  String get cancelGivts => 'Cancel your Givt';

  @override
  String get areYouSureToCancelGivts => 'Are you sure? Press OK to confirm.';

  @override
  String get feedbackTitle => 'Feedback or questions?';

  @override
  String get noMessage => 'You didn\'t enter a message.';

  @override
  String get feedbackMailSent => 'We\'ve received your message succesfully, we\'ll be in touch as soon as possible.';

  @override
  String get typeMessage => 'Write your message here!';

  @override
  String get safariGivtTransaction => 'This Givt will be converted into a transaction.';

  @override
  String get safariMandateSignedPopup => 'Your donations are withdrawn from this IBAN. If this is incorrect, just cancel this Givt and register a new account.';

  @override
  String get didNotSignMandateYet => 'You still need to sign a mandate. This is necessary to be able to give from start to finish. At the moment it\'s not possible to sign one. Your Givt will proceed, but to be processed completely, a mandate needs to be signed.';

  @override
  String get appVersion => 'App version:';

  @override
  String get shareGivtText => 'Share Givt';

  @override
  String get shareGivtTextLong => 'Hey! Do you want to keep on giving?';

  @override
  String get givtGewoonBlijvenGeven => 'Givt - Always good to give.';

  @override
  String get updatesDoneTitle => 'Ready to start giving?';

  @override
  String get updatesDoneSubtitle => 'Givt is completely up-to-date, have fun giving.';

  @override
  String get featureShareTitle => 'Share Givt with everyone!';

  @override
  String get featureShareSubtitle => 'Sharing Givt is as easy as 1, 2, 3. You can share the app at the bottom of the settings page.';

  @override
  String get askMeLater => 'Ask me later';

  @override
  String get giveDifferently => 'Choose from the list';

  @override
  String get churches => 'Churches';

  @override
  String get stichtingen => 'Charities';

  @override
  String get acties => 'Campaigns';

  @override
  String get overig => 'Other';

  @override
  String get signMandateLaterTitle => 'Okay, we will ask you again later.';

  @override
  String get signMandateLater => 'You have chosen to sign the mandate later. You can do this the next time you give.';

  @override
  String get suggestie => 'Give to:';

  @override
  String get codeCanNotBeScanned => 'Alas, this code cannot be used to give within the Givt app.';

  @override
  String get giveDifferentScan => 'Scan QR code';

  @override
  String get giveDiffQrText => 'Now, aim well!';

  @override
  String get qrCodeOrganisationNotFound => 'Code is scanned, but it seems the organisation has lost its way. Please, try again later.';

  @override
  String get noCameraAccess => 'We need your camera to scan the code. Go to the app settings on your smartphone to give us your permission.';

  @override
  String get nsCameraUsageDescription => 'We\'d like to use your camera to scan the code.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get needEmailToGiveSubtext => 'To be able to process your donations correctly, we need your e-mail address.';

  @override
  String get completeRegistrationAfterGiveFirst => 'Thanks for giving with Givt!\n \n\n We would love for you to keep \n using Givt, so we ask you \n to complete the registration.';

  @override
  String get termsUpdate => 'The terms and conditions have been updated';

  @override
  String get agreeToUpdateTerms => 'You agree to the new terms and conditions if you continue.';

  @override
  String get iWantToReadIt => 'I want to read it';

  @override
  String get termsTextVersion => '1.9';

  @override
  String get locationPermission => 'We need to access your location to receive the signal from the Givt-beacon.';

  @override
  String get locationEnabledMessage => 'Please enable your location with high accuracy to give with Givt. (After your donation you can disable it again.)';

  @override
  String get changeGivingLimit => 'Adjust maximum amount';

  @override
  String get somethingWentWrong2 => 'Something went wrong.';

  @override
  String get chooseLowerAmount => 'Change the amount';

  @override
  String get turnOnBluetooth => 'Switch on Bluetooth';

  @override
  String get errorTldCheck => 'Sorry, you can’t register with this e-mail address. Could you check for any typos?';

  @override
  String get addCollectConfirm => 'Do you want to add a second collection?';

  @override
  String get faQvraag0 => 'Feedback or questions?';

  @override
  String get faQantwoord0 => 'In the app-menu under \"About Givt / Contact\" there\'s a text field where you can type a message and send it to us. Of course you can also contact us by calling +44 2037 908068 or by sending an e-mail to support@givt.co.uk';

  @override
  String get personalPageHeader => 'Change your account data here.';

  @override
  String get personalPageSubHeader => 'Would you like to change your name? Send an e-mail to support@givtapp.net .';

  @override
  String get titlePersonalInfo => 'Personal information';

  @override
  String get personalInfoTempUser => 'Hi there, fast giver! You\'re using a temporary account. We have not received your personal details yet.';

  @override
  String get updatePersonalInfoError => 'Alas! We are not able to update your personal information at the moment. Could you try again later?';

  @override
  String get updatePersonalInfoSuccess => 'Success!';

  @override
  String get loadingTitle => 'Please wait...';

  @override
  String get loadingMessage => 'Please wait while we are loading your data...';

  @override
  String get buttonChange => 'Change';

  @override
  String get welcomeContinue => 'Let’s begin';

  @override
  String get enterEmail => 'Let’s begin';

  @override
  String get finalizeRegistrationPopupText => 'Important: Donations can only be processed after you have finished your registration.';

  @override
  String get finalizeRegistration => 'Finish registration';

  @override
  String get importantReminder => 'Important reminder';

  @override
  String get multipleCollections => 'Multiple collections';

  @override
  String get questionAndroidLocation => 'Why does Givt need access to my location?';

  @override
  String get answerAndroidLocation => 'When using an Android smartphone, the Givt-beacon can only be detected by the Givt app when the location is known. Therefore, Givt needs your location to make giving possible. Besides that, we do not use your location.';

  @override
  String get shareTheGivtButton => 'Share with my friends';

  @override
  String shareTheGivtText(Object value0) {
    return 'I\'ve just used Givt to donate to $value0!';
  }

  @override
  String get shareTheGivtTextNoOrg => 'I\'ve just used Givt to donate!';

  @override
  String get joinGivt => 'Get involved on givtapp.net/download.';

  @override
  String get firstUseWelcomeSubTitle => 'Swipe for more information';

  @override
  String get firstUseWelcomeTitle => 'Welcome!';

  @override
  String get firstUseLabelTitle1 => 'Give everywhere with one debit mandate';

  @override
  String get firstUseLabelTitle2 => 'Easy, safe and anonymous giving';

  @override
  String get firstUseLabelTitle3 => 'Give always and everywhere';

  @override
  String get yesSuccess => 'Yes, success!';

  @override
  String get toGiveWeNeedYourEmailAddress => 'To start giving, we only need your email address.';

  @override
  String get weWontSendAnySpam => '(we won\'t send any spam, promise)';

  @override
  String get swipeDownOpenGivt => 'Swipe down to open the Givt app.';

  @override
  String get moreInfo => 'More info';

  @override
  String get germany => 'Germany';

  @override
  String get extraBluetoothText => 'Does it look like your Bluetooth is on? It is still necessary to switch it off and on again.';

  @override
  String get openMailbox => 'Open inbox';

  @override
  String get personalInfo => 'Personal info';

  @override
  String get cameraPermission => 'We need to access your camera to scan a QR code.';

  @override
  String get downloadYearOverview => 'Do you want to download your donations overview of 2017 for your tax return?';

  @override
  String get sendOverViewTo => 'We\'ll send the overview to';

  @override
  String get yearOverviewAvailable => 'Annual overview available';

  @override
  String get checkHereForYearOverview => 'You can request your annual overview here';

  @override
  String get couldNotSendTaxOverview => 'We can\'t seem to fetch your annual review, please try again later. Contact us at support@givtapp.net if this problem persists.';

  @override
  String get searchHere => 'Search ...';

  @override
  String get noInternet => 'Whoops! It looks like you\'re not connected to the internet. Try again when you are connected with the internet.';

  @override
  String get noInternetConnectionTitle => 'No internet connection';

  @override
  String get serverNotReachable => 'Alas, it\'s not possible to finish your registration at this time, our server seems to have an issue. Can you try it again later?\n Got this message before? We\'re probably not aware of this issue. Help us improve Givt by sending us a message and we\'ll get right on it.';

  @override
  String get sendMessage => 'Send message';

  @override
  String get answerWhyAreMyDataStored => 'Everyday we work very hard at improving Givt. To do this we use the data we have at our disposal.\n We require some of your data to create your mandate. Other information is used to create your personal account.\n We also use your data to answer your service questions.\n In no case we give your personal details to third parties.';

  @override
  String get logoffSession => 'Log out';

  @override
  String get alreadyAnAccount => 'Already have an account?';

  @override
  String get unitedKingdom => 'United Kingdom';

  @override
  String get cancelShort => 'Cancel';

  @override
  String get cantCancelGiftAfter15Minutes => 'Alas, you can\'t cancel this donation within the Givt app.';

  @override
  String get unknownErrorCancelGivt => 'Due to an unexpected error, we could not cancel your donation. Get in touch with us at support@givtapp.net for more information.';

  @override
  String transactionCancelled(Object value0) {
    return 'The donation to $value0 will be cancelled.';
  }

  @override
  String get cancelled => 'Cancelled';

  @override
  String get undo => 'Undo';

  @override
  String get faqVraag16 => 'Can I revoke donations?';

  @override
  String get faqAntwoord16 => 'Yes, simply go to the donation overview and swipe the donation you want to cancel to the left. If this it not possible the donation has already been processed. Note: You can only cancel your donation if you have completed your registration in the Givt app.\n \n\n No transactions take place in the moment of giving. The transactions take place afterwards via a direct debit. Since these transactions are revertible via your bank, it is completely safe and immune to fraud.';

  @override
  String get selectContextCollect => 'Give in the church, at the door or on the street';

  @override
  String get giveContextQr => 'Give by scanning a QR code';

  @override
  String get selectContextList => 'Select a cause from the list';

  @override
  String get selectContext => 'Choose the way you give';

  @override
  String get chooseWhoYouWantToGiveTo => 'Choose who you want to give to';

  @override
  String get cancelGiftAlertTitle => 'Cancel donation?';

  @override
  String get cancelGiftAlertMessage => 'Are you sure you want to cancel this donation?';

  @override
  String get gotIt => 'Got it';

  @override
  String get cancelFeatureTitle => 'You can cancel a donation by swiping left';

  @override
  String get cancelFeatureMessage => 'Tap anywhere to dismiss this message';

  @override
  String get giveSubtitle => 'There are several ways to ‘Givt’. Pick the one that suits you best.';

  @override
  String get confirm => 'Confirm';

  @override
  String safariGivingToOrganisation(Object value0) {
    return 'You just gave to $value0. Find the overview of your donation below.';
  }

  @override
  String get safariGiving => 'You just gave. Find the overview of your donation below.';

  @override
  String get giveSituationShowcaseTitle => 'Next, choose how you want to give';

  @override
  String get soonMessage => 'Coming soon...';

  @override
  String get giveWithYourPhone => 'Move your phone';

  @override
  String get celebrateTitle => 'Let\'s countdown';

  @override
  String get celebrateMessage => 'When the countdown hits 0, hold your phone above your head.\n \n\n What\'s going to happen? You\'ll soon see...';

  @override
  String get afterCelebrationTitle => 'Wave!';

  @override
  String get afterCelebrationMessage => 'Hold it up, shine your light!';

  @override
  String get errorContactGivt => 'An error has occurred, please contact us at support@givtapp.net .';

  @override
  String get mandateFailPersonalInformation => 'It seems there is something wrong with the information you filled in. Could you please check in the menu, under \'Personal information\'? You can change the information there as well, if necessary.';

  @override
  String mandateSmsCode(Object value0, Object value1) {
    return 'We\'ll send a text message to $value0. The mandate will be signed on behalf of $value1. Correct? Proceed to the next step.';
  }

  @override
  String get mandateSigningCode => 'If all goes well, you\'ll receive a text message. Fill in the code below to sign your mandate.';

  @override
  String get readCode => 'Your code:';

  @override
  String get readMandate => 'View mandate';

  @override
  String get mandatePdfFileName => 'mandate';

  @override
  String get writeStoragePermission => 'To be able to view this PDF, we need access to your phone\'s storage so that we can save the PDF and show it.';

  @override
  String get legalTextSlimPay => 'By continuing, you will be asked to sign a mandate authorizing Givt B.V. to debit your account. You must be the account holder or be authorized to act on the account holder\'s behalf.\n \n\n Your personal data will be processed by SlimPay, a licensed payment institution, to execute the payment transaction on behalf of Givt B.V., and to prevent fraud according to European regulation.';

  @override
  String get resendCode => 'Resend code';

  @override
  String get wrongCodeMandateSigning => 'The code seems to be incorrect. Try again or request a new code.';

  @override
  String get back => 'Back';

  @override
  String get amountLowest => 'Two Euro Fifthy';

  @override
  String get amountMiddle => 'Seven Euro Fifthy';

  @override
  String get amountHighest => 'Twelve Euro Fifthy';

  @override
  String get divider => 'Dot';

  @override
  String givtEventText(Object value0) {
    return 'Hey! You\'re at a location where Givt is supported. Do you want to give to $value0?';
  }

  @override
  String get searchingEventText => 'We are searching where you are, care to wait a little?';

  @override
  String get weDoNotFindYou => 'Alas, we cannot find your location right now. You can choose from a list to which organisation you want to give or go back and try again.';

  @override
  String get selectLocationContext => 'Give at location';

  @override
  String get changePassword => 'Change password';

  @override
  String get allowGivtLocationTitle => 'Allow Givt to access your location';

  @override
  String get allowGivtLocationMessage => 'We need your location to determine who you want to give to.\n Go to Settings > Privacy > Location Services > Set Location Services On and set Givt to \'While Using the App\'.';

  @override
  String get faqVraag10 => 'How do I change my password?';

  @override
  String get faqAntwoord10 => 'If you want to change your password, you can choose ‘Personal information’ in the menu and then press the ‘Change password’ button. We will send you an e-mail with a link to a web page where you can change your password.';

  @override
  String get editPersonalSucces => 'Your personal information is successfully updated';

  @override
  String get editPersonalFail => 'Oops, we could not update your personal information';

  @override
  String get changeEmail => 'Change e-mail address';

  @override
  String get changeIban => 'Change IBAN';

  @override
  String get smsSuccess => 'Code sent via SMS';

  @override
  String get smsFailed => 'Please try again later';

  @override
  String get kerkdienstGemistQuestion => 'How can I give with Givt through 3rd-parties?';

  @override
  String get kerkdienstGemistAnswer => 'Kerkdienst Gemist\n If you’re watching using the Kerkdienst Gemist App, you can easily give with Givt when your church uses our service. At the bottom of the page, you’ll find a small button that will take you to the Givt app. Choose an amount, confirm with \'Yes, please\' and you’re done!';

  @override
  String externalSuggestionLabel(Object value0, Object value1) {
    return 'We see you are giving from the $value0 app. Would you like to give to $value1?';
  }

  @override
  String get chooseHowIGive => 'No, I\'d like to decide how I give myself';

  @override
  String get andersGeven => 'Give differently';

  @override
  String get kerkdienstGemist => 'Kerkdienst Gemist';

  @override
  String get changePhone => 'Change mobile number';

  @override
  String get artists => 'Artists';

  @override
  String get changeAddress => 'Change address';

  @override
  String get selectLocationContextLong => 'Give based on your location';

  @override
  String get givtAtLocationDisabledTitle => 'No Givt locations found';

  @override
  String get givtAtLocationDisabledMessage => 'Sorry! At the moment, no organisations are available to give to at this location.';

  @override
  String get tempAccountLogin => 'You\'re using a temporary account without password. You will now be automatically logged in and asked to complete your registration.';

  @override
  String get sortCodePlaceholder => 'Sort code';

  @override
  String get bankAccountNumberPlaceholder => 'Bank account number';

  @override
  String get bacsSetupTitle => 'Setting up Direct Debit Instruction';

  @override
  String get bacsSetupBody => 'You are signing an incidental direct debit, we will only debit from your account when you use the Givt app to make a donation.\n \n\n By continuing, you agree that you are the account holder and are the only person required to authorise debits from this account.\n \n\n The details of your Direct Debit Instruction mandate will be sent to you by e-mail within 3 working days or no later than 10 working days before the first collection.';

  @override
  String get bacsUnderstoodNotice => 'I have read and understood the advance notice';

  @override
  String get bacsVerifyTitle => 'Verify your details';

  @override
  String get bacsVerifyBody => 'If any of the above is incorrect, please abort the registration and change your \'Personal information\'\n \n\n The company name which will appear on your bank statement against the Direct Debit will be Givt Ltd.';

  @override
  String get bacsReadDdGuarantee => 'Read Direct Debit Guarantee';

  @override
  String get bacsDdGuarantee => '- The Guarantee is offered by all banks and building societies that accept instructions to pay Direct Debits.\n - If there are any changes to the way this incidental Direct Debit Instruction is used, the organisation will notify you (normally 10 working days) in advance of your account being debited or as otherwise agreed. \n - If an error is made in the payment of your Direct Debit, by the organisation, or your bank or building society, you are entitled to a full and immediate refund of the amount paid from your bank or building society.\n - If you receive a refund you are not entitled to, you must pay it back when the organisation asks you to.\n - You can cancel a Direct Debit at any time by simply contacting your bank or building society. Written confirmation may be required. Please also notify the organisation.';

  @override
  String get bacsAdvanceNotice => 'You are signing an incidental, non-recurring Direct Debit Instruction mandate. Only on your specific request will debits be executed by the organisation. All the normal Direct Debit safeguards and guarantees apply. No changes in the use of this Direct Debit Instruction can be made without notifying you at least five (5) working days in advance of your account being debited.\n In the event of any error, you are entitled to an immediate refund from your bank or building society. \n You have the right to cancel a Direct Debit Instruction at any time by writing to your bank or building society, with a copy to us.';

  @override
  String get bacsAdvanceNoticeTitle => 'Advance Notice';

  @override
  String get bacsDdGuaranteeTitle => 'Direct Debit Guarantee';

  @override
  String bacsVerifyBodyDetails(Object value0, Object value1, Object value2, Object value3, Object value4) {
    return 'Name: $value0\n Address: $value1\n E-mail address: $value2\n Sort code: $value3\n Account number: $value4\n Frequency type: Incidental, when you use the Givt app to make a donation';
  }

  @override
  String get bacsHelpTitle => 'Need help?';

  @override
  String get bacsHelpBody => 'Can\'t figure something out or you just have a question? Give us a call at +44 2037 908068 or hit us up on support@givt.co.uk and we will be in touch!';

  @override
  String bacsSortcodeAccountnumber(Object value0, Object value1) {
    return 'Sortcode: $value0\n Account number: $value1';
  }

  @override
  String get cantFetchPersonalInformation => 'We can\'t seem to fetch your personal information right now, could you try again later?';

  @override
  String get givingContextCollectionBag => 'Collection device';

  @override
  String get givingContextQrCode => 'QR code';

  @override
  String get givingContextLocation => 'Location';

  @override
  String get givingContextCollectionBagList => 'List';

  @override
  String get amountPresetsTitle => 'Amount presets';

  @override
  String get amountPresetsBody => 'Set your amount presets below.';

  @override
  String get amountPresetsResetAll => 'Reset values';

  @override
  String get amountPresetsErrGivingLimit => 'The amount is higher than your maximum amount';

  @override
  String amountPresetsErr25C(Object value0) {
    return 'The amount has to be at least $value0';
  }

  @override
  String get amountPresetsErrEmpty => 'Enter an amount';

  @override
  String alertBacsMessage(Object value0) {
    return 'Because you indicated $value0 as country choice, we assume that you prefer to give through a SEPA mandate (€), we need your IBAN for that. If you prefer to use BACS (£), we need your Sort Code and Account Number.';
  }

  @override
  String alertSepaMessage(Object value0) {
    return 'Because you indicated $value0 as country choice, we assume that you prefer to give through BACS Direct Debit (£), we need your Sort Code and Account Number for that. If you prefer to use SEPA (€), we need your IBAN.';
  }

  @override
  String get important => 'Important';

  @override
  String get fingerprintTitle => 'Fingerprint';

  @override
  String get touchId => 'Touch ID';

  @override
  String get faceId => 'Face ID';

  @override
  String get touchIdUsage => 'This is where you change the use of your Touch ID to login into the Givt app.';

  @override
  String get faceIdUsage => 'This is where you change the use of your Face ID to login into the Givt app.';

  @override
  String get fingerprintUsage => 'This is where you change the use of your fingerprint to login into the Givt app.';

  @override
  String get authenticationIssueTitle => 'Authentication problem';

  @override
  String get authenticationIssueMessage => 'We could not properly identify you. Please try again later.';

  @override
  String get authenticationIssueFallbackMessage => 'We could not properly identify you. Please log in using your access code or password.';

  @override
  String get cancelledAuthorizationMessage => 'You cancelled the authentication. Do you want to login using your access code/password?';

  @override
  String get offlineGiftsTitle => 'Offline donations';

  @override
  String get offlineGiftsMessage => 'To make sure your donations arrive on time, your internet connection needs to be activated so that the donations you made can be sent to the server.';

  @override
  String get enrollFingerprint => 'Place your finger on the sensor.';

  @override
  String fingerprintMessageAlert(Object value0, Object value1) {
    return 'Use $value0 to log in for $value1';
  }

  @override
  String get loginFingerprint => 'Login using your fingerprint';

  @override
  String get loginFingerprintCancel => 'Login using pass code/password';

  @override
  String get fingerprintStateScanning => 'Touch sensor';

  @override
  String get fingerprintStateSuccess => 'Fingerprint recognized';

  @override
  String get fingerprintStateFailure => 'Fingerprint not recognized.\n Try again.';

  @override
  String get activateBluetooth => 'Activate Bluetooth';

  @override
  String get amountTooHigh => 'Amount too high';

  @override
  String get activateLocation => 'Activate location';

  @override
  String get loginFailure => 'Login error';

  @override
  String get requestFailed => 'Request failed';

  @override
  String get resetPasswordSent => 'You should have received an e-mail with a link to reset your password. In case you do not see the e-mail right away, check your spam.';

  @override
  String get success => 'Success!';

  @override
  String get notSoFast => 'Not so fast, big spender';

  @override
  String get giftBetween30Sec => 'You already gave within 30 seconds. Can you wait a little?';

  @override
  String get android8ActivateLocation => 'Enable your location and make sure the \'High accuracy\' mode is selected.';

  @override
  String get android9ActivateLocation => 'Enable your location and make sure \'Location Accuracy\' is enabled.';

  @override
  String get nonExistingEmail => 'We have not seen this e-mail address before. Is it possible that you registered with a different e-mail account?';

  @override
  String get secondCollection => 'Second collection';

  @override
  String get amountTooLow => 'Amount too low';

  @override
  String get qrScanFailed => 'Aiming failed';

  @override
  String get temporaryAccount => 'Temporary account';

  @override
  String get temporaryDisabled => 'Temporarily blocked';

  @override
  String get cancelFailed => 'Cancel failed';

  @override
  String get accessDenied => 'Access denied';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get mandateFailed => 'Authorization failed';

  @override
  String qrScannedOutOfApp(Object value0) {
    return 'Hey! Great that you want to give with a QR code! Are you sure you would like to give to $value0?';
  }

  @override
  String get saveFailed => 'Saving failed';

  @override
  String get invalidEmail => 'Invalid e-mail address';

  @override
  String get giftsOverviewSent => 'We\'ve sent your donations overview to your mailbox.';

  @override
  String get giftWasBetween30S => 'Your donation was not processed because it was less than 30 sec. ago since your last donation.';

  @override
  String get promotionalQr => 'This code redirects to our webpage. You cannot use it to give within the Givt app.';

  @override
  String get promotionalQrTitle => 'Promo QR code';

  @override
  String get downloadYearOverviewByChoice => 'Do you want to download an annual overview of your donations? Choose the year below and we will send the overview to';

  @override
  String giveOutOfApp(Object value0) {
    return 'Hey! Great that you want to give with Givt! Are you sure you would like to give to $value0?';
  }

  @override
  String get mandateFailTryAgainLater => 'Something went wrong while generating the mandate. Can you try again later?';

  @override
  String get featureButtonSkip => 'Skip';

  @override
  String get featureMenuText => 'Your app from A to Z';

  @override
  String get featureMultipleNew => 'Hello, we would like to introduce a few new features to you.';

  @override
  String get featureReadMore => 'Read more';

  @override
  String featureStepTitle(Object value0, Object value1) {
    return 'Feature $value0 of $value1';
  }

  @override
  String get noticeSmsCode => 'Important!\n Please note that you have to fill in the sms code in the webpage and not in the app. When you have signed the mandate you will be automatically redirected to the app.';

  @override
  String get featurePush1Title => 'Push notifications';

  @override
  String get featurePush2Title => 'We\'ll help you through';

  @override
  String get featurePush3Title => 'Make sure they\'re switched on';

  @override
  String get featurePush1Message => 'With a push notification we can tell you something important while the app isn\'t running.';

  @override
  String get featurePush2Message => 'If there is something wrong with your account or with your gifts, we can communicate that easily and quickly.';

  @override
  String get featurePush3Message => 'And don\'t hesitate to leave them on. We only communicate about urgent matters.';

  @override
  String get featurePushInappnot => 'Tap here to read more about push notifications';

  @override
  String get featurePushNotenabledAction => 'Switch on';

  @override
  String get featurePushEnabledAction => 'I understand';

  @override
  String get termsTextGb => 'GIVT LTD \n\nTerms of use – Givt app \nLast updated: 24-11-2023\nVersion: 1.5\n\n1.  \tGeneral \nThese terms of use describe the conditions under which the mobile application Givt (\"Givt\") can be utilised. Givt allows the User (anonymously) to give donations through their smartphone, for example churches, fundraising campaigns or charities that are members of Givt Ltd.  \n\nThese terms of use apply to the use of Givt. Through the use of Givt (which means the download and the installation thereof), you (\"the User\") accept these terms of use and our privacy policy (https://givt.co.uk/privacystatementgivt-service). These terms of use and our privacy policy are also available on our website to download and print. We may revise these terms of use from time to time. \n\n2.  \tLicense and intellectual property rights \n\n2.1\tAll rights to Givt, the accompanying documentation and all modifications and extensions thereto as well as the enforcement thereof are and remain the property of Givt. The User is granted solely the rights and authorities and/or permissions ensuing from the effect of this agreement or which are assigned in writing, and you may not otherwise use, reproduce or publicly release Givt. \n\n2.2\tGivt grants the User a non-exclusive, non-sublicensable and non-transmittable license to use Givt. The User is not allowed to use Givt for commercial purposes. \n\n2.3  \tThe User may not provide Givt to third parties nor sell, rent, decompile, submit to reverse engineer or modify it without prior permission from Givt. Nor should the User, or let others, remove or bypass the technical provisions that are intended to protect Givt. \n\n2.4 \tGivt has the right to change Givt at any time, modify or remove data, deny the User the use of Givt by termination of the license, limitation of the use of Givt or deny access to Givt in whole or in part, temporarily or permanently. Givt will inform the User about this in an appropriate manner. \n\n2.5 \tThe User acquires no right, title or interest to the intellectual property rights and/or similar rights to (the means of) Givt, including the underlying software and content.\n\n3. \tThe use of Givt \n\n3.1 \tThe User can only give donations to churches, charities, fundraising campaigns and/or other legal entities that are affiliated with Givt. The donations are done anonymously. \n\n3.2  \tThe use of Givt is at your own risk and expense and should be used in accordance with the purposes for which it is intended. It is prohibited to reverse engineer the source code of Givt or to decompile and/or modify Givt, to make a copy of Givt available to any third party or to remove, delete or render illegible any designations of Givt as the party holding rights to Givt or parts thereof.\n\n3.3\tThe User is responsible for the correct submission of data such as name and address details, bank account number and other information as requested by Givt to ensure the use of Givt. \n\n3.4\tIf the User is under the age of 18 they must have the consent of their parent or legal guardian in order to use Givt. By accepting these terms of use, the User guarantees that they are 18 years of age or have the permission of their parents or legal representative. \n\n3.5 \tGivt is available for the operating systems Android and iOS. In addition to the provisions set out below, Apple’s App Store or Google Play may attach conditions to the acquisition of Givt, its use and related matters. For further information, see the terms of use and privacy policy of Apple’s App Store and Google Play as well as any other applicable terms and conditions appearing on the website of the respective provider. This end user licence is applicable to the agreement between the User and Givt and does not apply between the User and the provider of the platform through which you acquired Givt. That provider may hold you liable for violation of provisions in this end user licence, however.\n\n3.6\tAfter the User has downloaded Givt, the User is requested to register. In doing so, the User must provide the following information: (i) name (ii) address, (iii) phone number, (iv) bank account number, and (v) e-mail address. The privacy policy of Givt is applied to the processing of personal data via Givt. The User must inform Givt immediately if any of this data changes by correcting the information within the app.\n\n3.7\tThe User may, after installing the Givt app, also choose to only enter an e-mail address and immediately use the app to donate. After the donation, the User will be asked to complete the registration procedure. If the User wishes to do so later, Givt ensures to only use the User\'s e-mail address to remind the User to finish the registration procedure until this procedure is finalised.\n\n3.8 \tThe User is responsible for any expenses related to the equipment, software system and (internet) connection to make use of Givt.\n\n3.9 \tGivt provides the related services based on the information the User submits. The User is obliged to provide correct and complete information, which is not false or misleading. The User may not provide data with respect to names or bank accounts for which the User is not authorised to use. Givt and the Processor have the right to validate and verify the information the User has provided. \n\n3.10 \tThe User may at any time terminate the use of Givt, by deleting their account via the menu in the app or via mail to support@givt.app. Deleting the app from the smartphone without following aforementioned steps will not result in deletion of the User’s data. Givt can terminate the relationship with the User if the User does not comply with these terms and conditions or if Givt has not been used for 18 consecutive months. On request Givt can send a listing of all donation data. \n\n3.11 \tGivt does not charge fees for the use of Givt. \n\n3.12\tGivt has the right to adjust the offered functionalities from time to time to improve, to change or to fix errors. Givt will always work to fix errors within the Givt software, but cannot guarantee that all errors, whether or not in a timely fashion, be restored. \n\n4. \tProcessing transactions and Protecting your money\n\n4.1 \tGivt does not provide banking or payment services. To facilitate the processing of donations from the User, Givt has entered into an agreement with Access Paysuite Ltd, an Electronic Money Institution, authorised and regulated by the Financial Conduct Authority (FRN 730815) (“Access PaySuite”)(the \"Processor\"). Givt will, after the collection of donations, ensure the payment of donations to the user-designated beneficiary. The transaction data will be processed and forwarded to the Givt Processor. The Processor will initiate payment transactions whereas Givt is responsible for the transaction of the relevant amounts to the bank account of the Church/Charity as being the user-designated beneficiary of the donation.\n\n4.2 \tThe User agrees that Givt may pass the User’s (transaction and bank) data to the Processor, along with all other necessary account and personal information of the User, in order to enable the Processor to initiate the payment transactions and processing. Givt reserves the right to change the Processor at any time. The User agrees that Givt may forward the relevant information and data about the User as defined in article 4.2 to the new Processor to be able to continue processing payment transactions. \n\n4.3 \tGivt and the Processor will process the data of the User in accordance with the law and regulations that apply to data protection. For further information on how personal data is collected, processed and used, Givt refers the User to its privacy policy. This can be found at: (https://givt.co.uk/privacystatementgivt-service/).\n\n4.4 \tThe donations of the User will pass through Access PaySuite. Givt will ensure that the funds will be transferred to the beneficiary, with whom Givt has an agreement. \n\n4.5 \tThe User can reverse a debit at any time, within the terms of the User\'s bank, and the direct debit scheme. \n\n4.6 \tGivt and/or the Processor can refuse a donation if there are reasonable grounds to believe that a user is acting in violation of these terms or if there are reasonable grounds to believe that a donation is possibly suspicious or illegal. In this case Givt will inform the User as soon as possible, unless prohibited by law. \n\n4.7\tUsers of the Givt app will not be charged for their donations through our platform. Givt and the receiving party have made separate compensation arrangements pursuant to the agreement in effect between them.\n\n4.8 \tThe User agrees that Givt may pass transactional data of the User to the HMRC, along with all other necessary account and personal information of the User, in order to assist the User with their annual tax return.   \n\n4.9\tWe will hold your money in a Client Funds Account, provided by Access PaySuite. The account is segregated from our own assets. The money contained in the Client Funds Account cannot be used by Givt, invested or lent to third parties, or in any way form part of Givt’s assets.\n\n4.10\tCurrent Regulatory Provisions exclude money placed on a Client Funds Account from the UK Financial Services Compensation Scheme (FSCS).\n\n4.11\tMoney placed or held in the Client Funds Account shall not constitute a deposit (within the meaning of Article 5 of Directive 2006/48/EC) and does not earn interest.\n4.12\tDeposits and, in particular, withdrawals from the Client Funds Account will only be made in the following circumstances:\n\nIn the case of deposits:\n\nTo receive money intended for onward payment to the designated charity/charities or church(es)\nTo replenish the account where fees or other costs associated with running the account have been deducted\nTo receive refunds in the event that prior instruction to make a payment by you is cancelled, in accordance with these Terms and Conditions\n\nIn the case of withdrawals:\n\nTo pay designated charities and churches, in accordance with your instructions\nTo pay fees or other costs associated with running the account\nTo return money to you, in the event that prior instruction to make a payment by you is canceled, in accordance with these Terms and Conditions.\n\n5. \tSecurity, theft and loss \n\n5.1 \tThe User shall take all reasonable precautions safekeeping their login credentials for Givt to avoid loss, theft, misappropriation or unauthorised use of Givt on their device.\n\n5.2 \tThe User is responsible for the security of their device. Givt considers any donation from the Givt account as a user-approved transaction, regardless of the rights of the User under article 4.5.\n\n5.3 \tThe User shall inform Givt immediately via info@givt.app or +44 20 3790 8068 once their device is lost or stolen. Upon receipt of a message Givt will block the account to prevent (further) misuse. \n\n6.\tUpdates\n\n6.1\tGivt releases updates from time to time, which can rectify errors or improve the functionality of Givt. Available updates for Givt will be announced by means of notification through Apple’s App Store and Google Play and it is the User’s sole responsibility to monitor these notifications and keep informed about new updates.\n\n6.2\tAn update can stipulate conditions, which differ from the provisions in this agreement. The User will always be notified in advance so that they have the opportunity to refuse the update. By installing such an update, the User agrees to these new conditions, which will then form part of this agreement. If User does not agree to the changed conditions, they will have to cease using Givt and delete Givt from their device.\n\n7. \tLiability \n\n7.1 \tGivt has been compiled with the utmost care. Although Givt strives to make Givt available 24 hours a day, it accepts no liability if, for any reason, Givt is not available at any given time or for a certain period of time. Givt reserves the right to temporarily or permanently discontinue Givt (unannounced). The User cannot derive any rights from this. \n\n7.2 \tGivt is not liable for damage or injury resulting from the use of Givt. The limitations of liability as mentioned in this article shall lapse if the liability for damage is the result of intent or gross negligence on the part of Givt.\n\n7.3 \tThe User indemnifies Givt against any claim from third parties (for example, beneficiaries of the donations or HMRC) as a result of the use of the Givt or not correctly meeting the agreements made concerning legal or contractual obligations with Givt. The User will pay all damages and costs to Givt as a result of such claims.\n\n8. \tOther provisions \n\n8.1 \tThis agreement comes into effect on commencement of the use of Givt and will remain in force for an undetermined period from that moment. This agreement may be terminated by the User as well as by Givt at any moment, subject to one month’s notice. This agreement will end by operation of law in the event you are declared bankrupt, you apply for a moratorium on payments or a general attachment is levied against your assets, in the event of your death, or in the event you go into liquidation, are wound up or dissolved. Following the termination of this agreement (for whatever reason), you shall cease and desist from all further use of Givt. You must then delete all copies (including back-up copies) of Givt from all your devices.\n\n8.2\tIf any provision of these terms and conditions is void or destroyed, this will not affect the validity of the agreement as a whole, and other provisions of these terms remain in force. In that case, the parties will decide on a new replacement provision or provisions which will be in line with the intention of the original agreement as far as is legally possible.\n\n8.3 \tThe User is not allowed to transfer the rights and/or obligations arising from the use of Givt and these terms to third parties without prior written permission of Givt. Conversely, Givt is allowed to do so. \n\n8.4 \tWe will endeavor to resolve the dispute amicably. Any disputes arising from or in connection with these terms and conditions are finally settled in the Courts of England and Wales. \n\n8.5  \tThe Law of England and Wales is applicable on these terms of use. \n\n8.6 \tThe terms of use shall not affect the User\'s statutory rights as a consumer.\n\n8.7 \tGivt features an internal complaints procedure. Givt handles complaints efficiently and as soon as reasonably possible. Any complaint about the implementation of these conditions by Givt must be submitted in writing at Givt (via support@givt.app).\n\n\n';

  @override
  String get firstCollect => '1st collection';

  @override
  String get secondCollect => '2nd collection';

  @override
  String get thirdCollect => '3rd collection';

  @override
  String get addCollect => 'Add a collection';

  @override
  String get termsTextVersionGb => '1.3';

  @override
  String get accountDisabledError => 'Alas, it looks like your account has been deactivated. Don\'t worry! Just send a quick e-mail to support@givtapp.net.';

  @override
  String get featureNewgui1Title => 'The user interface';

  @override
  String get featureNewgui2Title => 'Progress bar';

  @override
  String get featureNewgui3Title => 'Multiple collections';

  @override
  String get featureNewgui1Message => 'Quickly and easily add an amount and add or remove collections in the first screen.';

  @override
  String get featureNewgui2Message => 'Based on the progress bar at the top, you know exactly where you are in the giving process.';

  @override
  String get featureNewgui3Message => 'Add or remove collections with a single tap on a button.';

  @override
  String get featureNewguiAction => 'Okay, understood!';

  @override
  String get featureMultipleInappnot => 'Hi! We have something new for you. Do you have a minute?';

  @override
  String get policyTextGb => 'Latest Amendment: 24-09-2021\n Version 1.9\n \n\n Givt Limited Privacy Policy  \n \n\n Introduction\n This Privacy Policy outlines Givt Limited’s (\" we \", \" our \" or \" the Company \") practices with respect to information collected from our Application (“App”) or from users that otherwise share personal information with us (collectively: \"Users\"). \n \n\n Grounds for data collection \n \n\n Processing of your personal information (meaning, any information which may potentially allow your identification with reasonable means; hereinafter \"Personal Information\") is necessary for the performance of our contractual obligations towards you and providing you with our services, to protect our legitimate interests and for compliance with legal and financial regulatory obligations to which we are subject.\n \n\n When you use our App or register yourself or an organisation you represent with us, you consent to the collection, storage, use, disclosure and other uses of your Personal Information as described in this Privacy Policy.\n \n\n We encourage our Users to carefully read the Privacy Policy and use it to make informed decisions. \n \n\n What information do we collect?\n \n\n We collect two types of data and information from Users. \n \n\n The first type of information is un-identified and non-identifiable information pertaining to a User(s), which may be made available or gathered via your use of the App (“ Non-personal Information ”). We are not aware of the identity of a User from which the Non-personal Information was collected. Non-personal Information which is being collected may include your aggregated usage information and technical information transmitted by your device, including certain software and hardware information (e.g. language preference, access time, etc.) in order to enhance the functionality of our App.\n \n\n The second type of information is Personal Information, which is personally identifiable information, namely information that identifies an individual or may with reasonable effort identify an individual. Such information includes:\n Device Information: We collect Personal Information from your device. Such information includes geolocation data, IP address, unique identifiers (e.g. MAC address and UUID) and other information which relates to your activity through the App.\n Service User Information: We collect additional information for individuals who would like to use our Services. This is gathered through the App and includes all the information needed to register for our service: \n Name and address, \n Date of birth, \n e-mail address, \n secured password details, and \n bank details for the purposes of making payments.\n Contact information: If you choose to contact us you will be asked to provide us with certain details such as: full name; e-mail or physical address, and other relevant information. This may be for yourself or for people in the organisation you represent.\n  \n How do we receive information about you?\n We receive your Personal Information from various sources:\n \n\n When you voluntarily provide us your personal details in order to register on our App;\n When you use or access our App in connection with your use of our services;\n From third party providers, services and public registers (for example, traffic analytics vendors).\n Through diagnostic information from the App. The App will send us anonymous information about its functioning. This information contains non-personal data from your smartphone like its type and operating system, but also the version information of the App. This data is solely used for purposes of improving our Service or allowing better responses to your questions. This information will never be shared with third-parties. \n What do we do with the information we collect?\n We do not rent, sell, or share Users’ information with third parties except as described in this Privacy Policy.\n \n\n We may use the information for the following:\n To provide the services through the App – we will use a minimum of name and bank details to perform the services of effecting payment(s) via the App. Such information is never shared with intended recipients of donations.;\n Communicating with you – sending you notices regarding our services, providing you with technical information and responding to any customer service issue you may have; to keep you informed of our latest updates and services;\n Conducting statistical and analytical activities, intended to improve the App and/or the App.\n \n\n In addition to the different uses listed above, we may transfer or disclose Personal Information to our subsidiaries, affiliated companies and subcontractors in relation to services that we provide to you.\n \n\n We may also disclose information if we have good faith to believe that disclosure of such information is helpful or reasonably necessary to: (i) comply with any applicable law, regulation, legal process or governmental request; (ii) enforce our policies (including our Agreement), including investigations of potential violations thereof; (iii) investigate, detect, prevent, or take action regarding illegal activities or other wrongdoing, suspected fraud or security issues; (iv) to establish or exercise our rights to defend against legal claims; (v) prevent harm to the rights, property or safety of us, our users, yourself or any third party; or (vi) for the purpose of collaborating with law enforcement agencies and/or in case we find it necessary in order to enforce intellectual property or other legal rights.\n \n\n User Rights\n You may request to: \n Receive confirmation as to whether or not personal information concerning you is being processed, and access your stored personal information, together with supplementary information. \n Receive a copy of personal information you directly volunteer to us in a structured, commonly used and machine-readable format. \n Request rectification of your personal information that is in our control.\n Request erasure of your personal information. \n Object to the processing of personal information by us. \n Request to restrict processing of your personal information by us.\n Lodge a complaint with a supervisory authority.\n \n\n However, please note that these rights are not absolute, and may be subject to our own legitimate interests and regulatory requirements. \n \n\n If you have any questions about this Privacy Policy, please contact us:\n \n\n By e-mail: support@givt.app\n By visiting this page on our Website: https://givt.co.uk/faq-3/\n By phone number: +44 20 3790 8068.\n \n\n Retention\n We will retain your personal information for as long as necessary to provide our services, and as necessary to comply with our legal obligations, resolve disputes, and enforce our policies. Retention periods will be determined taking into account the type of information that is collected and the purpose for which it is collected, bearing in mind the requirements applicable to the situation and the need to destroy outdated, unused information at the earliest reasonable time. Under applicable regulations, we will keep records containing client personal data, account opening documents, communications and anything else as required by applicable laws and regulations. \n \n\n We may rectify, replenish or remove incomplete or inaccurate information, at any time and at our own discretion.\n \n\n Use of Location Services\n \n\n The App may use the location services as provided by the operating system on the smartphone. With these services, the App may determine the location of the user. The location data will not be sent anywhere outside the smartphone, and is solely used to determine whether the user is in a location where it’s possible to use the App for donating. The locations where one can use App are downloaded to the smartphone prior to using the location services.\n \n\n How do we safeguard your information?\n \n\n We take security measures to reduce misuse of and unauthorised access to personal data. We take the following measures in particular:\n \n\n Access to personal data requires the use of a username and password\n Access to personal data requires the use of a username and login token\n We make use of secure connections (Secure Sockets Layer of SSL) to encrypt all information between you and our website when entering your personal data.\n We keep logs of all requests for personal data.\n \n\n Although we take reasonable steps to safeguard information, we cannot be responsible for the acts of those who gain unauthorised access or abuse our App, and we make no warranty, express, implied or otherwise, that we will prevent such access.\n \n\n Transfer of data outside the EEA \n Please note that some data recipients may be located outside the EEA. In such cases we will transfer your data only to such countries as approved by the European Commission as providing adequate level of data protection, or enter into legal agreements ensuring an adequate level of data protection.\n \n\n Advertisements\n We do not use third-party advertising technology to serve advertisements when you access the App. \n \n\n Marketing\n We may use your Personal Information, such as your name, email address to send you a Newsletter about our products and services. You may opt out of receiving this Newsletter at any time by unsubscribing via the link.\n \n\n Providing Data to Third Parties\n We may provide your information to our partners. These partners are involved in the execution of the agreement. In all cases, these parties are necessary to provide the services. These are not the collecting authorities, as we protect the anonymity of users.\n You agree that the transaction data are anonymous and can be used for data collection, statistics, reviews and comparisons. Only the summary will be shared with other customers and we ensure you that none of your data will be traceable to individuals.\n \n\n We will also never sell data to third parties. We are only committed to make it easier for the donor to give to charities of their choosing.\n \n\n Updates or amendments to this Privacy Policy\n We reserve the right to periodically amend or revise the Privacy Policy; material changes will be effective immediately upon the display of the revised Privacy policy. The last revision will be reflected in the \"Last modified\" section. Your continued use of our Services following the notification of such amendments on our Website or through the App, constitutes your acknowledgment and consent of such amendments to the Privacy Policy and your agreement to be bound by the terms of such amendments.\n \n\n How to contact us\n \n\n If you have any general questions about the App or the information we collect about you and how we use it, you can contact us at: support@givt.app\n \n\n or\n \n\n By visiting this page on our Website: https://givt.co.uk/faq-3/\n By phone number: +44 20 3790 8068.\n \n\n Givt Ltd. is a part of Givt B.V., our office is located on the Bongerd 159 in Lelystad, the Netherlands.\n Company Number (CRN): 11396586';

  @override
  String get amount => 'Choose amount';

  @override
  String get amountLimit => 'Determine the maximum amount of your Givt';

  @override
  String get cancel => 'Cancel';

  @override
  String get changePincode => 'Change your access code';

  @override
  String get checkInbox => 'Success! Check your inbox.';

  @override
  String get city => 'City/Town';

  @override
  String get contactFailed => 'Something went wrong. Try again or select the recipient manually.';

  @override
  String get country => 'Country';

  @override
  String get email => 'E-mail address';

  @override
  String get errorTextRegister => 'Something went wrong while creating your account. Try a different e-mail address.';

  @override
  String get fieldsNotCorrect => 'One of the entered fields is not correct.';

  @override
  String get firstName => 'First name';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get forgotPasswordText => 'Enter your e-mail address. We will send you an e-mail with the information on how to change your password.\n \n\n If you can\'t find the e-mail right away, please check your spam.';

  @override
  String get give => 'Give';

  @override
  String get selectReceiverButton => 'Select';

  @override
  String get giveLimit => 'Maximum amount';

  @override
  String get givingSuccess => 'Thank you for your Givt!\n You can check the status in your overview.';

  @override
  String get information => 'Personal info';

  @override
  String get lastName => 'Last name';

  @override
  String get loggingIn => 'Logging in ...';

  @override
  String get login => 'Login';

  @override
  String get loginPincode => 'Enter your access code.';

  @override
  String get loginText => 'To get access to your account we would like to make sure that you are you.';

  @override
  String get logOut => 'Logout';

  @override
  String get makeContact => 'This is the Givt-moment.\n Move your phone towards the \n collection box, bag or basket.';

  @override
  String get next => 'Next';

  @override
  String get noThanks => 'No thanks';

  @override
  String get notifications => 'Notifications';

  @override
  String get password => 'Password';

  @override
  String get passwordRule => 'The password should contain at least 7 characters including at least one capital and one digit.';

  @override
  String get phoneNumber => 'Mobile number';

  @override
  String get postalCode => 'Postal Code';

  @override
  String get ready => 'Done';

  @override
  String get register => 'Register';

  @override
  String get registerBusy => 'Registering ...';

  @override
  String get registerPage => 'Register to access your Givt info.';

  @override
  String get registerPersonalPage => 'In order to process your donations,\n we need some personal information.';

  @override
  String get registerPincode => 'Enter your access code.';

  @override
  String get registrationSuccess => 'Registration successful.\n Have fun giving!';

  @override
  String get security => 'Security';

  @override
  String get send => 'Send';

  @override
  String get settings => 'Settings';

  @override
  String get somethingWentWrong => 'Whoops, something went wrong.';

  @override
  String get streetAndHouseNumber => 'Street name and number';

  @override
  String get tryAgain => 'Try again';

  @override
  String get welcome => 'Welcome';

  @override
  String get wrongCredentials => 'Invalid e-mail address or password. Is it possible that you registered with a different e-mail account?';

  @override
  String get yesPlease => 'Yes, please';

  @override
  String get bluetoothErrorMessage => 'Switch on Bluetooth so you\'re ready to give to a collection.';

  @override
  String get connectionError => 'Currently we\'re not able to connect to the server. No worries, have a cup of tea and/or check your settings.';

  @override
  String get save => 'Save';

  @override
  String get acceptPolicy => 'Ok, Givt is permitted to save my data.';

  @override
  String get close => 'Close';

  @override
  String get sendViaEmail => 'Send by e-mail';

  @override
  String get termsTitle => 'Our Terms of Use';

  @override
  String get shortSummaryTitleTerms => 'It comes down to:';

  @override
  String get fullVersionTitleTerms => 'Terms of Use';

  @override
  String get termsText => 'Terms of use – Givt app \nLast updated: 24-11-2023\nEnglish translation of version 1.10\n\n1. General \nThese terms of use describe the conditions under which the mobile application Givt (\"Givt\") can be utilised. Givt allows the User (anonymously) to give donations through their smartphone, for example churches, fundraising campaigns and charities that are members of Givt. Givt is managed by Givt B.V., a private company, located in Lelystad (8243 PR), Noordersluisweg 27, registered in the trade register of the Chamber of Commerce under number 64534421 (\"Givt B.V.\"). These terms of use apply to the use of Givt. Through the use of Givt (which means the download and the installation thereof), you (\"The user\") accept these terms of use and our privacy policy (www.givtapp.net/privacyverklaringgivt). These terms of use and our privacy policy are also available on our website to download and print. We may revise these terms of use from time to time. \n\n\n2.License and intellectual property rights\n2.1 All rights to Givt, the accompanying documentation and all modifications and extensions thereto as well as the enforcement thereof are and remain the property of Givt B.V. The user is granted solely the rights and authorities and/or permissions ensuing from the effect of this agreement or which are assigned in writing, and you may not otherwise use, reproduce or publicly release Givt. \n\n2.2 Givt B.V. grants the User a non-exclusive, non-sublicensable and non-transmittable license to use Givt. The User is not allowed to use Givt for commercial purposes. \n\n2.3 The User may not provide Givt to third parties nor sell, rent, decompile, submit to reverse engineer or modify it without prior permission from Givt B.V. Nor should the User, or let others, remove or bypass the technical provisions that are intended to protect Givt. \n\n2.4 Givt B.V. has the right to change Givt at any time, modify or remove data, deny the User the use of Givt by termination of the license, limitation of the use of Givt or deny access to Givt in whole or in part, temporarily or permanently. Givt B.V. will inform the User about this in an appropriate manner. \n\n2.5 The User acquires no right, title or interest to the intellectual property rights and/or similar rights to (the means of) Givt, including the underlying software and content.\n\n\n3. The use of Givt \n3.1 The User can only give donations to churches, charities, fundraising campaigns and/or other legal entities that are affiliated with Givt. The donations are done anonymously.\n \n3.2 The use of Givt is at your own risk and expense and should be used in accordance with the purposes for which it is intended. It is prohibited to reverse engineer the source code of Givt or to decompile and/or modify Givt, to make a copy of Givt available to any third party or to remove, delete or render illegible any designations of Givt B.V. as the party holding rights to Givt or parts thereof.\n\n3.3 The User is responsible for the correct submission of data such as name and address details, bank account number and other information as requested by Givt B.V. to ensure the use of Givt. \n\n3.4 If the User is under the age of 18 he/she must have have the consent of their parent or legal guardian in order to use Givt. By accepting these terms of use, the User guarantees that they are 18 years of age or has the permission of their parents or legal representative. \n\n3.5 Givt is available for the operating systems Android and iOS. In addition to the provisions set out below, Apple’s App Store or Google Play may attach conditions to the acquisition of Givt, its use and related matters. For further information, see the terms of use and privacy policy of Apple’s App Store and Google Play as well as any other applicable terms and conditions appearing on the website of the respective provider. This end user licence is applicable to the agreement between the User and Givt B.V. and does not apply between the User and the provider of the platform through which you acquired Givt. That provider may hold you liable for violation of provisions in this end user licence, however. \n\n3.6 After the User has downloaded Givt, the User is requested to register. In doing so, the User must provide the following information: (i) name (ii) address, (iii) phone number, (iv) bank account number and (v) e-mail address. The privacy policy of Givt B.V. is applied to the processing of personal data via Givt. The User must inform Givt immediately if any of this data changes by correcting the information within the app.\n\n3.7 The User may, after installing the Givt app, also choose to only enter an e-mail address and immediately use the app to donate. After the donation, the User will be asked to complete the registration procedure. If the User wishes to do so later, Givt B.V. ensures to only use the User\'s e-mail address to remind the User to finish the registration procedure until this procedure is finalised.\n\n3.8 The User is responsible for any expenses related to the equipment, software system and (internet) connection to make use of Givt.\n\n3.9 Givt B.V. provides the related services based on the information the User submits. The User is obliged to provide correct and complete information, which is not false or misleading. The User may not provide data with respect to names or bank accounts for which the User is not authorised to use. Givt B.V. and the Processor have the right to validate and verify the information the User has provided. \n\n3.10 The User may at any time terminate the use of Givt, by deleting their account via the menu in the app or via mail to support@givt.app. Deleting the app from the smartphone without following aforementioned steps will not result in deletion of the User’s data. Givt can terminate the relationship with the User if the User does not comply with these terms and conditions or if Givt has not been used for 18 consecutive months. On request Givt can send a listing of all donation data. \n\n3.11 Givt B.V. does not charge the User fees for the use of Givt. \n\n3.12 Givt B.V. has the right to adjust the offered functionalities from time to time to improve, to change or to fix errors. Givt B.V. will always work to fix errors within the Givt software, but cannot guarantee that all errors, whether or not in a timely fashion, be restored. \n\n\n4. Processing transactions \n4.1 Givt B.V. is not a bank/financial institution and does not provide banking or payment processor services. To facilitate the processing of donations from the User, Givt B.V. has entered into an agreement with a payment service provider called SlimPay. SlimPay is a financial institution (the \"Processor\") with which it was agreed that Givt B.V. sends the transaction information to the Processor in order to initiate and to handle donations. Givt B.V. will, after the collection of donations, ensure the payment of donations to the user-designated beneficiary. The transaction data will be processed and forwarded to the Givt Processor. The Processor will initiate payment transactions whereas Givt B.V. is responsible for the transaction of the relevant amounts to the bank account of the Church/Foundation as being the user-designated beneficiary of the donation.\n\n4.2 The User agrees that Givt B.V. may pass the User’s (transaction and bank) data to the Processor, along with all other necessary account and personal information of the User, in order to enable the Processor to initiate the payment transactions and processing. Givt B.V. reserves the right to change of Processor at any time. The User agrees that Givt B.V. may forward the relevant information and data about the User as defined in article 3.6 to the new Processor to be able to continue processing payment transactions. \n\n4.3 Givt B.V. and the Processor will process the data of the User in accordance with the law and regulations that applies to data protection. For further information on how personal data is collected, processed and used, Givt B.V. refers the User to its privacy policy. This policy can be found online (www.givtapp.net/en/privacystatementgivt-service/).\n\n4.4 The donations of the User will pass through Givt B.V. as an intermediary. Givt B.V. will ensure that the funds will be transferred to the beneficiary, with whom Givt B.V. has an agreement. \n\n4.5 The User must authorise Givt B.V. and/or the Processor (for automatic SEPA debit) to make a donation with Givt. The User can at all times, within the terms of the User\'s bank, revert a debit. \n\n4.6 Givt B.V. and/or the Processor can refuse a donation if there are reasonable grounds to believe that a user is acting in violation of these terms or if there are reasonable grounds to believe that a donation is possibly suspicious or illegal. In this case Givt B.V. will inform the User as soon as possible, unless prohibited by law. \n\n4.7 Users of the Givt app will not be charged for their donations through our platform. Givt and the receiving party have made separate compensation arrangements pursuant to the agreement in effect between them.\n\n4.8 The User agrees that Givt B.V. (transaction) may pass data of the User to the local tax authorities, along with all other necessary account and personal information of the User, in order to assist the User with his/her annual tax return.   \n\n\n5. Security, theft and loss \n5.1 The User shall take all reasonable precautions safekeeping their login credentials for Givt to avoid loss, theft, misappropriation or unauthorised use of Givt on their smartphone. \n\n5.2 The User is responsible for the security of his/her smartphone. Givt B.V.t considers any donation from the Givt account as a user-approved transaction, regardless of the rights of the User under article 4.5.\n\n5.3 The User shall inform Givt B.V. immediately via info@givt.app or +31 320 320 115 once their smartphone is lost or stolen. Upon receipt of a message Givt B.V. will block the account to prevent (further) misuse. \n\n6. Updates\n6.1 Givt B.V. releases updates from time to time, which can rectify errors or improve the functionality of Givt. Available updates for Givt will be announced by means of notification through Apple’s App Store and Google Play and it is the User’s sole responsibility to monitor these notifications and keep informed about new updates.\n\n6.2 An update can stipulate conditions, which differ from the provisions in this agreement. This will always be notified to the User in advance so that they have the opportunity to refuse the update. By installing such an update, the User agrees to these new conditions, which will then form part of this agreement. If User does not agree to the changed conditions, they have to cease using Givt and have to delete Givt from their device.\n\n7. Liability \n7.1 Givt has been compiled with the utmost care. Although Givt B.V. strives to make Givt available 24 hours a day, it accepts no liability if, for any reason, Givt is not available at any given time or for a certain period of time. Givt B.V. reserves the right to temporarily or permanently discontinue Givt (unannounced). The User cannot derive any rights from this. \n\n7.2 Givt B.V. is not liable for damage or injury resulting from the use of Givt. The limitations of liability as mentioned in this article shall lapse if the liability for damage is the result of intent or gross negligence on the part of Givt B.V.\n\n7.3 The User indemnifies Givt B.V. against any claim from third parties (for example, beneficiaries of the donations or the tax authority) as a result of the use of the Givt or not correctly meeting the agreements made concerning legal or contractual obligations with Givt B.V. The User will pay all damages and costs to Givt B.V. as a result of such claims.\n\n8. Other provisions \n8.1 This agreement comes into effect on commencement of the use of Givt and will remain in force for an undetermined period from that moment. This agreement may be terminated by the User as well as by Givt B.V. at any moment, subject to one month’s notice. This agreement will end by operation of law in the event you are declared bankrupt, you apply for a moratorium on payments or a general attachment is levied against your assets, in the event of your death, or in the event you go into liquidation, are wound up or dissolved. Following the termination of this agreement (for whatever reason), you shall cease and desist from all further use of Givt. You must then delete all copies (including back-up copies) of Givt from all your devices.\n\n8.2 If any provision of these terms and conditions is void or destroyed, this will not affect the validity of the agreement as a whole, and other provisions of these terms remain in force. In that case, the parties will decide on a new replacement provision or provisions which will be in line with the intention of the original agreement as far as is legally possible. \n\n8.3 The User is not allowed to transfer the rights and/or obligations arising from the use of Givt and these terms to third parties without prior written permission of Givt B.V. Conversely, Givt B.V. is allowed to do so. \n\n8.4 Any disputes arising from or in connection with these terms are finally settled in the Court of Lelystad. Before the dispute will be referred to court, we will endeavor to resolve the dispute amicably. \n\n8.5 The Dutch law is applicable on these terms of use. \n\n8.6 The terms of use shall not affect the User\'s statutory rights as a consumer.\n\n8.7 Givt B.V. features an internal complaints procedure. Givt B.V. handles complaints efficiently and as soon as reasonably possible. Any complaint about the implementation of these conditions by Givt B.V. must be submitted in writing at Givt B.V. (via support@givt.app).\n\n';

  @override
  String get prepareMobileTitle => 'Before you start';

  @override
  String get prepareMobileExplained => 'For an optimal experience with Givt, we require your permission in order to send notifications.';

  @override
  String get prepareMobileSummary => 'This way you\'ll know where and when you can give.';

  @override
  String get policyText => 'Privacy Statement of Givt B.V.\n \n\n Translation from original 1.9 (March 3rd 2021)\n \n\n Through its service, Givt will process privacy-sensitive or personal data. Givt B.V. values the privacy of its customers and observes due care in processing and protecting personal data.\n \n\n During the processing we stick to the requirements of the General Data Protection Regulation (EU 2016/679, also known as the GDPR). This means we:\n - Clearly specify our purposes before we process personal data, by using this Privacy Statement;\n - Limit our collection of personal data to only the personal data needed for legitimate purposes;\n - First ask for explicit permission to process your personal data (and data of other individuals in the organisation you represent) in cases where your permission is required;\n - Take appropriate security measures to protect your personal data and we demand the same from parties who process personal data on our behalf;\n - Respect your right to inspect, correct or delete your personal data held by us.\n \n\n Givt B.V. is the party responsible for all data processing. Our data processing is registered with the Dutch Data Protection Authority, number M1640707. In this privacy statement, we will explain which personal data we collect and for which purposes. We recommend that you read it carefully.\n \n\n This privacy statement was last amended on 03-03-2021.\n \n\n Use of Personal Data\n By using our service, you are providing certain data to us. This could be personal data (and data of other individuals in the organisation you represent). We only retain and use the personal data provided directly by you or for which it is clear that it has been supplied to us to be processed.\n We use the following data for the purposes as mentioned in this Privacy Statement:\n - Name and address\n - Telephone number\n - E-mail address\n - Payment details\n \n\n Registration\n Certain features of our service require you to register or the organisation you represent beforehand. After your registration we will retain your user name and the personal data you provided. We will retain this data so that you do not have to re-enter it every time you visit our website, to contact you in connection with the execution of the agreement, invoicing and payment, and to provide an overview of the products and services you have purchased from us.\n We will not provide the data linked to your user name to third parties, unless it is necessary for the execution of the agreement you concluded with us or if law requires this. In the event of suspicion of fraud or misuse of our website we may hand over personal data to the entitled authorities.\n  \n \n\n Promotion\n Other than the advertisements on the website, we can inform you about new products or services:\n - by e-mail\n \n\n Contact Form and Newsletter\n We have a newsletter to inform those interested of our products and/or services. Each newsletter contains a link with which to unsubscribe from our newsletter. Your e-mail address will be added to the list of subscribers automatically.\n If you fill out a contact form on the website or send us an e-mail, the data you provide will be retained for as long as is necessary depending on the nature of the form or the content of your e-mail, to fully answer and correctly handle your message or e-mail.\n \n\n Publication\n We will not publish your data.\n \n\n Providing Data to Third Parties\n We may provide your information to our partners. These partners are involved in the execution of the agreement. In all cases, these parties are necessary to provide the services. Personal data is not shared with other collecting parties, as we protect the anonymity of donors.\n \n\n You agree that the transaction data are anonymous and can be used for data collection, statistics, reviews and comparisons. Only the summary will be shared with other customers and we ensure you that none of your data will be traceable to individuals.\n We will also never sell data to third parties. We are only committed to make it easier for the donor to give to charities of their choosing. \n \n\n Security\n We take security measures to reduce misuse of and unauthorized access to personal data. We take the following measures in particular:\n - Access to personal data requires the use of a username and password\n - Access to personal data requires the use of a username and login token\n - We make use of secure connections (Secure Sockets Layer of SSL) to encrypt all information between you and our website when entering your personal data.\n - We keep logs of all requests for personal data.\n \n\n Use of location services\n The app may use the location services as provided by the operating system on the smartphone. With these services, the app may determine the location of the user. These location data are not being sent to anywhere outside the smartphone, but solely used to determine whether the user is on a location where it’s possible to use Givt for donating. The locations where one can use Givt are downloaded to the smartphone prior to using the location services.\n \n\n Diagnostic information from the app\n The app sends anonymous information about its functioning. This information contains non-personal data from your smartphone like its type and operating system, but also the version information of the app. These data are solely used for purposes of improving the service of Givt or allowing better responses to your questions. This information will never be shared with third-parties. \n \n\n Changes to this Privacy Statement\n We reserve the right to modify this statement. We recommend that you review this statement regularly, so that you remain informed of any changes.\n \n\n Inspection and Modification of your Data\n You can always contact us if you have any questions regarding our privacy policy or wish to review, modify or delete your personal data.\n \n\n Givt B.V. \n Bongerd 159\n 8212 BJ LELYSTAD\n 0031 320 320 115\n KVKnr: 64534421';

  @override
  String get needHelpTitle => 'Need help?';

  @override
  String get findAnswersToYourQuestions => 'Here you\'ll find answers to your questions and useful tips';

  @override
  String get questionHowDoesRegisteringWorks => 'How does registration work?';

  @override
  String get questionWhyAreMyDataStored => 'Why does Givt store my personal information?';

  @override
  String get faQvraag1 => 'What is Givt?';

  @override
  String get faQvraag2 => 'How does Givt work?';

  @override
  String get faQvraag3 => 'How can I change my settings or personal information?';

  @override
  String get faQvraag4 => 'Where can I use Givt?';

  @override
  String get faQvraag5 => 'How will my donation be withdrawn?';

  @override
  String get faQvraag6 => 'What are the possibilities using Givt?';

  @override
  String get faQvraag7 => 'How safe is donating with Givt?';

  @override
  String get faQvraag8 => 'How can I delete my Givt account?';

  @override
  String get faQantwoord1 => 'Donating with your smartphone\n Givt is the solution for giving with your smartphone when you are not carrying cash. Everyone owns a smartphone and with the Givt app you can easily participate in the offering. \n It’s a personal and conscious moment, as we believe that making a donation is not just a financial transaction. Using Givt feels as natural as giving cash. \n \n\n Why \'Givt\'?\n The name Givt was chosen because it is about ‘giving’ as well as giving a ‘gift’. We were looking for a modern and compact name that looks friendly and playful. In our logo you might notice that the green bar combined with the letter ‘v’ forms the shape of an offering bag, which gives an idea of the function. \n \n\n The Netherlands, Belgium and the United Kingdom\n There is a team of specialists behind Givt, divided over the Netherlands, Belgium and the United Kingdom. Each one of us is actively working on the development and improvement of Givt. Read more about us on www.givtapp.net.';

  @override
  String get faQantwoord2 => 'The first step was installing the app. For Givt to work effectively, it’s important that you enable Bluetooth and have a working internet connection. \n \n\n Then register yourself by filling in your information and signing a mandate. \n You’re ready to give! Open the app, select an amount, and scan a QR code, move your phone towards the collection bag or basket, or select a cause from the list.\n Your chosen amount will be saved, withdrawn from your account and distributed to the church or collecting charities.\n \n\n If you don’t have an internet connection when making your donation, the donation will be sent at a later time when you re-open the app. Like when you are in a WiFi zone.';

  @override
  String get faQantwoord3 => 'You can access the app menu by tapping the menu at the top left of the ‘Amount’ screen. To change your settings, you have to log in using your e-mail address and password, fingerprint/Touch ID or a FaceID. In the menu you can find an overview of your donations, adjust your maximum amount, review and/or change your personal information, change your amount presets, fingerprint/Touch ID or FaceID, or terminate your Givt account.';

  @override
  String get faQantwoord4 => 'More and more organisations\n You can use Givt in all organisations that are registered with us. More organisations are joining every week.\n \n\n Not registered yet? \n If your organisation is not affiliated with Givt yet, please contact us at +44 2037 908068 or info@givt.app .';

  @override
  String get faQantwoord5 => 'SlimPay\n When installing Givt, the user gives the app authorisation to debit their account. The transactions are handled by Slimpay – a bank that specialises in processing mandates.\n \n\n Revocable afterwards\n No transactions take place in the moment of giving. The transactions take place afterwards via a direct debit. Since these transactions are revocable, it is completely safe and immune to fraud.';

  @override
  String get faQantwoord6 => 'Continues to develop\n Givt continues to develop their service. Right now you can easily give during the offering using your smartphone, but it doesn\'t stop there. Curious to see what we are working on? Join us for one of our Friday afternoon demos.\n \n\n Tax return\n At the end of the year you can request an overview of all your donations, which makes it easier for you when it comes to tax declaration. Eventually we would like to see that all donations are automatically filled in on the declaration.';

  @override
  String get faQantwoord7 => 'Safe and risk free \n It is very important to us that everything is safe and risk free. Each user has a personal account with its own password. You need to login to view or change your settings.\n \n\n Handling transactions \n The transactions are handled by Slimpay – a bank that specialises in processing mandates. SlimPay is under the supervision of several national banks in Europe, including the Dutch Central Bank (DNB).\n \n\n Immune to fraud \n When installing Givt, the user gives the app authorisation to debit their account.\n We want to emphasise that no transactions take place in the moment of giving. The transactions take place afterwards via a direct debit. Since these transactions are revocable, it is completely safe and immune to fraud. \n \n\n Overview \n Organisations can login to the Givt dashboard. This dashboard gives an overview of all financial transactions, from the moment of giving up to the full processing of the payment. In this way any collection can be followed from start to finish.\n Organisations can see how many people used Givt, but not who they are.';

  @override
  String get faQantwoord8 => 'We are sorry to hear that! We would like to hear why.\n \n\n If you no longer want to use Givt, you can unsubscribe for all Givt services.\n To unsubscribe, go to your settings via the user menu and choose ‘Terminate my account’.';

  @override
  String get privacyTitle => 'Privacy Statement';

  @override
  String get acceptTerms => 'By continuing you agree to our terms and conditions.';

  @override
  String get mandateSigingFailed => 'The mandate has not been signed successfully. Try again later via the menu. Does this alert keep appearing? Feel free to contact us at support@givtapp.net.';

  @override
  String get awaitingMandateStatus => 'We just need a moment to process your mandate.';

  @override
  String get requestMandateFailed => 'At the moment it is not possible to request a mandate. Please try again in a few minutes.';

  @override
  String get faqHowDoesGivingWork => 'How can I give?';

  @override
  String get faqHowDoesManualGivingWork => 'How can I select the recipient?';

  @override
  String givtNotEnough(Object value0) {
    return 'Sorry, but the minimum amount we can work with is $value0.';
  }

  @override
  String get slimPayInformationPart2 => 'That\'s why we ask you this one time to sign a SEPA eMandate.\n \n\n Since we\'re working with mandates, you have the option to revoke your donation if you should wish to do so.';

  @override
  String get unregister => 'Terminate account';

  @override
  String get unregisterInfo => 'We’re sad to see you go! We will delete all your personal information.\n \n\n There’s one exception: if you donated to a PBO-registered organisation, we are obligated to keep the information about your donation, your name and address for at least 7 years. Your e-mail address and phone number will be removed.';

  @override
  String get unregisterSad => 'We\'re sad to see you leave\n and we hope to see you again.';

  @override
  String get historyTitle => 'Donations history';

  @override
  String get historyInfoTitle => 'Donation details';

  @override
  String get historyAmountAccepted => 'In process';

  @override
  String get historyAmountCancelled => 'Cancelled by user';

  @override
  String get historyAmountDenied => 'Refused by bank';

  @override
  String get historyAmountCollected => 'Processed';

  @override
  String get loginSuccess => 'Have fun giving!';

  @override
  String get historyIsEmpty => 'This is where you\'ll find information about your donations, but first you\'ll need to start giving';

  @override
  String get errorEmailTooLong => 'Sorry, your e-mail address is too long.';

  @override
  String get updateAlertTitle => 'Update available';

  @override
  String get updateAlertMessage => 'A new version of Givt is available, do you want to update now?';

  @override
  String get criticalUpdateTitle => 'Critical update';

  @override
  String get criticalUpdateMessage => 'A new critical update is available. This is necessary for the proper functioning of the Givt app.';

  @override
  String organisationProposalMessage(Object value0) {
    return 'Do you want to give to $value0?';
  }

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get faQvraag9 => 'Where can I see the overview of my donations?';

  @override
  String get faQantwoord9 => 'Press the menu at the top left of the ‘Amount’ screen to access your app menu. To get access you have to login using your e-mail address and password. Choose ‘Donations history’ to find an overview of your recent activity. This list consists of the name of the recipient, time, and date. The coloured line indicates the status of the donation: In process, processed, refused by bank, or cancelled by user.\n You can request an overview of your donations for your tax declaration at the end of each year.';

  @override
  String get faqQuestion11 => 'How do I set my Touch ID or Face ID?';

  @override
  String get faqAnswer11 => 'Go to your settings by pressing menu in the top left of the screen. There you can protect your Givt app with a fingerprint/Touch ID or a FaceID (only available on certain iPhones). \n \n\n When one of these settings is activated, you can use it to access your settings instead of using your e-mail address and password.';

  @override
  String get answerHowDoesRegistrationWork => 'To use Givt, you have to register in the Givt app. Go to your app menu and choose \'Finish registration\'. You set up a Givt account, fill in some personal details and give permission to collect the donations made with the app. The transactions are handled by Slimpay - a bank that specialises in the treatment of permissions. When your registration is complete, you are ready to give. You only need your login details to see or change your settings.';

  @override
  String get answerHowDoesGivingWork => 'From now on, you can give with ease. Open the app, choose the amount you want to give, and select 1 of the 4 possibilities: you can give to a collection device, scan a QR code, choose from a list, or give at your location. \n Don\'t forget to finish your registration, so your donations can be delivered to the right charity.';

  @override
  String get answerHowDoesManualGivingWork => 'When you aren’t able to give to a collection device, you can choose to select the recipient manually. Choose an amount and press ‘Next’. Next, select ‘Choose from the list’ and select \'Churches\', \'Charities\', \'Campaigns\' or \'Artists\'. Now choose a recipient from one of these lists and press ‘Give’.';

  @override
  String get informationPersonalData => 'Givt needs this personal data to process your gifts. We are careful with this information. You can read it in our privacy statement.';

  @override
  String get informationAboutUs => 'Givt is a product of Givt B.V.\n \n\n We are located on the Bongerd 159 in Lelystad, The Netherlands. For questions or complaints you can reach us via +31 320 320 115 or support@givtapp.net.\n \n\n We are registered in the trade register of the Dutch Chamber of Commerce under number 64534421.';

  @override
  String get titleAboutGivt => 'About Givt / Contact';

  @override
  String get sendAnnualReview => 'Send annual review';

  @override
  String get infoAnnualReview => 'Here you can receive the annual review of your donations over 2016.\n The annual review can be used for your tax declaration.';

  @override
  String get sendByEmail => 'Send by e-mail';

  @override
  String get whyPersonalData => 'Why this personal data?';

  @override
  String get readPrivacy => 'Read privacy statement';

  @override
  String get faqQuestion12 => 'How long does it take before my donation is withdrawn from my bank account?';

  @override
  String get faqAnswer12 => 'Your donation will be withdrawn from your bank account within two working days.';

  @override
  String get faqQuestion14 => 'How can I give to multiple collections?';

  @override
  String get faqAnswer14 => 'Are there multiple collections in one service? Even then you can easily give in one move!\n By pressing the ‘Add collection’-button, you can activate up to three collections. For each collection, you can enter your own amount. Choose your collection you want to adjust and enter your specific amount or use the presets. You can delete a collection by pressing the minus sign, located to the right of the amount.\n \n\n The numbers 1, 2 or 3 distinguish the different collections. No worries, your church knows which number corresponds to which collection purpose. Multiple collections are very handy, because all your gifts are sent immediately with your first donation. In the overview you can see a breakdown of all your donations.\n \n\n Do you want to skip a collection? Leave it open or remove it.';

  @override
  String get featureMultipleCollections => 'News! Now you can help three different collections in one go. Are you feeling the pinch this month? Just leave a collection open or remove it. Want to know more? Check our FAQ.';

  @override
  String get featureIGetItButton => 'Always good to give';

  @override
  String get ballonActiveerCollecte => 'Here you can add up to three collections';

  @override
  String get ballonVerwijderCollecte => 'A collection can be removed by tapping fast twice';

  @override
  String get needEmailToGive => 'We need some identification to allow you to give with Givt';

  @override
  String get giveFirst => 'Give first';

  @override
  String get go => 'Go';

  @override
  String get faQvraag15 => 'Are my Givt donations tax deductible?';

  @override
  String get faQantwoord15 => 'Yes, your Givt donations are tax deductible, but only when you’re giving to institutions that are registered as ANBI (Public Benefit Organisation) or SBBI (Social Importance Organisation). Check if the church or institution has such a registration. Since it’s quite a bit of work to gather all your donations for your tax declaration, the Givt app offers you the option to annually download an overview of your donations. Go to your Donations in the app-menu to download the overview. You can use this overview for your tax declaration. It’s a piece of cake.';

  @override
  String get giveDiffWalkthrough => 'Having some trouble? Tap here to pick an organisation from the list.';

  @override
  String get faQvraag17 => 'Can\'t find your question here?';

  @override
  String get faQantwoord17 => 'Send us a message from within the app (\"About Givt / Contact\"), an e-mail at support@givtapp.net or give us a call at +31 320 320 115.';

  @override
  String get noCameraAccessCelebration => 'To be able to support the giving event, we need access to your camera.';

  @override
  String get yesCool => 'Yes, cool!';

  @override
  String get faQvraag18 => 'How does Givt handle my personal information? (GDPR)';

  @override
  String get faqAntwoord18 => 'Givt fully complies with the GDPR requirements. GDPR stands for General Data Protection Regulation.\n \n\n Wondering what this means for you? It means that we handle your information with care, that you have the right to know which information we keep on record, have the right to change this information, have the right to demand from us that we do not store your information, and that you may know why we need your personal information.\n \n\n Why we need your personal data:\n Address information: We need your address information in order to create the mandate. The mandate is not valid without this information and you cannot complete your registration without it. The required data are determined by law. Mobile number: We use your mobile number to contact you if there is an issue with your donation. Payment details: We need your payment information to debit the donations you make. E-mail address: We use your e-mail address to create your Givt account. You can use your e-mail address and password to log in.\n \n\n If you would like to know more, please read our privacy statement.';

  @override
  String get fingerprintCancel => 'Cancel';

  @override
  String get faQuestAnonymity => 'How is my anonymity guaranteed by Givt?';

  @override
  String get faQanswerAnonymity => 'Givt ensures that the receiving party will never be able to see who has given the donation and that you, as a user, can give anonymously with Givt. Only the total amounts will be shared with the receiving party. Data from you as a user will never be resold to third parties, it is only used to make it easier for you to give and to be involved in the charities in a way that you prefer.\n \n\n Do you want to read more about this? Then read our privacy statement (scroll down to the last question at the bottom of this FAQ).';

  @override
  String get amountPresetsChangingPresets => 'You can add amount presets to your keyboard. This is where you can enable and set the amount presets.';

  @override
  String get amountPresetsChangePresetsMenu => 'Change amount presets';

  @override
  String get featureNewguiInappnot => 'Tap here to read more about the renewed user interface!';

  @override
  String get givtCompanyInfo => 'Givt is a product of Givt B.V.\n You can find us on Bongerd 159 in Lelystad, the Netherlands.\n For questions or complaints you can reach us via +31 320 320 115 or support@givtapp.net.\n \n\n We are registered with the chamber of commerce under KVK: 64534421.';

  @override
  String get givtCompanyInfoGb => 'Givt is a product of Givt Ltd.\n Our office is located on Bongerd 159 in Lelystad, the Netherlands. \n For questions or complaints you can reach us via support@givt.co.uk\n \n\n We are registered under Company Number (CRN): 11396586.';

  @override
  String get celebrationHappyToSeeYou => 'Let\'s celebrate your Givt together!';

  @override
  String get celebrationQueueText => 'Just leave the app open and wait for the countdown to start.';

  @override
  String get celebrationQueueCancel => 'Give without participating';

  @override
  String get celebrationEnablePushNotification => 'Activate push notifications';

  @override
  String get faqButtonAccessibilityLabel => 'Frequently asked questions';

  @override
  String get progressBarStepOne => 'Step 1';

  @override
  String get progressBarStepTwo => 'Step 2';

  @override
  String get progressBarStepThree => 'Step 3';

  @override
  String removeCollectButtonAccessibilityLabel(Object value0) {
    return 'Remove the $value0';
  }

  @override
  String get removeBtnAccessabilityLabel => 'Erase';

  @override
  String get progressBarStepFour => 'Stap 3';

  @override
  String get changeBankAccountNumberAndSortCode => 'Change bank details';

  @override
  String get updateBacsAccountDetailsError => 'Alas, the Sortcode or Account number is invalid. You can change the Sortcode and/or Account number under ‘Personal information’ in the menu.';

  @override
  String get ddiFailedTitle => 'DDI request failed';

  @override
  String get ddiFailedMessage => 'At the moment it is not possible to request a Direct Debit Instruction. Please try again in a few minutes.';

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
  String get giftAidSetting => 'I want to use/keep using Gift Aid';

  @override
  String get giftAidInfo => 'As a UK taxpayer, you can use the Gift Aid initiative. Every year we will remind you of your choice. Activating Gift Aid after March 1st will count towards March and the next tax year. All your donations made before entering your account details will be considered eligible if they were made in the current tax year.';

  @override
  String get giftAidHeaderDisclaimer => 'When you enable this option, you agree to the following:';

  @override
  String get giftAidBodyDisclaimer => 'I am a UK taxpayer and understand that if I pay less Income Tax and/or Capital Gains Tax in the current tax year than the amount of Gift Aid claimed on all my donations, it is my responsibility to pay any difference.';

  @override
  String get giftAidInfoTitle => 'What is Gift Aid?';

  @override
  String get giftAidInfoBody => 'Donating through Gift Aid means charities can claim an extra 25p for every £1 you give. It will not cost you any extra. \n \n\n Gift Aid treats the donations as being made after deduction of income tax at the basic rate. The charity you give to can reclaim this basic rate income tax paid on the gift from HMRC. Your donations will qualify as long as they’re not more than 4 times what you have paid in tax in that tax year. \n  \n For more info, please go to: www.gov.uk/donating-to-charity/gift-aid';

  @override
  String get faqAnswer12Gb => 'Your donation will be withdrawn from your bank account within five working days. The first time you make a donation with Givt, the donation will be withdrawn after two weeks, as it takes extra time to set up your registration.';

  @override
  String get faqVraagDdi => 'Does the Direct Debit mean I signed up to monthly deductions?';

  @override
  String get faqAntwoordDdi => 'NO! You sign a direct debit so we can deduct the donations you have made using the Givt app. The deductions we make are incidental, user-driven deductions.\n \n\n We will not debit your account unless you make a donation using the Givt app.';

  @override
  String get giftAidUnsavedChanges => 'You have unsaved changes, do you want to go back to save the changes or dismiss these changes?';

  @override
  String get giftAidChangeLater => 'Later on, you can change this option in the menu under \'Personal Info\'.';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get importantMessage => 'Important mention';

  @override
  String get celebrationQueueCancelAlertBody => 'Are you sure you don\'t want to celebrate with us?';

  @override
  String get celebrationQueueCancelAlertTitle => 'Too bad!';

  @override
  String get historyInfoLegendaAccessibilityLabel => 'Info explanation';

  @override
  String get historyDownloadAnnualOverviewAccessibilityLabel => 'Download annual overview of donations (mail)';

  @override
  String get bluetoothErrorMessageEvent => 'With Bluetooth, you can find your location even with no/poor GPS connection, thanks to location-beacons. \n Activate your Bluetooth now!';

  @override
  String get processCashedGivtNamespaceInvalid => 'We see that you have made a non-processed gift to an organisation that, sadly, doesn\'t use Givt anymore. This gift will be deleted.';

  @override
  String get suggestionNamespaceInvalid => 'Your last selected cause doesn\'t support Givt anymore.';

  @override
  String get charity => 'Charity';

  @override
  String get artist => 'Artist';

  @override
  String get church => 'Church';

  @override
  String get campaign => 'Campaign';

  @override
  String get giveYetDifferently => 'Choose from the list';

  @override
  String giveToNearestBeacon(Object value0) {
    return 'Give to: $value0';
  }

  @override
  String get jersey => 'Jersey';

  @override
  String get guernsey => 'Guernsey';

  @override
  String get countryStringBe => 'Belgium';

  @override
  String get countryStringNl => 'Netherlands';

  @override
  String get countryStringDe => 'Germany';

  @override
  String get countryStringGb => 'United Kingdom';

  @override
  String get countryStringFr => 'France';

  @override
  String get countryStringIt => 'Italy';

  @override
  String get countryStringLu => 'Luxembourg';

  @override
  String get countryStringGr => 'Greece';

  @override
  String get countryStringPt => 'Portugal';

  @override
  String get countryStringEs => 'Spain';

  @override
  String get countryStringFi => 'Finland';

  @override
  String get countryStringAt => 'Austria';

  @override
  String get countryStringCy => 'Cyprus';

  @override
  String get countryStringEe => 'Estonia';

  @override
  String get countryStringLv => 'Latvia';

  @override
  String get countryStringLt => 'Lithuania';

  @override
  String get countryStringMt => 'Malta';

  @override
  String get countryStringSi => 'Slovenia';

  @override
  String get countryStringSk => 'Slovakia';

  @override
  String get countryStringIe => 'Ireland';

  @override
  String get countryStringAd => 'Andorra';

  @override
  String get errorChangePostalCode => 'You\'ve entered a post code that is unknown. Please change it under \"Personal information\" in the menu.';

  @override
  String get informationAboutUsGb => 'Givt is a product of Givt LTD.\n \n\n We are located at the Blackthorn House in Birmingham, England. For questions or complaints you can reach us via 020 3790 8068 or support@givt.co.uk\n \n\n We are registered under the Company Registration Number 11396586.';

  @override
  String get bluetoothErrorMessageAction => 'On it';

  @override
  String get bluetoothErrorMessageCancel => 'Rather not';

  @override
  String get authoriseBluetooth => 'Authorise Givt to use Bluetooth';

  @override
  String get authoriseBluetoothErrorMessage => 'Give Givt permission to access your Bluetooth so you\'re ready to give to a collection.';

  @override
  String get authoriseBluetoothExtraText => 'Go to Settings > Privacy > Bluetooth and select \'Givt\'.';

  @override
  String get unregisterError => 'Alas, we are unable to unregister your account. Could you try again later?';

  @override
  String get unregisterMandateError => 'Alas, we are unable to unregister your account because we are unable to cancel your mandate or direct debit instruction. Please contact us.';

  @override
  String get unregisterErrorTitle => 'Terminate failed';

  @override
  String get setupRecurringGiftTitle => 'Set up your recurring donation';

  @override
  String get setupRecurringGiftText3 => 'from';

  @override
  String get setupRecurringGiftText4 => 'until';

  @override
  String get setupRecurringGiftText5 => 'or';

  @override
  String get add => 'Add';

  @override
  String get subMenuItemFirstDestinationThenAmount => 'One-off donation';

  @override
  String get faqQuestionFirstTargetThenAmount1 => 'What is \"Give to a good cause\"?';

  @override
  String get faqAnswerFirstTargetThenAmount1 => '\"Give to a good cause\" is a new functionality in your Givt-app. It works exactly as you are used with us, but now you first choose the good cause and then the amount. Handy!';

  @override
  String get faqQuestionFirstTargetThenAmount2 => 'Why can I only choose a good cause from the list?';

  @override
  String get faqAnswerFirstTargetThenAmount2 => '\"Giving to a good cause\" is brand new and still under construction. New functionalities are continuous being added in time.';

  @override
  String get setupRecurringGiftText2 => 'to';

  @override
  String get setupRecurringGiftText1 => 'I want to give every';

  @override
  String get setupRecurringGiftWeek => 'week';

  @override
  String get setupRecurringGiftMonth => 'month';

  @override
  String get setupRecurringGiftQuarter => 'quarter';

  @override
  String get setupRecurringGiftYear => 'year';

  @override
  String get setupRecurringGiftWeekPlural => 'weeks';

  @override
  String get setupRecurringGiftMonthPlural => 'months';

  @override
  String get setupRecurringGiftQuarterPlural => 'quarters';

  @override
  String get setupRecurringGiftYearPlural => 'years';

  @override
  String get menuItemRecurringDonation => 'Recurring donations';

  @override
  String get setupRecurringGiftHalfYear => 'half year';

  @override
  String get setupRecurringGiftText6 => 'times';

  @override
  String get loginAndTryAgain => 'Please log in and try again.';

  @override
  String givtIsBeingProcessedRecurring(Object value0, Object value1, Object value2, Object value3, Object value4) {
    return 'Thank you for your Givt(s) to $value0!\n You can check the overview of your recurring donations under \'Overview\'.\n The first recurring donation of $value1 $value2 will be initiated on $value3.\n After that it will be withdrawn each $value4.';
  }

  @override
  String get overviewRecurringDonations => 'Recurring donations';

  @override
  String get titleRecurringGifts => 'Recurring donations';

  @override
  String get recurringGiftsSetupCreate => 'Schedule your';

  @override
  String get recurringGiftsSetupRecurringGift => 'recurring donation';

  @override
  String get recurringDonationYouGive => 'you give';

  @override
  String recurringDonationStops(Object value0) {
    return 'This will stop on $value0';
  }

  @override
  String get selectRecipient => 'Select recipient';

  @override
  String get setupRecurringDonationFailed => 'The recurring donation was not set up successfully. Please try again later.';

  @override
  String get emptyRecurringDonationList => 'All your recurring donations will be visible here.';

  @override
  String cancelRecurringDonationAlertTitle(Object value0) {
    return 'Are you sure you want to stop donating to $value0?';
  }

  @override
  String get cancelRecurringDonationAlertMessage => 'The donations already made will not be cancelled.';

  @override
  String get cancelRecurringDonation => 'Stop';

  @override
  String get setupRecurringGiftText7 => 'Each';

  @override
  String get cancelRecurringDonationFailed => 'The recurring donation was not cancelled successfully. Please try again later.';

  @override
  String get pushnotificationRequestScreenTitle => 'Push notifications';

  @override
  String get pushnotificationRequestScreenDescription => 'We would like to keep you posted on when the next donation will be collected from your account. At the moment we don\'t have permission to send you messages. Could you change that setting, please?';

  @override
  String get pushnotificationRequestScreenButtonYes => 'Yes, I will change my settings';

  @override
  String get reportMissingOrganisationListItem => 'Report a missing organisation';

  @override
  String get reportMissingOrganisationPrefilledText => 'Hi! I would really like to give to:';

  @override
  String get featureRecurringDonations1Title => 'Plan your recurring donations to charities';

  @override
  String get featureRecurringDonations2Title => 'You\'re in control';

  @override
  String get featureRecurringDonations3Title => 'Overview';

  @override
  String get featureRecurringDonations1Description => 'You can now plan your recurring donations, with the end date already selected.';

  @override
  String get featureRecurringDonations2Description => 'You can see all the recurring donations you have planned and stop them whenever you want.';

  @override
  String get featureRecurringDonations3Description => 'All your one off and recurring donations in one overview. Useful for yourself and for tax purposes.';

  @override
  String get featureRecurringDonations3Button => 'Show me!';

  @override
  String get featureRecurringDonationsNotification => 'Hi! Would you also like to set up a recurring donation with this app? Take a quick look at what we have built.';

  @override
  String get setupRecurringDonationFailedDuplicate => 'The recurring donation was not set up successfully. You have already made a donation to this organisation with the same repeating period.';

  @override
  String get setupRecurringDonationFailedDuplicateTitle => 'Duplicate donation';

  @override
  String get goToListWithRecurringDonationDonations => 'Overview';

  @override
  String get recurringDonationsEmptyDetailOverview => 'This is where you\'ll find information about your donations, but the first donation still has to be collected';

  @override
  String get recurringDonationFutureDetailSameYear => 'Upcoming donation';

  @override
  String get recurringDonationFutureDetailDifferentYear => 'Upcoming donation in';

  @override
  String get pushnotificationRequestScreenPrimaryDescription => 'We would like to keep you posted on when the next donation will be collected from your account. At the moment we don\'t have permission to send you messages. Could you allow that, please?';

  @override
  String get pushnotificationRequestScreenPrimaryButtonYes => 'Ok, fine!';

  @override
  String get discoverSearchButton => 'Search';

  @override
  String get discoverDiscoverButton => 'See all';

  @override
  String get discoverSegmentNow => 'Give';

  @override
  String get discoverSegmentWho => 'Discover';

  @override
  String get discoverHomeDiscoverTitle => 'Choose category';

  @override
  String get discoverOrAmountActionSheetOnce => 'One-off donation';

  @override
  String get discoverOrAmountActionSheetRecurring => 'Recurring donation';

  @override
  String reccurringGivtIsBeingProcessed(Object value0) {
    return 'Thank you for your recurring donation to $value0!\n To see all the information, go to \'Recurring donations\' in the menu.';
  }

  @override
  String get setupRecurringGiftTextPlaceholderDate => 'dd / mm / yy';

  @override
  String get setupRecurringGiftTextPlaceholderTimes => 'x';

  @override
  String get amountLimitExceededRecurringDonation => 'This amount is higher than your chosen maximum amount. Do you want to continue or change the amount?';

  @override
  String get appStoreRestart => '';

  @override
  String sepaVerifyBodyDetails(Object value0, Object value1, Object value2, Object value3) {
    return 'Name: $value0\n Address: $value1\n E-mail address: $value2\n IBAN: $value3\n We only use the eMandate when you use the Givt app to make a donation';
  }

  @override
  String get sepaVerifyBody => 'If any of the above is incorrect, please abort the registration and change your \'Personal information\'';

  @override
  String get signMandate => 'Sign mandate';

  @override
  String get signMandateDisclaimer => 'By continuing you sign the eMandate with above details.\n The mandate will be sent to you via mail.';

  @override
  String get budgetSummaryBalance => 'My giving this month';

  @override
  String get budgetSummarySetGoal => 'Set a giving goal to motivate yourself.';

  @override
  String get budgetSummaryGiveNow => 'Give now!';

  @override
  String get budgetSummaryGivt => 'Given within Givt';

  @override
  String get budgetSummaryNotGivt => 'Given outside Givt';

  @override
  String get budgetSummaryShowAll => 'Show all';

  @override
  String get budgetSummaryMonth => 'Monthly';

  @override
  String get budgetSummaryYear => 'Annually';

  @override
  String get budgetExternalGiftsTitle => 'Giving outside Givt';

  @override
  String get budgetExternalGiftsInfo => 'Get a complete overview of all of your contributions. Add any contributions that you have made outside of Givt. You will find everything in your summary.';

  @override
  String get budgetExternalGiftsSubTitle => 'Your donations outside Givt';

  @override
  String get budgetExternalGiftsOrg => 'Name of organisation';

  @override
  String get budgetExternalGiftsTime => 'Frequency';

  @override
  String get budgetExternalGiftsAmount => 'Amount';

  @override
  String get budgetExternalGiftsAdd => 'Add';

  @override
  String get budgetExternalGiftsSave => 'Save';

  @override
  String get budgetGivingGoalTitle => 'Setup giving goal';

  @override
  String get budgetGivingGoalInfo => 'Give consciously. Consider each month whether your giving behaviour matches your personal giving goals.';

  @override
  String get budgetGivingGoalMine => 'My giving goal';

  @override
  String get budgetGivingGoalTime => 'Period';

  @override
  String get budgetSummaryGivingGoalMonth => 'Monthly giving goal';

  @override
  String get budgetSummaryGivingGoalEdit => 'Edit giving goal';

  @override
  String get budgetSummaryGivingGoalRest => 'Remaining giving goal';

  @override
  String get budgetSummaryGivingGoal => 'Giving goal:';

  @override
  String get budgetMenuView => 'My personal summary';

  @override
  String get budgetSummarySetGoalBold => 'Give consciously';

  @override
  String get budgetExternalGiftsInfoBold => 'Gain insight into what you give';

  @override
  String get budgetGivingGoalInfoBold => 'Set giving goal';

  @override
  String get budgetGivingGoalRemove => 'Remove giving goal';

  @override
  String get budgetSummaryNoGifts => 'You have no donations (yet) this month';

  @override
  String get budgetTestimonialSummary => '”Since I’ve been using the summary, I have gained more insight into what I give. I give more consciously because of it.\"';

  @override
  String get budgetTestimonialGivingGoal => '”My giving goal motivates me to regularly reflect on my giving behaviour.”';

  @override
  String get budgetTestimonialExternalGifts => '\"I like that I can add any external donations to my summary. I can now simply keep track of my giving.\"';

  @override
  String get budgetTestimonialYearlyOverview => '\"Givt\'s annual overview is great! I\'ve also added all my donations outside Givt. This way I have all my giving in one overview, which is essential for my tax return.\"';

  @override
  String get budgetPushMonthly => 'See what you have given this month.';

  @override
  String get budgetPushYearly => 'View your annual overview and see what you have given so far.';

  @override
  String get budgetTooltipGivingGoal => 'Give consciously. Consider each month whether your giving behaviour matches your personal giving goals.';

  @override
  String get budgetTooltipExternalGifts => 'Add what you\'re donating outside of Givt. Everything will appear in your summary. With all your donations included you\'ll get the best insight.';

  @override
  String get budgetTooltipYearly => 'One overview for the tax return? View the overview of all your donations here.';

  @override
  String get budgetPushMonthlyBold => 'Your monthly summary is ready.';

  @override
  String get budgetPushYearlyBold => '2021 is almost over ... Have you made up your balance?';

  @override
  String get budgetExternalGiftsListAddEditButton => 'Manage external donations';

  @override
  String get budgetExternalGiftsFrequencyOnce => 'Once';

  @override
  String get budgetExternalGiftsFrequencyMonthly => 'Every month';

  @override
  String get budgetExternalGiftsFrequencyQuarterly => 'Every 3 months';

  @override
  String get budgetExternalGiftsFrequencyHalfYearly => 'Every 6 months';

  @override
  String get budgetExternalGiftsFrequencyYearly => 'Every year';

  @override
  String get budgetExternalGiftsEdit => 'Edit';

  @override
  String get budgetTestimonialSummaryName => 'Willem:';

  @override
  String get budgetTestimonialGivingGoalName => 'Danielle:';

  @override
  String get budgetTestimonialExternalGiftsName => 'Johnson:';

  @override
  String get budgetTestimonialYearlyOverviewName => 'Jonathan:';

  @override
  String get budgetTestimonialSummaryAction => 'View your summary';

  @override
  String get budgetTestimonialGivingGoalAction => 'Setup your giving goal';

  @override
  String get budgetTestimonialExternalGiftsAction => 'Add external donations';

  @override
  String get budgetSummaryGivingGoalReached => 'Giving goal achieved';

  @override
  String get budgetExternalDonationToHighAlertTitle => 'Wow, generous giver?!';

  @override
  String get budgetExternalDonationToHighAlertMessage => 'Hi generous giver, this amount is higher than we expected here. Lower your amount or let us know that we have to change this maximum of 99 999.';

  @override
  String get budgetExternalDonationToLongAlertTitle => 'Too much';

  @override
  String get budgetExternalDonationToLongAlertMessage => 'Hold your horses! This field can only take 30 characters max.';

  @override
  String get budgetSummaryNoGiftsExternal => 'Donations outside Givt this month? Add here';

  @override
  String get budgetYearlyOverviewGivenThroughGivt => 'Total within Givt';

  @override
  String get budgetYearlyOverviewGivenThroughNotGivt => 'Total outside Givt';

  @override
  String get budgetYearlyOverviewGivenTotal => 'Total';

  @override
  String get budgetYearlyOverviewGivenTotalTax => 'Total tax relief';

  @override
  String get budgetYearlyOverviewDetailThroughGivt => 'Within Givt';

  @override
  String get budgetYearlyOverviewDetailAmount => 'Amount';

  @override
  String get budgetYearlyOverviewDetailDeductable => 'Tax relief';

  @override
  String get budgetYearlyOverviewDetailTotal => 'Total';

  @override
  String get budgetYearlyOverviewDetailTotalDeductable => 'Total tax relief';

  @override
  String get budgetYearlyOverviewDetailNotThroughGivt => 'Outside Givt';

  @override
  String get budgetYearlyOverviewDetailTotalThroughGivt => '(within Givt)';

  @override
  String get budgetYearlyOverviewDetailTotalNotThroughGivt => '(outside Givt)';

  @override
  String get budgetYearlyOverviewDetailTipBold => 'TIP: add your external donations';

  @override
  String get budgetYearlyOverviewDetailTipNormal => 'to get a total overview of what you give, both via the Givt app and not via the Givt app.';

  @override
  String get budgetYearlyOverviewDetailReceiveViaMail => 'Receive by e-mail';

  @override
  String get budgetYearlyOverviewDownloadButton => 'Download annual overview';

  @override
  String get budgetExternalDonationsTaxDeductableSwitch => 'Tax relief';

  @override
  String get budgetYearlyOverviewGivingGoalPerYear => 'Annual giving goal';

  @override
  String get budgetYearlyOverviewGivenIn => 'Given in';

  @override
  String get budgetYearlyOverviewRelativeTo => 'Relative to the total in';

  @override
  String get budgetYearlyOverviewVersus => 'Versus';

  @override
  String get budgetYearlyOverviewPerOrganisation => 'Per organisation';

  @override
  String get budgetSummaryNoGiftsYearlyOverview => 'You have no donations (yet) this year';

  @override
  String budgetPushYearlyNearlyEndBold(Object value0) {
    return '$value0 is almost over... Have you made up your balance yet?';
  }

  @override
  String get budgetPushYearlyNearlyEnd => 'View your annual overview and see what you have given so far.';

  @override
  String get budgetPushYearlyNewYearBold => 'Have you made up your balance yet?';

  @override
  String get budgetPushYearlyNewYear => 'View your annual overview and see what you have given in the past year.';

  @override
  String get budgetPushYearlyFinalBold => 'Your annual overview is now ready!';

  @override
  String get budgetPushYearlyFinal => 'View your annual overview and see what you have given in the past year.';

  @override
  String get budgetTestimonialYearlyOverviewAction => 'Go to the overview';

  @override
  String get duplicateAccountOrganisationMessage => 'Are you sure you are using your own bank details? Could you please check in the menu, under \'Personal information\'? You can change the information there as well, if necessary.';

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
  String get usRegistrationPersonalDetailsLastnamePlaceholder => 'Last name';

  @override
  String get usRegistrationTaxTitle => 'A few more details for your annual statement.';

  @override
  String get usRegistrationTaxSubtitle => 'Your name and Zip code will only be used to create your statement. By default, you will remain anonymous to the recipient.';

  @override
  String get policyTextUs => 'Latest Amendment: 04-04-2022 \n Version 1.0\n \n\n Givt Inc. Privacy Policy\n \n\n Introduction\n This Privacy Policy outlines Givt Inc.’s (“we,” “our,” or “the Company”) practices with respect to information collected from our Application (“App”) or from users that otherwise share personal information with us (collectively: “Users”). Refer to www.givt.app/terms-of-use/ for the Terms of Use that apply when you use the Givt app.\n \n\n Grounds for data collection\n Processing of your personal information (meaning, any information relating to an identified or identifiable individual; hereinafter “Personal Information”) is necessary for the performance of our contractual obligations towards you and providing you with our services, to protect our legitimate interests and for compliance with legal and financial regulatory obligations to which we are subject.\n When you use our App or register yourself or an organization you represent with us, you consent to the collection, storage, use, disclosure and other uses of your Personal Information as described in this Privacy Policy.\n We encourage our Users to carefully read the Privacy Policy and use it to make informed decisions.\n \n\n What information do we collect?\n We collect two types of data and information from Users.\n The first type of information is un-identified and non-identifiable information pertaining to a User(s), which may be made available or gathered via your use of the App (“Non-personal Information”). We are not aware of the identity of a User from which the Non-personal Information was collected. Non-personal Information which is being collected may include your aggregated usage information and technical information transmitted by your device, including certain software and hardware information (e.g. language preference, access time, etc.) in order to enhance the functionality of our App.\n The second type of information is Personal Information, which is personally identifiable information, namely information that identifies an individual or may with reasonable effort identify an individual. Such information includes:\n ● Device Information: We collect Personal Information from your device. Such information includes geolocation data, IP address, unique identifiers (e.g. MAC address and UUID) and other information which relates to your activity through the App.\n  ● Service User Information: We collect additional information for individuals who would like to use our Services. This is gathered through the App and includes all the information needed to register for our service:\n ● Name and address,\n ● Date of birth,\n ● Email address,\n ● Secured password details, and\n ● Bank details for the purposes of making payments.\n ● Contact information: If you choose to contact us you will be asked to provide us with certain details such as: full name; e-mail or physical address, and other relevant information. This may be for yourself or for people in the organization you represent.\n \n\n How do we receive information about you?\n We receive your Personal Information from various sources:\n ● When you voluntarily provide us with your personal details in order to register on our App;\n ● When you use or access our App in connection with your use of our services;\n When you use or access our Dashboard in connection with your organization’s use of our services;\n ● From third party providers, services and public registers (for example, traffic analytics vendors); and,\n ● Through diagnostic information from the App. The App will send us anonymous information about its functioning. This information contains non-personal data from your smartphone like its type and operating system, but also the version information of the App. This data is solely used for purposes of improving our Service or allowing better responses to your questions.\n \n\n What do we do with the information we collect?\n We may use the information for the following:\n ● To provide the services through the App – we will use a minimum of name and bank details to perform the services of effecting payment(s) via the App. Such information is never shared with intended recipients of donations;\n ● Communicating with you – sending you notices regarding our services, providing you with technical information and responding to any customer service issue you may have; to keep you informed of our latest updates and services;\n ● Conducting statistical and analytical activities, intended to improve the App and/or the App.\n ● For marketing and advertising purposes, such as developing and providing promotional and advertising materials that may be relevant, valuable or otherwise of interest to you.\n In addition to the different uses listed above, we may transfer or disclose Personal Information to our subsidiaries, affiliated companies and subcontractors in relation to services that we provide to you.\n We may also disclose information if we have good faith to believe that disclosure of such information is helpful or reasonably necessary to: (i) comply with any applicable law, regulation, legal process or governmental request; (ii) enforce our policies (including our Agreement), including investigations of potential violations thereof; (iii) investigate, detect, prevent, or take action regarding illegal activities or other wrongdoing, suspected fraud or security issues; (iv) to establish or exercise our rights to defend against legal claims; (v) prevent harm to the rights, property or safety of us, our users, yourself or any third party; or (vi) for the purpose of collaborating with law enforcement agencies and/or in case we find it necessary in order to enforce intellectual property or other legal rights.\n \n\n User Rights\n You may request to:\n 1. Receive confirmation as to whether or not personal information concerning you is being processed, and access your stored personal information, together with supplementary information.\n 2. Receive a copy of personal information you directly volunteer to us in a structured, commonly used and machine-readable format.\n 3. Request rectification of your personal information that is in our control.\n 4. Request erasure of your personal information.\n 5. Object to the processing of personal information by us.\n 6. Request portability of your personal information.\n 7. Request to restrict processing of your personal information by us.\n 8. Lodge a complaint with a supervisory authority.\n However, please note that these rights are not absolute, and may be subject to our own legitimate interests and regulatory requirements. Before fulfilling your request, we may ask you to provide reasonable information to verify your identity.\n \n\n Retention\n We will retain your personal information for as long as necessary to provide our services, and as necessary to comply with our legal obligations, resolve disputes, and enforce our policies. Retention periods will be determined taking into account the type of information that is collected and the purpose for which it is collected, bearing in mind the requirements applicable to the situation and the need to destroy outdated, unused information at the earliest reasonable time. Under applicable regulations, we will keep records containing client personal data, account opening documents, communications and anything else as required by applicable laws and regulations.\n We may rectify, replenish or remove incomplete or inaccurate information, at any time and at our own discretion.\n \n\n Use of Location Services\n The App may use the location services as provided by the operating system on the smartphone. With these services, the App may determine the location of the user. The location data will not be sent anywhere outside the smartphone, and is solely used to determine whether the user is in a location where it’s possible to use the App for donating. The locations where one can use App are downloaded to the smartphone prior to using the location services.\n \n\n How do we safeguard your information?\n We take security measures to reduce misuse of and unauthorized access to personal data. Although we take reasonable steps to safeguard information, we cannot be responsible for the acts of those who gain unauthorized access or abuse our App, and we make no warranty, express, implied or otherwise, that we will prevent such access.\n \n\n Transfer of data outside the EEA\n Please note that some data recipients may be located outside the EEA. In such cases we will transfer your data only to such countries as approved by the European Commission as providing adequate level of data protection, or enter into legal agreements ensuring an adequate level of data protection. Data collected from Users located in the United States is stored in the United States.\n \n\n Advertisements\n We do not use third-party advertising technology to serve advertisements when you access the App.\n \n\n Marketing\n We may use your Personal Information, such as your name, email address to send you a Newsletter about our products and services. You may opt out of receiving this Newsletter at any time by unsubscribing via the link in the newsletter.\n \n\n Providing Data to Third Parties\n We may provide your information to our partners. For example, we may share any information we receive with vendors and service providers retained in connection with the provision of the App. If you use the App to make a donation, your payment-related information, such as credit card or other financial information, is collected by our third- party payment processor on our behalf. In all cases, these parties are necessary to provide the services.\n We may collect, use, and share anonymous data for statistical purposes, reviews, and comparisons; no such data will be traceable to individuals.\n We are committed to making it easier for donors to give to charities of their choosing, and we will never sell data to third parties.\n We may access, preserve, and disclose your information if we believe doing so is required or appropriate to: (a) comply with law enforcement requests and legal process, such as a court order or subpoena; (b) respond to your requests; or (c) protect your, our, or others’ rights, property, or safety.\n We may transfer your information to service providers, advisors, potential transactional partners, or other third parties in connection with the consideration, negotiation, or completion of a corporate transaction in which we are acquired by or merged with another company or we sell, liquidate, or transfer all or a portion of our assets. The use of your information following any of these events will be governed by the provisions of this Privacy Policy in effect at the time the applicable information was collected.\n We may also disclose your information with your permission.\n \n\n Children’s Privacy\n We do not knowingly collect, maintain, or use personal information from children under 13 years of age, and no part of our App is directed to children. If you learn that a child has provided us with personal information in violation of this Privacy Policy, then you may alert us at support@givt.app.\n \n\n Third Parties\n The App may contain links to other websites, products, or services that we do not own or operate. We are not responsible for the privacy practices of these third parties. Please be aware that this Privacy Policy does not apply to your activities on these third-party services or any information you disclose to these third parties. We encourage you to read their privacy policies before providing any information to them.\n \n\n Updates or amendments to this Privacy Policy\n We reserve the right to periodically amend or revise the Privacy Policy; material changes will be effective immediately upon the display of the revised Privacy policy. The last revision will be reflected in the “Last modified” section. If we materially change the ways in which we use or share personal information collected from you, we will notify you through the App, by email, or other communication. Your continued use of our Services following the notification of such amendments on our Website or through the App, constitutes your acknowledgment and consent of such amendments to the Privacy Policy and your agreement to be bound by the terms of such amendments.\n \n\n How to contact us\n If you have any general questions about the App or the information we collect about you and how we use it, you can contact us at: support@givt.app or by phone at +1 918-615-9611.';

  @override
  String get termsTextUs => 'GIVT INC.\n Terms of Use for Giving with Givt \n Last updated: July 13th, 2022\n Version: 1.1\n These terms of use describe the conditions under which you can use the services made available through the mobile or other downloadable application and website owned by Givt, Inc. (“Givt”, and “Service\" respectively) can be utilized by you, the User (“you”). These Terms of Use are a legally binding contract between you and Givt regarding your use of the Service.\n BY DOWNLOADING, INSTALLING, OR OTHERWISE ACCESSING OR USING THE SERVICE, YOU AGREE THAT YOU HAVE READ AND UNDERSTOOD, AND, AS A CONDITION TO YOUR USE OF THE SERVICE, YOU AGREE TO BE BOUND BY, THE FOLLOWING TERMS AND CONDITIONS, INCLUDING GIVT’S PRIVACY POLICY (https://www.givt.app/privacy-policy) (TOGETHER, THESE “TERMS”). If you are not eligible, or do not agree to the Terms, then you do not have our permission to use the Service. YOUR USE OF THE SERVICE, AND GIVT’S PROVISION OF THE SERVICE TO YOU, CONSTITUTES AN AGREEMENT BY GIVT AND BY YOU TO BE BOUND BY THESE TERMS.\n Arbitration NOTICE. Except for certain kinds of disputes described in Section 12, you agree that disputes arising under these Terms will be resolved by binding, individual arbitration, and BY ACCEPTING THESE TERMS, YOU AND GIVT ARE EACH WAIVING THE RIGHT TO A TRIAL BY JURY OR TO PARTICIPATE IN ANY CLASS ACTION OR REPRESENTATIVE PROCEEDING.\n 1. Givt Service Overview. Givt provides its users with a platform to make anonymous donations to any of the entities properly registered with Givt as a recipient of donations (“Recipient”). The Service is available for users through their smartphones, and other electronic device. \n 2. Eligibility. You must be at least 18 years old to use the Service. By agreeing to these Terms, you represent and warrant to us that: (a) you are at least 18 years old; (b) you have not previously been suspended or removed from the Service; and (c) your registration and your use of the Service is in compliance with any and all applicable laws and regulations. If you are an entity, organization, or company, the individual accepting these Terms on your behalf represents and warrants that they have authority to bind you to these Terms and you agree to be bound by these Terms. \n 3. Accounts and Registration. To access the Service, you must register for an account. When you register for an account, you may be required to provide us with some information about yourself, such as your (i) name (ii) address, (iii) phone number, and (iv) e-mail address. You agree that the information you provide to us is accurate, complete, and not misleading, and that you will keep it accurate and up to date at all times. When you register, you will be asked to create a password. You are solely responsible for maintaining the confidentiality of your account and password, and you accept responsibility for all activities that occur under your account. If you believe that your account is no longer secure, then you should immediately notify us at support@givt.app.\n 4. Processing Donations\n 4.1. Givt does not provide banking or payment services. To facilitate the processing and transfer of donations from you to Recipients, Givt has entered into an agreement with a third party payment processor (the “Processor”). The amount of your donation that is actually received by a Recipient will be net of fees and other charges imposed by Givt and Processor.\n 4.2. The transaction data, including the applicable designated Recipient, will be processed by Givt and forwarded to the Processor. The Processor will, subject to the Processor’s online terms and conditions, initiate payment transactions to the bank account of the applicable designated Recipient. For the full terms of the transfer of donations, including chargeback, reversals, fees and charges, and limitations on the amount of a donation please see Processor’s online terms and conditions.\n 4.3. You agree that Givt may pass your transaction and bank data to the Processor, along with all other necessary account and personal information, in order to enable the Processor to initiate the transfer of donations from you to Recipients. Givt reserves the right to change of Processor at any time. You agree that Givt may forward relevant information and data as set forth in this Section 4.3 to the new Processor in order to continue the processing and transfer of donations from you to Recipients.\n 5. License and intellectual property rights\n 5.1. Limited License. Subject to your complete and ongoing compliance with these Terms, Givt grants you a non-exclusive, non-sublicensable and non-transmittable license to (a) install and use one object code copy of any mobile or other downloadable application associated with the Service (whether installed by you or pre-installed on your mobile device manufacturer or a wireless telephone provider) on a mobile device that you own or control; (b) access and use the Service. You are not allowed to use the Service for commercial purposes.\n 5.2. License Restrictions. Except and solely to the extent such a restriction is impermissible under applicable law, you may not: (a) provide the Service to third parties; (b) reproduce, distribute, publicly display, publicly perform, or create derivative works for the Service; (c) decompile, submit to reverse engineer or modify the Service; (d), remove or bypass the technical provisions that are intended to protect the Service and/or Givt. If you are prohibited under applicable law from using the Service, then you may not use it. \n 5.3. Ownership; Proprietary Rights. The Service is owned and operated by Givt. The visual interfaces, graphics, design, compilation, information, data, computer code (including source code or object code), products, software, services, and all other elements of the Service provided by Givt (“Materials”) are protected by intellectual property and other laws. All Materials included in the Service are the property of Givt or its third-party licensors. Except as expressly authorized by Givt, you may not make use of the Materials. There are no implied licenses in these Terms and Givt reserves all rights to the Materials not granted expressly in these Terms.\n 5.4. Feedback. We respect and appreciate the thoughts and comments from our users. If you choose to provide input and suggestions regarding existing functionalities, problems with or proposed modifications or improvements to the Service (“Feedback”), then you hereby grant Givt an unrestricted, perpetual, irrevocable, non-exclusive, fully paid, royalty-free right and license to exploit the Feedback in any manner and for any purpose, including to improve the Service and create other products and services. We will have no obligation to provide you with attribution for any Feedback you provide to us.\n 6. Third-Party Software. The Service may include or incorporate third-party software components that are generally available free of charge under licenses granting recipients broad rights to copy, modify, and distribute those components (“Third-Party Components”). Although the Service is provided to you subject to these Terms, nothing in these Terms prevents, restricts, or is intended to prevent or restrict you from obtaining Third-Party Components under the applicable third-party licenses or to limit your use of Third-Party Components under those third-party licenses.\n 7. Prohibited Conduct. BY USING THE SERVICE, YOU AGREE NOT TO:\n 7.1. use the Service for any illegal purpose or in violation of any local, state, national, or international law;\n 7.2. violate, encourage others to violate, or provide instructions on how to violate, any right of a third party, including by infringing or misappropriating any third-party intellectual property right;\n 7.3. interfere with security-related features of the Service, including by: (i) disabling or circumventing features that prevent or limit use, printing or copying of any content; or (ii) reverse engineering or otherwise attempting to discover the source code of any portion of the Service except to the extent that the activity is expressly permitted by applicable law;\n 7.4. interfere with the operation of the Service or any user’s enjoyment of the Service, including by: (i) uploading or otherwise disseminating any virus, adware, spyware, worm, or other malicious code; (ii) making any unsolicited offer or advertisement to another user of the Service; (iii) collecting personal information about another user or third party without consent; or (iv) interfering with or disrupting any network, equipment, or server connected to or used to provide the Service;\n 7.5. perform any fraudulent activity including impersonating any person or entity, claiming a false affiliation or identity, accessing any other Service account without permission, or falsifying your age or date of birth;\n 7.6. sell or otherwise transfer the access granted under these Terms or any Materials or any right or ability to view, access, or use any Materials; or\n 7.7. attempt to do any of the acts described in this Section 7 or assist or permit any person in engaging in any of the acts described in this Section 7.\n 8. Term, Termination, and Modification of the Service\n 8.1. Term. These Terms are effective beginning when you accept the Terms or first download, install, access, or use the Service, and ending when terminated as described in Section 8.2.\n 8.2. Termination. If you violate any provision of these Terms, then your authorization to access the Service and these Terms automatically terminate. These Terms will end by operation of law in the event you are declared bankrupt, you apply for a moratorium on payments or a general attachment is levied against your assets, in the event of your death, or in the event you go into liquidation, are wound up or dissolved. Following the termination of these Terms (for whatever reason), you shall cease and desist from all further use of Givt. You must then delete all copies (including back-up copies) of Givt from all your systems.\n 8.3. In addition, Givt may, at its sole discretion, terminate these Terms or your account on the Service, or suspend or terminate your access to the Service, at any time for any reason or no reason, with or without notice, and without any liability to you arising from such termination. You may terminate your account and these Terms at any time by deleting or uninstalling the Service, or as otherwise indicated within the Service, or by contacting customer service at support@givt.app. In the event your smartphone, or other electronic device on which the Services are installed, is lost or stolen, inform Givt immediately by contacting support@givt.app. Upon receipt of a message Givt will use commercially reasonable efforts to block the account to prevent further misuse.\n 8.4. Effect of Termination. Upon termination of these Terms: (a) your license rights will terminate and you must immediately cease all use of the Service; (b) you will no longer be authorized to access your account or the Service. If your account has been terminated for a breach of these Terms, then you are prohibited from creating a new account on the Service using a different name, email address or other forms of account verification.\n 8.5. Modification of the Service. Givt reserves the right to modify or discontinue all or any portion of the Service at any time (including by limiting or discontinuing certain features of the Service), temporarily or permanently, without notice to you. Givt will have no liability for any change to the Service, or any suspension or termination of your access to or use of the Service. \n 9. Indemnity. To the fullest extent permitted by law, you are responsible for your use of the Service, and you will defend and indemnify Givt, its affiliates and their respective shareholders, directors, managers, members, officers, employees, consultants, and agents (together, the “Givt Entities”) from and against every claim brought by a third party, and any related liability, damage, loss, and expense, including attorneys’ fees and costs, arising out of or connected with: (1) your unauthorized use of, or misuse of, the Service; (2) your violation of any portion of these Terms, any representation, warranty, or agreement referenced in these Terms, or any applicable law or regulation; (3) your violation of any third-party right, including any intellectual property right or publicity, confidentiality, other property, or privacy right; or (4) any dispute or issue between you and any third party. We reserve the right, at our own expense, to assume the exclusive defense and control of any matter otherwise subject to indemnification by you (without limiting your indemnification obligations with respect to that matter), and in that case, you agree to cooperate with our defense of those claims.\n 10. Disclaimers; No Warranties.\n THE SERVICE AND ALL MATERIALS AND CONTENT AVAILABLE THROUGH THE SERVICE ARE PROVIDED “AS IS” AND ON AN “AS AVAILABLE” BASIS. GIVT DISCLAIMS ALL WARRANTIES OF ANY KIND, WHETHER EXPRESS OR IMPLIED, RELATING TO THE SERVICE AND ALL MATERIALS AND CONTENT AVAILABLE THROUGH THE SERVICE, INCLUDING: (A) ANY IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, QUIET ENJOYMENT, OR NON-INFRINGEMENT; AND (B) ANY WARRANTY ARISING OUT OF COURSE OF DEALING, USAGE, OR TRADE. GIVT DOES NOT WARRANT THAT THE SERVICE OR ANY PORTION OF THE SERVICE, OR ANY MATERIALS OR CONTENT OFFERED THROUGH THE SERVICE, WILL BE UNINTERRUPTED, SECURE, OR FREE OF ERRORS, VIRUSES, OR OTHER HARMFUL COMPONENTS, AND GIVT DOES NOT WARRANT THAT ANY OF THOSE ISSUES WILL BE CORRECTED.\n NO ADVICE OR INFORMATION, WHETHER ORAL OR WRITTEN, OBTAINED BY YOU FROM THE SERVICE OR GIVT ENTITIES OR ANY MATERIALS OR CONTENT AVAILABLE THROUGH THE SERVICE WILL CREATE ANY WARRANTY REGARDING ANY OF THE GIVT ENTITIES OR THE SERVICE THAT IS NOT EXPRESSLY STATED IN THESE TERMS. WE ARE NOT RESPONSIBLE FOR ANY DAMAGE THAT MAY RESULT FROM THE SERVICE AND YOUR DEALING WITH ANY OTHER SERVICE USER. WE DO NOT GUARANTEE THE STATUS OF ANY ORGANIZATION, INCLUDING WHETHER AN ORGANIZATION IS A NOT-FOR-PROFIT, CHARITABLE, OR OTHER SIMILAR ORGANIZATION UNDER APPLICABLE LAWS, AND WE DO NOT MAKE ANY REPRESENTATIONS REGARDING THE TAX TREATMENT OF ANY DONATIONS, GIFTS, OR OTHER MONEYS TRANSFERRED OR OTHERWISE PROVIDED TO ANY SUCH ORGANIZATION. YOU ARE SOLELY RESPONSIBLE FOR DETERMINING WHETHER AN ORGANIZATION QUALIFIES AS A NOT-FOR-PROFIT, CHARITABLE, OR OTHER SIMILAR ORGANIZATION UNDER APPLICABLE LAWS AND TO UNDERSTAND THE TAX TREATMENT OF ANY DONATIONS, GIFTS OR OTHER MONEYS TRANSFERRED OR PROVIDED TO SUCH ORGANIZATIONS. YOU UNDERSTAND AND AGREE THAT YOU USE ANY PORTION OF THE SERVICE AT YOUR OWN DISCRETION AND RISK, AND THAT WE ARE NOT RESPONSIBLE FOR ANY DAMAGE TO YOUR PROPERTY (INCLUDING YOUR COMPUTER SYSTEM OR MOBILE DEVICE USED IN CONNECTION WITH THE SERVICE) OR ANY LOSS OF DATA, INCLUDING USER CONTENT.\n THE LIMITATIONS, EXCLUSIONS AND DISCLAIMERS IN THIS SECTION APPLY TO THE FULLEST EXTENT PERMITTED BY LAW. Givt does not disclaim any warranty or other right that Givt is prohibited from disclaiming under applicable law.\n 11. Liability\n 11.1. TO THE FULLEST EXTENT PERMITTED BY LAW, IN NO EVENT WILL THE GIVT ENTITIES BE LIABLE TO YOU FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL OR PUNITIVE DAMAGES (INCLUDING DAMAGES FOR LOSS OF PROFITS, GOODWILL, OR ANY OTHER INTANGIBLE LOSS) ARISING OUT OF OR RELATING TO YOUR ACCESS TO OR USE OF, OR YOUR INABILITY TO ACCESS OR USE, THE SERVICE OR ANY MATERIALS OR CONTENT ON THE SERVICE, WHETHER BASED ON WARRANTY, CONTRACT, TORT (INCLUDING NEGLIGENCE), STATUTE, OR ANY OTHER LEGAL THEORY, AND WHETHER OR NOT ANY GIVT ENTITY HAS BEEN INFORMED OF THE POSSIBILITY OF DAMAGE.\n 11.2. EXCEPT AS PROVIDED IN SECTIONS 11.2 AND 11.3 AND TO THE FULLEST EXTENT PERMITTED BY LAW, THE AGGREGATE LIABILITY OF THE GIVT ENTITIES TO YOU FOR ALL CLAIMS ARISING OUT OF OR RELATING TO THE USE OF OR ANY INABILITY TO USE ANY PORTION OF THE SERVICE OR OTHERWISE UNDER THESE TERMS, WHETHER IN CONTRACT, TORT, OR OTHERWISE, IS LIMITED TO US\$100.\n 11.3. EACH PROVISION OF THESE TERMS THAT PROVIDES FOR A LIMITATION OF LIABILITY, DISCLAIMER OF WARRANTIES, OR EXCLUSION OF DAMAGES IS INTENDED TO AND DOES ALLOCATE THE RISKS BETWEEN THE PARTIES UNDER THESE TERMS. THIS ALLOCATION IS AN ESSENTIAL ELEMENT OF THE BASIS OF THE BARGAIN BETWEEN THE PARTIES. EACH OF THESE PROVISIONS IS SEVERABLE AND INDEPENDENT OF ALL OTHER PROVISIONS OF THESE TERMS. THE LIMITATIONS IN THIS SECTION 11 WILL APPLY EVEN IF ANY LIMITED REMEDY FAILS OF ITS ESSENTIAL PURPOSE.\n 12. Dispute Resolution and Arbitration\n 12.1. Generally. Except as described in Section 12.2 and 12.3, you and Givt agree that every dispute arising in connection with these Terms, the Service, or communications from us will be resolved through binding arbitration. Arbitration uses a neutral arbitrator instead of a judge or jury, is less formal than a court proceeding, may allow for more limited discovery than in court, and is subject to very limited review by courts. This agreement to arbitrate disputes includes all claims whether based in contract, tort, statute, fraud, misrepresentation, or any other legal theory, and regardless of whether a claim arises during or after the termination of these Terms. Any dispute relating to the interpretation, applicability, or enforceability of this binding arbitration agreement will be resolved by the arbitrator.\n YOU UNDERSTAND AND AGREE THAT, BY ENTERING INTO THESE TERMS, YOU AND GIVT ARE EACH WAIVING THE RIGHT TO A TRIAL BY JURY OR TO PARTICIPATE IN A CLASS ACTION.\n 12.2. Exceptions. Although we are agreeing to arbitrate most disputes between us, nothing in these Terms will be deemed to waive, preclude, or otherwise limit the right of either party to: (a) bring an individual action in small claims court; (b) pursue an enforcement action through the applicable federal, state, or local agency if that action is available; (c) seek injunctive relief in a court of law in aid of arbitration; or (d) to file suit in a court of law to address an intellectual property infringement claim.\n 12.3. Opt-Out. If you do not wish to resolve disputes by binding arbitration, you may opt out of the provisions of this Section 12 within 30 days after the date that you agree to these Terms by sending an e-mail to Givt Inc. at support@givt.app, with the following subject line: “Legal Department – Arbitration Opt-Out”, that specifies: your full legal name, the email address associated with your account on the Service, and a statement that you wish to opt out of arbitration (“Opt-Out Notice”). Once Givt receives your Opt-Out Notice, this Section 12 will be void and any action arising out of these Terms will be resolved as set forth in Section 12.2. The remaining provisions of these Terms will not be affected by your Opt-Out Notice.\n 12.4. Arbitrator. This arbitration agreement, and any arbitration between us, is subject to the Federal Arbitration Act and will be administered by the American Arbitration Association (“AAA”) under its Consumer Arbitration Rules (collectively, “AAA Rules”) as modified by these Terms. The AAA Rules and filing forms are available online at www.adr.org, by calling the AAA at +1-800-778-7879, or by contacting Givt.\n 12.5. Commencing Arbitration. Before initiating arbitration, a party must first send a written notice of the dispute to the other party by e-mail mail (“Notice of Arbitration”). Givt’s e-address for Notice is: support@givt.app. The Notice of Arbitration must: (a) include the following subject line: “Notice of Arbitration”; (b) identify the name or account number of the party making the claim; (c) describe the nature and basis of the claim or dispute; and (d) set forth the specific relief sought (“Demand”). The parties will make good faith efforts to resolve the claim directly, but if the parties do not reach an agreement to do so within 30 days after the Notice of Arbitration is received, you or Givt may commence an arbitration proceeding. If you commence arbitration in accordance with these Terms, Givt will reimburse you for your payment of the filing fee, unless your claim is for more than US\$10,000 or if Givt has received 25 or more similar demands for arbitration, in which case the payment of any fees will be decided by the AAA Rules. If the arbitrator finds that either the substance of the claim or the relief sought in the Demand is frivolous or brought for an improper purpose (as measured by the standards set forth in Federal Rule of Civil Procedure 11(b)), then the payment of all fees will be governed by the AAA Rules and the other party may seek reimbursement for any fees paid to AAA.\n 12.6. Arbitration Proceedings. Any arbitration hearing will take place in Fulton County, Georgia unless we agree otherwise or, if the claim is for US\$10,000 or less (and does not seek injunctive relief), you may choose whether the arbitration will be conducted: (a) solely on the basis of documents submitted to the arbitrator; (b) through a telephonic or video hearing; or (c) by an in-person hearing as established by the AAA Rules in the county (or parish) of your residence. During the arbitration, the amount of any settlement offer made by you or Givt must not be disclosed to the arbitrator until after the arbitrator makes a final decision and award, if any. Regardless of the manner in which the arbitration is conducted, the arbitrator must issue a reasoned written decision sufficient to explain the essential findings and conclusions on which the decision and award, if any, are based. \n 12.7. Arbitration Relief. Except as provided in Section 12.8, the arbitrator can award any relief that would be available if the claims had been brough in a court of competent jurisdiction. If the arbitrator awards you an amount higher than the last written settlement amount offered by Givt before an arbitrator was selected, Givt will pay to you the higher of: (a) the amount awarded by the arbitrator and (b) US\$10,000. The arbitrator’s award shall be final and binding on all parties, except (1) for judicial review expressly permitted by law or (2) if the arbitrator\'s award includes an award of injunctive relief against a party, in which case that party shall have the right to seek judicial review of the injunctive relief in a court of competent jurisdiction that shall not be bound by the arbitrator\'s application or conclusions of law. Judgment on the award may be entered in any court having jurisdiction.\n 12.8. No Class Actions. YOU AND GIVT AGREE THAT EACH MAY BRING CLAIMS AGAINST THE OTHER ONLY IN YOUR OR ITS INDIVIDUAL CAPACITY AND NOT AS A PLAINTIFF OR CLASS MEMBER IN ANY PURPORTED CLASS OR REPRESENTATIVE PROCEEDING. Further, unless both you and Givt agree otherwise, the arbitrator may not consolidate more than one person’s claims and may not otherwise preside over any form of a representative or class proceeding.  \n 12.9. Modifications to this Arbitration Provision. If Givt makes any substantive change to this arbitration provision, you may reject the change by sending us written notice within 30 days of the change to Givt’s address for Notice of Arbitration, in which case your account with Givt will be immediately terminated and this arbitration provision, as in effect immediately prior to the changes you rejected will survive.\n 12.10. Enforceability. If Section 12.8 or the entirety of this Section 12.10 is found to be unenforceable, or if Givt receives an Opt-Out Notice from you, then the entirety of this Section 12 will be null and void and, in that case, the exclusive jurisdiction and venue described in Section 13.2 will govern any action arising out of or related to these Terms. \n \n\n 13. Miscellaneous \n 13.1. General Terms. These Terms, including the Privacy Policy and any other agreements expressly incorporated by reference into these Terms, are the entire and exclusive understanding and agreement between you and Givt regarding your use of the Service. You may not assign or transfer these Terms or your rights under these Terms, in whole or in part, by operation of law or otherwise, without our prior written consent. We may assign these Terms and all rights granted under these Terms, at any time without notice or consent. The failure to require performance of any provision will not affect our right to require performance at any other time after that, nor will a waiver by us of any breach or default of these Terms, or any provision of these Terms, be a waiver of any subsequent breach or default or a waiver of the provision itself. Use of Section headers in these Terms is for convenience only and will not have any impact on the interpretation of any provision. Throughout these Terms the use of the word “including” means “including but not limited to.” If any part of these Terms is held to be invalid or unenforceable, then the unenforceable part will be given effect to the greatest extent possible, and the remaining parts will remain in full force and effect.\n 13.2. Governing Law. These Terms are governed by the laws of the State of Delaware without regard to conflict of law principles. You and Givt submit to the personal and exclusive jurisdiction of the state courts and federal courts located within Fulton County, Georgia for resolution of any lawsuit or court proceeding permitted under these Terms. We operate the Service from our offices in Georgia, and we make no representation that Materials included in the Service are appropriate or available for use in other locations.\n 13.3. Privacy Policy. Please read the Givt Privacy Policy (https://www.givt.app/privacy-policy) carefully for information relating to our collection, use, storage, and disclosure of your personal information. The Givt Privacy Policy is incorporated by this reference into, and made a part of, these Terms. \n 13.4. Additional Terms. Your use of the Service is subject to all additional terms, policies, rules, or guidelines applicable to the Service or certain features of the Service that we may post on or link to from the Service (the “Additional Terms”). All Additional Terms are incorporated by this reference into, and made a part of, these Terms.\n 13.5. Modification of these Terms. We reserve the right to change these Terms on a going-forward basis at any time. Please check these Terms periodically for changes. If a change to these Terms materially modifies your rights or obligations, we may require that you accept the modified Terms in order to continue to use the Service. Material modifications are effective upon your acceptance of the modified Terms. Immaterial modifications are effective upon publication. Except as expressly permitted in this Section 13.5, these Terms may be amended only by a written agreement signed by authorized representatives of the parties to these Terms. Disputes arising under these Terms will be resolved in accordance with the version of these Terms that was in effect at the time the dispute arose.\n 13.6. Consent to Electronic Communications. By using the Service, you consent to receiving certain electronic communications from us as further described in our Privacy Policy. Please read our Privacy Policy to learn more about our electronic communications practices. You agree that any notices, agreements, disclosures, or other communications that we send to you electronically will satisfy any legal communication requirements, including that those communications be in writing.\n 13.7. Contact Information. The Service is offered by Givt Inc. located at\n 3343 Peachtree Road Northeast Suite 145-1032, Atlanta, GA 30326. You may contact us by emailing us at support@givt.app.\n 13.8. Notice to California Residents. If you are a California resident, then under California Civil Code Section 1789.3, you may contact the Complaint Assistance Unit of the Division of Consumer Services of the California Department of Consumer Affairs in writing at 1625 N. Market Blvd., Suite S-202, Sacramento, California 95834, or by telephone at +1-800-952-5210 in order to resolve a complaint regarding the Service or to receive further information regarding use of the Service.\n 13.9. No Support. We are under no obligation to provide support for the Service. In instances where we may offer support, the support will be subject to published policies.\n 13.10. International Use. The Service is intended for visitors located within the United States. We make no representation that the Service is appropriate or available for use outside of the United States. Access to the Service from countries or territories or by individuals where such access is illegal is prohibited.\n 13.11. Complaints. Givt handles complaints efficiently and as soon as reasonably possible. Any complaint about the implementation of these Terms by Givt must be submitted in writing at Givt via e-mail to support@givt.app.\n 13.12. Notice Regarding Apple. This Section 13 only applies to the extent you are using our mobile application on an iOS device. You acknowledge that these Terms are between you and Givt only, not with Apple Inc. (“Apple”), and Apple is not responsible for the Service or the content of it. Apple has no obligation to furnish any maintenance and support services with respect to the Service. If the Service fails to conform to any applicable warranty, you may notify Apple, and Apple will refund any applicable purchase price for the mobile application to you. To the maximum extent permitted by applicable law, Apple has no other warranty obligation with respect to the Service. Apple is not responsible for addressing any claims by you or any third party relating to the Service or your possession and/or use of the Service, including: (1) product liability claims; (2) any claim that the Service fails to conform to any applicable legal or regulatory requirement; or (3) claims arising under consumer protection or similar legislation. Apple is not responsible for the investigation, defense, settlement, and discharge of any third-party claim that the Service and/or your possession and use of the Service infringe a third party’s intellectual property rights. You agree to comply with any applicable third-party terms when using the Service. Apple and Apple’s subsidiaries are third-party beneficiaries of these Terms, and upon your acceptance of these Terms, Apple will have the right (and will be deemed to have accepted the right) to enforce these Terms against you as a third-party beneficiary of these Terms. You hereby represent and warrant that: (a) you are not located in a country that is subject to a U.S. Government embargo or that has been designated by the U.S. Government as a “terrorist supporting” country; and (b) you are not listed on any U.S. Government list of prohibited or restricted parties.';

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
    return 'The amount has to be at least $value0';
  }

  @override
  String get unregisterInfoUs => 'We’re sad to see you go!';

  @override
  String get invalidQRcodeTitle => 'Inactive QR code';

  @override
  String invalidQRcodeMessage(Object value0) {
    return 'Unfortunately, this QR code is no longer active. Would you like to give to the general funds of $value0?';
  }

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get registrationErrorTitle => 'Registration cannot be completed';

  @override
  String get noDonationsFoundOnRegistrationMessage => 'We could not retrieve any donations but we need one to complete your registration. Please contact support at support@givt.app or through About Givt/Contact in the menu.';

  @override
  String get cantCancelAlreadyProcessed => 'Alas, you can\'t cancel this donation because it is already processed.';

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
  String get surname => 'Surname';

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
    return 'Do you want to use $value0?';
  }

  @override
  String get permitBiometricExplanation => 'Speed up the login process and keep you account secure';

  @override
  String get permitBiometricSkip => 'Skip for now';

  @override
  String permitBiometricActivateWithType(Object value0) {
    return 'Activate $value0';
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

/// The translations for English, as used in the United States (`en_US`).
class AppLocalizationsEnUs extends AppLocalizationsEn {
  AppLocalizationsEnUs(): super('en_US');

  @override
  String get ibanPlaceHolder => 'IBAN account number';

  @override
  String get amountLimitExceeded => 'This amount is higher than your chosen maximum amount. Please adjust the maximum donation amount or choose a lower amount.';

  @override
  String get belgium => 'Belgium';

  @override
  String get insertAmount => 'Do you know how much you want to give? \n Choose an amount.';

  @override
  String get netherlands => 'The Netherlands';

  @override
  String get notificationTitle => 'Givt';

  @override
  String get selectReceiverTitle => 'Select recipient';

  @override
  String get slimPayInformation => 'We want your Givt experience to be as smooth as possible.';

  @override
  String get savingSettings => 'Sit back and relax,\n we are saving your settings.';

  @override
  String get continueKey => 'Continue';

  @override
  String get slimPayInfoDetail => 'Givt works together with SlimPay for executing the transactions. SlimPay is specialised in handling mandates and automatic money transfers on digital platforms. SlimPay executes these orders for Givt at the lowest rates on this market and at a high speed.\n \n\n SlimPay is an ideal partner for Givt because they make giving without cash very easy and safe. As a payment company, they are supervised by the Nederlandsche Bank and other European national banks.\n \n\n The money will be collected in a SlimPay account. \n Givt will ensure that the money is distributed correctly.';

  @override
  String get slimPayInfoDetailTitle => 'What is SlimPay?';

  @override
  String get continueRegistration => 'Your user account was already\n created, but it was impossible\n to finalise the registration.\n \n\n We would love for you to use\n Givt, so we ask you to login\n to complete the registration.';

  @override
  String get contactFailedButton => 'Didn\'t work?';

  @override
  String get unregisterButton => 'Terminate my account';

  @override
  String get unregisterUnderstood => 'I understand';

  @override
  String givtIsBeingProcessed(Object value0) {
    return 'Thank you for your Givt to $value0!\n You can check the status in the overview.';
  }

  @override
  String get offlineGegevenGivtMessage => 'Thank you for your Givt!\n \n\n When there\'s a good connection with the Givt-server, your Givt will be processed.\n You can check the status in the overview.';

  @override
  String offlineGegevenGivtMessageWithOrg(Object value0) {
    return 'Thank you for your Givt to $value0!\n \n\n When there\'s a good connection with the Givt-server, your Givt will be processed.\n You can check the status in the overview.';
  }

  @override
  String get pincode => 'Passcode';

  @override
  String get pincodeTitleChangingPin => 'This is where you change the use of your passcode to login into the Givt app.';

  @override
  String get pincodeChangePinMenu => 'Change passcode';

  @override
  String get pincodeSetPinTitle => 'Set passcode';

  @override
  String get pincodeSetPinMessage => 'Set your passcode here';

  @override
  String get pincodeEnterPinAgain => 'Re-enter your passcode';

  @override
  String get pincodeDoNotMatch => 'Codes do not match. Could you try again?';

  @override
  String get pincodeSuccessfullTitle => 'Got it!';

  @override
  String get pincodeSuccessfullMessage => 'Your passcode has been successfully saved.';

  @override
  String get pincodeForgotten => 'Login with e-mail and password';

  @override
  String get pincodeForgottenTitle => 'Forgot passcode';

  @override
  String get pincodeForgottenMessage => 'Login using your e-mail address to access your account.';

  @override
  String get pincodeWrongPinTitle => 'Wrong passcode';

  @override
  String get pincodeWrongPinFirstTry => 'First attempt failed.\n Please try again.';

  @override
  String get pincodeWrongPinSecondTry => 'Second attempt failed.\n Please try again.';

  @override
  String get pincodeWrongPinThirdTry => 'Third attempt failed.\n Login using your e-mail address.';

  @override
  String get wrongPasswordLockedOut => 'Third attempt failed, you cannot login for 15 minutes. Try again later.';

  @override
  String confirmGivtSafari(Object value0) {
    return 'Thank you for your Givt to $value0! Please confirm by pressing the button. You can check the status in the overview.';
  }

  @override
  String get confirmGivtSafariNoOrg => 'Thank you for your Givt! Please confirm by pressing the button. You can check the status in the overview.';

  @override
  String get menuSettingsSwitchAccounts => 'Switch accounts';

  @override
  String get prepareIUnderstand => 'I understand';

  @override
  String get amountLimitExceededGb => 'This amount is higher than \$250. Please choose a lower amount.';

  @override
  String giftOverviewGiftAidBanner(Object value0) {
    return 'Gift Aided $value0';
  }

  @override
  String get maximumAmountReachedGb => 'Woah, you\'ve reached the maximum donation limit. You can give a maximum of \$250 per donation.';

  @override
  String get faqWhyBluetoothEnabledQ => 'Why do I have to enable Bluetooth to use Givt?';

  @override
  String get faqWhyBluetoothEnabledA => 'Your phone receives a signal from the beacon inside the collection box, bag or basket. This signal uses the Bluetooth protocol. It can be considered as a one-way traffic, which means there is no connection, in contrast to a Bluetooth car kit or headset. It is a safe and easy way to let your phone know which collection box, bag or basket is nearby. When the beacon is near, the phone picks up the signal and your Givt is completed.';

  @override
  String get collect => 'Collection';

  @override
  String get offlineGegevenGivtsMessage => 'Thank you for your Givts!\n \n\n When there\'s a good connection with the Givt-server, your Givts will be processed.\n You can check the status in the overview.';

  @override
  String offlineGegevenGivtsMessageWithOrg(Object value0) {
    return 'Thank you for your Givts to $value0!\n \n\n When there\'s a good connection with the Givt-server, your Givts will be processed.\n You can check the status in the overview.';
  }

  @override
  String get changeDonation => 'Change your donation';

  @override
  String get cancelGivts => 'Cancel your Givt';

  @override
  String get areYouSureToCancelGivts => 'Are you sure? Press OK to confirm.';

  @override
  String get feedbackTitle => 'Feedback or questions?';

  @override
  String get noMessage => 'You didn\'t enter a message.';

  @override
  String get feedbackMailSent => 'We\'ve received your message succesfully, we\'ll be in touch as soon as possible.';

  @override
  String get typeMessage => 'Write your message here!';

  @override
  String get safariGivtTransaction => 'This Givt will be converted into a transaction.';

  @override
  String get safariMandateSignedPopup => 'Your donations are withdrawn from this IBAN. If this is incorrect, just cancel this Givt and register a new account.';

  @override
  String get didNotSignMandateYet => 'You still need to sign a mandate. This is necessary to be able to give from start to finish. At the moment it\'s not possible to sign one. Your Givt will proceed, but to be processed completely, a mandate needs to be signed.';

  @override
  String get appVersion => 'App version:';

  @override
  String get shareGivtText => 'Share Givt';

  @override
  String get shareGivtTextLong => 'Hey! Do you want to keep on giving?';

  @override
  String get givtGewoonBlijvenGeven => 'Givt - Always good to give.';

  @override
  String get updatesDoneTitle => 'Ready to start giving?';

  @override
  String get updatesDoneSubtitle => 'Givt is completely up-to-date, have fun giving.';

  @override
  String get featureShareTitle => 'Share Givt with everyone!';

  @override
  String get featureShareSubtitle => 'Sharing Givt is as easy as 1, 2, 3. You can share the app at the bottom of the settings page.';

  @override
  String get askMeLater => 'Ask me later';

  @override
  String get giveDifferently => 'Choose from the list';

  @override
  String get churches => 'Churches';

  @override
  String get stichtingen => 'Charities';

  @override
  String get acties => 'Campaigns';

  @override
  String get overig => 'Other';

  @override
  String get signMandateLaterTitle => 'Okay, we will ask you again later.';

  @override
  String get signMandateLater => 'You have chosen to sign the mandate later. You can do this the next time you give.';

  @override
  String get suggestie => 'Give to:';

  @override
  String get codeCanNotBeScanned => 'Alas, this code cannot be used to give within the Givt app.';

  @override
  String get giveDifferentScan => 'Scan QR code';

  @override
  String get giveDiffQrText => 'Now, aim well!';

  @override
  String get qrCodeOrganisationNotFound => 'Code is scanned, but it seems the organization has lost its way. Please, try again later.';

  @override
  String get noCameraAccess => 'We need your camera to scan the code. Go to the app settings on your smartphone to give us your permission.';

  @override
  String get nsCameraUsageDescription => 'We\'d like to use your camera to scan the code.';

  @override
  String get openSettings => 'Open settings';

  @override
  String get needEmailToGiveSubtext => 'To be able to process your donations correctly, we need your e-mail address.';

  @override
  String get completeRegistrationAfterGiveFirst => 'Thanks for giving with Givt!\n \n\n We would love for you to keep \n using Givt, so we ask you \n to complete the registration.';

  @override
  String get termsUpdate => 'The terms and conditions have been updated';

  @override
  String get agreeToUpdateTerms => 'You agree to the new terms and conditions if you continue.';

  @override
  String get iWantToReadIt => 'I want to read it';

  @override
  String get termsTextVersion => '1.9';

  @override
  String get locationPermission => 'We need to access your location to receive the signal from the Givt-beacon.';

  @override
  String get locationEnabledMessage => 'Please enable your location with high accuracy to give with Givt. (After your donation you can disable it again.)';

  @override
  String get changeGivingLimit => 'Adjust maximum amount';

  @override
  String get somethingWentWrong2 => 'Something went wrong.';

  @override
  String get chooseLowerAmount => 'Change the amount';

  @override
  String get turnOnBluetooth => 'Switch on Bluetooth';

  @override
  String get errorTldCheck => 'Sorry, you can’t register with this email address. Could you check for any typos?';

  @override
  String get addCollectConfirm => 'Do you want to add a second collection?';

  @override
  String get faQvraag0 => 'Feedback or questions?';

  @override
  String get faQantwoord0 => 'In the app-menu under \"About Givt / Contact\" there\'s a text field where you can type a message and send it to us. Of course you can also contact us by calling +1 918-615-9611 or by sending an e-mail to support@givt.app.';

  @override
  String get personalPageHeader => 'Change your account data here.';

  @override
  String get personalPageSubHeader => 'Would you like to change your name? Send an e-mail to support@givt.app.';

  @override
  String get titlePersonalInfo => 'Personal information';

  @override
  String get personalInfoTempUser => 'Hi there, fast giver! You\'re using a temporary account. We have not received your personal details yet.';

  @override
  String get updatePersonalInfoError => 'Alas! We are not able to update your personal information at the moment. Could you try again later?';

  @override
  String get updatePersonalInfoSuccess => 'Success!';

  @override
  String get loadingTitle => 'Please wait...';

  @override
  String get loadingMessage => 'Please wait while we are loading your data...';

  @override
  String get buttonChange => 'Change';

  @override
  String get welcomeContinue => 'Let’s begin';

  @override
  String get enterEmail => 'Let’s begin';

  @override
  String get finalizeRegistrationPopupText => 'Important: Donations can only be processed after you have finished your registration.';

  @override
  String get finalizeRegistration => 'Continue';

  @override
  String get importantReminder => 'Important reminder';

  @override
  String get multipleCollections => 'Multiple collections';

  @override
  String get questionAndroidLocation => 'Why does Givt need access to my location?';

  @override
  String get answerAndroidLocation => 'When using an Android smartphone, the Givt-beacon can only be detected by the Givt app when the location is known. Therefore, Givt needs your location to make giving possible. Besides that, we do not use your location.';

  @override
  String get shareTheGivtButton => 'Share with my friends';

  @override
  String shareTheGivtText(Object value0) {
    return 'I\'ve just used Givt to donate to $value0!';
  }

  @override
  String get shareTheGivtTextNoOrg => 'I\'ve just used Givt to donate!';

  @override
  String get joinGivt => 'Get involved on givtapp.net/download.';

  @override
  String get firstUseWelcomeSubTitle => 'Swipe for more information';

  @override
  String get firstUseWelcomeTitle => 'Welcome!';

  @override
  String get firstUseLabelTitle1 => 'Give everywhere with one debit mandate';

  @override
  String get firstUseLabelTitle2 => 'Easy and safe giving';

  @override
  String get firstUseLabelTitle3 => 'Give always and everywhere';

  @override
  String get yesSuccess => 'Yes, success!';

  @override
  String get toGiveWeNeedYourEmailAddress => 'To start giving with Givt, \n we just need your email address';

  @override
  String get weWontSendAnySpam => '(we won\'t send any spam, promise)';

  @override
  String get swipeDownOpenGivt => 'Swipe down to open the Givt app.';

  @override
  String get moreInfo => 'More info';

  @override
  String get germany => 'Germany';

  @override
  String get extraBluetoothText => 'Does it look like your Bluetooth is on? It is still necessary to switch it off and on again.';

  @override
  String get openMailbox => 'Open inbox';

  @override
  String get personalInfo => 'Personal info';

  @override
  String get cameraPermission => 'We need to access your camera to scan a QR code.';

  @override
  String get downloadYearOverview => 'Do you want to download your donations overview of 2017 for your tax return?';

  @override
  String get sendOverViewTo => 'We\'ll send the overview to';

  @override
  String get yearOverviewAvailable => 'Annual overview available';

  @override
  String get checkHereForYearOverview => 'You can request your annual overview here';

  @override
  String get couldNotSendTaxOverview => 'We can\'t seem to fetch your annual review, please try again later. Contact us at support@givt.app if this problem persists.';

  @override
  String get searchHere => 'Search ...';

  @override
  String get noInternet => 'Whoops! It looks like you\'re not connected to the internet. Try again when you are connected with the internet.';

  @override
  String get noInternetConnectionTitle => 'No internet connection';

  @override
  String get serverNotReachable => 'Alas, it\'s not possible to finish your registration at this time, our server seems to have an issue. Can you try it again later?\n Got this message before? We\'re probably not aware of this issue. Help us improve Givt by sending us a message and we\'ll get right on it.';

  @override
  String get sendMessage => 'Send message';

  @override
  String get answerWhyAreMyDataStored => 'Everyday we work very hard at improving Givt. To do this we use the data we have at our disposal.\n We require some of your data to create your mandate. Other information is used to create your personal account.\n We also use your data to answer your service questions.\n In no case we give your personal details to third parties.';

  @override
  String get logoffSession => 'Log out';

  @override
  String get alreadyAnAccount => 'Already have an account?';

  @override
  String get unitedKingdom => 'United Kingdom';

  @override
  String get cancelShort => 'Cancel';

  @override
  String get cantCancelGiftAfter15Minutes => 'Alas, you can\'t cancel this donation within the Givt app';

  @override
  String get unknownErrorCancelGivt => 'Due to an unexpected error, we could not cancel your donation. Get in touch with us at support@givt.app for more information.';

  @override
  String transactionCancelled(Object value0) {
    return 'The donation to $value0 will be cancelled.';
  }

  @override
  String get cancelled => 'Cancelled';

  @override
  String get undo => 'Undo';

  @override
  String get faqVraag16 => 'Can I revoke donations?';

  @override
  String get faqAntwoord16 => 'Yes, simply go to the donation overview and swipe the donation you want to cancel to the left. If this it not possible the donation has already been processed. Note: You can only cancel your donation if you have completed your registration in the Givt app.\n \n\n We believe giving should never come with obligations. We\'re therefore happy to reverse any donations you\'ve made. Simply contact us through the contact field in the menu to get in touch.';

  @override
  String get selectContextCollect => 'Give in the church, at the door or on the street';

  @override
  String get giveContextQr => 'Give by scanning a QR code';

  @override
  String get selectContextList => 'Select a cause from the list';

  @override
  String get selectContext => 'Choose the way you give';

  @override
  String get chooseWhoYouWantToGiveTo => 'Choose who you want to give to';

  @override
  String get cancelGiftAlertTitle => 'Cancel donation?';

  @override
  String get cancelGiftAlertMessage => 'Are you sure you want to cancel this donation?';

  @override
  String get gotIt => 'Got it';

  @override
  String get cancelFeatureTitle => 'You can cancel a donation by swiping left';

  @override
  String get cancelFeatureMessage => 'Tap anywhere to dismiss this message';

  @override
  String get giveSubtitle => 'There are several ways to ‘Givt’. Pick the one that suits you best.';

  @override
  String get confirm => 'Confirm';

  @override
  String safariGivingToOrganisation(Object value0) {
    return 'You just gave to $value0. Find the overview of your donation below.';
  }

  @override
  String get safariGiving => 'You just gave. Find the overview of your donation below.';

  @override
  String get giveSituationShowcaseTitle => 'Next, choose how you want to give';

  @override
  String get soonMessage => 'Coming soon...';

  @override
  String get giveWithYourPhone => 'Move your phone';

  @override
  String get celebrateTitle => 'Let\'s countdown';

  @override
  String get celebrateMessage => 'When the countdown hits 0, hold your phone above your head.\n \n\n What\'s going to happen? You\'ll soon see...';

  @override
  String get afterCelebrationTitle => 'Wave!';

  @override
  String get afterCelebrationMessage => 'Hold it up, shine your light!';

  @override
  String get errorContactGivt => 'An error has occurred, please contact us at support@givt.app.';

  @override
  String get mandateFailPersonalInformation => 'It seems there is something wrong with the information you filled in. Could you please check in the menu, under \'Personal information\'? You can change the information there as well, if necessary.';

  @override
  String mandateSmsCode(Object value0, Object value1) {
    return 'We\'ll send a text message to $value0. The mandate will be signed on behalf of $value1. Correct? Proceed to the next step.';
  }

  @override
  String get mandateSigningCode => 'If all goes well, you\'ll receive a text message. Fill in the code below to sign your mandate.';

  @override
  String get readCode => 'Your code:';

  @override
  String get readMandate => 'View mandate';

  @override
  String get mandatePdfFileName => 'mandate';

  @override
  String get writeStoragePermission => 'To be able to view this PDF, we need access to your phone\'s storage so that we can save the PDF and show it.';

  @override
  String get legalTextSlimPay => 'By continuing, you will be asked to sign a mandate authorizing Givt B.V. to debit your account. You must be the account holder or be authorized to act on the account holder\'s behalf.\n \n\n Your personal data will be processed by SlimPay, a licensed payment institution, to execute the payment transaction on behalf of Givt B.V., and to prevent fraud according to European regulation.';

  @override
  String get resendCode => 'Resend code';

  @override
  String get wrongCodeMandateSigning => 'The code seems to be incorrect. Try again or request a new code.';

  @override
  String get back => 'Back';

  @override
  String get amountLowest => 'Two Euro Fifthy';

  @override
  String get amountMiddle => 'Seven Euro Fifthy';

  @override
  String get amountHighest => 'Twelve Euro Fifthy';

  @override
  String get divider => 'Dot';

  @override
  String givtEventText(Object value0) {
    return 'Hey! You\'re at a location where Givt is supported. Do you want to give to $value0?';
  }

  @override
  String get searchingEventText => 'We are searching where you are, care to wait a little?';

  @override
  String get weDoNotFindYou => 'We cannot find your location right now. You can choose from a list to which organization you want to give or go back and try again.';

  @override
  String get selectLocationContext => 'Give at location';

  @override
  String get changePassword => 'Change password';

  @override
  String get allowGivtLocationTitle => 'Allow Givt to access your location';

  @override
  String get allowGivtLocationMessage => 'We need your location to determine who you want to give to.\n Go to Settings > Privacy > Location Services > Set Location Services On and set Givt to \'While Using the App\'.';

  @override
  String get faqVraag10 => 'How do I change my password?';

  @override
  String get faqAntwoord10 => 'If you want to change your password, you can choose ‘Personal information’ in the menu and then press the ‘Change password’ button. We will send you an e-mail with a link to a web page where you can change your password.';

  @override
  String get editPersonalSucces => 'Your personal information is successfully updated';

  @override
  String get editPersonalFail => 'Oops, we could not update your personal information';

  @override
  String get changeEmail => 'Change e-mail address';

  @override
  String get changeIban => 'Change IBAN';

  @override
  String get smsSuccess => 'Code sent via SMS';

  @override
  String get smsFailed => 'Please try again later';

  @override
  String get kerkdienstGemistQuestion => 'How can I give with Givt through 3rd-parties?';

  @override
  String get kerkdienstGemistAnswer => 'Kerkdienst Gemist\n If you’re watching using the Kerkdienst Gemist App, you can easily give with Givt when your church uses our service. At the bottom of the page, you’ll find a small button that will take you to the Givt app. Choose an amount, confirm with \'Yes, please\' and you’re done!';

  @override
  String externalSuggestionLabel(Object value0, Object value1) {
    return 'We see you are giving from the $value0 app. Would you like to give to $value1?';
  }

  @override
  String get chooseHowIGive => 'No, I\'d like to decide how I give myself';

  @override
  String get andersGeven => 'Give differently';

  @override
  String get kerkdienstGemist => 'Kerkdienst Gemist';

  @override
  String get changePhone => 'Change mobile number';

  @override
  String get artists => 'Artists';

  @override
  String get changeAddress => 'Change address';

  @override
  String get selectLocationContextLong => 'Give based on your location';

  @override
  String get givtAtLocationDisabledTitle => 'No Givt locations found';

  @override
  String get givtAtLocationDisabledMessage => 'Sorry! At the moment, no organizations are available to give to at this location.';

  @override
  String get tempAccountLogin => 'You\'re using a temporary account without password. You will now be automatically logged in and asked to complete your registration.';

  @override
  String get sortCodePlaceholder => 'Sort code';

  @override
  String get bankAccountNumberPlaceholder => 'Bank account number';

  @override
  String get bacsSetupTitle => 'Setting up Direct Debit Instruction';

  @override
  String get bacsSetupBody => 'You are signing an incidental direct debit, we will only debit from your account when you use the Givt app to make a donation.\n \n\n By continuing, you agree that you are the account holder and are the only person required to authorise debits from this account.\n \n\n The details of your Direct Debit Instruction mandate will be sent to you by e-mail within 3 working days or no later than 10 working days before the first collection.';

  @override
  String get bacsUnderstoodNotice => 'I have read and understood the advance notice';

  @override
  String get bacsVerifyTitle => 'Verify your details';

  @override
  String get bacsVerifyBody => 'If any of the above is incorrect, please abort the registration and change your \'Personal information\'\n \n\n The company name which will appear on your bank statement against the Direct Debit will be Givt Ltd.';

  @override
  String get bacsReadDdGuarantee => 'Read Direct Debit Guarantee';

  @override
  String get bacsDdGuarantee => '- The Guarantee is offered by all banks and building societies that accept instructions to pay Direct Debits.\n - If there are any changes to the way this incidental Direct Debit Instruction is used, the organization will notify you (normally 10 working days) in advance of your account being debited or as otherwise agreed. \n - If an error is made in the payment of your Direct Debit, by the organization, or your bank or building society, you are entitled to a full and immediate refund of the amount paid from your bank or building society.\n - If you receive a refund you are not entitled to, you must pay it back when the organization asks you to.\n - You can cancel a Direct Debit at any time by simply contacting your bank or building society. Written confirmation may be required. Please also notify the organization.';

  @override
  String get bacsAdvanceNotice => 'You are signing an incidental, non-recurring Direct Debit Instruction mandate. Only on your specific request will debits be executed by the organization. All the normal Direct Debit safeguards and guarantees apply. No changes in the use of this Direct Debit Instruction can be made without notifying you at least five (5) working days in advance of your account being debited.\n In the event of any error, you are entitled to an immediate refund from your bank or building society. \n You have the right to cancel a Direct Debit Instruction at any time by writing to your bank or building society, with a copy to us.';

  @override
  String get bacsAdvanceNoticeTitle => 'Advance Notice';

  @override
  String get bacsDdGuaranteeTitle => 'Direct Debit Guarantee';

  @override
  String bacsVerifyBodyDetails(Object value0, Object value1, Object value2, Object value3, Object value4) {
    return 'Name: $value0\n Address: $value1\n E-mail address: $value2\n Sort code: $value3\n Account number: $value4\n Frequency type: Incidental, when you use the Givt app to make a donation';
  }

  @override
  String get bacsHelpTitle => 'Need help?';

  @override
  String get bacsHelpBody => 'Can\'t figure something out or you just have a question? Give us a call at +44 2037 908068 or hit us up on support@givt.co.uk and we will be in touch!';

  @override
  String bacsSortcodeAccountnumber(Object value0, Object value1) {
    return 'Sortcode: $value0\n Account number: $value1';
  }

  @override
  String get cantFetchPersonalInformation => 'We can\'t seem to fetch your personal information right now, could you try again later?';

  @override
  String get givingContextCollectionBag => 'Collection device';

  @override
  String get givingContextQrCode => 'QR code';

  @override
  String get givingContextLocation => 'Location';

  @override
  String get givingContextCollectionBagList => 'List';

  @override
  String get amountPresetsTitle => 'Amount presets';

  @override
  String get amountPresetsBody => 'Set your amount presets below.';

  @override
  String get amountPresetsResetAll => 'Reset values';

  @override
  String get amountPresetsErrGivingLimit => 'The amount is higher than your maximum amount';

  @override
  String amountPresetsErr25C(Object value0) {
    return 'The amount has to be at least $value0';
  }

  @override
  String get amountPresetsErrEmpty => 'Enter an amount';

  @override
  String alertBacsMessage(Object value0) {
    return 'Because you indicated $value0 as country choice, we assume that you prefer to give through a SEPA mandate (€), we need your IBAN for that. If you prefer to use BACS (£), we need your Sort Code and Account Number.';
  }

  @override
  String alertSepaMessage(Object value0) {
    return 'Because you indicated $value0 as country choice, we assume that you prefer to give through BACS Direct Debit (£), we need your Sort Code and Account Number for that. If you prefer to use SEPA (€), we need your IBAN.';
  }

  @override
  String get important => 'Important';

  @override
  String get fingerprintTitle => 'Fingerprint';

  @override
  String get touchId => 'Touch ID';

  @override
  String get faceId => 'Face ID';

  @override
  String get touchIdUsage => 'This is where you change the use of your Touch ID to login into the Givt app.';

  @override
  String get faceIdUsage => 'This is where you change the use of your Face ID to login into the Givt app.';

  @override
  String get fingerprintUsage => 'This is where you change the use of your fingerprint to login into the Givt app.';

  @override
  String get authenticationIssueTitle => 'Authentication problem';

  @override
  String get authenticationIssueMessage => 'We could not properly identify you. Please try again later.';

  @override
  String get authenticationIssueFallbackMessage => 'We could not properly identify you. Please log in using your access code or password.';

  @override
  String get cancelledAuthorizationMessage => 'You cancelled the authentication. Do you want to login using your access code/password?';

  @override
  String get offlineGiftsTitle => 'Offline donations';

  @override
  String get offlineGiftsMessage => 'To make sure your donations arrive on time, your internet connection needs to be activated so that the donations you made can be sent to the server.';

  @override
  String get enrollFingerprint => 'Place your finger on the sensor.';

  @override
  String fingerprintMessageAlert(Object value0, Object value1) {
    return 'Use $value0 to log in for $value1';
  }

  @override
  String get loginFingerprint => 'Login using your fingerprint';

  @override
  String get loginFingerprintCancel => 'Login using pass code/password';

  @override
  String get fingerprintStateScanning => 'Touch sensor';

  @override
  String get fingerprintStateSuccess => 'Fingerprint recognized';

  @override
  String get fingerprintStateFailure => 'Fingerprint not recognized.\n Try again.';

  @override
  String get activateBluetooth => 'Activate Bluetooth';

  @override
  String get amountTooHigh => 'Amount too high';

  @override
  String get activateLocation => 'Activate location';

  @override
  String get loginFailure => 'Login error';

  @override
  String get requestFailed => 'Request failed';

  @override
  String get resetPasswordSent => 'You should have received an e-mail with a link to reset your password. In case you do not see the e-mail right away, check your spam.';

  @override
  String get success => 'Success!';

  @override
  String get notSoFast => 'Not so fast, big spender';

  @override
  String get giftBetween30Sec => 'You already gave within 30 seconds. Can you wait a little?';

  @override
  String get android8ActivateLocation => 'Enable your location and make sure the \'High accuracy\' mode is selected.';

  @override
  String get android9ActivateLocation => 'Enable your location and make sure \'Location Accuracy\' is enabled.';

  @override
  String get nonExistingEmail => 'We have not seen this email address before. Is it possible that you registered with a different email account?';

  @override
  String get secondCollection => 'Second collection';

  @override
  String get amountTooLow => 'Amount too low';

  @override
  String get qrScanFailed => 'Aiming failed';

  @override
  String get temporaryAccount => 'Temporary account';

  @override
  String get temporaryDisabled => 'Temporarily blocked';

  @override
  String get cancelFailed => 'Cancel failed';

  @override
  String get accessDenied => 'Access denied';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get mandateFailed => 'Authorization failed';

  @override
  String qrScannedOutOfApp(Object value0) {
    return 'Hey! Great that you want to give with a QR code! Are you sure you would like to give to $value0?';
  }

  @override
  String get saveFailed => 'Saving failed';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String get giftsOverviewSent => 'We\'ve sent your donations overview to your mailbox.';

  @override
  String get giftWasBetween30S => 'Your donation was not processed because it was less than 30 sec. ago since your last donation.';

  @override
  String get promotionalQr => 'This code redirects to our webpage. You cannot use it to give within the Givt app.';

  @override
  String get promotionalQrTitle => 'Promo QR code';

  @override
  String get downloadYearOverviewByChoice => 'Do you want to download an annual overview of your donations? Choose the year below and we will send the overview to';

  @override
  String giveOutOfApp(Object value0) {
    return 'Hey! Great that you want to give with Givt! Are you sure you would like to give to $value0?';
  }

  @override
  String get mandateFailTryAgainLater => 'Something went wrong while generating the mandate. Can you try again later?';

  @override
  String get featureButtonSkip => 'Skip';

  @override
  String get featureMenuText => 'Your app from A to Z';

  @override
  String get featureMultipleNew => 'Hello, we would like to introduce a few new features to you.';

  @override
  String get featureReadMore => 'Read more';

  @override
  String featureStepTitle(Object value0, Object value1) {
    return 'Feature $value0 of $value1';
  }

  @override
  String get noticeSmsCode => 'Important!\n Please note that you have to fill in the sms code in the webpage and not in the app. When you have signed the mandate you will be automatically redirected to the app.';

  @override
  String get featurePush1Title => 'Push notifications';

  @override
  String get featurePush2Title => 'We\'ll help you through';

  @override
  String get featurePush3Title => 'Make sure they\'re switched on';

  @override
  String get featurePush1Message => 'With a push notification we can tell you something important while the app isn\'t running.';

  @override
  String get featurePush2Message => 'If there is something wrong with your account or with your gifts, we can communicate that easily and quickly.';

  @override
  String get featurePush3Message => 'And don\'t hesitate to leave them on. We only communicate about urgent matters.';

  @override
  String get featurePushInappnot => 'Tap here to read more about push notifications';

  @override
  String get featurePushNotenabledAction => 'Switch on';

  @override
  String get featurePushEnabledAction => 'I understand';

  @override
  String get termsTextGb => 'GIVT LTD \n\nTerms of use – Givt app \nLast updated: 24-11-2023\nVersion: 1.5\n\n1.  \tGeneral \nThese terms of use describe the conditions under which the mobile application Givt (\"Givt\") can be utilised. Givt allows the User (anonymously) to give donations through their smartphone, for example churches, fundraising campaigns or charities that are members of Givt Ltd.  \n\nThese terms of use apply to the use of Givt. Through the use of Givt (which means the download and the installation thereof), you (\"the User\") accept these terms of use and our privacy policy (https://givt.co.uk/privacystatementgivt-service). These terms of use and our privacy policy are also available on our website to download and print. We may revise these terms of use from time to time. \n\n2.  \tLicense and intellectual property rights \n\n2.1\tAll rights to Givt, the accompanying documentation and all modifications and extensions thereto as well as the enforcement thereof are and remain the property of Givt. The User is granted solely the rights and authorities and/or permissions ensuing from the effect of this agreement or which are assigned in writing, and you may not otherwise use, reproduce or publicly release Givt. \n\n2.2\tGivt grants the User a non-exclusive, non-sublicensable and non-transmittable license to use Givt. The User is not allowed to use Givt for commercial purposes. \n\n2.3  \tThe User may not provide Givt to third parties nor sell, rent, decompile, submit to reverse engineer or modify it without prior permission from Givt. Nor should the User, or let others, remove or bypass the technical provisions that are intended to protect Givt. \n\n2.4 \tGivt has the right to change Givt at any time, modify or remove data, deny the User the use of Givt by termination of the license, limitation of the use of Givt or deny access to Givt in whole or in part, temporarily or permanently. Givt will inform the User about this in an appropriate manner. \n\n2.5 \tThe User acquires no right, title or interest to the intellectual property rights and/or similar rights to (the means of) Givt, including the underlying software and content.\n\n3. \tThe use of Givt \n\n3.1 \tThe User can only give donations to churches, charities, fundraising campaigns and/or other legal entities that are affiliated with Givt. The donations are done anonymously. \n\n3.2  \tThe use of Givt is at your own risk and expense and should be used in accordance with the purposes for which it is intended. It is prohibited to reverse engineer the source code of Givt or to decompile and/or modify Givt, to make a copy of Givt available to any third party or to remove, delete or render illegible any designations of Givt as the party holding rights to Givt or parts thereof.\n\n3.3\tThe User is responsible for the correct submission of data such as name and address details, bank account number and other information as requested by Givt to ensure the use of Givt. \n\n3.4\tIf the User is under the age of 18 they must have the consent of their parent or legal guardian in order to use Givt. By accepting these terms of use, the User guarantees that they are 18 years of age or have the permission of their parents or legal representative. \n\n3.5 \tGivt is available for the operating systems Android and iOS. In addition to the provisions set out below, Apple’s App Store or Google Play may attach conditions to the acquisition of Givt, its use and related matters. For further information, see the terms of use and privacy policy of Apple’s App Store and Google Play as well as any other applicable terms and conditions appearing on the website of the respective provider. This end user licence is applicable to the agreement between the User and Givt and does not apply between the User and the provider of the platform through which you acquired Givt. That provider may hold you liable for violation of provisions in this end user licence, however.\n\n3.6\tAfter the User has downloaded Givt, the User is requested to register. In doing so, the User must provide the following information: (i) name (ii) address, (iii) phone number, (iv) bank account number, and (v) e-mail address. The privacy policy of Givt is applied to the processing of personal data via Givt. The User must inform Givt immediately if any of this data changes by correcting the information within the app.\n\n3.7\tThe User may, after installing the Givt app, also choose to only enter an e-mail address and immediately use the app to donate. After the donation, the User will be asked to complete the registration procedure. If the User wishes to do so later, Givt ensures to only use the User\'s e-mail address to remind the User to finish the registration procedure until this procedure is finalised.\n\n3.8 \tThe User is responsible for any expenses related to the equipment, software system and (internet) connection to make use of Givt.\n\n3.9 \tGivt provides the related services based on the information the User submits. The User is obliged to provide correct and complete information, which is not false or misleading. The User may not provide data with respect to names or bank accounts for which the User is not authorised to use. Givt and the Processor have the right to validate and verify the information the User has provided. \n\n3.10 \tThe User may at any time terminate the use of Givt, by deleting their account via the menu in the app or via mail to support@givt.app. Deleting the app from the smartphone without following aforementioned steps will not result in deletion of the User’s data. Givt can terminate the relationship with the User if the User does not comply with these terms and conditions or if Givt has not been used for 18 consecutive months. On request Givt can send a listing of all donation data. \n\n3.11 \tGivt does not charge fees for the use of Givt. \n\n3.12\tGivt has the right to adjust the offered functionalities from time to time to improve, to change or to fix errors. Givt will always work to fix errors within the Givt software, but cannot guarantee that all errors, whether or not in a timely fashion, be restored. \n\n4. \tProcessing transactions and Protecting your money\n\n4.1 \tGivt does not provide banking or payment services. To facilitate the processing of donations from the User, Givt has entered into an agreement with Access Paysuite Ltd, an Electronic Money Institution, authorised and regulated by the Financial Conduct Authority (FRN 730815) (“Access PaySuite”)(the \"Processor\"). Givt will, after the collection of donations, ensure the payment of donations to the user-designated beneficiary. The transaction data will be processed and forwarded to the Givt Processor. The Processor will initiate payment transactions whereas Givt is responsible for the transaction of the relevant amounts to the bank account of the Church/Charity as being the user-designated beneficiary of the donation.\n\n4.2 \tThe User agrees that Givt may pass the User’s (transaction and bank) data to the Processor, along with all other necessary account and personal information of the User, in order to enable the Processor to initiate the payment transactions and processing. Givt reserves the right to change the Processor at any time. The User agrees that Givt may forward the relevant information and data about the User as defined in article 4.2 to the new Processor to be able to continue processing payment transactions. \n\n4.3 \tGivt and the Processor will process the data of the User in accordance with the law and regulations that apply to data protection. For further information on how personal data is collected, processed and used, Givt refers the User to its privacy policy. This can be found at: (https://givt.co.uk/privacystatementgivt-service/).\n\n4.4 \tThe donations of the User will pass through Access PaySuite. Givt will ensure that the funds will be transferred to the beneficiary, with whom Givt has an agreement. \n\n4.5 \tThe User can reverse a debit at any time, within the terms of the User\'s bank, and the direct debit scheme. \n\n4.6 \tGivt and/or the Processor can refuse a donation if there are reasonable grounds to believe that a user is acting in violation of these terms or if there are reasonable grounds to believe that a donation is possibly suspicious or illegal. In this case Givt will inform the User as soon as possible, unless prohibited by law. \n\n4.7\tUsers of the Givt app will not be charged for their donations through our platform. Givt and the receiving party have made separate compensation arrangements pursuant to the agreement in effect between them.\n\n4.8 \tThe User agrees that Givt may pass transactional data of the User to the HMRC, along with all other necessary account and personal information of the User, in order to assist the User with their annual tax return.   \n\n4.9\tWe will hold your money in a Client Funds Account, provided by Access PaySuite. The account is segregated from our own assets. The money contained in the Client Funds Account cannot be used by Givt, invested or lent to third parties, or in any way form part of Givt’s assets.\n\n4.10\tCurrent Regulatory Provisions exclude money placed on a Client Funds Account from the UK Financial Services Compensation Scheme (FSCS).\n\n4.11\tMoney placed or held in the Client Funds Account shall not constitute a deposit (within the meaning of Article 5 of Directive 2006/48/EC) and does not earn interest.\n4.12\tDeposits and, in particular, withdrawals from the Client Funds Account will only be made in the following circumstances:\n\nIn the case of deposits:\n\nTo receive money intended for onward payment to the designated charity/charities or church(es)\nTo replenish the account where fees or other costs associated with running the account have been deducted\nTo receive refunds in the event that prior instruction to make a payment by you is cancelled, in accordance with these Terms and Conditions\n\nIn the case of withdrawals:\n\nTo pay designated charities and churches, in accordance with your instructions\nTo pay fees or other costs associated with running the account\nTo return money to you, in the event that prior instruction to make a payment by you is canceled, in accordance with these Terms and Conditions.\n\n5. \tSecurity, theft and loss \n\n5.1 \tThe User shall take all reasonable precautions safekeeping their login credentials for Givt to avoid loss, theft, misappropriation or unauthorised use of Givt on their device.\n\n5.2 \tThe User is responsible for the security of their device. Givt considers any donation from the Givt account as a user-approved transaction, regardless of the rights of the User under article 4.5.\n\n5.3 \tThe User shall inform Givt immediately via info@givt.app or +44 20 3790 8068 once their device is lost or stolen. Upon receipt of a message Givt will block the account to prevent (further) misuse. \n\n6.\tUpdates\n\n6.1\tGivt releases updates from time to time, which can rectify errors or improve the functionality of Givt. Available updates for Givt will be announced by means of notification through Apple’s App Store and Google Play and it is the User’s sole responsibility to monitor these notifications and keep informed about new updates.\n\n6.2\tAn update can stipulate conditions, which differ from the provisions in this agreement. The User will always be notified in advance so that they have the opportunity to refuse the update. By installing such an update, the User agrees to these new conditions, which will then form part of this agreement. If User does not agree to the changed conditions, they will have to cease using Givt and delete Givt from their device.\n\n7. \tLiability \n\n7.1 \tGivt has been compiled with the utmost care. Although Givt strives to make Givt available 24 hours a day, it accepts no liability if, for any reason, Givt is not available at any given time or for a certain period of time. Givt reserves the right to temporarily or permanently discontinue Givt (unannounced). The User cannot derive any rights from this. \n\n7.2 \tGivt is not liable for damage or injury resulting from the use of Givt. The limitations of liability as mentioned in this article shall lapse if the liability for damage is the result of intent or gross negligence on the part of Givt.\n\n7.3 \tThe User indemnifies Givt against any claim from third parties (for example, beneficiaries of the donations or HMRC) as a result of the use of the Givt or not correctly meeting the agreements made concerning legal or contractual obligations with Givt. The User will pay all damages and costs to Givt as a result of such claims.\n\n8. \tOther provisions \n\n8.1 \tThis agreement comes into effect on commencement of the use of Givt and will remain in force for an undetermined period from that moment. This agreement may be terminated by the User as well as by Givt at any moment, subject to one month’s notice. This agreement will end by operation of law in the event you are declared bankrupt, you apply for a moratorium on payments or a general attachment is levied against your assets, in the event of your death, or in the event you go into liquidation, are wound up or dissolved. Following the termination of this agreement (for whatever reason), you shall cease and desist from all further use of Givt. You must then delete all copies (including back-up copies) of Givt from all your devices.\n\n8.2\tIf any provision of these terms and conditions is void or destroyed, this will not affect the validity of the agreement as a whole, and other provisions of these terms remain in force. In that case, the parties will decide on a new replacement provision or provisions which will be in line with the intention of the original agreement as far as is legally possible.\n\n8.3 \tThe User is not allowed to transfer the rights and/or obligations arising from the use of Givt and these terms to third parties without prior written permission of Givt. Conversely, Givt is allowed to do so. \n\n8.4 \tWe will endeavor to resolve the dispute amicably. Any disputes arising from or in connection with these terms and conditions are finally settled in the Courts of England and Wales. \n\n8.5  \tThe Law of England and Wales is applicable on these terms of use. \n\n8.6 \tThe terms of use shall not affect the User\'s statutory rights as a consumer.\n\n8.7 \tGivt features an internal complaints procedure. Givt handles complaints efficiently and as soon as reasonably possible. Any complaint about the implementation of these conditions by Givt must be submitted in writing at Givt (via support@givt.app).\n\n\n';

  @override
  String get firstCollect => '1st collection';

  @override
  String get secondCollect => '2nd collection';

  @override
  String get thirdCollect => '3rd collection';

  @override
  String get addCollect => 'Add a collection';

  @override
  String get termsTextVersionGb => '1.3';

  @override
  String get accountDisabledError => 'Alas, it looks like your account has been deactivated. Don\'t worry! Just send a quick email to support@givt.app.';

  @override
  String get featureNewgui1Title => 'The user interface';

  @override
  String get featureNewgui2Title => 'Progress bar';

  @override
  String get featureNewgui3Title => 'Multiple collections';

  @override
  String get featureNewgui1Message => 'Quickly and easily add an amount and add or remove collections in the first screen.';

  @override
  String get featureNewgui2Message => 'Based on the progress bar at the top, you know exactly where you are in the giving process.';

  @override
  String get featureNewgui3Message => 'Add or remove collections with a single tap on a button.';

  @override
  String get featureNewguiAction => 'Okay, understood!';

  @override
  String get featureMultipleInappnot => 'Hi! We have something new for you. Do you have a minute?';

  @override
  String get policyTextGb => 'Latest Amendment: [13-03-2023]\n Version [1.1]\n Givt Inc. Privacy Policy  \n \n\n Introduction\n This Privacy Policy outlines Givt Inc.’s (“we,” “our,” or “the Company”) practices with respect to information collected from our Application\n (“App”) or from users that otherwise share personal information with us (collectively: “Users”). Click here for the Terms of Use that apply when you use the Givt app.\n \n\n Grounds for data collection\n Processing of your personal information (meaning, any information relating to an identified or identifiable individual; hereinafter “Personal\n Information”) is necessary for the performance of our contractual obligations towards you and providing you with our services, to protect\n our legitimate interests and for compliance with legal and financial regulatory obligations to which we are subject.\n When you use our App or register yourself or an organization you represent with us, you consent to the collection, storage, use, disclosure and other uses of your Personal Information as described in this Privacy Policy.\n We encourage our Users to carefully read the Privacy Policy and use it to make informed decisions.\n \n\n What information do we collect?\n We collect two types of data and information from Users. The first type of information is un-identified and non-identifiable information pertaining to a User(s), which may be made available or gathered via your use of the App (“Non-personal Information”). We are not aware of the identity of a User from which the Non-personal Information was collected. Non-personal Information which is being collected may include your aggregated usage information and technical information transmitted by your device, including certain software and\n hardware information (e.g. language preference, access time, etc.) in order to enhance the functionality of our App.\n The second type of information is Personal Information, which is personally identifiable information, namely information that identifies an\n individual or may with reasonable effort identify an individual. Such information includes:\n ● Device Information: We collect Personal Information from your device. Such information includes geolocation data, IP address, unique identifiers (e.g. MAC address and UUID) and other information which relates to your activity through the App.\n ● Service User Information: We collect additional information for individuals who would like to use our Services. This is gathered\n through the App and includes all the information needed to register for our service:\n – Name and address,\n – Date of birth,\n – email address,\n – secured password details, and\n – bank details for the purposes of making payments.\n ● Contact information: If you choose to contact us you will be asked to provide us with certain details such as: full name; e-mail or physical address, and other relevant information. This may be for yourself or for people in the organization you represent.\n \n\n \n\n How do we receive information about you?\n \n\n We receive your Personal Information from various sources:\n \n\n ● When you voluntarily provide us with your personal details in order to register on our App;\n ● When you use or access our App in connection with your use of our services;\n When you use or access our Dashboard in connection with your organization’s use of our services;\n ● From third party providers, services and public registers (for example, traffic analytics vendors); and,\n ● Through diagnostic information from the App. The App will send us anonymous information about its functioning. This information contains non-personal data from your smartphone like its type and operating system, but also the version information of the App. This data is solely used for purposes of improving our Service or allowing better responses to your questions.\n What do we do with the information we collect?\n We may use the information for the following:\n ● To provide the services through the App – we will use a minimum of name and bank details to perform the services of effecting payment(s) via the App. Payment information is never shared with intended recipients of donations;\n ● Communicating with you – sending you notices regarding our services, providing you with technical information and responding to\n any customer service issue you may have; to keep you informed of our latest updates and services;\n ● Conducting statistical and analytical activities, intended to improve the App and/or the App.\n ● For marketing and advertising purposes, such as developing and providing promotional and advertising materials that may be relevant,\n valuable or otherwise of interest to you.\n In addition to the different uses listed above, we may transfer or disclose Personal Information to our subsidiaries, affiliated companies and subcontractors in relation to services that we provide to you. We may also disclose information if we have good faith to believe that\n disclosure of such information is helpful or reasonably necessary to: (i) comply with any applicable law, regulation, legal process or governmental request; (ii) enforce our policies (including our Agreement), including investigations of potential violations thereof; (iii) investigate, detect, prevent, or take action regarding illegal activities or other wrongdoing, suspected fraud or security issues; (iv) to establish or exercise our rights to defend against legal claims; (v) prevent harm to the rights, property or safety of us, our users, yourself or any third party; or (vi) for the purpose of collaborating with law enforcement agencies and/or in case we find it necessary in order to enforce intellectual property or other legal rights.\n \n\n \n\n Providing Data to Third Parties\n When you make a donation, personal information about you, your name, the amount, campaign and email address is shared with the intended recipient of your donation. In some cases, you may have the option to remain anonymous. If you choose to remain anonymous, your personal information will not be shared with the intended recipient of your donation.\n We may provide your information to our partners. For example, we may share any information we receive with vendors and service providers retained in connection with the provision of the App. If you use the App to make a donation, your payment-related information, such as credit card or other financial information, is collected by our third-party payment processor on our behalf. In all cases, these parties are necessary to provide the services.\n We may collect, use, and share anonymous data for statistical purposes, reviews, and comparisons; no such data will be traceable to individuals.\n We are committed to making it easier for donors to give to charities of their choosing, and we will never sell data to third parties.\n We may access, preserve, and disclose your information if we believe doing so is required or appropriate to: (a) comply with law enforcement requests and legal process, such as a court order or subpoena; (b) respond to your requests; or (c) protect your, our, or others’ rights, property, or safety.\n We may transfer your information to service providers, advisors, potential transactional partners, or other third parties in connection with the consideration, negotiation, or completion of a corporate transaction in which we are acquired by or merged with another company or we sell, liquidate, or transfer all or a portion of our assets. The use of your information following any of these events will be governed by the provisions of this Privacy Policy in effect at the time the applicable information was collected.\n We may also disclose your information with your permission.\n \n\n User Rights\n You may request to:\n 1.Receive confirmation as to whether or not personal information concerning you is being processed, and access your stored personal information, together with supplementary information.\n 2.Receive a copy of personal information you directly volunteer to us in a structured, commonly used and machine-readable format.\n 3.Request rectification of your personal information that is in our control.\n 4.Request erasure of your personal information.\n 5.Object to the processing of personal information by us.\n 6.Request portability of your personal information.\n 7.Request to restrict processing of your personal information by us.\n 8.Lodge a complaint with a supervisory authority.\n \n\n However, please note that these rights are not absolute, and may be subject to our own legitimate interests and regulatory requirements.\n Before fulfilling your request, we may ask you to provide reasonable information to verify your identity.\n \n\n Retention\n We will retain your personal information for as long as necessary to provide our services, and as necessary to comply with our legal\n obligations, resolve disputes, and enforce our policies. Retention periods will be determined taking into account the type of information that is collected and the purpose for which it is collected, bearing in mind the requirements applicable to \n Use of Location Services\n The App may use the location services as provided by the operating system on the smartphone. With these services, the App may determine the location of the user. The location data will not be sent anywhere outside the smartphone, and is solely used to determine whether the user is in a location where it’s possible to use the App for donating. The locations where one can use App are downloaded to the smartphone prior to using the location services.\n \n\n How do we safeguard your information?\n We take security measures to reduce misuse of and unauthorized access to personal data. Although we take reasonable steps to safeguard information, we cannot be responsible for the acts of those who gain unauthorized access or abuse our App, and we make no warranty, express, implied or otherwise, that we will prevent such access.\n \n\n Transfer of data outside the EEA\n Please note that some data recipients may be located outside the EEA. In such cases we will transfer your data only to such countries as approved by the European Commission as providing adequate level of data protection, or enter into legal agreements ensuring an adequate level of data protection. Data collected from Users located in the United States is stored in the United States.\n \n\n Advertisements\n We do not use third-party advertising technology to serve advertisements when you access the App.\n \n\n Marketing\n We may use your Personal Information, such as your name, email address to send you a Newsletter about our products and services. You may opt out of receiving this Newsletter at any time by unsubscribing via the link in the newsletter.\n Children’s Privacy\n We do not knowingly collect, maintain, or use personal information from children under 13 years of age, and no part of our App is directed to children. If you learn that a child has provided us with personal information in violation of this Privacy Policy, then you may alert us at\n support@givt.app.\n Third Parties\n The App may contain links to other websites, products, or services that we do not own or operate. We are not responsible for the privacy\n practices of these third parties. Please be aware that this Privacy Policy does not apply to your activities on these third-party services or any information you disclose to these third parties. We encourage you to read their privacy policies before providing any information to them.\n \n\n Updates or amendments to this Privacy Policy\n We reserve the right to periodically amend or revise the Privacy Policy; material changes will be effective immediately upon the display of the revised Privacy policy. The last revision will be reflected in the “Last modified” section. If we materially change the ways in which we use or share personal information collected from you, we will notify you through the App, by email, or other communication. Your continued use of our Services following the notification of such amendments on our Website or through the App, constitutes your acknowledgment and consent of such amendments to the Privacy Policy and your agreement to be bound by the terms of such amendments.\n \n\n How to contact us\n If you have any general questions about the App or the information we collect about you and how we use it, you can contact us at:\n support@givt.app or by phone at +1 918-615-9611.';

  @override
  String get amount => 'Choose amount';

  @override
  String get amountLimit => 'Determine the maximum amount of your Givt';

  @override
  String get cancel => 'Cancel';

  @override
  String get changePincode => 'Change your access code';

  @override
  String get checkInbox => 'Success! Check your inbox.';

  @override
  String get city => 'City/Town';

  @override
  String get contactFailed => 'Something went wrong. Try again or select the recipient manually.';

  @override
  String get country => 'Country';

  @override
  String get email => 'Email address';

  @override
  String get errorTextRegister => 'Something went wrong while creating your account. Try a different email address.';

  @override
  String get fieldsNotCorrect => 'One of the entered fields is not correct.';

  @override
  String get firstName => 'First name';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get forgotPasswordText => 'Enter your email address. We will send you an e-mail with the information on how to change your password.\n \n\n If you can\'t find the email right away, please check your spam.';

  @override
  String get give => 'Give';

  @override
  String get selectReceiverButton => 'Select';

  @override
  String get giveLimit => 'Maximum amount';

  @override
  String get givingSuccess => 'Thank you for your Givt!\n You can check the status in your overview.';

  @override
  String get information => 'Personal info';

  @override
  String get lastName => 'Last Name';

  @override
  String get loggingIn => 'Logging in ...';

  @override
  String get login => 'Login';

  @override
  String get loginPincode => 'Enter your access code.';

  @override
  String get loginText => 'To get access to your account we would like to make sure that you are you.';

  @override
  String get logOut => 'Logout';

  @override
  String get makeContact => 'This is the Givt-moment.\n Move your phone towards the \n collection box, bag or basket.';

  @override
  String get next => 'Next';

  @override
  String get noThanks => 'No thanks';

  @override
  String get notifications => 'Notifications';

  @override
  String get password => 'Password';

  @override
  String get passwordRule => 'The password should contain at least 7 characters including at least one capital and one digit.';

  @override
  String get phoneNumber => 'Mobile number';

  @override
  String get postalCode => 'Postal Code';

  @override
  String get ready => 'Done';

  @override
  String get register => 'Register';

  @override
  String get registerBusy => 'Registering ...';

  @override
  String get registerPage => 'Register to access your Givt info.';

  @override
  String get registerPersonalPage => 'In order to process your donations,\n we need some personal information.';

  @override
  String get registerPincode => 'Enter your access code.';

  @override
  String get registrationSuccess => 'Registration successful.\n Have fun giving!';

  @override
  String get security => 'Security';

  @override
  String get send => 'Send';

  @override
  String get settings => 'Settings';

  @override
  String get somethingWentWrong => 'Whoops, something went wrong.';

  @override
  String get streetAndHouseNumber => 'Street name and number';

  @override
  String get tryAgain => 'Try again';

  @override
  String get welcome => 'Welcome';

  @override
  String get wrongCredentials => 'Invalid email address or password. Is it possible that you registered with a different email account?';

  @override
  String get yesPlease => 'Yes, please';

  @override
  String get bluetoothErrorMessage => 'Switch on Bluetooth so you\'re ready to give to a collection.';

  @override
  String get connectionError => 'Currently we\'re not able to connect to the server. No worries, have a cup of tea and/or check your settings.';

  @override
  String get save => 'Save';

  @override
  String get acceptPolicy => 'Ok, Givt is permitted to save my data.';

  @override
  String get close => 'Close';

  @override
  String get sendViaEmail => 'Send by e-mail';

  @override
  String get termsTitle => 'Our Terms of Use';

  @override
  String get shortSummaryTitleTerms => 'It comes down to:';

  @override
  String get fullVersionTitleTerms => 'Terms of Use';

  @override
  String get termsText => 'Terms of use – Givt app \nLast updated: 24-11-2023\nEnglish translation of version 1.10\n\n1. General \nThese terms of use describe the conditions under which the mobile application Givt (\"Givt\") can be utilised. Givt allows the User (anonymously) to give donations through their smartphone, for example churches, fundraising campaigns and charities that are members of Givt. Givt is managed by Givt B.V., a private company, located in Lelystad (8243 PR), Noordersluisweg 27, registered in the trade register of the Chamber of Commerce under number 64534421 (\"Givt B.V.\"). These terms of use apply to the use of Givt. Through the use of Givt (which means the download and the installation thereof), you (\"The user\") accept these terms of use and our privacy policy (www.givtapp.net/privacyverklaringgivt). These terms of use and our privacy policy are also available on our website to download and print. We may revise these terms of use from time to time. \n\n\n2.License and intellectual property rights\n2.1 All rights to Givt, the accompanying documentation and all modifications and extensions thereto as well as the enforcement thereof are and remain the property of Givt B.V. The user is granted solely the rights and authorities and/or permissions ensuing from the effect of this agreement or which are assigned in writing, and you may not otherwise use, reproduce or publicly release Givt. \n\n2.2 Givt B.V. grants the User a non-exclusive, non-sublicensable and non-transmittable license to use Givt. The User is not allowed to use Givt for commercial purposes. \n\n2.3 The User may not provide Givt to third parties nor sell, rent, decompile, submit to reverse engineer or modify it without prior permission from Givt B.V. Nor should the User, or let others, remove or bypass the technical provisions that are intended to protect Givt. \n\n2.4 Givt B.V. has the right to change Givt at any time, modify or remove data, deny the User the use of Givt by termination of the license, limitation of the use of Givt or deny access to Givt in whole or in part, temporarily or permanently. Givt B.V. will inform the User about this in an appropriate manner. \n\n2.5 The User acquires no right, title or interest to the intellectual property rights and/or similar rights to (the means of) Givt, including the underlying software and content.\n\n\n3. The use of Givt \n3.1 The User can only give donations to churches, charities, fundraising campaigns and/or other legal entities that are affiliated with Givt. The donations are done anonymously.\n \n3.2 The use of Givt is at your own risk and expense and should be used in accordance with the purposes for which it is intended. It is prohibited to reverse engineer the source code of Givt or to decompile and/or modify Givt, to make a copy of Givt available to any third party or to remove, delete or render illegible any designations of Givt B.V. as the party holding rights to Givt or parts thereof.\n\n3.3 The User is responsible for the correct submission of data such as name and address details, bank account number and other information as requested by Givt B.V. to ensure the use of Givt. \n\n3.4 If the User is under the age of 18 he/she must have have the consent of their parent or legal guardian in order to use Givt. By accepting these terms of use, the User guarantees that they are 18 years of age or has the permission of their parents or legal representative. \n\n3.5 Givt is available for the operating systems Android and iOS. In addition to the provisions set out below, Apple’s App Store or Google Play may attach conditions to the acquisition of Givt, its use and related matters. For further information, see the terms of use and privacy policy of Apple’s App Store and Google Play as well as any other applicable terms and conditions appearing on the website of the respective provider. This end user licence is applicable to the agreement between the User and Givt B.V. and does not apply between the User and the provider of the platform through which you acquired Givt. That provider may hold you liable for violation of provisions in this end user licence, however. \n\n3.6 After the User has downloaded Givt, the User is requested to register. In doing so, the User must provide the following information: (i) name (ii) address, (iii) phone number, (iv) bank account number and (v) e-mail address. The privacy policy of Givt B.V. is applied to the processing of personal data via Givt. The User must inform Givt immediately if any of this data changes by correcting the information within the app.\n\n3.7 The User may, after installing the Givt app, also choose to only enter an e-mail address and immediately use the app to donate. After the donation, the User will be asked to complete the registration procedure. If the User wishes to do so later, Givt B.V. ensures to only use the User\'s e-mail address to remind the User to finish the registration procedure until this procedure is finalised.\n\n3.8 The User is responsible for any expenses related to the equipment, software system and (internet) connection to make use of Givt.\n\n3.9 Givt B.V. provides the related services based on the information the User submits. The User is obliged to provide correct and complete information, which is not false or misleading. The User may not provide data with respect to names or bank accounts for which the User is not authorised to use. Givt B.V. and the Processor have the right to validate and verify the information the User has provided. \n\n3.10 The User may at any time terminate the use of Givt, by deleting their account via the menu in the app or via mail to support@givt.app. Deleting the app from the smartphone without following aforementioned steps will not result in deletion of the User’s data. Givt can terminate the relationship with the User if the User does not comply with these terms and conditions or if Givt has not been used for 18 consecutive months. On request Givt can send a listing of all donation data. \n\n3.11 Givt B.V. does not charge the User fees for the use of Givt. \n\n3.12 Givt B.V. has the right to adjust the offered functionalities from time to time to improve, to change or to fix errors. Givt B.V. will always work to fix errors within the Givt software, but cannot guarantee that all errors, whether or not in a timely fashion, be restored. \n\n\n4. Processing transactions \n4.1 Givt B.V. is not a bank/financial institution and does not provide banking or payment processor services. To facilitate the processing of donations from the User, Givt B.V. has entered into an agreement with a payment service provider called SlimPay. SlimPay is a financial institution (the \"Processor\") with which it was agreed that Givt B.V. sends the transaction information to the Processor in order to initiate and to handle donations. Givt B.V. will, after the collection of donations, ensure the payment of donations to the user-designated beneficiary. The transaction data will be processed and forwarded to the Givt Processor. The Processor will initiate payment transactions whereas Givt B.V. is responsible for the transaction of the relevant amounts to the bank account of the Church/Foundation as being the user-designated beneficiary of the donation.\n\n4.2 The User agrees that Givt B.V. may pass the User’s (transaction and bank) data to the Processor, along with all other necessary account and personal information of the User, in order to enable the Processor to initiate the payment transactions and processing. Givt B.V. reserves the right to change of Processor at any time. The User agrees that Givt B.V. may forward the relevant information and data about the User as defined in article 3.6 to the new Processor to be able to continue processing payment transactions. \n\n4.3 Givt B.V. and the Processor will process the data of the User in accordance with the law and regulations that applies to data protection. For further information on how personal data is collected, processed and used, Givt B.V. refers the User to its privacy policy. This policy can be found online (www.givtapp.net/en/privacystatementgivt-service/).\n\n4.4 The donations of the User will pass through Givt B.V. as an intermediary. Givt B.V. will ensure that the funds will be transferred to the beneficiary, with whom Givt B.V. has an agreement. \n\n4.5 The User must authorise Givt B.V. and/or the Processor (for automatic SEPA debit) to make a donation with Givt. The User can at all times, within the terms of the User\'s bank, revert a debit. \n\n4.6 Givt B.V. and/or the Processor can refuse a donation if there are reasonable grounds to believe that a user is acting in violation of these terms or if there are reasonable grounds to believe that a donation is possibly suspicious or illegal. In this case Givt B.V. will inform the User as soon as possible, unless prohibited by law. \n\n4.7 Users of the Givt app will not be charged for their donations through our platform. Givt and the receiving party have made separate compensation arrangements pursuant to the agreement in effect between them.\n\n4.8 The User agrees that Givt B.V. (transaction) may pass data of the User to the local tax authorities, along with all other necessary account and personal information of the User, in order to assist the User with his/her annual tax return.   \n\n\n5. Security, theft and loss \n5.1 The User shall take all reasonable precautions safekeeping their login credentials for Givt to avoid loss, theft, misappropriation or unauthorised use of Givt on their smartphone. \n\n5.2 The User is responsible for the security of his/her smartphone. Givt B.V.t considers any donation from the Givt account as a user-approved transaction, regardless of the rights of the User under article 4.5.\n\n5.3 The User shall inform Givt B.V. immediately via info@givt.app or +31 320 320 115 once their smartphone is lost or stolen. Upon receipt of a message Givt B.V. will block the account to prevent (further) misuse. \n\n6. Updates\n6.1 Givt B.V. releases updates from time to time, which can rectify errors or improve the functionality of Givt. Available updates for Givt will be announced by means of notification through Apple’s App Store and Google Play and it is the User’s sole responsibility to monitor these notifications and keep informed about new updates.\n\n6.2 An update can stipulate conditions, which differ from the provisions in this agreement. This will always be notified to the User in advance so that they have the opportunity to refuse the update. By installing such an update, the User agrees to these new conditions, which will then form part of this agreement. If User does not agree to the changed conditions, they have to cease using Givt and have to delete Givt from their device.\n\n7. Liability \n7.1 Givt has been compiled with the utmost care. Although Givt B.V. strives to make Givt available 24 hours a day, it accepts no liability if, for any reason, Givt is not available at any given time or for a certain period of time. Givt B.V. reserves the right to temporarily or permanently discontinue Givt (unannounced). The User cannot derive any rights from this. \n\n7.2 Givt B.V. is not liable for damage or injury resulting from the use of Givt. The limitations of liability as mentioned in this article shall lapse if the liability for damage is the result of intent or gross negligence on the part of Givt B.V.\n\n7.3 The User indemnifies Givt B.V. against any claim from third parties (for example, beneficiaries of the donations or the tax authority) as a result of the use of the Givt or not correctly meeting the agreements made concerning legal or contractual obligations with Givt B.V. The User will pay all damages and costs to Givt B.V. as a result of such claims.\n\n8. Other provisions \n8.1 This agreement comes into effect on commencement of the use of Givt and will remain in force for an undetermined period from that moment. This agreement may be terminated by the User as well as by Givt B.V. at any moment, subject to one month’s notice. This agreement will end by operation of law in the event you are declared bankrupt, you apply for a moratorium on payments or a general attachment is levied against your assets, in the event of your death, or in the event you go into liquidation, are wound up or dissolved. Following the termination of this agreement (for whatever reason), you shall cease and desist from all further use of Givt. You must then delete all copies (including back-up copies) of Givt from all your devices.\n\n8.2 If any provision of these terms and conditions is void or destroyed, this will not affect the validity of the agreement as a whole, and other provisions of these terms remain in force. In that case, the parties will decide on a new replacement provision or provisions which will be in line with the intention of the original agreement as far as is legally possible. \n\n8.3 The User is not allowed to transfer the rights and/or obligations arising from the use of Givt and these terms to third parties without prior written permission of Givt B.V. Conversely, Givt B.V. is allowed to do so. \n\n8.4 Any disputes arising from or in connection with these terms are finally settled in the Court of Lelystad. Before the dispute will be referred to court, we will endeavor to resolve the dispute amicably. \n\n8.5 The Dutch law is applicable on these terms of use. \n\n8.6 The terms of use shall not affect the User\'s statutory rights as a consumer.\n\n8.7 Givt B.V. features an internal complaints procedure. Givt B.V. handles complaints efficiently and as soon as reasonably possible. Any complaint about the implementation of these conditions by Givt B.V. must be submitted in writing at Givt B.V. (via support@givt.app).\n\n';

  @override
  String get prepareMobileTitle => 'Before you start';

  @override
  String get prepareMobileExplained => 'For an optimal experience with Givt, we require your permission in order to send notifications.';

  @override
  String get prepareMobileSummary => 'This way you\'ll know where and when you can give.';

  @override
  String get policyText => 'Latest Amendment: [13-03-2023]\n Version [1.1]\n Givt Inc. Privacy Policy  \n \n\n Introduction\n This Privacy Policy outlines Givt Inc.’s (“we,” “our,” or “the Company”) practices with respect to information collected from our Application\n (“App”) or from users that otherwise share personal information with us (collectively: “Users”). Click here for the Terms of Use that apply when you use the Givt app.\n \n\n Grounds for data collection\n Processing of your personal information (meaning, any information relating to an identified or identifiable individual; hereinafter “Personal\n Information”) is necessary for the performance of our contractual obligations towards you and providing you with our services, to protect\n our legitimate interests and for compliance with legal and financial regulatory obligations to which we are subject.\n When you use our App or register yourself or an organization you represent with us, you consent to the collection, storage, use, disclosure and other uses of your Personal Information as described in this Privacy Policy.\n We encourage our Users to carefully read the Privacy Policy and use it to make informed decisions.\n \n\n What information do we collect?\n We collect two types of data and information from Users. The first type of information is un-identified and non-identifiable information pertaining to a User(s), which may be made available or gathered via your use of the App (“Non-personal Information”). We are not aware of the identity of a User from which the Non-personal Information was collected. Non-personal Information which is being collected may include your aggregated usage information and technical information transmitted by your device, including certain software and\n hardware information (e.g. language preference, access time, etc.) in order to enhance the functionality of our App.\n The second type of information is Personal Information, which is personally identifiable information, namely information that identifies an\n individual or may with reasonable effort identify an individual. Such information includes:\n ● Device Information: We collect Personal Information from your device. Such information includes geolocation data, IP address, unique identifiers (e.g. MAC address and UUID) and other information which relates to your activity through the App.\n ● Service User Information: We collect additional information for individuals who would like to use our Services. This is gathered\n through the App and includes all the information needed to register for our service:\n – Name and address,\n – Date of birth,\n – email address,\n – secured password details, and\n – bank details for the purposes of making payments.\n ● Contact information: If you choose to contact us you will be asked to provide us with certain details such as: full name; e-mail or physical address, and other relevant information. This may be for yourself or for people in the organization you represent.\n \n\n \n\n How do we receive information about you?\n \n\n We receive your Personal Information from various sources:\n \n\n ● When you voluntarily provide us with your personal details in order to register on our App;\n ● When you use or access our App in connection with your use of our services;\n When you use or access our Dashboard in connection with your organization’s use of our services;\n ● From third party providers, services and public registers (for example, traffic analytics vendors); and,\n ● Through diagnostic information from the App. The App will send us anonymous information about its functioning. This information contains non-personal data from your smartphone like its type and operating system, but also the version information of the App. This data is solely used for purposes of improving our Service or allowing better responses to your questions.\n What do we do with the information we collect?\n We may use the information for the following:\n ● To provide the services through the App – we will use a minimum of name and bank details to perform the services of effecting payment(s) via the App. Payment information is never shared with intended recipients of donations;\n ● Communicating with you – sending you notices regarding our services, providing you with technical information and responding to\n any customer service issue you may have; to keep you informed of our latest updates and services;\n ● Conducting statistical and analytical activities, intended to improve the App and/or the App.\n ● For marketing and advertising purposes, such as developing and providing promotional and advertising materials that may be relevant,\n valuable or otherwise of interest to you.\n In addition to the different uses listed above, we may transfer or disclose Personal Information to our subsidiaries, affiliated companies and subcontractors in relation to services that we provide to you. We may also disclose information if we have good faith to believe that\n disclosure of such information is helpful or reasonably necessary to: (i) comply with any applicable law, regulation, legal process or governmental request; (ii) enforce our policies (including our Agreement), including investigations of potential violations thereof; (iii) investigate, detect, prevent, or take action regarding illegal activities or other wrongdoing, suspected fraud or security issues; (iv) to establish or exercise our rights to defend against legal claims; (v) prevent harm to the rights, property or safety of us, our users, yourself or any third party; or (vi) for the purpose of collaborating with law enforcement agencies and/or in case we find it necessary in order to enforce intellectual property or other legal rights.\n \n\n \n\n Providing Data to Third Parties\n When you make a donation, personal information about you, your name, the amount, campaign and email address is shared with the intended recipient of your donation. In some cases, you may have the option to remain anonymous. If you choose to remain anonymous, your personal information will not be shared with the intended recipient of your donation.\n We may provide your information to our partners. For example, we may share any information we receive with vendors and service providers retained in connection with the provision of the App. If you use the App to make a donation, your payment-related information, such as credit card or other financial information, is collected by our third-party payment processor on our behalf. In all cases, these parties are necessary to provide the services.\n We may collect, use, and share anonymous data for statistical purposes, reviews, and comparisons; no such data will be traceable to individuals.\n We are committed to making it easier for donors to give to charities of their choosing, and we will never sell data to third parties.\n We may access, preserve, and disclose your information if we believe doing so is required or appropriate to: (a) comply with law enforcement requests and legal process, such as a court order or subpoena; (b) respond to your requests; or (c) protect your, our, or others’ rights, property, or safety.\n We may transfer your information to service providers, advisors, potential transactional partners, or other third parties in connection with the consideration, negotiation, or completion of a corporate transaction in which we are acquired by or merged with another company or we sell, liquidate, or transfer all or a portion of our assets. The use of your information following any of these events will be governed by the provisions of this Privacy Policy in effect at the time the applicable information was collected.\n We may also disclose your information with your permission.\n \n\n User Rights\n You may request to:\n 1.Receive confirmation as to whether or not personal information concerning you is being processed, and access your stored personal information, together with supplementary information.\n 2.Receive a copy of personal information you directly volunteer to us in a structured, commonly used and machine-readable format.\n 3.Request rectification of your personal information that is in our control.\n 4.Request erasure of your personal information.\n 5.Object to the processing of personal information by us.\n 6.Request portability of your personal information.\n 7.Request to restrict processing of your personal information by us.\n 8.Lodge a complaint with a supervisory authority.\n \n\n However, please note that these rights are not absolute, and may be subject to our own legitimate interests and regulatory requirements.\n Before fulfilling your request, we may ask you to provide reasonable information to verify your identity.\n \n\n Retention\n We will retain your personal information for as long as necessary to provide our services, and as necessary to comply with our legal\n obligations, resolve disputes, and enforce our policies. Retention periods will be determined taking into account the type of information that is collected and the purpose for which it is collected, bearing in mind the requirements applicable to \n Use of Location Services\n The App may use the location services as provided by the operating system on the smartphone. With these services, the App may determine the location of the user. The location data will not be sent anywhere outside the smartphone, and is solely used to determine whether the user is in a location where it’s possible to use the App for donating. The locations where one can use App are downloaded to the smartphone prior to using the location services.\n \n\n How do we safeguard your information?\n We take security measures to reduce misuse of and unauthorized access to personal data. Although we take reasonable steps to safeguard information, we cannot be responsible for the acts of those who gain unauthorized access or abuse our App, and we make no warranty, express, implied or otherwise, that we will prevent such access.\n \n\n Transfer of data outside the EEA\n Please note that some data recipients may be located outside the EEA. In such cases we will transfer your data only to such countries as approved by the European Commission as providing adequate level of data protection, or enter into legal agreements ensuring an adequate level of data protection. Data collected from Users located in the United States is stored in the United States.\n \n\n Advertisements\n We do not use third-party advertising technology to serve advertisements when you access the App.\n \n\n Marketing\n We may use your Personal Information, such as your name, email address to send you a Newsletter about our products and services. You may opt out of receiving this Newsletter at any time by unsubscribing via the link in the newsletter.\n Children’s Privacy\n We do not knowingly collect, maintain, or use personal information from children under 13 years of age, and no part of our App is directed to children. If you learn that a child has provided us with personal information in violation of this Privacy Policy, then you may alert us at\n support@givt.app.\n Third Parties\n The App may contain links to other websites, products, or services that we do not own or operate. We are not responsible for the privacy\n practices of these third parties. Please be aware that this Privacy Policy does not apply to your activities on these third-party services or any information you disclose to these third parties. We encourage you to read their privacy policies before providing any information to them.\n \n\n Updates or amendments to this Privacy Policy\n We reserve the right to periodically amend or revise the Privacy Policy; material changes will be effective immediately upon the display of the revised Privacy policy. The last revision will be reflected in the “Last modified” section. If we materially change the ways in which we use or share personal information collected from you, we will notify you through the App, by email, or other communication. Your continued use of our Services following the notification of such amendments on our Website or through the App, constitutes your acknowledgment and consent of such amendments to the Privacy Policy and your agreement to be bound by the terms of such amendments.\n \n\n How to contact us\n If you have any general questions about the App or the information we collect about you and how we use it, you can contact us at:\n support@givt.app or by phone at +1 918-615-9611.';

  @override
  String get needHelpTitle => 'Need help?';

  @override
  String get findAnswersToYourQuestions => 'Here you\'ll find answers to your questions and useful tips';

  @override
  String get questionHowDoesRegisteringWorks => 'How does registration work?';

  @override
  String get questionWhyAreMyDataStored => 'Why does Givt store my personal information?';

  @override
  String get faQvraag1 => 'What is Givt?';

  @override
  String get faQvraag2 => 'How does Givt work?';

  @override
  String get faQvraag3 => 'How can I change my settings or personal information?';

  @override
  String get faQvraag4 => 'Where can I use Givt?';

  @override
  String get faQvraag5 => 'How will my donation be withdrawn?';

  @override
  String get faQvraag6 => 'What are the possibilities using Givt?';

  @override
  String get faQvraag7 => 'How safe is donating with Givt?';

  @override
  String get faQvraag8 => 'How can I delete my Givt account?';

  @override
  String get faQantwoord1 => 'Donating with your smartphone\n Givt is the solution for giving with your smartphone when you are not carrying cash. Everyone owns a smartphone and with the Givt app you can easily participate in the offering. \n It’s a personal and conscious moment, as we believe that making a donation is not just a financial transaction. Using Givt feels as natural as giving cash. \n \n\n Why \'Givt\'?\n The name Givt was chosen because it is about ‘giving’ as well as giving a ‘gift’. We were looking for a modern and compact name that looks friendly and playful. In our logo you might notice that the green bar combined with the letter ‘v’ forms the shape of an offering bag, which gives an idea of the function. \n \n\n There is a team of specialists behind Givt in the Netherlands, Belgium and the United Kingdom. Each one of us is actively working on the development and improvement of Givt. Read more about us on www.givt.app.';

  @override
  String get faQantwoord2 => 'The first step was installing the app. For Givt to work effectively, it’s important that you enable Bluetooth and have a working internet connection. \n \n\n Then register yourself by filling in your information and adding your card details. \n You’re ready to give! Open the app, select an amount, and scan a QR code, move your phone towards the collection bag or basket, or select a cause from the list.\n Your chosen amount will be saved, withdrawn from your account and distributed to the church or collecting charities.\n \n\n If you don’t have an internet connection when making your donation, the donation will be sent at a later time when you re-open the app. Like when you are in a WiFi zone.';

  @override
  String get faQantwoord3 => 'You can access the app menu by tapping the menu at the top left of the ‘Amount’ screen. To change your settings, you have to log in using your e-mail address and password, fingerprint/Touch ID or a FaceID. In the menu you can find an overview of your donations, adjust your maximum amount, review and/or change your personal information, change your amount presets, fingerprint/Touch ID or FaceID, or terminate your Givt account.';

  @override
  String get faQantwoord4 => 'More and more organizations\n You can use Givt in all organizations that are registered with us. More organizations are joining every week.\n \n\n Not registered yet? \n If your organization is not affiliated with Givt yet, please contact us at +1 918-615-9611 or info@givt.app.';

  @override
  String get faQantwoord5 => 'WePay - a Chase company\n When installing Givt, you give the app authorisation to debit your account. The transactions are handled by WePay – a Chase company that specializes in processing payments.\n \n\n Reversible\n We believe giving should never come with obligations. We\'re therefore happy to reverse any donations you\'ve made. Simply contact us through the contact field in the menu to get in touch.';

  @override
  String get faQantwoord6 => 'Continues to develop\n Givt continues to develop their service. Right now you can easily give during the offering using your smartphone, but it doesn\'t stop there. Curious to see what we are working on? Join us for one of our Friday morning demos.\n \n\n Tax return\n At the end of the year you can request an overview of all your donations, which makes it easier for you when it comes to tax filing.';

  @override
  String get faQantwoord7 => 'Safe and risk-free \n It is very important to us that everything is safe and risk free. Each user has a personal account with its own password. You need to login to view or change your settings.\n \n\n Handling transactions \n The transactions are handled by WePay – a Chase company that specializes in processing payments.\n \n\n Immune to fraud \n When installing Givt, you give the app authorisation to debit your account. Since these transactions are reversible, it is completely safe and immune to fraud. \n \n\n Overview \n Organizations can login to the Givt dashboard. This dashboard gives an overview of all financial transactions, from the moment of giving up to the full processing of the payment. In this way any collection can be followed from start to finish.\n Organizations can see how many people used Givt, but not who they are.';

  @override
  String get faQantwoord8 => 'We are sorry to hear that! We would like to hear why.\n \n\n If you no longer want to use Givt, you can unsubscribe for all Givt services.\n To unsubscribe, go to your settings via the user menu and choose ‘Terminate my account’.';

  @override
  String get privacyTitle => 'Privacy Statement';

  @override
  String get acceptTerms => 'By continuing you agree to our terms and conditions.';

  @override
  String get mandateSigingFailed => 'The mandate has not been signed successfully. Try again later via the menu. Does this alert keep appearing? Feel free to contact us at support@givt.app';

  @override
  String get awaitingMandateStatus => 'We just need a moment to process your mandate.';

  @override
  String get requestMandateFailed => 'At the moment it is not possible to request a mandate. Please try again in a few minutes.';

  @override
  String get faqHowDoesGivingWork => 'How can I give?';

  @override
  String get faqHowDoesManualGivingWork => 'How can I select the recipient?';

  @override
  String givtNotEnough(Object value0) {
    return 'Sorry, but the minimum amount we can work with is $value0.';
  }

  @override
  String get slimPayInformationPart2 => 'That\'s why we ask you this one time to sign a SEPA eMandate.\n \n\n Since we\'re working with mandates, you have the option to revoke your donation if you should wish to do so.';

  @override
  String get unregister => 'Terminate account';

  @override
  String get unregisterInfo => 'We’re sad to see you go! We will delete all your personal information.';

  @override
  String get unregisterSad => 'We\'re sad to see you leave\n and we hope to see you again.';

  @override
  String get historyTitle => 'Donations history';

  @override
  String get historyInfoTitle => 'Donation details';

  @override
  String get historyAmountAccepted => 'In process';

  @override
  String get historyAmountCancelled => 'Cancelled by user';

  @override
  String get historyAmountDenied => 'Refused by bank';

  @override
  String get historyAmountCollected => 'Processed';

  @override
  String get loginSuccess => 'Have fun giving!';

  @override
  String get historyIsEmpty => 'This is where you\'ll find information about your donations, but first you\'ll need to start giving';

  @override
  String get errorEmailTooLong => 'Sorry, your email address is too long.';

  @override
  String get updateAlertTitle => 'Update available';

  @override
  String get updateAlertMessage => 'A new version of Givt is available, do you want to update now?';

  @override
  String get criticalUpdateTitle => 'Critical update';

  @override
  String get criticalUpdateMessage => 'A new critical update is available. This is necessary for the proper functioning of the Givt app.';

  @override
  String organisationProposalMessage(Object value0) {
    return 'Do you want to give to $value0?';
  }

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get faQvraag9 => 'Where can I see the overview of my donations?';

  @override
  String get faQantwoord9 => 'Press the menu at the top left to access your app menu. To get access you have to login using your e-mail address and password. Choose ‘Donations history’ to find an overview of your recent activity. This list consists of the name of the recipient, time, and date. The coloured line indicates the status of the donation: In process, processed, refused by bank, or cancelled by user.\n You can request an overview of your donations for your tax filing at the end of each year.';

  @override
  String get faqQuestion11 => 'How do I set my Touch ID or Face ID?';

  @override
  String get faqAnswer11 => 'Go to your settings by pressing menu in the top left of the screen. There you can protect your Givt app with a passcode, fingerprint/Touch ID or a FaceID. \n \n\n When one of these settings is activated, you can use it to access your settings instead of using your e-mail address and password. However, when you\'ve forgotten your passcode, you need your e-mail address and password to make a new one.';

  @override
  String get answerHowDoesRegistrationWork => 'To use Givt, you have to register in the Givt app. Go to your app menu and choose \'Finish registration\'. You set up a Givt account, fill in some personal details and give permission to collect the donations made with the app. The transactions are handled by WePay, a Chase company that specializes in processing payments. When your registration is complete, you are ready to give. You only need your login details to see or change your settings.';

  @override
  String get answerHowDoesGivingWork => 'From now on, you can give with ease. Open the app, choose the amount you want to give, and select 1 of the 4 possibilities: you can give to a collection device, scan a QR code, choose from a list, or give at your location. \n Don\'t forget to finish your registration, so your donations can be delivered to the right charity.';

  @override
  String get answerHowDoesManualGivingWork => 'When you aren’t able to give to a collection device, you can choose to select the recipient manually. Choose an amount and press ‘Next’. Next, select ‘Choose from the list’ and select \'Churches\', \'Charities\', \'Campaigns\' or \'Artists\'. Now choose a recipient from one of these lists and press ‘Give’.';

  @override
  String get informationPersonalData => 'Givt needs this personal data to process your gifts. We are careful with this information. You can read it in our privacy statement.';

  @override
  String get informationAboutUs => 'Givt is a product of Givt B.V.\n \n\n We are located on the Schutweg 47 in Lelystad, The Netherlands. For questions or complaints you can reach us via +31 320 320 115 or support@givtapp.net.\n \n\n We are registered in the trade register of the Dutch Chamber of Commerce under number 64534421.';

  @override
  String get titleAboutGivt => 'About Givt / Contact';

  @override
  String get sendAnnualReview => 'Send annual review';

  @override
  String get infoAnnualReview => 'Here you can receive the annual review of your donations over 2016.\n The annual review can be used for your tax declaration.';

  @override
  String get sendByEmail => 'Send by e-mail';

  @override
  String get whyPersonalData => 'Why this personal data?';

  @override
  String get readPrivacy => 'Read privacy statement';

  @override
  String get faqQuestion12 => 'How long does it take before my donation is withdrawn from my bank account?';

  @override
  String get faqAnswer12 => 'Your donation will be withdrawn from your bank account within two working days.';

  @override
  String get faqQuestion14 => 'How can I give to multiple collections?';

  @override
  String get faqAnswer14 => 'Are there multiple collections in one service? Even then you can easily give in one move!\n By pressing the ‘Add collection’-button, you can activate up to three collections. For each collection, you can enter your own amount. Choose your collection you want to adjust and enter your specific amount or use the presets. You can delete a collection by pressing the minus sign, located to the right of the amount.\n \n\n The numbers 1, 2 or 3 distinguish the different collections. No worries, your church knows which number corresponds to which collection purpose. Multiple collections are very handy, because all your gifts are sent immediately with your first donation. In the overview you can see a breakdown of all your donations.\n \n\n Do you want to skip a collection? Leave it open or remove it.';

  @override
  String get featureMultipleCollections => 'News! Now you can give to three different collections in one go. Are you feeling the pinch this month? Just leave a collection open or remove it. Want to know more? Check our FAQ.';

  @override
  String get featureIGetItButton => 'Always good to give';

  @override
  String get ballonActiveerCollecte => 'Here you can add up to three collections';

  @override
  String get ballonVerwijderCollecte => 'A collection can be removed by tapping fast twice';

  @override
  String get needEmailToGive => 'We need some identification to allow you to give with Givt';

  @override
  String get giveFirst => 'Give first';

  @override
  String get go => 'Go';

  @override
  String get faQvraag15 => 'Are my Givt donations tax deductible?';

  @override
  String get faQantwoord15 => 'Yes, your Givt donations are tax deductible, but only when you’re giving to churches or other organizations registered as 501 (c) (3) organizations. Check if the church or charity has such a registration. Since it’s quite a bit of work to gather all your donations for your tax declaration, the Givt app offers you the option to annually download an overview of your donations. Go to your Donations in the app menu to download the overview. You can use this overview for your tax filing. It’s a piece of cake.';

  @override
  String get giveDiffWalkthrough => 'Having some trouble? Tap here to pick an organization from the list.';

  @override
  String get faQvraag17 => 'Can\'t find your question here?';

  @override
  String get faQantwoord17 => 'Send us a message from within the app (\"About Givt / Contact\"), an e-mail at support@givt.app or give us a call at +1 918-615-9611.';

  @override
  String get noCameraAccessCelebration => 'To be able to support the giving event, we need access to your camera.';

  @override
  String get yesCool => 'Yes, cool!';

  @override
  String get faQvraag18 => 'How does Givt handle my personal information? (GDPR)';

  @override
  String get faqAntwoord18 => 'Givt fully complies with the EU GDPR requirements. GDPR stands for General Data Protection Regulation and is a strict European framework for protecting consumer data rights.\n \n\n Wondering what this means for you? It means that we handle your information with care, that you have the right to know which information we keep on record, have the right to change this information, have the right to demand from us that we do not store your information, and that you may know why we need your personal information.\n \n\n Why we need your personal data:\n Card details: We need your payment information to debit the donations you make. E-mail address: We use your e-mail address to create your Givt account. You can use your e-mail address and password to log in.\n \n\n If you would like to know more, please read our privacy statement.';

  @override
  String get fingerprintCancel => 'Cancel';

  @override
  String get faQuestAnonymity => 'x';

  @override
  String get faQanswerAnonymity => 'x';

  @override
  String get amountPresetsChangingPresets => 'You can add amount presets to your keyboard. This is where you can enable and set the amount presets.';

  @override
  String get amountPresetsChangePresetsMenu => 'Change amount presets';

  @override
  String get featureNewguiInappnot => 'Tap here to read more about the renewed user interface!';

  @override
  String get givtCompanyInfo => 'Givt is a product of Givt Inc\n\nWe are located at 100 S Cincinnati Ave, Fifth Floor, Tulsa, OK 74103. \nFor questions or complaints you can reach us via +1 918-615-9611 or support@givt.app\n\n We are incorporated in Delaware.';

  @override
  String get givtCompanyInfoGb => 'Givt is a product of Givt Ltd.\n Our office is located on Bongerd 159 in Lelystad, the Netherlands. \n For questions or complaints you can reach us via support@givt.co.uk\n \n\n We are registered under Company Number (CRN): 11396586.';

  @override
  String get celebrationHappyToSeeYou => 'Let\'s celebrate your Givt together!';

  @override
  String get celebrationQueueText => 'Just leave the app open and wait for the countdown to start.';

  @override
  String get celebrationQueueCancel => 'Give without participating';

  @override
  String get celebrationEnablePushNotification => 'Activate push notifications';

  @override
  String get faqButtonAccessibilityLabel => 'Frequently asked questions';

  @override
  String get progressBarStepOne => 'Step 1';

  @override
  String get progressBarStepTwo => 'Step 2';

  @override
  String get progressBarStepThree => 'Step 3';

  @override
  String removeCollectButtonAccessibilityLabel(Object value0) {
    return 'Remove the $value0';
  }

  @override
  String get removeBtnAccessabilityLabel => 'Erase';

  @override
  String get progressBarStepFour => 'Stap 3';

  @override
  String get changeBankAccountNumberAndSortCode => 'Change bank details';

  @override
  String get updateBacsAccountDetailsError => 'Alas, the Sortcode or Account number is invalid. You can change the Sortcode and/or Account number under ‘Personal information’ in the menu.';

  @override
  String get ddiFailedTitle => 'DDI request failed';

  @override
  String get ddiFailedMessage => 'At the moment it is not possible to request a Direct Debit Instruction. Please try again in a few minutes.';

  @override
  String get faQantwoord5Gb => 'Handling transactions\n The transactions are handled by Access PaySuite; a payment institution specialised in processing BACS Direct Debit Instructions. Access PaySuite is under the supervision of the Financial Conduct Authority.\n \n\n Revertible afterwards\n The transactions take place afterwards via a direct debit under Givt Ltd. We want to emphasise that no transactions take place in the moment of giving. Since these transactions are revocable, it is completely safe and immune to fraud.';

  @override
  String get faQvraag15Gb => 'Can I Gift Aid my donations?';

  @override
  String get faQantwoord15Gb => 'Yes, you can. In the Givt app you can enable Gift Aid. You can also always see how much Gift Aid has been claimed on your donations.\n \n\n Donating through Gift Aid means charities can claim an extra 25p for every £1 you give. It will not cost you any extra.';

  @override
  String get answerHowDoesRegistrationWorkGb => 'To start giving, all you need is an e-mail address. Once you have entered this, you are ready to give.\n \n\n Please note: you need to fully register to ensure that all your previous and future donations can be processed. Go to the menu in the app and choose ‘Complete registration’. Here, you set up a Givt account by filling in your personal information and by us giving permission to debit the donations made in the app. Those transactions are processed by Access PaySuite, who are specialised in direct debits. \n \n\n When your registration is complete, you are ready to give with the Givt app. You only need your login details to see or change your settings.';

  @override
  String get faQantwoord7Gb => 'Registered Small Payment Institution\n Givt Ltd. is registered with the Financial Conduct Authority as a Small Payment Institution (823261). This means you can be confident that the way we conduct our business is transparent and secure and that the people running the company have been thoroughly checked.\n \n\n Personal safety\n It is very important to us that everything is safe and risk free. Each user has a personal account with its own password. You need to log in to view or change your settings.\n \n\n Handling transactions\n The transactions are handled by Access PaySuite; a payment institution specialised in processing BACS Direct Debit Instructions. Just like Givt Ltd., Access PaySuite is under the supervision of the Financial Conduct Authority.\n \n\n Immune to fraud\n When installing Givt, the user gives the app authorisation to debit their account. We want to emphasise that no transactions take place in the moment of giving. The transactions take place afterwards via a direct debit under Givt Ltd. Since these transactions are revocable, it is completely safe and immune to fraud.\n \n\n Overview\n Individual users can see an overview of their donations in the app. Organizations can log in to the Givt dashboard. This dashboard gives an overview of all financial transactions, from the moment of giving up to the full processing of the payment. In this way any collection can be followed from start to finish. Organizations can see how many people used Givt, but not who they are.';

  @override
  String get faQantwoord18Gb => 'Givt fully complies with the GDPR requirements. GDPR stands for General Data Protection Regulation.\n \n\n Wondering what this means for you? It means that we handle your information with care, that you have the right to know which information we keep on record, have the right to change this information, have the right to demand from us that we do not store your information, and that you may know why we need your personal information.\n \n\n If you would like to know more, please read our privacy statement.';

  @override
  String get giftAidSetting => 'I want to use/keep using Gift Aid';

  @override
  String get giftAidInfo => 'As a UK taxpayer, you can use the Gift Aid initiative. Every year we will remind you of your choice. Activating Gift Aid after March 1st will count towards March and the next tax year. All your donations made before entering your account details will be considered eligible if they were made in the current tax year.';

  @override
  String get giftAidHeaderDisclaimer => 'When you enable this option, you agree to the following:';

  @override
  String get giftAidBodyDisclaimer => 'I am a UK taxpayer and understand that if I pay less Income Tax and/or Capital Gains Tax in the current tax year than the amount of Gift Aid claimed on all my donations, it is my responsibility to pay any difference.';

  @override
  String get giftAidInfoTitle => 'What is Gift Aid?';

  @override
  String get giftAidInfoBody => 'Donating through Gift Aid means charities can claim an extra 25p for every £1 you give. It will not cost you any extra. \n \n\n Gift Aid treats the donations as being made after deduction of income tax at the basic rate. The charity you give to can reclaim this basic rate income tax paid on the gift from HMRC. Your donations will qualify as long as they’re not more than 4 times what you have paid in tax in that tax year. \n  \n For more info, please go to: www.gov.uk/donating-to-charity/gift-aid';

  @override
  String get faqAnswer12Gb => 'Your donation will be withdrawn from your bank account within five working days. The first time you make a donation with Givt, the donation will be withdrawn after two weeks, as it takes extra time to set up your registration.';

  @override
  String get faqVraagDdi => 'Does the Direct Debit mean I signed up to monthly deductions?';

  @override
  String get faqAntwoordDdi => 'NO! You sign a direct debit so we can deduct the donations you have made using the Givt app. The deductions we make are incidental, user-driven deductions.\n \n\n We will not debit your account unless you make a donation using the Givt app.';

  @override
  String get giftAidUnsavedChanges => 'You have unsaved changes, do you want to go back to save the changes or dismiss these changes?';

  @override
  String get giftAidChangeLater => 'Later on, you can change this option in the menu under \'Personal Info\'.';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get importantMessage => 'Important mention';

  @override
  String get celebrationQueueCancelAlertBody => 'Are you sure you don\'t want to celebrate with us?';

  @override
  String get celebrationQueueCancelAlertTitle => 'Too bad!';

  @override
  String get historyInfoLegendaAccessibilityLabel => 'Info explanation';

  @override
  String get historyDownloadAnnualOverviewAccessibilityLabel => 'Download annual overview of donations (mail)';

  @override
  String get bluetoothErrorMessageEvent => 'With Bluetooth, you can find your location even with no/poor GPS connection, thanks to location-beacons. \n Activate your Bluetooth now!';

  @override
  String get processCashedGivtNamespaceInvalid => 'We see that you have made a non-processed gift to an organization that, sadly, doesn\'t use Givt anymore. This gift will be deleted.';

  @override
  String get suggestionNamespaceInvalid => 'Your last selected cause doesn\'t support Givt anymore.';

  @override
  String get charity => 'Charity';

  @override
  String get artist => 'Artist';

  @override
  String get church => 'Church';

  @override
  String get campaign => 'Campaign';

  @override
  String get giveYetDifferently => 'Choose from the list';

  @override
  String giveToNearestBeacon(Object value0) {
    return 'Give to: $value0';
  }

  @override
  String get jersey => 'Jersey';

  @override
  String get guernsey => 'Guernsey';

  @override
  String get countryStringBe => 'Belgium';

  @override
  String get countryStringNl => 'Netherlands';

  @override
  String get countryStringDe => 'Germany';

  @override
  String get countryStringGb => 'United Kingdom';

  @override
  String get countryStringFr => 'France';

  @override
  String get countryStringIt => 'Italy';

  @override
  String get countryStringLu => 'Luxembourg';

  @override
  String get countryStringGr => 'Greece';

  @override
  String get countryStringPt => 'Portugal';

  @override
  String get countryStringEs => 'Spain';

  @override
  String get countryStringFi => 'Finland';

  @override
  String get countryStringAt => 'Austria';

  @override
  String get countryStringCy => 'Cyprus';

  @override
  String get countryStringEe => 'Estonia';

  @override
  String get countryStringLv => 'Latvia';

  @override
  String get countryStringLt => 'Lithuania';

  @override
  String get countryStringMt => 'Malta';

  @override
  String get countryStringSi => 'Slovenia';

  @override
  String get countryStringSk => 'Slovakia';

  @override
  String get countryStringIe => 'Ireland';

  @override
  String get countryStringAd => 'Andorra';

  @override
  String get errorChangePostalCode => 'You\'ve entered a post code that is unknown. Please change it under \"Personal information\" in the menu.';

  @override
  String get informationAboutUsGb => 'Givt is a product of Givt LTD.\n \n\n We are located at the Blackthorn House in Birmingham, England. For questions or complaints you can reach us via 020 3790 8068 or support@givt.co.uk\n \n\n We are registered under the Company Registration Number 11396586.';

  @override
  String get bluetoothErrorMessageAction => 'On it';

  @override
  String get bluetoothErrorMessageCancel => 'Rather not';

  @override
  String get authoriseBluetooth => 'Authorise Givt to use Bluetooth';

  @override
  String get authoriseBluetoothErrorMessage => 'Give Givt permission to access your Bluetooth so you\'re ready to give to a collection.';

  @override
  String get authoriseBluetoothExtraText => 'Go to Settings > Privacy > Bluetooth and select \'Givt\'.';

  @override
  String get unregisterError => 'Alas, we are unable to unregister your account. Could you try again later?';

  @override
  String get unregisterMandateError => 'Alas, we are unable to unregister your account because we are unable to cancel your mandate or direct debit instruction. Please contact us.';

  @override
  String get unregisterErrorTitle => 'Terminate failed';

  @override
  String get setupRecurringGiftTitle => 'Set up your recurring donation';

  @override
  String get setupRecurringGiftText3 => 'from';

  @override
  String get setupRecurringGiftText4 => 'until';

  @override
  String get setupRecurringGiftText5 => 'or';

  @override
  String get add => 'Add';

  @override
  String get subMenuItemFirstDestinationThenAmount => 'One-off donation';

  @override
  String get faqQuestionFirstTargetThenAmount1 => 'What is \"Give to a good cause\"?';

  @override
  String get faqAnswerFirstTargetThenAmount1 => '\"Give to a good cause\" is a new functionality in your Givt-app. It works exactly as you are used with us, but now you first choose the good cause and then the amount. Handy!';

  @override
  String get faqQuestionFirstTargetThenAmount2 => 'Why can I only choose a good cause from the list?';

  @override
  String get faqAnswerFirstTargetThenAmount2 => '\"Giving to a good cause\" is brand new and still under construction. New functionalities are continuous being added in time.';

  @override
  String get setupRecurringGiftText2 => 'to';

  @override
  String get setupRecurringGiftText1 => 'I want to give every';

  @override
  String get setupRecurringGiftWeek => 'week';

  @override
  String get setupRecurringGiftMonth => 'month';

  @override
  String get setupRecurringGiftQuarter => 'quarter';

  @override
  String get setupRecurringGiftYear => 'year';

  @override
  String get setupRecurringGiftWeekPlural => 'weeks';

  @override
  String get setupRecurringGiftMonthPlural => 'months';

  @override
  String get setupRecurringGiftQuarterPlural => 'quarters';

  @override
  String get setupRecurringGiftYearPlural => 'years';

  @override
  String get menuItemRecurringDonation => 'Recurring donations';

  @override
  String get setupRecurringGiftHalfYear => 'half year';

  @override
  String get setupRecurringGiftText6 => 'times';

  @override
  String get loginAndTryAgain => 'Please log in and try again.';

  @override
  String givtIsBeingProcessedRecurring(Object value0, Object value1, Object value2, Object value3, Object value4) {
    return 'Thank you for your Givt(s) to $value0!\n You can check the overview of your recurring donations under \'Overview\'.\n The first recurring donation of $value1 $value2 will be initiated on $value3.\n After that it will be withdrawn each $value4.';
  }

  @override
  String get overviewRecurringDonations => 'Recurring donations';

  @override
  String get titleRecurringGifts => 'Recurring donations';

  @override
  String get recurringGiftsSetupCreate => 'Schedule your';

  @override
  String get recurringGiftsSetupRecurringGift => 'recurring donation';

  @override
  String get recurringDonationYouGive => 'you give';

  @override
  String recurringDonationStops(Object value0) {
    return 'This will stop on $value0';
  }

  @override
  String get selectRecipient => 'Select recipient';

  @override
  String get setupRecurringDonationFailed => 'The recurring donation was not set up successfully. Please try again later.';

  @override
  String get emptyRecurringDonationList => 'All your recurring donations will be visible here.';

  @override
  String cancelRecurringDonationAlertTitle(Object value0) {
    return 'Are you sure you want to stop donating to $value0?';
  }

  @override
  String get cancelRecurringDonationAlertMessage => 'The donations already made will not be cancelled.';

  @override
  String get cancelRecurringDonation => 'Stop';

  @override
  String get setupRecurringGiftText7 => 'Each';

  @override
  String get cancelRecurringDonationFailed => 'The recurring donation was not cancelled successfully. Please try again later.';

  @override
  String get pushnotificationRequestScreenTitle => 'Push notifications';

  @override
  String get pushnotificationRequestScreenDescription => 'We would like to keep you posted on when the next donation will be collected from your account. At the moment we don\'t have permission to send you messages. Could you change that setting, please?';

  @override
  String get pushnotificationRequestScreenButtonYes => 'Yes, I will change my settings';

  @override
  String get reportMissingOrganisationListItem => 'Report a missing organization';

  @override
  String get reportMissingOrganisationPrefilledText => 'Hi! I would really like to give to:';

  @override
  String get featureRecurringDonations1Title => 'Plan your recurring donations to charities';

  @override
  String get featureRecurringDonations2Title => 'You\'re in control';

  @override
  String get featureRecurringDonations3Title => 'Overview';

  @override
  String get featureRecurringDonations1Description => 'You can now plan your recurring donations, with the end date already selected.';

  @override
  String get featureRecurringDonations2Description => 'You can see all the recurring donations you have planned and stop them whenever you want.';

  @override
  String get featureRecurringDonations3Description => 'All your one off and recurring donations in one overview. Useful for yourself and for tax purposes.';

  @override
  String get featureRecurringDonations3Button => 'Show me!';

  @override
  String get featureRecurringDonationsNotification => 'Hi! Would you also like to set up a recurring donation with this app? Take a quick look at what we have built.';

  @override
  String get setupRecurringDonationFailedDuplicate => 'The recurring donation was not set up successfully. You have already made a donation to this organization with the same repeating period.';

  @override
  String get setupRecurringDonationFailedDuplicateTitle => 'Duplicate donation';

  @override
  String get goToListWithRecurringDonationDonations => 'Overview';

  @override
  String get recurringDonationsEmptyDetailOverview => 'This is where you\'ll find information about your donations, but the first donation still has to be collected';

  @override
  String get recurringDonationFutureDetailSameYear => 'Upcoming donation';

  @override
  String get recurringDonationFutureDetailDifferentYear => 'Upcoming donation in';

  @override
  String get pushnotificationRequestScreenPrimaryDescription => 'We would like to keep you posted on when the next donation will be collected from your account. At the moment we don\'t have permission to send you messages. Could you allow that, please?';

  @override
  String get pushnotificationRequestScreenPrimaryButtonYes => 'Ok, fine!';

  @override
  String get discoverSearchButton => 'Search';

  @override
  String get discoverDiscoverButton => 'See all';

  @override
  String get discoverSegmentNow => 'Give';

  @override
  String get discoverSegmentWho => 'Discover';

  @override
  String get discoverHomeDiscoverTitle => 'Choose category';

  @override
  String get discoverOrAmountActionSheetOnce => 'One-off donation';

  @override
  String get discoverOrAmountActionSheetRecurring => 'Recurring donation';

  @override
  String reccurringGivtIsBeingProcessed(Object value0) {
    return 'Thank you for your recurring donation to $value0!\n To see all the information, go to \'Recurring donations\' in the menu.';
  }

  @override
  String get setupRecurringGiftTextPlaceholderDate => 'dd / mm / yy';

  @override
  String get setupRecurringGiftTextPlaceholderTimes => 'x';

  @override
  String get amountLimitExceededRecurringDonation => 'This amount is higher than your chosen maximum amount. Do you want to continue or change the amount?';

  @override
  String get appStoreRestart => '';

  @override
  String sepaVerifyBodyDetails(Object value0, Object value1, Object value2, Object value3) {
    return 'Name: $value0\n Address: $value1\n E-mail address: $value2\n IBAN: $value3\n We only use the eMandate when you use the Givt app to make a donation';
  }

  @override
  String get sepaVerifyBody => 'If any of the above is incorrect, please abort the registration and change your \'Personal information\'';

  @override
  String get signMandate => 'Sign mandate';

  @override
  String get signMandateDisclaimer => 'By continuing you sign the eMandate with above details.\n The mandate will be sent to you via mail.';

  @override
  String get budgetSummaryBalance => 'My giving this month';

  @override
  String get budgetSummarySetGoal => 'Set a giving goal to motivate yourself.';

  @override
  String get budgetSummaryGiveNow => 'Give now!';

  @override
  String get budgetSummaryGivt => 'Given within Givt';

  @override
  String get budgetSummaryNotGivt => 'Given outside Givt';

  @override
  String get budgetSummaryShowAll => 'Show all';

  @override
  String get budgetSummaryMonth => 'Monthly';

  @override
  String get budgetSummaryYear => 'Annually';

  @override
  String get budgetExternalGiftsTitle => 'Giving outside Givt';

  @override
  String get budgetExternalGiftsInfo => 'Get a complete overview of all of your contributions. Add any contributions that you have made outside of Givt. You will find everything in your summary.';

  @override
  String get budgetExternalGiftsSubTitle => 'Your donations outside Givt';

  @override
  String get budgetExternalGiftsOrg => 'Name of organization';

  @override
  String get budgetExternalGiftsTime => 'Frequency';

  @override
  String get budgetExternalGiftsAmount => 'Amount';

  @override
  String get budgetExternalGiftsAdd => 'Add';

  @override
  String get budgetExternalGiftsSave => 'Save';

  @override
  String get budgetGivingGoalTitle => 'Setup giving goal';

  @override
  String get budgetGivingGoalInfo => 'Give consciously. Consider each month whether your giving behavior matches your personal giving goals.';

  @override
  String get budgetGivingGoalMine => 'My giving goal';

  @override
  String get budgetGivingGoalTime => 'Period';

  @override
  String get budgetSummaryGivingGoalMonth => 'Monthly giving goal';

  @override
  String get budgetSummaryGivingGoalEdit => 'Edit giving goal';

  @override
  String get budgetSummaryGivingGoalRest => 'Remaining giving goal';

  @override
  String get budgetSummaryGivingGoal => 'Giving goal:';

  @override
  String get budgetMenuView => 'My personal summary';

  @override
  String get budgetSummarySetGoalBold => 'Give consciously';

  @override
  String get budgetExternalGiftsInfoBold => 'Gain insight into what you give';

  @override
  String get budgetGivingGoalInfoBold => 'Set giving goal';

  @override
  String get budgetGivingGoalRemove => 'Remove giving goal';

  @override
  String get budgetSummaryNoGifts => 'You have no donations (yet) this month';

  @override
  String get budgetTestimonialSummary => '”Since I’ve been using the summary, I have gained more insight into what I give. I give more consciously because of it.\"';

  @override
  String get budgetTestimonialGivingGoal => '”My giving goal motivates me to regularly reflect on my giving behavior.”';

  @override
  String get budgetTestimonialExternalGifts => '\"I like that I can add any external donations to my summary. I can now simply keep track of my giving.\"';

  @override
  String get budgetTestimonialYearlyOverview => '\"Givt\'s annual overview is great! I\'ve also added all my donations outside Givt. This way I have all my giving in one overview, which is essential for my tax return.\"';

  @override
  String get budgetPushMonthly => 'See what you have given this month.';

  @override
  String get budgetPushYearly => 'View your annual overview and see what you have given so far.';

  @override
  String get budgetTooltipGivingGoal => 'Give consciously. Consider each month whether your giving behavior matches your personal giving goals.';

  @override
  String get budgetTooltipExternalGifts => 'Add what you\'re donating outside of Givt. Everything will appear in your summary. With all your donations included you\'ll get the best insight.';

  @override
  String get budgetTooltipYearly => 'One overview for the tax return? View the overview of all your donations here.';

  @override
  String get budgetPushMonthlyBold => 'Your monthly summary is ready.';

  @override
  String get budgetPushYearlyBold => '2021 is almost over ... Have you made up your balance?';

  @override
  String get budgetExternalGiftsListAddEditButton => 'Manage external donations';

  @override
  String get budgetExternalGiftsFrequencyOnce => 'Once';

  @override
  String get budgetExternalGiftsFrequencyMonthly => 'Every month';

  @override
  String get budgetExternalGiftsFrequencyQuarterly => 'Every 3 months';

  @override
  String get budgetExternalGiftsFrequencyHalfYearly => 'Every 6 months';

  @override
  String get budgetExternalGiftsFrequencyYearly => 'Every year';

  @override
  String get budgetExternalGiftsEdit => 'Edit';

  @override
  String get budgetTestimonialSummaryName => 'Willem:';

  @override
  String get budgetTestimonialGivingGoalName => 'Danielle:';

  @override
  String get budgetTestimonialExternalGiftsName => 'Johnson:';

  @override
  String get budgetTestimonialYearlyOverviewName => 'Jonathan:';

  @override
  String get budgetTestimonialSummaryAction => 'View your summary';

  @override
  String get budgetTestimonialGivingGoalAction => 'Setup your giving goal';

  @override
  String get budgetTestimonialExternalGiftsAction => 'Add external donations';

  @override
  String get budgetSummaryGivingGoalReached => 'Giving goal achieved';

  @override
  String get budgetExternalDonationToHighAlertTitle => 'Wow, generous giver?!';

  @override
  String get budgetExternalDonationToHighAlertMessage => 'Hi generous giver, this amount is higher than we expected here. Lower your amount or let us know that we have to change this maximum of 99 999.';

  @override
  String get budgetExternalDonationToLongAlertTitle => 'Too much';

  @override
  String get budgetExternalDonationToLongAlertMessage => 'Hold your horses! This field can only take 30 characters max.';

  @override
  String get budgetSummaryNoGiftsExternal => 'Donations outside Givt this month? Add here';

  @override
  String get budgetYearlyOverviewGivenThroughGivt => 'Total within Givt';

  @override
  String get budgetYearlyOverviewGivenThroughNotGivt => 'Total outside Givt';

  @override
  String get budgetYearlyOverviewGivenTotal => 'Total';

  @override
  String get budgetYearlyOverviewGivenTotalTax => 'Total tax relief';

  @override
  String get budgetYearlyOverviewDetailThroughGivt => 'Within Givt';

  @override
  String get budgetYearlyOverviewDetailAmount => 'Amount';

  @override
  String get budgetYearlyOverviewDetailDeductable => 'Deductible';

  @override
  String get budgetYearlyOverviewDetailTotal => 'Total';

  @override
  String get budgetYearlyOverviewDetailTotalDeductable => 'Deductible';

  @override
  String get budgetYearlyOverviewDetailNotThroughGivt => 'Outside Givt';

  @override
  String get budgetYearlyOverviewDetailTotalThroughGivt => '(within Givt)';

  @override
  String get budgetYearlyOverviewDetailTotalNotThroughGivt => '(outside Givt)';

  @override
  String get budgetYearlyOverviewDetailTipBold => 'TIP: add your external donations';

  @override
  String get budgetYearlyOverviewDetailTipNormal => 'to get a total overview of what you give, both via the Givt app and not via the Givt app.';

  @override
  String get budgetYearlyOverviewDetailReceiveViaMail => 'Receive by e-mail';

  @override
  String get budgetYearlyOverviewDownloadButton => 'Download annual overview';

  @override
  String get budgetExternalDonationsTaxDeductableSwitch => 'Deductible';

  @override
  String get budgetYearlyOverviewGivingGoalPerYear => 'Annual giving goal';

  @override
  String get budgetYearlyOverviewGivenIn => 'Given in';

  @override
  String get budgetYearlyOverviewRelativeTo => 'Relative to the total in';

  @override
  String get budgetYearlyOverviewVersus => 'Versus';

  @override
  String get budgetYearlyOverviewPerOrganisation => 'Per organization';

  @override
  String get budgetSummaryNoGiftsYearlyOverview => 'You have no donations (yet) this year';

  @override
  String budgetPushYearlyNearlyEndBold(Object value0) {
    return '$value0 is almost over... Have you made up your balance yet?';
  }

  @override
  String get budgetPushYearlyNearlyEnd => 'View your annual overview and see what you have given so far.';

  @override
  String get budgetPushYearlyNewYearBold => 'Have you made up your balance yet?';

  @override
  String get budgetPushYearlyNewYear => 'View your annual overview and see what you have given in the past year.';

  @override
  String get budgetPushYearlyFinalBold => 'Your annual overview is now ready!';

  @override
  String get budgetPushYearlyFinal => 'View your annual overview and see what you have given in the past year.';

  @override
  String get budgetTestimonialYearlyOverviewAction => 'Go to the overview';

  @override
  String get duplicateAccountOrganisationMessage => 'Are you sure you are using your own bank details? Could you please check in the menu, under \'Personal information\'? You can change the information there as well, if necessary.';

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
  String get usRegistrationPersonalDetailsLastnamePlaceholder => 'Last Name';

  @override
  String get usRegistrationTaxTitle => 'A few more details for your annual statement.';

  @override
  String get usRegistrationTaxSubtitle => 'Your name and Zip code will only be used to create your statement. By default, you will remain anonymous to the recipient.';

  @override
  String get policyTextUs => '1. Givt App – US Privacy Policy\n Latest Amendment: [13-03-2023]\n Version [1.1]\n Givt Inc. Privacy Policy  \n \n\n Introduction\n This Privacy Policy outlines Givt Inc.’s (“we,” “our,” or “the Company”) practices with respect to information collected from our Application\n (“App”) or from users that otherwise share personal information with us (collectively: “Users”). Click here for the Terms of Use that apply when you use the Givt app.\n Grounds for data collection\n Processing of your personal information (meaning, any information relating to an identified or identifiable individual; hereinafter “Personal\n Information”) is necessary for the performance of our contractual obligations towards you and providing you with our services, to protect\n our legitimate interests and for compliance with legal and financial regulatory obligations to which we are subject.\n When you use our App or register yourself or an organization you represent with us, you consent to the collection, storage, use, disclosure and other uses of your Personal Information as described in this Privacy Policy.\n We encourage our Users to carefully read the Privacy Policy and use it to make informed decisions.\n What information do we collect?\n We collect two types of data and information from Users. The first type of information is un-identified and non-identifiable information pertaining to a User(s), which may be made available or gathered via your use of the App (“Non-personal Information”). We are not aware of the identity of a User from which the Non-personal Information was collected. Non-personal Information which is being collected may include your aggregated usage information and technical information transmitted by your device, including certain software and\n hardware information (e.g. language preference, access time, etc.) in order to enhance the functionality of our App.\n The second type of information is Personal Information, which is personally identifiable information, namely information that identifies an\n individual or may with reasonable effort identify an individual. Such information includes:\n Device Information: We collect Personal Information from your device. Such information includes geolocation data, IP address, unique identifiers (e.g. MAC address and UUID) and other information which relates to your activity through the App.\n Service User Information: We collect additional information for individuals who would like to use our Services. This is gathered\n through the App and includes all the information needed to register for our service:\n – Name and address,\n – Date of birth,\n – email address,\n – secured password details, and\n – bank details for the purposes of making payments.\n Contact information: If you choose to contact us you will be asked to provide us with certain details such as: full name; e-mail or physical address, and other relevant information. This may be for yourself or for people in the organization you represent.\n \n\n \n\n How do we receive information about you?\n \n\n We receive your Personal Information from various sources:\n \n\n ● When you voluntarily provide us with your personal details in order to register on our App;\n \n\n ● When you use or access our App in connection with your use of our services;\n When you use or access our Dashboard in connection with your organization’s use of our services;\n \n\n ● From third party providers, services and public registers (for example, traffic analytics vendors); and,\n \n\n ● Through diagnostic information from the App. The App will send us anonymous information about its functioning. This information contains non-personal data from your smartphone like its type and operating system, but also the version information of the App. This data is solely used for purposes of improving our Service or allowing better responses to your questions.\n What do we do with the information we collect?\n We may use the information for the following:\n ● To provide the services through the App – we will use a minimum of name and bank details to perform the services of effecting payment(s) via the App. Payment information is never shared with intended recipients of donations;\n ● Communicating with you – sending you notices regarding our services, providing you with technical information and responding to\n any customer service issue you may have; to keep you informed of our latest updates and services;\n ● Conducting statistical and analytical activities, intended to improve the App and/or the App.\n ● For marketing and advertising purposes, such as developing and providing promotional and advertising materials that may be relevant,\n valuable or otherwise of interest to you.\n In addition to the different uses listed above, we may transfer or disclose Personal Information to our subsidiaries, affiliated companies and subcontractors in relation to services that we provide to you. We may also disclose information if we have good faith to believe that\n disclosure of such information is helpful or reasonably necessary to: (i) comply with any applicable law, regulation, legal process or governmental request; (ii) enforce our policies (including our Agreement), including investigations of potential violations thereof; (iii) investigate, detect, prevent, or take action regarding illegal activities or other wrongdoing, suspected fraud or security issues; (iv) to establish or exercise our rights to defend against legal claims; (v) prevent harm to the rights, property or safety of us, our users, yourself or any third party; or (vi) for the purpose of collaborating with law enforcement agencies and/or in case we find it necessary in order to enforce intellectual property or other legal rights.\n \n\n \n\n Providing Data to Third Parties\n When you make a donation, personal information about you, your name, the amount, campaign and email address is shared with the intended recipient of your donation. In some cases, you may have the option to remain anonymous. If you choose to remain anonymous, your personal information will not be shared with the intended recipient of your donation.\n We may provide your information to our partners. For example, we may share any information we receive with vendors and service providers retained in connection with the provision of the App. If you use the App to make a donation, your payment-related information, such as credit card or other financial information, is collected by our third-party payment processor on our behalf. In all cases, these parties are necessary to provide the services.\n We may collect, use, and share anonymous data for statistical purposes, reviews, and comparisons; no such data will be traceable to individuals.\n We are committed to making it easier for donors to give to charities of their choosing, and we will never sell data to third parties.\n We may access, preserve, and disclose your information if we believe doing so is required or appropriate to: (a) comply with law enforcement requests and legal process, such as a court order or subpoena; (b) respond to your requests; or (c) protect your, our, or others’ rights, property, or safety.\n We may transfer your information to service providers, advisors, potential transactional partners, or other third parties in connection with the consideration, negotiation, or completion of a corporate transaction in which we are acquired by or merged with another company or we sell, liquidate, or transfer all or a portion of our assets. The use of your information following any of these events will be governed by the provisions of this Privacy Policy in effect at the time the applicable information was collected.\n We may also disclose your information with your permission.\n \n\n User Rights\n You may request to:\n 1.Receive confirmation as to whether or not personal information concerning you is being processed, and access your stored personal information, together with supplementary information.\n 2.Receive a copy of personal information you directly volunteer to us in a structured, commonly used and machine-readable format.\n 3.Request rectification of your personal information that is in our control.\n 4.Request erasure of your personal information.\n 5.Object to the processing of personal information by us.\n 6.Request portability of your personal information.\n 7.Request to restrict processing of your personal information by us.\n 8.Lodge a complaint with a supervisory authority.\n \n\n However, please note that these rights are not absolute, and may be subject to our own legitimate interests and regulatory requirements.\n Before fulfilling your request, we may ask you to provide reasonable information to verify your identity.\n \n\n Retention\n We will retain your personal information for as long as necessary to provide our services, and as necessary to comply with our legal\n obligations, resolve disputes, and enforce our policies. Retention periods will be determined taking into account the type of information that is collected and the purpose for which it is collected, bearing in mind the requirements applicable to the situation and the need to destroy outdated, unused information at the earliest reasonable time. Under applicable regulations, we will keep records containing client personal data, account opening documents, communications and anything else as required by applicable laws and regulations.\n We may rectify, replenish or remove incomplete or inaccurate information, at any time and at our own discretion.\n \n\n Use of Location Services\n The App may use the location services as provided by the operating system on the smartphone. With these services, the App may determine the location of the user. The location data will not be sent anywhere outside the smartphone, and is solely used to determine whether the user is in a location where it’s possible to use the App for donating. The locations where one can use App are downloaded to the smartphone prior to using the location services.\n \n\n How do we safeguard your information?\n We take security measures to reduce misuse of and unauthorized access to personal data. Although we take reasonable steps to safeguard information, we cannot be responsible for the acts of those who gain unauthorized access or abuse our App, and we make no warranty, express, implied or otherwise, that we will prevent such access.\n \n\n Transfer of data outside the EEA\n Please note that some data recipients may be located outside the EEA. In such cases we will transfer your data only to such countries as approved by the European Commission as providing adequate level of data protection, or enter into legal agreements ensuring an adequate level of data protection. Data collected from Users located in the United States is stored in the United States.\n \n\n Advertisements\n We do not use third-party advertising technology to serve advertisements when you access the App.\n \n\n Marketing\n We may use your Personal Information, such as your name, email address to send you a Newsletter about our products and services. You may opt out of receiving this Newsletter at any time by unsubscribing via the link in the newsletter.\n Children’s Privacy\n We do not knowingly collect, maintain, or use personal information from children under 13 years of age, and no part of our App is directed to children. If you learn that a child has provided us with personal information in violation of this Privacy Policy, then you may alert us at\n support@givt.app.\n Third Parties\n The App may contain links to other websites, products, or services that we do not own or operate. We are not responsible for the privacy\n practices of these third parties. Please be aware that this Privacy Policy does not apply to your activities on these third-party services or any information you disclose to these third parties. We encourage you to read their privacy policies before providing any information to them.\n \n\n Updates or amendments to this Privacy Policy\n We reserve the right to periodically amend or revise the Privacy Policy; material changes will be effective immediately upon the display of the revised Privacy policy. The last revision will be reflected in the “Last modified” section. If we materially change the ways in which we use or share personal information collected from you, we will notify you through the App, by email, or other communication. Your continued use of our Services following the notification of such amendments on our Website or through the App, constitutes your acknowledgment and consent of such amendments to the Privacy Policy and your agreement to be bound by the terms of such amendments.\n \n\n How to contact us\n If you have any general questions about the App or the information we collect about you and how we use it, you can contact us at:\n support@givt.app or by phone at +1 918-615-9611.';

  @override
  String get termsTextUs => 'GIVT INC.\n Terms of Use for Giving with Givt \n Last updated: March 30th, 2022\n Version: 1.0\n These terms of use describe the conditions under which you can use the services made available through the mobile or other downloadable application and website owned by Givt, Inc. (“Givt”, and “Service\" respectively) can be utilized by you, the User (“you”). These Terms of Use are a legally binding contract between you and Givt regarding your use of the Service.\n BY DOWNLOADING, INSTALLING, OR OTHERWISE ACCESSING OR USING THE SERVICE, YOU AGREE THAT YOU HAVE READ AND UNDERSTOOD, AND, AS A CONDITION TO YOUR USE OF THE SERVICE, YOU AGREE TO BE BOUND BY, THE FOLLOWING TERMS AND CONDITIONS, INCLUDING GIVT’S PRIVACY POLICY (https://www.givt.app/privacy-policy-givt-service) (TOGETHER, THESE “TERMS”). If you are not eligible, or do not agree to the Terms, then you do not have our permission to use the Service. YOUR USE OF THE SERVICE, AND GIVT’S PROVISION OF THE SERVICE TO YOU, CONSTITUTES AN AGREEMENT BY GIVT AND BY YOU TO BE BOUND BY THESE TERMS.\n Arbitration NOTICE. Except for certain kinds of disputes described in Section 12, you agree that disputes arising under these Terms will be resolved by binding, individual arbitration, and BY ACCEPTING THESE TERMS, YOU AND GIVT ARE EACH WAIVING THE RIGHT TO A TRIAL BY JURY OR TO PARTICIPATE IN ANY CLASS ACTION OR REPRESENTATIVE PROCEEDING.\n 1. Givt Service Overview. Givt provides its users with a platform to make anonymous donations to any of the entities properly registered with Givt as a recipient of donations (“Recipient”). The Service is available for users through their smartphones, and other electronic device. \n 2. Eligibility. You must be at least 18 years old to use the Service. By agreeing to these Terms, you represent and warrant to us that: (a) you are at least 18 years old; (b) you have not previously been suspended or removed from the Service; and (c) your registration and your use of the Service is in compliance with any and all applicable laws and regulations. If you are an entity, organization, or company, the individual accepting these Terms on your behalf represents and warrants that they have authority to bind you to these Terms and you agree to be bound by these Terms. \n 3. Accounts and Registration. To access the Service, you must register for an account. When you register for an account, you may be required to provide us with some information about yourself, such as your (i) name (ii) address, (iii) phone number, and (iv) e-mail address. You agree that the information you provide to us is accurate, complete, and not misleading, and that you will keep it accurate and up to date at all times. When you register, you will be asked to create a password. You are solely responsible for maintaining the confidentiality of your account and password, and you accept responsibility for all activities that occur under your account. If you believe that your account is no longer secure, then you should immediately notify us at support@givt.app.\n 4. Processing Donations\n 4.1. Givt does not provide banking or payment services. To facilitate the processing and transfer of donations from you to Recipients, Givt has entered into an agreement with a third party payment processor (the “Processor”). The amount of your donation that is actually received by a Recipient will be net of fees and other charges imposed by Givt and Processor.\n 4.2. The transaction data, including the applicable designated Recipient, will be processed by Givt and forwarded to the Processor. The Processor will, subject to the Processor’s online terms and conditions, initiate payment transactions to the bank account of the applicable designated Recipient. For the full terms of the transfer of donations, including chargeback, reversals, fees and charges, and limitations on the amount of a donation please see Processor’s online terms and conditions.\n 4.3. You agree that Givt may pass your transaction and bank data to the Processor, along with all other necessary account and personal information, in order to enable the Processor to initiate the transfer of donations from you to Recipients. Givt reserves the right to change of Processor at any time. You agree that Givt may forward relevant information and data as set forth in this Section 4.3 to the new Processor in order to continue the processing and transfer of donations from you to Recipients.\n 5. License and intellectual property rights\n 5.1. Limited License. Subject to your complete and ongoing compliance with these Terms, Givt grants you a non-exclusive, non-sublicensable and non-transmittable license to (a) install and use one object code copy of any mobile or other downloadable application associated with the Service (whether installed by you or pre-installed on your mobile device manufacturer or a wireless telephone provider) on a mobile device that you own or control; (b) access and use the Service. You are not allowed to use the Service for commercial purposes.\n 5.2. License Restrictions. Except and solely to the extent such a restriction is impermissible under applicable law, you may not: (a) provide the Service to third parties; (b) reproduce, distribute, publicly display, publicly perform, or create derivative works for the Service; (c) decompile, submit to reverse engineer or modify the Service; (d), remove or bypass the technical provisions that are intended to protect the Service and/or Givt. If you are prohibited under applicable law from using the Service, then you may not use it. \n 5.3. Ownership; Proprietary Rights. The Service is owned and operated by Givt. The visual interfaces, graphics, design, compilation, information, data, computer code (including source code or object code), products, software, services, and all other elements of the Service provided by Givt (“Materials”) are protected by intellectual property and other laws. All Materials included in the Service are the property of Givt or its third-party licensors. Except as expressly authorized by Givt, you may not make use of the Materials. There are no implied licenses in these Terms and Givt reserves all rights to the Materials not granted expressly in these Terms.\n 5.4. Feedback. We respect and appreciate the thoughts and comments from our users. If you choose to provide input and suggestions regarding existing functionalities, problems with or proposed modifications or improvements to the Service (“Feedback”), then you hereby grant Givt an unrestricted, perpetual, irrevocable, non-exclusive, fully paid, royalty-free right and license to exploit the Feedback in any manner and for any purpose, including to improve the Service and create other products and services. We will have no obligation to provide you with attribution for any Feedback you provide to us.\n 6. Third-Party Software. The Service may include or incorporate third-party software components that are generally available free of charge under licenses granting recipients broad rights to copy, modify, and distribute those components (“Third-Party Components”). Although the Service is provided to you subject to these Terms, nothing in these Terms prevents, restricts, or is intended to prevent or restrict you from obtaining Third-Party Components under the applicable third-party licenses or to limit your use of Third-Party Components under those third-party licenses.\n 7. Prohibited Conduct. BY USING THE SERVICE, YOU AGREE NOT TO:\n 7.1. use the Service for any illegal purpose or in violation of any local, state, national, or international law;\n 7.2. violate, encourage others to violate, or provide instructions on how to violate, any right of a third party, including by infringing or misappropriating any third-party intellectual property right;\n 7.3. interfere with security-related features of the Service, including by: (i) disabling or circumventing features that prevent or limit use, printing or copying of any content; or (ii) reverse engineering or otherwise attempting to discover the source code of any portion of the Service except to the extent that the activity is expressly permitted by applicable law;\n 7.4. interfere with the operation of the Service or any user’s enjoyment of the Service, including by: (i) uploading or otherwise disseminating any virus, adware, spyware, worm, or other malicious code; (ii) making any unsolicited offer or advertisement to another user of the Service; (iii) collecting personal information about another user or third party without consent; or (iv) interfering with or disrupting any network, equipment, or server connected to or used to provide the Service;\n 7.5. perform any fraudulent activity including impersonating any person or entity, claiming a false affiliation or identity, accessing any other Service account without permission, or falsifying your age or date of birth;\n 7.6. sell or otherwise transfer the access granted under these Terms or any Materials or any right or ability to view, access, or use any Materials; or\n 7.7. attempt to do any of the acts described in this Section 7 or assist or permit any person in engaging in any of the acts described in this Section 7.\n 8. Term, Termination, and Modification of the Service\n 8.1. Term. These Terms are effective beginning when you accept the Terms or first download, install, access, or use the Service, and ending when terminated as described in Section 8.2.\n 8.2. Termination. If you violate any provision of these Terms, then your authorization to access the Service and these Terms automatically terminate. These Terms will end by operation of law in the event you are declared bankrupt, you apply for a moratorium on payments or a general attachment is levied against your assets, in the event of your death, or in the event you go into liquidation, are wound up or dissolved. Following the termination of these Terms (for whatever reason), you shall cease and desist from all further use of Givt. You must then delete all copies (including back-up copies) of Givt from all your systems.\n 8.3. In addition, Givt may, at its sole discretion, terminate these Terms or your account on the Service, or suspend or terminate your access to the Service, at any time for any reason or no reason, with or without notice, and without any liability to you arising from such termination. You may terminate your account and these Terms at any time by deleting or uninstalling the Service, or as otherwise indicated within the Service, or by contacting customer service at support@givt.app. In the event your smartphone, or other electronic device on which the Services are installed, is lost or stolen, inform Givt immediately by contacting support@givt.app. Upon receipt of a message Givt will use commercially reasonable efforts to block the account to prevent further misuse.\n 8.4. Effect of Termination. Upon termination of these Terms: (a) your license rights will terminate and you must immediately cease all use of the Service; (b) you will no longer be authorized to access your account or the Service. If your account has been terminated for a breach of these Terms, then you are prohibited from creating a new account on the Service using a different name, email address or other forms of account verification.\n 8.5. Modification of the Service. Givt reserves the right to modify or discontinue all or any portion of the Service at any time (including by limiting or discontinuing certain features of the Service), temporarily or permanently, without notice to you. Givt will have no liability for any change to the Service, or any suspension or termination of your access to or use of the Service. \n 9. Indemnity. To the fullest extent permitted by law, you are responsible for your use of the Service, and you will defend and indemnify Givt, its affiliates and their respective shareholders, directors, managers, members, officers, employees, consultants, and agents (together, the “Givt Entities”) from and against every claim brought by a third party, and any related liability, damage, loss, and expense, including attorneys’ fees and costs, arising out of or connected with: (1) your unauthorized use of, or misuse of, the Service; (2) your violation of any portion of these Terms, any representation, warranty, or agreement referenced in these Terms, or any applicable law or regulation; (3) your violation of any third-party right, including any intellectual property right or publicity, confidentiality, other property, or privacy right; or (4) any dispute or issue between you and any third party. We reserve the right, at our own expense, to assume the exclusive defense and control of any matter otherwise subject to indemnification by you (without limiting your indemnification obligations with respect to that matter), and in that case, you agree to cooperate with our defense of those claims.\n 10. Disclaimers; No Warranties.\n THE SERVICE AND ALL MATERIALS AND CONTENT AVAILABLE THROUGH THE SERVICE ARE PROVIDED “AS IS” AND ON AN “AS AVAILABLE” BASIS. GIVT DISCLAIMS ALL WARRANTIES OF ANY KIND, WHETHER EXPRESS OR IMPLIED, RELATING TO THE SERVICE AND ALL MATERIALS AND CONTENT AVAILABLE THROUGH THE SERVICE, INCLUDING: (A) ANY IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, QUIET ENJOYMENT, OR NON-INFRINGEMENT; AND (B) ANY WARRANTY ARISING OUT OF COURSE OF DEALING, USAGE, OR TRADE. GIVT DOES NOT WARRANT THAT THE SERVICE OR ANY PORTION OF THE SERVICE, OR ANY MATERIALS OR CONTENT OFFERED THROUGH THE SERVICE, WILL BE UNINTERRUPTED, SECURE, OR FREE OF ERRORS, VIRUSES, OR OTHER HARMFUL COMPONENTS, AND GIVT DOES NOT WARRANT THAT ANY OF THOSE ISSUES WILL BE CORRECTED.\n NO ADVICE OR INFORMATION, WHETHER ORAL OR WRITTEN, OBTAINED BY YOU FROM THE SERVICE OR GIVT ENTITIES OR ANY MATERIALS OR CONTENT AVAILABLE THROUGH THE SERVICE WILL CREATE ANY WARRANTY REGARDING ANY OF THE GIVT ENTITIES OR THE SERVICE THAT IS NOT EXPRESSLY STATED IN THESE TERMS. WE ARE NOT RESPONSIBLE FOR ANY DAMAGE THAT MAY RESULT FROM THE SERVICE AND YOUR DEALING WITH ANY OTHER SERVICE USER. WE DO NOT GUARANTEE THE STATUS OF ANY ORGANIZATION, INCLUDING WHETHER AN ORGANIZATION IS A NOT-FOR-PROFIT, CHARITABLE, OR OTHER SIMILAR ORGANIZATION UNDER APPLICABLE LAWS, AND WE DO NOT MAKE ANY REPRESENTATIONS REGARDING THE TAX TREATMENT OF ANY DONATIONS, GIFTS, OR OTHER MONEYS TRANSFERRED OR OTHERWISE PROVIDED TO ANY SUCH ORGANIZATION. YOU ARE SOLELY RESPONSIBLE FOR DETERMINING WHETHER AN ORGANIZATION QUALIFIES AS A NOT-FOR-PROFIT, CHARITABLE, OR OTHER SIMILAR ORGANIZATION UNDER APPLICABLE LAWS AND TO UNDERSTAND THE TAX TREATMENT OF ANY DONATIONS, GIFTS OR OTHER MONEYS TRANSFERRED OR PROVIDED TO SUCH ORGANIZATIONS. YOU UNDERSTAND AND AGREE THAT YOU USE ANY PORTION OF THE SERVICE AT YOUR OWN DISCRETION AND RISK, AND THAT WE ARE NOT RESPONSIBLE FOR ANY DAMAGE TO YOUR PROPERTY (INCLUDING YOUR COMPUTER SYSTEM OR MOBILE DEVICE USED IN CONNECTION WITH THE SERVICE) OR ANY LOSS OF DATA, INCLUDING USER CONTENT.\n THE LIMITATIONS, EXCLUSIONS AND DISCLAIMERS IN THIS SECTION APPLY TO THE FULLEST EXTENT PERMITTED BY LAW. Givt does not disclaim any warranty or other right that Givt is prohibited from disclaiming under applicable law.\n 11. Liability\n 11.1. TO THE FULLEST EXTENT PERMITTED BY LAW, IN NO EVENT WILL THE GIVT ENTITIES BE LIABLE TO YOU FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL OR PUNITIVE DAMAGES (INCLUDING DAMAGES FOR LOSS OF PROFITS, GOODWILL, OR ANY OTHER INTANGIBLE LOSS) ARISING OUT OF OR RELATING TO YOUR ACCESS TO OR USE OF, OR YOUR INABILITY TO ACCESS OR USE, THE SERVICE OR ANY MATERIALS OR CONTENT ON THE SERVICE, WHETHER BASED ON WARRANTY, CONTRACT, TORT (INCLUDING NEGLIGENCE), STATUTE, OR ANY OTHER LEGAL THEORY, AND WHETHER OR NOT ANY GIVT ENTITY HAS BEEN INFORMED OF THE POSSIBILITY OF DAMAGE.\n 11.2. EXCEPT AS PROVIDED IN SECTIONS 11.2 AND 11.3 AND TO THE FULLEST EXTENT PERMITTED BY LAW, THE AGGREGATE LIABILITY OF THE GIVT ENTITIES TO YOU FOR ALL CLAIMS ARISING OUT OF OR RELATING TO THE USE OF OR ANY INABILITY TO USE ANY PORTION OF THE SERVICE OR OTHERWISE UNDER THESE TERMS, WHETHER IN CONTRACT, TORT, OR OTHERWISE, IS LIMITED TO US\$100.\n 11.3. EACH PROVISION OF THESE TERMS THAT PROVIDES FOR A LIMITATION OF LIABILITY, DISCLAIMER OF WARRANTIES, OR EXCLUSION OF DAMAGES IS INTENDED TO AND DOES ALLOCATE THE RISKS BETWEEN THE PARTIES UNDER THESE TERMS. THIS ALLOCATION IS AN ESSENTIAL ELEMENT OF THE BASIS OF THE BARGAIN BETWEEN THE PARTIES. EACH OF THESE PROVISIONS IS SEVERABLE AND INDEPENDENT OF ALL OTHER PROVISIONS OF THESE TERMS. THE LIMITATIONS IN THIS SECTION 11 WILL APPLY EVEN IF ANY LIMITED REMEDY FAILS OF ITS ESSENTIAL PURPOSE.\n 12. Dispute Resolution and Arbitration\n 12.1. Generally. Except as described in Section 12.2 and 12.3, you and Givt agree that every dispute arising in connection with these Terms, the Service, or communications from us will be resolved through binding arbitration. Arbitration uses a neutral arbitrator instead of a judge or jury, is less formal than a court proceeding, may allow for more limited discovery than in court, and is subject to very limited review by courts. This agreement to arbitrate disputes includes all claims whether based in contract, tort, statute, fraud, misrepresentation, or any other legal theory, and regardless of whether a claim arises during or after the termination of these Terms. Any dispute relating to the interpretation, applicability, or enforceability of this binding arbitration agreement will be resolved by the arbitrator.\n YOU UNDERSTAND AND AGREE THAT, BY ENTERING INTO THESE TERMS, YOU AND GIVT ARE EACH WAIVING THE RIGHT TO A TRIAL BY JURY OR TO PARTICIPATE IN A CLASS ACTION.\n 12.2. Exceptions. Although we are agreeing to arbitrate most disputes between us, nothing in these Terms will be deemed to waive, preclude, or otherwise limit the right of either party to: (a) bring an individual action in small claims court; (b) pursue an enforcement action through the applicable federal, state, or local agency if that action is available; (c) seek injunctive relief in a court of law in aid of arbitration; or (d) to file suit in a court of law to address an intellectual property infringement claim.\n 12.3. Opt-Out. If you do not wish to resolve disputes by binding arbitration, you may opt out of the provisions of this Section 12 within 30 days after the date that you agree to these Terms by sending an e-mail to Givt Inc. at support@givt.app, with the following subject line: “Legal Department – Arbitration Opt-Out”, that specifies: your full legal name, the email address associated with your account on the Service, and a statement that you wish to opt out of arbitration (“Opt-Out Notice”). Once Givt receives your Opt-Out Notice, this Section 12 will be void and any action arising out of these Terms will be resolved as set forth in Section 12.2. The remaining provisions of these Terms will not be affected by your Opt-Out Notice.\n 12.4. Arbitrator. This arbitration agreement, and any arbitration between us, is subject to the Federal Arbitration Act and will be administered by the American Arbitration Association (“AAA”) under its Consumer Arbitration Rules (collectively, “AAA Rules”) as modified by these Terms. The AAA Rules and filing forms are available online at www.adr.org, by calling the AAA at +1-800-778-7879, or by contacting Givt.\n 12.5. Commencing Arbitration. Before initiating arbitration, a party must first send a written notice of the dispute to the other party by e-mail mail (“Notice of Arbitration”). Givt’s e-address for Notice is: support@givt.app. The Notice of Arbitration must: (a) include the following subject line: “Notice of Arbitration”; (b) identify the name or account number of the party making the claim; (c) describe the nature and basis of the claim or dispute; and (d) set forth the specific relief sought (“Demand”). The parties will make good faith efforts to resolve the claim directly, but if the parties do not reach an agreement to do so within 30 days after the Notice of Arbitration is received, you or Givt may commence an arbitration proceeding. If you commence arbitration in accordance with these Terms, Givt will reimburse you for your payment of the filing fee, unless your claim is for more than US\$10,000 or if Givt has received 25 or more similar demands for arbitration, in which case the payment of any fees will be decided by the AAA Rules. If the arbitrator finds that either the substance of the claim or the relief sought in the Demand is frivolous or brought for an improper purpose (as measured by the standards set forth in Federal Rule of Civil Procedure 11(b)), then the payment of all fees will be governed by the AAA Rules and the other party may seek reimbursement for any fees paid to AAA.\n 12.6. Arbitration Proceedings. Any arbitration hearing will take place in Fulton County, Georgia unless we agree otherwise or, if the claim is for US\$10,000 or less (and does not seek injunctive relief), you may choose whether the arbitration will be conducted: (a) solely on the basis of documents submitted to the arbitrator; (b) through a telephonic or video hearing; or (c) by an in-person hearing as established by the AAA Rules in the county (or parish) of your residence. During the arbitration, the amount of any settlement offer made by you or Givt must not be disclosed to the arbitrator until after the arbitrator makes a final decision and award, if any. Regardless of the manner in which the arbitration is conducted, the arbitrator must issue a reasoned written decision sufficient to explain the essential findings and conclusions on which the decision and award, if any, are based. \n 12.7. Arbitration Relief. Except as provided in Section 12.8, the arbitrator can award any relief that would be available if the claims had been brough in a court of competent jurisdiction. If the arbitrator awards you an amount higher than the last written settlement amount offered by Givt before an arbitrator was selected, Givt will pay to you the higher of: (a) the amount awarded by the arbitrator and (b) US\$10,000. The arbitrator’s award shall be final and binding on all parties, except (1) for judicial review expressly permitted by law or (2) if the arbitrator\'s award includes an award of injunctive relief against a party, in which case that party shall have the right to seek judicial review of the injunctive relief in a court of competent jurisdiction that shall not be bound by the arbitrator\'s application or conclusions of law. Judgment on the award may be entered in any court having jurisdiction.\n 12.8. No Class Actions. YOU AND GIVT AGREE THAT EACH MAY BRING CLAIMS AGAINST THE OTHER ONLY IN YOUR OR ITS INDIVIDUAL CAPACITY AND NOT AS A PLAINTIFF OR CLASS MEMBER IN ANY PURPORTED CLASS OR REPRESENTATIVE PROCEEDING. Further, unless both you and Givt agree otherwise, the arbitrator may not consolidate more than one person’s claims and may not otherwise preside over any form of a representative or class proceeding.  \n 12.9. Modifications to this Arbitration Provision. If Givt makes any substantive change to this arbitration provision, you may reject the change by sending us written notice within 30 days of the change to Givt’s address for Notice of Arbitration, in which case your account with Givt will be immediately terminated and this arbitration provision, as in effect immediately prior to the changes you rejected will survive.\n 12.10. Enforceability. If Section 12.8 or the entirety of this Section 12.10 is found to be unenforceable, or if Givt receives an Opt-Out Notice from you, then the entirety of this Section 12 will be null and void and, in that case, the exclusive jurisdiction and venue described in Section 13.2 will govern any action arising out of or related to these Terms. \n \n\n 13. Miscellaneous \n 13.1. General Terms. These Terms, including the Privacy Policy and any other agreements expressly incorporated by reference into these Terms, are the entire and exclusive understanding and agreement between you and Givt regarding your use of the Service. You may not assign or transfer these Terms or your rights under these Terms, in whole or in part, by operation of law or otherwise, without our prior written consent. We may assign these Terms and all rights granted under these Terms, at any time without notice or consent. The failure to require performance of any provision will not affect our right to require performance at any other time after that, nor will a waiver by us of any breach or default of these Terms, or any provision of these Terms, be a waiver of any subsequent breach or default or a waiver of the provision itself. Use of Section headers in these Terms is for convenience only and will not have any impact on the interpretation of any provision. Throughout these Terms the use of the word “including” means “including but not limited to.” If any part of these Terms is held to be invalid or unenforceable, then the unenforceable part will be given effect to the greatest extent possible, and the remaining parts will remain in full force and effect.\n 13.2. Governing Law. These Terms are governed by the laws of the State of Delaware without regard to conflict of law principles. You and Givt submit to the personal and exclusive jurisdiction of the state courts and federal courts located within Fulton County, Georgia for resolution of any lawsuit or court proceeding permitted under these Terms. We operate the Service from our offices in Georgia, and we make no representation that Materials included in the Service are appropriate or available for use in other locations.\n 13.3. Privacy Policy. Please read the Givt Privacy Policy (https://www.givt.app/privacy-policy-givt-service) carefully for information relating to our collection, use, storage, and disclosure of your personal information. The Givt Privacy Policy is incorporated by this reference into, and made a part of, these Terms. \n 13.4. Additional Terms. Your use of the Service is subject to all additional terms, policies, rules, or guidelines applicable to the Service or certain features of the Service that we may post on or link to from the Service (the “Additional Terms”). All Additional Terms are incorporated by this reference into, and made a part of, these Terms.\n 13.5. Modification of these Terms. We reserve the right to change these Terms on a going-forward basis at any time. Please check these Terms periodically for changes. If a change to these Terms materially modifies your rights or obligations, we may require that you accept the modified Terms in order to continue to use the Service. Material modifications are effective upon your acceptance of the modified Terms. Immaterial modifications are effective upon publication. Except as expressly permitted in this Section 13.5, these Terms may be amended only by a written agreement signed by authorized representatives of the parties to these Terms. Disputes arising under these Terms will be resolved in accordance with the version of these Terms that was in effect at the time the dispute arose.\n 13.6. Consent to Electronic Communications. By using the Service, you consent to receiving certain electronic communications from us as further described in our Privacy Policy. Please read our Privacy Policy to learn more about our electronic communications practices. You agree that any notices, agreements, disclosures, or other communications that we send to you electronically will satisfy any legal communication requirements, including that those communications be in writing.\n 13.7. Contact Information. The Service is offered by Givt Inc. located at 100 S Cincinnati Ave, Fifth Floor, Tulsa, OK 74103. You may contact us by emailing us at support@givt.app.\n 13.8. Notice to California Residents. If you are a California resident, then under California Civil Code Section 1789.3, you may contact the Complaint Assistance Unit of the Division of Consumer Services of the California Department of Consumer Affairs in writing at 1625 N. Market Blvd., Suite S-202, Sacramento, California 95834, or by telephone at +1-800-952-5210 in order to resolve a complaint regarding the Service or to receive further information regarding use of the Service.\n 13.9. No Support. We are under no obligation to provide support for the Service. In instances where we may offer support, the support will be subject to published policies.\n 13.10. International Use. The Service is intended for visitors located within the United States. We make no representation that the Service is appropriate or available for use outside of the United States. Access to the Service from countries or territories or by individuals where such access is illegal is prohibited.\n 13.11. Complaints. Givt handles complaints efficiently and as soon as reasonably possible. Any complaint about the implementation of these Terms by Givt must be submitted in writing at Givt via e-mail to support@givt.app.\n 13.12. Notice Regarding Apple. This Section 13 only applies to the extent you are using our mobile application on an iOS device. You acknowledge that these Terms are between you and Givt only, not with Apple Inc. (“Apple”), and Apple is not responsible for the Service or the content of it. Apple has no obligation to furnish any maintenance and support services with respect to the Service. If the Service fails to conform to any applicable warranty, you may notify Apple, and Apple will refund any applicable purchase price for the mobile application to you. To the maximum extent permitted by applicable law, Apple has no other warranty obligation with respect to the Service. Apple is not responsible for addressing any claims by you or any third party relating to the Service or your possession and/or use of the Service, including: (1) product liability claims; (2) any claim that the Service fails to conform to any applicable legal or regulatory requirement; or (3) claims arising under consumer protection or similar legislation. Apple is not responsible for the investigation, defense, settlement, and discharge of any third-party claim that the Service and/or your possession and use of the Service infringe a third party’s intellectual property rights. You agree to comply with any applicable third-party terms when using the Service. Apple and Apple’s subsidiaries are third-party beneficiaries of these Terms, and upon your acceptance of these Terms, Apple will have the right (and will be deemed to have accepted the right) to enforce these Terms against you as a third-party beneficiary of these Terms. You hereby represent and warrant that: (a) you are not located in a country that is subject to a U.S. Government embargo or that has been designated by the U.S. Government as a “terrorist supporting” country; and (b) you are not listed on any U.S. Government list of prohibited or restricted parties.';

  @override
  String get termsTextUsVersion => '1';

  @override
  String get informationAboutUsUs => 'Givt is a product of Givt Inc\n \nWe are located at 100 S Cincinnati Ave, Fifth Floor, Tulsa, OK 74103. \nFor questions or complaints you can reach us via +1 918-615-9611 or support@givt.app \n \n We are incorporated in Delaware.';

  @override
  String get faQantwoord0Us => 'In the app-menu under \"About Givt / Contact\" there\'s a text field where you can type a message and send it to us. Of course you can also contact us by calling +1 918-615-9611 or by sending an e-mail to support@givt.app.';

  @override
  String get usRegistrationPersonalDetailsPostalCodePlaceholder => 'Zip code';

  @override
  String amountPresetsErrMinAmount(Object value0) {
    return 'The amount has to be at least $value0';
  }

  @override
  String get unregisterInfoUs => 'We’re sad to see you go!';

  @override
  String get invalidQRcodeTitle => 'Inactive QR code';

  @override
  String invalidQRcodeMessage(Object value0) {
    return 'Unfortunately, this QR code is no longer active. Would you like to give to the general funds of $value0?';
  }

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get registrationErrorTitle => 'Registration cannot be completed';

  @override
  String get noDonationsFoundOnRegistrationMessage => 'We could not retrieve any donations but we need one to complete your registration. Please contact support at support@givt.app or through About Givt/Contact in the menu.';

  @override
  String get cantCancelAlreadyProcessed => 'Unfortunately, you can\'t cancel this donation because it is already processed.';

  @override
  String get shareDataSwitch => 'I want to share the necessary personal data with the organization I donate to, so I can receive a tax statement.';

  @override
  String get shareDataInfo => 'When you enable this option, you agree to share your personal information. With this information, the organization that receives your donation will be able to provide you with a tax statement.';

  @override
  String get shareDataDisclaimer => 'When you disable this option, your donations will remain anonymous for that organization.';

  @override
  String get shareDataAlertTitle => 'Do you want a tax statement?';

  @override
  String get shareDataAlertMessage => 'To receive a tax statement, you need to share your personal information with the organization you donate to.';

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
  String get signUpPageTitle => 'Enter your details';

  @override
  String get downloadKey => 'Download';

  @override
  String get surname => 'Last name';

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
    return 'Do you want to use $value0?';
  }

  @override
  String get permitBiometricExplanation => 'Speed up the login process and keep you account secure';

  @override
  String get permitBiometricSkip => 'Skip for now';

  @override
  String permitBiometricActivateWithType(Object value0) {
    return 'Activate $value0';
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
