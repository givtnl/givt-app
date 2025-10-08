// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get ibanPlaceHolder => 'IBAN account number';

  @override
  String get amountLimitExceeded =>
      'This amount is higher than your chosen maximum amount. Please adjust the maximum donation amount or choose a lower amount.';

  @override
  String get slimPayInformation =>
      'We want your Givt experience to be as smooth as possible.';

  @override
  String get buttonContinue => 'Continue';

  @override
  String get slimPayInfoDetail =>
      'Givt works together with Better World Payments for executing the transactions. Better World Payments is specialised in handling mandates and automatic money transfers on digital platforms. Better World Payments executes these orders for Givt at the lowest rates on this market and at a high speed.\n \n\nBetter World Payments is an ideal partner for Givt because they make giving without cash very easy and safe. \n \n\nThe money will be collected in a Better World Payments account. \n Givt will ensure that the money is distributed correctly.';

  @override
  String get slimPayInfoDetailTitle => 'What is Better World Payments?';

  @override
  String get unregisterButton => 'Terminate my account';

  @override
  String get unregisterUnderstood => 'I understand';

  @override
  String givtIsBeingProcessed(Object value0) {
    return 'Thank you for your Givt to $value0!\n You can check the status in the overview.';
  }

  @override
  String offlineGegevenGivtMessageWithOrg(Object value0) {
    return 'Thank you for your Givt to $value0!\n \n\n When there\'s a good connection with the Givt-server, your Givt will be processed.\n You can check the status in the overview.';
  }

  @override
  String get wrongPasswordLockedOut =>
      'Third attempt failed, you cannot login for 15 minutes. Try again later.';

  @override
  String giftOverviewGiftAidBanner(Object value0) {
    return 'Gift Aided $value0';
  }

  @override
  String get faqWhyBluetoothEnabledQ =>
      'Why do I have to enable Bluetooth to use Givt?';

  @override
  String get faqWhyBluetoothEnabledA =>
      'Your phone receives a signal from the beacon inside the collection box, bag or basket. This signal uses the Bluetooth protocol. It can be considered as a one-way traffic, which means there is no connection, in contrast to a Bluetooth car kit or headset. It is a safe and easy way to let your phone know which collection box, bag or basket is nearby. When the beacon is near, the phone picks up the signal and your Givt is completed.';

  @override
  String get collect => 'Collection';

  @override
  String get areYouSureToCancelGivts => 'Are you sure? Press OK to confirm.';

  @override
  String get feedbackTitle => 'Feedback or questions?';

  @override
  String get feedbackMailSent =>
      'We\'ve received your message succesfully, we\'ll be in touch as soon as possible.';

  @override
  String get typeMessage => 'Write your message here!';

  @override
  String get safariGivtTransaction =>
      'This Givt will be converted into a transaction.';

  @override
  String get appVersion => 'App version:';

  @override
  String get askMeLater => 'Ask me later';

  @override
  String get giveDifferently => 'Choose from the list';

  @override
  String get codeCanNotBeScanned =>
      'Alas, this code cannot be used to give within the Givt app.';

  @override
  String get giveDifferentScan => 'Scan QR code';

  @override
  String get giveDiffQrText => 'Now, aim well!';

  @override
  String get locationEnabledMessage =>
      'Please enable your location with high accuracy to give with Givt. (After your donation you can disable it again.)';

  @override
  String get changeGivingLimit => 'Adjust maximum amount';

  @override
  String get chooseLowerAmount => 'Change the amount';

  @override
  String get turnOnBluetooth => 'Switch on Bluetooth';

  @override
  String get errorTldCheck =>
      'Sorry, you can’t register with this e-mail address. Could you check for any typos?';

  @override
  String get faQantwoord0 =>
      'In the app-menu under \"About Givt / Contact\" there\'s a text field where you can type a message and send it to us. Of course you can also contact us by calling +44 2037 908068 or by sending an e-mail to support@givt.co.uk';

  @override
  String get personalPageHeader => 'Change your account data here.';

  @override
  String get personalPageSubHeader =>
      'Would you like to change your name? Send an e-mail to support@givtapp.net .';

  @override
  String get updatePersonalInfoError =>
      'Alas! We are not able to update your personal information at the moment. Could you try again later?';

  @override
  String get loadingTitle => 'Please wait...';

  @override
  String get finalizeRegistrationPopupText =>
      'Important: Donations can only be processed after you have finished your registration.';

  @override
  String get finalizeRegistration => 'Finish registration';

  @override
  String get importantReminder => 'Important reminder';

  @override
  String get shareTheGivtButton => 'Share with my friends';

  @override
  String shareTheGivtText(Object value0) {
    return 'I\'ve just used Givt to donate to $value0!';
  }

  @override
  String get joinGivt => 'Get involved on givtapp.net/download.';

  @override
  String get yesSuccess => 'Yes, success!';

  @override
  String get personalInfo => 'Personal info';

  @override
  String get searchHere => 'Search ...';

  @override
  String get noInternet =>
      'Whoops! It looks like you\'re not connected to the internet. Try again when you are connected with the internet.';

  @override
  String get noInternetConnectionTitle => 'No internet connection';

  @override
  String get answerWhyAreMyDataStored =>
      'Everyday we work very hard at improving Givt. To do this we use the data we have at our disposal.\n We require some of your data to create your mandate. Other information is used to create your personal account.\n We also use your data to answer your service questions.\n In no case we give your personal details to third parties.';

  @override
  String get cantCancelGiftAfter15Minutes =>
      'Alas, you can\'t cancel this donation within the Givt app.';

  @override
  String get faqVraag16 => 'Can I revoke donations?';

  @override
  String get faqAntwoord16 =>
      'Yes, simply go to the donation overview and click the cancel button below the specific donation that you want to cancel. If the cancel button is not visible the donation has already been processed. Note: You can only cancel your donation if you have completed your registration in the Givt app.\n \n\n No transactions take place in the moment of giving. The transactions take place afterwards via a direct debit. Since these transactions are revertible via your bank, it is completely safe and immune to fraud.';

  @override
  String get selectContextCollect =>
      'Give in the church, at the door or on the street';

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
  String get cancelGiftAlertMessage =>
      'Are you sure you want to cancel this donation?';

  @override
  String get cancelFeatureTitle => 'You can cancel a donation by swiping left';

  @override
  String get cancelFeatureMessage => 'Tap anywhere to dismiss this message';

  @override
  String get giveSubtitle =>
      'There are several ways to ‘Givt’. Pick the one that suits you best.';

  @override
  String get confirm => 'Confirm';

  @override
  String get giveWithYourPhone => 'Move your phone';

  @override
  String get errorContactGivt =>
      'An error has occurred, please contact us at support@givtapp.net .';

  @override
  String get mandateFailPersonalInformation =>
      'It seems there is something wrong with the information you filled in. Could you please check in the menu, under \'Personal information\'? You can change the information there as well, if necessary.';

  @override
  String givtEventText(Object value0) {
    return 'Hey! You\'re at a location where Givt is supported. Do you want to give to $value0?';
  }

  @override
  String get searchingEventText =>
      'We are searching where you are, care to wait a little?';

  @override
  String get selectLocationContext => 'Give at location';

  @override
  String get changePassword => 'Change password';

  @override
  String get allowGivtLocationTitle => 'Allow Givt to access your location';

  @override
  String get allowGivtLocationMessage =>
      'We need your location to determine who you want to give to.\n Go to Settings > Privacy > Location Services > Set Location Services On and set Givt to \'While Using the App\'.';

  @override
  String get faqVraag10 => 'How do I change my password?';

  @override
  String get faqAntwoord10 =>
      'If you want to change your password, you can choose ‘Personal information’ in the menu and then press the ‘Change password’ button. We will send you an e-mail with a link to a web page where you can change your password.';

  @override
  String get changeEmail => 'Change e-mail address';

  @override
  String get changeIban => 'Change IBAN';

  @override
  String get kerkdienstGemistQuestion =>
      'How can I give with Givt through 3rd-parties?';

  @override
  String get kerkdienstGemistAnswer =>
      'Kerkdienst Gemist\n If you’re watching using the Kerkdienst Gemist App, you can easily give with Givt when your church uses our service. At the bottom of the page, you’ll find a small button that will take you to the Givt app. Choose an amount, confirm with \'Yes, please\' and you’re done!';

  @override
  String get changePhone => 'Change mobile number';

  @override
  String get artists => 'Artists';

  @override
  String get changeAddress => 'Change address';

  @override
  String get selectLocationContextLong => 'Give based on your location';

  @override
  String get sortCodePlaceholder => 'Sort code';

  @override
  String get bankAccountNumberPlaceholder => 'Bank account number';

  @override
  String get bacsSetupTitle => 'Setting up Direct Debit Instruction';

  @override
  String get bacsSetupBody =>
      'You are signing an incidental direct debit, we will only debit from your account when you use the Givt app to make a donation.\n \n\n By continuing, you agree that you are the account holder and are the only person required to authorise debits from this account.\n \n\n The details of your Direct Debit Instruction mandate will be sent to you by e-mail within 3 working days or no later than 10 working days before the first collection.';

  @override
  String get bacsUnderstoodNotice =>
      'I have read and understood the advance notice';

  @override
  String get bacsVerifyTitle => 'Verify your details';

  @override
  String get bacsVerifyBody =>
      'If any of the above is incorrect, please abort the registration and change your \'Personal information\'\n \n\n The company name which will appear on your bank statement against the Direct Debit will be Givt Ltd.';

  @override
  String get bacsReadDdGuarantee => 'Read Direct Debit Guarantee';

  @override
  String get bacsDdGuarantee =>
      '- The Guarantee is offered by all banks and building societies that accept instructions to pay Direct Debits.\n - If there are any changes to the way this incidental Direct Debit Instruction is used, the organisation will notify you (normally 10 working days) in advance of your account being debited or as otherwise agreed. \n - If an error is made in the payment of your Direct Debit, by the organisation, or your bank or building society, you are entitled to a full and immediate refund of the amount paid from your bank or building society.\n - If you receive a refund you are not entitled to, you must pay it back when the organisation asks you to.\n - You can cancel a Direct Debit at any time by simply contacting your bank or building society. Written confirmation may be required. Please also notify the organisation.';

  @override
  String get bacsAdvanceNotice =>
      'You are signing an incidental, non-recurring Direct Debit Instruction mandate. Only on your specific request will debits be executed by the organisation. All the normal Direct Debit safeguards and guarantees apply. No changes in the use of this Direct Debit Instruction can be made without notifying you at least five (5) working days in advance of your account being debited.\n In the event of any error, you are entitled to an immediate refund from your bank or building society. \n You have the right to cancel a Direct Debit Instruction at any time by writing to your bank or building society, with a copy to us.';

  @override
  String get bacsAdvanceNoticeTitle => 'Advance Notice';

  @override
  String get bacsDdGuaranteeTitle => 'Direct Debit Guarantee';

  @override
  String bacsVerifyBodyDetails(
    Object value0,
    Object value1,
    Object value2,
    Object value3,
    Object value4,
  ) {
    return 'Name: $value0\n Address: $value1\n E-mail address: $value2\n Sort code: $value3\n Account number: $value4\n Frequency type: Incidental, when you use the Givt app to make a donation';
  }

  @override
  String get bacsHelpTitle => 'Need help?';

  @override
  String get bacsHelpBody =>
      'Can\'t figure something out or you just have a question? Give us a call at +44 2037 908068 or hit us up on support@givt.co.uk and we will be in touch!';

  @override
  String bacsSortcodeAccountnumber(Object value0, Object value1) {
    return 'Sortcode: $value0\n Account number: $value1';
  }

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
  String get amountPresetsErrGivingLimit =>
      'The amount is higher than your maximum amount';

  @override
  String amountPresetsErr25C(Object value0) {
    return 'The amount has to be at least $value0';
  }

  @override
  String get amountPresetsErrEmpty => 'Enter an amount';

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
  String get touchIdUsage =>
      'This is where you change the use of your Touch ID to login into the Givt app.';

  @override
  String get faceIdUsage =>
      'This is where you change the use of your Face ID to login into the Givt app.';

  @override
  String get fingerprintUsage =>
      'This is where you change the use of your fingerprint to login into the Givt app.';

  @override
  String get offlineGiftsTitle => 'Offline donations';

  @override
  String get amountTooHigh => 'Amount too high';

  @override
  String get loginFailure => 'Login error';

  @override
  String get requestFailed => 'Request failed';

  @override
  String get resetPasswordSent =>
      'You should have received an e-mail with a link to reset your password. In case you do not see the e-mail right away, check your spam.';

  @override
  String get success => 'Success!';

  @override
  String get notSoFast => 'Not so fast, big spender';

  @override
  String get giftBetween30Sec =>
      'You already gave within 30 seconds. Can you wait a little?';

  @override
  String get nonExistingEmail =>
      'We have not seen this e-mail address before. Is it possible that you registered with a different e-mail account?';

  @override
  String get amountTooLow => 'Amount too low';

  @override
  String get qrScanFailed => 'Aiming failed';

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
  String get giftsOverviewSent =>
      'We\'ve sent your donations overview to your mailbox.';

  @override
  String get downloadYearOverviewByChoice =>
      'Do you want to download an annual overview of your donations? Choose the year below and we will send the overview to';

  @override
  String get mandateFailTryAgainLater =>
      'Something went wrong while generating the mandate. Can you try again later?';

  @override
  String get termsTextGb =>
      'GIVT LTD \n\nTerms of use – Givt app \nLast updated: 24-11-2023\nVersion: 1.5\n\n1.  \tGeneral \nThese terms of use describe the conditions under which the mobile application Givt (\"Givt\") can be utilised. Givt allows the User (anonymously) to give donations through their smartphone, for example churches, fundraising campaigns or charities that are members of Givt Ltd.  \n\nThese terms of use apply to the use of Givt. Through the use of Givt (which means the download and the installation thereof), you (\"the User\") accept these terms of use and our privacy policy (https://givt.co.uk/privacystatementgivt-service). These terms of use and our privacy policy are also available on our website to download and print. We may revise these terms of use from time to time. \n\n2.  \tLicense and intellectual property rights \n\n2.1\tAll rights to Givt, the accompanying documentation and all modifications and extensions thereto as well as the enforcement thereof are and remain the property of Givt. The User is granted solely the rights and authorities and/or permissions ensuing from the effect of this agreement or which are assigned in writing, and you may not otherwise use, reproduce or publicly release Givt. \n\n2.2\tGivt grants the User a non-exclusive, non-sublicensable and non-transmittable license to use Givt. The User is not allowed to use Givt for commercial purposes. \n\n2.3  \tThe User may not provide Givt to third parties nor sell, rent, decompile, submit to reverse engineer or modify it without prior permission from Givt. Nor should the User, or let others, remove or bypass the technical provisions that are intended to protect Givt. \n\n2.4 \tGivt has the right to change Givt at any time, modify or remove data, deny the User the use of Givt by termination of the license, limitation of the use of Givt or deny access to Givt in whole or in part, temporarily or permanently. Givt will inform the User about this in an appropriate manner. \n\n2.5 \tThe User acquires no right, title or interest to the intellectual property rights and/or similar rights to (the means of) Givt, including the underlying software and content.\n\n3. \tThe use of Givt \n\n3.1 \tThe User can only give donations to churches, charities, fundraising campaigns and/or other legal entities that are affiliated with Givt. The donations are done anonymously. \n\n3.2  \tThe use of Givt is at your own risk and expense and should be used in accordance with the purposes for which it is intended. It is prohibited to reverse engineer the source code of Givt or to decompile and/or modify Givt, to make a copy of Givt available to any third party or to remove, delete or render illegible any designations of Givt as the party holding rights to Givt or parts thereof.\n\n3.3\tThe User is responsible for the correct submission of data such as name and address details, bank account number and other information as requested by Givt to ensure the use of Givt. \n\n3.4\tIf the User is under the age of 18 they must have the consent of their parent or legal guardian in order to use Givt. By accepting these terms of use, the User guarantees that they are 18 years of age or have the permission of their parents or legal representative. \n\n3.5 \tGivt is available for the operating systems Android and iOS. In addition to the provisions set out below, Apple’s App Store or Google Play may attach conditions to the acquisition of Givt, its use and related matters. For further information, see the terms of use and privacy policy of Apple’s App Store and Google Play as well as any other applicable terms and conditions appearing on the website of the respective provider. This end user licence is applicable to the agreement between the User and Givt and does not apply between the User and the provider of the platform through which you acquired Givt. That provider may hold you liable for violation of provisions in this end user licence, however.\n\n3.6\tAfter the User has downloaded Givt, the User is requested to register. In doing so, the User must provide the following information: (i) name (ii) address, (iii) phone number, (iv) bank account number, and (v) e-mail address. The privacy policy of Givt is applied to the processing of personal data via Givt. The User must inform Givt immediately if any of this data changes by correcting the information within the app.\n\n3.7\tThe User may, after installing the Givt app, also choose to only enter an e-mail address and immediately use the app to donate. After the donation, the User will be asked to complete the registration procedure. If the User wishes to do so later, Givt ensures to only use the User\'s e-mail address to remind the User to finish the registration procedure until this procedure is finalised.\n\n3.8 \tThe User is responsible for any expenses related to the equipment, software system and (internet) connection to make use of Givt.\n\n3.9 \tGivt provides the related services based on the information the User submits. The User is obliged to provide correct and complete information, which is not false or misleading. The User may not provide data with respect to names or bank accounts for which the User is not authorised to use. Givt and the Processor have the right to validate and verify the information the User has provided. \n\n3.10 \tThe User may at any time terminate the use of Givt, by deleting their account via the menu in the app or via mail to support@givt.app. Deleting the app from the smartphone without following aforementioned steps will not result in deletion of the User’s data. Givt can terminate the relationship with the User if the User does not comply with these terms and conditions or if Givt has not been used for 18 consecutive months. On request Givt can send a listing of all donation data. \n\n3.11 \tGivt does not charge fees for the use of Givt. \n\n3.12\tGivt has the right to adjust the offered functionalities from time to time to improve, to change or to fix errors. Givt will always work to fix errors within the Givt software, but cannot guarantee that all errors, whether or not in a timely fashion, be restored. \n\n4. \tProcessing transactions and Protecting your money\n\n4.1 \tGivt does not provide banking or payment services. To facilitate the processing of donations from the User, Givt has entered into an agreement with Access Paysuite Ltd, an Electronic Money Institution, authorised and regulated by the Financial Conduct Authority (FRN 730815) (“Access PaySuite”)(the \"Processor\"). Givt will, after the collection of donations, ensure the payment of donations to the user-designated beneficiary. The transaction data will be processed and forwarded to the Givt Processor. The Processor will initiate payment transactions whereas Givt is responsible for the transaction of the relevant amounts to the bank account of the Church/Charity as being the user-designated beneficiary of the donation.\n\n4.2 \tThe User agrees that Givt may pass the User’s (transaction and bank) data to the Processor, along with all other necessary account and personal information of the User, in order to enable the Processor to initiate the payment transactions and processing. Givt reserves the right to change the Processor at any time. The User agrees that Givt may forward the relevant information and data about the User as defined in article 4.2 to the new Processor to be able to continue processing payment transactions. \n\n4.3 \tGivt and the Processor will process the data of the User in accordance with the law and regulations that apply to data protection. For further information on how personal data is collected, processed and used, Givt refers the User to its privacy policy. This can be found at: (https://givt.co.uk/privacystatementgivt-service/).\n\n4.4 \tThe donations of the User will pass through Access PaySuite. Givt will ensure that the funds will be transferred to the beneficiary, with whom Givt has an agreement. \n\n4.5 \tThe User can reverse a debit at any time, within the terms of the User\'s bank, and the direct debit scheme. \n\n4.6 \tGivt and/or the Processor can refuse a donation if there are reasonable grounds to believe that a user is acting in violation of these terms or if there are reasonable grounds to believe that a donation is possibly suspicious or illegal. In this case Givt will inform the User as soon as possible, unless prohibited by law. \n\n4.7\tUsers of the Givt app will not be charged for their donations through our platform. Givt and the receiving party have made separate compensation arrangements pursuant to the agreement in effect between them.\n\n4.8 \tThe User agrees that Givt may pass transactional data of the User to the HMRC, along with all other necessary account and personal information of the User, in order to assist the User with their annual tax return.   \n\n4.9\tWe will hold your money in a Client Funds Account, provided by Access PaySuite. The account is segregated from our own assets. The money contained in the Client Funds Account cannot be used by Givt, invested or lent to third parties, or in any way form part of Givt’s assets.\n\n4.10\tCurrent Regulatory Provisions exclude money placed on a Client Funds Account from the UK Financial Services Compensation Scheme (FSCS).\n\n4.11\tMoney placed or held in the Client Funds Account shall not constitute a deposit (within the meaning of Article 5 of Directive 2006/48/EC) and does not earn interest.\n4.12\tDeposits and, in particular, withdrawals from the Client Funds Account will only be made in the following circumstances:\n\nIn the case of deposits:\n\nTo receive money intended for onward payment to the designated charity/charities or church(es)\nTo replenish the account where fees or other costs associated with running the account have been deducted\nTo receive refunds in the event that prior instruction to make a payment by you is cancelled, in accordance with these Terms and Conditions\n\nIn the case of withdrawals:\n\nTo pay designated charities and churches, in accordance with your instructions\nTo pay fees or other costs associated with running the account\nTo return money to you, in the event that prior instruction to make a payment by you is canceled, in accordance with these Terms and Conditions.\n\n5. \tSecurity, theft and loss \n\n5.1 \tThe User shall take all reasonable precautions safekeeping their login credentials for Givt to avoid loss, theft, misappropriation or unauthorised use of Givt on their device.\n\n5.2 \tThe User is responsible for the security of their device. Givt considers any donation from the Givt account as a user-approved transaction, regardless of the rights of the User under article 4.5.\n\n5.3 \tThe User shall inform Givt immediately via info@givt.app or +44 20 3790 8068 once their device is lost or stolen. Upon receipt of a message Givt will block the account to prevent (further) misuse. \n\n6.\tUpdates\n\n6.1\tGivt releases updates from time to time, which can rectify errors or improve the functionality of Givt. Available updates for Givt will be announced by means of notification through Apple’s App Store and Google Play and it is the User’s sole responsibility to monitor these notifications and keep informed about new updates.\n\n6.2\tAn update can stipulate conditions, which differ from the provisions in this agreement. The User will always be notified in advance so that they have the opportunity to refuse the update. By installing such an update, the User agrees to these new conditions, which will then form part of this agreement. If User does not agree to the changed conditions, they will have to cease using Givt and delete Givt from their device.\n\n7. \tLiability \n\n7.1 \tGivt has been compiled with the utmost care. Although Givt strives to make Givt available 24 hours a day, it accepts no liability if, for any reason, Givt is not available at any given time or for a certain period of time. Givt reserves the right to temporarily or permanently discontinue Givt (unannounced). The User cannot derive any rights from this. \n\n7.2 \tGivt is not liable for damage or injury resulting from the use of Givt. The limitations of liability as mentioned in this article shall lapse if the liability for damage is the result of intent or gross negligence on the part of Givt.\n\n7.3 \tThe User indemnifies Givt against any claim from third parties (for example, beneficiaries of the donations or HMRC) as a result of the use of the Givt or not correctly meeting the agreements made concerning legal or contractual obligations with Givt. The User will pay all damages and costs to Givt as a result of such claims.\n\n8. \tOther provisions \n\n8.1 \tThis agreement comes into effect on commencement of the use of Givt and will remain in force for an undetermined period from that moment. This agreement may be terminated by the User as well as by Givt at any moment, subject to one month’s notice. This agreement will end by operation of law in the event you are declared bankrupt, you apply for a moratorium on payments or a general attachment is levied against your assets, in the event of your death, or in the event you go into liquidation, are wound up or dissolved. Following the termination of this agreement (for whatever reason), you shall cease and desist from all further use of Givt. You must then delete all copies (including back-up copies) of Givt from all your devices.\n\n8.2\tIf any provision of these terms and conditions is void or destroyed, this will not affect the validity of the agreement as a whole, and other provisions of these terms remain in force. In that case, the parties will decide on a new replacement provision or provisions which will be in line with the intention of the original agreement as far as is legally possible.\n\n8.3 \tThe User is not allowed to transfer the rights and/or obligations arising from the use of Givt and these terms to third parties without prior written permission of Givt. Conversely, Givt is allowed to do so. \n\n8.4 \tWe will endeavor to resolve the dispute amicably. Any disputes arising from or in connection with these terms and conditions are finally settled in the Courts of England and Wales. \n\n8.5  \tThe Law of England and Wales is applicable on these terms of use. \n\n8.6 \tThe terms of use shall not affect the User\'s statutory rights as a consumer.\n\n8.7 \tGivt features an internal complaints procedure. Givt handles complaints efficiently and as soon as reasonably possible. Any complaint about the implementation of these conditions by Givt must be submitted in writing at Givt (via support@givt.app).\n\n\n';

  @override
  String get firstCollect => '1st collection';

  @override
  String get secondCollect => '2nd collection';

  @override
  String get thirdCollect => '3rd collection';

  @override
  String get addCollect => 'Add a collection';

  @override
  String get policyTextGb =>
      'Latest Amendment: 24-09-2021\n Version 1.9\n \n\n Givt Limited Privacy Policy  \n \n\n Introduction\n This Privacy Policy outlines Givt Limited’s (\" we \", \" our \" or \" the Company \") practices with respect to information collected from our Application (“App”) or from users that otherwise share personal information with us (collectively: \"Users\"). \n \n\n Grounds for data collection \n \n\n Processing of your personal information (meaning, any information which may potentially allow your identification with reasonable means; hereinafter \"Personal Information\") is necessary for the performance of our contractual obligations towards you and providing you with our services, to protect our legitimate interests and for compliance with legal and financial regulatory obligations to which we are subject.\n \n\n When you use our App or register yourself or an organisation you represent with us, you consent to the collection, storage, use, disclosure and other uses of your Personal Information as described in this Privacy Policy.\n \n\n We encourage our Users to carefully read the Privacy Policy and use it to make informed decisions. \n \n\n What information do we collect?\n \n\n We collect two types of data and information from Users. \n \n\n The first type of information is un-identified and non-identifiable information pertaining to a User(s), which may be made available or gathered via your use of the App (“ Non-personal Information ”). We are not aware of the identity of a User from which the Non-personal Information was collected. Non-personal Information which is being collected may include your aggregated usage information and technical information transmitted by your device, including certain software and hardware information (e.g. language preference, access time, etc.) in order to enhance the functionality of our App.\n \n\n The second type of information is Personal Information, which is personally identifiable information, namely information that identifies an individual or may with reasonable effort identify an individual. Such information includes:\n Device Information: We collect Personal Information from your device. Such information includes geolocation data, IP address, unique identifiers (e.g. MAC address and UUID) and other information which relates to your activity through the App.\n Service User Information: We collect additional information for individuals who would like to use our Services. This is gathered through the App and includes all the information needed to register for our service: \n Name and address, \n Date of birth, \n e-mail address, \n secured password details, and \n bank details for the purposes of making payments.\n Contact information: If you choose to contact us you will be asked to provide us with certain details such as: full name; e-mail or physical address, and other relevant information. This may be for yourself or for people in the organisation you represent.\n  \n How do we receive information about you?\n We receive your Personal Information from various sources:\n \n\n When you voluntarily provide us your personal details in order to register on our App;\n When you use or access our App in connection with your use of our services;\n From third party providers, services and public registers (for example, traffic analytics vendors).\n Through diagnostic information from the App. The App will send us anonymous information about its functioning. This information contains non-personal data from your smartphone like its type and operating system, but also the version information of the App. This data is solely used for purposes of improving our Service or allowing better responses to your questions. This information will never be shared with third-parties. \n What do we do with the information we collect?\n We do not rent, sell, or share Users’ information with third parties except as described in this Privacy Policy.\n \n\n We may use the information for the following:\n To provide the services through the App – we will use a minimum of name and bank details to perform the services of effecting payment(s) via the App. Such information is never shared with intended recipients of donations.;\n Communicating with you – sending you notices regarding our services, providing you with technical information and responding to any customer service issue you may have; to keep you informed of our latest updates and services;\n Conducting statistical and analytical activities, intended to improve the App and/or the App.\n \n\n In addition to the different uses listed above, we may transfer or disclose Personal Information to our subsidiaries, affiliated companies and subcontractors in relation to services that we provide to you.\n \n\n We may also disclose information if we have good faith to believe that disclosure of such information is helpful or reasonably necessary to: (i) comply with any applicable law, regulation, legal process or governmental request; (ii) enforce our policies (including our Agreement), including investigations of potential violations thereof; (iii) investigate, detect, prevent, or take action regarding illegal activities or other wrongdoing, suspected fraud or security issues; (iv) to establish or exercise our rights to defend against legal claims; (v) prevent harm to the rights, property or safety of us, our users, yourself or any third party; or (vi) for the purpose of collaborating with law enforcement agencies and/or in case we find it necessary in order to enforce intellectual property or other legal rights.\n \n\n User Rights\n You may request to: \n Receive confirmation as to whether or not personal information concerning you is being processed, and access your stored personal information, together with supplementary information. \n Receive a copy of personal information you directly volunteer to us in a structured, commonly used and machine-readable format. \n Request rectification of your personal information that is in our control.\n Request erasure of your personal information. \n Object to the processing of personal information by us. \n Request to restrict processing of your personal information by us.\n Lodge a complaint with a supervisory authority.\n \n\n However, please note that these rights are not absolute, and may be subject to our own legitimate interests and regulatory requirements. \n \n\n If you have any questions about this Privacy Policy, please contact us:\n \n\n By e-mail: support@givt.app\n By visiting this page on our Website: https://givt.co.uk/faq-3/\n By phone number: +44 20 3790 8068.\n \n\n Retention\n We will retain your personal information for as long as necessary to provide our services, and as necessary to comply with our legal obligations, resolve disputes, and enforce our policies. Retention periods will be determined taking into account the type of information that is collected and the purpose for which it is collected, bearing in mind the requirements applicable to the situation and the need to destroy outdated, unused information at the earliest reasonable time. Under applicable regulations, we will keep records containing client personal data, account opening documents, communications and anything else as required by applicable laws and regulations. \n \n\n We may rectify, replenish or remove incomplete or inaccurate information, at any time and at our own discretion.\n \n\n Use of Location Services\n \n\n The App may use the location services as provided by the operating system on the smartphone. With these services, the App may determine the location of the user. The location data will not be sent anywhere outside the smartphone, and is solely used to determine whether the user is in a location where it’s possible to use the App for donating. The locations where one can use App are downloaded to the smartphone prior to using the location services.\n \n\n How do we safeguard your information?\n \n\n We take security measures to reduce misuse of and unauthorised access to personal data. We take the following measures in particular:\n \n\n Access to personal data requires the use of a username and password\n Access to personal data requires the use of a username and login token\n We make use of secure connections (Secure Sockets Layer of SSL) to encrypt all information between you and our website when entering your personal data.\n We keep logs of all requests for personal data.\n \n\n Although we take reasonable steps to safeguard information, we cannot be responsible for the acts of those who gain unauthorised access or abuse our App, and we make no warranty, express, implied or otherwise, that we will prevent such access.\n \n\n Transfer of data outside the EEA \n Please note that some data recipients may be located outside the EEA. In such cases we will transfer your data only to such countries as approved by the European Commission as providing adequate level of data protection, or enter into legal agreements ensuring an adequate level of data protection.\n \n\n Advertisements\n We do not use third-party advertising technology to serve advertisements when you access the App. \n \n\n Marketing\n We may use your Personal Information, such as your name, email address to send you a Newsletter about our products and services. You may opt out of receiving this Newsletter at any time by unsubscribing via the link.\n \n\n Providing Data to Third Parties\n We may provide your information to our partners. These partners are involved in the execution of the agreement. In all cases, these parties are necessary to provide the services. These are not the collecting authorities, as we protect the anonymity of users.\n You agree that the transaction data are anonymous and can be used for data collection, statistics, reviews and comparisons. Only the summary will be shared with other customers and we ensure you that none of your data will be traceable to individuals.\n \n\n We will also never sell data to third parties. We are only committed to make it easier for the donor to give to charities of their choosing.\n \n\n Updates or amendments to this Privacy Policy\n We reserve the right to periodically amend or revise the Privacy Policy; material changes will be effective immediately upon the display of the revised Privacy policy. The last revision will be reflected in the \"Last modified\" section. Your continued use of our Services following the notification of such amendments on our Website or through the App, constitutes your acknowledgment and consent of such amendments to the Privacy Policy and your agreement to be bound by the terms of such amendments.\n \n\n How to contact us\n \n\n If you have any general questions about the App or the information we collect about you and how we use it, you can contact us at: support@givt.app\n \n\n or\n \n\n By visiting this page on our Website: https://givt.co.uk/faq-3/\n By phone number: +44 20 3790 8068.\n \n\n Givt Ltd. is a part of Givt B.V., our office is located on the Bongerd 159 in Lelystad, the Netherlands.\n Company Number (CRN): 11396586';

  @override
  String get amount => 'Choose amount';

  @override
  String get amountLimit => 'Determine the maximum amount of your Givt';

  @override
  String get cancel => 'Cancel';

  @override
  String get city => 'City/Town';

  @override
  String get country => 'Country';

  @override
  String get email => 'E-mail address';

  @override
  String get firstName => 'First name';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get forgotPasswordText =>
      'Enter your e-mail address. We will send you an e-mail with the information on how to change your password.\n \n\n If you can\'t find the e-mail right away, please check your spam.';

  @override
  String get give => 'Give';

  @override
  String get selectReceiverButton => 'Select';

  @override
  String get giveLimit => 'Maximum amount';

  @override
  String get login => 'Login';

  @override
  String get loginText =>
      'To get access to your account we would like to make sure that you are you.';

  @override
  String get logOut => 'Logout';

  @override
  String get makeContact =>
      'This is the Givt-moment.\n Move your phone towards the \n collection box, bag or basket.';

  @override
  String get next => 'Next';

  @override
  String get password => 'Password';

  @override
  String get passwordRule =>
      'The password should contain at least 7 characters including at least one capital and one digit.';

  @override
  String get phoneNumber => 'Mobile number';

  @override
  String get postalCode => 'Postal Code';

  @override
  String get ready => 'Done';

  @override
  String get registerPersonalPage =>
      'In order to process your donations,\n we need some personal information.';

  @override
  String get registrationSuccess =>
      'Registration successful.\n Have fun giving!';

  @override
  String get send => 'Send';

  @override
  String get somethingWentWrong => 'Whoops, something went wrong.';

  @override
  String get streetAndHouseNumber => 'Street name and number';

  @override
  String get tryAgain => 'Try again';

  @override
  String get wrongCredentials =>
      'Invalid e-mail address or password. Is it possible that you registered with a different e-mail account?';

  @override
  String get yesPlease => 'Yes, please';

  @override
  String get bluetoothErrorMessage =>
      'Switch on Bluetooth so you\'re ready to give to a collection.';

  @override
  String get save => 'Save';

  @override
  String get acceptPolicy => 'Ok, Givt is permitted to save my data.';

  @override
  String get close => 'Close';

  @override
  String get termsTitle => 'Our Terms of Use';

  @override
  String get fullVersionTitleTerms => 'Terms of Use';

  @override
  String get termsText =>
      'Last updated: 26-05-2025\nEnglish translation of version 2.0\n\n1. ​General\nThese terms of use describe the conditions under which the mobile and web applications of Givt (\"Givt\") may be used. Givt enables the User to give (anonymous) donations via their smartphone and/or web browser to, for example, churches, funds, or foundations that are affiliated with Givt or with a third party with whom Givt partners. Givt is managed by Givt B.V., a private limited company, located in Lelystad (8212 BJ), at Bongerd 159, registered in the trade register of the Chamber of Commerce under number 64534421 (\"Givt B.V.\"). These terms of use apply to the use of Givt. By using Givt (which includes downloading and installing it or making a donation via the Givt website), you as a user (\"User\") accept these terms of use and our privacy statement (www.givtapp.net/privacyverklaring). These terms of use and our privacy statement can also be consulted, downloaded, and printed from our website. We may amend these terms of use from time to time.\n\n2. ​License and Intellectual Property Rights\n2.1 All rights to Givt, the accompanying documentation, and all modifications and extensions thereof and the enforcement thereof are and shall remain with Givt B.V. The User only obtains the user rights and powers that arise from the scope of these terms, and for the rest, you may not use, reproduce, or disclose Givt.\n2.2 Givt B.V. grants the User a non-exclusive, non-sublicensable, and non-transferable license for the use of Givt. The User is not permitted to use Givt for commercial purposes.\n2.3 The User may not make Givt available to third parties, sell, rent, decompile, subject to reverse engineering, or modify it without the prior consent of Givt B.V. Nor may the User remove or circumvent the technical provisions intended to protect Givt.\n2.4 Givt B.V. has the right at all times to modify Givt, change or delete data, deny the User the use of Givt by terminating the license, restrict the use of Givt, or deny access to Givt in whole or in part, temporarily or permanently. Givt B.V. will inform the User about this in a manner it deems appropriate.\n2.5 The User does not acquire any right, title, or interest in or to the intellectual property rights and/or similar rights to (the content of) Givt, including the underlying software and content.\n\n3.0 Use of Givt\n3.1 The User can only make donations to churches, foundations, funds, and/or other (legal) persons that are offered by Givt and have entered into a relationship with Givt B.V. or one of its partners. The donor is anonymous to the recipient, unless otherwise indicated.\n3.2 The use of Givt is at your own expense and risk and must be used in accordance with the purposes for which it is intended. It is not permitted to reverse engineer the source code of Givt or to decompile and/or modify Givt, to make Givt available to third parties, or to remove or make illegible any indications of Givt B.V. as the rights holder of Givt or parts thereof.\n3.3 The User is responsible for the correct provision of data such as name and address details, bank account number, and other data as requested by Givt B.V. to ensure the use of Givt.\n3.4 If the User is younger than 18 years old, they must have the consent of their parent or legal guardian to use Givt. By accepting these terms of use, the User guarantees that they are 18 years of age or older or have permission from their parents or legal guardian.\n3.5 The Givt app is available for the Android and iOS operating systems, and the web functionality is available for the most common and modern web browsers. In addition to the provisions below, Apple\'s App Store or Google Play may impose conditions on obtaining Givt, its use, and related matters. For this, please consult the terms of use and privacy statement of Apple\'s App Store and Google Play and any applicable conditions on the website of the respective provider. These terms of use apply to the agreement between the User and Givt B.V. and do not apply between the User and the provider of the platform through which you obtained Givt. However, these providers may hold the User accountable for violating provisions in these terms of use.\n3.6 After the User has downloaded Givt, the User must register. In doing so, the User must provide the following information: (i) name and address details, (ii) telephone number, (iii) bank account number, and (iv) email address. The processing of personal data via Givt is subject to the privacy statement of Givt B.V. In the event of any changes to data, the User must immediately adjust this via Givt.\n3.7 To be able to use Givt, the User must, at their own expense, provide the necessary equipment, system software, and (internet) connection.\n3.8 Givt B.V. provides the related services based on the information the User provides. The User is obliged to provide correct and complete information that is not false or misleading. The User may not provide data relating to names or bank accounts that the User is not authorized to use. Givt B.V. and the Processor have the right to validate and verify the information provided by the User.\n3.9 The User can terminate the use of Givt at any time by deleting their Givt account via the menu in the app, or via email to support@givtapp.net. Deleting the app on the smartphone without following these steps does not result in an automatic deletion of the User\'s data. Givt B.V. may terminate the relationship with the User if the User does not comply with these terms or if Givt is not used for 18 consecutive months. Upon request, Givt B.V. will send an overview of all donation data if this happens before the account is deleted by the User.\n3.10 Givt B.V. does not charge a fee for the use of Givt.\n3.11 Givt B.V. has the right to adjust the offered functionalities from time to time to improve or change them and to correct errors. Givt B.V. will make an effort to resolve any errors in the Givt software but cannot guarantee that all errors will be corrected, whether in a timely manner or not.\n\n4.0 Transaction Processing\n4.1 Givt B.V. is not a bank/financial institution and does not provide banking or payment processing services. To process the User\'s donations, Givt B.V. has therefore entered into an agreement with a payment service provider called Better World Payments, a financial institution (the \"Processor\"), in which it is agreed that Givt B.V. will send the transaction data to the Processor to initiate and handle donations. Givt B.V. will, after the collection of the donations, ensure the remittance of the donations to the beneficiary(s) appointed by the User. The transaction data will be processed by Givt and forwarded to the Processor. The Processor will initiate the payment transactions, and Givt B.V. is responsible for transferring the relevant amounts to a bank account of the church/foundation as designated by the User as the beneficiary of the donation.\n4.2 The User agrees that Givt B.V. may pass on the User\'s (transaction and bank) data to the Processor, along with all other necessary account and personal information of the User, to enable the Processor to initiate and process the payment transactions. Givt B.V. reserves the right to change its Processor at any time. The User agrees that Givt B.V. may forward relevant information about the User and the data as described in Article 4.2 to the new Processor in order to continue processing payment transactions.\n4.3 Givt B.V. and the Processor will process the User\'s data in accordance with the laws and regulations that apply to data protection. For further information on how personal data is collected, processed, and used, Givt B.V. refers the User to its privacy policy. This can be found online (www.givtapp.net/privacyverklaring).\n4.4 The User\'s donations are processed through Givt B.V. as an intermediary. Givt B.V. will then ensure that the funds are transferred to the beneficiary(s) with whom Givt B.V. has concluded an agreement.\n4.5 To make a donation via Givt, the User must issue an authorization to Givt B.V. and/or the Processor (for an automatic SEPA direct debit) or complete the transaction directly with another payment method. The User can at any time – within the conditions applied by the User\'s bank – reverse an automatic direct debit.\n4.6 A donation may be refused by Givt B.V. and/or the Processor if there are reasonable grounds to assume that a User is acting in violation of these terms or if there are reasonable grounds to assume that a donation may be suspicious or illegal. Givt B.V. will inform the User of this as soon as possible, unless this is prohibited by law.\n4.7 Users of the Givt app will not be charged any fees for their donations via our platform. Givt and the receiving party have made separate agreements regarding fees in their applicable agreement. In some cases, the User is offered the opportunity to make a voluntary platform contribution. When the User chooses to make this contribution, it is a gift to Givt B.V. and is not considered a cost. Givt B.V. uses this voluntary platform contribution to reduce the costs for foundations and churches at its own discretion.\n4.8 The User agrees that Givt B.V. may pass on the User\'s (transaction) data to the local tax authorities, along with all other necessary account and personal information of the User, to assist the User with their annual tax return.\n\n5.0 Security, Theft, and Loss\n5.1 The User must take all reasonable precautions to keep their login details for Givt secure to prevent loss, theft, misappropriation, or unauthorized use of Givt or their smartphone.\n5.2 The User is responsible for the security of their smartphone. Givt B.V. considers every donation from the User\'s Givt account to be a transaction approved by the User, regardless of the rights that the User has under Article 4.5.\n5.3 The User must immediately notify Givt B.V. via support@givtapp.net or +31 320 320 115 as soon as their smartphone is lost or stolen. Upon receipt of a notification, Givt B.V. will block the account to prevent (further) misuse.\n\n6.0 Updates\n6.1 Givt B.V. will release updates from time to time to improve the user experience, which may fix bugs or improve the functioning of Givt. Available updates for Givt will be announced via notifications through Apple\'s App Store and Google Play, and it is the sole responsibility of the User to keep track of these notifications.\n6.2 An update may impose conditions that deviate from those set out in these terms. This will always be communicated to the User in advance, and the User will have the opportunity to refuse the update. By installing such an update, the User agrees to these deviating conditions, which will then form part of these terms of use. If the User does not agree with the amended conditions, they must cease using Givt and remove Givt from their mobile phone and/or tablet.\n\n7.0 Liability\n7.1 Givt has been compiled with the greatest care. Although Givt B.V. strives to make Givt available 24 hours a day, it accepts no liability if, for any reason, Givt is not available at a certain time or for a certain period. Givt B.V. reserves the right to discontinue Givt (unannounced) temporarily or permanently, without the User being able to derive any rights from this.\n7.2 Givt B.V. is not liable for damage or injury resulting from the use of Givt. The limitations of liability as mentioned in this article shall not apply if the liability for damage is the result of intent or gross negligence on the part of Givt B.V.\n7.3 The User indemnifies Givt B.V. against all possible claims from third parties (for example, beneficiaries of the donations or the tax authorities) as a result of the use of Givt or the failure to comply, or to comply correctly, with legal or contractual obligations towards Givt B.V. The User will reimburse Givt B.V. for all damages and costs that Givt B.V. suffers as a result of such claims.\n\n8.0 Other Provisions\n8.1 These terms of use come into effect upon the use of Givt, including the online web services that Givt makes available, and then remain in force for an indefinite period. The agreement may be terminated by either the User or Givt B.V. at any time with a notice period of one month. This agreement terminates automatically if the User: (i) is declared bankrupt, (ii) applies for a moratorium on payments or if a general seizure of the User\'s assets is made, (iii) the User passes away, (iv) goes into liquidation, is dissolved, or is wound up. After termination of the agreement (for whatever reason), the User must cease and desist all use of Givt. The User must then remove all copies (including backup copies) of Givt from all of their systems.\n8.2 If any provision of these terms is void or nullified, this does not affect the validity of the entire agreement, and the other provisions of these terms will remain in force. In that case, the parties will establish (a) new provision(s) to replace it, giving shape to the intention of the original agreement as much as is legally possible.\n8.3 The User is not permitted to transfer rights and/or obligations arising from the use of Givt and these terms to third parties without the prior written consent of Givt B.V. Conversely, Givt B.V. is permitted to do so.\n8.4 Any disputes arising from or in connection with these terms will be finally settled by the court of Lelystad. Before the dispute is referred to the court, you and we will endeavor to resolve the dispute amicably.\n8.5 Dutch law applies to these Terms of Use.\n8.6 The Terms of Use do not prejudice the User\'s mandatory statutory rights as a consumer.\n8.7 Givt B.V. has an internal complaints procedure. Givt B.V. handles complaints efficiently and as soon as is reasonably possible. If the User has a complaint about the implementation of these terms by Givt B.V., the User must submit it in writing to Givt B.V. (via support@givtapp.net).';

  @override
  String get policyText =>
      'Last updated: May 26, 2025\nTranslation of original: 2.0\nPrivacy Statement of the Givt Service\n\nThrough the Givt service – consisting of both an app and an online platform – sensitive data, or personal data, is processed. Givt B.V. considers the careful handling of personal data to be of great importance. Therefore, we process and secure personal data with care.\n\nIn our processing, we comply with the requirements of the General Data Protection Regulation (GDPR). This means, among other things, that we:\n- clearly state the purposes for which we process personal data;\n- limit our collection of personal data to only that which is necessary for legitimate purposes;\n- take appropriate security measures;\n- respect your rights (access, correction, deletion, objection);\n- only share data with third parties when necessary or legally required;\n- guarantee the anonymity of donors towards charities.\n\n1. Data Controller\nGivt B.V. is the data controller for all data processing within the app and the platform. Our processing is registered with the Dutch Data Protection Authority (Autoriteit Persoonsgegevens) under number M1640707. In this privacy statement, we explain which personal data we collect and use, and for what purpose. We recommend that you read it carefully.\n\nFor questions about this statement or your rights, you can contact us via info@givtapp.net.\n\n2. Use of Personal Data\nWhen using our services, we may process the following personal data:\n\nName, address, and city of residence (NAW)\nEmail address\nPhone number\nPayment details\nWe use this data for the following purposes and on the following legal bases:\n- Execution of donations – performance of a contract\n- Account registration and user convenience – legitimate interest\n- Sending newsletters – consent\n- Customer contact via contact form or email – legitimate interest\n- Analysis of user behavior (donation flow) – legitimate interest\n- Improving the service and app – legitimate interest\n- Compliance with legal obligations – legal basis\n\n3. Analysis of User Behavior\nWe collect behavioral data on how users use our app and online donation environment. This includes clicks on buttons, the flow of donation processes, and technical error messages. This helps us to improve usability and identify bottlenecks.\n\nFor these analyses, we use the tool Amplitude. This tool collects pseudonymized data and only links it to users with an account. We use this information exclusively internally. A data processing agreement has been concluded with Amplitude. Data is not sold or shared with third parties.\n\n4. Cookies\nOur website uses cookies and similar technologies. Cookies are only placed if you give your consent via our cookie banner. Functional cookies (for the functioning of the site) are always placed.\n\nWe use, among others, Google Analytics (with IP anonymization) to analyze website usage. The _ga cookie is stored for a maximum of 2 years.\n\nYou can always change your cookie preferences via our cookie banner or browser settings.\n\n5. Newsletter and Contact\nWe offer a newsletter to inform interested parties about our (new) products and/or services. Each newsletter contains a link to unsubscribe. Your email address is automatically added to the list of subscribers.\n\nIf you fill out a contact form or send an email, we will retain the data for as long as necessary for the complete handling of your query.\n\n6. Advertising\nIn addition to the information provided via our online service infrastructure, we may inform you about our new products and services by email.\n\n7. Provision to Third Parties\nWe only provide your data to third parties if this is necessary for the performance of our agreement, or if legally required. Examples include payment processors or hosting providers. We never sell your data and guarantee the anonymity of donors towards charities. Transaction data may be anonymized for statistical purposes.\n\n8. Data Security\nWe take security measures to limit misuse of and unauthorized access to personal data. Specifically, we take the following measures:\n- Access to personal data is protected by a username and password.\n- We use secure connections (TLS/SSL or Transport Layer Security/Secure Sockets Layer) that encrypt all information between you and our online service infrastructure when you enter personal data.\n- We keep logs of all requests for personal data.\n\n9. Use of Location Data\nThe app may use location data to determine if you are in a place where Givt can be used. This data is processed exclusively locally on your device and is not transmitted or stored.\n\n10. Diagnostic Information from the App\nThe app sends anonymized information about its operation. This information contains non-personal data from your smartphone, such as the type and operating system, as well as the app version. This data is used solely to improve the Givt service or to answer your questions more quickly. This information is never provided to third parties.\n\n11. Changes to this Privacy Statement\nWe may change this privacy statement from time to time. The most current version is always available on our website. We recommend that you consult this statement regularly.\n\n12. Accessing and Changing Your Data\nYou have the right to access your data, to have it corrected or deleted, to object to its processing, and to withdraw your consent. You can contact us at any time using the details below:\n\nGivt B.V.\nBongerd 159\n8212 BJ LELYSTAD\nThe Netherlands\n+31 320 320 115\ninfo@givtapp.net\nChamber of Commerce (KVK) no: 64534421';

  @override
  String get needHelpTitle => 'Need help?';

  @override
  String get findAnswersToYourQuestions =>
      'Here you\'ll find answers to your questions and useful tips';

  @override
  String get questionHowDoesRegisteringWorks => 'How does registration work?';

  @override
  String get questionWhyAreMyDataStored =>
      'Why does Givt store my personal information?';

  @override
  String get faQvraag1 => 'What is Givt?';

  @override
  String get faQvraag2 => 'How does Givt work?';

  @override
  String get faQvraag3 =>
      'How can I change my settings or personal information?';

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
  String get faQantwoord1 =>
      'Donating with your smartphone\n Givt is the solution for giving with your smartphone when you are not carrying cash. Everyone owns a smartphone and with the Givt app you can easily participate in the offering. \n It’s a personal and conscious moment, as we believe that making a donation is not just a financial transaction. Using Givt feels as natural as giving cash. \n \n\n Why \'Givt\'?\n The name Givt was chosen because it is about ‘giving’ as well as giving a ‘gift’. We were looking for a modern and compact name that looks friendly and playful. In our logo you might notice that the green bar combined with the letter ‘v’ forms the shape of an offering bag, which gives an idea of the function. \n \n\n The Netherlands, Belgium and the United Kingdom\n There is a team of specialists behind Givt, divided over the Netherlands, Belgium and the United Kingdom. Each one of us is actively working on the development and improvement of Givt. Read more about us on www.givtapp.net.';

  @override
  String get faQantwoord2 =>
      'The first step was installing the app. For Givt to work effectively, it’s important that you enable Bluetooth and have a working internet connection. \n \n\n Then register yourself by filling in your information and signing a mandate. \n You’re ready to give! Open the app, select an amount, and scan a QR code, move your phone towards the collection bag or basket, or select a cause from the list.\n Your chosen amount will be saved, withdrawn from your account and distributed to the church or collecting charities.\n \n\n If you don’t have an internet connection when making your donation, the donation will be sent at a later time when you re-open the app. Like when you are in a WiFi zone.';

  @override
  String get faQantwoord3 =>
      'You can access the app menu by tapping the menu at the top left of the ‘Amount’ screen. To change your settings, you have to log in using your e-mail address and password, fingerprint/Touch ID or a FaceID. In the menu you can find an overview of your donations, adjust your maximum amount, review and/or change your personal information, change your amount presets, fingerprint/Touch ID or FaceID, or terminate your Givt account.';

  @override
  String get faQantwoord4 =>
      'More and more organisations\n You can use Givt in all organisations that are registered with us. More organisations are joining every week.\n \n\n Not registered yet? \n If your organisation is not affiliated with Givt yet, please contact us at +44 2037 908068 or info@givt.app .';

  @override
  String get faQantwoord5 =>
      'Better World Payments\n When installing Givt, the user gives the app authorisation to debit their account. The transactions are handled by Better World Payments – a bank that specialises in processing mandates.\n \n\n Revocable afterwards\n No transactions take place in the moment of giving. The transactions take place afterwards via a direct debit. Since these transactions are revocable, it is completely safe and immune to fraud.';

  @override
  String get faQantwoord6 =>
      'Continues to develop\n Givt continues to develop their service. Right now you can easily give during the offering using your smartphone, but it doesn\'t stop there. Curious to see what we are working on? Join us for one of our Friday afternoon demos.\n \n\n Tax return\n At the end of the year you can request an overview of all your donations, which makes it easier for you when it comes to tax declaration. Eventually we would like to see that all donations are automatically filled in on the declaration.';

  @override
  String get faQantwoord7 =>
      'Safe and risk free \n It is very important to us that everything is safe and risk free. Each user has a personal account with its own password. You need to login to view or change your settings.\n \n\n Handling transactions \n The transactions are handled by Better World Payments – a bank that specialises in processing mandates. \n \n\n Immune to fraud \n When installing Givt, the user gives the app authorisation to debit their account.\n We want to emphasise that no transactions take place in the moment of giving. The transactions take place afterwards via a direct debit. Since these transactions are revocable, it is completely safe and immune to fraud. \n \n\n Overview \n Organisations can login to the Givt dashboard. This dashboard gives an overview of all financial transactions, from the moment of giving up to the full processing of the payment. In this way any collection can be followed from start to finish.\n Organisations can see how many people used Givt, but not who they are.';

  @override
  String get faQantwoord8 =>
      'We are sorry to hear that! We would like to hear why.\n \n\n If you no longer want to use Givt, you can unsubscribe for all Givt services.\n To unsubscribe, go to your settings via the user menu and choose ‘Terminate my account’.';

  @override
  String get privacyTitle => 'Privacy Statement';

  @override
  String get acceptTerms =>
      'By continuing you agree to our terms and conditions.';

  @override
  String get faqHowDoesGivingWork => 'How can I give?';

  @override
  String get faqHowDoesManualGivingWork => 'How can I select the recipient?';

  @override
  String givtNotEnough(Object value0) {
    return 'Sorry, but the minimum amount we can work with is $value0.';
  }

  @override
  String get slimPayInformationPart2 =>
      'That\'s why we ask you this one time to sign a SEPA eMandate.\n \n\n Since we\'re working with mandates, you have the option to revoke your donation if you should wish to do so.';

  @override
  String get unregister => 'Terminate account';

  @override
  String get unregisterInfo =>
      'We’re sad to see you go! We will delete all your personal information.\n \n\n There’s one exception: if you donated to a PBO-registered organisation, we are obligated to keep the information about your donation, your name and address for at least 7 years. Your e-mail address and phone number will be removed.';

  @override
  String get unregisterSad =>
      'We\'re sad to see you leave\n and we hope to see you again.';

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
  String get historyIsEmpty =>
      'This is where you\'ll find information about your donations, but first you\'ll need to start giving';

  @override
  String get updateAlertTitle => 'Update available';

  @override
  String get updateAlertMessage =>
      'A new version of Givt is available, do you want to update now?';

  @override
  String get criticalUpdateTitle => 'Critical update';

  @override
  String get criticalUpdateMessage =>
      'A new critical update is available. This is necessary for the proper functioning of the Givt app.';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get faQvraag9 => 'Where can I see the overview of my donations?';

  @override
  String get faQantwoord9 =>
      'Press the menu at the top left of the ‘Amount’ screen to access your app menu. To get access you have to login using your e-mail address and password. Choose ‘Donations history’ to find an overview of your recent activity. This list consists of the name of the recipient, time, and date. The coloured line indicates the status of the donation: In process, processed, refused by bank, or cancelled by user.\n You can request an overview of your donations for your tax declaration at the end of each year.';

  @override
  String get faqQuestion11 => 'How do I set my Touch ID or Face ID?';

  @override
  String get faqAnswer11 =>
      'Go to your settings by pressing menu in the top left of the screen. There you can protect your Givt app with a fingerprint/Touch ID or a FaceID (only available on certain iPhones). \n \n\n When one of these settings is activated, you can use it to access your settings instead of using your e-mail address and password.';

  @override
  String get answerHowDoesRegistrationWork =>
      'To use Givt, you have to register in the Givt app. Go to your app menu and choose \'Finish registration\'. You set up a Givt account, fill in some personal details and give permission to collect the donations made with the app. The transactions are handled by Better World Payments - a bank that specialises in the treatment of permissions. When your registration is complete, you are ready to give. You only need your login details to see or change your settings.';

  @override
  String get answerHowDoesGivingWork =>
      'From now on, you can give with ease. Open the app, choose the amount you want to give, and select 1 of the 4 possibilities: you can give to a collection device, scan a QR code, choose from a list, or give at your location. \n Don\'t forget to finish your registration, so your donations can be delivered to the right charity.';

  @override
  String get answerHowDoesManualGivingWork =>
      'When you aren’t able to give to a collection device, you can choose to select the recipient manually. Choose an amount and press ‘Next’. Next, select ‘Choose from the list’ and select \'Churches\', \'Charities\', \'Campaigns\' or \'Artists\'. Now choose a recipient from one of these lists and press ‘Give’.';

  @override
  String get informationPersonalData =>
      'Givt needs this personal data to process your gifts. We are careful with this information. You can read it in our privacy statement.';

  @override
  String get informationAboutUs =>
      'Givt is a product of Givt B.V.\n \n\n We are located on the Bongerd 159 in Lelystad, The Netherlands. For questions or complaints you can reach us via +31 320 320 115 or support@givtapp.net.\n \n\n We are registered in the trade register of the Dutch Chamber of Commerce under number 64534421.';

  @override
  String get titleAboutGivt => 'About Givt / Contact';

  @override
  String get readPrivacy => 'Read privacy statement';

  @override
  String get faqQuestion12 =>
      'How long does it take before my donation is withdrawn from my bank account?';

  @override
  String get faqAnswer12 =>
      'Your donation will be withdrawn from your bank account within two working days.';

  @override
  String get faqQuestion14 => 'How can I give to multiple collections?';

  @override
  String get faqAnswer14 =>
      'Are there multiple collections in one service? Even then you can easily give in one move!\n By pressing the ‘Add collection’-button, you can activate up to three collections. For each collection, you can enter your own amount. Choose your collection you want to adjust and enter your specific amount or use the presets. You can delete a collection by pressing the minus sign, located to the right of the amount.\n \n\n The numbers 1, 2 or 3 distinguish the different collections. No worries, your church knows which number corresponds to which collection purpose. Multiple collections are very handy, because all your gifts are sent immediately with your first donation. In the overview you can see a breakdown of all your donations.\n \n\n Do you want to skip a collection? Leave it open or remove it.';

  @override
  String get faQvraag15 => 'Are my Givt donations tax deductible?';

  @override
  String get faQantwoord15 =>
      'Yes, your Givt donations are tax deductible, but only when you’re giving to institutions that are registered as ANBI (Public Benefit Organisation) or SBBI (Social Importance Organisation). Check if the church or institution has such a registration. Since it’s quite a bit of work to gather all your donations for your tax declaration, the Givt app offers you the option to annually download an overview of your donations. Go to your Donations in the app-menu to download the overview. You can use this overview for your tax declaration. It’s a piece of cake.';

  @override
  String get amountPresetsChangingPresets =>
      'You can add amount presets to your keyboard. This is where you can enable and set the amount presets.';

  @override
  String get amountPresetsChangePresetsMenu => 'Change amount presets';

  @override
  String get changeBankAccountNumberAndSortCode => 'Change bank details';

  @override
  String get updateBacsAccountDetailsError =>
      'Alas, the Sortcode or Account number is invalid. You can change the Sortcode and/or Account number under ‘Personal information’ in the menu.';

  @override
  String get ddiFailedTitle => 'DDI request failed';

  @override
  String get ddiFailedMessage =>
      'At the moment it is not possible to request a Direct Debit Instruction. Please try again in a few minutes.';

  @override
  String get faQantwoord5Gb =>
      'Handling transactions\n The transactions are handled by Access PaySuite; a payment institution specialised in processing BACS Direct Debit Instructions. Access PaySuite is under the supervision of the Financial Conduct Authority.\n \n\n Revertible afterwards\n The transactions take place afterwards via a direct debit under Givt Ltd. We want to emphasise that no transactions take place in the moment of giving. Since these transactions are revocable, it is completely safe and immune to fraud.';

  @override
  String get faQvraag15Gb => 'Can I Gift Aid my donations?';

  @override
  String get faQantwoord15Gb =>
      'Yes, you can. In the Givt app you can enable Gift Aid. You can also always see how much Gift Aid has been claimed on your donations.\n \n\n Donating through Gift Aid means charities can claim an extra 25p for every £1 you give. It will not cost you any extra.';

  @override
  String get answerHowDoesRegistrationWorkGb =>
      'To start giving, all you need is an e-mail address. Once you have entered this, you are ready to give.\n \n\n Please note: you need to fully register to ensure that all your previous and future donations can be processed. Go to the menu in the app and choose ‘Complete registration’. Here, you set up a Givt account by filling in your personal information and by us giving permission to debit the donations made in the app. Those transactions are processed by Access PaySuite, who are specialised in direct debits. \n \n\n When your registration is complete, you are ready to give with the Givt app. You only need your login details to see or change your settings.';

  @override
  String get faQantwoord7Gb =>
      ' Personal safety\n It is very important to us that everything is safe and risk free. Each user has a personal account with its own password. You need to log in to view or change your settings.\n \n\n Handling transactions\n The transactions are handled by Access PaySuite; a payment institution specialised in processing BACS Direct Debit Instructions. Access PaySuite is under the supervision of the Financial Conduct Authority.\n \n\n Immune to fraud\n When installing Givt, the user gives the app authorisation to debit their account. We want to emphasise that no transactions take place in the moment of giving. The transactions take place afterwards via a direct debit under Givt Ltd. Since these transactions are revocable, it is completely safe and immune to fraud.\n \n\n Overview\n Individual users can see an overview of their donations in the app. Organisations can log in to the Givt dashboard. This dashboard gives an overview of all financial transactions, from the moment of giving up to the full processing of the payment. In this way any collection can be followed from start to finish. Organisations can see how many people used Givt, but not who they are.';

  @override
  String get giftAidSetting => 'I want to use/keep using Gift Aid';

  @override
  String get giftAidInfo =>
      'As a UK taxpayer, you can use the Gift Aid initiative. Every year we will remind you of your choice. Activating Gift Aid after March 1st will count towards March and the next tax year. All your donations made before entering your account details will be considered eligible if they were made in the current tax year.';

  @override
  String get giftAidHeaderDisclaimer =>
      'When you enable this option, you agree to the following:';

  @override
  String get giftAidBodyDisclaimer =>
      'I am a UK taxpayer and understand that if I pay less Income Tax and/or Capital Gains Tax in the current tax year than the amount of Gift Aid claimed on all my donations, it is my responsibility to pay any difference.';

  @override
  String get giftAidInfoTitle => 'What is Gift Aid?';

  @override
  String get giftAidInfoBody =>
      'Donating through Gift Aid means charities can claim an extra 25p for every £1 you give. It will not cost you any extra. \n \n\n Gift Aid treats the donations as being made after deduction of income tax at the basic rate. The charity you give to can reclaim this basic rate income tax paid on the gift from HMRC. Your donations will qualify as long as they’re not more than 4 times what you have paid in tax in that tax year. \n  \n For more info, please go to: www.gov.uk/donating-to-charity/gift-aid';

  @override
  String get faqAnswer12Gb =>
      'Your donation will be withdrawn from your bank account within five working days. The first time you make a donation with Givt, the donation will be withdrawn after two weeks, as it takes extra time to set up your registration.';

  @override
  String get faqVraagDdi =>
      'Does the Direct Debit mean I signed up to monthly deductions?';

  @override
  String get faqAntwoordDdi =>
      'NO! You sign a direct debit so we can deduct the donations you have made using the Givt app. The deductions we make are incidental, user-driven deductions.\n \n\n We will not debit your account unless you make a donation using the Givt app.';

  @override
  String get charity => 'Charity';

  @override
  String get artist => 'Artist';

  @override
  String get church => 'Church';

  @override
  String get campaign => 'Campaign';

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
  String get informationAboutUsGb =>
      'Givt is a product of Givt LTD.\n \n\n We are located at the Blackthorn House in Birmingham, England. For questions or complaints you can reach us via 020 3790 8068 or support@givt.co.uk\n \n\n We are registered under the Company Registration Number 11396586.';

  @override
  String get authoriseBluetooth => 'Authorise Givt to use Bluetooth';

  @override
  String get authoriseBluetoothErrorMessage =>
      'Give Givt permission to access your Bluetooth so you\'re ready to give to a collection.';

  @override
  String get authoriseBluetoothExtraText =>
      'Go to Settings > Privacy > Bluetooth and select \'Givt\'.';

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
  String get menuItemRecurringDonation => 'Recurring donations';

  @override
  String get setupRecurringGiftHalfYear => 'half year';

  @override
  String get setupRecurringGiftText6 => 'times';

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
  String get setupRecurringDonationFailed =>
      'The recurring donation was not set up successfully. Please try again later.';

  @override
  String get emptyRecurringDonationList =>
      'All your recurring donations will be visible here.';

  @override
  String cancelRecurringDonationAlertTitle(Object value0) {
    return 'Are you sure you want to stop donating to $value0?';
  }

  @override
  String get cancelRecurringDonationAlertMessage =>
      'The donations already made will not be cancelled.';

  @override
  String get cancelRecurringDonation => 'Stop';

  @override
  String get setupRecurringGiftText7 => 'Each';

  @override
  String get cancelRecurringDonationFailed =>
      'The recurring donation was not cancelled successfully. Please try again later.';

  @override
  String get reportMissingOrganisationListItem =>
      'Report a missing organisation';

  @override
  String get reportMissingOrganisationPrefilledText =>
      'Hi! I would really like to give to:';

  @override
  String get setupRecurringDonationFailedDuplicate =>
      'The recurring donation was not set up successfully. You have already made a donation to this organisation with the same repeating period.';

  @override
  String get setupRecurringDonationFailedDuplicateTitle => 'Duplicate donation';

  @override
  String get goToListWithRecurringDonationDonations => 'Overview';

  @override
  String get recurringDonationFutureDetailSameYear => 'Upcoming donation';

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
  String get amountLimitExceededRecurringDonation =>
      'This amount is higher than your chosen maximum amount. Do you want to continue or change the amount?';

  @override
  String get sepaVerifyBody =>
      'If any of the above is incorrect, please abort the registration and change your \'Personal information\'';

  @override
  String get signMandate => 'Sign mandate';

  @override
  String get signMandateDisclaimer =>
      'By continuing you sign the eMandate with above details.\n The mandate will be sent to you via mail.';

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
  String get budgetExternalGiftsInfo =>
      'Get a complete overview of all of your contributions. Add any contributions that you have made outside of Givt. You will find everything in your summary.';

  @override
  String get budgetExternalGiftsSubTitle => 'Your donations outside Givt';

  @override
  String get budgetExternalGiftsOrg => 'Name of organisation';

  @override
  String get budgetExternalGiftsTime => 'Frequency';

  @override
  String get budgetExternalGiftsAmount => 'Amount';

  @override
  String get budgetExternalGiftsSave => 'Save';

  @override
  String get budgetGivingGoalTitle => 'Setup giving goal';

  @override
  String get budgetGivingGoalInfo =>
      'Give consciously. Consider each month whether your giving behaviour matches your personal giving goals.';

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
  String get budgetTestimonialSummary =>
      '”Since I’ve been using the summary, I have gained more insight into what I give. I give more consciously because of it.\"';

  @override
  String get budgetTestimonialGivingGoal =>
      '”My giving goal motivates me to regularly reflect on my giving behaviour.”';

  @override
  String get budgetTestimonialExternalGifts =>
      '\"I like that I can add any external donations to my summary. I can now simply keep track of my giving.\"';

  @override
  String get budgetTestimonialYearlyOverview =>
      '\"Givt\'s annual overview is great! I\'ve also added all my donations outside Givt. This way I have all my giving in one overview, which is essential for my tax return.\"';

  @override
  String get budgetPushMonthly => 'See what you have given this month.';

  @override
  String get budgetTooltipYearly =>
      'One overview for the tax return? View the overview of all your donations here.';

  @override
  String get budgetPushMonthlyBold => 'Your monthly summary is ready.';

  @override
  String get budgetExternalGiftsListAddEditButton =>
      'Manage external donations';

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
  String get budgetTestimonialSummaryAction => 'View your summary';

  @override
  String get budgetTestimonialGivingGoalAction => 'Setup your giving goal';

  @override
  String get budgetTestimonialExternalGiftsAction => 'Add external donations';

  @override
  String get budgetSummaryGivingGoalReached => 'Giving goal achieved';

  @override
  String get budgetSummaryNoGiftsExternal =>
      'Donations outside Givt this month? Add here';

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
  String get budgetYearlyOverviewDetailTipBold =>
      'TIP: add your external donations';

  @override
  String get budgetYearlyOverviewDetailTipNormal =>
      'to get a total overview of what you give, both via the Givt app and not via the Givt app.';

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
  String get budgetSummaryNoGiftsYearlyOverview =>
      'You have no donations (yet) this year';

  @override
  String budgetPushYearlyNearlyEndBold(Object value0) {
    return '$value0 is almost over... Have you made up your balance yet?';
  }

  @override
  String get budgetPushYearlyNearlyEnd =>
      'View your annual overview and see what you have given so far.';

  @override
  String get budgetTestimonialYearlyOverviewAction => 'Go to the overview';

  @override
  String get duplicateAccountOrganisationMessage =>
      'Are you sure you are using your own bank details? Could you please check in the menu, under \'Personal information\'? You can change the information there as well, if necessary.';

  @override
  String get policyTextUs =>
      '1. Givt App – US Privacy Policy\nLatest Amendment: [01-03-2025]\nVersion [1.2]\nGivt Inc. Privacy Policy\n\nIntroduction\nThis Privacy Policy outlines Givt Inc.’s (“we,” “our,” or “the Company”) practices with respect to information collected from our Application\n\nGrounds for data collection\nProcessing of your personal information (meaning, any information relating to an identified or identifiable individual; hereinafter “Personal\nInformation”)  is necessary for the performance of our contractual obligations towards you and providing you with our services, to protect\nour legitimate interests and for compliance with legal and financial regulatory obligations to which we are subject.\nWhen you use our App or register yourself or an organization you represent with us, you consent to the collection, storage, use, disclosure and other uses of your Personal Information as described in this Privacy Policy.\nWe encourage our Users to carefully read the Privacy Policy and use it to make informed decisions.\nWhat information do we collect?\nWe collect two types of data and information from Users. The first type of information is un-identified and non-identifiable information pertaining to a User(s), which may be made available or gathered via your use of the App (“Non-personal Information”). We are not aware of the identity of a User from which the Non-personal Information was collected. Non-personal Information which is being collected may include your aggregated usage information and technical information transmitted by your device, including certain software and\nhardware information (e.g. language preference, access time, etc.) in order to enhance the functionality of our App.\nThe second type of information is Personal Information, which is personally identifiable information, namely information that identifies an\nindividual or may with reasonable effort identify an individual. Such information includes:\n\nDevice Information: We collect Personal Information from your device. Such information includes geolocation data, IP address, unique identifiers (e.g. MAC address and UUID) and other information which relates to your activity through the App.\n\nService User Information: We collect additional information for individuals who would like to use our Services. This is gathered\nthrough the App and includes all the information needed to register for our service:\n– Name and address,\n– Date of birth,\n– email address,\n– secured password details, and\n– bank details for the purposes of making payments.\n\n\nContact information: If you choose to contact us you will be asked to provide us with certain details such as: full name; e-mail or physical address, and other relevant information. This may be for yourself or for people in the organization you represent.\n\n\nHow do we receive information about you?\n\nWe receive your Personal Information from various sources:\n\n● When you voluntarily provide us with your personal details in order to register on our App;\n\n● When you use or access our App in connection with your use of our services;\nWhen you use or access our Dashboard in connection with your organization’s use of our services;\n\n● From third party providers, services and public registers (for example, traffic analytics vendors); and,\n\n● Through diagnostic information from the App. The App will send us anonymous information about its functioning. This information contains non-personal data from your smartphone like its type and operating system, but also the version information of the App. This data is solely used for purposes of improving our Service or allowing better responses to your questions.\n\n\nWhat do we do with the information we collect?\n\n\nWe may use the information for the following:\n● To provide the services through the App – we will use a minimum of name and bank details to perform the services of effecting payment(s) via the App. Payment information is never shared with intended recipients of donations;\n● Communicating with you – sending you notices regarding our services, providing you with technical information and responding to\nany customer service issue you may have; to keep you informed of our latest updates and services;\n● Conducting statistical and analytical activities, intended to improve the App and/or the App.\n● For marketing and advertising purposes, such as developing and providing promotional and advertising materials that may be relevant,\nvaluable or otherwise of interest to you.\nIn addition to the different uses listed above, we may transfer or disclose Personal Information to our subsidiaries, affiliated companies and subcontractors in relation to services that we provide to you. We may also disclose information if we have good faith to believe that\ndisclosure of such information is helpful or reasonably necessary to: (i) comply with any applicable law, regulation, legal process or governmental request; (ii) enforce our policies (including our Agreement), including investigations of potential violations thereof; (iii) investigate, detect, prevent, or take action regarding illegal activities or other wrongdoing, suspected fraud or security issues; (iv) to establish or exercise our rights to defend against legal claims; (v) prevent harm to the rights, property or safety of us, our users, yourself or any third party; or (vi) for the purpose of collaborating with law enforcement agencies and/or in case we find it necessary in order to enforce intellectual property or other legal rights.\n\n\nProviding Data to Third Parties When you make a donation, personal information about you, your name, the amount, campaign and email address is shared with the intended recipient of your donation. In some cases, you may have the option to remain anonymous. If you choose to remain anonymous, your personal information will not be shared with the intended recipient of your donation.\nWhen you make a donation, personal information about you, your name, the amount, campaign and email address is shared with the intended recipient of your donation. In some cases, you may have the option to remain anonymous. If you choose to remain anonymous, your personal information will not be shared with the intended recipient of your donation.\n\n\nWe may provide your information to our partners. For example, we may share any information we receive with vendors and service providers retained in connection with the provision of the App. If you use the App to make a donation, your payment-related information, such as credit card or other financial information, is collected by our third-party payment processor on our behalf. In all cases, these parties are necessary to provide the services.\nWe may collect, use, and share anonymous data for statistical purposes, reviews, and comparisons; no such data will be traceable to individuals.\nWe are committed to making it easier for donors to give to charities of their choosing, and we will never sell data to third parties.\nWe may access, preserve, and disclose your information if we believe doing so is required or appropriate to: (a) comply with law enforcement requests and legal process, such as a court order or subpoena; (b) respond to your requests; or (c) protect your, our, or others’ rights, property, or safety.\nWe may transfer your information to service providers, advisors, potential transactional partners, or other third parties in connection with the consideration, negotiation, or completion of a corporate transaction in which we are acquired by or merged with another company or we sell, liquidate, or transfer all or a portion of our assets. The use of your information following any of these events will be governed by the provisions of this Privacy Policy in effect at the time the applicable information was collected.\nWe may also disclose your information with your permission.\n\n\nInformation from Cookies and Other Tracking Technologies. \nWe and our third-party partners collect information about your activities on our Application using cookies, pixel tags, SDKs, or other tracking technologies. Our third-party partners, such as analytics, authentication, and security partners, may also use these technologies to collect information about your online activities over time and across different services.\n\n\nAnalytics Partners. We use analytics services such as Google Analytics to collect and process certain analytics data. [You can learn more about Google’s practices by visiting https://www.google.com/policies/privacy/partners/.]\n\n\nCollection of Audio Data. \n\nIn order to create recorded messages for family members, our App collects audio data if you explicitly enable the App to have access to your device’s microphone via your device’s operating system settings. This feature is designed to enhance user experience by allowing personalized messages to be shared through our services. Audio data is only used for the purpose of delivering the recorded message. Audio recording occurs solely during the active use of this feature. Audio recordings are not shared with third parties unless explicitly required for service delivery or mandated by law. You can disable microphone access at any time through your device settings, which may limit your ability to use this feature.\n\nUser Rights\nYou may request to:\n1.Receive confirmation as to whether or not personal information concerning you is being processed, and access your stored personal information, together with supplementary information.\n2.Receive a copy of personal information you directly volunteer to us in a structured, commonly used and machine-readable format.\n3.Request rectification of your personal information that is in our control.\n4.Request erasure of your personal information.\n5.Object to the processing of personal information by us.\n6.Request portability of your personal information.\n7.Request to restrict processing of your personal information by us.\n8.Lodge a complaint with a supervisory authority.\n\nHowever, please note that these rights are not absolute, and may be subject to our own legitimate interests and regulatory requirements.\nBefore fulfilling your request, we may ask you to provide reasonable information to verify your identity.\n\nRetention\nWe will retain your personal information for as long as necessary to provide our services, and as necessary to comply with our legal\nobligations, resolve disputes, and enforce our policies. Retention periods will be determined taking into account the type of information that is collected and the purpose for which it is collected, bearing in mind the requirements applicable to the situation and the need to destroy outdated, unused information at the earliest reasonable time. Under applicable regulations, we will keep records containing client personal data, account opening documents, communications and anything else as required by applicable laws and regulations.\nWe may rectify, replenish or remove incomplete or inaccurate information, at any time and at our own discretion.\n\nUse of Location Services\nThe App may use the location services as provided by the operating system on the smartphone. With these services, the App may determine the location of the user. The location data will not be sent anywhere outside the smartphone, and is solely used to determine whether the user is in a location where it’s possible to use the App for donating. The locations where one can use App are downloaded to the smartphone prior to using the location services.\n\nHow do we safeguard your information?\nWe take security measures to reduce misuse of and unauthorized access to personal data. Although we take reasonable steps to safeguard information, we cannot be responsible for the acts of those who gain unauthorized access or abuse our App, and we make no warranty, express, implied or otherwise, that we will prevent such access.\n\nTransfer of data outside the EEA\nPlease note that some data recipients may be located outside the EEA. In such cases we will transfer your data only to such countries as approved by the European Commission as providing adequate level of data protection, or enter into legal agreements ensuring an adequate level of data protection. Data collected from Users located in the United States is stored in the United States.\n\nAdvertisements\nWe do not use third-party advertising technology to serve advertisements when you access the App.\n\nMarketing\nWe may use your Personal Information, such as your name, email address to send you a Newsletter about our products and services. You may opt out of receiving this Newsletter at any time by unsubscribing via the link in the newsletter.\nThird Parties\nThe App may contain links to other websites, products, or services that we do not own or operate. We are not responsible for the privacy\npractices of these third parties. Please be aware that this Privacy Policy does not apply to your activities on these third-party services or any information you disclose to these third parties. We encourage you to read their privacy policies before providing any information to them.\n\nUpdates or amendments to this Privacy Policy\nWe reserve the right to periodically amend or revise the Privacy Policy; material changes will be effective immediately upon the display of the revised Privacy policy. The last revision will be reflected in the “Last modified” section. If we materially change the ways in which we use or share personal information collected from you, we will notify you through the App, by email, or other communication. Your continued use of our Services following the notification of such amendments on our Website or through the App, constitutes your acknowledgment and consent of such amendments to the Privacy Policy and your agreement to be bound by the terms of such amendments.\n\nHow to contact us\nIf you have any general questions about the App or the information we collect about you and how we use it, you can contact us at:\nsupport@givt.app or by phone at 918-615-9611.\n';

  @override
  String get termsTextUs =>
      'GIVT INC.\n Terms of Use for Giving with Givt \n Last updated: July 13th, 2022\n Version: 1.2\n These terms of use describe the conditions under which you can use the services made available through the mobile or other downloadable application and website owned by Givt, Inc. (\"Givt\", and \"Service\" respectively) can be utilized by you, the User (\"you\"). These Terms of Use are a legally binding contract between you and Givt regarding your use of the Service.\n BY DOWNLOADING, INSTALLING, OR OTHERWISE ACCESSING OR USING THE SERVICE, YOU AGREE THAT YOU HAVE READ AND UNDERSTOOD, AND, AS A CONDITION TO YOUR USE OF THE SERVICE, YOU AGREE TO BE BOUND BY, THE FOLLOWING TERMS AND CONDITIONS, INCLUDING GIVT\'S PRIVACY POLICY (https://www.givt.app/privacy-policy) (TOGETHER, THESE \"TERMS\"). If you are not eligible, or do not agree to the Terms, then you do not have our permission to use the Service. YOUR USE OF THE SERVICE, AND GIVT\'S PROVISION OF THE SERVICE TO YOU, CONSTITUTES AN AGREEMENT BY GIVT AND BY YOU TO BE BOUND BY THESE TERMS.\n Arbitration NOTICE. Except for certain kinds of disputes described in Section 12, you agree that disputes arising under these Terms will be resolved by binding, individual arbitration, and BY ACCEPTING THESE TERMS, YOU AND GIVT ARE EACH WAIVING THE RIGHT TO A TRIAL BY JURY OR TO PARTICIPATE IN ANY CLASS ACTION OR REPRESENTATIVE PROCEEDING.\n 1. Givt Service Overview. Givt provides its users with a platform to make anonymous donations to any of the entities properly registered with Givt as a recipient of donations (\"Recipient\"). The Service is available for users through their smartphones, and other electronic device. \n 2. Eligibility. You must be at least 18 years old to use the Service. By agreeing to these Terms, you represent and warrant to us that: (a) you are at least 18 years old; (b) you have not previously been suspended or removed from the Service; and (c) your registration and your use of the Service is in compliance with any and all applicable laws and regulations. If you are an entity, organization, or company, the individual accepting these Terms on your behalf represents and warrants that they have authority to bind you to these Terms and you agree to be bound by these Terms. \n 3. Accounts and Registration. To access the Service, you must register for an account. When you register for an account, you may be required to provide us with some information about yourself, such as your (i) name (ii) address, (iii) phone number, and (iv) e-mail address. You agree that the information you provide to us is accurate, complete, and not misleading, and that you will keep it accurate and up to date at all times. When you register, you will be asked to create a password. You are solely responsible for maintaining the confidentiality of your account and password, and you accept responsibility for all activities that occur under your account. If you believe that your account is no longer secure, then you should immediately notify us at support@givt.app.\n 4. Processing Donations\n 4.1. Givt does not provide banking or payment services. To facilitate the processing and transfer of donations from you to Recipients, Givt has entered into an agreement with a third party payment processor (the \"Processor\"). The amount of your donation that is actually received by a Recipient will be net of fees and other charges imposed by Givt and Processor.\n 4.2. The transaction data, including the applicable designated Recipient, will be processed by Givt and forwarded to the Processor. The Processor will, subject to the Processor\'s online terms and conditions, initiate payment transactions to the bank account of the applicable designated Recipient. For the full terms of the transfer of donations, including chargeback, reversals, fees and charges, and limitations on the amount of a donation please see Processor\'s online terms and conditions.\n 4.3. You agree that Givt may pass your transaction and bank data to the Processor, along with all other necessary account and personal information, in order to enable the Processor to initiate the transfer of donations from you to Recipients. Givt reserves the right to change of Processor at any time. You agree that Givt may forward relevant information and data as set forth in this Section 4.3 to the new Processor in order to continue the processing and transfer of donations from you to Recipients.\n 5. License and intellectual property rights\n 5.1. Limited License. Subject to your complete and ongoing compliance with these Terms, Givt grants you a non-exclusive, non-sublicensable and non-transmittable license to (a) install and use one object code copy of any mobile or other downloadable application associated with the Service (whether installed by you or pre-installed on your mobile device manufacturer or a wireless telephone provider) on a mobile device that you own or control; (b) access and use the Service. You are not allowed to use the Service for commercial purposes.\n 5.2. License Restrictions. Except and solely to the extent such a restriction is impermissible under applicable law, you may not: (a) provide the Service to third parties; (b) reproduce, distribute, publicly display, publicly perform, or create derivative works for the Service; (c) decompile, submit to reverse engineer or modify the Service; (d), remove or bypass the technical provisions that are intended to protect the Service and/or Givt. If you are prohibited under applicable law from using the Service, then you may not use it. \n 5.3. Ownership; Proprietary Rights. The Service is owned and operated by Givt. The visual interfaces, graphics, design, compilation, information, data, computer code (including source code or object code), products, software, services, and all other elements of the Service provided by Givt (\"Materials\") are protected by intellectual property and other laws. All Materials included in the Service are the property of Givt or its third-party licensors. Except as expressly authorized by Givt, you may not make use of the Materials. There are no implied licenses in these Terms and Givt reserves all rights to the Materials not granted expressly in these Terms.\n 5.4. Feedback. We respect and appreciate the thoughts and comments from our users. If you choose to provide input and suggestions regarding existing functionalities, problems with or proposed modifications or improvements to the Service (\"Feedback\"), then you hereby grant Givt an unrestricted, perpetual, irrevocable, non-exclusive, fully paid, royalty-free right and license to exploit the Feedback in any manner and for any purpose, including to improve the Service and create other products and services. We will have no obligation to provide you with attribution for any Feedback you provide to us.\n 6. Third-Party Software. The Service may include or incorporate third-party software components that are generally available free of charge under licenses granting recipients broad rights to copy, modify, and distribute those components (\"Third-Party Components\"). Although the Service is provided to you subject to these Terms, nothing in these Terms prevents, restricts, or is intended to prevent or restrict you from obtaining Third-Party Components under the applicable third-party licenses or to limit your use of Third-Party Components under those third-party licenses.\n 7. Prohibited Conduct. BY USING THE SERVICE, YOU AGREE NOT TO:\n 7.1. use the Service for any illegal purpose or in violation of any local, state, national, or international law;\n 7.2. violate, encourage others to violate, or provide instructions on how to violate, any right of a third party, including by infringing or misappropriating any third-party intellectual property right;\n 7.3. interfere with security-related features of the Service, including by: (i) disabling or circumventing features that prevent or limit use, printing or copying of any content; or (ii) reverse engineering or otherwise attempting to discover the source code of any portion of the Service except to the extent that the activity is expressly permitted by applicable law;\n 7.4. interfere with the operation of the Service or any user\'s enjoyment of the Service, including by: (i) uploading or otherwise disseminating any virus, adware, spyware, worm, or other malicious code; (ii) making any unsolicited offer or advertisement to another user of the Service; (iii) collecting personal information about another user or third party without consent; or (iv) interfering with or disrupting any network, equipment, or server connected to or used to provide the Service;\n 7.5. perform any fraudulent activity including impersonating any person or entity, claiming a false affiliation or identity, accessing any other Service account without permission, or falsifying your age or date of birth;\n 7.6. sell or otherwise transfer the access granted under these Terms or any Materials or any right or ability to view, access, or use any Materials; or\n 7.7. attempt to do any of the acts described in this Section 7 or assist or permit any person in engaging in any of the acts described in this Section 7.\n 8. Term, Termination, and Modification of the Service\n 8.1. Term. These Terms are effective beginning when you accept the Terms or first download, install, access, or use the Service, and ending when terminated as described in Section 8.2.\n 8.2. Termination. If you violate any provision of these Terms, then your authorization to access the Service and these Terms automatically terminate. These Terms will end by operation of law in the event you are declared bankrupt, you apply for a moratorium on payments or a general attachment is levied against your assets, in the event of your death, or in the event you go into liquidation, are wound up or dissolved. Following the termination of these Terms (for whatever reason), you shall cease and desist from all further use of Givt. You must then delete all copies (including back-up copies) of Givt from all your systems.\n 8.3. In addition, Givt may, at its sole discretion, terminate these Terms or your account on the Service, or suspend or terminate your access to the Service, at any time for any reason or no reason, with or without notice, and without any liability to you arising from such termination. You may terminate your account and these Terms at any time by deleting or uninstalling the Service, or as otherwise indicated within the Service, or by contacting customer service at support@givt.app. In the event your smartphone, or other electronic device on which the Services are installed, is lost or stolen, inform Givt immediately by contacting support@givt.app. Upon receipt of a message Givt will use commercially reasonable efforts to block the account to prevent further misuse.\n 8.4. Effect of Termination. Upon termination of these Terms: (a) your license rights will terminate and you must immediately cease all use of the Service; (b) you will no longer be authorized to access your account or the Service. If your account has been terminated for a breach of these Terms, then you are prohibited from creating a new account on the Service using a different name, email address or other forms of account verification.\n 8.5. Modification of the Service. Givt reserves the right to modify or discontinue all or any portion of the Service at any time (including by limiting or discontinuing certain features of the Service), temporarily or permanently, without notice to you. Givt will have no liability for any change to the Service, or any suspension or termination of your access to or use of the Service. \n 9. Indemnity. To the fullest extent permitted by law, you are responsible for your use of the Service, and you will defend and indemnify Givt, its affiliates and their respective shareholders, directors, managers, members, officers, employees, consultants, and agents (together, the \"Givt Entities\") from and against every claim brought by a third party, and any related liability, damage, loss, and expense, including attorneys\' fees and costs, arising out of or connected with: (1) your unauthorized use of, or misuse of, the Service; (2) your violation of any portion of these Terms, any representation, warranty, or agreement referenced in these Terms, or any applicable law or regulation; (3) your violation of any third-party right, including any intellectual property right or publicity, confidentiality, other property, or privacy right; or (4) any dispute or issue between you and any third party. We reserve the right, at our own expense, to assume the exclusive defense and control of any matter otherwise subject to indemnification by you (without limiting your indemnification obligations with respect to that matter), and in that case, you agree to cooperate with our defense of those claims.\n 10. Disclaimers; No Warranties.\n THE SERVICE AND ALL MATERIALS AND CONTENT AVAILABLE THROUGH THE SERVICE ARE PROVIDED \"AS IS\" AND ON AN \"AS AVAILABLE\" BASIS. GIVT DISCLAIMS ALL WARRANTIES OF ANY KIND, WHETHER EXPRESS OR IMPLIED, RELATING TO THE SERVICE AND ALL MATERIALS AND CONTENT AVAILABLE THROUGH THE SERVICE, INCLUDING: (A) ANY IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, QUIET ENJOYMENT, OR NON-INFRINGEMENT; AND (B) ANY WARRANTY ARISING OUT OF COURSE OF DEALING, USAGE, OR TRADE. GIVT DOES NOT WARRANT THAT THE SERVICE OR ANY PORTION OF THE SERVICE, OR ANY MATERIALS OR CONTENT OFFERED THROUGH THE SERVICE, WILL BE UNINTERRUPTED, SECURE, OR FREE OF ERRORS, VIRUSES, OR OTHER HARMFUL COMPONENTS, AND GIVT DOES NOT WARRANT THAT ANY OF THOSE ISSUES WILL BE CORRECTED.\n NO ADVICE OR INFORMATION, WHETHER ORAL OR WRITTEN, OBTAINED BY YOU FROM THE SERVICE OR GIVT ENTITIES OR ANY MATERIALS OR CONTENT AVAILABLE THROUGH THE SERVICE WILL CREATE ANY WARRANTY REGARDING ANY OF THE GIVT ENTITIES OR THE SERVICE THAT IS NOT EXPRESSLY STATED IN THESE TERMS. WE ARE NOT RESPONSIBLE FOR ANY DAMAGE THAT MAY RESULT FROM THE SERVICE AND YOUR DEALING WITH ANY OTHER SERVICE USER. WE DO NOT GUARANTEE THE STATUS OF ANY ORGANIZATION, INCLUDING WHETHER AN ORGANIZATION IS A NOT-FOR-PROFIT, CHARITABLE, OR OTHER SIMILAR ORGANIZATION UNDER APPLICABLE LAWS, AND WE DO NOT MAKE ANY REPRESENTATIONS REGARDING THE TAX TREATMENT OF ANY DONATIONS, GIFTS, OR OTHER MONEYS TRANSFERRED OR OTHERWISE PROVIDED TO ANY SUCH ORGANIZATION. YOU ARE SOLELY RESPONSIBLE FOR DETERMINING WHETHER AN ORGANIZATION QUALIFIES AS A NOT-FOR-PROFIT, CHARITABLE, OR OTHER SIMILAR ORGANIZATION UNDER APPLICABLE LAWS AND TO UNDERSTAND THE TAX TREATMENT OF ANY DONATIONS, GIFTS OR OTHER MONEYS TRANSFERRED OR PROVIDED TO SUCH ORGANIZATIONS. YOU UNDERSTAND AND AGREE THAT YOU USE ANY PORTION OF THE SERVICE AT YOUR OWN DISCRETION AND RISK, AND THAT WE ARE NOT RESPONSIBLE FOR ANY DAMAGE TO YOUR PROPERTY (INCLUDING YOUR COMPUTER SYSTEM OR MOBILE DEVICE USED IN CONNECTION WITH THE SERVICE) OR ANY LOSS OF DATA, INCLUDING USER CONTENT.\n THE LIMITATIONS, EXCLUSIONS AND DISCLAIMERS IN THIS SECTION APPLY TO THE FULLEST EXTENT PERMITTED BY LAW. Givt does not disclaim any warranty or other right that Givt is prohibited from disclaiming under applicable law.\n 11. Liability\n 11.1. TO THE FULLEST EXTENT PERMITTED BY LAW, IN NO EVENT WILL THE GIVT ENTITIES BE LIABLE TO YOU FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL OR PUNITIVE DAMAGES (INCLUDING DAMAGES FOR LOSS OF PROFITS, GOODWILL, OR ANY OTHER INTANGIBLE LOSS) ARISING OUT OF OR RELATING TO YOUR ACCESS TO OR USE OF, OR YOUR INABILITY TO ACCESS OR USE, THE SERVICE OR ANY MATERIALS OR CONTENT ON THE SERVICE, WHETHER BASED ON WARRANTY, CONTRACT, TORT (INCLUDING NEGLIGENCE), STATUTE, OR ANY OTHER LEGAL THEORY, AND WHETHER OR NOT ANY GIVT ENTITY HAS BEEN INFORMED OF THE POSSIBILITY OF DAMAGE.\n 11.2. EXCEPT AS PROVIDED IN SECTIONS 11.2 AND 11.3 AND TO THE FULLEST EXTENT PERMITTED BY LAW, THE AGGREGATE LIABILITY OF THE GIVT ENTITIES TO YOU FOR ALL CLAIMS ARISING OUT OF OR RELATING TO THE USE OF OR ANY INABILITY TO USE ANY PORTION OF THE SERVICE OR OTHERWISE UNDER THESE TERMS, WHETHER IN CONTRACT, TORT, OR OTHERWISE, IS LIMITED TO US\$100.\n 11.3. EACH PROVISION OF THESE TERMS THAT PROVIDES FOR A LIMITATION OF LIABILITY, DISCLAIMER OF WARRANTIES, OR EXCLUSION OF DAMAGES IS INTENDED TO AND DOES ALLOCATE THE RISKS BETWEEN THE PARTIES UNDER THESE TERMS. THIS ALLOCATION IS AN ESSENTIAL ELEMENT OF THE BASIS OF THE BARGAIN BETWEEN THE PARTIES. EACH OF THESE PROVISIONS IS SEVERABLE AND INDEPENDENT OF ALL OTHER PROVISIONS OF THESE TERMS. THE LIMITATIONS IN THIS SECTION 11 WILL APPLY EVEN IF ANY LIMITED REMEDY FAILS OF ITS ESSENTIAL PURPOSE.\n 12. Dispute Resolution and Arbitration\n 12.1. Generally. Except as described in Section 12.2 and 12.3, you and Givt agree that every dispute arising in connection with these Terms, the Service, or communications from us will be resolved through binding arbitration. Arbitration uses a neutral arbitrator instead of a judge or jury, is less formal than a court proceeding, may allow for more limited discovery than in court, and is subject to very limited review by courts. This agreement to arbitrate disputes includes all claims whether based in contract, tort, statute, fraud, misrepresentation, or any other legal theory, and regardless of whether a claim arises during or after the termination of these Terms. Any dispute relating to the interpretation, applicability, or enforceability of this binding arbitration agreement will be resolved by the arbitrator.\n YOU UNDERSTAND AND AGREE THAT, BY ENTERING INTO THESE TERMS, YOU AND GIVT ARE EACH WAIVING THE RIGHT TO A TRIAL BY JURY OR TO PARTICIPATE IN A CLASS ACTION.\n 12.2. Exceptions. Although we are agreeing to arbitrate most disputes between us, nothing in these Terms will be deemed to waive, preclude, or otherwise limit the right of either party to: (a) bring an individual action in small claims court; (b) pursue an enforcement action through the applicable federal, state, or local agency if that action is available; (c) seek injunctive relief in a court of law in aid of arbitration; or (d) to file suit in a court of law to address an intellectual property infringement claim.\n 12.3. Opt-Out. If you do not wish to resolve disputes by binding arbitration, you may opt out of the provisions of this Section 12 within 30 days after the date that you agree to these Terms by sending an e-mail to Givt Inc. at support@givt.app, with the following subject line: \"Legal Department – Arbitration Opt-Out\", that specifies: your full legal name, the email address associated with your account on the Service, and a statement that you wish to opt out of arbitration (\"Opt-Out Notice\"). Once Givt receives your Opt-Out Notice, this Section 12 will be void and any action arising out of these Terms will be resolved as set forth in Section 12.2. The remaining provisions of these Terms will not be affected by your Opt-Out Notice.\n 12.4. Arbitrator. This arbitration agreement, and any arbitration between us, is subject to the Federal Arbitration Act and will be administered by the American Arbitration Association (\"AAA\") under its Consumer Arbitration Rules (collectively, \"AAA Rules\") as modified by these Terms. The AAA Rules and filing forms are available online at www.adr.org, by calling the AAA at +1-800-778-7879, or by contacting Givt.\n 12.5. Commencing Arbitration. Before initiating arbitration, a party must first send a written notice of the dispute to the other party by e-mail mail (\"Notice of Arbitration\"). Givt\'s e-address for Notice is: support@givt.app. The Notice of Arbitration must: (a) include the following subject line: \"Notice of Arbitration\"; (b) identify the name or account number of the party making the claim; (c) describe the nature and basis of the claim or dispute; and (d) set forth the specific relief sought (\"Demand\"). The parties will make good faith efforts to resolve the claim directly, but if the parties do not reach an agreement to do so within 30 days after the Notice of Arbitration is received, you or Givt may commence an arbitration proceeding. If you commence arbitration in accordance with these Terms, Givt will reimburse you for your payment of the filing fee, unless your claim is for more than US\$10,000 or if Givt has received 25 or more similar demands for arbitration, in which case the payment of any fees will be decided by the AAA Rules. If the arbitrator finds that either the substance of the claim or the relief sought in the Demand is frivolous or brought for an improper purpose (as measured by the standards set forth in Federal Rule of Civil Procedure 11(b)), then the payment of all fees will be governed by the AAA Rules and the other party may seek reimbursement for any fees paid to AAA.\n 12.6. Arbitration Proceedings. Any arbitration hearing will take place in Fulton County, Georgia unless we agree otherwise or, if the claim is for US\$10,000 or less (and does not seek injunctive relief), you may choose whether the arbitration will be conducted: (a) solely on the basis of documents submitted to the arbitrator; (b) through a telephonic or video hearing; or (c) by an in-person hearing as established by the AAA Rules in the county (or parish) of your residence. During the arbitration, the amount of any settlement offer made by you or Givt must not be disclosed to the arbitrator until after the arbitrator makes a final decision and award, if any. Regardless of the manner in which the arbitration is conducted, the arbitrator must issue a reasoned written decision sufficient to explain the essential findings and conclusions on which the decision and award, if any, are based. \n 12.7. Arbitration Relief. Except as provided in Section 12.8, the arbitrator can award any relief that would be available if the claims had been brough in a court of competent jurisdiction. If the arbitrator awards you an amount higher than the last written settlement amount offered by Givt before an arbitrator was selected, Givt will pay to you the higher of: (a) the amount awarded by the arbitrator and (b) US\$10,000. The arbitrator\'s award shall be final and binding on all parties, except (1) for judicial review expressly permitted by law or (2) if the arbitrator\'s award includes an award of injunctive relief against a party, in which case that party shall have the right to seek judicial review of the injunctive relief in a court of competent jurisdiction that shall not be bound by the arbitrator\'s application or conclusions of law. Judgment on the award may be entered in any court having jurisdiction.\n 12.8. No Class Actions. YOU AND GIVT AGREE THAT EACH MAY BRING CLAIMS AGAINST THE OTHER ONLY IN YOUR OR ITS INDIVIDUAL CAPACITY AND NOT AS A PLAINTIFF OR CLASS MEMBER IN ANY PURPORTED CLASS OR REPRESENTATIVE PROCEEDING. Further, unless both you and Givt agree otherwise, the arbitrator may not consolidate more than one person\'s claims and may not otherwise preside over any form of a representative or class proceeding.  \n 12.9. Modifications to this Arbitration Provision. If Givt makes any substantive change to this arbitration provision, you may reject the change by sending us written notice within 30 days of the change to Givt\'s address for Notice of Arbitration, in which case your account with Givt will be immediately terminated and this arbitration provision, as in effect immediately prior to the changes you rejected will survive.\n 12.10. Enforceability. If Section 12.8 or the entirety of this Section 12.10 is found to be unenforceable, or if Givt receives an Opt-Out Notice from you, then the entirety of this Section 12 will be null and void and, in that case, the exclusive jurisdiction and venue described in Section 13.2 will govern any action arising out of or related to these Terms. \n \n\n 13. Miscellaneous \n 13.1. General Terms. These Terms, including the Privacy Policy and any other agreements expressly incorporated by reference into these Terms, are the entire and exclusive understanding and agreement between you and Givt regarding your use of the Service. You may not assign or transfer these Terms or your rights under these Terms, in whole or in part, by operation of law or otherwise, without our prior written consent. We may assign these Terms and all rights granted under these Terms, at any time without notice or consent. The failure to require performance of any provision will not affect our right to require performance at any other time after that, nor will a waiver by us of any breach or default of these Terms, or any provision of these Terms, be a waiver of any subsequent breach or default or a waiver of the provision itself. Use of Section headers in these Terms is for convenience only and will not have any impact on the interpretation of any provision. Throughout these Terms the use of the word \"including\" means \"including but not limited to.\" If any part of these Terms is held to be invalid or unenforceable, then the unenforceable part will be given effect to the greatest extent possible, and the remaining parts will remain in full force and effect.\n 13.2. Governing Law. These Terms are governed by the laws of the State of Delaware without regard to conflict of law principles. You and Givt submit to the personal and exclusive jurisdiction of the state courts and federal courts located within Fulton County, Georgia for resolution of any lawsuit or court proceeding permitted under these Terms. We operate the Service from our offices in Georgia, and we make no representation that Materials included in the Service are appropriate or available for use in other locations.\n 13.3. Privacy Policy. Please read the Givt Privacy Policy (https://www.givt.app/privacy-policy) carefully for information relating to our collection, use, storage, and disclosure of your personal information. The Givt Privacy Policy is incorporated by this reference into, and made a part of, these Terms. \n 13.4. Additional Terms. Your use of the Service is subject to all additional terms, policies, rules, or guidelines applicable to the Service or certain features of the Service that we may post on or link to from the Service (the \"Additional Terms\"). All Additional Terms are incorporated by this reference into, and made a part of, these Terms.\n 13.5. Modification of these Terms. We reserve the right to change these Terms on a going-forward basis at any time. Please check these Terms periodically for changes. If a change to these Terms materially modifies your rights or obligations, we may require that you accept the modified Terms in order to continue to use the Service. Material modifications are effective upon your acceptance of the modified Terms. Immaterial modifications are effective upon publication. Except as expressly permitted in this Section 13.5, these Terms may be amended only by a written agreement signed by authorized representatives of the parties to these Terms. Disputes arising under these Terms will be resolved in accordance with the version of these Terms that was in effect at the time the dispute arose.\n 13.6. Consent to Electronic Communications. By using the Service, you consent to receiving certain electronic communications from us as further described in our Privacy Policy. Please read our Privacy Policy to learn more about our electronic communications practices. You agree that any notices, agreements, disclosures, or other communications that we send to you electronically will satisfy any legal communication requirements, including that those communications be in writing.\n 13.7. Contact Information. The Service is offered by Givt Inc. located at\n 3343 12 N Cheyenne Ave, #305 TULSA, OK, 74103. You may contact us by emailing us at support@givt.app.\n 13.8. Notice to California Residents. If you are a California resident, then under California Civil Code Section 1789.3, you may contact the Complaint Assistance Unit of the Division of Consumer Services of the California Department of Consumer Affairs in writing at 1625 N. Market Blvd., Suite S-202, Sacramento, California 95834, or by telephone at +1-800-952-5210 in order to resolve a complaint regarding the Service or to receive further information regarding use of the Service.\n 13.9. No Support. We are under no obligation to provide support for the Service. In instances where we may offer support, the support will be subject to published policies.\n 13.10. International Use. The Service is intended for visitors located within the United States. We make no representation that the Service is appropriate or available for use outside of the United States. Access to the Service from countries or territories or by individuals where such access is illegal is prohibited.\n 13.11. Complaints. Givt handles complaints efficiently and as soon as reasonably possible. Any complaint about the implementation of these Terms by Givt must be submitted in writing at Givt via e-mail to support@givt.app.\n 13.12. Notice Regarding Apple. This Section 13 only applies to the extent you are using our mobile application on an iOS device. You acknowledge that these Terms are between you and Givt only, not with Apple Inc. (\"Apple\"), and Apple is not responsible for the Service or the content of it. Apple has no obligation to furnish any maintenance and support services with respect to the Service. If the Service fails to conform to any applicable warranty, you may notify Apple, and Apple will refund any applicable purchase price for the mobile application to you. To the maximum extent permitted by applicable law, Apple has no other warranty obligation with respect to the Service. Apple is not responsible for addressing any claims by you or any third party relating to the Service or your possession and/or use of the Service, including: (1) product liability claims; (2) any claim that the Service fails to conform to any applicable legal or regulatory requirement; or (3) claims arising under consumer protection or similar legislation. Apple is not responsible for the investigation, defense, settlement, and discharge of any third-party claim that the Service and/or your possession and use of the Service infringe a third party\'s intellectual property rights. You agree to comply with any applicable third-party terms when using the Service. Apple and Apple\'s subsidiaries are third-party beneficiaries of these Terms, and upon your acceptance of these Terms, Apple will have the right (and will be deemed to have accepted the right) to enforce these Terms against you as a third-party beneficiary of these Terms. You hereby represent and warrant that: (a) you are not located in a country that is subject to a U.S. Government embargo or that has been designated by the U.S. Government as a \"terrorist supporting\" country; and (b) you are not listed on any U.S. Government list of prohibited or restricted parties.\n\n';

  @override
  String get informationAboutUsUs =>
      'Givt is a product of Givt Inc\n \n\n We are located at 12 N Cheyenne Ave, #305, Tulsa, OK, 74103. For questions or complaints you can reach us via +1 918-615-9611 or support@givt.app\n \n\n We are incorporated in Delaware.';

  @override
  String get faQantwoord0Us =>
      'In the app-menu under \"About Givt / Contact\" there\'s a text field where you can type a message and send it to us. Of course you can also contact us by calling +1 918-615-9611 or by sending an e-mail to support@givt.app.';

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
  String get cantCancelAlreadyProcessed =>
      'Alas, you can\'t cancel this donation because it is already processed.';

  @override
  String get countryStringUs => 'United States of America';

  @override
  String get enterPaymentDetails => 'Enter Payment Details';

  @override
  String get directNoticeText =>
      'Givt Direct Notice to Parents  \nIn order to allow your child to use Givt, an application through which younger users can direct donations, linked to and controlled by your Givt account, we have collected your online contact information, as well as your and your child’s name, for the purpose of obtaining your consent to collect, use, and disclose personal information from your child. \nParental consent is required for Givt to collect, use, or disclose your child\'s personal information. Givt will not collect, use, or disclose personal information from your child if you do not provide consent. As a parent, you provide your consent by completing a nominal payment card charge in your account on the Givt app. If you do not provide consent within a reasonable time, Givt will delete your information from its records, however Givt will retain any information it has collected from you as a standard Givt user, subject to Givt’s standard privacy policy www.givt.app/privacy-policy/ \nThe Givt Privacy Policy for Children Under the Age of 13 www.givt.app/privacy-policy-givt4kids/ provides details regarding how and what personal information we collect, use, and disclose from children under 13 using Givt (the “Application”). \nInformation We Collect from Children\nWe only collect as much information about a child as is reasonably necessary for the child to participate in an activity, and we do not condition his or her participation on the disclosure of more personal information than is reasonably necessary.  \nInformation We Collect Directly \nWe may request information from your child, but this information is optional. We specify whether information is required or optional when we request it. For example, if a child chooses to provide it, we collect information about the child’s choices and preferences, the child’s donation choices, and any good deeds that the child records. \nAutomatic Information Collection and Tracking\nWe use technology to automatically collect information from our users, including children, when they access and navigate through the Application and use certain of its features. The information we collect through these technologies may include: \nOne or more persistent identifiers that can be used to recognize a user over time and across different websites and online services, such as IP address and unique identifiers (e.g. MAC address and UUID); and,\nInformation that identifies a device\'s location (geolocation information).\nWe also may combine non-personal information we collect through these technologies with personal information about you or your child that we collect online.  \nHow We Use Your Child\'s Information\nWe use the personal information we collect from your child to: \nfacilitate donations that your child chooses;\ncommunicate with him or her about activities or features of the Application,;\ncustomize the content presented to a child using the Application;\nRecommend donation opportunities that may be of interest to your child; and,\ntrack his or her use of the Application. \nWe use the information we collect automatically through technology (see Automatic Information Collection and Tracking) and other non-personal information we collect to improve our Application and to deliver a better and more personalized experience by enabling us to:\nEstimate our audience size and usage patterns.\nStore information about the child\'s preferences, allowing us to customize the content according to individual interests.\nWe use geolocation information we collect to determine whether the user is in a location where it’s possible to use the Application for donating. \nOur Practices for Disclosing Children\'s Information\nWe may disclose aggregated information about many of our users, and information that does not identify any individual or device. In addition, we may disclose children\'s personal information:\nTo third parties we use to support the internal operations of our Application.\nIf we are required to do so by law or legal process, such as to comply with any court order or subpoena or to respond to any government or regulatory request.\nIf we believe disclosure is necessary or appropriate to protect the rights, property, or safety of Givt, our customers or others, including to:\nprotect the safety of a child;\nprotect the safety and security of the Application; or\nenable us to take precautions against liability.\nTo law enforcement agencies or for an investigation related to public safety. \nIf Givt is involved in a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of Givt\'s assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding or event, we may transfer the personal information we have collected or maintain to the buyer or other successor. \nSocial Features \nThe Application allows parents to view information about their child’s donation activities and any good deeds that the child records, and parents may provide certain responses to this information. \nAccessing and Correcting Your Child\'s Personal Information\nAt any time, you may review the child\'s personal information maintained by us, require us to correct or delete the personal information, and/or refuse to permit us from further collecting or using the child\'s information.  \nYou can review, change, or delete your child\'s personal information by:\nLogging into your account and accessing the profile page relating to your child.\nSending us an email at support@givt.app. To protect your and your child’s privacy and security, we may require you to take certain steps or provide additional information to verify your identity before we provide any information or make corrections. \nOperators That Collect or Maintain Information from Children\nGivt Inc. is the operator that collects and maintains personal information from children through the Application.Givt can be contacted at support@givt.app, by mail at 12 N Cheyenne Ave, #305, Tulsa, OK, 74103. , or by phone at +1 918-615-9611.';

  @override
  String get mobileNumberUsDigits => '1231231234';

  @override
  String get createChildNameErrorTextFirstPart1 => 'Name must be at least ';

  @override
  String get createChildNameErrorTextFirstPart2 => ' characters.';

  @override
  String get createChildAllowanceErrorText =>
      'Giving allowance must be greater than zero.';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get childInWalletPostfix => ' in Wallet';

  @override
  String get childEditProfileErrorText =>
      'Cannot update child profile. Please try again later.';

  @override
  String get childEditProfile => 'Edit Profile';

  @override
  String get childHistoryBy => 'by';

  @override
  String get childHistoryTo => 'to';

  @override
  String get childHistoryToBeApproved => 'To be approved';

  @override
  String get childHistoryCanContinueMakingADifference =>
      'can continue making a difference';

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
  String childParentalApprovalConfirmationSubTitle(
    Object value0,
    Object value1,
  ) {
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
  String get surname => 'Surname';

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
  String get emptyChildrenDonations =>
      'Your children\'s donations\nwill appear here';

  @override
  String get almostDone => 'Almost done...';

  @override
  String get weHadTroubleGettingAllowance =>
      'We had trouble getting money from your account for the giving allowance(s).';

  @override
  String get noWorriesWeWillTryAgain =>
      'No worries, we will try again tomorrow!';

  @override
  String get allowanceOopsCouldntGetAllowances =>
      'Oops! We couldn\'t get the allowance amount from your account.';

  @override
  String get weWillTryAgainTmr => 'We will try again tomorrow';

  @override
  String get weWillTryAgainNxtMonth => 'We will try again next month';

  @override
  String get editChildWeWIllTryAgain => 'We will try again on: ';

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
  String get familyGoalStartMakingHabit =>
      'Start making giving a habit in your family';

  @override
  String get familyGoalCreate => 'Create';

  @override
  String get familyGoalConfirmedTitle => 'Family Goal launched!';

  @override
  String get familyGoalToSupport => 'to support';

  @override
  String get familyGoalShareWithFamily =>
      'Share this with your family and make a difference together';

  @override
  String get familyGoalLaunch => 'Launch';

  @override
  String get familyGoalHowMuch => 'How much do you want to raise?';

  @override
  String get familyGoalAmountHint =>
      'Most families start out with an amount of \$100';

  @override
  String get certExceptionTitle => 'A little hiccup';

  @override
  String get certExceptionBody =>
      'We couldn\'t connect to the server. But no worries, try again later and we\'ll get things sorted out!';

  @override
  String get familyGoalPrefix => 'Family Goal: ';

  @override
  String permitBiometricQuestionWithType(Object value0) {
    return 'Do you want to use $value0?';
  }

  @override
  String get permitBiometricExplanation =>
      'Speed up the login process and keep you account secure';

  @override
  String get permitBiometricSkip => 'Skip for now';

  @override
  String permitBiometricActivateWithType(Object value0) {
    return 'Activate $value0';
  }

  @override
  String get youHaveBeenInvitedToImpactGroup =>
      'You have been invited\nto the ';

  @override
  String get acceptInviteKey => 'Accept the invite';

  @override
  String get chooseGroup => 'Choose Group';

  @override
  String get groups => 'Groups';

  @override
  String get genericSuccessTitle => 'Consider it done!';

  @override
  String get topUpScreenInfo =>
      'How much would you like to add to\nyour child\'s Wallet?';

  @override
  String topUpSuccessText(Object value0) {
    return '$value0 has been added to\nyour child’s Wallet';
  }

  @override
  String get goToSettings => 'Go to Settings';

  @override
  String get goToSettingsBody =>
      'To scan the QR Code we need to turn on the camera. Go to Settings to allow that.';

  @override
  String get selectCountryHint => 'Select country';

  @override
  String get homescreenLetsGo => 'Let\'s go!';

  @override
  String get homescreenJourneyOfGenerosity =>
      'Start your journey of generosity!';

  @override
  String get registrationRandomAvatarError => 'Failed to load avatar.';

  @override
  String get registrationAvatarSelectionTitle => 'Select your avatar';

  @override
  String get registrationParentFirstName => 'Parent first name';

  @override
  String get registrationParentLastName => 'Parent last name';

  @override
  String get homepageParentEmailHint => 'Parent email address';

  @override
  String get addMemberAdultDescription =>
      'This adult will receive an email adding them to the family, enabling them to also:';

  @override
  String get addMemberAdultReason1 => 'Login to Givt with their own account';

  @override
  String get addMemberAdultReason2 => 'Approve donations of the children';

  @override
  String get addMemberAdultReason3 => 'Explore generosity as a family';

  @override
  String get addMemberAdultEmailSameAsLoggedIn =>
      'You\'ve already created an account for yourself with this email address';

  @override
  String get unregisterTitle => 'Terminate account';

  @override
  String get unregisterPrimaryBtnText => 'Terminate account';

  @override
  String get unregisterDescription =>
      'We’re sorry to see you go!\nAfter terminating your account, we cannot recover it for you.';

  @override
  String get unregisterCheckboxText => 'Yes, I want to terminate my account';

  @override
  String get unregisterLoading => 'Terminating account';

  @override
  String get unregisterSuccessText =>
      'We’re sad to see you leave and we hope to see you again.';

  @override
  String get homeScreenWelcome => 'Welcome!';

  @override
  String homeScreenHeyFamily(Object family) {
    return 'Hey $family!';
  }

  @override
  String get tutorialGratitudeGameTitle => 'Gratitude Game';

  @override
  String get tutorialGratitudeGameDescription =>
      'This game helps you to build gratitude by reflecting on your day as a family';

  @override
  String homeScreenSecondParentDialogTitle(Object firstName) {
    return '$firstName needs to use their own account';
  }

  @override
  String get homeScreenSecondParentDialogDescription =>
      'Use the Givt App on your own device';

  @override
  String get homeScreenSecondParentDialogConfirmButton => 'Got it';

  @override
  String get tutorialFirstMissionTitle => 'Let\'s complete your first mission!';

  @override
  String get tutorialFirstMissionDescription =>
      'New missions help your family grow together. Tap above to begin!';

  @override
  String get homeScreenGratitudeGameButtonTitle => 'Family Game';

  @override
  String get homeScreenGratitudeGameButtonSubtitle => 'Play now!';

  @override
  String get setupFamilyTitle => 'Set up Family';

  @override
  String get setupFamilyHowManyTitle => 'How many people are in your family?';

  @override
  String get childKey => 'Child';

  @override
  String get adultKey => 'Adult';

  @override
  String get setupFamilyAddNextMember => 'Add next member';

  @override
  String get homescreenFamilyWelcome => 'Welcome, super family!';

  @override
  String get homescreenFamilyGenerosity => 'Let\'s foster generosity together';

  @override
  String get buttonSkip => 'Skip';

  @override
  String get leagueUnlockLeague => 'Unlock League';

  @override
  String get leagueUnlocked => 'League Unlocked!';

  @override
  String get leagueWelcome => 'Welcome to the League!';

  @override
  String get leagueExplanation =>
      'Your XP sets your rank. Grow in generosity and climb to the top!';

  @override
  String get buttonDone => 'Done';

  @override
  String get originQuestionTitle => 'Last step';

  @override
  String get originQuestionSubtitle => 'Where did you get your box?';

  @override
  String get originSelectLocation => 'Select location';

  @override
  String get homeScreenGiveButtonTitle => 'Give';

  @override
  String get homeScreenGivtButtonDescription => 'Donate to a cause';

  @override
  String gratitudeWeeklyGoal(Object amount) {
    return 'Play ${amount}x Weekly';
  }

  @override
  String gratitudeGoalDaysLeft(Object amount) {
    return '$amount days left';
  }

  @override
  String get familyNavigationBarHome => 'Home';

  @override
  String get familyNavigationBarFamily => 'Family';

  @override
  String get familyNavigationBarMemories => 'Memories';

  @override
  String get familyNavigationBarLeague => 'League';

  @override
  String get missionsTitle => 'Missions available';

  @override
  String get missionsNoMissions => 'You don\'t have any missions currently';

  @override
  String get missionsNoCompletedMissions =>
      'You haven\'t completed any missions yet';

  @override
  String get tutorialMissionTitle => 'Tap to begin mission!';

  @override
  String get tutorialMissionDescription =>
      'Track your progress and complete your missions here.';

  @override
  String get missionsCardNoMissionsTitle => 'No missions available';

  @override
  String get missionsCardNoMissionsDescription => 'Your work here is done';

  @override
  String get missionsCardTitle => '';

  @override
  String get missionsCardTitleSingular => 'Mission available';

  @override
  String get missionsCardTitlePlural => 'Missions available';

  @override
  String get missionsCardDescriptionSingular =>
      '1 mission available to be completed';

  @override
  String missionsCardDescriptionPlural(Object amount) {
    return '$amount missions available to be completed';
  }

  @override
  String get progressbarPlayed => 'played';

  @override
  String get gameStatsActivityThisWeek => 'Game activity this week';

  @override
  String get gameStatsPlayGame => 'Play the Gratitude Game';

  @override
  String gameStatsAmountOfDeeds(Object amount) {
    return '$amount deeds';
  }

  @override
  String get homescreenOverlayDiscoverTitle => 'Discover your reward!';

  @override
  String get homescreenOverlayGiveTitle => 'Who would like to give?';

  @override
  String get tutorialFamilyExplanationTitle => 'Here’s your super family!';

  @override
  String get tutorialFamilyExplanationDescription =>
      'Work together to find causes to support and spread kindness.';

  @override
  String get tutorialManagingFamilyTitle => 'Managing your family';

  @override
  String get tutorialManagingFamilyDescription =>
      'Encourage your heroes by topping up wallets and approving donations.';

  @override
  String get tutorialTheEndTitle => 'Amazing work, superhero!';

  @override
  String get tutorialTheEndDescription =>
      'I’ll let you take it from here. Head to your next mission and keep making a difference!';

  @override
  String get completedKey => 'Completed';

  @override
  String get tutorialIntroductionTitle => 'Hey, I’m Captain Generosity';

  @override
  String get tutorialIntroductionDescription =>
      'I’m here to help your family build gratitude and foster generosity. Let’s get started!\'';

  @override
  String get refundTitle => 'Refund donation?';

  @override
  String get refundMessageBACS =>
      'Por favor, contáctanos para que podamos reembolsar tu donación.';

  @override
  String get refundMessageGeneral =>
      'Accede a tu banca en línea para revertir tu donación.';

  @override
  String get requestRefund => 'Refund';

  @override
  String get changeName => 'Edit name';

  @override
  String get onlineGivingLabel => 'Online giving';

  @override
  String get accountDisabled =>
      'Your account has been blocked. Please contact us at support@givtapp.net';

  @override
  String get recurringDonationsFrequenciesWeekly => 'Weekly';

  @override
  String get recurringDonationsFrequenciesMonthly => 'Monthly';

  @override
  String get recurringDonationsFrequenciesQuarterly => 'Quarterly';

  @override
  String get recurringDonationsFrequenciesHalfYearly => 'Half Yearly';

  @override
  String get recurringDonationsFrequenciesYearly => 'Yearly';

  @override
  String get closeModalAreYouSure => 'Are you sure you want to exit?';

  @override
  String get closeModalWontBeSaved =>
      'If you exit now, your current changes won\'t be saved.';

  @override
  String get closeModalYesExit => 'Yes, exit';

  @override
  String get closeModalNoBack => 'No, go back';

  @override
  String get recurringDonationsStep2Description =>
      'How often do you want to give, and how much?';

  @override
  String get recurringDonationsFrequencyTitle => 'Donation frequency';

  @override
  String get recurringDonationsAmountTitle => 'Donation amount';

  @override
  String get donationSubtotal => 'Subtotal';

  @override
  String get donationTotal => 'Total';

  @override
  String get platformFeeTitle => 'Help us lower the costs for organisations';

  @override
  String get platformFeeText =>
      'Givt aims for 0% service fee. With a small donation to Givt, you help achieve that.';

  @override
  String get platformFeeNoContribution => 'Not this time';

  @override
  String get donationOverviewPlatformContribution =>
      'Contribución de plataforma';

  @override
  String get donationOverviewPlatformContributionTitle =>
      '¡Gracias por tu contribución!';

  @override
  String get donationOverviewPlatformContributionText =>
      'Gracias a esta contribución, no hay costes de plataforma para el receptor.';

  @override
  String get platformFeePlaceholder => 'Select amount';

  @override
  String get platformFeeRequired => 'Required field';

  @override
  String get recurringDonationsStep1Title => 'Select organisation';

  @override
  String get recurringDonationsStep1Description =>
      'Who do you want to give to?';

  @override
  String get recurringDonationsStep1ListTitle => 'Select from list';

  @override
  String get recurringDonationsStep1ListSubtitle =>
      'Select a cause from the list';

  @override
  String get recurringDonationsStep2Title => 'Set amount';

  @override
  String get recurringDonationsStep3Title => 'Set duration';

  @override
  String get recurringDonationsStep3Description =>
      'How long would you like to schedule this donation for?';

  @override
  String get recurringDonationsStartingTitle => 'Starting on';

  @override
  String get recurringDonationsEndsTitle => 'Ends';

  @override
  String get recurringDonationsEndsWhenIDecide => 'When I decide';

  @override
  String get recurringDonationsEndsAfterNumber => 'After a number of donations';

  @override
  String get recurringDonationsEndsAfterDate => 'On a specific date';

  @override
  String recurringDonationsEndDateHintEveryMonth(Object dag, Object day) {
    return 'Your donation will occur on the $day of every month';
  }

  @override
  String recurringDonationsEndDateHintEveryWeek(Object day) {
    return 'Your donation will occur every week on the $day';
  }

  @override
  String recurringDonationsEndDateHintEveryXMonth(Object day, Object freq) {
    return 'Your donation will occur every $freq months on the $day';
  }

  @override
  String recurringDonationsEndDateHintEveryYear(Object day, Object month) {
    return 'Your donation will occur once a year on the $day of $month';
  }

  @override
  String recurringDonationsEndsAfterXDonations(Object amount) {
    return 'After $amount of donations';
  }

  @override
  String get recurringDonationsStep4Title => 'Confirm';

  @override
  String get recurringDonationsStep4Description =>
      'Ready to make a difference?';

  @override
  String get recurringDonationsStep4YoullDonateTo => 'You\'ll donate to';

  @override
  String get recurringDonationsStep4Amount => 'Amount';

  @override
  String get recurringDonationsStep4Frequency => 'Frequency';

  @override
  String get recurringDonationsStep4Starts => 'Starts';

  @override
  String get recurringDonationsStep4Ends => 'Ends';

  @override
  String get recurringDonationsStep4ConfirmMyDonation => 'Confirm my donation';

  @override
  String get recurringDonationsEmptyStateTitle => 'Easy giving, full control';

  @override
  String get recurringDonationsEmptyStateDescription =>
      'Set up a recurring donation you can adjust or cancel anytime.';

  @override
  String get recurringDonationsOverviewTabCurrent => 'Current';

  @override
  String get recurringDonationsOverviewTabPast => 'Past';

  @override
  String get recurringDonationsOverviewAddButton => 'Add recurring donation';

  @override
  String get recurringDonationsDetailProgressSuffix => 'donations';

  @override
  String get recurringDonationsDetailSummaryDonated => 'Donated';

  @override
  String get recurringDonationsDetailSummaryHelping => 'Helping';

  @override
  String get recurringDonationsDetailSummaryHelped => 'Helped';

  @override
  String recurringDonationsDetailEndsTag(Object date) {
    return 'Ends $date';
  }

  @override
  String get recurringDonationsDetailHistoryTitle => 'History';

  @override
  String get recurringDonationsDetailStatusUpcoming => 'Upcoming';

  @override
  String get recurringDonationsDetailStatusCompleted => 'Completed';

  @override
  String get recurringDonationsDetailStatusPending => 'Pending';

  @override
  String recurringDonationsDetailTimeDisplayDays(Object days) {
    return '$days days';
  }

  @override
  String get recurringDonationsDetailManageButton => 'Manage donation';

  @override
  String get recurringDonationsDetailEditDonation => 'Edit donation';

  @override
  String get recurringDonationsDetailEditComingSoon =>
      'Edit functionality coming soon';

  @override
  String get recurringDonationsDetailPauseDonation => 'Pause donation';

  @override
  String get recurringDonationsDetailPauseComingSoon =>
      'Pause functionality coming soon';

  @override
  String get recurringDonationsDetailCancelDonation => 'Cancel donation';

  @override
  String get recurringDonationsCreateStep2AmountHint => 'Enter amount';

  @override
  String get recurringDonationsCreateFrequencyHint => 'Select one';

  @override
  String get recurringDonationsCreateDurationNumberHint => 'Enter the number';

  @override
  String recurringDonationsCreateDurationSnackbarTimes(
    Object date,
    Object number,
  ) {
    return 'You\'ll donate $number times, ending on $date';
  }

  @override
  String recurringDonationsCreateDurationSnackbarOnce(Object date) {
    return 'You\'ll donate 1 time, ending on $date';
  }

  @override
  String recurringDonationsCreateDurationSnackbarMultiple(
    Object count,
    Object date,
  ) {
    return 'You\'ll donate $count times, ending on $date';
  }

  @override
  String get recurringDonationsSuccessTitle => 'Thanks for your support';

  @override
  String recurringDonationsSuccessSubtitleNextXMonths(
    Object months,
    Object organization,
  ) {
    return 'For the next $months months, you\'ll be helping $organization make an impact';
  }

  @override
  String recurringDonationsSuccessSubtitleUntilDecide(Object organization) {
    return 'You\'ll be helping $organization make an impact until you decide to stop.';
  }

  @override
  String recurringDonationsSuccessSubtitleUntilDate(
    Object date,
    Object organization,
  ) {
    return 'Until $date, you\'ll be helping $organization make an impact';
  }

  @override
  String recurringDonationsSuccessSubtitleDefault(Object organization) {
    return 'You\'ll be helping $organization make an impact';
  }

  @override
  String get recurringDonationsListStatusEnded => 'Ended';

  @override
  String get recurringDonationsListStatusNextUp => 'Next up';

  @override
  String get recurringDonationsListFrequencyWeekly => 'Weekly';

  @override
  String get recurringDonationsListFrequencyMonthly => 'Monthly';

  @override
  String get recurringDonationsListFrequencyQuarterly => 'Quarterly';

  @override
  String get recurringDonationsListFrequencySemiAnnually => 'Semi-annually';

  @override
  String get recurringDonationsListFrequencyAnnually => 'Annually';

  @override
  String get recurringDonationsListFrequencyRecurring => 'Recurring';

  @override
  String get platformFeeCommonOption => 'Most popular';

  @override
  String get platformFeeGenerousOption => 'Extra generous';

  @override
  String get recurringDonationsCreationErrorTitle =>
      'We couldn\'t set up your donation';

  @override
  String get recurringDonationsCreationErrorDescription =>
      'Something went wrong.\\nPlease check your details and try again.';

  @override
  String get recurringDonationsCreationErrorChangeAndRetry =>
      'Change and Retry';

  @override
  String get recurringDonationsCancelled => 'Cancelled';

  @override
  String get donationOverviewDateAt => 'at';

  @override
  String get donationOverviewStatusProcessed => 'Processed';

  @override
  String get donationOverviewStatusCancelled => 'Cancelled';

  @override
  String get donationOverviewStatusInProcess => 'In Process';

  @override
  String get donationOverviewStatusRefused => 'Refused';

  @override
  String get donationOverviewStatusProcessedFull => 'Processed';

  @override
  String get donationOverviewStatusCancelledFull => 'Cancelled by user';

  @override
  String get donationOverviewStatusInProcessFull => 'In Process';

  @override
  String get donationOverviewStatusRefusedFull => 'Refused by bank';

  @override
  String donationOverviewContactMessage(Object status, Object transactionId) {
    return 'Hi, I need help with the following donation:\\n\\nStatus: $status\\nTransaction ID:#$transactionId';
  }

  @override
  String get date => 'Date';

  @override
  String get platformFeeGoodOption => 'Good choice';

  @override
  String get platformFeeRemember =>
      'Remember my choice for future donations to this organisation.';

  @override
  String get platformFeeCustomOption => 'Custom amount';

  @override
  String get platformFeeCustomPlaceholder => 'Enter custom amount';

  @override
  String get platformContributionTitle => 'Platform Contribution';

  @override
  String get platformContributionHelpLowerCosts =>
      'Help us lower costs for the organizations';

  @override
  String get platformContributionAims =>
      'Give aims for 0% service fee with your help. They\'ll show here once you set them.';

  @override
  String get platformContributionManage =>
      'Manage your platform contribution for each organization';

  @override
  String get platformContributionOrgPresbyterian => 'Presbyterian Church';

  @override
  String get platformContributionExtraGenerous => 'Extra generous';

  @override
  String get platformContributionOrgRedCross => 'Red Cross';

  @override
  String get platformContributionMostPopular => 'Most popular';

  @override
  String get platformContributionOrgTheParkChurch => 'The Park Church';

  @override
  String get platformContributionSaveChangesButton => 'Save changes';

  @override
  String get platformContributionSaveChangesModalTitle => 'Save changes?';

  @override
  String get platformContributionSaveChangesModalBody =>
      'Do you want to save your changes before leaving?';

  @override
  String get platformContributionSaveChangesModalYesButton => 'Yes, save';

  @override
  String get platformContributionSaveChangesModalNoButton => 'No, discard';
}

/// The translations for Spanish Castilian, as used in Latin America and the Caribbean (`es_419`).
class AppLocalizationsEs419 extends AppLocalizationsEs {
  AppLocalizationsEs419() : super('es_419');

  @override
  String get ibanPlaceHolder => 'Número de cuenta IBAN';

  @override
  String get amountLimitExceeded =>
      'Esta cantidad es mayor que su importe máximo elegido. Ajuste el importe máximo de donación o elija una cantidad inferior.';

  @override
  String get slimPayInformation =>
      'Queremos que su experiencia con Givt sea lo más agradable posible.';

  @override
  String get buttonContinue => 'Continuar';

  @override
  String get slimPayInfoDetail =>
      'Givt trabaja junto con Better World Payments para ejecutar las transacciones. Better World Payments se especializa en la gestión de mandatos y transferencias automáticas de dinero en plataformas digitales. Better World Payments ejecuta estas solicitudes para Givt a las tarifas más bajas del mercado y a gran velocidad.\n \n\nBetter World Payments es un socio ideal para Givt porque facilita mucho la donación sin efectivo de forma segura. \n \n\n El dinero se recogerá en una cuenta de Better World Payments. \n Givt se asegurará de que el dinero se distribuya correctamente.';

  @override
  String get slimPayInfoDetailTitle => '¿Qué es Better World Payments?';

  @override
  String get unregisterButton => 'Eliminar mi cuenta';

  @override
  String get unregisterUnderstood => 'Entendido';

  @override
  String givtIsBeingProcessed(Object value0) {
    return '¡Gracias por dar con Givt a $value0!\nPuede comprobar el estado en el resumen.';
  }

  @override
  String offlineGegevenGivtMessageWithOrg(Object value0) {
    return '¡Gracias por dar con Givt a $value0!\n \n\n Cuando haya una buena conexión con el servidor de Givt, tu donación se procesará.\n Puedes comprobar el estado en el resumen.';
  }

  @override
  String get wrongPasswordLockedOut =>
      'Tercer intento fallido, inténtalo de nuevo en 15 minutos.';

  @override
  String giftOverviewGiftAidBanner(Object value0) {
    return 'Donativo con Ayuda Fiscal $value0';
  }

  @override
  String get faqWhyBluetoothEnabledQ =>
      '¿Por qué tengo que activar el Bluetooth para usar Givt?';

  @override
  String get faqWhyBluetoothEnabledA =>
      'Tu teléfono recibe una señal de la baliza dentro de la caja, bolsa o cesta de recolección. Esta señal utiliza el protocolo Bluetooth. Puede considerarse como un tráfico unidireccional, lo que significa que no hay conexión, a diferencia de un kit Bluetooth para auto o unos auriculares. Es una forma segura y fácil de que tu teléfono sepa qué caja, bolsa o cesta de recolección está cerca. Cuando la baliza está cerca, el teléfono capta la señal y tu Givt se completa.';

  @override
  String get collect => 'Recolección';

  @override
  String get areYouSureToCancelGivts =>
      '¿Estás seguro? Presiona Aceptar para confirmar.';

  @override
  String get feedbackTitle => '¿Comentarios o preguntas?';

  @override
  String get feedbackMailSent =>
      'Hemos recibido tu mensaje correctamente, nos pondremos en contacto contigo lo antes posible.';

  @override
  String get typeMessage => '¡Escribe tu mensaje aquí!';

  @override
  String get safariGivtTransaction =>
      'Este Givt se convertirá en una transacción.';

  @override
  String get appVersion => 'Versión de la aplicación:';

  @override
  String get askMeLater => 'Pregúntame más tarde';

  @override
  String get giveDifferently => 'Elije de la lista';

  @override
  String get codeCanNotBeScanned =>
      'Lamentablemente, este código no se puede utilizar para donar dentro de la aplicación Givt.';

  @override
  String get giveDifferentScan => 'Escanear código QR';

  @override
  String get giveDiffQrText => '¡Ahora, apunta bien!';

  @override
  String get locationEnabledMessage =>
      'Por favor, activa tu ubicación con alta precisión para donar con Givt. (Después de tu donación puedes desactivarla de nuevo).';

  @override
  String get changeGivingLimit => 'Ajustar cantidad máxima';

  @override
  String get chooseLowerAmount => 'Cambiar la cantidad';

  @override
  String get turnOnBluetooth => 'Activar Bluetooth';

  @override
  String get errorTldCheck =>
      'Lo sentimos, no puedes registrarte con este correo electrónico. ¿Podrías comprobar si hay errores tipográficos?';

  @override
  String get faQantwoord0 =>
      'En el menú de la aplicación, en \"Acerca de Givt / Contacto\", hay un campo de texto donde puedes escribir un mensaje y enviárnoslo. Por supuesto, también puedes ponerte en contacto con nosotros llamando al +44 2037 908068 o enviando un correo electrónico a support@givt.co.uk';

  @override
  String get personalPageHeader => 'Cambia los datos de tu cuenta aquí.';

  @override
  String get personalPageSubHeader =>
      '¿Deseas cambiar tu nombre? Envía un correo electrónico a support@givtapp.net .';

  @override
  String get updatePersonalInfoError =>
      '¡Lo sentimos! No podemos actualizar tu información personal en este momento. ¿Podrías intentarlo de nuevo más tarde?';

  @override
  String get loadingTitle => 'Por favor, espera...';

  @override
  String get finalizeRegistrationPopupText =>
      'Importante: Las donaciones sólo pueden procesarse una vez hayas finalizado tu registro.';

  @override
  String get finalizeRegistration => 'Finalizar registro';

  @override
  String get importantReminder => 'Recordatorio importante';

  @override
  String get shareTheGivtButton => 'Compartir con mis amigos';

  @override
  String shareTheGivtText(Object value0) {
    return '¡Acabo de usar Givt para donar a $value0!';
  }

  @override
  String get joinGivt => 'Únete en givtapp.net/download.';

  @override
  String get yesSuccess => '¡Sí, completado!';

  @override
  String get personalInfo => 'Información personal';

  @override
  String get searchHere => 'Buscar ...';

  @override
  String get noInternet =>
      '¡Ups! Parece que no estás conectado a Internet. Inténtalo de nuevo cuando estés conectado a Internet.';

  @override
  String get noInternetConnectionTitle => 'Sin conexión a Internet';

  @override
  String get answerWhyAreMyDataStored =>
      'Trabajamos muy duro todos los días para mejorar Givt. Para ello utilizamos los datos que tenemos a nuestra disposición.\n Necesitamos algunos de tus datos para crear tu mandato. Otra información se utiliza para crear tu cuenta personal.\n También utilizamos tus datos para responder a tus preguntas de servicio.\n En ningún caso cedemos tus datos personales a terceros.';

  @override
  String get cantCancelGiftAfter15Minutes =>
      'Lamentablemente, no puedes cancelar esta donación dentro de la aplicación Givt.';

  @override
  String get faqVraag16 => '¿Puedo cancelar las donaciones?';

  @override
  String get faqAntwoord16 =>
      'Puedes cancelar tu donación a través del resumen de donaciones pulsando el botón de cancelar debajo de la donación específica. Si ya no puedes eliminar la donación, significa que ya ha sido procesada. Atención: Esto solo es posible si has completado tu registro en la aplicación Givt.\n\nTambién puedes revocar tus donaciones en un momento posterior. Al dar con Givt, no se realizan transferencias inmediatas; estas se llevan a cabo posteriormente mediante una domiciliación bancaria. Todas las domiciliaciones pueden ser revocadas posteriormente a través de tu banco.';

  @override
  String get selectContextCollect =>
      'Dona en la iglesia, en la puerta o en la calle';

  @override
  String get giveContextQr => 'Dona escaneando un código QR';

  @override
  String get selectContextList => 'Selecciona una causa de la lista';

  @override
  String get selectContext => 'Elige la forma en que quieres donar';

  @override
  String get chooseWhoYouWantToGiveTo => 'Elige a quién quieres donar';

  @override
  String get cancelGiftAlertTitle => '¿Cancelar donación?';

  @override
  String get cancelGiftAlertMessage =>
      '¿Estás seguro de que deseas cancelar esta donación?';

  @override
  String get cancelFeatureTitle =>
      'Puedes cancelar una donación deslizando hacia la izquierda';

  @override
  String get cancelFeatureMessage =>
      'Toca en cualquier lugar para descartar este mensaje';

  @override
  String get giveSubtitle =>
      'Hay varias maneras de \'Givt\'. Elija la que mejor se adapte a usted.';

  @override
  String get confirm => 'Confirmar';

  @override
  String get giveWithYourPhone => 'Mueve tu teléfono';

  @override
  String get errorContactGivt =>
      'Se ha producido un error, póngase en contacto con nosotros en support@givtapp.net .';

  @override
  String get mandateFailPersonalInformation =>
      'Parece que hay algo mal con la información que ingresó. ¿Podría verificar en el menú, en \'Información personal\'? También puede cambiar la información allí, si es necesario.';

  @override
  String givtEventText(Object value0) {
    return '¡Hola! Estás en un lugar donde Givt es compatible. ¿Quieres donar a $value0?';
  }

  @override
  String get searchingEventText =>
      'Estamos buscando dónde estás, ¿quieres esperar un poco?';

  @override
  String get selectLocationContext => 'Donar en la ubicación';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get allowGivtLocationTitle =>
      'Permitir que Givt acceda a su ubicación';

  @override
  String get allowGivtLocationMessage =>
      'Necesitamos su ubicación para determinar a quién desea donar.\n Vaya a Ajustes > Privacidad > Servicios de localización > Active los servicios de localización y establezca Givt en \'Mientras se usa la aplicación\'.';

  @override
  String get faqVraag10 => '¿Cómo cambio mi contraseña?';

  @override
  String get faqAntwoord10 =>
      'Si desea cambiar su contraseña, puede elegir \'Información personal\' en el menú y, a continuación, pulsar el botón \'Cambiar contraseña\'. Le enviaremos un correo electrónico con un enlace a una página web donde podrá cambiar su contraseña.';

  @override
  String get changeEmail => 'Cambiar correo electrónico';

  @override
  String get changeIban => 'Cambiar IBAN';

  @override
  String get kerkdienstGemistQuestion =>
      '¿Cómo puedo donar con Givt a través de terceros?';

  @override
  String get kerkdienstGemistAnswer =>
      'Kerkdienst Gemist\n Si está viendo con la aplicación Kerkdienst Gemist, puede donar fácilmente con Givt cuando su iglesia utiliza nuestro servicio. En la parte inferior de la página, encontrará un pequeño botón que le llevará a la aplicación Givt. Elija un importe, confirme con \'Sí, por favor\' y ¡listo!';

  @override
  String get changePhone => 'Cambiar número de teléfono';

  @override
  String get artists => 'Artistas';

  @override
  String get changeAddress => 'Cambiar dirección';

  @override
  String get selectLocationContextLong => 'Donar según tu ubicación';

  @override
  String get sortCodePlaceholder => 'Código de clasificación';

  @override
  String get bankAccountNumberPlaceholder => 'Número de cuenta bancaria';

  @override
  String get bacsSetupTitle =>
      'Configurando la instrucción de domiciliación bancaria';

  @override
  String get bacsSetupBody =>
      'Está firmando una domiciliación bancaria incidental, sólo debitaremos de su cuenta cuando utilice la aplicación Givt para hacer una donación.\n \n\n Al continuar, usted acepta que es el titular de la cuenta y es la única persona requerida para autorizar los débitos de esta cuenta.\n \n\n Los detalles de su mandato de instrucción de domiciliación bancaria se le enviarán por correo electrónico en un plazo de 3 días hábiles o, a más tardar, 10 días hábiles antes del primer cobro.';

  @override
  String get bacsUnderstoodNotice => 'He leído y entendido el aviso previo';

  @override
  String get bacsVerifyTitle => 'Verifica tus datos';

  @override
  String get bacsVerifyBody =>
      'Si alguno de los datos anteriores es incorrecto, por favor, anula el registro y cambia tu \'Información personal\'\n \n\n El nombre de la empresa que aparecerá en su extracto bancario contra la domiciliación bancaria será Givt Ltd.';

  @override
  String get bacsReadDdGuarantee =>
      'Leer la garantía de domiciliación bancaria';

  @override
  String get bacsDdGuarantee =>
      '- La garantía es ofrecida por todos los bancos y cajas de ahorros que aceptan instrucciones para pagar las domiciliaciones bancarias.\n - Si hay algún cambio en la forma en que se utiliza esta instrucción incidental de domiciliación bancaria, la organización le notificará (normalmente 10 días hábiles) antes de que se cargue en su cuenta o según lo acordado. \n - Si se produce un error en el pago de su domiciliación bancaria, por parte de la organización, o de su banco o caja de ahorros, tiene derecho a un reembolso completo e inmediato del importe pagado por su banco o caja de ahorros.\n - Si recibe un reembolso al que no tiene derecho, debe devolverlo cuando la organización se lo solicite.\n - Puede cancelar una domiciliación bancaria en cualquier momento poniéndose en contacto con su banco o caja de ahorros. Es posible que se requiera una confirmación por escrito. Por favor, notifique también a la organización.';

  @override
  String get bacsAdvanceNotice =>
      'Está firmando un mandato de instrucción de domiciliación bancaria incidental y no recurrente. Sólo a petición suya se ejecutarán débitos por parte de la organización. Se aplican todas las salvaguardias y garantías normales de la domiciliación bancaria. No se pueden realizar cambios en el uso de esta instrucción de domiciliación bancaria sin notificarle con al menos cinco (5) días hábiles de antelación al cargo en su cuenta.\n En caso de error, tiene derecho a un reembolso inmediato de su banco o caja de ahorros. \n Tiene derecho a cancelar una instrucción de domiciliación bancaria en cualquier momento escribiendo a su banco o caja de ahorros, con una copia a nosotros.';

  @override
  String get bacsAdvanceNoticeTitle => 'Aviso previo';

  @override
  String get bacsDdGuaranteeTitle => 'Garantía de domiciliación bancaria';

  @override
  String bacsVerifyBodyDetails(
    Object value0,
    Object value1,
    Object value2,
    Object value3,
    Object value4,
  ) {
    return 'Nombre: $value0\n Dirección: $value1\n Dirección de correo electrónico: $value2\n Código de clasificación: $value3\n Número de cuenta: $value4\n Tipo de frecuencia: Incidental, cuando utilice la aplicación Givt para hacer una donación';
  }

  @override
  String get bacsHelpTitle => '¿Necesitas ayuda?';

  @override
  String get bacsHelpBody =>
      '¿No puede entender algo o simplemente tiene una pregunta? Llámenos al +44 2037 908068 o envíenos un correo electrónico a support@givt.co.uk y nos pondremos en contacto con usted.';

  @override
  String bacsSortcodeAccountnumber(Object value0, Object value1) {
    return 'Código de clasificación: $value0\n Número de cuenta: $value1';
  }

  @override
  String get givingContextCollectionBag => 'Dispositivo de recolección';

  @override
  String get givingContextQrCode => 'Código QR';

  @override
  String get givingContextLocation => 'Ubicación';

  @override
  String get givingContextCollectionBagList => 'Lista';

  @override
  String get amountPresetsTitle => 'Importes predefinidos';

  @override
  String get amountPresetsBody =>
      'Establezca sus importes predefinidos a continuación.';

  @override
  String get amountPresetsErrGivingLimit =>
      'El monto es mayor que tu monto máximo';

  @override
  String amountPresetsErr25C(Object value0) {
    return 'El monto debe ser al menos $value0';
  }

  @override
  String get amountPresetsErrEmpty => 'Ingresa un monto';

  @override
  String alertSepaMessage(Object value0) {
    return 'Dado que indicó $value0 como opción de país, asumimos que prefiere donar a través de BACS Direct Debit (£), necesitamos su código de clasificación y número de cuenta para eso. Si prefiere utilizar SEPA (€), necesitamos su IBAN.';
  }

  @override
  String get important => 'Importante';

  @override
  String get fingerprintTitle => 'Huella dactilar';

  @override
  String get touchId => 'Touch ID';

  @override
  String get faceId => 'Face ID';

  @override
  String get touchIdUsage =>
      'Aquí puedes cambiar el uso de tu Touch ID para iniciar sesión en la aplicación Givt.';

  @override
  String get faceIdUsage =>
      'Aquí puedes cambiar el uso de tu Face ID para iniciar sesión en la aplicación Givt.';

  @override
  String get fingerprintUsage =>
      'Aquí puedes cambiar el uso de tu huella dactilar para iniciar sesión en la aplicación Givt.';

  @override
  String get offlineGiftsTitle => 'Donaciones sin conexión';

  @override
  String get amountTooHigh => 'Monto demasiado alto';

  @override
  String get loginFailure => 'Error de inicio de sesión';

  @override
  String get requestFailed => 'Solicitud fallida';

  @override
  String get resetPasswordSent =>
      'Debería haber recibido un correo electrónico con un enlace para restablecer tu contraseña. En caso de que no veas el correo electrónico de inmediato, revisa tu correo no deseado.';

  @override
  String get success => '¡Listo!';

  @override
  String get notSoFast => '¡No tan rápido, gastalón!';

  @override
  String get giftBetween30Sec =>
      'Ya diste hace menos de 30 segundos. ¿Puedes esperar un poco?';

  @override
  String get nonExistingEmail =>
      'No hemos visto este correo electrónico antes. ¿Es posible que te hayas registrado con un correo diferente?';

  @override
  String get amountTooLow => 'Monto demasiado bajo';

  @override
  String get qrScanFailed => 'Error al apuntar';

  @override
  String get cancelFailed => 'Error al cancelar';

  @override
  String get accessDenied => 'Acceso denegado';

  @override
  String get unknownError => 'Error desconocido';

  @override
  String get mandateFailed => 'Error de autorización';

  @override
  String qrScannedOutOfApp(Object value0) {
    return '¡Hola! ¡Qué bien que quieras donar con un código QR! ¿Estás seguro de que deseas donar a $value0?';
  }

  @override
  String get saveFailed => 'Error al guardar';

  @override
  String get invalidEmail => 'Correo electrónico inválido';

  @override
  String get giftsOverviewSent =>
      'Hemos enviado el resumen de tus donaciones a tu buzón de correo.';

  @override
  String get downloadYearOverviewByChoice =>
      '¿Deseas descargar un resumen anual de tus donaciones? Elige el año a continuación y te enviaremos el resumen a';

  @override
  String get mandateFailTryAgainLater =>
      'Algo salió mal al generar el mandato. ¿Puede intentarlo de nuevo más tarde?';

  @override
  String get termsTextGb =>
      'GIVT LTD \n\nTerms of use – Givt app \nLast updated: 24-11-2023\nVersion: 1.5\n\n1.  \tGeneral \nThese terms of use describe the conditions under which the mobile application Givt (\"Givt\") can be utilised. Givt allows the User (anonymously) to give donations through their smartphone, for example churches, fundraising campaigns or charities that are members of Givt Ltd.  \n\nThese terms of use apply to the use of Givt. Through the use of Givt (which means the download and the installation thereof), you (\"the User\") accept these terms of use and our privacy policy (https://givt.co.uk/privacystatementgivt-service). These terms of use and our privacy policy are also available on our website to download and print. We may revise these terms of use from time to time. \n\n2.  \tLicense and intellectual property rights \n\n2.1\tAll rights to Givt, the accompanying documentation and all modifications and extensions thereto as well as the enforcement thereof are and remain the property of Givt. The User is granted solely the rights and authorities and/or permissions ensuing from the effect of this agreement or which are assigned in writing, and you may not otherwise use, reproduce or publicly release Givt. \n\n2.2\tGivt grants the User a non-exclusive, non-sublicensable and non-transmittable license to use Givt. The User is not allowed to use Givt for commercial purposes. \n\n2.3  \tThe User may not provide Givt to third parties nor sell, rent, decompile, submit to reverse engineer or modify it without prior permission from Givt. Nor should the User, or let others, remove or bypass the technical provisions that are intended to protect Givt. \n\n2.4 \tGivt has the right to change Givt at any time, modify or remove data, deny the User the use of Givt by termination of the license, limitation of the use of Givt or deny access to Givt in whole or in part, temporarily or permanently. Givt will inform the User about this in an appropriate manner. \n\n2.5 \tThe User acquires no right, title or interest to the intellectual property rights and/or similar rights to (the means of) Givt, including the underlying software and content.\n\n3. \tThe use of Givt \n\n3.1 \tThe User can only give donations to churches, charities, fundraising campaigns and/or other legal entities that are affiliated with Givt. The donations are done anonymously. \n\n3.2  \tThe use of Givt is at your own risk and expense and should be used in accordance with the purposes for which it is intended. It is prohibited to reverse engineer the source code of Givt or to decompile and/or modify Givt, to make a copy of Givt available to any third party or to remove, delete or render illegible any designations of Givt as the party holding rights to Givt or parts thereof.\n\n3.3\tThe User is responsible for the correct submission of data such as name and address details, bank account number and other information as requested by Givt to ensure the use of Givt. \n\n3.4\tIf the User is under the age of 18 they must have the consent of their parent or legal guardian in order to use Givt. By accepting these terms of use, the User guarantees that they are 18 years of age or have the permission of their parents or legal representative. \n\n3.5 \tGivt is available for the operating systems Android and iOS. In addition to the provisions set out below, Apple’s App Store or Google Play may attach conditions to the acquisition of Givt, its use and related matters. For further information, see the terms of use and privacy policy of Apple’s App Store and Google Play as well as any other applicable terms and conditions appearing on the website of the respective provider. This end user licence is applicable to the agreement between the User and Givt and does not apply between the User and the provider of the platform through which you acquired Givt. That provider may hold you liable for violation of provisions in this end user licence, however.\n\n3.6\tAfter the User has downloaded Givt, the User is requested to register. In doing so, the User must provide the following information: (i) name (ii) address, (iii) phone number, (iv) bank account number, and (v) e-mail address. The privacy policy of Givt is applied to the processing of personal data via Givt. The User must inform Givt immediately if any of this data changes by correcting the information within the app.\n\n3.7\tThe User may, after installing the Givt app, also choose to only enter an e-mail address and immediately use the app to donate. After the donation, the User will be asked to complete the registration procedure. If the User wishes to do so later, Givt ensures to only use the User\'s e-mail address to remind the User to finish the registration procedure until this procedure is finalised.\n\n3.8 \tThe User is responsible for any expenses related to the equipment, software system and (internet) connection to make use of Givt.\n\n3.9 \tGivt provides the related services based on the information the User submits. The User is obliged to provide correct and complete information, which is not false or misleading. The User may not provide data with respect to names or bank accounts for which the User is not authorised to use. Givt and the Processor have the right to validate and verify the information the User has provided. \n\n3.10 \tThe User may at any time terminate the use of Givt, by deleting their account via the menu in the app or via mail to support@givt.app. Deleting the app from the smartphone without following aforementioned steps will not result in deletion of the User’s data. Givt can terminate the relationship with the User if the User does not comply with these terms and conditions or if Givt has not been used for 18 consecutive months. On request Givt can send a listing of all donation data. \n\n3.11 \tGivt does not charge fees for the use of Givt. \n\n3.12\tGivt has the right to adjust the offered functionalities from time to time to improve, to change or to fix errors. Givt will always work to fix errors within the Givt software, but cannot guarantee that all errors, whether or not in a timely fashion, be restored. \n\n4. \tProcessing transactions and Protecting your money\n\n4.1 \tGivt does not provide banking or payment services. To facilitate the processing of donations from the User, Givt has entered into an agreement with Access Paysuite Ltd, an Electronic Money Institution, authorised and regulated by the Financial Conduct Authority (FRN 730815) (“Access PaySuite”)(the \"Processor\"). Givt will, after the collection of donations, ensure the payment of donations to the user-designated beneficiary. The transaction data will be processed and forwarded to the Givt Processor. The Processor will initiate payment transactions whereas Givt is responsible for the transaction of the relevant amounts to the bank account of the Church/Charity as being the user-designated beneficiary of the donation.\n\n4.2 \tThe User agrees that Givt may pass the User’s (transaction and bank) data to the Processor, along with all other necessary account and personal information of the User, in order to enable the Processor to initiate the payment transactions and processing. Givt reserves the right to change the Processor at any time. The User agrees that Givt may forward the relevant information and data about the User as defined in article 4.2 to the new Processor to be able to continue processing payment transactions. \n\n4.3 \tGivt and the Processor will process the data of the User in accordance with the law and regulations that apply to data protection. For further information on how personal data is collected, processed and used, Givt refers the User to its privacy policy. This can be found at: (https://givt.co.uk/privacystatementgivt-service/).\n\n4.4 \tThe donations of the User will pass through Access PaySuite. Givt will ensure that the funds will be transferred to the beneficiary, with whom Givt has an agreement. \n\n4.5 \tThe User can reverse a debit at any time, within the terms of the User\'s bank, and the direct debit scheme. \n\n4.6 \tGivt and/or the Processor can refuse a donation if there are reasonable grounds to believe that a user is acting in violation of these terms or if there are reasonable grounds to believe that a donation is possibly suspicious or illegal. In this case Givt will inform the User as soon as possible, unless prohibited by law. \n\n4.7\tUsers of the Givt app will not be charged for their donations through our platform. Givt and the receiving party have made separate compensation arrangements pursuant to the agreement in effect between them.\n\n4.8 \tThe User agrees that Givt may pass transactional data of the User to the HMRC, along with all other necessary account and personal information of the User, in order to assist the User with their annual tax return.   \n\n4.9\tWe will hold your money in a Client Funds Account, provided by Access PaySuite. The account is segregated from our own assets. The money contained in the Client Funds Account cannot be used by Givt, invested or lent to third parties, or in any way form part of Givt’s assets.\n\n4.10\tCurrent Regulatory Provisions exclude money placed on a Client Funds Account from the UK Financial Services Compensation Scheme (FSCS).\n\n4.11\tMoney placed or held in the Client Funds Account shall not constitute a deposit (within the meaning of Article 5 of Directive 2006/48/EC) and does not earn interest.\n4.12\tDeposits and, in particular, withdrawals from the Client Funds Account will only be made in the following circumstances:\n\nIn the case of deposits:\n\nTo receive money intended for onward payment to the designated charity/charities or church(es)\nTo replenish the account where fees or other costs associated with running the account have been deducted\nTo receive refunds in the event that prior instruction to make a payment by you is cancelled, in accordance with these Terms and Conditions\n\nIn the case of withdrawals:\n\nTo pay designated charities and churches, in accordance with your instructions\nTo pay fees or other costs associated with running the account\nTo return money to you, in the event that prior instruction to make a payment by you is canceled, in accordance with these Terms and Conditions.\n\n5. \tSecurity, theft and loss \n\n5.1 \tThe User shall take all reasonable precautions safekeeping their login credentials for Givt to avoid loss, theft, misappropriation or unauthorised use of Givt on their device.\n\n5.2 \tThe User is responsible for the security of their device. Givt considers any donation from the Givt account as a user-approved transaction, regardless of the rights of the User under article 4.5.\n\n5.3 \tThe User shall inform Givt immediately via info@givt.app or +44 20 3790 8068 once their device is lost or stolen. Upon receipt of a message Givt will block the account to prevent (further) misuse. \n\n6.\tUpdates\n\n6.1\tGivt releases updates from time to time, which can rectify errors or improve the functionality of Givt. Available updates for Givt will be announced by means of notification through Apple’s App Store and Google Play and it is the User’s sole responsibility to monitor these notifications and keep informed about new updates.\n\n6.2\tAn update can stipulate conditions, which differ from the provisions in this agreement. The User will always be notified in advance so that they have the opportunity to refuse the update. By installing such an update, the User agrees to these new conditions, which will then form part of this agreement. If User does not agree to the changed conditions, they will have to cease using Givt and delete Givt from their device.\n\n7. \tLiability \n\n7.1 \tGivt has been compiled with the utmost care. Although Givt strives to make Givt available 24 hours a day, it accepts no liability if, for any reason, Givt is not available at any given time or for a certain period of time. Givt reserves the right to temporarily or permanently discontinue Givt (unannounced). The User cannot derive any rights from this. \n\n7.2 \tGivt is not liable for damage or injury resulting from the use of Givt. The limitations of liability as mentioned in this article shall lapse if the liability for damage is the result of intent or gross negligence on the part of Givt.\n\n7.3 \tThe User indemnifies Givt against any claim from third parties (for example, beneficiaries of the donations or HMRC) as a result of the use of the Givt or not correctly meeting the agreements made concerning legal or contractual obligations with Givt. The User will pay all damages and costs to Givt as a result of such claims.\n\n8. \tOther provisions \n\n8.1 \tThis agreement comes into effect on commencement of the use of Givt and will remain in force for an undetermined period from that moment. This agreement may be terminated by the User as well as by Givt at any moment, subject to one month’s notice. This agreement will end by operation of law in the event you are declared bankrupt, you apply for a moratorium on payments or a general attachment is levied against your assets, in the event of your death, or in the event you go into liquidation, are wound up or dissolved. Following the termination of this agreement (for whatever reason), you shall cease and desist from all further use of Givt. You must then delete all copies (including back-up copies) of Givt from all your devices.\n\n8.2\tIf any provision of these terms and conditions is void or destroyed, this will not affect the validity of the agreement as a whole, and other provisions of these terms remain in force. In that case, the parties will decide on a new replacement provision or provisions which will be in line with the intention of the original agreement as far as is legally possible.\n\n8.3 \tThe User is not allowed to transfer the rights and/or obligations arising from the use of Givt and these terms to third parties without prior written permission of Givt. Conversely, Givt is allowed to do so. \n\n8.4 \tWe will endeavor to resolve the dispute amicably. Any disputes arising from or in connection with these terms and conditions are finally settled in the Courts of England and Wales. \n\n8.5  \tThe Law of England and Wales is applicable on these terms of use. \n\n8.6 \tThe terms of use shall not affect the User\'s statutory rights as a consumer.\n\n8.7 \tGivt features an internal complaints procedure. Givt handles complaints efficiently and as soon as reasonably possible. Any complaint about the implementation of these conditions by Givt must be submitted in writing at Givt (via support@givt.app).\n\n\n';

  @override
  String get firstCollect => '1ª colecta';

  @override
  String get secondCollect => '2ª colecta';

  @override
  String get thirdCollect => '3ª colecta';

  @override
  String get addCollect => 'Añadir una colecta';

  @override
  String get policyTextGb =>
      'Latest Amendment: 24-09-2021\n Version 1.9\n \n\n Givt Limited Privacy Policy  \n \n\n Introduction\n This Privacy Policy outlines Givt Limited’s (\" we \", \" our \" or \" the Company \") practices with respect to information collected from our Application (“App”) or from users that otherwise share personal information with us (collectively: \"Users\"). \n \n\n Grounds for data collection \n \n\n Processing of your personal information (meaning, any information which may potentially allow your identification with reasonable means; hereinafter \"Personal Information\") is necessary for the performance of our contractual obligations towards you and providing you with our services, to protect our legitimate interests and for compliance with legal and financial regulatory obligations to which we are subject.\n \n\n When you use our App or register yourself or an organisation you represent with us, you consent to the collection, storage, use, disclosure and other uses of your Personal Information as described in this Privacy Policy.\n \n\n We encourage our Users to carefully read the Privacy Policy and use it to make informed decisions. \n \n\n What information do we collect?\n \n\n We collect two types of data and information from Users. \n \n\n The first type of information is un-identified and non-identifiable information pertaining to a User(s), which may be made available or gathered via your use of the App (“ Non-personal Information ”). We are not aware of the identity of a User from which the Non-personal Information was collected. Non-personal Information which is being collected may include your aggregated usage information and technical information transmitted by your device, including certain software and hardware information (e.g. language preference, access time, etc.) in order to enhance the functionality of our App.\n \n\n The second type of information is Personal Information, which is personally identifiable information, namely information that identifies an individual or may with reasonable effort identify an individual. Such information includes:\n Device Information: We collect Personal Information from your device. Such information includes geolocation data, IP address, unique identifiers (e.g. MAC address and UUID) and other information which relates to your activity through the App.\n Service User Information: We collect additional information for individuals who would like to use our Services. This is gathered through the App and includes all the information needed to register for our service: \n Name and address, \n Date of birth, \n e-mail address, \n secured password details, and \n bank details for the purposes of making payments.\n Contact information: If you choose to contact us you will be asked to provide us with certain details such as: full name; e-mail or physical address, and other relevant information. This may be for yourself or for people in the organisation you represent.\n  \n How do we receive information about you?\n We receive your Personal Information from various sources:\n \n\n When you voluntarily provide us your personal details in order to register on our App;\n When you use or access our App in connection with your use of our services;\n From third party providers, services and public registers (for example, traffic analytics vendors).\n Through diagnostic information from the App. The App will send us anonymous information about its functioning. This information contains non-personal data from your smartphone like its type and operating system, but also the version information of the App. This data is solely used for purposes of improving our Service or allowing better responses to your questions. This information will never be shared with third-parties. \n What do we do with the information we collect?\n We do not rent, sell, or share Users’ information with third parties except as described in this Privacy Policy.\n \n\n We may use the information for the following:\n To provide the services through the App – we will use a minimum of name and bank details to perform the services of effecting payment(s) via the App. Such information is never shared with intended recipients of donations.;\n Communicating with you – sending you notices regarding our services, providing you with technical information and responding to any customer service issue you may have; to keep you informed of our latest updates and services;\n Conducting statistical and analytical activities, intended to improve the App and/or the App.\n \n\n In addition to the different uses listed above, we may transfer or disclose Personal Information to our subsidiaries, affiliated companies and subcontractors in relation to services that we provide to you.\n \n\n We may also disclose information if we have good faith to believe that disclosure of such information is helpful or reasonably necessary to: (i) comply with any applicable law, regulation, legal process or governmental request; (ii) enforce our policies (including our Agreement), including investigations of potential violations thereof; (iii) investigate, detect, prevent, or take action regarding illegal activities or other wrongdoing, suspected fraud or security issues; (iv) to establish or exercise our rights to defend against legal claims; (v) prevent harm to the rights, property or safety of us, our users, yourself or any third party; or (vi) for the purpose of collaborating with law enforcement agencies and/or in case we find it necessary in order to enforce intellectual property or other legal rights.\n \n\n User Rights\n You may request to: \n Receive confirmation as to whether or not personal information concerning you is being processed, and access your stored personal information, together with supplementary information. \n Receive a copy of personal information you directly volunteer to us in a structured, commonly used and machine-readable format. \n Request rectification of your personal information that is in our control.\n Request erasure of your personal information. \n Object to the processing of personal information by us. \n Request to restrict processing of your personal information by us.\n Lodge a complaint with a supervisory authority.\n \n\n However, please note that these rights are not absolute, and may be subject to our own legitimate interests and regulatory requirements. \n \n\n If you have any questions about this Privacy Policy, please contact us:\n \n\n By e-mail: support@givt.app\n By visiting this page on our Website: https://givt.co.uk/faq-3/\n By phone number: +44 20 3790 8068.\n \n\n Retention\n We will retain your personal information for as long as necessary to provide our services, and as necessary to comply with our legal obligations, resolve disputes, and enforce our policies. Retention periods will be determined taking into account the type of information that is collected and the purpose for which it is collected, bearing in mind the requirements applicable to the situation and the need to destroy outdated, unused information at the earliest reasonable time. Under applicable regulations, we will keep records containing client personal data, account opening documents, communications and anything else as required by applicable laws and regulations. \n \n\n We may rectify, replenish or remove incomplete or inaccurate information, at any time and at our own discretion.\n \n\n Use of Location Services\n \n\n The App may use the location services as provided by the operating system on the smartphone. With these services, the App may determine the location of the user. The location data will not be sent anywhere outside the smartphone, and is solely used to determine whether the user is in a location where it’s possible to use the App for donating. The locations where one can use App are downloaded to the smartphone prior to using the location services.\n \n\n How do we safeguard your information?\n \n\n We take security measures to reduce misuse of and unauthorised access to personal data. We take the following measures in particular:\n \n\n Access to personal data requires the use of a username and password\n Access to personal data requires the use of a username and login token\n We make use of secure connections (Secure Sockets Layer of SSL) to encrypt all information between you and our website when entering your personal data.\n We keep logs of all requests for personal data.\n \n\n Although we take reasonable steps to safeguard information, we cannot be responsible for the acts of those who gain unauthorised access or abuse our App, and we make no warranty, express, implied or otherwise, that we will prevent such access.\n \n\n Transfer of data outside the EEA \n Please note that some data recipients may be located outside the EEA. In such cases we will transfer your data only to such countries as approved by the European Commission as providing adequate level of data protection, or enter into legal agreements ensuring an adequate level of data protection.\n \n\n Advertisements\n We do not use third-party advertising technology to serve advertisements when you access the App. \n \n\n Marketing\n We may use your Personal Information, such as your name, email address to send you a Newsletter about our products and services. You may opt out of receiving this Newsletter at any time by unsubscribing via the link.\n \n\n Providing Data to Third Parties\n We may provide your information to our partners. These partners are involved in the execution of the agreement. In all cases, these parties are necessary to provide the services. These are not the collecting authorities, as we protect the anonymity of users.\n You agree that the transaction data are anonymous and can be used for data collection, statistics, reviews and comparisons. Only the summary will be shared with other customers and we ensure you that none of your data will be traceable to individuals.\n \n\n We will also never sell data to third parties. We are only committed to make it easier for the donor to give to charities of their choosing.\n \n\n Updates or amendments to this Privacy Policy\n We reserve the right to periodically amend or revise the Privacy Policy; material changes will be effective immediately upon the display of the revised Privacy policy. The last revision will be reflected in the \"Last modified\" section. Your continued use of our Services following the notification of such amendments on our Website or through the App, constitutes your acknowledgment and consent of such amendments to the Privacy Policy and your agreement to be bound by the terms of such amendments.\n \n\n How to contact us\n \n\n If you have any general questions about the App or the information we collect about you and how we use it, you can contact us at: support@givt.app\n \n\n or\n \n\n By visiting this page on our Website: https://givt.co.uk/faq-3/\n By phone number: +44 20 3790 8068.\n \n\n Givt Ltd. is a part of Givt B.V., our office is located on the Bongerd 159 in Lelystad, the Netherlands.\n Company Number (CRN): 11396586';

  @override
  String get amount => 'Elige el monto';

  @override
  String get amountLimit => 'Determina el monto máximo de tus Givt';

  @override
  String get cancel => 'Cancelar';

  @override
  String get city => 'Ciudad/Localidad';

  @override
  String get country => 'País';

  @override
  String get email => 'Correo electrónico';

  @override
  String get firstName => 'Nombre';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get forgotPasswordText =>
      'Introduce tu dirección de correo electrónico. te enviaremos un correo con la información sobre cómo cambiar tu contraseña.\n \n\n Si no encuentras el correo de inmediato, por favor revisa tu carpeta de spam.';

  @override
  String get give => 'Donar';

  @override
  String get selectReceiverButton => 'Seleccionar';

  @override
  String get giveLimit => 'Importe máximo';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get loginText =>
      'Para acceder a tu cuenta, queremos asegurarnos de que realmente eres tú.';

  @override
  String get logOut => 'Cerrar sesión';

  @override
  String get makeContact =>
      'Este es el momento Givt.\n Acerca tu teléfono a la \n caja, bolsa o cesta de colecta.';

  @override
  String get next => 'Siguiente';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordRule =>
      'La contraseña debe contener al menos 7 caracteres';

  @override
  String get phoneNumber => 'Teléfono';

  @override
  String get postalCode => 'Código postal';

  @override
  String get ready => 'Hecho';

  @override
  String get registerPersonalPage =>
      'Para procesar tus donaciones,\n necesitamos algunos datos personales.';

  @override
  String get registrationSuccess => 'Registro exitoso.\n ¡Disfruta donando!';

  @override
  String get send => 'Enviar';

  @override
  String get somethingWentWrong => '¡Ups! Algo salió mal.';

  @override
  String get streetAndHouseNumber => 'Nombre de la calle y número';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get wrongCredentials =>
      'Correo electrónico o contraseña no válidos. ¿Es posible que te hayas registrado con un correo electrónico diferente?';

  @override
  String get yesPlease => 'Sí, por favor';

  @override
  String get bluetoothErrorMessage =>
      'Activa el Bluetooth para estar listo para donar a una colecta.';

  @override
  String get save => 'Guardar';

  @override
  String get acceptPolicy => 'Ok, Givt tiene permiso para guardar mis datos.';

  @override
  String get close => 'Cerrar';

  @override
  String get termsTitle => 'Nuestros Términos de Uso';

  @override
  String get fullVersionTitleTerms => 'Términos de Uso';

  @override
  String get termsText =>
      'Last updated: 26-05-2025\nEnglish translation of version 2.0\n\n1. ​General\nThese terms of use describe the conditions under which the mobile and web applications of Givt (\"Givt\") may be used. Givt enables the User to give (anonymous) donations via their smartphone and/or web browser to, for example, churches, funds, or foundations that are affiliated with Givt or with a third party with whom Givt partners. Givt is managed by Givt B.V., a private limited company, located in Lelystad (8212 BJ), at Bongerd 159, registered in the trade register of the Chamber of Commerce under number 64534421 (\"Givt B.V.\"). These terms of use apply to the use of Givt. By using Givt (which includes downloading and installing it or making a donation via the Givt website), you as a user (\"User\") accept these terms of use and our privacy statement (www.givtapp.net/privacyverklaring). These terms of use and our privacy statement can also be consulted, downloaded, and printed from our website. We may amend these terms of use from time to time.\n\n2. ​License and Intellectual Property Rights\n2.1 All rights to Givt, the accompanying documentation, and all modifications and extensions thereof and the enforcement thereof are and shall remain with Givt B.V. The User only obtains the user rights and powers that arise from the scope of these terms, and for the rest, you may not use, reproduce, or disclose Givt.\n2.2 Givt B.V. grants the User a non-exclusive, non-sublicensable, and non-transferable license for the use of Givt. The User is not permitted to use Givt for commercial purposes.\n2.3 The User may not make Givt available to third parties, sell, rent, decompile, subject to reverse engineering, or modify it without the prior consent of Givt B.V. Nor may the User remove or circumvent the technical provisions intended to protect Givt.\n2.4 Givt B.V. has the right at all times to modify Givt, change or delete data, deny the User the use of Givt by terminating the license, restrict the use of Givt, or deny access to Givt in whole or in part, temporarily or permanently. Givt B.V. will inform the User about this in a manner it deems appropriate.\n2.5 The User does not acquire any right, title, or interest in or to the intellectual property rights and/or similar rights to (the content of) Givt, including the underlying software and content.\n\n3.0 Use of Givt\n3.1 The User can only make donations to churches, foundations, funds, and/or other (legal) persons that are offered by Givt and have entered into a relationship with Givt B.V. or one of its partners. The donor is anonymous to the recipient, unless otherwise indicated.\n3.2 The use of Givt is at your own expense and risk and must be used in accordance with the purposes for which it is intended. It is not permitted to reverse engineer the source code of Givt or to decompile and/or modify Givt, to make Givt available to third parties, or to remove or make illegible any indications of Givt B.V. as the rights holder of Givt or parts thereof.\n3.3 The User is responsible for the correct provision of data such as name and address details, bank account number, and other data as requested by Givt B.V. to ensure the use of Givt.\n3.4 If the User is younger than 18 years old, they must have the consent of their parent or legal guardian to use Givt. By accepting these terms of use, the User guarantees that they are 18 years of age or older or have permission from their parents or legal guardian.\n3.5 The Givt app is available for the Android and iOS operating systems, and the web functionality is available for the most common and modern web browsers. In addition to the provisions below, Apple\'s App Store or Google Play may impose conditions on obtaining Givt, its use, and related matters. For this, please consult the terms of use and privacy statement of Apple\'s App Store and Google Play and any applicable conditions on the website of the respective provider. These terms of use apply to the agreement between the User and Givt B.V. and do not apply between the User and the provider of the platform through which you obtained Givt. However, these providers may hold the User accountable for violating provisions in these terms of use.\n3.6 After the User has downloaded Givt, the User must register. In doing so, the User must provide the following information: (i) name and address details, (ii) telephone number, (iii) bank account number, and (iv) email address. The processing of personal data via Givt is subject to the privacy statement of Givt B.V. In the event of any changes to data, the User must immediately adjust this via Givt.\n3.7 To be able to use Givt, the User must, at their own expense, provide the necessary equipment, system software, and (internet) connection.\n3.8 Givt B.V. provides the related services based on the information the User provides. The User is obliged to provide correct and complete information that is not false or misleading. The User may not provide data relating to names or bank accounts that the User is not authorized to use. Givt B.V. and the Processor have the right to validate and verify the information provided by the User.\n3.9 The User can terminate the use of Givt at any time by deleting their Givt account via the menu in the app, or via email to support@givtapp.net. Deleting the app on the smartphone without following these steps does not result in an automatic deletion of the User\'s data. Givt B.V. may terminate the relationship with the User if the User does not comply with these terms or if Givt is not used for 18 consecutive months. Upon request, Givt B.V. will send an overview of all donation data if this happens before the account is deleted by the User.\n3.10 Givt B.V. does not charge a fee for the use of Givt.\n3.11 Givt B.V. has the right to adjust the offered functionalities from time to time to improve or change them and to correct errors. Givt B.V. will make an effort to resolve any errors in the Givt software but cannot guarantee that all errors will be corrected, whether in a timely manner or not.\n\n4.0 Transaction Processing\n4.1 Givt B.V. is not a bank/financial institution and does not provide banking or payment processing services. To process the User\'s donations, Givt B.V. has therefore entered into an agreement with a payment service provider called Better World Payments, a financial institution (the \"Processor\"), in which it is agreed that Givt B.V. will send the transaction data to the Processor to initiate and handle donations. Givt B.V. will, after the collection of the donations, ensure the remittance of the donations to the beneficiary(s) appointed by the User. The transaction data will be processed by Givt and forwarded to the Processor. The Processor will initiate the payment transactions, and Givt B.V. is responsible for transferring the relevant amounts to a bank account of the church/foundation as designated by the User as the beneficiary of the donation.\n4.2 The User agrees that Givt B.V. may pass on the User\'s (transaction and bank) data to the Processor, along with all other necessary account and personal information of the User, to enable the Processor to initiate and process the payment transactions. Givt B.V. reserves the right to change its Processor at any time. The User agrees that Givt B.V. may forward relevant information about the User and the data as described in Article 4.2 to the new Processor in order to continue processing payment transactions.\n4.3 Givt B.V. and the Processor will process the User\'s data in accordance with the laws and regulations that apply to data protection. For further information on how personal data is collected, processed, and used, Givt B.V. refers the User to its privacy policy. This can be found online (www.givtapp.net/privacyverklaring).\n4.4 The User\'s donations are processed through Givt B.V. as an intermediary. Givt B.V. will then ensure that the funds are transferred to the beneficiary(s) with whom Givt B.V. has concluded an agreement.\n4.5 To make a donation via Givt, the User must issue an authorization to Givt B.V. and/or the Processor (for an automatic SEPA direct debit) or complete the transaction directly with another payment method. The User can at any time – within the conditions applied by the User\'s bank – reverse an automatic direct debit.\n4.6 A donation may be refused by Givt B.V. and/or the Processor if there are reasonable grounds to assume that a User is acting in violation of these terms or if there are reasonable grounds to assume that a donation may be suspicious or illegal. Givt B.V. will inform the User of this as soon as possible, unless this is prohibited by law.\n4.7 Users of the Givt app will not be charged any fees for their donations via our platform. Givt and the receiving party have made separate agreements regarding fees in their applicable agreement. In some cases, the User is offered the opportunity to make a voluntary platform contribution. When the User chooses to make this contribution, it is a gift to Givt B.V. and is not considered a cost. Givt B.V. uses this voluntary platform contribution to reduce the costs for foundations and churches at its own discretion.\n4.8 The User agrees that Givt B.V. may pass on the User\'s (transaction) data to the local tax authorities, along with all other necessary account and personal information of the User, to assist the User with their annual tax return.\n\n5.0 Security, Theft, and Loss\n5.1 The User must take all reasonable precautions to keep their login details for Givt secure to prevent loss, theft, misappropriation, or unauthorized use of Givt or their smartphone.\n5.2 The User is responsible for the security of their smartphone. Givt B.V. considers every donation from the User\'s Givt account to be a transaction approved by the User, regardless of the rights that the User has under Article 4.5.\n5.3 The User must immediately notify Givt B.V. via support@givtapp.net or +31 320 320 115 as soon as their smartphone is lost or stolen. Upon receipt of a notification, Givt B.V. will block the account to prevent (further) misuse.\n\n6.0 Updates\n6.1 Givt B.V. will release updates from time to time to improve the user experience, which may fix bugs or improve the functioning of Givt. Available updates for Givt will be announced via notifications through Apple\'s App Store and Google Play, and it is the sole responsibility of the User to keep track of these notifications.\n6.2 An update may impose conditions that deviate from those set out in these terms. This will always be communicated to the User in advance, and the User will have the opportunity to refuse the update. By installing such an update, the User agrees to these deviating conditions, which will then form part of these terms of use. If the User does not agree with the amended conditions, they must cease using Givt and remove Givt from their mobile phone and/or tablet.\n\n7.0 Liability\n7.1 Givt has been compiled with the greatest care. Although Givt B.V. strives to make Givt available 24 hours a day, it accepts no liability if, for any reason, Givt is not available at a certain time or for a certain period. Givt B.V. reserves the right to discontinue Givt (unannounced) temporarily or permanently, without the User being able to derive any rights from this.\n7.2 Givt B.V. is not liable for damage or injury resulting from the use of Givt. The limitations of liability as mentioned in this article shall not apply if the liability for damage is the result of intent or gross negligence on the part of Givt B.V.\n7.3 The User indemnifies Givt B.V. against all possible claims from third parties (for example, beneficiaries of the donations or the tax authorities) as a result of the use of Givt or the failure to comply, or to comply correctly, with legal or contractual obligations towards Givt B.V. The User will reimburse Givt B.V. for all damages and costs that Givt B.V. suffers as a result of such claims.\n\n8.0 Other Provisions\n8.1 These terms of use come into effect upon the use of Givt, including the online web services that Givt makes available, and then remain in force for an indefinite period. The agreement may be terminated by either the User or Givt B.V. at any time with a notice period of one month. This agreement terminates automatically if the User: (i) is declared bankrupt, (ii) applies for a moratorium on payments or if a general seizure of the User\'s assets is made, (iii) the User passes away, (iv) goes into liquidation, is dissolved, or is wound up. After termination of the agreement (for whatever reason), the User must cease and desist all use of Givt. The User must then remove all copies (including backup copies) of Givt from all of their systems.\n8.2 If any provision of these terms is void or nullified, this does not affect the validity of the entire agreement, and the other provisions of these terms will remain in force. In that case, the parties will establish (a) new provision(s) to replace it, giving shape to the intention of the original agreement as much as is legally possible.\n8.3 The User is not permitted to transfer rights and/or obligations arising from the use of Givt and these terms to third parties without the prior written consent of Givt B.V. Conversely, Givt B.V. is permitted to do so.\n8.4 Any disputes arising from or in connection with these terms will be finally settled by the court of Lelystad. Before the dispute is referred to the court, you and we will endeavor to resolve the dispute amicably.\n8.5 Dutch law applies to these Terms of Use.\n8.6 The Terms of Use do not prejudice the User\'s mandatory statutory rights as a consumer.\n8.7 Givt B.V. has an internal complaints procedure. Givt B.V. handles complaints efficiently and as soon as is reasonably possible. If the User has a complaint about the implementation of these terms by Givt B.V., the User must submit it in writing to Givt B.V. (via support@givtapp.net).';

  @override
  String get policyText =>
      'Last updated: May 26, 2025\nTranslation of original: 2.0\nPrivacy Statement of the Givt Service\n\nThrough the Givt service – consisting of both an app and an online platform – sensitive data, or personal data, is processed. Givt B.V. considers the careful handling of personal data to be of great importance. Therefore, we process and secure personal data with care.\n\nIn our processing, we comply with the requirements of the General Data Protection Regulation (GDPR). This means, among other things, that we:\n- clearly state the purposes for which we process personal data;\n- limit our collection of personal data to only that which is necessary for legitimate purposes;\n- take appropriate security measures;\n- respect your rights (access, correction, deletion, objection);\n- only share data with third parties when necessary or legally required;\n- guarantee the anonymity of donors towards charities.\n\n1. Data Controller\nGivt B.V. is the data controller for all data processing within the app and the platform. Our processing is registered with the Dutch Data Protection Authority (Autoriteit Persoonsgegevens) under number M1640707. In this privacy statement, we explain which personal data we collect and use, and for what purpose. We recommend that you read it carefully.\n\nFor questions about this statement or your rights, you can contact us via info@givtapp.net.\n\n2. Use of Personal Data\nWhen using our services, we may process the following personal data:\n\nName, address, and city of residence (NAW)\nEmail address\nPhone number\nPayment details\nWe use this data for the following purposes and on the following legal bases:\n- Execution of donations – performance of a contract\n- Account registration and user convenience – legitimate interest\n- Sending newsletters – consent\n- Customer contact via contact form or email – legitimate interest\n- Analysis of user behavior (donation flow) – legitimate interest\n- Improving the service and app – legitimate interest\n- Compliance with legal obligations – legal basis\n\n3. Analysis of User Behavior\nWe collect behavioral data on how users use our app and online donation environment. This includes clicks on buttons, the flow of donation processes, and technical error messages. This helps us to improve usability and identify bottlenecks.\n\nFor these analyses, we use the tool Amplitude. This tool collects pseudonymized data and only links it to users with an account. We use this information exclusively internally. A data processing agreement has been concluded with Amplitude. Data is not sold or shared with third parties.\n\n4. Cookies\nOur website uses cookies and similar technologies. Cookies are only placed if you give your consent via our cookie banner. Functional cookies (for the functioning of the site) are always placed.\n\nWe use, among others, Google Analytics (with IP anonymization) to analyze website usage. The _ga cookie is stored for a maximum of 2 years.\n\nYou can always change your cookie preferences via our cookie banner or browser settings.\n\n5. Newsletter and Contact\nWe offer a newsletter to inform interested parties about our (new) products and/or services. Each newsletter contains a link to unsubscribe. Your email address is automatically added to the list of subscribers.\n\nIf you fill out a contact form or send an email, we will retain the data for as long as necessary for the complete handling of your query.\n\n6. Advertising\nIn addition to the information provided via our online service infrastructure, we may inform you about our new products and services by email.\n\n7. Provision to Third Parties\nWe only provide your data to third parties if this is necessary for the performance of our agreement, or if legally required. Examples include payment processors or hosting providers. We never sell your data and guarantee the anonymity of donors towards charities. Transaction data may be anonymized for statistical purposes.\n\n8. Data Security\nWe take security measures to limit misuse of and unauthorized access to personal data. Specifically, we take the following measures:\n- Access to personal data is protected by a username and password.\n- We use secure connections (TLS/SSL or Transport Layer Security/Secure Sockets Layer) that encrypt all information between you and our online service infrastructure when you enter personal data.\n- We keep logs of all requests for personal data.\n\n9. Use of Location Data\nThe app may use location data to determine if you are in a place where Givt can be used. This data is processed exclusively locally on your device and is not transmitted or stored.\n\n10. Diagnostic Information from the App\nThe app sends anonymized information about its operation. This information contains non-personal data from your smartphone, such as the type and operating system, as well as the app version. This data is used solely to improve the Givt service or to answer your questions more quickly. This information is never provided to third parties.\n\n11. Changes to this Privacy Statement\nWe may change this privacy statement from time to time. The most current version is always available on our website. We recommend that you consult this statement regularly.\n\n12. Accessing and Changing Your Data\nYou have the right to access your data, to have it corrected or deleted, to object to its processing, and to withdraw your consent. You can contact us at any time using the details below:\n\nGivt B.V.\nBongerd 159\n8212 BJ LELYSTAD\nThe Netherlands\n+31 320 320 115\ninfo@givtapp.net\nChamber of Commerce (KVK) no: 64534421';

  @override
  String get needHelpTitle => '¿Necesitas ayuda?';

  @override
  String get findAnswersToYourQuestions =>
      'Aquí encontrará respuestas a sus preguntas y consejos útiles';

  @override
  String get questionHowDoesRegisteringWorks => '¿Cómo funciona el registro?';

  @override
  String get questionWhyAreMyDataStored =>
      '¿Por qué Givt almacena mi información personal?';

  @override
  String get faQvraag1 => '¿Qué es Givt?';

  @override
  String get faQvraag2 => '¿Cómo funciona Givt?';

  @override
  String get faQvraag3 =>
      '¿Cómo puedo cambiar mi configuración o información personal?';

  @override
  String get faQvraag4 => '¿Dónde puedo usar Givt?';

  @override
  String get faQvraag5 => '¿Cómo se retirará mi donación?';

  @override
  String get faQvraag6 => '¿Qué más puedo hacer con Givt?';

  @override
  String get faQvraag7 => '¿Qué tan seguro es donar con Givt?';

  @override
  String get faQvraag8 => '¿Cómo puedo eliminar mi cuenta de Givt?';

  @override
  String get faQantwoord1 =>
      'Donar con su smartphone\n Givt es la solución para donar con tu smartphone cuando no llevas efectivo. Todo el mundo tiene un smartphone y con la aplicación Givt puedes participar fácilmente en la colecta. \n Es un momento personal y consciente, ya que creemos que hacer una donación no es solo una transacción financiera. Usar Givt se siente tan natural como dar dinero en efectivo. \n \n\n ¿Por qué \'Givt\'?\n El nombre Givt fue elegido porque se trata tanto de \'dar\' (giving) como de hacer un \'regalo\' (gift). Buscábamos un nombre moderno y compacto que pareciera amigable y divertido. En nuestro logo puedes notar que la barra verde combinada con la letra \'v\' forma la figura de una bolsa de colecta, lo que da una idea de la función. \n \n\n Países Bajos, Bélgica y Reino Unido\n Detrás de Givt hay un equipo de especialistas, repartidos entre los Países Bajos, Bélgica y el Reino Unido. Cada uno de nosotros trabaja activamente en el desarrollo y mejora de Givt. Lea más sobre nosotros en www.givtapp.net.';

  @override
  String get faQantwoord2 =>
      'El primer paso fue instalar la aplicación. Para que Givt funcione eficazmente, es importante que actives el Bluetooth y tengas una conexión a internet funcional. \n \n\n Luego regístrate completando tu información y firmando un mandato. \n ¡Estás listo para donar! Abre la aplicación, selecciona un importe y escanea un código QR, acerca tu teléfono a la bolsa o cesta de colecta, o selecciona una causa de la lista.\n El monto elegido se guardará, se retirará de tu cuenta y se distribuirá a la iglesia u organizaciones benéficas que recolectan.\n \n\n Si no tienes conexión a internet al hacer tu donación, la donación se enviará más tarde cuando vuelva a abrir la aplicación. Como cuando estas en una zona WiFi.';

  @override
  String get faQantwoord3 =>
      'Puedes acceder al menú de la aplicación tocando el menú en la parte superior izquierda de la pantalla \'Importe\'. Para cambiar su configuración, debe iniciar sesión con su dirección de correo electrónico y contraseña, huella digital/Touch ID o Face ID. En el menú puede encontrar un resumen de sus donaciones, ajustar su importe máximo, revisar y/o cambiar su información personal, cambiar sus importes preestablecidos, huella digital/Touch ID o Face ID, o cancelar su cuenta de Givt.';

  @override
  String get faQantwoord4 =>
      'Cada vez más organizaciones\n Puede usar Givt en todas las organizaciones registradas con nosotros. Más organizaciones se unen cada semana.\n \n\n ¿Aún no está registrada? \n Si su organización aún no está afiliada a Givt, por favor contáctenos al +44 2037 908068 o info@givt.app .';

  @override
  String get faQantwoord5 =>
      'Better World Payments\n Al instalar Givt, el usuario autoriza a la aplicación a debitar su cuenta. Las transacciones son gestionadas por Better World Payments, un banco especializado en procesar mandatos.\n \n\n Revocable posteriormente\n No se realizan transacciones en el momento de la donación. Las transacciones se realizan posteriormente mediante un débito directo. Dado que estas transacciones son revocables, es completamente seguro e inmune al fraude.';

  @override
  String get faQantwoord6 =>
      'Desarrollo continuo\n Givt continúa desarrollando su servicio. Ahora mismo puede donar fácilmente durante la colecta usando su smartphone, pero esto no termina aquí. ¿Tiene curiosidad por saber en qué estamos trabajando? Únase a una de nuestras demostraciones de los viernes por la tarde.\n \n\n Declaración de impuestos\n Al final del año puede solicitar un resumen de todas sus donaciones, lo que le facilita la declaración de impuestos. Eventualmente nos gustaría que todas las donaciones se completaran automáticamente en la declaración.';

  @override
  String get faQantwoord7 =>
      'Seguro y sin riesgos \n Es muy importante para nosotros que todo sea seguro y sin riesgos. Cada usuario tiene una cuenta personal con su propia contraseña. Necesita iniciar sesión para ver o cambiar su configuración.\n \n\n Gestión de transacciones \n Las transacciones son gestionadas por Better World Payments, un banco especializado en procesar mandatos. \n \n\n Inmune al fraude \n Al instalar Givt, el usuario autoriza a la aplicación a debitar su cuenta.\n Queremos enfatizar que no se realizan transacciones en el momento de la donación. Las transacciones se realizan posteriormente mediante un débito directo. Dado que estas transactions son revocables, es completamente seguro e inmune al fraude. \n \n\n Resumen \n Las organizaciones pueden iniciar sesión en el panel de control de Givt. Este panel ofrece un resumen de todas las transacciones financieras, desde el momento de la donación hasta el procesamiento completo del pago. De esta manera, cualquier colecta puede seguirse de principio a fin.\n Las organizaciones pueden ver cuántas personas usaron Givt, pero no quiénes son.';

  @override
  String get faQantwoord8 =>
      '¡Lamentamos oír eso! Nos gustaría saber por qué.\n \n\n Si ya no desea usar Givt, puede darse de baja de todos los servicios de Givt.\n Para darse de baja, vaya a su configuración a través del menú de usuario y elija \'Cancelar mi cuenta\'.';

  @override
  String get privacyTitle => 'Declaración de Privacidad';

  @override
  String get acceptTerms =>
      'Al continuar, aceptas nuestros términos y condiciones.';

  @override
  String get faqHowDoesGivingWork => '¿Cómo puedo donar?';

  @override
  String get faqHowDoesManualGivingWork =>
      '¿Cómo puedo seleccionar el destinatario?';

  @override
  String givtNotEnough(Object value0) {
    return 'Lo sentimos, pero el importe mínimo con el que podemos trabajar es $value0.';
  }

  @override
  String get slimPayInformationPart2 =>
      'Por eso le pedimos que firme por única vez un mandato electrónico SEPA.\n \n\n Como trabajamos con mandatos, tiene la opción de revocar su donación si así lo desea.';

  @override
  String get unregister => 'Cancelar cuenta';

  @override
  String get unregisterInfo =>
      '¡Lamentamos que te vayas! Eliminaremos toda su información personal.\n \n\n Hay una excepción: si donaste a una organización registrada como PBO (Organización de Beneficio Público), estamos obligados a conservar la información sobre tu donación, tu nombre y dirección durante al menos 7 años. Tu dirección de correo electrónico y número de teléfono serán eliminados.';

  @override
  String get unregisterSad =>
      'Lamentamos que se vaya\n y esperamos volver a verle.';

  @override
  String get historyTitle => 'Historial de donaciones';

  @override
  String get historyInfoTitle => 'Detalles de la donación';

  @override
  String get historyAmountAccepted => 'En proceso';

  @override
  String get historyAmountCancelled => 'Cancelado por el usuario';

  @override
  String get historyAmountDenied => 'Rechazado por el banco';

  @override
  String get historyAmountCollected => 'Procesado';

  @override
  String get historyIsEmpty =>
      'Aquí encontrará información sobre sus donaciones, pero primero necesita empezar a donar';

  @override
  String get updateAlertTitle => 'Actualización disponible';

  @override
  String get updateAlertMessage =>
      'Hay una nueva versión de Givt disponible, ¿desea actualizar ahora?';

  @override
  String get criticalUpdateTitle => 'Actualización crítica';

  @override
  String get criticalUpdateMessage =>
      'Hay una nueva actualización crítica disponible. Es necesaria para el correcto funcionamiento de la aplicación Givt.';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get faQvraag9 => '¿Dónde puedo ver el resumen de mis donaciones?';

  @override
  String get faQantwoord9 =>
      'Pulse el menú en la parte superior izquierda de la pantalla \'Importe\' para acceder al menú de la aplicación. Para acceder, debe iniciar sesión con su dirección de correo electrónico y contraseña. Elija \'Historial de donaciones\' para encontrar un resumen de su actividad reciente. Esta lista consta del nombre del destinatario, la hora y la fecha. La línea de color indica el estado de la donación: En proceso, procesado, rechazado por el banco o cancelado por el usuario.\n Puede solicitar un resumen de sus donaciones para su declaración de impuestos al final de cada año.';

  @override
  String get faqQuestion11 => '¿Cómo configuro mi Touch ID o Face ID?';

  @override
  String get faqAnswer11 =>
      'Vaya a su configuración pulsando el menú en la parte superior izquierda de la pantalla. Allí puede proteger su aplicación Givt con una huella digital/Touch ID o un Face ID (solo disponible en ciertos iPhones). \n \n\n Cuando una de estas configuraciones está activada, puede usarla para acceder a su configuración en lugar de usar su dirección de correo electrónico y contraseña.';

  @override
  String get answerHowDoesRegistrationWork =>
      'Para usar Givt, debe registrarse en la aplicación Givt. Vaya al menú de su aplicación y elija \'Completar registro\'. Configure una cuenta Givt, complete algunos datos personales y otorgue permiso para recolectar las donaciones realizadas con la aplicación. Las transacciones son gestionadas por Better World Payments, un banco especializado en el tratamiento de permisos. Cuando su registro esté completo, estará listo para donar. Solo necesita sus datos de inicio de sesión para ver o cambiar su configuración.';

  @override
  String get answerHowDoesGivingWork =>
      'A partir de ahora, puede donar con facilidad. Abra la aplicación, elija el importe que desea donar y seleccione 1 de las 4 posibilidades: puede donar a un dispositivo de colecta, escanear un código QR, elegir de una lista o donar en su ubicación. \n No olvide completar su registro, para que sus donaciones puedan ser entregadas a la organización benéfica correcta.';

  @override
  String get answerHowDoesManualGivingWork =>
      'Cuando no pueda donar a un dispositivo de colecta, puede elegir seleccionar el destinatario manualmente. Elija un importe y pulse \'Siguiente\'. A continuación, seleccione \'Elegir de la lista\' y seleccione \'Iglesias\', \'Organizaciones benéficas\', \'Campañas\' o \'Artistas\'. Ahora elija un destinatario de una de estas listas y pulse \'Donar\'.';

  @override
  String get informationPersonalData =>
      'Givt necesita estos datos personales para procesar sus donaciones. Somos cuidadosos con esta información. Puede leerlo en nuestra declaración de privacidad.';

  @override
  String get informationAboutUs =>
      'Givt es un producto de Givt B.V.\n \n\n Estamos ubicados en Bongerd 159 en Lelystad, Países Bajos. Para preguntas o quejas puede contactarnos a través del +31 320 320 115 o support@givtapp.net.\n \n\n Estamos registrados en el registro mercantil de la Cámara de Comercio Holandesa con el número 64534421.';

  @override
  String get titleAboutGivt => 'Acerca de Givt / Contacto';

  @override
  String get readPrivacy => 'Leer la declaración de privacidad';

  @override
  String get faqQuestion12 =>
      '¿Cuánto tiempo tarda en retirarse mi donación de mi cuenta bancaria?';

  @override
  String get faqAnswer12 =>
      'Su donación se retirará de su cuenta bancaria en un plazo de dos días hábiles.';

  @override
  String get faqQuestion14 => '¿Cómo puedo donar a múltiples colectas?';

  @override
  String get faqAnswer14 =>
      '¿Hay múltiples colectas en un solo servicio? ¡Incluso entonces puede donar fácilmente de una sola vez!\n Pulsando el botón \'Añadir colecta\', puede activar hasta tres colectas. Para cada colecta, puede introducir su propio importe. Elija la colecta que desea ajustar e introduzca su importe específico o use los preestablecidos. Puede eliminar una colecta pulsando el signo menos, ubicado a la derecha del importe.\n \n\n Los números 1, 2 o 3 distinguen las diferentes colectas. No se preocupe, su iglesia sabe qué número corresponde a qué propósito de colecta. Las colectas múltiples son muy útiles, porque todas sus donaciones se envían inmediatamente con su primera donación. En el resumen puede ver un desglose de todas sus donaciones.\n \n\n ¿Quiere saltarse una colecta? Déjela abierta o elimínela.';

  @override
  String get faQvraag15 =>
      '¿Son mis donaciones de Givt deducibles de impuestos?';

  @override
  String get faQantwoord15 =>
      'Sí, sus donaciones de Givt son deducibles de impuestos, pero solo cuando dona a instituciones registradas como ANBI (Organización de Beneficio Público) o SBBI (Organización de Importancia Social). Verifique si la iglesia o institución tiene dicho registro. Dado que es bastante trabajo recopilar todas sus donaciones para su declaración de impuestos, la aplicación Givt le ofrece la opción de descargar anualmente un resumen de sus donaciones. Vaya a sus Donaciones en el menú de la aplicación para descargar el resumen. Puede usar este resumen para su declaración de impuestos. Es muy fácil.';

  @override
  String get amountPresetsChangingPresets =>
      'Puede añadir importes preestablecidos a su teclado. Aquí es donde puede habilitar y configurar los importes preestablecidos.';

  @override
  String get amountPresetsChangePresetsMenu =>
      'Cambiar importes preestablecidos';

  @override
  String get changeBankAccountNumberAndSortCode => 'Cambiar datos bancarios';

  @override
  String get updateBacsAccountDetailsError =>
      'Alas, the Sortcode or Account number is invalid. You can change the Sortcode and/or Account number under ‘Personal information’ in the menu.';

  @override
  String get ddiFailedTitle => 'Solicitud de DDI fallida';

  @override
  String get ddiFailedMessage =>
      'En este momento no es posible solicitar una Instrucción de Débito Directo. Por favor';

  @override
  String get faQantwoord5Gb =>
      'Handling transactions\n The transactions are handled by Access PaySuite; a payment institution specialised in processing BACS Direct Debit Instructions. Access PaySuite is under the supervision of the Financial Conduct Authority.\n \n\n Revertible afterwards\n The transactions take place afterwards via a direct debit under Givt Ltd. We want to emphasise that no transactions take place in the moment of giving. Since these transactions are revocable, it is completely safe and immune to fraud.';

  @override
  String get faQvraag15Gb => '¿Puedo aplicar Gift Aid a mis donaciones?';

  @override
  String get faQantwoord15Gb =>
      'Yes, you can. In the Givt app you can enable Gift Aid. You can also always see how much Gift Aid has been claimed on your donations.\n \n\n Donating through Gift Aid means charities can claim an extra 25p for every £1 you give. It will not cost you any extra.';

  @override
  String get answerHowDoesRegistrationWorkGb =>
      'To start giving, all you need is an e-mail address. Once you have entered this, you are ready to give.\n \n\n Please note: you need to fully register to ensure that all your previous and future donations can be processed. Go to the menu in the app and choose ‘Complete registration’. Here, you set up a Givt account by filling in your personal information and by us giving permission to debit the donations made in the app. Those transactions are processed by Access PaySuite, who are specialised in direct debits. \n \n\n When your registration is complete, you are ready to give with the Givt app. You only need your login details to see or change your settings.';

  @override
  String get faQantwoord7Gb =>
      ' Personal safety\n It is very important to us that everything is safe and risk free. Each user has a personal account with its own password. You need to log in to view or change your settings.\n \n\n Handling transactions\n The transactions are handled by Access PaySuite; a payment institution specialised in processing BACS Direct Debit Instructions. Access PaySuite is under the supervision of the Financial Conduct Authority.\n \n\n Immune to fraud\n When installing Givt, the user gives the app authorisation to debit their account. We want to emphasise that no transactions take place in the moment of giving. The transactions take place afterwards via a direct debit under Givt Ltd. Since these transactions are revocable, it is completely safe and immune to fraud.\n \n\n Overview\n Individual users can see an overview of their donations in the app. Organisations can log in to the Givt dashboard. This dashboard gives an overview of all financial transactions, from the moment of giving up to the full processing of the payment. In this way any collection can be followed from start to finish. Organisations can see how many people used Givt, but not who they are.';

  @override
  String get giftAidSetting => 'Quiero usar/seguir usando Gift Aid';

  @override
  String get giftAidInfo =>
      'As a UK taxpayer, you can use the Gift Aid initiative. Every year we will remind you of your choice. Activating Gift Aid after March 1st will count towards March and the next tax year. All your donations made before entering your account details will be considered eligible if they were made in the current tax year.';

  @override
  String get giftAidHeaderDisclaimer =>
      'When you enable this option, you agree to the following:';

  @override
  String get giftAidBodyDisclaimer =>
      'I am a UK taxpayer and understand that if I pay less Income Tax and/or Capital Gains Tax in the current tax year than the amount of Gift Aid claimed on all my donations, it is my responsibility to pay any difference.';

  @override
  String get giftAidInfoTitle => '¿Qué es Gift Aid?';

  @override
  String get giftAidInfoBody =>
      'Donating through Gift Aid means charities can claim an extra 25p for every £1 you give. It will not cost you any extra. \n \n\n Gift Aid treats the donations as being made after deduction of income tax at the basic rate. The charity you give to can reclaim this basic rate income tax paid on the gift from HMRC. Your donations will qualify as long as they’re not more than 4 times what you have paid in tax in that tax year. \n  \n For more info, please go to: www.gov.uk/donating-to-charity/gift-aid';

  @override
  String get faqAnswer12Gb =>
      'Your donation will be withdrawn from your bank account within five working days. The first time you make a donation with Givt, the donation will be withdrawn after two weeks, as it takes extra time to set up your registration.';

  @override
  String get faqVraagDdi =>
      '¿El Débito Directo significa que me he suscrito a deducciones mensuales?';

  @override
  String get faqAntwoordDdi =>
      'NO! You sign a direct debit so we can deduct the donations you have made using the Givt app. The deductions we make are incidental, user-driven deductions.\n \n\n We will not debit your account unless you make a donation using the Givt app.';

  @override
  String get charity => 'Organización benéfica';

  @override
  String get artist => 'Artista';

  @override
  String get church => 'Iglesia';

  @override
  String get campaign => 'Campaña';

  @override
  String giveToNearestBeacon(Object value0) {
    return 'Donar a: $value0';
  }

  @override
  String get jersey => 'Jersey';

  @override
  String get guernsey => 'Guernsey';

  @override
  String get countryStringBe => 'Bélgica';

  @override
  String get countryStringNl => 'Países Bajos';

  @override
  String get countryStringDe => 'Alemania';

  @override
  String get countryStringGb => 'Reino Unido';

  @override
  String get countryStringFr => 'Francia';

  @override
  String get countryStringIt => 'Italia';

  @override
  String get countryStringLu => 'Luxemburgo';

  @override
  String get countryStringGr => 'Grecia';

  @override
  String get countryStringPt => 'Portugal';

  @override
  String get countryStringEs => 'España';

  @override
  String get countryStringFi => 'Finlandia';

  @override
  String get countryStringAt => 'Austria';

  @override
  String get countryStringCy => 'Chipre';

  @override
  String get countryStringEe => 'Estonia';

  @override
  String get countryStringLv => 'Letonia';

  @override
  String get countryStringLt => 'Lituania';

  @override
  String get countryStringMt => 'Malta';

  @override
  String get countryStringSi => 'Eslovenia';

  @override
  String get countryStringSk => 'Eslovaquia';

  @override
  String get countryStringIe => 'Irlanda';

  @override
  String get countryStringAd => 'Andorra';

  @override
  String get informationAboutUsGb =>
      'Givt is a product of Givt LTD.\n \n\n We are located at the Blackthorn House in Birmingham, England. For questions or complaints you can reach us via 020 3790 8068 or support@givt.co.uk\n \n\n We are registered under the Company Registration Number 11396586.';

  @override
  String get authoriseBluetooth => 'Autorizar a Givt para usar Bluetooth';

  @override
  String get authoriseBluetoothErrorMessage =>
      'Dé permiso a Givt para acceder a su Bluetooth para estar listo para donar a una colecta.';

  @override
  String get authoriseBluetoothExtraText =>
      'Vaya a Ajustes > Privacidad > Bluetooth y seleccione \'Givt\'.';

  @override
  String get unregisterErrorTitle => 'Cancelación fallida';

  @override
  String get setupRecurringGiftTitle => 'Configure su donación recurrente';

  @override
  String get setupRecurringGiftText3 => 'desde';

  @override
  String get setupRecurringGiftText4 => 'hasta';

  @override
  String get setupRecurringGiftText5 => 'o';

  @override
  String get setupRecurringGiftText2 => 'a';

  @override
  String get setupRecurringGiftText1 => 'Quiero donar cada';

  @override
  String get setupRecurringGiftWeek => 'semana';

  @override
  String get setupRecurringGiftMonth => 'mes';

  @override
  String get setupRecurringGiftQuarter => 'trimestre';

  @override
  String get setupRecurringGiftYear => 'año';

  @override
  String get menuItemRecurringDonation => 'Donaciones recurrentes';

  @override
  String get setupRecurringGiftHalfYear => 'semestre';

  @override
  String get setupRecurringGiftText6 => 'veces';

  @override
  String get recurringGiftsSetupCreate => 'Programe su';

  @override
  String get recurringGiftsSetupRecurringGift => 'donación recurrente';

  @override
  String get recurringDonationYouGive => 'usted dona';

  @override
  String recurringDonationStops(Object value0) {
    return 'Esto se detendrá el $value0';
  }

  @override
  String get selectRecipient => 'Seleccionar destinatario';

  @override
  String get setupRecurringDonationFailed =>
      'La donación recurrente no se configuró correctamente. Por favor';

  @override
  String get emptyRecurringDonationList =>
      'Todas sus donaciones recurrentes serán visibles aquí.';

  @override
  String cancelRecurringDonationAlertTitle(Object value0) {
    return '¿Está seguro de que quiere dejar de donar a $value0?';
  }

  @override
  String get cancelRecurringDonationAlertMessage =>
      'Las donaciones ya realizadas no serán canceladas.';

  @override
  String get cancelRecurringDonation => 'Detener';

  @override
  String get setupRecurringGiftText7 => 'Cada';

  @override
  String get cancelRecurringDonationFailed =>
      'La donación recurrente no se canceló correctamente. Por favor';

  @override
  String get reportMissingOrganisationListItem =>
      'Informar sobre una organización que falta';

  @override
  String get reportMissingOrganisationPrefilledText =>
      '¡Hola! Me gustaría mucho donar a:';

  @override
  String get setupRecurringDonationFailedDuplicate =>
      'La donación recurrente no se configuró correctamente. Ya ha realizado una donación a esta organización con el mismo período de repetición.';

  @override
  String get setupRecurringDonationFailedDuplicateTitle => 'Donación duplicada';

  @override
  String get goToListWithRecurringDonationDonations => 'Resumen';

  @override
  String get recurringDonationFutureDetailSameYear => 'Próxima donación';

  @override
  String get discoverSearchButton => 'Buscar';

  @override
  String get discoverDiscoverButton => 'Ver todo';

  @override
  String get discoverSegmentNow => 'Donar';

  @override
  String get discoverSegmentWho => 'Descubrir';

  @override
  String get discoverHomeDiscoverTitle => 'Elegir categoría';

  @override
  String get discoverOrAmountActionSheetOnce => 'Donación única';

  @override
  String get discoverOrAmountActionSheetRecurring => 'Donación recurrente';

  @override
  String reccurringGivtIsBeingProcessed(Object value0) {
    return 'Thank you for your recurring donation to $value0!\n To see all the information, go to \'Recurring donations\' in the menu.';
  }

  @override
  String get amountLimitExceededRecurringDonation =>
      'Este importe es superior al importe máximo elegido. ¿Desea continuar o cambiar el importe?';

  @override
  String get sepaVerifyBody =>
      'If any of the above is incorrect, please abort the registration and change your \'Personal information\'';

  @override
  String get signMandate => 'Firmar mandato';

  @override
  String get signMandateDisclaimer =>
      'By continuing you sign the eMandate with above details.\n The mandate will be sent to you via mail.';

  @override
  String get budgetSummaryBalance => 'Mis donaciones este mes';

  @override
  String get budgetSummarySetGoal =>
      'Establezca un objetivo de donación para motivarse.';

  @override
  String get budgetSummaryGiveNow => '¡Donar ahora!';

  @override
  String get budgetSummaryGivt => 'Donado dentro de Givt';

  @override
  String get budgetSummaryNotGivt => 'Donado fuera de Givt';

  @override
  String get budgetSummaryShowAll => 'Mostrar todo';

  @override
  String get budgetSummaryMonth => 'Mensual';

  @override
  String get budgetSummaryYear => 'Anual';

  @override
  String get budgetExternalGiftsTitle => 'Donaciones fuera de Givt';

  @override
  String get budgetExternalGiftsInfo =>
      'Obtenga una visión completa de todas sus contribuciones. Añada cualquier contribución que haya realizado fuera de Givt. Encontrará todo en su resumen.';

  @override
  String get budgetExternalGiftsSubTitle => 'Sus donaciones fuera de Givt';

  @override
  String get budgetExternalGiftsOrg => 'Nombre de la organización';

  @override
  String get budgetExternalGiftsTime => 'Frecuencia';

  @override
  String get budgetExternalGiftsAmount => 'Importe';

  @override
  String get budgetExternalGiftsSave => 'Guardar';

  @override
  String get budgetGivingGoalTitle => 'Configurar objetivo de donación';

  @override
  String get budgetGivingGoalInfo =>
      'Done conscientemente. Considere cada mes si su comportamiento de donación coincide con sus objetivos personales de donación.';

  @override
  String get budgetGivingGoalMine => 'Mi objetivo de donación';

  @override
  String get budgetGivingGoalTime => 'Período';

  @override
  String get budgetSummaryGivingGoalMonth => 'Objetivo de donación mensual';

  @override
  String get budgetSummaryGivingGoalEdit => 'Editar objetivo de donación';

  @override
  String get budgetSummaryGivingGoalRest => 'Objetivo de donación restante';

  @override
  String get budgetMenuView => 'Mi resumen personal';

  @override
  String get budgetSummarySetGoalBold => 'Done conscientemente';

  @override
  String get budgetExternalGiftsInfoBold =>
      'Obtenga información sobre lo que dona';

  @override
  String get budgetGivingGoalInfoBold => 'Establecer objetivo de donación';

  @override
  String get budgetGivingGoalRemove => 'Eliminar objetivo de donación';

  @override
  String get budgetSummaryNoGifts => 'No tiene donaciones (aún) este mes';

  @override
  String get budgetTestimonialSummary =>
      '”Since I’ve been using the summary, I have gained more insight into what I give. I give more consciously because of it.\"';

  @override
  String get budgetTestimonialGivingGoal =>
      '”My giving goal motivates me to regularly reflect on my giving behaviour.”';

  @override
  String get budgetTestimonialExternalGifts =>
      '\"I like that I can add any external donations to my summary. I can now simply keep track of my giving.\"';

  @override
  String get budgetTestimonialYearlyOverview =>
      '\"Givt\'s annual overview is great! I\'ve also added all my donations outside Givt. This way I have all my giving in one overview, which is essential for my tax return.\"';

  @override
  String get budgetPushMonthly => 'Vea lo que ha donado este mes.';

  @override
  String get budgetTooltipYearly =>
      '¿Un resumen para la declaración de impuestos? Vea el resumen de todas sus donaciones aquí.';

  @override
  String get budgetPushMonthlyBold => 'Su resumen mensual está listo.';

  @override
  String get budgetExternalGiftsListAddEditButton =>
      'Gestionar donaciones externas';

  @override
  String get budgetExternalGiftsFrequencyOnce => 'Una vez';

  @override
  String get budgetExternalGiftsFrequencyMonthly => 'Cada mes';

  @override
  String get budgetExternalGiftsFrequencyQuarterly => 'Cada 3 meses';

  @override
  String get budgetExternalGiftsFrequencyHalfYearly => 'Cada 6 meses';

  @override
  String get budgetExternalGiftsFrequencyYearly => 'Cada año';

  @override
  String get budgetExternalGiftsEdit => 'Editar';

  @override
  String get budgetTestimonialSummaryName => 'Guillermo:';

  @override
  String get budgetTestimonialGivingGoalName => 'Daniela:';

  @override
  String get budgetTestimonialExternalGiftsName => 'Johnson:';

  @override
  String get budgetTestimonialSummaryAction => 'Ver su resumen';

  @override
  String get budgetTestimonialGivingGoalAction =>
      'Configure su objetivo de donación';

  @override
  String get budgetTestimonialExternalGiftsAction =>
      'Añadir donaciones externas';

  @override
  String get budgetSummaryGivingGoalReached => 'Objetivo de donación alcanzado';

  @override
  String get budgetSummaryNoGiftsExternal =>
      '¿Donaciones fuera de Givt este mes? Añádalas aquí';

  @override
  String get budgetYearlyOverviewGivenThroughGivt => 'Total dentro de Givt';

  @override
  String get budgetYearlyOverviewGivenThroughNotGivt => 'Total fuera de Givt';

  @override
  String get budgetYearlyOverviewGivenTotal => 'Total';

  @override
  String get budgetYearlyOverviewGivenTotalTax => 'Desgravación fiscal total';

  @override
  String get budgetYearlyOverviewDetailThroughGivt => 'Dentro de Givt';

  @override
  String get budgetYearlyOverviewDetailAmount => 'Importe';

  @override
  String get budgetYearlyOverviewDetailDeductable => 'Desgravación fiscal';

  @override
  String get budgetYearlyOverviewDetailTotal => 'Total';

  @override
  String get budgetYearlyOverviewDetailTotalDeductable =>
      'Desgravación fiscal total';

  @override
  String get budgetYearlyOverviewDetailNotThroughGivt => 'Fuera de Givt';

  @override
  String get budgetYearlyOverviewDetailTotalThroughGivt => '(dentro de Givt)';

  @override
  String get budgetYearlyOverviewDetailTotalNotThroughGivt => '(fuera de Givt)';

  @override
  String get budgetYearlyOverviewDetailTipBold =>
      'CONSEJO: añada sus donaciones externas';

  @override
  String get budgetYearlyOverviewDetailTipNormal =>
      'to get a total overview of what you give, both via the Givt app and not via the Givt app.';

  @override
  String get budgetYearlyOverviewDetailReceiveViaMail =>
      'Recibir por correo electrónico';

  @override
  String get budgetYearlyOverviewDownloadButton => 'Descargar resumen anual';

  @override
  String get budgetExternalDonationsTaxDeductableSwitch =>
      'Desgravación fiscal';

  @override
  String get budgetYearlyOverviewGivingGoalPerYear =>
      'Objetivo de donación anual';

  @override
  String get budgetYearlyOverviewGivenIn => 'Donado en';

  @override
  String get budgetYearlyOverviewRelativeTo => 'Relativo al total en';

  @override
  String get budgetYearlyOverviewVersus => 'Contra';

  @override
  String get budgetYearlyOverviewPerOrganisation => 'Por organización';

  @override
  String get budgetSummaryNoGiftsYearlyOverview =>
      'No tiene donaciones (aún) este año';

  @override
  String budgetPushYearlyNearlyEndBold(Object value0) {
    return '$value0 casi ha terminado... ¿Ya ha hecho su balance?';
  }

  @override
  String get budgetPushYearlyNearlyEnd =>
      'Vea su resumen anual y lo que ha donado hasta ahora.';

  @override
  String get budgetTestimonialYearlyOverviewAction => 'Ir al resumen';

  @override
  String get duplicateAccountOrganisationMessage =>
      'Are you sure you are using your own bank details? Could you please check in the menu, under \'Personal information\'? You can change the information there as well, if necessary.';

  @override
  String get policyTextUs =>
      '1. Givt App – US Privacy Policy\nLatest Amendment: [01-03-2025]\nVersion [1.2]\nGivt Inc. Privacy Policy\n\nIntroduction\nThis Privacy Policy outlines Givt Inc.’s (“we,” “our,” or “the Company”) practices with respect to information collected from our Application\n\nGrounds for data collection\nProcessing of your personal information (meaning, any information relating to an identified or identifiable individual; hereinafter “Personal\nInformation”)  is necessary for the performance of our contractual obligations towards you and providing you with our services, to protect\nour legitimate interests and for compliance with legal and financial regulatory obligations to which we are subject.\nWhen you use our App or register yourself or an organization you represent with us, you consent to the collection, storage, use, disclosure and other uses of your Personal Information as described in this Privacy Policy.\nWe encourage our Users to carefully read the Privacy Policy and use it to make informed decisions.\nWhat information do we collect?\nWe collect two types of data and information from Users. The first type of information is un-identified and non-identifiable information pertaining to a User(s), which may be made available or gathered via your use of the App (“Non-personal Information”). We are not aware of the identity of a User from which the Non-personal Information was collected. Non-personal Information which is being collected may include your aggregated usage information and technical information transmitted by your device, including certain software and\nhardware information (e.g. language preference, access time, etc.) in order to enhance the functionality of our App.\nThe second type of information is Personal Information, which is personally identifiable information, namely information that identifies an\nindividual or may with reasonable effort identify an individual. Such information includes:\n\nDevice Information: We collect Personal Information from your device. Such information includes geolocation data, IP address, unique identifiers (e.g. MAC address and UUID) and other information which relates to your activity through the App.\n\nService User Information: We collect additional information for individuals who would like to use our Services. This is gathered\nthrough the App and includes all the information needed to register for our service:\n– Name and address,\n– Date of birth,\n– email address,\n– secured password details, and\n– bank details for the purposes of making payments.\n\n\nContact information: If you choose to contact us you will be asked to provide us with certain details such as: full name; e-mail or physical address, and other relevant information. This may be for yourself or for people in the organization you represent.\n\n\nHow do we receive information about you?\n\nWe receive your Personal Information from various sources:\n\n● When you voluntarily provide us with your personal details in order to register on our App;\n\n● When you use or access our App in connection with your use of our services;\nWhen you use or access our Dashboard in connection with your organization’s use of our services;\n\n● From third party providers, services and public registers (for example, traffic analytics vendors); and,\n\n● Through diagnostic information from the App. The App will send us anonymous information about its functioning. This information contains non-personal data from your smartphone like its type and operating system, but also the version information of the App. This data is solely used for purposes of improving our Service or allowing better responses to your questions.\n\n\nWhat do we do with the information we collect?\n\n\nWe may use the information for the following:\n● To provide the services through the App – we will use a minimum of name and bank details to perform the services of effecting payment(s) via the App. Payment information is never shared with intended recipients of donations;\n● Communicating with you – sending you notices regarding our services, providing you with technical information and responding to\nany customer service issue you may have; to keep you informed of our latest updates and services;\n● Conducting statistical and analytical activities, intended to improve the App and/or the App.\n● For marketing and advertising purposes, such as developing and providing promotional and advertising materials that may be relevant,\nvaluable or otherwise of interest to you.\nIn addition to the different uses listed above, we may transfer or disclose Personal Information to our subsidiaries, affiliated companies and subcontractors in relation to services that we provide to you. We may also disclose information if we have good faith to believe that\ndisclosure of such information is helpful or reasonably necessary to: (i) comply with any applicable law, regulation, legal process or governmental request; (ii) enforce our policies (including our Agreement), including investigations of potential violations thereof; (iii) investigate, detect, prevent, or take action regarding illegal activities or other wrongdoing, suspected fraud or security issues; (iv) to establish or exercise our rights to defend against legal claims; (v) prevent harm to the rights, property or safety of us, our users, yourself or any third party; or (vi) for the purpose of collaborating with law enforcement agencies and/or in case we find it necessary in order to enforce intellectual property or other legal rights.\n\n\nProviding Data to Third Parties When you make a donation, personal information about you, your name, the amount, campaign and email address is shared with the intended recipient of your donation. In some cases, you may have the option to remain anonymous. If you choose to remain anonymous, your personal information will not be shared with the intended recipient of your donation.\nWhen you make a donation, personal information about you, your name, the amount, campaign and email address is shared with the intended recipient of your donation. In some cases, you may have the option to remain anonymous. If you choose to remain anonymous, your personal information will not be shared with the intended recipient of your donation.\n\n\nWe may provide your information to our partners. For example, we may share any information we receive with vendors and service providers retained in connection with the provision of the App. If you use the App to make a donation, your payment-related information, such as credit card or other financial information, is collected by our third-party payment processor on our behalf. In all cases, these parties are necessary to provide the services.\nWe may collect, use, and share anonymous data for statistical purposes, reviews, and comparisons; no such data will be traceable to individuals.\nWe are committed to making it easier for donors to give to charities of their choosing, and we will never sell data to third parties.\nWe may access, preserve, and disclose your information if we believe doing so is required or appropriate to: (a) comply with law enforcement requests and legal process, such as a court order or subpoena; (b) respond to your requests; or (c) protect your, our, or others’ rights, property, or safety.\nWe may transfer your information to service providers, advisors, potential transactional partners, or other third parties in connection with the consideration, negotiation, or completion of a corporate transaction in which we are acquired by or merged with another company or we sell, liquidate, or transfer all or a portion of our assets. The use of your information following any of these events will be governed by the provisions of this Privacy Policy in effect at the time the applicable information was collected.\nWe may also disclose your information with your permission.\n\n\nInformation from Cookies and Other Tracking Technologies. \nWe and our third-party partners collect information about your activities on our Application using cookies, pixel tags, SDKs, or other tracking technologies. Our third-party partners, such as analytics, authentication, and security partners, may also use these technologies to collect information about your online activities over time and across different services.\n\n\nAnalytics Partners. We use analytics services such as Google Analytics to collect and process certain analytics data. [You can learn more about Google’s practices by visiting https://www.google.com/policies/privacy/partners/.]\n\n\nCollection of Audio Data. \n\nIn order to create recorded messages for family members, our App collects audio data if you explicitly enable the App to have access to your device’s microphone via your device’s operating system settings. This feature is designed to enhance user experience by allowing personalized messages to be shared through our services. Audio data is only used for the purpose of delivering the recorded message. Audio recording occurs solely during the active use of this feature. Audio recordings are not shared with third parties unless explicitly required for service delivery or mandated by law. You can disable microphone access at any time through your device settings, which may limit your ability to use this feature.\n\nUser Rights\nYou may request to:\n1.Receive confirmation as to whether or not personal information concerning you is being processed, and access your stored personal information, together with supplementary information.\n2.Receive a copy of personal information you directly volunteer to us in a structured, commonly used and machine-readable format.\n3.Request rectification of your personal information that is in our control.\n4.Request erasure of your personal information.\n5.Object to the processing of personal information by us.\n6.Request portability of your personal information.\n7.Request to restrict processing of your personal information by us.\n8.Lodge a complaint with a supervisory authority.\n\nHowever, please note that these rights are not absolute, and may be subject to our own legitimate interests and regulatory requirements.\nBefore fulfilling your request, we may ask you to provide reasonable information to verify your identity.\n\nRetention\nWe will retain your personal information for as long as necessary to provide our services, and as necessary to comply with our legal\nobligations, resolve disputes, and enforce our policies. Retention periods will be determined taking into account the type of information that is collected and the purpose for which it is collected, bearing in mind the requirements applicable to the situation and the need to destroy outdated, unused information at the earliest reasonable time. Under applicable regulations, we will keep records containing client personal data, account opening documents, communications and anything else as required by applicable laws and regulations.\nWe may rectify, replenish or remove incomplete or inaccurate information, at any time and at our own discretion.\n\nUse of Location Services\nThe App may use the location services as provided by the operating system on the smartphone. With these services, the App may determine the location of the user. The location data will not be sent anywhere outside the smartphone, and is solely used to determine whether the user is in a location where it’s possible to use the App for donating. The locations where one can use App are downloaded to the smartphone prior to using the location services.\n\nHow do we safeguard your information?\nWe take security measures to reduce misuse of and unauthorized access to personal data. Although we take reasonable steps to safeguard information, we cannot be responsible for the acts of those who gain unauthorized access or abuse our App, and we make no warranty, express, implied or otherwise, that we will prevent such access.\n\nTransfer of data outside the EEA\nPlease note that some data recipients may be located outside the EEA. In such cases we will transfer your data only to such countries as approved by the European Commission as providing adequate level of data protection, or enter into legal agreements ensuring an adequate level of data protection. Data collected from Users located in the United States is stored in the United States.\n\nAdvertisements\nWe do not use third-party advertising technology to serve advertisements when you access the App.\n\nMarketing\nWe may use your Personal Information, such as your name, email address to send you a Newsletter about our products and services. You may opt out of receiving this Newsletter at any time by unsubscribing via the link in the newsletter.\nThird Parties\nThe App may contain links to other websites, products, or services that we do not own or operate. We are not responsible for the privacy\npractices of these third parties. Please be aware that this Privacy Policy does not apply to your activities on these third-party services or any information you disclose to these third parties. We encourage you to read their privacy policies before providing any information to them.\n\nUpdates or amendments to this Privacy Policy\nWe reserve the right to periodically amend or revise the Privacy Policy; material changes will be effective immediately upon the display of the revised Privacy policy. The last revision will be reflected in the “Last modified” section. If we materially change the ways in which we use or share personal information collected from you, we will notify you through the App, by email, or other communication. Your continued use of our Services following the notification of such amendments on our Website or through the App, constitutes your acknowledgment and consent of such amendments to the Privacy Policy and your agreement to be bound by the terms of such amendments.\n\nHow to contact us\nIf you have any general questions about the App or the information we collect about you and how we use it, you can contact us at:\nsupport@givt.app or by phone at 918-615-9611.\n';

  @override
  String get termsTextUs =>
      'GIVT INC.\n Terms of Use for Giving with Givt \n Last updated: July 13th, 2022\n Version: 1.2\n These terms of use describe the conditions under which you can use the services made available through the mobile or other downloadable application and website owned by Givt, Inc. (\"Givt\", and \"Service\" respectively) can be utilized by you, the User (\"you\"). These Terms of Use are a legally binding contract between you and Givt regarding your use of the Service.\n BY DOWNLOADING, INSTALLING, OR OTHERWISE ACCESSING OR USING THE SERVICE, YOU AGREE THAT YOU HAVE READ AND UNDERSTOOD, AND, AS A CONDITION TO YOUR USE OF THE SERVICE, YOU AGREE TO BE BOUND BY, THE FOLLOWING TERMS AND CONDITIONS, INCLUDING GIVT\'S PRIVACY POLICY (https://www.givt.app/privacy-policy) (TOGETHER, THESE \"TERMS\"). If you are not eligible, or do not agree to the Terms, then you do not have our permission to use the Service. YOUR USE OF THE SERVICE, AND GIVT\'S PROVISION OF THE SERVICE TO YOU, CONSTITUTES AN AGREEMENT BY GIVT AND BY YOU TO BE BOUND BY THESE TERMS.\n Arbitration NOTICE. Except for certain kinds of disputes described in Section 12, you agree that disputes arising under these Terms will be resolved by binding, individual arbitration, and BY ACCEPTING THESE TERMS, YOU AND GIVT ARE EACH WAIVING THE RIGHT TO A TRIAL BY JURY OR TO PARTICIPATE IN ANY CLASS ACTION OR REPRESENTATIVE PROCEEDING.\n 1. Givt Service Overview. Givt provides its users with a platform to make anonymous donations to any of the entities properly registered with Givt as a recipient of donations (\"Recipient\"). The Service is available for users through their smartphones, and other electronic device. \n 2. Eligibility. You must be at least 18 years old to use the Service. By agreeing to these Terms, you represent and warrant to us that: (a) you are at least 18 years old; (b) you have not previously been suspended or removed from the Service; and (c) your registration and your use of the Service is in compliance with any and all applicable laws and regulations. If you are an entity, organization, or company, the individual accepting these Terms on your behalf represents and warrants that they have authority to bind you to these Terms and you agree to be bound by these Terms. \n 3. Accounts and Registration. To access the Service, you must register for an account. When you register for an account, you may be required to provide us with some information about yourself, such as your (i) name (ii) address, (iii) phone number, and (iv) e-mail address. You agree that the information you provide to us is accurate, complete, and not misleading, and that you will keep it accurate and up to date at all times. When you register, you will be asked to create a password. You are solely responsible for maintaining the confidentiality of your account and password, and you accept responsibility for all activities that occur under your account. If you believe that your account is no longer secure, then you should immediately notify us at support@givt.app.\n 4. Processing Donations\n 4.1. Givt does not provide banking or payment services. To facilitate the processing and transfer of donations from you to Recipients, Givt has entered into an agreement with a third party payment processor (the \"Processor\"). The amount of your donation that is actually received by a Recipient will be net of fees and other charges imposed by Givt and Processor.\n 4.2. The transaction data, including the applicable designated Recipient, will be processed by Givt and forwarded to the Processor. The Processor will, subject to the Processor\'s online terms and conditions, initiate payment transactions to the bank account of the applicable designated Recipient. For the full terms of the transfer of donations, including chargeback, reversals, fees and charges, and limitations on the amount of a donation please see Processor\'s online terms and conditions.\n 4.3. You agree that Givt may pass your transaction and bank data to the Processor, along with all other necessary account and personal information, in order to enable the Processor to initiate the transfer of donations from you to Recipients. Givt reserves the right to change of Processor at any time. You agree that Givt may forward relevant information and data as set forth in this Section 4.3 to the new Processor in order to continue the processing and transfer of donations from you to Recipients.\n 5. License and intellectual property rights\n 5.1. Limited License. Subject to your complete and ongoing compliance with these Terms, Givt grants you a non-exclusive, non-sublicensable and non-transmittable license to (a) install and use one object code copy of any mobile or other downloadable application associated with the Service (whether installed by you or pre-installed on your mobile device manufacturer or a wireless telephone provider) on a mobile device that you own or control; (b) access and use the Service. You are not allowed to use the Service for commercial purposes.\n 5.2. License Restrictions. Except and solely to the extent such a restriction is impermissible under applicable law, you may not: (a) provide the Service to third parties; (b) reproduce, distribute, publicly display, publicly perform, or create derivative works for the Service; (c) decompile, submit to reverse engineer or modify the Service; (d), remove or bypass the technical provisions that are intended to protect the Service and/or Givt. If you are prohibited under applicable law from using the Service, then you may not use it. \n 5.3. Ownership; Proprietary Rights. The Service is owned and operated by Givt. The visual interfaces, graphics, design, compilation, information, data, computer code (including source code or object code), products, software, services, and all other elements of the Service provided by Givt (\"Materials\") are protected by intellectual property and other laws. All Materials included in the Service are the property of Givt or its third-party licensors. Except as expressly authorized by Givt, you may not make use of the Materials. There are no implied licenses in these Terms and Givt reserves all rights to the Materials not granted expressly in these Terms.\n 5.4. Feedback. We respect and appreciate the thoughts and comments from our users. If you choose to provide input and suggestions regarding existing functionalities, problems with or proposed modifications or improvements to the Service (\"Feedback\"), then you hereby grant Givt an unrestricted, perpetual, irrevocable, non-exclusive, fully paid, royalty-free right and license to exploit the Feedback in any manner and for any purpose, including to improve the Service and create other products and services. We will have no obligation to provide you with attribution for any Feedback you provide to us.\n 6. Third-Party Software. The Service may include or incorporate third-party software components that are generally available free of charge under licenses granting recipients broad rights to copy, modify, and distribute those components (\"Third-Party Components\"). Although the Service is provided to you subject to these Terms, nothing in these Terms prevents, restricts, or is intended to prevent or restrict you from obtaining Third-Party Components under the applicable third-party licenses or to limit your use of Third-Party Components under those third-party licenses.\n 7. Prohibited Conduct. BY USING THE SERVICE, YOU AGREE NOT TO:\n 7.1. use the Service for any illegal purpose or in violation of any local, state, national, or international law;\n 7.2. violate, encourage others to violate, or provide instructions on how to violate, any right of a third party, including by infringing or misappropriating any third-party intellectual property right;\n 7.3. interfere with security-related features of the Service, including by: (i) disabling or circumventing features that prevent or limit use, printing or copying of any content; or (ii) reverse engineering or otherwise attempting to discover the source code of any portion of the Service except to the extent that the activity is expressly permitted by applicable law;\n 7.4. interfere with the operation of the Service or any user\'s enjoyment of the Service, including by: (i) uploading or otherwise disseminating any virus, adware, spyware, worm, or other malicious code; (ii) making any unsolicited offer or advertisement to another user of the Service; (iii) collecting personal information about another user or third party without consent; or (iv) interfering with or disrupting any network, equipment, or server connected to or used to provide the Service;\n 7.5. perform any fraudulent activity including impersonating any person or entity, claiming a false affiliation or identity, accessing any other Service account without permission, or falsifying your age or date of birth;\n 7.6. sell or otherwise transfer the access granted under these Terms or any Materials or any right or ability to view, access, or use any Materials; or\n 7.7. attempt to do any of the acts described in this Section 7 or assist or permit any person in engaging in any of the acts described in this Section 7.\n 8. Term, Termination, and Modification of the Service\n 8.1. Term. These Terms are effective beginning when you accept the Terms or first download, install, access, or use the Service, and ending when terminated as described in Section 8.2.\n 8.2. Termination. If you violate any provision of these Terms, then your authorization to access the Service and these Terms automatically terminate. These Terms will end by operation of law in the event you are declared bankrupt, you apply for a moratorium on payments or a general attachment is levied against your assets, in the event of your death, or in the event you go into liquidation, are wound up or dissolved. Following the termination of these Terms (for whatever reason), you shall cease and desist from all further use of Givt. You must then delete all copies (including back-up copies) of Givt from all your systems.\n 8.3. In addition, Givt may, at its sole discretion, terminate these Terms or your account on the Service, or suspend or terminate your access to the Service, at any time for any reason or no reason, with or without notice, and without any liability to you arising from such termination. You may terminate your account and these Terms at any time by deleting or uninstalling the Service, or as otherwise indicated within the Service, or by contacting customer service at support@givt.app. In the event your smartphone, or other electronic device on which the Services are installed, is lost or stolen, inform Givt immediately by contacting support@givt.app. Upon receipt of a message Givt will use commercially reasonable efforts to block the account to prevent further misuse.\n 8.4. Effect of Termination. Upon termination of these Terms: (a) your license rights will terminate and you must immediately cease all use of the Service; (b) you will no longer be authorized to access your account or the Service. If your account has been terminated for a breach of these Terms, then you are prohibited from creating a new account on the Service using a different name, email address or other forms of account verification.\n 8.5. Modification of the Service. Givt reserves the right to modify or discontinue all or any portion of the Service at any time (including by limiting or discontinuing certain features of the Service), temporarily or permanently, without notice to you. Givt will have no liability for any change to the Service, or any suspension or termination of your access to or use of the Service. \n 9. Indemnity. To the fullest extent permitted by law, you are responsible for your use of the Service, and you will defend and indemnify Givt, its affiliates and their respective shareholders, directors, managers, members, officers, employees, consultants, and agents (together, the \"Givt Entities\") from and against every claim brought by a third party, and any related liability, damage, loss, and expense, including attorneys\' fees and costs, arising out of or connected with: (1) your unauthorized use of, or misuse of, the Service; (2) your violation of any portion of these Terms, any representation, warranty, or agreement referenced in these Terms, or any applicable law or regulation; (3) your violation of any third-party right, including any intellectual property right or publicity, confidentiality, other property, or privacy right; or (4) any dispute or issue between you and any third party. We reserve the right, at our own expense, to assume the exclusive defense and control of any matter otherwise subject to indemnification by you (without limiting your indemnification obligations with respect to that matter), and in that case, you agree to cooperate with our defense of those claims.\n 10. Disclaimers; No Warranties.\n THE SERVICE AND ALL MATERIALS AND CONTENT AVAILABLE THROUGH THE SERVICE ARE PROVIDED \"AS IS\" AND ON AN \"AS AVAILABLE\" BASIS. GIVT DISCLAIMS ALL WARRANTIES OF ANY KIND, WHETHER EXPRESS OR IMPLIED, RELATING TO THE SERVICE AND ALL MATERIALS AND CONTENT AVAILABLE THROUGH THE SERVICE, INCLUDING: (A) ANY IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, QUIET ENJOYMENT, OR NON-INFRINGEMENT; AND (B) ANY WARRANTY ARISING OUT OF COURSE OF DEALING, USAGE, OR TRADE. GIVT DOES NOT WARRANT THAT THE SERVICE OR ANY PORTION OF THE SERVICE, OR ANY MATERIALS OR CONTENT OFFERED THROUGH THE SERVICE, WILL BE UNINTERRUPTED, SECURE, OR FREE OF ERRORS, VIRUSES, OR OTHER HARMFUL COMPONENTS, AND GIVT DOES NOT WARRANT THAT ANY OF THOSE ISSUES WILL BE CORRECTED.\n NO ADVICE OR INFORMATION, WHETHER ORAL OR WRITTEN, OBTAINED BY YOU FROM THE SERVICE OR GIVT ENTITIES OR ANY MATERIALS OR CONTENT AVAILABLE THROUGH THE SERVICE WILL CREATE ANY WARRANTY REGARDING ANY OF THE GIVT ENTITIES OR THE SERVICE THAT IS NOT EXPRESSLY STATED IN THESE TERMS. WE ARE NOT RESPONSIBLE FOR ANY DAMAGE THAT MAY RESULT FROM THE SERVICE AND YOUR DEALING WITH ANY OTHER SERVICE USER. WE DO NOT GUARANTEE THE STATUS OF ANY ORGANIZATION, INCLUDING WHETHER AN ORGANIZATION IS A NOT-FOR-PROFIT, CHARITABLE, OR OTHER SIMILAR ORGANIZATION UNDER APPLICABLE LAWS, AND WE DO NOT MAKE ANY REPRESENTATIONS REGARDING THE TAX TREATMENT OF ANY DONATIONS, GIFTS, OR OTHER MONEYS TRANSFERRED OR OTHERWISE PROVIDED TO ANY SUCH ORGANIZATION. YOU ARE SOLELY RESPONSIBLE FOR DETERMINING WHETHER AN ORGANIZATION QUALIFIES AS A NOT-FOR-PROFIT, CHARITABLE, OR OTHER SIMILAR ORGANIZATION UNDER APPLICABLE LAWS AND TO UNDERSTAND THE TAX TREATMENT OF ANY DONATIONS, GIFTS OR OTHER MONEYS TRANSFERRED OR PROVIDED TO SUCH ORGANIZATIONS. YOU UNDERSTAND AND AGREE THAT YOU USE ANY PORTION OF THE SERVICE AT YOUR OWN DISCRETION AND RISK, AND THAT WE ARE NOT RESPONSIBLE FOR ANY DAMAGE TO YOUR PROPERTY (INCLUDING YOUR COMPUTER SYSTEM OR MOBILE DEVICE USED IN CONNECTION WITH THE SERVICE) OR ANY LOSS OF DATA, INCLUDING USER CONTENT.\n THE LIMITATIONS, EXCLUSIONS AND DISCLAIMERS IN THIS SECTION APPLY TO THE FULLEST EXTENT PERMITTED BY LAW. Givt does not disclaim any warranty or other right that Givt is prohibited from disclaiming under applicable law.\n 11. Liability\n 11.1. TO THE FULLEST EXTENT PERMITTED BY LAW, IN NO EVENT WILL THE GIVT ENTITIES BE LIABLE TO YOU FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL OR PUNITIVE DAMAGES (INCLUDING DAMAGES FOR LOSS OF PROFITS, GOODWILL, OR ANY OTHER INTANGIBLE LOSS) ARISING OUT OF OR RELATING TO YOUR ACCESS TO OR USE OF, OR YOUR INABILITY TO ACCESS OR USE, THE SERVICE OR ANY MATERIALS OR CONTENT ON THE SERVICE, WHETHER BASED ON WARRANTY, CONTRACT, TORT (INCLUDING NEGLIGENCE), STATUTE, OR ANY OTHER LEGAL THEORY, AND WHETHER OR NOT ANY GIVT ENTITY HAS BEEN INFORMED OF THE POSSIBILITY OF DAMAGE.\n 11.2. EXCEPT AS PROVIDED IN SECTIONS 11.2 AND 11.3 AND TO THE FULLEST EXTENT PERMITTED BY LAW, THE AGGREGATE LIABILITY OF THE GIVT ENTITIES TO YOU FOR ALL CLAIMS ARISING OUT OF OR RELATING TO THE USE OF OR ANY INABILITY TO USE ANY PORTION OF THE SERVICE OR OTHERWISE UNDER THESE TERMS, WHETHER IN CONTRACT, TORT, OR OTHERWISE, IS LIMITED TO US\$100.\n 11.3. EACH PROVISION OF THESE TERMS THAT PROVIDES FOR A LIMITATION OF LIABILITY, DISCLAIMER OF WARRANTIES, OR EXCLUSION OF DAMAGES IS INTENDED TO AND DOES ALLOCATE THE RISKS BETWEEN THE PARTIES UNDER THESE TERMS. THIS ALLOCATION IS AN ESSENTIAL ELEMENT OF THE BASIS OF THE BARGAIN BETWEEN THE PARTIES. EACH OF THESE PROVISIONS IS SEVERABLE AND INDEPENDENT OF ALL OTHER PROVISIONS OF THESE TERMS. THE LIMITATIONS IN THIS SECTION 11 WILL APPLY EVEN IF ANY LIMITED REMEDY FAILS OF ITS ESSENTIAL PURPOSE.\n 12. Dispute Resolution and Arbitration\n 12.1. Generally. Except as described in Section 12.2 and 12.3, you and Givt agree that every dispute arising in connection with these Terms, the Service, or communications from us will be resolved through binding arbitration. Arbitration uses a neutral arbitrator instead of a judge or jury, is less formal than a court proceeding, may allow for more limited discovery than in court, and is subject to very limited review by courts. This agreement to arbitrate disputes includes all claims whether based in contract, tort, statute, fraud, misrepresentation, or any other legal theory, and regardless of whether a claim arises during or after the termination of these Terms. Any dispute relating to the interpretation, applicability, or enforceability of this binding arbitration agreement will be resolved by the arbitrator.\n YOU UNDERSTAND AND AGREE THAT, BY ENTERING INTO THESE TERMS, YOU AND GIVT ARE EACH WAIVING THE RIGHT TO A TRIAL BY JURY OR TO PARTICIPATE IN A CLASS ACTION.\n 12.2. Exceptions. Although we are agreeing to arbitrate most disputes between us, nothing in these Terms will be deemed to waive, preclude, or otherwise limit the right of either party to: (a) bring an individual action in small claims court; (b) pursue an enforcement action through the applicable federal, state, or local agency if that action is available; (c) seek injunctive relief in a court of law in aid of arbitration; or (d) to file suit in a court of law to address an intellectual property infringement claim.\n 12.3. Opt-Out. If you do not wish to resolve disputes by binding arbitration, you may opt out of the provisions of this Section 12 within 30 days after the date that you agree to these Terms by sending an e-mail to Givt Inc. at support@givt.app, with the following subject line: \"Legal Department – Arbitration Opt-Out\", that specifies: your full legal name, the email address associated with your account on the Service, and a statement that you wish to opt out of arbitration (\"Opt-Out Notice\"). Once Givt receives your Opt-Out Notice, this Section 12 will be void and any action arising out of these Terms will be resolved as set forth in Section 12.2. The remaining provisions of these Terms will not be affected by your Opt-Out Notice.\n 12.4. Arbitrator. This arbitration agreement, and any arbitration between us, is subject to the Federal Arbitration Act and will be administered by the American Arbitration Association (\"AAA\") under its Consumer Arbitration Rules (collectively, \"AAA Rules\") as modified by these Terms. The AAA Rules and filing forms are available online at www.adr.org, by calling the AAA at +1-800-778-7879, or by contacting Givt.\n 12.5. Commencing Arbitration. Before initiating arbitration, a party must first send a written notice of the dispute to the other party by e-mail mail (\"Notice of Arbitration\"). Givt\'s e-address for Notice is: support@givt.app. The Notice of Arbitration must: (a) include the following subject line: \"Notice of Arbitration\"; (b) identify the name or account number of the party making the claim; (c) describe the nature and basis of the claim or dispute; and (d) set forth the specific relief sought (\"Demand\"). The parties will make good faith efforts to resolve the claim directly, but if the parties do not reach an agreement to do so within 30 days after the Notice of Arbitration is received, you or Givt may commence an arbitration proceeding. If you commence arbitration in accordance with these Terms, Givt will reimburse you for your payment of the filing fee, unless your claim is for more than US\$10,000 or if Givt has received 25 or more similar demands for arbitration, in which case the payment of any fees will be decided by the AAA Rules. If the arbitrator finds that either the substance of the claim or the relief sought in the Demand is frivolous or brought for an improper purpose (as measured by the standards set forth in Federal Rule of Civil Procedure 11(b)), then the payment of all fees will be governed by the AAA Rules and the other party may seek reimbursement for any fees paid to AAA.\n 12.6. Arbitration Proceedings. Any arbitration hearing will take place in Fulton County, Georgia unless we agree otherwise or, if the claim is for US\$10,000 or less (and does not seek injunctive relief), you may choose whether the arbitration will be conducted: (a) solely on the basis of documents submitted to the arbitrator; (b) through a telephonic or video hearing; or (c) by an in-person hearing as established by the AAA Rules in the county (or parish) of your residence. During the arbitration, the amount of any settlement offer made by you or Givt must not be disclosed to the arbitrator until after the arbitrator makes a final decision and award, if any. Regardless of the manner in which the arbitration is conducted, the arbitrator must issue a reasoned written decision sufficient to explain the essential findings and conclusions on which the decision and award, if any, are based. \n 12.7. Arbitration Relief. Except as provided in Section 12.8, the arbitrator can award any relief that would be available if the claims had been brough in a court of competent jurisdiction. If the arbitrator awards you an amount higher than the last written settlement amount offered by Givt before an arbitrator was selected, Givt will pay to you the higher of: (a) the amount awarded by the arbitrator and (b) US\$10,000. The arbitrator\'s award shall be final and binding on all parties, except (1) for judicial review expressly permitted by law or (2) if the arbitrator\'s award includes an award of injunctive relief against a party, in which case that party shall have the right to seek judicial review of the injunctive relief in a court of competent jurisdiction that shall not be bound by the arbitrator\'s application or conclusions of law. Judgment on the award may be entered in any court having jurisdiction.\n 12.8. No Class Actions. YOU AND GIVT AGREE THAT EACH MAY BRING CLAIMS AGAINST THE OTHER ONLY IN YOUR OR ITS INDIVIDUAL CAPACITY AND NOT AS A PLAINTIFF OR CLASS MEMBER IN ANY PURPORTED CLASS OR REPRESENTATIVE PROCEEDING. Further, unless both you and Givt agree otherwise, the arbitrator may not consolidate more than one person\'s claims and may not otherwise preside over any form of a representative or class proceeding.  \n 12.9. Modifications to this Arbitration Provision. If Givt makes any substantive change to this arbitration provision, you may reject the change by sending us written notice within 30 days of the change to Givt\'s address for Notice of Arbitration, in which case your account with Givt will be immediately terminated and this arbitration provision, as in effect immediately prior to the changes you rejected will survive.\n 12.10. Enforceability. If Section 12.8 or the entirety of this Section 12.10 is found to be unenforceable, or if Givt receives an Opt-Out Notice from you, then the entirety of this Section 12 will be null and void and, in that case, the exclusive jurisdiction and venue described in Section 13.2 will govern any action arising out of or related to these Terms. \n \n\n 13. Miscellaneous \n 13.1. General Terms. These Terms, including the Privacy Policy and any other agreements expressly incorporated by reference into these Terms, are the entire and exclusive understanding and agreement between you and Givt regarding your use of the Service. You may not assign or transfer these Terms or your rights under these Terms, in whole or in part, by operation of law or otherwise, without our prior written consent. We may assign these Terms and all rights granted under these Terms, at any time without notice or consent. The failure to require performance of any provision will not affect our right to require performance at any other time after that, nor will a waiver by us of any breach or default of these Terms, or any provision of these Terms, be a waiver of any subsequent breach or default or a waiver of the provision itself. Use of Section headers in these Terms is for convenience only and will not have any impact on the interpretation of any provision. Throughout these Terms the use of the word \"including\" means \"including but not limited to.\" If any part of these Terms is held to be invalid or unenforceable, then the unenforceable part will be given effect to the greatest extent possible, and the remaining parts will remain in full force and effect.\n 13.2. Governing Law. These Terms are governed by the laws of the State of Delaware without regard to conflict of law principles. You and Givt submit to the personal and exclusive jurisdiction of the state courts and federal courts located within Fulton County, Georgia for resolution of any lawsuit or court proceeding permitted under these Terms. We operate the Service from our offices in Georgia, and we make no representation that Materials included in the Service are appropriate or available for use in other locations.\n 13.3. Privacy Policy. Please read the Givt Privacy Policy (https://www.givt.app/privacy-policy) carefully for information relating to our collection, use, storage, and disclosure of your personal information. The Givt Privacy Policy is incorporated by this reference into, and made a part of, these Terms. \n 13.4. Additional Terms. Your use of the Service is subject to all additional terms, policies, rules, or guidelines applicable to the Service or certain features of the Service that we may post on or link to from the Service (the \"Additional Terms\"). All Additional Terms are incorporated by this reference into, and made a part of, these Terms.\n 13.5. Modification of these Terms. We reserve the right to change these Terms on a going-forward basis at any time. Please check these Terms periodically for changes. If a change to these Terms materially modifies your rights or obligations, we may require that you accept the modified Terms in order to continue to use the Service. Material modifications are effective upon your acceptance of the modified Terms. Immaterial modifications are effective upon publication. Except as expressly permitted in this Section 13.5, these Terms may be amended only by a written agreement signed by authorized representatives of the parties to these Terms. Disputes arising under these Terms will be resolved in accordance with the version of these Terms that was in effect at the time the dispute arose.\n 13.6. Consent to Electronic Communications. By using the Service, you consent to receiving certain electronic communications from us as further described in our Privacy Policy. Please read our Privacy Policy to learn more about our electronic communications practices. You agree that any notices, agreements, disclosures, or other communications that we send to you electronically will satisfy any legal communication requirements, including that those communications be in writing.\n 13.7. Contact Information. The Service is offered by Givt Inc. located at\n 3343 12 N Cheyenne Ave, #305 TULSA, OK, 74103. You may contact us by emailing us at support@givt.app.\n 13.8. Notice to California Residents. If you are a California resident, then under California Civil Code Section 1789.3, you may contact the Complaint Assistance Unit of the Division of Consumer Services of the California Department of Consumer Affairs in writing at 1625 N. Market Blvd., Suite S-202, Sacramento, California 95834, or by telephone at +1-800-952-5210 in order to resolve a complaint regarding the Service or to receive further information regarding use of the Service.\n 13.9. No Support. We are under no obligation to provide support for the Service. In instances where we may offer support, the support will be subject to published policies.\n 13.10. International Use. The Service is intended for visitors located within the United States. We make no representation that the Service is appropriate or available for use outside of the United States. Access to the Service from countries or territories or by individuals where such access is illegal is prohibited.\n 13.11. Complaints. Givt handles complaints efficiently and as soon as reasonably possible. Any complaint about the implementation of these Terms by Givt must be submitted in writing at Givt via e-mail to support@givt.app.\n 13.12. Notice Regarding Apple. This Section 13 only applies to the extent you are using our mobile application on an iOS device. You acknowledge that these Terms are between you and Givt only, not with Apple Inc. (\"Apple\"), and Apple is not responsible for the Service or the content of it. Apple has no obligation to furnish any maintenance and support services with respect to the Service. If the Service fails to conform to any applicable warranty, you may notify Apple, and Apple will refund any applicable purchase price for the mobile application to you. To the maximum extent permitted by applicable law, Apple has no other warranty obligation with respect to the Service. Apple is not responsible for addressing any claims by you or any third party relating to the Service or your possession and/or use of the Service, including: (1) product liability claims; (2) any claim that the Service fails to conform to any applicable legal or regulatory requirement; or (3) claims arising under consumer protection or similar legislation. Apple is not responsible for the investigation, defense, settlement, and discharge of any third-party claim that the Service and/or your possession and use of the Service infringe a third party\'s intellectual property rights. You agree to comply with any applicable third-party terms when using the Service. Apple and Apple\'s subsidiaries are third-party beneficiaries of these Terms, and upon your acceptance of these Terms, Apple will have the right (and will be deemed to have accepted the right) to enforce these Terms against you as a third-party beneficiary of these Terms. You hereby represent and warrant that: (a) you are not located in a country that is subject to a U.S. Government embargo or that has been designated by the U.S. Government as a \"terrorist supporting\" country; and (b) you are not listed on any U.S. Government list of prohibited or restricted parties.\n\n';

  @override
  String get informationAboutUsUs =>
      'Givt is a product of Givt Inc\n \n\n We are located at 12 N Cheyenne Ave, #305, Tulsa, OK, 74103. For questions or complaints you can reach us via +1 918-615-9611 or support@givt.app\n \n\n We are incorporated in Delaware.';

  @override
  String get faQantwoord0Us =>
      'In the app-menu under \"About Givt / Contact\" there\'s a text field where you can type a message and send it to us. Of course you can also contact us by calling +1 918-615-9611 or by sending an e-mail to support@givt.app.';

  @override
  String get invalidQRcodeTitle => 'Código QR inactivo';

  @override
  String invalidQRcodeMessage(Object value0) {
    return 'Unfortunately, this QR code is no longer active. Would you like to give to the general funds of $value0?';
  }

  @override
  String get errorOccurred => 'Ocurrió un error';

  @override
  String get registrationErrorTitle => 'No se puede completar el registro';

  @override
  String get cantCancelAlreadyProcessed =>
      'Alas, you can\'t cancel this donation because it is already processed.';

  @override
  String get countryStringUs => 'Estados Unidos';

  @override
  String get enterPaymentDetails => 'Introducir detalles de pago';

  @override
  String get directNoticeText =>
      'Givt Direct Notice to Parents  \nIn order to allow your child to use Givt, an application through which younger users can direct donations, linked to and controlled by your Givt account, we have collected your online contact information, as well as your and your child’s name, for the purpose of obtaining your consent to collect, use, and disclose personal information from your child. \nParental consent is required for Givt to collect, use, or disclose your child\'s personal information. Givt will not collect, use, or disclose personal information from your child if you do not provide consent. As a parent, you provide your consent by completing a nominal payment card charge in your account on the Givt app. If you do not provide consent within a reasonable time, Givt will delete your information from its records, however Givt will retain any information it has collected from you as a standard Givt user, subject to Givt’s standard privacy policy www.givt.app/privacy-policy/ \nThe Givt Privacy Policy for Children Under the Age of 13 www.givt.app/privacy-policy-givt4kids/ provides details regarding how and what personal information we collect, use, and disclose from children under 13 using Givt (the “Application”). \nInformation We Collect from Children\nWe only collect as much information about a child as is reasonably necessary for the child to participate in an activity, and we do not condition his or her participation on the disclosure of more personal information than is reasonably necessary.  \nInformation We Collect Directly \nWe may request information from your child, but this information is optional. We specify whether information is required or optional when we request it. For example, if a child chooses to provide it, we collect information about the child’s choices and preferences, the child’s donation choices, and any good deeds that the child records. \nAutomatic Information Collection and Tracking\nWe use technology to automatically collect information from our users, including children, when they access and navigate through the Application and use certain of its features. The information we collect through these technologies may include: \nOne or more persistent identifiers that can be used to recognize a user over time and across different websites and online services, such as IP address and unique identifiers (e.g. MAC address and UUID); and,\nInformation that identifies a device\'s location (geolocation information).\nWe also may combine non-personal information we collect through these technologies with personal information about you or your child that we collect online.  \nHow We Use Your Child\'s Information\nWe use the personal information we collect from your child to: \nfacilitate donations that your child chooses;\ncommunicate with him or her about activities or features of the Application,;\ncustomize the content presented to a child using the Application;\nRecommend donation opportunities that may be of interest to your child; and,\ntrack his or her use of the Application. \nWe use the information we collect automatically through technology (see Automatic Information Collection and Tracking) and other non-personal information we collect to improve our Application and to deliver a better and more personalized experience by enabling us to:\nEstimate our audience size and usage patterns.\nStore information about the child\'s preferences, allowing us to customize the content according to individual interests.\nWe use geolocation information we collect to determine whether the user is in a location where it’s possible to use the Application for donating. \nOur Practices for Disclosing Children\'s Information\nWe may disclose aggregated information about many of our users, and information that does not identify any individual or device. In addition, we may disclose children\'s personal information:\nTo third parties we use to support the internal operations of our Application.\nIf we are required to do so by law or legal process, such as to comply with any court order or subpoena or to respond to any government or regulatory request.\nIf we believe disclosure is necessary or appropriate to protect the rights, property, or safety of Givt, our customers or others, including to:\nprotect the safety of a child;\nprotect the safety and security of the Application; or\nenable us to take precautions against liability.\nTo law enforcement agencies or for an investigation related to public safety. \nIf Givt is involved in a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of Givt\'s assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding or event, we may transfer the personal information we have collected or maintain to the buyer or other successor. \nSocial Features \nThe Application allows parents to view information about their child’s donation activities and any good deeds that the child records, and parents may provide certain responses to this information. \nAccessing and Correcting Your Child\'s Personal Information\nAt any time, you may review the child\'s personal information maintained by us, require us to correct or delete the personal information, and/or refuse to permit us from further collecting or using the child\'s information.  \nYou can review, change, or delete your child\'s personal information by:\nLogging into your account and accessing the profile page relating to your child.\nSending us an email at support@givt.app. To protect your and your child’s privacy and security, we may require you to take certain steps or provide additional information to verify your identity before we provide any information or make corrections. \nOperators That Collect or Maintain Information from Children\nGivt Inc. is the operator that collects and maintains personal information from children through the Application.Givt can be contacted at support@givt.app, by mail at 12 N Cheyenne Ave, #305, Tulsa, OK, 74103. , or by phone at +1 918-615-9611.';

  @override
  String get mobileNumberUsDigits => '1231231234';

  @override
  String get createChildNameErrorTextFirstPart1 =>
      'El nombre debe tener al menos ';

  @override
  String get createChildNameErrorTextFirstPart2 => ' caracteres.';

  @override
  String get createChildAllowanceErrorText =>
      'La asignación para donar debe ser mayor que cero.';

  @override
  String get dateOfBirth => 'Fecha de nacimiento';

  @override
  String get childInWalletPostfix => ' en el Monedero';

  @override
  String get childEditProfileErrorText =>
      'No se puede actualizar el perfil del niño/a. Por favor';

  @override
  String get childEditProfile => 'Editar perfil';

  @override
  String get childHistoryBy => 'por';

  @override
  String get childHistoryTo => 'a';

  @override
  String get childHistoryToBeApproved => 'Pendiente de aprobación';

  @override
  String get childHistoryCanContinueMakingADifference =>
      'puede seguir marcando la diferencia';

  @override
  String get childHistoryYay => '¡Genial!';

  @override
  String get childHistoryAllGivts => 'Todas las donaciones';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String childParentalApprovalApprovedTitle(Object value0) {
    return 'Yes, $value0 has made a difference!';
  }

  @override
  String get childParentalApprovalApprovedSubTitle => 'Gracias';

  @override
  String childParentalApprovalConfirmationTitle(Object value0) {
    return 'A $value0 le encantaría donar';
  }

  @override
  String childParentalApprovalConfirmationSubTitle(
    Object value0,
    Object value1,
  ) {
    return 'to $value0\n$value1';
  }

  @override
  String get childParentalApprovalConfirmationDecline => 'Rechazar';

  @override
  String get childParentalApprovalConfirmationApprove => 'Aprobar';

  @override
  String childParentalApprovalDeclinedTitle(Object value0) {
    return 'Has rechazado la solicitud de $value0';
  }

  @override
  String get childParentalApprovalDeclinedSubTitle => '¿Quizás la próxima vez?';

  @override
  String get childParentalApprovalErrorTitle => 'Oops, something went wrong!';

  @override
  String get childParentalApprovalErrorSubTitle =>
      'Por favor, intenta de nuevo más tarde';

  @override
  String get signUpPageTitle => 'Crear cuenta';

  @override
  String get surname => 'Apellido';

  @override
  String get pleaseEnterChildName => 'Por favor, ingresa el nombre del niño/a';

  @override
  String get pleaseEnterChildAge => 'Por favor, ingresa la edad del niño/a';

  @override
  String get pleaseEnterValidName => 'Por favor, ingresa un nombre valido';

  @override
  String get nameTooLong => 'El nombre es demasiado largo';

  @override
  String get pleaseEnterValidAge => 'Por favor, ingresa una edad valida';

  @override
  String get addAdultInstead => 'Por favor, agrégalo como Adulto';

  @override
  String get ageKey => 'Edad';

  @override
  String get emptyChildrenDonations =>
      'Your children\'s donations\nwill appear here';

  @override
  String get almostDone => 'Casi listo...';

  @override
  String get weHadTroubleGettingAllowance =>
      'Tuvimos problemas para obtener dinero de tu cuenta para la(s) asignación(es) para donar.';

  @override
  String get noWorriesWeWillTryAgain =>
      'No worries, we will try again tomorrow!';

  @override
  String get allowanceOopsCouldntGetAllowances =>
      '¡Ups! No pudimos obtener el importe de la asignación de su cuenta.';

  @override
  String get weWillTryAgainTmr => 'Lo intentaremos de nuevo mañana';

  @override
  String get weWillTryAgainNxtMonth =>
      'Lo intentaremos de nuevo el próximo mes';

  @override
  String get editChildWeWIllTryAgain => 'Lo intentaremos de nuevo el: ';

  @override
  String get familyGoalStepperCause => '1. Causa';

  @override
  String get familyGoalStepperAmount => '2. Importe';

  @override
  String get familyGoalStepperConfirm => '3. Confirmar';

  @override
  String familyGoalCircleMore(Object value0) {
    return '`+$value0 más';
  }

  @override
  String get familyGoalOverviewTitle => 'Crear un Objetivo Familiar';

  @override
  String get familyGoalConfirmationTitle => 'Lanzar el Objetivo Familiar';

  @override
  String get familyGoalCauseTitle => 'Encontrar una causa';

  @override
  String get familyGoalAmountTitle => 'Establezca su objetivo de donación';

  @override
  String get familyGoalStartMakingHabit =>
      'Comience a hacer de la donación un hábito en su familia';

  @override
  String get familyGoalCreate => 'Crear';

  @override
  String get familyGoalConfirmedTitle => '¡Objetivo Familiar lanzado!';

  @override
  String get familyGoalToSupport => 'para apoyar';

  @override
  String get familyGoalShareWithFamily =>
      'Comparta esto con su familia y marquen la diferencia juntos';

  @override
  String get familyGoalLaunch => 'Lanzar';

  @override
  String get familyGoalHowMuch => '¿Cuánto quieren recaudar?';

  @override
  String get familyGoalAmountHint =>
      'La mayoría de las familias comienzan con \$100';

  @override
  String get certExceptionTitle => 'Un pequeño contratiempo';

  @override
  String get certExceptionBody =>
      'We couldn\'t connect to the server. But no worries, try again later and we\'ll get things sorted out!';

  @override
  String get familyGoalPrefix => 'Objetivo Familiar: ';

  @override
  String permitBiometricQuestionWithType(Object value0) {
    return '¿Quieres usar $value0?';
  }

  @override
  String get permitBiometricExplanation =>
      'Acelera el proceso de inicio de sesión y mantén tu cuenta segura';

  @override
  String get permitBiometricSkip => 'Omitir por ahora';

  @override
  String permitBiometricActivateWithType(Object value0) {
    return 'Activar $value0';
  }

  @override
  String get youHaveBeenInvitedToImpactGroup =>
      'You have been invited\nto the ';

  @override
  String get acceptInviteKey => 'Acepta la invitación';

  @override
  String get chooseGroup => 'Elegir Grupo';

  @override
  String get groups => 'Grupos';

  @override
  String get genericSuccessTitle => '¡Considéralo hecho!';

  @override
  String get topUpScreenInfo =>
      'How much would you like to add to\nyour child\'s Wallet?';

  @override
  String topUpSuccessText(Object value0) {
    return '$value0 has been added to\nyour child’s Wallet';
  }

  @override
  String get goToSettings => 'Ir a Ajustes';

  @override
  String get goToSettingsBody =>
      'Para escanear el código QR necesitamos encender la cámara. Ve a Ajustes para permitirlo.';

  @override
  String get selectCountryHint => 'Seleccionar país';

  @override
  String get homescreenLetsGo => '¡Vamos!';

  @override
  String get homescreenJourneyOfGenerosity =>
      '¡Comienza tu viaje de generosidad!';

  @override
  String get registrationRandomAvatarError => 'Error al cargar el avatar.';

  @override
  String get registrationAvatarSelectionTitle => 'Selecciona tu avatar';

  @override
  String get registrationParentFirstName => 'Nombre del padre/madre';

  @override
  String get registrationParentLastName => 'Apellido';

  @override
  String get homepageParentEmailHint => 'Correo electrónico del padre';

  @override
  String get addMemberAdultDescription =>
      'Recibirás un correo electrónico confirmando que te unirás a la familia, lo que también te permitirá:';

  @override
  String get addMemberAdultReason1 =>
      'Inicia sesión en Givt con tu propia cuenta';

  @override
  String get addMemberAdultReason2 => 'Aprobar las donaciones de los niños/as';

  @override
  String get addMemberAdultReason3 => 'Ser generosos como familia';

  @override
  String get addMemberAdultEmailSameAsLoggedIn =>
      'Ya has creado una cuenta para ti con este correo';

  @override
  String get unregisterTitle => 'Cerrar cuenta';

  @override
  String get unregisterPrimaryBtnText => 'Cerrar cuenta';

  @override
  String get unregisterDescription =>
      'Lamentamos verte partir.\nDespués de cerrar tu cuenta, no podremos recuperarla.';

  @override
  String get unregisterCheckboxText => 'Si, quiero eliminar mi cuenta';

  @override
  String get unregisterLoading => 'Eliminar cuenta';

  @override
  String get unregisterSuccessText =>
      'Nos da tristeza que te vayas y esperamos verte de nuevo.';

  @override
  String get homeScreenWelcome => '¡Bienvenidos!';

  @override
  String homeScreenHeyFamily(Object family) {
    return '¡Hola $family!';
  }

  @override
  String get tutorialGratitudeGameTitle => 'Gratitude Game';

  @override
  String get tutorialGratitudeGameDescription =>
      'Este juego te ayuda a cultivar la gratitud al reflexionar sobre tu día en familia.';

  @override
  String homeScreenSecondParentDialogTitle(Object firstName) {
    return '$firstName necesita usar su propia cuenta';
  }

  @override
  String get homeScreenSecondParentDialogDescription =>
      'Usa la app Givt en tu propio dispositivo';

  @override
  String get homeScreenSecondParentDialogConfirmButton => 'Entendido';

  @override
  String get tutorialFirstMissionTitle =>
      '¡Vamos a completar tu primera misión!';

  @override
  String get tutorialFirstMissionDescription =>
      'Nuevas misiones ayudan a tu familia a crecer juntos. ¡Toca arriba para empezar!';

  @override
  String get homeScreenGratitudeGameButtonTitle => 'Juego en Familia';

  @override
  String get homeScreenGratitudeGameButtonSubtitle => '¡Juega ahora!';

  @override
  String get setupFamilyTitle => 'Crear Familia';

  @override
  String get setupFamilyHowManyTitle => '¿Cuántas personas hay en tu familia?';

  @override
  String get childKey => 'Niño/a';

  @override
  String get adultKey => 'Adulto';

  @override
  String get setupFamilyAddNextMember => 'Agregar nuevo miembro';

  @override
  String get homescreenFamilyWelcome => '¡Bienvenidos, súper familia!';

  @override
  String get homescreenFamilyGenerosity => '¡Fomentemos la generosidad juntos!';

  @override
  String get buttonSkip => 'Saltar';

  @override
  String get leagueUnlockLeague => 'Desbloquear Liga';

  @override
  String get leagueUnlocked => '¡Liga Desbloqueada!';

  @override
  String get leagueWelcome => '¡Bienvenidos a la Liga!';

  @override
  String get leagueExplanation =>
      'Tu XP determina tu rango. ¡Crece en generosidad y escala hasta la cima!';

  @override
  String get buttonDone => 'Listo';

  @override
  String get originQuestionTitle => 'Último paso';

  @override
  String get originQuestionSubtitle => '¿Dónde recibiste tu caja?';

  @override
  String get originSelectLocation => 'Seleccionar ubicación';

  @override
  String get homeScreenGiveButtonTitle => 'Dar';

  @override
  String get homeScreenGivtButtonDescription => 'Donar a una causa';

  @override
  String gratitudeWeeklyGoal(Object amount) {
    return 'Juega ${amount}x por semana';
  }

  @override
  String gratitudeGoalDaysLeft(Object amount) {
    return '$amount días';
  }

  @override
  String get familyNavigationBarHome => 'Inicio';

  @override
  String get familyNavigationBarFamily => 'Familia';

  @override
  String get familyNavigationBarMemories => 'Recuerdos';

  @override
  String get familyNavigationBarLeague => 'Liga';

  @override
  String get missionsTitle => 'Misiones disponibles';

  @override
  String get missionsNoMissions => 'No tienes ninguna misión actualmente';

  @override
  String get missionsNoCompletedMissions =>
      'Todavía no has completado ninguna misión';

  @override
  String get tutorialMissionTitle => '¡Toca para empezar la misión!';

  @override
  String get tutorialMissionDescription =>
      'Sigue tu progreso y completa tus misiones aquí.';

  @override
  String get missionsCardNoMissionsTitle => 'No hay misiones disponibles';

  @override
  String get missionsCardNoMissionsDescription =>
      'Tu trabajo aquí ha terminado';

  @override
  String get missionsCardTitle => '';

  @override
  String get missionsCardTitleSingular => 'Misión disponible';

  @override
  String get missionsCardTitlePlural => 'Misiones disponibles';

  @override
  String get missionsCardDescriptionSingular =>
      '1 misión disponible por completar';

  @override
  String missionsCardDescriptionPlural(Object amount) {
    return '$amount misiones disponibles por completar';
  }

  @override
  String get progressbarPlayed => 'jugados';

  @override
  String get gameStatsActivityThisWeek => 'Actividad en el juego esta semana';

  @override
  String get gameStatsPlayGame => 'Jugar el Juego de la Gratitud';

  @override
  String gameStatsAmountOfDeeds(Object amount) {
    return '$amount actos';
  }

  @override
  String get homescreenOverlayDiscoverTitle => '¡Descubre tu recompensa!';

  @override
  String get homescreenOverlayGiveTitle => '¿A quién le gustaría dar?';

  @override
  String get tutorialFamilyExplanationTitle => '¡Aquí está tu súper familia!';

  @override
  String get tutorialFamilyExplanationDescription =>
      'Trabajen juntos para encontrar causas para apoyar y difundir la bondad.';

  @override
  String get tutorialManagingFamilyTitle => 'Gestión de tu familia';

  @override
  String get tutorialManagingFamilyDescription =>
      'Anima a tus héroes recargando sus monederos y aprobando las donaciones.';

  @override
  String get tutorialTheEndTitle => '¡Excelente trabajo, superhéroe!';

  @override
  String get tutorialTheEndDescription =>
      'Puedes seguir por tu cuenta. ¡Ve a tu próxima misión y sigue marcando la diferencia!';

  @override
  String get completedKey => 'Completado';

  @override
  String get tutorialIntroductionTitle => '¡Hola! Soy el Capitán Generosidad.';

  @override
  String get tutorialIntroductionDescription =>
      'Estoy aquí para ayudar a tu familia a cultivar gratitud y fomentar la generosidad. ¡Empecemos!';

  @override
  String get refundTitle => 'Revertir donación';

  @override
  String get refundMessageBACS =>
      'Por favor, contáctanos para que podamos reembolsar tu donación.';

  @override
  String get refundMessageGeneral =>
      'Go to your online banking environment to refund your donation.';

  @override
  String get requestRefund => 'Revertir';

  @override
  String get changeName => 'Editar nombre';

  @override
  String get onlineGivingLabel => 'Donación en línea';

  @override
  String get accountDisabled =>
      'Tu cuenta ha sido bloqueada. Por favor, contáctanos en support@givtapp.net';

  @override
  String get recurringDonationsFrequenciesWeekly => 'Weekly';

  @override
  String get recurringDonationsFrequenciesMonthly => 'Monthly';

  @override
  String get recurringDonationsFrequenciesQuarterly => 'Quarterly';

  @override
  String get recurringDonationsFrequenciesHalfYearly => 'Half Yearly';

  @override
  String get recurringDonationsFrequenciesYearly => 'Yearly';

  @override
  String get closeModalAreYouSure => 'Are you sure you want to exit?';

  @override
  String get closeModalWontBeSaved =>
      'If you exit now, your current changes won\'t be saved.';

  @override
  String get closeModalYesExit => 'Yes, exit';

  @override
  String get closeModalNoBack => 'No, go back';

  @override
  String get recurringDonationsStep2Description =>
      'How often do you want to give, and how much?';

  @override
  String get recurringDonationsFrequencyTitle => 'Donation frequency';

  @override
  String get recurringDonationsAmountTitle => 'Donation amount';

  @override
  String get donationSubtotal => 'Subtotal';

  @override
  String get donationTotal => 'Total';

  @override
  String get platformFeeTitle => 'Help us lower the costs for organisations';

  @override
  String get platformFeeText =>
      'Givt aims for 0% service fee. With a small donation to Givt, you help achieve that.';

  @override
  String get platformFeeNoContribution => 'Not this time';

  @override
  String get donationOverviewPlatformContribution => 'Platform Contribution';

  @override
  String get donationOverviewPlatformContributionTitle =>
      'Thanks for your generosity!';

  @override
  String get donationOverviewPlatformContributionText =>
      'Because of the voluntary platform contribution you\'ve chosen, we can lower the costs of receiving donations.';

  @override
  String get platformFeePlaceholder => 'Select amount';

  @override
  String get platformFeeRequired => 'Required field';

  @override
  String get recurringDonationsStep1Title => 'Select organisation';

  @override
  String get recurringDonationsStep1Description =>
      'Who do you want to give to?';

  @override
  String get recurringDonationsStep1ListTitle => 'Select from list';

  @override
  String get recurringDonationsStep1ListSubtitle =>
      'Select a cause from the list';

  @override
  String get recurringDonationsStep2Title => 'Set amount';

  @override
  String get recurringDonationsStep3Title => 'Set duration';

  @override
  String get recurringDonationsStep3Description =>
      'How long would you like to schedule this donation for?';

  @override
  String get recurringDonationsStartingTitle => 'Starting on';

  @override
  String get recurringDonationsEndsTitle => 'Ends';

  @override
  String get recurringDonationsEndsWhenIDecide => 'When I decide';

  @override
  String get recurringDonationsEndsAfterNumber => 'After a number of donations';

  @override
  String get recurringDonationsEndsAfterDate => 'On a specific date';

  @override
  String recurringDonationsEndDateHintEveryMonth(Object dag, Object day) {
    return 'Your donation will occur on the $day of every month';
  }

  @override
  String recurringDonationsEndDateHintEveryWeek(Object day) {
    return 'Your donation will occur every week on the $day';
  }

  @override
  String recurringDonationsEndDateHintEveryXMonth(Object day, Object freq) {
    return 'Your donation will occur every $freq months on the $day';
  }

  @override
  String recurringDonationsEndDateHintEveryYear(Object day, Object month) {
    return 'Your donation will occur once a year on the $day of $month';
  }

  @override
  String recurringDonationsEndsAfterXDonations(Object amount) {
    return 'After $amount of donations';
  }

  @override
  String get recurringDonationsStep4Title => 'Confirm';

  @override
  String get recurringDonationsStep4Description =>
      'Ready to make a difference?';

  @override
  String get recurringDonationsStep4YoullDonateTo => 'You\'ll donate to';

  @override
  String get recurringDonationsStep4Amount => 'Amount';

  @override
  String get recurringDonationsStep4Frequency => 'Frequency';

  @override
  String get recurringDonationsStep4Starts => 'Starts';

  @override
  String get recurringDonationsStep4Ends => 'Ends';

  @override
  String get recurringDonationsStep4ConfirmMyDonation => 'Confirm my donation';

  @override
  String get recurringDonationsEmptyStateTitle => 'Easy giving, full control';

  @override
  String get recurringDonationsEmptyStateDescription =>
      'Set up a recurring donation you can adjust or cancel anytime.';

  @override
  String get recurringDonationsOverviewTabCurrent => 'Current';

  @override
  String get recurringDonationsOverviewTabPast => 'Past';

  @override
  String get recurringDonationsOverviewAddButton => 'Add recurring donation';

  @override
  String get recurringDonationsDetailProgressSuffix => 'donations';

  @override
  String get recurringDonationsDetailSummaryDonated => 'Donated';

  @override
  String get recurringDonationsDetailSummaryHelping => 'Helping';

  @override
  String get recurringDonationsDetailSummaryHelped => 'Helped';

  @override
  String recurringDonationsDetailEndsTag(Object date) {
    return 'Ends $date';
  }

  @override
  String get recurringDonationsDetailHistoryTitle => 'History';

  @override
  String get recurringDonationsDetailStatusUpcoming => 'Upcoming';

  @override
  String get recurringDonationsDetailStatusCompleted => 'Completed';

  @override
  String get recurringDonationsDetailStatusPending => 'Pending';

  @override
  String recurringDonationsDetailTimeDisplayDays(Object days) {
    return '$days days';
  }

  @override
  String get recurringDonationsDetailManageButton => 'Manage donation';

  @override
  String get recurringDonationsDetailEditDonation => 'Edit donation';

  @override
  String get recurringDonationsDetailEditComingSoon =>
      'Edit functionality coming soon';

  @override
  String get recurringDonationsDetailPauseDonation => 'Pause donation';

  @override
  String get recurringDonationsDetailPauseComingSoon =>
      'Pause functionality coming soon';

  @override
  String get recurringDonationsDetailCancelDonation => 'Cancel donation';

  @override
  String get recurringDonationsCreateStep2AmountHint => 'Enter amount';

  @override
  String get recurringDonationsCreateFrequencyHint => 'Select one';

  @override
  String get recurringDonationsCreateDurationNumberHint => 'Enter the number';

  @override
  String recurringDonationsCreateDurationSnackbarTimes(
    Object date,
    Object number,
  ) {
    return 'You\'ll donate $number times, ending on $date';
  }

  @override
  String recurringDonationsCreateDurationSnackbarOnce(Object date) {
    return 'You\'ll donate 1 time, ending on $date';
  }

  @override
  String recurringDonationsCreateDurationSnackbarMultiple(
    Object count,
    Object date,
  ) {
    return 'You\'ll donate $count times, ending on $date';
  }

  @override
  String get recurringDonationsSuccessTitle => 'Thanks for your support';

  @override
  String recurringDonationsSuccessSubtitleNextXMonths(
    Object months,
    Object organization,
  ) {
    return 'For the next $months months, you\'ll be helping $organization make an impact';
  }

  @override
  String recurringDonationsSuccessSubtitleUntilDecide(Object organization) {
    return 'You\'ll be helping $organization make an impact until you decide to stop.';
  }

  @override
  String recurringDonationsSuccessSubtitleUntilDate(
    Object date,
    Object organization,
  ) {
    return 'Until $date, you\'ll be helping $organization make an impact';
  }

  @override
  String recurringDonationsSuccessSubtitleDefault(Object organization) {
    return 'You\'ll be helping $organization make an impact';
  }

  @override
  String get recurringDonationsListStatusEnded => 'Ended';

  @override
  String get recurringDonationsListStatusNextUp => 'Next up';

  @override
  String get recurringDonationsListFrequencyWeekly => 'Weekly';

  @override
  String get recurringDonationsListFrequencyMonthly => 'Monthly';

  @override
  String get recurringDonationsListFrequencyQuarterly => 'Quarterly';

  @override
  String get recurringDonationsListFrequencySemiAnnually => 'Semi-annually';

  @override
  String get recurringDonationsListFrequencyAnnually => 'Annually';

  @override
  String get recurringDonationsListFrequencyRecurring => 'Recurring';

  @override
  String get platformFeeCommonOption => 'Most popular';

  @override
  String get platformFeeGenerousOption => 'Extra generous';

  @override
  String get recurringDonationsCreationErrorTitle =>
      'We couldn\'t set up your donation';

  @override
  String get recurringDonationsCreationErrorDescription =>
      'Something went wrong.\\nPlease check your details and try again.';

  @override
  String get recurringDonationsCreationErrorChangeAndRetry =>
      'Change and Retry';

  @override
  String get recurringDonationsCancelled => 'Cancelled';

  @override
  String get donationOverviewDateAt => 'at';

  @override
  String get donationOverviewStatusProcessed => 'Processed';

  @override
  String get donationOverviewStatusCancelled => 'Cancelled';

  @override
  String get donationOverviewStatusInProcess => 'In Process';

  @override
  String get donationOverviewStatusRefused => 'Refused';

  @override
  String get donationOverviewStatusProcessedFull => 'Processed';

  @override
  String get donationOverviewStatusCancelledFull => 'Cancelled by user';

  @override
  String get donationOverviewStatusInProcessFull => 'In Process';

  @override
  String get donationOverviewStatusRefusedFull => 'Refused by bank';

  @override
  String donationOverviewContactMessage(Object status, Object transactionId) {
    return 'Hi, I need help with the following donation:\\n\\nStatus: $status\\nTransaction ID:#$transactionId';
  }

  @override
  String get date => 'Date';

  @override
  String get platformFeeGoodOption => 'Good choice';

  @override
  String get platformFeeRemember =>
      'Remember my choice for future donations to this organisation.';

  @override
  String get platformFeeCustomOption => 'Custom amount';

  @override
  String get platformFeeCustomPlaceholder => 'Enter custom amount';

  @override
  String get platformContributionTitle => 'Platform Contribution';

  @override
  String get platformContributionHelpLowerCosts =>
      'Help us lower costs for the organizations';

  @override
  String get platformContributionAims =>
      'Give aims for 0% service fee with your help. They\'ll show here once you set them.';

  @override
  String get platformContributionManage =>
      'Manage your platform contribution for each organization';

  @override
  String get platformContributionOrgPresbyterian => 'Presbyterian Church';

  @override
  String get platformContributionExtraGenerous => 'Extra generous';

  @override
  String get platformContributionOrgRedCross => 'Red Cross';

  @override
  String get platformContributionMostPopular => 'Most popular';

  @override
  String get platformContributionOrgTheParkChurch => 'The Park Church';

  @override
  String get platformContributionSaveChangesButton => 'Save changes';

  @override
  String get platformContributionSaveChangesModalTitle => 'Save changes?';

  @override
  String get platformContributionSaveChangesModalBody =>
      'Do you want to save your changes before leaving?';

  @override
  String get platformContributionSaveChangesModalYesButton => 'Yes, save';

  @override
  String get platformContributionSaveChangesModalNoButton => 'No, discard';
}
