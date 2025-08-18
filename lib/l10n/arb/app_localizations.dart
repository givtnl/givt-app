import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_nl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('en', 'US'),
    Locale('es'),
    Locale('es', '419'),
    Locale('nl'),
  ];

  /// No description provided for @ibanPlaceHolder.
  ///
  /// In en, this message translates to:
  /// **'IBAN account number'**
  String get ibanPlaceHolder;

  /// `@Tine, vind je 'Ho' kunnen? Of 'Ha' of moet de zin gewoon anders? Sjoerd kan niet leven met 'Hé'
  ///
  /// In en, this message translates to:
  /// **'This amount is higher than your chosen maximum amount. Please adjust the maximum donation amount or choose a lower amount.'**
  String get amountLimitExceeded;

  /// Alleen wanneer je zelf een bedrag geeft
  ///  met Givt, wordt er geïncasseerd. Deze oorspronkelijke tekst even aangepast om te checken of de tekst er dan beter uit ziet op het scherm.
  ///
  /// In en, this message translates to:
  /// **'We want your Givt experience to be as smooth as possible.'**
  String get slimPayInformation;

  /// No description provided for @buttonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get buttonContinue;

  /// No description provided for @slimPayInfoDetail.
  ///
  /// In en, this message translates to:
  /// **'Givt works together with Better World Payments for executing the transactions. Better World Payments is specialised in handling mandates and automatic money transfers on digital platforms. Better World Payments executes these orders for Givt at the lowest rates on this market and at a high speed.\n \n\nBetter World Payments is an ideal partner for Givt because they make giving without cash very easy and safe. \n \n\nThe money will be collected in a Better World Payments account. \n Givt will ensure that the money is distributed correctly.'**
  String get slimPayInfoDetail;

  /// No description provided for @slimPayInfoDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'What is Better World Payments?'**
  String get slimPayInfoDetailTitle;

  /// No description provided for @unregisterButton.
  ///
  /// In en, this message translates to:
  /// **'Terminate my account'**
  String get unregisterButton;

  /// No description provided for @unregisterUnderstood.
  ///
  /// In en, this message translates to:
  /// **'I understand'**
  String get unregisterUnderstood;

  /// No description provided for @givtIsBeingProcessed.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your Givt to {value0}!\n You can check the status in the overview.'**
  String givtIsBeingProcessed(Object value0);

  /// No description provided for @offlineGegevenGivtMessageWithOrg.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your Givt to {value0}!\n \n\n When there\'s a good connection with the Givt-server, your Givt will be processed.\n You can check the status in the overview.'**
  String offlineGegevenGivtMessageWithOrg(Object value0);

  /// No description provided for @wrongPasswordLockedOut.
  ///
  /// In en, this message translates to:
  /// **'Third attempt failed, you cannot login for 15 minutes. Try again later.'**
  String get wrongPasswordLockedOut;

  /// No description provided for @giftOverviewGiftAidBanner.
  ///
  /// In en, this message translates to:
  /// **'Gift Aided {value0}'**
  String giftOverviewGiftAidBanner(Object value0);

  /// No description provided for @faqWhyBluetoothEnabledQ.
  ///
  /// In en, this message translates to:
  /// **'Why do I have to enable Bluetooth to use Givt?'**
  String get faqWhyBluetoothEnabledQ;

  /// No description provided for @faqWhyBluetoothEnabledA.
  ///
  /// In en, this message translates to:
  /// **'Your phone receives a signal from the beacon inside the collection box, bag or basket. This signal uses the Bluetooth protocol. It can be considered as a one-way traffic, which means there is no connection, in contrast to a Bluetooth car kit or headset. It is a safe and easy way to let your phone know which collection box, bag or basket is nearby. When the beacon is near, the phone picks up the signal and your Givt is completed.'**
  String get faqWhyBluetoothEnabledA;

  /// No description provided for @collect.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get collect;

  /// No description provided for @areYouSureToCancelGivts.
  ///
  /// In en, this message translates to:
  /// **'Are you sure? Press OK to confirm.'**
  String get areYouSureToCancelGivts;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback or questions?'**
  String get feedbackTitle;

  /// No description provided for @feedbackMailSent.
  ///
  /// In en, this message translates to:
  /// **'We\'ve received your message succesfully, we\'ll be in touch as soon as possible.'**
  String get feedbackMailSent;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Write your message here!'**
  String get typeMessage;

  /// No description provided for @safariGivtTransaction.
  ///
  /// In en, this message translates to:
  /// **'This Givt will be converted into a transaction.'**
  String get safariGivtTransaction;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version:'**
  String get appVersion;

  /// No description provided for @askMeLater.
  ///
  /// In en, this message translates to:
  /// **'Ask me later'**
  String get askMeLater;

  /// No description provided for @giveDifferently.
  ///
  /// In en, this message translates to:
  /// **'Choose from the list'**
  String get giveDifferently;

  /// No description provided for @codeCanNotBeScanned.
  ///
  /// In en, this message translates to:
  /// **'Alas, this code cannot be used to give within the Givt app.'**
  String get codeCanNotBeScanned;

  /// No description provided for @giveDifferentScan.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get giveDifferentScan;

  /// No description provided for @giveDiffQrText.
  ///
  /// In en, this message translates to:
  /// **'Now, aim well!'**
  String get giveDiffQrText;

  /// No description provided for @locationEnabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enable your location with high accuracy to give with Givt. (After your donation you can disable it again.)'**
  String get locationEnabledMessage;

  /// No description provided for @changeGivingLimit.
  ///
  /// In en, this message translates to:
  /// **'Adjust maximum amount'**
  String get changeGivingLimit;

  /// No description provided for @chooseLowerAmount.
  ///
  /// In en, this message translates to:
  /// **'Change the amount'**
  String get chooseLowerAmount;

  /// No description provided for @turnOnBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Switch on Bluetooth'**
  String get turnOnBluetooth;

  /// No description provided for @errorTldCheck.
  ///
  /// In en, this message translates to:
  /// **'Sorry, you can’t register with this e-mail address. Could you check for any typos?'**
  String get errorTldCheck;

  /// No description provided for @faQantwoord0.
  ///
  /// In en, this message translates to:
  /// **'In the app-menu under \"About Givt / Contact\" there\'s a text field where you can type a message and send it to us. Of course you can also contact us by calling +44 2037 908068 or by sending an e-mail to support@givt.co.uk'**
  String get faQantwoord0;

  /// No description provided for @personalPageHeader.
  ///
  /// In en, this message translates to:
  /// **'Change your account data here.'**
  String get personalPageHeader;

  /// No description provided for @personalPageSubHeader.
  ///
  /// In en, this message translates to:
  /// **'Would you like to change your name? Send an e-mail to support@givtapp.net .'**
  String get personalPageSubHeader;

  /// No description provided for @updatePersonalInfoError.
  ///
  /// In en, this message translates to:
  /// **'Alas! We are not able to update your personal information at the moment. Could you try again later?'**
  String get updatePersonalInfoError;

  /// No description provided for @loadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get loadingTitle;

  /// No description provided for @finalizeRegistrationPopupText.
  ///
  /// In en, this message translates to:
  /// **'Important: Donations can only be processed after you have finished your registration.'**
  String get finalizeRegistrationPopupText;

  /// No description provided for @finalizeRegistration.
  ///
  /// In en, this message translates to:
  /// **'Finish registration'**
  String get finalizeRegistration;

  /// No description provided for @importantReminder.
  ///
  /// In en, this message translates to:
  /// **'Important reminder'**
  String get importantReminder;

  /// No description provided for @shareTheGivtButton.
  ///
  /// In en, this message translates to:
  /// **'Share with my friends'**
  String get shareTheGivtButton;

  /// No description provided for @shareTheGivtText.
  ///
  /// In en, this message translates to:
  /// **'I\'ve just used Givt to donate to {value0}!'**
  String shareTheGivtText(Object value0);

  /// No description provided for @joinGivt.
  ///
  /// In en, this message translates to:
  /// **'Get involved on givtapp.net/download.'**
  String get joinGivt;

  /// No description provided for @yesSuccess.
  ///
  /// In en, this message translates to:
  /// **'Yes, success!'**
  String get yesSuccess;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal info'**
  String get personalInfo;

  /// No description provided for @searchHere.
  ///
  /// In en, this message translates to:
  /// **'Search ...'**
  String get searchHere;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'Whoops! It looks like you\'re not connected to the internet. Try again when you are connected with the internet.'**
  String get noInternet;

  /// No description provided for @noInternetConnectionTitle.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnectionTitle;

  /// No description provided for @answerWhyAreMyDataStored.
  ///
  /// In en, this message translates to:
  /// **'Everyday we work very hard at improving Givt. To do this we use the data we have at our disposal.\n We require some of your data to create your mandate. Other information is used to create your personal account.\n We also use your data to answer your service questions.\n In no case we give your personal details to third parties.'**
  String get answerWhyAreMyDataStored;

  /// No description provided for @cantCancelGiftAfter15Minutes.
  ///
  /// In en, this message translates to:
  /// **'Alas, you can\'t cancel this donation within the Givt app.'**
  String get cantCancelGiftAfter15Minutes;

  /// No description provided for @faqVraag16.
  ///
  /// In en, this message translates to:
  /// **'Can I revoke donations?'**
  String get faqVraag16;

  /// No description provided for @faqAntwoord16.
  ///
  /// In en, this message translates to:
  /// **'Yes, simply go to the donation overview and click the cancel button below the specific donation that you want to cancel. If the cancel button is not visible the donation has already been processed. Note: You can only cancel your donation if you have completed your registration in the Givt app.\n \n\n No transactions take place in the moment of giving. The transactions take place afterwards via a direct debit. Since these transactions are revertible via your bank, it is completely safe and immune to fraud.'**
  String get faqAntwoord16;

  /// No description provided for @selectContextCollect.
  ///
  /// In en, this message translates to:
  /// **'Give in the church, at the door or on the street'**
  String get selectContextCollect;

  /// No description provided for @giveContextQr.
  ///
  /// In en, this message translates to:
  /// **'Give by scanning a QR code'**
  String get giveContextQr;

  /// No description provided for @selectContextList.
  ///
  /// In en, this message translates to:
  /// **'Select a cause from the list'**
  String get selectContextList;

  /// No description provided for @selectContext.
  ///
  /// In en, this message translates to:
  /// **'Choose the way you give'**
  String get selectContext;

  /// No description provided for @chooseWhoYouWantToGiveTo.
  ///
  /// In en, this message translates to:
  /// **'Choose who you want to give to'**
  String get chooseWhoYouWantToGiveTo;

  /// No description provided for @cancelGiftAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel donation?'**
  String get cancelGiftAlertTitle;

  /// No description provided for @cancelGiftAlertMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this donation?'**
  String get cancelGiftAlertMessage;

  /// No description provided for @cancelFeatureTitle.
  ///
  /// In en, this message translates to:
  /// **'You can cancel a donation by swiping left'**
  String get cancelFeatureTitle;

  /// No description provided for @cancelFeatureMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere to dismiss this message'**
  String get cancelFeatureMessage;

  /// No description provided for @giveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'There are several ways to ‘Givt’. Pick the one that suits you best.'**
  String get giveSubtitle;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @giveWithYourPhone.
  ///
  /// In en, this message translates to:
  /// **'Move your phone'**
  String get giveWithYourPhone;

  /// No description provided for @errorContactGivt.
  ///
  /// In en, this message translates to:
  /// **'An error has occurred, please contact us at support@givtapp.net .'**
  String get errorContactGivt;

  /// No description provided for @mandateFailPersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'It seems there is something wrong with the information you filled in. Could you please check in the menu, under \'Personal information\'? You can change the information there as well, if necessary.'**
  String get mandateFailPersonalInformation;

  /// No description provided for @givtEventText.
  ///
  /// In en, this message translates to:
  /// **'Hey! You\'re at a location where Givt is supported. Do you want to give to {value0}?'**
  String givtEventText(Object value0);

  /// No description provided for @searchingEventText.
  ///
  /// In en, this message translates to:
  /// **'We are searching where you are, care to wait a little?'**
  String get searchingEventText;

  /// No description provided for @selectLocationContext.
  ///
  /// In en, this message translates to:
  /// **'Give at location'**
  String get selectLocationContext;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @allowGivtLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow Givt to access your location'**
  String get allowGivtLocationTitle;

  /// No description provided for @allowGivtLocationMessage.
  ///
  /// In en, this message translates to:
  /// **'We need your location to determine who you want to give to.\n Go to Settings > Privacy > Location Services > Set Location Services On and set Givt to \'While Using the App\'.'**
  String get allowGivtLocationMessage;

  /// No description provided for @faqVraag10.
  ///
  /// In en, this message translates to:
  /// **'How do I change my password?'**
  String get faqVraag10;

  /// No description provided for @faqAntwoord10.
  ///
  /// In en, this message translates to:
  /// **'If you want to change your password, you can choose ‘Personal information’ in the menu and then press the ‘Change password’ button. We will send you an e-mail with a link to a web page where you can change your password.'**
  String get faqAntwoord10;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change e-mail address'**
  String get changeEmail;

  /// No description provided for @changeIban.
  ///
  /// In en, this message translates to:
  /// **'Change IBAN'**
  String get changeIban;

  /// No description provided for @kerkdienstGemistQuestion.
  ///
  /// In en, this message translates to:
  /// **'How can I give with Givt through 3rd-parties?'**
  String get kerkdienstGemistQuestion;

  /// No description provided for @kerkdienstGemistAnswer.
  ///
  /// In en, this message translates to:
  /// **'Kerkdienst Gemist\n If you’re watching using the Kerkdienst Gemist App, you can easily give with Givt when your church uses our service. At the bottom of the page, you’ll find a small button that will take you to the Givt app. Choose an amount, confirm with \'Yes, please\' and you’re done!'**
  String get kerkdienstGemistAnswer;

  /// No description provided for @changePhone.
  ///
  /// In en, this message translates to:
  /// **'Change mobile number'**
  String get changePhone;

  /// No description provided for @artists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get artists;

  /// No description provided for @changeAddress.
  ///
  /// In en, this message translates to:
  /// **'Change address'**
  String get changeAddress;

  /// No description provided for @selectLocationContextLong.
  ///
  /// In en, this message translates to:
  /// **'Give based on your location'**
  String get selectLocationContextLong;

  /// No description provided for @sortCodePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Sort code'**
  String get sortCodePlaceholder;

  /// No description provided for @bankAccountNumberPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Bank account number'**
  String get bankAccountNumberPlaceholder;

  /// No description provided for @bacsSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Setting up Direct Debit Instruction'**
  String get bacsSetupTitle;

  /// No description provided for @bacsSetupBody.
  ///
  /// In en, this message translates to:
  /// **'You are signing an incidental direct debit, we will only debit from your account when you use the Givt app to make a donation.\n \n\n By continuing, you agree that you are the account holder and are the only person required to authorise debits from this account.\n \n\n The details of your Direct Debit Instruction mandate will be sent to you by e-mail within 3 working days or no later than 10 working days before the first collection.'**
  String get bacsSetupBody;

  /// No description provided for @bacsUnderstoodNotice.
  ///
  /// In en, this message translates to:
  /// **'I have read and understood the advance notice'**
  String get bacsUnderstoodNotice;

  /// No description provided for @bacsVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your details'**
  String get bacsVerifyTitle;

  /// No description provided for @bacsVerifyBody.
  ///
  /// In en, this message translates to:
  /// **'If any of the above is incorrect, please abort the registration and change your \'Personal information\'\n \n\n The company name which will appear on your bank statement against the Direct Debit will be Givt Ltd.'**
  String get bacsVerifyBody;

  /// No description provided for @bacsReadDdGuarantee.
  ///
  /// In en, this message translates to:
  /// **'Read Direct Debit Guarantee'**
  String get bacsReadDdGuarantee;

  /// No description provided for @bacsDdGuarantee.
  ///
  /// In en, this message translates to:
  /// **'- The Guarantee is offered by all banks and building societies that accept instructions to pay Direct Debits.\n - If there are any changes to the way this incidental Direct Debit Instruction is used, the organisation will notify you (normally 10 working days) in advance of your account being debited or as otherwise agreed. \n - If an error is made in the payment of your Direct Debit, by the organisation, or your bank or building society, you are entitled to a full and immediate refund of the amount paid from your bank or building society.\n - If you receive a refund you are not entitled to, you must pay it back when the organisation asks you to.\n - You can cancel a Direct Debit at any time by simply contacting your bank or building society. Written confirmation may be required. Please also notify the organisation.'**
  String get bacsDdGuarantee;

  /// No description provided for @bacsAdvanceNotice.
  ///
  /// In en, this message translates to:
  /// **'You are signing an incidental, non-recurring Direct Debit Instruction mandate. Only on your specific request will debits be executed by the organisation. All the normal Direct Debit safeguards and guarantees apply. No changes in the use of this Direct Debit Instruction can be made without notifying you at least five (5) working days in advance of your account being debited.\n In the event of any error, you are entitled to an immediate refund from your bank or building society. \n You have the right to cancel a Direct Debit Instruction at any time by writing to your bank or building society, with a copy to us.'**
  String get bacsAdvanceNotice;

  /// No description provided for @bacsAdvanceNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Advance Notice'**
  String get bacsAdvanceNoticeTitle;

  /// No description provided for @bacsDdGuaranteeTitle.
  ///
  /// In en, this message translates to:
  /// **'Direct Debit Guarantee'**
  String get bacsDdGuaranteeTitle;

  /// No description provided for @bacsVerifyBodyDetails.
  ///
  /// In en, this message translates to:
  /// **'Name: {value0}\n Address: {value1}\n E-mail address: {value2}\n Sort code: {value3}\n Account number: {value4}\n Frequency type: Incidental, when you use the Givt app to make a donation'**
  String bacsVerifyBodyDetails(
    Object value0,
    Object value1,
    Object value2,
    Object value3,
    Object value4,
  );

  /// No description provided for @bacsHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get bacsHelpTitle;

  /// No description provided for @bacsHelpBody.
  ///
  /// In en, this message translates to:
  /// **'Can\'t figure something out or you just have a question? Give us a call at +44 2037 908068 or hit us up on support@givt.co.uk and we will be in touch!'**
  String get bacsHelpBody;

  /// No description provided for @bacsSortcodeAccountnumber.
  ///
  /// In en, this message translates to:
  /// **'Sortcode: {value0}\n Account number: {value1}'**
  String bacsSortcodeAccountnumber(Object value0, Object value1);

  /// No description provided for @givingContextCollectionBag.
  ///
  /// In en, this message translates to:
  /// **'Collection device'**
  String get givingContextCollectionBag;

  /// No description provided for @givingContextQrCode.
  ///
  /// In en, this message translates to:
  /// **'QR code'**
  String get givingContextQrCode;

  /// No description provided for @givingContextLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get givingContextLocation;

  /// No description provided for @givingContextCollectionBagList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get givingContextCollectionBagList;

  /// No description provided for @amountPresetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Amount presets'**
  String get amountPresetsTitle;

  /// No description provided for @amountPresetsBody.
  ///
  /// In en, this message translates to:
  /// **'Set your amount presets below.'**
  String get amountPresetsBody;

  /// No description provided for @amountPresetsErrGivingLimit.
  ///
  /// In en, this message translates to:
  /// **'The amount is higher than your maximum amount'**
  String get amountPresetsErrGivingLimit;

  /// No description provided for @amountPresetsErr25C.
  ///
  /// In en, this message translates to:
  /// **'The amount has to be at least {value0}'**
  String amountPresetsErr25C(Object value0);

  /// No description provided for @amountPresetsErrEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get amountPresetsErrEmpty;

  /// No description provided for @alertSepaMessage.
  ///
  /// In en, this message translates to:
  /// **'Because you indicated {value0} as country choice, we assume that you prefer to give through BACS Direct Debit (£), we need your Sort Code and Account Number for that. If you prefer to use SEPA (€), we need your IBAN.'**
  String alertSepaMessage(Object value0);

  /// No description provided for @important.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get important;

  /// No description provided for @fingerprintTitle.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get fingerprintTitle;

  /// No description provided for @touchId.
  ///
  /// In en, this message translates to:
  /// **'Touch ID'**
  String get touchId;

  /// No description provided for @faceId.
  ///
  /// In en, this message translates to:
  /// **'Face ID'**
  String get faceId;

  /// No description provided for @touchIdUsage.
  ///
  /// In en, this message translates to:
  /// **'This is where you change the use of your Touch ID to login into the Givt app.'**
  String get touchIdUsage;

  /// No description provided for @faceIdUsage.
  ///
  /// In en, this message translates to:
  /// **'This is where you change the use of your Face ID to login into the Givt app.'**
  String get faceIdUsage;

  /// No description provided for @fingerprintUsage.
  ///
  /// In en, this message translates to:
  /// **'This is where you change the use of your fingerprint to login into the Givt app.'**
  String get fingerprintUsage;

  /// No description provided for @offlineGiftsTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline donations'**
  String get offlineGiftsTitle;

  /// No description provided for @amountTooHigh.
  ///
  /// In en, this message translates to:
  /// **'Amount too high'**
  String get amountTooHigh;

  /// No description provided for @loginFailure.
  ///
  /// In en, this message translates to:
  /// **'Login error'**
  String get loginFailure;

  /// No description provided for @requestFailed.
  ///
  /// In en, this message translates to:
  /// **'Request failed'**
  String get requestFailed;

  /// No description provided for @resetPasswordSent.
  ///
  /// In en, this message translates to:
  /// **'You should have received an e-mail with a link to reset your password. In case you do not see the e-mail right away, check your spam.'**
  String get resetPasswordSent;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success;

  /// No description provided for @notSoFast.
  ///
  /// In en, this message translates to:
  /// **'Not so fast, big spender'**
  String get notSoFast;

  /// No description provided for @giftBetween30Sec.
  ///
  /// In en, this message translates to:
  /// **'You already gave within 30 seconds. Can you wait a little?'**
  String get giftBetween30Sec;

  /// No description provided for @nonExistingEmail.
  ///
  /// In en, this message translates to:
  /// **'We have not seen this e-mail address before. Is it possible that you registered with a different e-mail account?'**
  String get nonExistingEmail;

  /// No description provided for @amountTooLow.
  ///
  /// In en, this message translates to:
  /// **'Amount too low'**
  String get amountTooLow;

  /// No description provided for @qrScanFailed.
  ///
  /// In en, this message translates to:
  /// **'Aiming failed'**
  String get qrScanFailed;

  /// No description provided for @cancelFailed.
  ///
  /// In en, this message translates to:
  /// **'Cancel failed'**
  String get cancelFailed;

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get accessDenied;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @mandateFailed.
  ///
  /// In en, this message translates to:
  /// **'Authorization failed'**
  String get mandateFailed;

  /// No description provided for @qrScannedOutOfApp.
  ///
  /// In en, this message translates to:
  /// **'Hey! Great that you want to give with a QR code! Are you sure you would like to give to {value0}?'**
  String qrScannedOutOfApp(Object value0);

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Saving failed'**
  String get saveFailed;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid e-mail address'**
  String get invalidEmail;

  /// No description provided for @giftsOverviewSent.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent your donations overview to your mailbox.'**
  String get giftsOverviewSent;

  /// No description provided for @downloadYearOverviewByChoice.
  ///
  /// In en, this message translates to:
  /// **'Do you want to download an annual overview of your donations? Choose the year below and we will send the overview to'**
  String get downloadYearOverviewByChoice;

  /// No description provided for @mandateFailTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while generating the mandate. Can you try again later?'**
  String get mandateFailTryAgainLater;

  /// No description provided for @termsTextGb.
  ///
  /// In en, this message translates to:
  /// **'GIVT LTD \n\nTerms of use – Givt app \nLast updated: 24-11-2023\nVersion: 1.5\n\n1.  \tGeneral \nThese terms of use describe the conditions under which the mobile application Givt (\"Givt\") can be utilised. Givt allows the User (anonymously) to give donations through their smartphone, for example churches, fundraising campaigns or charities that are members of Givt Ltd.  \n\nThese terms of use apply to the use of Givt. Through the use of Givt (which means the download and the installation thereof), you (\"the User\") accept these terms of use and our privacy policy (https://givt.co.uk/privacystatementgivt-service). These terms of use and our privacy policy are also available on our website to download and print. We may revise these terms of use from time to time. \n\n2.  \tLicense and intellectual property rights \n\n2.1\tAll rights to Givt, the accompanying documentation and all modifications and extensions thereto as well as the enforcement thereof are and remain the property of Givt. The User is granted solely the rights and authorities and/or permissions ensuing from the effect of this agreement or which are assigned in writing, and you may not otherwise use, reproduce or publicly release Givt. \n\n2.2\tGivt grants the User a non-exclusive, non-sublicensable and non-transmittable license to use Givt. The User is not allowed to use Givt for commercial purposes. \n\n2.3  \tThe User may not provide Givt to third parties nor sell, rent, decompile, submit to reverse engineer or modify it without prior permission from Givt. Nor should the User, or let others, remove or bypass the technical provisions that are intended to protect Givt. \n\n2.4 \tGivt has the right to change Givt at any time, modify or remove data, deny the User the use of Givt by termination of the license, limitation of the use of Givt or deny access to Givt in whole or in part, temporarily or permanently. Givt will inform the User about this in an appropriate manner. \n\n2.5 \tThe User acquires no right, title or interest to the intellectual property rights and/or similar rights to (the means of) Givt, including the underlying software and content.\n\n3. \tThe use of Givt \n\n3.1 \tThe User can only give donations to churches, charities, fundraising campaigns and/or other legal entities that are affiliated with Givt. The donations are done anonymously. \n\n3.2  \tThe use of Givt is at your own risk and expense and should be used in accordance with the purposes for which it is intended. It is prohibited to reverse engineer the source code of Givt or to decompile and/or modify Givt, to make a copy of Givt available to any third party or to remove, delete or render illegible any designations of Givt as the party holding rights to Givt or parts thereof.\n\n3.3\tThe User is responsible for the correct submission of data such as name and address details, bank account number and other information as requested by Givt to ensure the use of Givt. \n\n3.4\tIf the User is under the age of 18 they must have the consent of their parent or legal guardian in order to use Givt. By accepting these terms of use, the User guarantees that they are 18 years of age or have the permission of their parents or legal representative. \n\n3.5 \tGivt is available for the operating systems Android and iOS. In addition to the provisions set out below, Apple’s App Store or Google Play may attach conditions to the acquisition of Givt, its use and related matters. For further information, see the terms of use and privacy policy of Apple’s App Store and Google Play as well as any other applicable terms and conditions appearing on the website of the respective provider. This end user licence is applicable to the agreement between the User and Givt and does not apply between the User and the provider of the platform through which you acquired Givt. That provider may hold you liable for violation of provisions in this end user licence, however.\n\n3.6\tAfter the User has downloaded Givt, the User is requested to register. In doing so, the User must provide the following information: (i) name (ii) address, (iii) phone number, (iv) bank account number, and (v) e-mail address. The privacy policy of Givt is applied to the processing of personal data via Givt. The User must inform Givt immediately if any of this data changes by correcting the information within the app.\n\n3.7\tThe User may, after installing the Givt app, also choose to only enter an e-mail address and immediately use the app to donate. After the donation, the User will be asked to complete the registration procedure. If the User wishes to do so later, Givt ensures to only use the User\'s e-mail address to remind the User to finish the registration procedure until this procedure is finalised.\n\n3.8 \tThe User is responsible for any expenses related to the equipment, software system and (internet) connection to make use of Givt.\n\n3.9 \tGivt provides the related services based on the information the User submits. The User is obliged to provide correct and complete information, which is not false or misleading. The User may not provide data with respect to names or bank accounts for which the User is not authorised to use. Givt and the Processor have the right to validate and verify the information the User has provided. \n\n3.10 \tThe User may at any time terminate the use of Givt, by deleting their account via the menu in the app or via mail to support@givt.app. Deleting the app from the smartphone without following aforementioned steps will not result in deletion of the User’s data. Givt can terminate the relationship with the User if the User does not comply with these terms and conditions or if Givt has not been used for 18 consecutive months. On request Givt can send a listing of all donation data. \n\n3.11 \tGivt does not charge fees for the use of Givt. \n\n3.12\tGivt has the right to adjust the offered functionalities from time to time to improve, to change or to fix errors. Givt will always work to fix errors within the Givt software, but cannot guarantee that all errors, whether or not in a timely fashion, be restored. \n\n4. \tProcessing transactions and Protecting your money\n\n4.1 \tGivt does not provide banking or payment services. To facilitate the processing of donations from the User, Givt has entered into an agreement with Access Paysuite Ltd, an Electronic Money Institution, authorised and regulated by the Financial Conduct Authority (FRN 730815) (“Access PaySuite”)(the \"Processor\"). Givt will, after the collection of donations, ensure the payment of donations to the user-designated beneficiary. The transaction data will be processed and forwarded to the Givt Processor. The Processor will initiate payment transactions whereas Givt is responsible for the transaction of the relevant amounts to the bank account of the Church/Charity as being the user-designated beneficiary of the donation.\n\n4.2 \tThe User agrees that Givt may pass the User’s (transaction and bank) data to the Processor, along with all other necessary account and personal information of the User, in order to enable the Processor to initiate the payment transactions and processing. Givt reserves the right to change the Processor at any time. The User agrees that Givt may forward the relevant information and data about the User as defined in article 4.2 to the new Processor to be able to continue processing payment transactions. \n\n4.3 \tGivt and the Processor will process the data of the User in accordance with the law and regulations that apply to data protection. For further information on how personal data is collected, processed and used, Givt refers the User to its privacy policy. This can be found at: (https://givt.co.uk/privacystatementgivt-service/).\n\n4.4 \tThe donations of the User will pass through Access PaySuite. Givt will ensure that the funds will be transferred to the beneficiary, with whom Givt has an agreement. \n\n4.5 \tThe User can reverse a debit at any time, within the terms of the User\'s bank, and the direct debit scheme. \n\n4.6 \tGivt and/or the Processor can refuse a donation if there are reasonable grounds to believe that a user is acting in violation of these terms or if there are reasonable grounds to believe that a donation is possibly suspicious or illegal. In this case Givt will inform the User as soon as possible, unless prohibited by law. \n\n4.7\tUsers of the Givt app will not be charged for their donations through our platform. Givt and the receiving party have made separate compensation arrangements pursuant to the agreement in effect between them.\n\n4.8 \tThe User agrees that Givt may pass transactional data of the User to the HMRC, along with all other necessary account and personal information of the User, in order to assist the User with their annual tax return.   \n\n4.9\tWe will hold your money in a Client Funds Account, provided by Access PaySuite. The account is segregated from our own assets. The money contained in the Client Funds Account cannot be used by Givt, invested or lent to third parties, or in any way form part of Givt’s assets.\n\n4.10\tCurrent Regulatory Provisions exclude money placed on a Client Funds Account from the UK Financial Services Compensation Scheme (FSCS).\n\n4.11\tMoney placed or held in the Client Funds Account shall not constitute a deposit (within the meaning of Article 5 of Directive 2006/48/EC) and does not earn interest.\n4.12\tDeposits and, in particular, withdrawals from the Client Funds Account will only be made in the following circumstances:\n\nIn the case of deposits:\n\nTo receive money intended for onward payment to the designated charity/charities or church(es)\nTo replenish the account where fees or other costs associated with running the account have been deducted\nTo receive refunds in the event that prior instruction to make a payment by you is cancelled, in accordance with these Terms and Conditions\n\nIn the case of withdrawals:\n\nTo pay designated charities and churches, in accordance with your instructions\nTo pay fees or other costs associated with running the account\nTo return money to you, in the event that prior instruction to make a payment by you is canceled, in accordance with these Terms and Conditions.\n\n5. \tSecurity, theft and loss \n\n5.1 \tThe User shall take all reasonable precautions safekeeping their login credentials for Givt to avoid loss, theft, misappropriation or unauthorised use of Givt on their device.\n\n5.2 \tThe User is responsible for the security of their device. Givt considers any donation from the Givt account as a user-approved transaction, regardless of the rights of the User under article 4.5.\n\n5.3 \tThe User shall inform Givt immediately via info@givt.app or +44 20 3790 8068 once their device is lost or stolen. Upon receipt of a message Givt will block the account to prevent (further) misuse. \n\n6.\tUpdates\n\n6.1\tGivt releases updates from time to time, which can rectify errors or improve the functionality of Givt. Available updates for Givt will be announced by means of notification through Apple’s App Store and Google Play and it is the User’s sole responsibility to monitor these notifications and keep informed about new updates.\n\n6.2\tAn update can stipulate conditions, which differ from the provisions in this agreement. The User will always be notified in advance so that they have the opportunity to refuse the update. By installing such an update, the User agrees to these new conditions, which will then form part of this agreement. If User does not agree to the changed conditions, they will have to cease using Givt and delete Givt from their device.\n\n7. \tLiability \n\n7.1 \tGivt has been compiled with the utmost care. Although Givt strives to make Givt available 24 hours a day, it accepts no liability if, for any reason, Givt is not available at any given time or for a certain period of time. Givt reserves the right to temporarily or permanently discontinue Givt (unannounced). The User cannot derive any rights from this. \n\n7.2 \tGivt is not liable for damage or injury resulting from the use of Givt. The limitations of liability as mentioned in this article shall lapse if the liability for damage is the result of intent or gross negligence on the part of Givt.\n\n7.3 \tThe User indemnifies Givt against any claim from third parties (for example, beneficiaries of the donations or HMRC) as a result of the use of the Givt or not correctly meeting the agreements made concerning legal or contractual obligations with Givt. The User will pay all damages and costs to Givt as a result of such claims.\n\n8. \tOther provisions \n\n8.1 \tThis agreement comes into effect on commencement of the use of Givt and will remain in force for an undetermined period from that moment. This agreement may be terminated by the User as well as by Givt at any moment, subject to one month’s notice. This agreement will end by operation of law in the event you are declared bankrupt, you apply for a moratorium on payments or a general attachment is levied against your assets, in the event of your death, or in the event you go into liquidation, are wound up or dissolved. Following the termination of this agreement (for whatever reason), you shall cease and desist from all further use of Givt. You must then delete all copies (including back-up copies) of Givt from all your devices.\n\n8.2\tIf any provision of these terms and conditions is void or destroyed, this will not affect the validity of the agreement as a whole, and other provisions of these terms remain in force. In that case, the parties will decide on a new replacement provision or provisions which will be in line with the intention of the original agreement as far as is legally possible.\n\n8.3 \tThe User is not allowed to transfer the rights and/or obligations arising from the use of Givt and these terms to third parties without prior written permission of Givt. Conversely, Givt is allowed to do so. \n\n8.4 \tWe will endeavor to resolve the dispute amicably. Any disputes arising from or in connection with these terms and conditions are finally settled in the Courts of England and Wales. \n\n8.5  \tThe Law of England and Wales is applicable on these terms of use. \n\n8.6 \tThe terms of use shall not affect the User\'s statutory rights as a consumer.\n\n8.7 \tGivt features an internal complaints procedure. Givt handles complaints efficiently and as soon as reasonably possible. Any complaint about the implementation of these conditions by Givt must be submitted in writing at Givt (via support@givt.app).\n\n\n'**
  String get termsTextGb;

  /// No description provided for @firstCollect.
  ///
  /// In en, this message translates to:
  /// **'1st collection'**
  String get firstCollect;

  /// No description provided for @secondCollect.
  ///
  /// In en, this message translates to:
  /// **'2nd collection'**
  String get secondCollect;

  /// No description provided for @thirdCollect.
  ///
  /// In en, this message translates to:
  /// **'3rd collection'**
  String get thirdCollect;

  /// No description provided for @addCollect.
  ///
  /// In en, this message translates to:
  /// **'Add a collection'**
  String get addCollect;

  /// No description provided for @policyTextGb.
  ///
  /// In en, this message translates to:
  /// **'Latest Amendment: 24-09-2021\n Version 1.9\n \n\n Givt Limited Privacy Policy  \n \n\n Introduction\n This Privacy Policy outlines Givt Limited’s (\" we \", \" our \" or \" the Company \") practices with respect to information collected from our Application (“App”) or from users that otherwise share personal information with us (collectively: \"Users\"). \n \n\n Grounds for data collection \n \n\n Processing of your personal information (meaning, any information which may potentially allow your identification with reasonable means; hereinafter \"Personal Information\") is necessary for the performance of our contractual obligations towards you and providing you with our services, to protect our legitimate interests and for compliance with legal and financial regulatory obligations to which we are subject.\n \n\n When you use our App or register yourself or an organisation you represent with us, you consent to the collection, storage, use, disclosure and other uses of your Personal Information as described in this Privacy Policy.\n \n\n We encourage our Users to carefully read the Privacy Policy and use it to make informed decisions. \n \n\n What information do we collect?\n \n\n We collect two types of data and information from Users. \n \n\n The first type of information is un-identified and non-identifiable information pertaining to a User(s), which may be made available or gathered via your use of the App (“ Non-personal Information ”). We are not aware of the identity of a User from which the Non-personal Information was collected. Non-personal Information which is being collected may include your aggregated usage information and technical information transmitted by your device, including certain software and hardware information (e.g. language preference, access time, etc.) in order to enhance the functionality of our App.\n \n\n The second type of information is Personal Information, which is personally identifiable information, namely information that identifies an individual or may with reasonable effort identify an individual. Such information includes:\n Device Information: We collect Personal Information from your device. Such information includes geolocation data, IP address, unique identifiers (e.g. MAC address and UUID) and other information which relates to your activity through the App.\n Service User Information: We collect additional information for individuals who would like to use our Services. This is gathered through the App and includes all the information needed to register for our service: \n Name and address, \n Date of birth, \n e-mail address, \n secured password details, and \n bank details for the purposes of making payments.\n Contact information: If you choose to contact us you will be asked to provide us with certain details such as: full name; e-mail or physical address, and other relevant information. This may be for yourself or for people in the organisation you represent.\n  \n How do we receive information about you?\n We receive your Personal Information from various sources:\n \n\n When you voluntarily provide us your personal details in order to register on our App;\n When you use or access our App in connection with your use of our services;\n From third party providers, services and public registers (for example, traffic analytics vendors).\n Through diagnostic information from the App. The App will send us anonymous information about its functioning. This information contains non-personal data from your smartphone like its type and operating system, but also the version information of the App. This data is solely used for purposes of improving our Service or allowing better responses to your questions. This information will never be shared with third-parties. \n What do we do with the information we collect?\n We do not rent, sell, or share Users’ information with third parties except as described in this Privacy Policy.\n \n\n We may use the information for the following:\n To provide the services through the App – we will use a minimum of name and bank details to perform the services of effecting payment(s) via the App. Such information is never shared with intended recipients of donations.;\n Communicating with you – sending you notices regarding our services, providing you with technical information and responding to any customer service issue you may have; to keep you informed of our latest updates and services;\n Conducting statistical and analytical activities, intended to improve the App and/or the App.\n \n\n In addition to the different uses listed above, we may transfer or disclose Personal Information to our subsidiaries, affiliated companies and subcontractors in relation to services that we provide to you.\n \n\n We may also disclose information if we have good faith to believe that disclosure of such information is helpful or reasonably necessary to: (i) comply with any applicable law, regulation, legal process or governmental request; (ii) enforce our policies (including our Agreement), including investigations of potential violations thereof; (iii) investigate, detect, prevent, or take action regarding illegal activities or other wrongdoing, suspected fraud or security issues; (iv) to establish or exercise our rights to defend against legal claims; (v) prevent harm to the rights, property or safety of us, our users, yourself or any third party; or (vi) for the purpose of collaborating with law enforcement agencies and/or in case we find it necessary in order to enforce intellectual property or other legal rights.\n \n\n User Rights\n You may request to: \n Receive confirmation as to whether or not personal information concerning you is being processed, and access your stored personal information, together with supplementary information. \n Receive a copy of personal information you directly volunteer to us in a structured, commonly used and machine-readable format. \n Request rectification of your personal information that is in our control.\n Request erasure of your personal information. \n Object to the processing of personal information by us. \n Request to restrict processing of your personal information by us.\n Lodge a complaint with a supervisory authority.\n \n\n However, please note that these rights are not absolute, and may be subject to our own legitimate interests and regulatory requirements. \n \n\n If you have any questions about this Privacy Policy, please contact us:\n \n\n By e-mail: support@givt.app\n By visiting this page on our Website: https://givt.co.uk/faq-3/\n By phone number: +44 20 3790 8068.\n \n\n Retention\n We will retain your personal information for as long as necessary to provide our services, and as necessary to comply with our legal obligations, resolve disputes, and enforce our policies. Retention periods will be determined taking into account the type of information that is collected and the purpose for which it is collected, bearing in mind the requirements applicable to the situation and the need to destroy outdated, unused information at the earliest reasonable time. Under applicable regulations, we will keep records containing client personal data, account opening documents, communications and anything else as required by applicable laws and regulations. \n \n\n We may rectify, replenish or remove incomplete or inaccurate information, at any time and at our own discretion.\n \n\n Use of Location Services\n \n\n The App may use the location services as provided by the operating system on the smartphone. With these services, the App may determine the location of the user. The location data will not be sent anywhere outside the smartphone, and is solely used to determine whether the user is in a location where it’s possible to use the App for donating. The locations where one can use App are downloaded to the smartphone prior to using the location services.\n \n\n How do we safeguard your information?\n \n\n We take security measures to reduce misuse of and unauthorised access to personal data. We take the following measures in particular:\n \n\n Access to personal data requires the use of a username and password\n Access to personal data requires the use of a username and login token\n We make use of secure connections (Secure Sockets Layer of SSL) to encrypt all information between you and our website when entering your personal data.\n We keep logs of all requests for personal data.\n \n\n Although we take reasonable steps to safeguard information, we cannot be responsible for the acts of those who gain unauthorised access or abuse our App, and we make no warranty, express, implied or otherwise, that we will prevent such access.\n \n\n Transfer of data outside the EEA \n Please note that some data recipients may be located outside the EEA. In such cases we will transfer your data only to such countries as approved by the European Commission as providing adequate level of data protection, or enter into legal agreements ensuring an adequate level of data protection.\n \n\n Advertisements\n We do not use third-party advertising technology to serve advertisements when you access the App. \n \n\n Marketing\n We may use your Personal Information, such as your name, email address to send you a Newsletter about our products and services. You may opt out of receiving this Newsletter at any time by unsubscribing via the link.\n \n\n Providing Data to Third Parties\n We may provide your information to our partners. These partners are involved in the execution of the agreement. In all cases, these parties are necessary to provide the services. These are not the collecting authorities, as we protect the anonymity of users.\n You agree that the transaction data are anonymous and can be used for data collection, statistics, reviews and comparisons. Only the summary will be shared with other customers and we ensure you that none of your data will be traceable to individuals.\n \n\n We will also never sell data to third parties. We are only committed to make it easier for the donor to give to charities of their choosing.\n \n\n Updates or amendments to this Privacy Policy\n We reserve the right to periodically amend or revise the Privacy Policy; material changes will be effective immediately upon the display of the revised Privacy policy. The last revision will be reflected in the \"Last modified\" section. Your continued use of our Services following the notification of such amendments on our Website or through the App, constitutes your acknowledgment and consent of such amendments to the Privacy Policy and your agreement to be bound by the terms of such amendments.\n \n\n How to contact us\n \n\n If you have any general questions about the App or the information we collect about you and how we use it, you can contact us at: support@givt.app\n \n\n or\n \n\n By visiting this page on our Website: https://givt.co.uk/faq-3/\n By phone number: +44 20 3790 8068.\n \n\n Givt Ltd. is a part of Givt B.V., our office is located on the Bongerd 159 in Lelystad, the Netherlands.\n Company Number (CRN): 11396586'**
  String get policyTextGb;

  /// Ik heb hier de punt weggehaald, omdat ik vermoed dat ik die zelf ten onrechte had geplaatst. Als die hier bewust wel was geplaatst, dan hoor ik het graag.
  ///   "Bedrag" titel op het geef bedrag scherm
  ///
  /// In en, this message translates to:
  /// **'Choose amount'**
  String get amount;

  /// "Bepaal je geeflimiet" ; bij registratie van het geeflimiet
  ///
  /// In en, this message translates to:
  /// **'Determine the maximum amount of your Givt'**
  String get amountLimit;

  /// Algemene "Annuleren" knop
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// "Stad" placeholder bij het invoeren van je stad bij de registratie
  ///
  /// In en, this message translates to:
  /// **'City/Town'**
  String get city;

  /// "Land" placeholder bij de keuze van het land bij registratie
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// E-mail placeholder
  ///
  /// In en, this message translates to:
  /// **'E-mail address'**
  String get email;

  /// "Voornaam" placeholder bij de registratie
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// Wachtwoord vergeten? knop bij de login-pagina
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// Titeltekst op de vergeet wachtwoord pagina
  ///
  /// In en, this message translates to:
  /// **'Enter your e-mail address. We will send you an e-mail with the information on how to change your password.\n \n\n If you can\'t find the e-mail right away, please check your spam.'**
  String get forgotPasswordText;

  /// "Geven" op de Geef pagina waar je je bedrag kiest
  ///
  /// In en, this message translates to:
  /// **'Give'**
  String get give;

  /// Op afstand geven en het bedrag overmaken is volgens mij niet hetzelfde!!
  ///   "Op afstand geven" knop; wordt getoond op de pagina wanneer het scannen niet lukt
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectReceiverButton;

  /// "Geeflimiet" knop bij de instellingen
  ///
  /// In en, this message translates to:
  /// **'Maximum amount'**
  String get giveLimit;

  /// Nu staat overal doorgaan ipv inloggen, was dat de bedoeling? Of moest het enkel in het registratiegelukt-scherm veranderd worden?
  ///   Inloggen tekst op de inlog knop
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Ik vind toegang ontvangen vreemd klinken.
  ///   Titel op de login-pagina
  ///
  /// In en, this message translates to:
  /// **'To get access to your account we would like to make sure that you are you.'**
  String get loginText;

  /// Uitloggen knop
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logOut;

  /// "collectemiddel" blijft vreemd. Alternatieven: "collectebus of -zak" of "inzamelobject" of "Givt logo"
  ///   Titel op de scanpagina
  ///
  /// In en, this message translates to:
  /// **'This is the Givt-moment.\n Move your phone towards the \n collection box, bag or basket.'**
  String get makeContact;

  /// "Volgende" knop
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Wachtwoord placeholder bij registratie
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// tekens, waaronder
  ///   Wachtwoord regel staat onder het wachtwoord veld
  ///
  /// In en, this message translates to:
  /// **'The password should contain at least 7 characters including at least one capital and one digit.'**
  String get passwordRule;

  /// Telefoonnummer placeholder bij registratie
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get phoneNumber;

  /// Postcode placeholder
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get postalCode;

  /// "Klaar'-knop bij het succesvol geven
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get ready;

  /// Kan dit leuker?
  ///   Titel op de tweede registratiepagina
  ///
  /// In en, this message translates to:
  /// **'In order to process your donations,\n we need some personal information.'**
  String get registerPersonalPage;

  /// Iets persoonlijker?
  ///   Titel op de registratie-gelukt pagina
  ///
  /// In en, this message translates to:
  /// **'Registration successful.\n Have fun giving!'**
  String get registrationSuccess;

  /// "Verstuur"-knop tekst
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// `@lennie, waarom is dit een aparte term? Ik ben exact dezelfde term eerder tegengekomen. En ik heb dus ook weer dezelfde vraag: Is dit alles wat een gebruiker krijgt?
  ///   Er ging iets verkeerd (algemene error)
  ///
  /// In en, this message translates to:
  /// **'Whoops, something went wrong.'**
  String get somethingWentWrong;

  /// Placeholder voor Straat en huisnummer
  ///
  /// In en, this message translates to:
  /// **'Street name and number'**
  String get streetAndHouseNumber;

  /// "Nogmaals proberen" knop op de geef mislukt pagina
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// Kan dit leuker?
  ///   Foutmelding die je te zien krijgt als je een verkeerd email of wachtwoord invoert
  ///
  /// In en, this message translates to:
  /// **'Invalid e-mail address or password. Is it possible that you registered with a different e-mail account?'**
  String get wrongCredentials;

  /// "Ja, graag"-knop, te zien als je kiest om touchid te gebruiken of niet
  ///
  /// In en, this message translates to:
  /// **'Yes, please'**
  String get yesPlease;

  /// Foutmelding dat de bluetooth niet aanstaat, is een popup
  ///
  /// In en, this message translates to:
  /// **'Switch on Bluetooth so you\'re ready to give to a collection.'**
  String get bluetoothErrorMessage;

  /// "Bewaar" in het nederlands, als gebruiker vanuit instellingen naar geeflimiet instellen gaat wordt dit een knop met "Bewaar", in de registratieflow blijft deze wel gewoon Volgende / Next
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// In registratieflow "Mijn persoonsgegevens mogen door Givt worden vastgelegd." => hierbij geeft gebruik toe dat hij givt toelaat z'n data op te slaan
  ///
  /// In en, this message translates to:
  /// **'Ok, Givt is permitted to save my data.'**
  String get acceptPolicy;

  /// Close-tekst op knop: registratieflow -> algemene voorwaarden knop rechtsboven "Sluiten"
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// De titel op de pagina met algemene voorwaarden
  ///
  /// In en, this message translates to:
  /// **'Our Terms of Use'**
  String get termsTitle;

  /// "De uitgebreide versie van de voorwaarden:" zie sketch registratieflow -> algemene voorwaarden
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get fullVersionTitleTerms;

  /// De algemene voorwaarden zelf (lange tekst, zie sketch)
  ///
  /// In en, this message translates to:
  /// **'Last updated: 26-05-2025\nEnglish translation of version 2.0\n\n1. ​General\nThese terms of use describe the conditions under which the mobile and web applications of Givt (\"Givt\") may be used. Givt enables the User to give (anonymous) donations via their smartphone and/or web browser to, for example, churches, funds, or foundations that are affiliated with Givt or with a third party with whom Givt partners. Givt is managed by Givt B.V., a private limited company, located in Lelystad (8212 BJ), at Bongerd 159, registered in the trade register of the Chamber of Commerce under number 64534421 (\"Givt B.V.\"). These terms of use apply to the use of Givt. By using Givt (which includes downloading and installing it or making a donation via the Givt website), you as a user (\"User\") accept these terms of use and our privacy statement (www.givtapp.net/privacyverklaring). These terms of use and our privacy statement can also be consulted, downloaded, and printed from our website. We may amend these terms of use from time to time.\n\n2. ​License and Intellectual Property Rights\n2.1 All rights to Givt, the accompanying documentation, and all modifications and extensions thereof and the enforcement thereof are and shall remain with Givt B.V. The User only obtains the user rights and powers that arise from the scope of these terms, and for the rest, you may not use, reproduce, or disclose Givt.\n2.2 Givt B.V. grants the User a non-exclusive, non-sublicensable, and non-transferable license for the use of Givt. The User is not permitted to use Givt for commercial purposes.\n2.3 The User may not make Givt available to third parties, sell, rent, decompile, subject to reverse engineering, or modify it without the prior consent of Givt B.V. Nor may the User remove or circumvent the technical provisions intended to protect Givt.\n2.4 Givt B.V. has the right at all times to modify Givt, change or delete data, deny the User the use of Givt by terminating the license, restrict the use of Givt, or deny access to Givt in whole or in part, temporarily or permanently. Givt B.V. will inform the User about this in a manner it deems appropriate.\n2.5 The User does not acquire any right, title, or interest in or to the intellectual property rights and/or similar rights to (the content of) Givt, including the underlying software and content.\n\n3.0 Use of Givt\n3.1 The User can only make donations to churches, foundations, funds, and/or other (legal) persons that are offered by Givt and have entered into a relationship with Givt B.V. or one of its partners. The donor is anonymous to the recipient, unless otherwise indicated.\n3.2 The use of Givt is at your own expense and risk and must be used in accordance with the purposes for which it is intended. It is not permitted to reverse engineer the source code of Givt or to decompile and/or modify Givt, to make Givt available to third parties, or to remove or make illegible any indications of Givt B.V. as the rights holder of Givt or parts thereof.\n3.3 The User is responsible for the correct provision of data such as name and address details, bank account number, and other data as requested by Givt B.V. to ensure the use of Givt.\n3.4 If the User is younger than 18 years old, they must have the consent of their parent or legal guardian to use Givt. By accepting these terms of use, the User guarantees that they are 18 years of age or older or have permission from their parents or legal guardian.\n3.5 The Givt app is available for the Android and iOS operating systems, and the web functionality is available for the most common and modern web browsers. In addition to the provisions below, Apple\'s App Store or Google Play may impose conditions on obtaining Givt, its use, and related matters. For this, please consult the terms of use and privacy statement of Apple\'s App Store and Google Play and any applicable conditions on the website of the respective provider. These terms of use apply to the agreement between the User and Givt B.V. and do not apply between the User and the provider of the platform through which you obtained Givt. However, these providers may hold the User accountable for violating provisions in these terms of use.\n3.6 After the User has downloaded Givt, the User must register. In doing so, the User must provide the following information: (i) name and address details, (ii) telephone number, (iii) bank account number, and (iv) email address. The processing of personal data via Givt is subject to the privacy statement of Givt B.V. In the event of any changes to data, the User must immediately adjust this via Givt.\n3.7 To be able to use Givt, the User must, at their own expense, provide the necessary equipment, system software, and (internet) connection.\n3.8 Givt B.V. provides the related services based on the information the User provides. The User is obliged to provide correct and complete information that is not false or misleading. The User may not provide data relating to names or bank accounts that the User is not authorized to use. Givt B.V. and the Processor have the right to validate and verify the information provided by the User.\n3.9 The User can terminate the use of Givt at any time by deleting their Givt account via the menu in the app, or via email to support@givtapp.net. Deleting the app on the smartphone without following these steps does not result in an automatic deletion of the User\'s data. Givt B.V. may terminate the relationship with the User if the User does not comply with these terms or if Givt is not used for 18 consecutive months. Upon request, Givt B.V. will send an overview of all donation data if this happens before the account is deleted by the User.\n3.10 Givt B.V. does not charge a fee for the use of Givt.\n3.11 Givt B.V. has the right to adjust the offered functionalities from time to time to improve or change them and to correct errors. Givt B.V. will make an effort to resolve any errors in the Givt software but cannot guarantee that all errors will be corrected, whether in a timely manner or not.\n\n4.0 Transaction Processing\n4.1 Givt B.V. is not a bank/financial institution and does not provide banking or payment processing services. To process the User\'s donations, Givt B.V. has therefore entered into an agreement with a payment service provider called Better World Payments, a financial institution (the \"Processor\"), in which it is agreed that Givt B.V. will send the transaction data to the Processor to initiate and handle donations. Givt B.V. will, after the collection of the donations, ensure the remittance of the donations to the beneficiary(s) appointed by the User. The transaction data will be processed by Givt and forwarded to the Processor. The Processor will initiate the payment transactions, and Givt B.V. is responsible for transferring the relevant amounts to a bank account of the church/foundation as designated by the User as the beneficiary of the donation.\n4.2 The User agrees that Givt B.V. may pass on the User\'s (transaction and bank) data to the Processor, along with all other necessary account and personal information of the User, to enable the Processor to initiate and process the payment transactions. Givt B.V. reserves the right to change its Processor at any time. The User agrees that Givt B.V. may forward relevant information about the User and the data as described in Article 4.2 to the new Processor in order to continue processing payment transactions.\n4.3 Givt B.V. and the Processor will process the User\'s data in accordance with the laws and regulations that apply to data protection. For further information on how personal data is collected, processed, and used, Givt B.V. refers the User to its privacy policy. This can be found online (www.givtapp.net/privacyverklaring).\n4.4 The User\'s donations are processed through Givt B.V. as an intermediary. Givt B.V. will then ensure that the funds are transferred to the beneficiary(s) with whom Givt B.V. has concluded an agreement.\n4.5 To make a donation via Givt, the User must issue an authorization to Givt B.V. and/or the Processor (for an automatic SEPA direct debit) or complete the transaction directly with another payment method. The User can at any time – within the conditions applied by the User\'s bank – reverse an automatic direct debit.\n4.6 A donation may be refused by Givt B.V. and/or the Processor if there are reasonable grounds to assume that a User is acting in violation of these terms or if there are reasonable grounds to assume that a donation may be suspicious or illegal. Givt B.V. will inform the User of this as soon as possible, unless this is prohibited by law.\n4.7 Users of the Givt app will not be charged any fees for their donations via our platform. Givt and the receiving party have made separate agreements regarding fees in their applicable agreement. In some cases, the User is offered the opportunity to make a voluntary platform contribution. When the User chooses to make this contribution, it is a gift to Givt B.V. and is not considered a cost. Givt B.V. uses this voluntary platform contribution to reduce the costs for foundations and churches at its own discretion.\n4.8 The User agrees that Givt B.V. may pass on the User\'s (transaction) data to the local tax authorities, along with all other necessary account and personal information of the User, to assist the User with their annual tax return.\n\n5.0 Security, Theft, and Loss\n5.1 The User must take all reasonable precautions to keep their login details for Givt secure to prevent loss, theft, misappropriation, or unauthorized use of Givt or their smartphone.\n5.2 The User is responsible for the security of their smartphone. Givt B.V. considers every donation from the User\'s Givt account to be a transaction approved by the User, regardless of the rights that the User has under Article 4.5.\n5.3 The User must immediately notify Givt B.V. via support@givtapp.net or +31 320 320 115 as soon as their smartphone is lost or stolen. Upon receipt of a notification, Givt B.V. will block the account to prevent (further) misuse.\n\n6.0 Updates\n6.1 Givt B.V. will release updates from time to time to improve the user experience, which may fix bugs or improve the functioning of Givt. Available updates for Givt will be announced via notifications through Apple\'s App Store and Google Play, and it is the sole responsibility of the User to keep track of these notifications.\n6.2 An update may impose conditions that deviate from those set out in these terms. This will always be communicated to the User in advance, and the User will have the opportunity to refuse the update. By installing such an update, the User agrees to these deviating conditions, which will then form part of these terms of use. If the User does not agree with the amended conditions, they must cease using Givt and remove Givt from their mobile phone and/or tablet.\n\n7.0 Liability\n7.1 Givt has been compiled with the greatest care. Although Givt B.V. strives to make Givt available 24 hours a day, it accepts no liability if, for any reason, Givt is not available at a certain time or for a certain period. Givt B.V. reserves the right to discontinue Givt (unannounced) temporarily or permanently, without the User being able to derive any rights from this.\n7.2 Givt B.V. is not liable for damage or injury resulting from the use of Givt. The limitations of liability as mentioned in this article shall not apply if the liability for damage is the result of intent or gross negligence on the part of Givt B.V.\n7.3 The User indemnifies Givt B.V. against all possible claims from third parties (for example, beneficiaries of the donations or the tax authorities) as a result of the use of Givt or the failure to comply, or to comply correctly, with legal or contractual obligations towards Givt B.V. The User will reimburse Givt B.V. for all damages and costs that Givt B.V. suffers as a result of such claims.\n\n8.0 Other Provisions\n8.1 These terms of use come into effect upon the use of Givt, including the online web services that Givt makes available, and then remain in force for an indefinite period. The agreement may be terminated by either the User or Givt B.V. at any time with a notice period of one month. This agreement terminates automatically if the User: (i) is declared bankrupt, (ii) applies for a moratorium on payments or if a general seizure of the User\'s assets is made, (iii) the User passes away, (iv) goes into liquidation, is dissolved, or is wound up. After termination of the agreement (for whatever reason), the User must cease and desist all use of Givt. The User must then remove all copies (including backup copies) of Givt from all of their systems.\n8.2 If any provision of these terms is void or nullified, this does not affect the validity of the entire agreement, and the other provisions of these terms will remain in force. In that case, the parties will establish (a) new provision(s) to replace it, giving shape to the intention of the original agreement as much as is legally possible.\n8.3 The User is not permitted to transfer rights and/or obligations arising from the use of Givt and these terms to third parties without the prior written consent of Givt B.V. Conversely, Givt B.V. is permitted to do so.\n8.4 Any disputes arising from or in connection with these terms will be finally settled by the court of Lelystad. Before the dispute is referred to the court, you and we will endeavor to resolve the dispute amicably.\n8.5 Dutch law applies to these Terms of Use.\n8.6 The Terms of Use do not prejudice the User\'s mandatory statutory rights as a consumer.\n8.7 Givt B.V. has an internal complaints procedure. Givt B.V. handles complaints efficiently and as soon as is reasonably possible. If the User has a complaint about the implementation of these terms by Givt B.V., the User must submit it in writing to Givt B.V. (via support@givtapp.net).'**
  String get termsText;

  /// De tekst van de privacy policy waar de gebruiker akkoord mee moet gaan.
  ///
  /// In en, this message translates to:
  /// **'Last updated: May 26, 2025\nTranslation of original: 2.0\nPrivacy Statement of the Givt Service\n\nThrough the Givt service – consisting of both an app and an online platform – sensitive data, or personal data, is processed. Givt B.V. considers the careful handling of personal data to be of great importance. Therefore, we process and secure personal data with care.\n\nIn our processing, we comply with the requirements of the General Data Protection Regulation (GDPR). This means, among other things, that we:\n- clearly state the purposes for which we process personal data;\n- limit our collection of personal data to only that which is necessary for legitimate purposes;\n- take appropriate security measures;\n- respect your rights (access, correction, deletion, objection);\n- only share data with third parties when necessary or legally required;\n- guarantee the anonymity of donors towards charities.\n\n1. Data Controller\nGivt B.V. is the data controller for all data processing within the app and the platform. Our processing is registered with the Dutch Data Protection Authority (Autoriteit Persoonsgegevens) under number M1640707. In this privacy statement, we explain which personal data we collect and use, and for what purpose. We recommend that you read it carefully.\n\nFor questions about this statement or your rights, you can contact us via info@givtapp.net.\n\n2. Use of Personal Data\nWhen using our services, we may process the following personal data:\n\nName, address, and city of residence (NAW)\nEmail address\nPhone number\nPayment details\nWe use this data for the following purposes and on the following legal bases:\n- Execution of donations – performance of a contract\n- Account registration and user convenience – legitimate interest\n- Sending newsletters – consent\n- Customer contact via contact form or email – legitimate interest\n- Analysis of user behavior (donation flow) – legitimate interest\n- Improving the service and app – legitimate interest\n- Compliance with legal obligations – legal basis\n\n3. Analysis of User Behavior\nWe collect behavioral data on how users use our app and online donation environment. This includes clicks on buttons, the flow of donation processes, and technical error messages. This helps us to improve usability and identify bottlenecks.\n\nFor these analyses, we use the tool Amplitude. This tool collects pseudonymized data and only links it to users with an account. We use this information exclusively internally. A data processing agreement has been concluded with Amplitude. Data is not sold or shared with third parties.\n\n4. Cookies\nOur website uses cookies and similar technologies. Cookies are only placed if you give your consent via our cookie banner. Functional cookies (for the functioning of the site) are always placed.\n\nWe use, among others, Google Analytics (with IP anonymization) to analyze website usage. The _ga cookie is stored for a maximum of 2 years.\n\nYou can always change your cookie preferences via our cookie banner or browser settings.\n\n5. Newsletter and Contact\nWe offer a newsletter to inform interested parties about our (new) products and/or services. Each newsletter contains a link to unsubscribe. Your email address is automatically added to the list of subscribers.\n\nIf you fill out a contact form or send an email, we will retain the data for as long as necessary for the complete handling of your query.\n\n6. Advertising\nIn addition to the information provided via our online service infrastructure, we may inform you about our new products and services by email.\n\n7. Provision to Third Parties\nWe only provide your data to third parties if this is necessary for the performance of our agreement, or if legally required. Examples include payment processors or hosting providers. We never sell your data and guarantee the anonymity of donors towards charities. Transaction data may be anonymized for statistical purposes.\n\n8. Data Security\nWe take security measures to limit misuse of and unauthorized access to personal data. Specifically, we take the following measures:\n- Access to personal data is protected by a username and password.\n- We use secure connections (TLS/SSL or Transport Layer Security/Secure Sockets Layer) that encrypt all information between you and our online service infrastructure when you enter personal data.\n- We keep logs of all requests for personal data.\n\n9. Use of Location Data\nThe app may use location data to determine if you are in a place where Givt can be used. This data is processed exclusively locally on your device and is not transmitted or stored.\n\n10. Diagnostic Information from the App\nThe app sends anonymized information about its operation. This information contains non-personal data from your smartphone, such as the type and operating system, as well as the app version. This data is used solely to improve the Givt service or to answer your questions more quickly. This information is never provided to third parties.\n\n11. Changes to this Privacy Statement\nWe may change this privacy statement from time to time. The most current version is always available on our website. We recommend that you consult this statement regularly.\n\n12. Accessing and Changing Your Data\nYou have the right to access your data, to have it corrected or deleted, to object to its processing, and to withdraw your consent. You can contact us at any time using the details below:\n\nGivt B.V.\nBongerd 159\n8212 BJ LELYSTAD\nThe Netherlands\n+31 320 320 115\ninfo@givtapp.net\nChamber of Commerce (KVK) no: 64534421'**
  String get policyText;

  /// "Hulp nodig?" op de hulppagina (titel)
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get needHelpTitle;

  /// "Vind hier antwoorden op je vragen en handige tips" : ondertitel op de helppagina
  ///
  /// In en, this message translates to:
  /// **'Here you\'ll find answers to your questions and useful tips'**
  String get findAnswersToYourQuestions;

  /// Vraag op de helppagina: "Hoe werkt het registreren?"
  ///
  /// In en, this message translates to:
  /// **'How does registration work?'**
  String get questionHowDoesRegisteringWorks;

  /// Vraag op de helppagina "Waarom worden mijn persoonsgegevens vastgelegd?"
  ///
  /// In en, this message translates to:
  /// **'Why does Givt store my personal information?'**
  String get questionWhyAreMyDataStored;

  /// Wat is Givt?
  ///
  /// In en, this message translates to:
  /// **'What is Givt?'**
  String get faQvraag1;

  /// Hoe werkt Givt?
  ///
  /// In en, this message translates to:
  /// **'How does Givt work?'**
  String get faQvraag2;

  /// Hoe wijzig ik mijn instellingen of gegevens?
  ///
  /// In en, this message translates to:
  /// **'How can I change my settings or personal information?'**
  String get faQvraag3;

  /// Waar kan ik Givt gebruiken?
  ///
  /// In en, this message translates to:
  /// **'Where can I use Givt?'**
  String get faQvraag4;

  /// Hoe wordt mijn Givt afgeschreven?
  ///
  /// In en, this message translates to:
  /// **'How will my donation be withdrawn?'**
  String get faQvraag5;

  /// Wat kan ik nog meer met Givt?
  ///
  /// In en, this message translates to:
  /// **'What are the possibilities using Givt?'**
  String get faQvraag6;

  /// Hoe veilig is geven met Givt?
  ///
  /// In en, this message translates to:
  /// **'How safe is donating with Givt?'**
  String get faQvraag7;

  /// Hoe kan ik mij afmelden voor Givt?
  ///
  /// In en, this message translates to:
  /// **'How can I delete my Givt account?'**
  String get faQvraag8;

  /// Antwoord op FAQ vraag1
  ///
  /// In en, this message translates to:
  /// **'Donating with your smartphone\n Givt is the solution for giving with your smartphone when you are not carrying cash. Everyone owns a smartphone and with the Givt app you can easily participate in the offering. \n It’s a personal and conscious moment, as we believe that making a donation is not just a financial transaction. Using Givt feels as natural as giving cash. \n \n\n Why \'Givt\'?\n The name Givt was chosen because it is about ‘giving’ as well as giving a ‘gift’. We were looking for a modern and compact name that looks friendly and playful. In our logo you might notice that the green bar combined with the letter ‘v’ forms the shape of an offering bag, which gives an idea of the function. \n \n\n The Netherlands, Belgium and the United Kingdom\n There is a team of specialists behind Givt, divided over the Netherlands, Belgium and the United Kingdom. Each one of us is actively working on the development and improvement of Givt. Read more about us on www.givtapp.net.'**
  String get faQantwoord1;

  /// Klopt dit?
  ///  Na inloggen komt er een melding in het scherm met ‘Verstuur openstaande Givts’. Door op deze melding te klikken geef je alsnog het bedrag dat je tijdens de collecte wilde geven.
  ///   Antwoord op FAQ vraag2
  ///
  /// In en, this message translates to:
  /// **'The first step was installing the app. For Givt to work effectively, it’s important that you enable Bluetooth and have a working internet connection. \n \n\n Then register yourself by filling in your information and signing a mandate. \n You’re ready to give! Open the app, select an amount, and scan a QR code, move your phone towards the collection bag or basket, or select a cause from the list.\n Your chosen amount will be saved, withdrawn from your account and distributed to the church or collecting charities.\n \n\n If you don’t have an internet connection when making your donation, the donation will be sent at a later time when you re-open the app. Like when you are in a WiFi zone.'**
  String get faQantwoord2;

  /// Je komt nu meteen in het betaalscherm. (ipv je komt nu gelijk in het betaalscherm)
  ///   Antwoord op FAQ vraag3
  ///
  /// In en, this message translates to:
  /// **'You can access the app menu by tapping the menu at the top left of the ‘Amount’ screen. To change your settings, you have to log in using your e-mail address and password, fingerprint/Touch ID or a FaceID. In the menu you can find an overview of your donations, adjust your maximum amount, review and/or change your personal information, change your amount presets, fingerprint/Touch ID or FaceID, or terminate your Givt account.'**
  String get faQantwoord3;

  /// Antwoord op FAQ vraag4
  ///
  /// In en, this message translates to:
  /// **'More and more organisations\n You can use Givt in all organisations that are registered with us. More organisations are joining every week.\n \n\n Not registered yet? \n If your organisation is not affiliated with Givt yet, please contact us at +44 2037 908068 or info@givt.app .'**
  String get faQantwoord4;

  /// Antwoord op FAQ vraag5
  ///
  /// In en, this message translates to:
  /// **'Better World Payments\n When installing Givt, the user gives the app authorisation to debit their account. The transactions are handled by Better World Payments – a bank that specialises in processing mandates.\n \n\n Revocable afterwards\n No transactions take place in the moment of giving. The transactions take place afterwards via a direct debit. Since these transactions are revocable, it is completely safe and immune to fraud.'**
  String get faQantwoord5;

  /// Antwoord op FAQ vraag6
  ///
  /// In en, this message translates to:
  /// **'Continues to develop\n Givt continues to develop their service. Right now you can easily give during the offering using your smartphone, but it doesn\'t stop there. Curious to see what we are working on? Join us for one of our Friday afternoon demos.\n \n\n Tax return\n At the end of the year you can request an overview of all your donations, which makes it easier for you when it comes to tax declaration. Eventually we would like to see that all donations are automatically filled in on the declaration.'**
  String get faQantwoord6;

  /// Antwoord op FAQ vraag7
  ///
  /// In en, this message translates to:
  /// **'Safe and risk free \n It is very important to us that everything is safe and risk free. Each user has a personal account with its own password. You need to login to view or change your settings.\n \n\n Handling transactions \n The transactions are handled by Better World Payments – a bank that specialises in processing mandates. \n \n\n Immune to fraud \n When installing Givt, the user gives the app authorisation to debit their account.\n We want to emphasise that no transactions take place in the moment of giving. The transactions take place afterwards via a direct debit. Since these transactions are revocable, it is completely safe and immune to fraud. \n \n\n Overview \n Organisations can login to the Givt dashboard. This dashboard gives an overview of all financial transactions, from the moment of giving up to the full processing of the payment. In this way any collection can be followed from start to finish.\n Organisations can see how many people used Givt, but not who they are.'**
  String get faQantwoord7;

  /// kunnen we dit deze sprint al aanpassen?
  ///   Antwoord op FAQ vraag8
  ///
  /// In en, this message translates to:
  /// **'We are sorry to hear that! We would like to hear why.\n \n\n If you no longer want to use Givt, you can unsubscribe for all Givt services.\n To unsubscribe, go to your settings via the user menu and choose ‘Terminate my account’.'**
  String get faQantwoord8;

  /// Titel op het scherm van de privacyverklaring
  ///
  /// In en, this message translates to:
  /// **'Privacy Statement'**
  String get privacyTitle;

  /// Tekst op het einde van de registratie "Bij het doorgaan ga je akkoord met de algemene voorwaarden."
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to our terms and conditions.'**
  String get acceptTerms;

  /// "Hoe werkt geven?" vraag in FAQ
  ///
  /// In en, this message translates to:
  /// **'How can I give?'**
  String get faqHowDoesGivingWork;

  /// "Hoe werkt handmatig geven?"
  ///
  /// In en, this message translates to:
  /// **'How can I select the recipient?'**
  String get faqHowDoesManualGivingWork;

  /// Cindy, die {0} stond daar express ...
  ///   Sorry, maar we nemen pas genoegen met minstens 0,50 euro.
  ///
  /// In en, this message translates to:
  /// **'Sorry, but the minimum amount we can work with is {value0}.'**
  String givtNotEnough(Object value0);

  /// SlimPay informatie onder het Givy icoon
  ///
  /// In en, this message translates to:
  /// **'That\'s why we ask you this one time to sign a SEPA eMandate.\n \n\n Since we\'re working with mandates, you have the option to revoke your donation if you should wish to do so.'**
  String get slimPayInformationPart2;

  /// Title van de pagina "Account opzeggen"
  ///
  /// In en, this message translates to:
  /// **'Terminate account'**
  String get unregister;

  /// Informatie op de "account opzeggen" pagina
  ///
  /// In en, this message translates to:
  /// **'We’re sad to see you go! We will delete all your personal information.\n \n\n There’s one exception: if you donated to a PBO-registered organisation, we are obligated to keep the information about your donation, your name and address for at least 7 years. Your e-mail address and phone number will be removed.'**
  String get unregisterInfo;

  /// Jammer dat je gaat
  ///
  /// In en, this message translates to:
  /// **'We\'re sad to see you leave\n and we hope to see you again.'**
  String get unregisterSad;

  /// Titel op de Historie pagina in de app
  ///
  /// In en, this message translates to:
  /// **'Donations history'**
  String get historyTitle;

  /// Titel op de infopagina van het Historiescherm
  ///
  /// In en, this message translates to:
  /// **'Donation details'**
  String get historyInfoTitle;

  /// Groene status bij de Historie infopagina
  ///
  /// In en, this message translates to:
  /// **'In process'**
  String get historyAmountAccepted;

  /// Status bij de historiepagina van gebruiker die geannuleerd heeft
  ///
  /// In en, this message translates to:
  /// **'Cancelled by user'**
  String get historyAmountCancelled;

  /// Status van bank die bedrag geweigerd heeft op de infopagina van de Historie
  ///
  /// In en, this message translates to:
  /// **'Refused by bank'**
  String get historyAmountDenied;

  /// Status op de infopagina van de Historie waar de instantie heeft geïncasseerd
  ///
  /// In en, this message translates to:
  /// **'Processed'**
  String get historyAmountCollected;

  /// Tekst op de giften historiek wanneer er geen gifts gegeven zijn.
  ///
  /// In en, this message translates to:
  /// **'This is where you\'ll find information about your donations, but first you\'ll need to start giving'**
  String get historyIsEmpty;

  /// Titel bovenaan een popup alert dat een nieuwe update beschikbaar is
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get updateAlertTitle;

  /// Bericht die in de alert zal staan omtrent een systeemupdate van Givt
  ///
  /// In en, this message translates to:
  /// **'A new version of Givt is available, do you want to update now?'**
  String get updateAlertMessage;

  /// Kritische update titel van het alert scherm
  ///
  /// In en, this message translates to:
  /// **'Critical update'**
  String get criticalUpdateTitle;

  /// Kritische update bericht onder de titel in de alert melding
  ///
  /// In en, this message translates to:
  /// **'A new critical update is available. This is necessary for the proper functioning of the Givt app.'**
  String get criticalUpdateMessage;

  /// Ja
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Nee
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Waar kan ik het overzicht van mijn giften bekijken?
  ///
  /// In en, this message translates to:
  /// **'Where can I see the overview of my donations?'**
  String get faQvraag9;

  /// antwoord-Waar kan ik het overzicht van mijn giften bekijken?
  ///
  /// In en, this message translates to:
  /// **'Press the menu at the top left of the ‘Amount’ screen to access your app menu. To get access you have to login using your e-mail address and password. Choose ‘Donations history’ to find an overview of your recent activity. This list consists of the name of the recipient, time, and date. The coloured line indicates the status of the donation: In process, processed, refused by bank, or cancelled by user.\n You can request an overview of your donations for your tax declaration at the end of each year.'**
  String get faQantwoord9;

  /// Question about passcode
  ///
  /// In en, this message translates to:
  /// **'How do I set my Touch ID or Face ID?'**
  String get faqQuestion11;

  /// Answer Passcode
  ///
  /// In en, this message translates to:
  /// **'Go to your settings by pressing menu in the top left of the screen. There you can protect your Givt app with a fingerprint/Touch ID or a FaceID (only available on certain iPhones). \n \n\n When one of these settings is activated, you can use it to access your settings instead of using your e-mail address and password.'**
  String get faqAnswer11;

  /// Antwoord op de vraag Hoe werkt registreren
  ///
  /// In en, this message translates to:
  /// **'To use Givt, you have to register in the Givt app. Go to your app menu and choose \'Finish registration\'. You set up a Givt account, fill in some personal details and give permission to collect the donations made with the app. The transactions are handled by Better World Payments - a bank that specialises in the treatment of permissions. When your registration is complete, you are ready to give. You only need your login details to see or change your settings.'**
  String get answerHowDoesRegistrationWork;

  /// Antwoord FAQ Hoe werkt geven?
  ///
  /// In en, this message translates to:
  /// **'From now on, you can give with ease. Open the app, choose the amount you want to give, and select 1 of the 4 possibilities: you can give to a collection device, scan a QR code, choose from a list, or give at your location. \n Don\'t forget to finish your registration, so your donations can be delivered to the right charity.'**
  String get answerHowDoesGivingWork;

  /// Antwoord FAQ hoe werkt ontvanger selecteren?
  ///
  /// In en, this message translates to:
  /// **'When you aren’t able to give to a collection device, you can choose to select the recipient manually. Choose an amount and press ‘Next’. Next, select ‘Choose from the list’ and select \'Churches\', \'Charities\', \'Campaigns\' or \'Artists\'. Now choose a recipient from one of these lists and press ‘Give’.'**
  String get answerHowDoesManualGivingWork;

  /// Informatie over waarom persoonlijke gegevens invullen.
  ///
  /// In en, this message translates to:
  /// **'Givt needs this personal data to process your gifts. We are careful with this information. You can read it in our privacy statement.'**
  String get informationPersonalData;

  /// Wie is Givt/NFCollect?
  ///
  /// In en, this message translates to:
  /// **'Givt is a product of Givt B.V.\n \n\n We are located on the Bongerd 159 in Lelystad, The Netherlands. For questions or complaints you can reach us via +31 320 320 115 or support@givtapp.net.\n \n\n We are registered in the trade register of the Dutch Chamber of Commerce under number 64534421.'**
  String get informationAboutUs;

  /// Over Givt
  ///
  /// In en, this message translates to:
  /// **'About Givt / Contact'**
  String get titleAboutGivt;

  /// Lees privacyverklaring
  ///
  /// In en, this message translates to:
  /// **'Read privacy statement'**
  String get readPrivacy;

  /// Hoe lang duurt het voor mijn gift wordt afgeschreven?
  ///
  /// In en, this message translates to:
  /// **'How long does it take before my donation is withdrawn from my bank account?'**
  String get faqQuestion12;

  /// Je gift wordt binnen twee werkdagen van je bankrekening afgeschreven.
  ///
  /// In en, this message translates to:
  /// **'Your donation will be withdrawn from your bank account within two working days.'**
  String get faqAnswer12;

  /// Hoe kan ik geven aan meerdere collectes
  ///
  /// In en, this message translates to:
  /// **'How can I give to multiple collections?'**
  String get faqQuestion14;

  /// antwoord meerdere collectesvraag
  ///
  /// In en, this message translates to:
  /// **'Are there multiple collections in one service? Even then you can easily give in one move!\n By pressing the ‘Add collection’-button, you can activate up to three collections. For each collection, you can enter your own amount. Choose your collection you want to adjust and enter your specific amount or use the presets. You can delete a collection by pressing the minus sign, located to the right of the amount.\n \n\n The numbers 1, 2 or 3 distinguish the different collections. No worries, your church knows which number corresponds to which collection purpose. Multiple collections are very handy, because all your gifts are sent immediately with your first donation. In the overview you can see a breakdown of all your donations.\n \n\n Do you want to skip a collection? Leave it open or remove it.'**
  String get faqAnswer14;

  /// belastingaangifte vraag
  ///
  /// In en, this message translates to:
  /// **'Are my Givt donations tax deductible?'**
  String get faQvraag15;

  /// antwoord op vraag15
  ///
  /// In en, this message translates to:
  /// **'Yes, your Givt donations are tax deductible, but only when you’re giving to institutions that are registered as ANBI (Public Benefit Organisation) or SBBI (Social Importance Organisation). Check if the church or institution has such a registration. Since it’s quite a bit of work to gather all your donations for your tax declaration, the Givt app offers you the option to annually download an overview of your donations. Go to your Donations in the app-menu to download the overview. You can use this overview for your tax declaration. It’s a piece of cake.'**
  String get faQantwoord15;

  /// op het scherm waar je de voorkeursbedragen (presets) kan enablen of disablen
  ///
  /// In en, this message translates to:
  /// **'You can add amount presets to your keyboard. This is where you can enable and set the amount presets.'**
  String get amountPresetsChangingPresets;

  /// menu-item to change/set the amount presets
  ///
  /// In en, this message translates to:
  /// **'Change amount presets'**
  String get amountPresetsChangePresetsMenu;

  /// No description provided for @changeBankAccountNumberAndSortCode.
  ///
  /// In en, this message translates to:
  /// **'Change bank details'**
  String get changeBankAccountNumberAndSortCode;

  /// No description provided for @updateBacsAccountDetailsError.
  ///
  /// In en, this message translates to:
  /// **'Alas, the Sortcode or Account number is invalid. You can change the Sortcode and/or Account number under ‘Personal information’ in the menu.'**
  String get updateBacsAccountDetailsError;

  /// No description provided for @ddiFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'DDI request failed'**
  String get ddiFailedTitle;

  /// No description provided for @ddiFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'At the moment it is not possible to request a Direct Debit Instruction. Please try again in a few minutes.'**
  String get ddiFailedMessage;

  /// No description provided for @faQantwoord5Gb.
  ///
  /// In en, this message translates to:
  /// **'Handling transactions\n The transactions are handled by Access PaySuite; a payment institution specialised in processing BACS Direct Debit Instructions. Access PaySuite is under the supervision of the Financial Conduct Authority.\n \n\n Revertible afterwards\n The transactions take place afterwards via a direct debit under Givt Ltd. We want to emphasise that no transactions take place in the moment of giving. Since these transactions are revocable, it is completely safe and immune to fraud.'**
  String get faQantwoord5Gb;

  /// No description provided for @faQvraag15Gb.
  ///
  /// In en, this message translates to:
  /// **'Can I Gift Aid my donations?'**
  String get faQvraag15Gb;

  /// No description provided for @faQantwoord15Gb.
  ///
  /// In en, this message translates to:
  /// **'Yes, you can. In the Givt app you can enable Gift Aid. You can also always see how much Gift Aid has been claimed on your donations.\n \n\n Donating through Gift Aid means charities can claim an extra 25p for every £1 you give. It will not cost you any extra.'**
  String get faQantwoord15Gb;

  /// No description provided for @answerHowDoesRegistrationWorkGb.
  ///
  /// In en, this message translates to:
  /// **'To start giving, all you need is an e-mail address. Once you have entered this, you are ready to give.\n \n\n Please note: you need to fully register to ensure that all your previous and future donations can be processed. Go to the menu in the app and choose ‘Complete registration’. Here, you set up a Givt account by filling in your personal information and by us giving permission to debit the donations made in the app. Those transactions are processed by Access PaySuite, who are specialised in direct debits. \n \n\n When your registration is complete, you are ready to give with the Givt app. You only need your login details to see or change your settings.'**
  String get answerHowDoesRegistrationWorkGb;

  /// No description provided for @faQantwoord7Gb.
  ///
  /// In en, this message translates to:
  /// **' Personal safety\n It is very important to us that everything is safe and risk free. Each user has a personal account with its own password. You need to log in to view or change your settings.\n \n\n Handling transactions\n The transactions are handled by Access PaySuite; a payment institution specialised in processing BACS Direct Debit Instructions. Access PaySuite is under the supervision of the Financial Conduct Authority.\n \n\n Immune to fraud\n When installing Givt, the user gives the app authorisation to debit their account. We want to emphasise that no transactions take place in the moment of giving. The transactions take place afterwards via a direct debit under Givt Ltd. Since these transactions are revocable, it is completely safe and immune to fraud.\n \n\n Overview\n Individual users can see an overview of their donations in the app. Organisations can log in to the Givt dashboard. This dashboard gives an overview of all financial transactions, from the moment of giving up to the full processing of the payment. In this way any collection can be followed from start to finish. Organisations can see how many people used Givt, but not who they are.'**
  String get faQantwoord7Gb;

  /// No description provided for @giftAidSetting.
  ///
  /// In en, this message translates to:
  /// **'I want to use/keep using Gift Aid'**
  String get giftAidSetting;

  /// No description provided for @giftAidInfo.
  ///
  /// In en, this message translates to:
  /// **'As a UK taxpayer, you can use the Gift Aid initiative. Every year we will remind you of your choice. Activating Gift Aid after March 1st will count towards March and the next tax year. All your donations made before entering your account details will be considered eligible if they were made in the current tax year.'**
  String get giftAidInfo;

  /// No description provided for @giftAidHeaderDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'When you enable this option, you agree to the following:'**
  String get giftAidHeaderDisclaimer;

  /// No description provided for @giftAidBodyDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'I am a UK taxpayer and understand that if I pay less Income Tax and/or Capital Gains Tax in the current tax year than the amount of Gift Aid claimed on all my donations, it is my responsibility to pay any difference.'**
  String get giftAidBodyDisclaimer;

  /// No description provided for @giftAidInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'What is Gift Aid?'**
  String get giftAidInfoTitle;

  /// No description provided for @giftAidInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Donating through Gift Aid means charities can claim an extra 25p for every £1 you give. It will not cost you any extra. \n \n\n Gift Aid treats the donations as being made after deduction of income tax at the basic rate. The charity you give to can reclaim this basic rate income tax paid on the gift from HMRC. Your donations will qualify as long as they’re not more than 4 times what you have paid in tax in that tax year. \n  \n For more info, please go to: www.gov.uk/donating-to-charity/gift-aid'**
  String get giftAidInfoBody;

  /// No description provided for @faqAnswer12Gb.
  ///
  /// In en, this message translates to:
  /// **'Your donation will be withdrawn from your bank account within five working days. The first time you make a donation with Givt, the donation will be withdrawn after two weeks, as it takes extra time to set up your registration.'**
  String get faqAnswer12Gb;

  /// No description provided for @faqVraagDdi.
  ///
  /// In en, this message translates to:
  /// **'Does the Direct Debit mean I signed up to monthly deductions?'**
  String get faqVraagDdi;

  /// No description provided for @faqAntwoordDdi.
  ///
  /// In en, this message translates to:
  /// **'NO! You sign a direct debit so we can deduct the donations you have made using the Givt app. The deductions we make are incidental, user-driven deductions.\n \n\n We will not debit your account unless you make a donation using the Givt app.'**
  String get faqAntwoordDdi;

  /// No description provided for @charity.
  ///
  /// In en, this message translates to:
  /// **'Charity'**
  String get charity;

  /// No description provided for @artist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get artist;

  /// No description provided for @church.
  ///
  /// In en, this message translates to:
  /// **'Church'**
  String get church;

  /// No description provided for @campaign.
  ///
  /// In en, this message translates to:
  /// **'Campaign'**
  String get campaign;

  /// No description provided for @giveToNearestBeacon.
  ///
  /// In en, this message translates to:
  /// **'Give to: {value0}'**
  String giveToNearestBeacon(Object value0);

  /// No description provided for @jersey.
  ///
  /// In en, this message translates to:
  /// **'Jersey'**
  String get jersey;

  /// No description provided for @guernsey.
  ///
  /// In en, this message translates to:
  /// **'Guernsey'**
  String get guernsey;

  /// No description provided for @countryStringBe.
  ///
  /// In en, this message translates to:
  /// **'Belgium'**
  String get countryStringBe;

  /// No description provided for @countryStringNl.
  ///
  /// In en, this message translates to:
  /// **'Netherlands'**
  String get countryStringNl;

  /// No description provided for @countryStringDe.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get countryStringDe;

  /// No description provided for @countryStringGb.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get countryStringGb;

  /// No description provided for @countryStringFr.
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get countryStringFr;

  /// No description provided for @countryStringIt.
  ///
  /// In en, this message translates to:
  /// **'Italy'**
  String get countryStringIt;

  /// No description provided for @countryStringLu.
  ///
  /// In en, this message translates to:
  /// **'Luxembourg'**
  String get countryStringLu;

  /// No description provided for @countryStringGr.
  ///
  /// In en, this message translates to:
  /// **'Greece'**
  String get countryStringGr;

  /// No description provided for @countryStringPt.
  ///
  /// In en, this message translates to:
  /// **'Portugal'**
  String get countryStringPt;

  /// No description provided for @countryStringEs.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get countryStringEs;

  /// No description provided for @countryStringFi.
  ///
  /// In en, this message translates to:
  /// **'Finland'**
  String get countryStringFi;

  /// No description provided for @countryStringAt.
  ///
  /// In en, this message translates to:
  /// **'Austria'**
  String get countryStringAt;

  /// No description provided for @countryStringCy.
  ///
  /// In en, this message translates to:
  /// **'Cyprus'**
  String get countryStringCy;

  /// No description provided for @countryStringEe.
  ///
  /// In en, this message translates to:
  /// **'Estonia'**
  String get countryStringEe;

  /// No description provided for @countryStringLv.
  ///
  /// In en, this message translates to:
  /// **'Latvia'**
  String get countryStringLv;

  /// No description provided for @countryStringLt.
  ///
  /// In en, this message translates to:
  /// **'Lithuania'**
  String get countryStringLt;

  /// No description provided for @countryStringMt.
  ///
  /// In en, this message translates to:
  /// **'Malta'**
  String get countryStringMt;

  /// No description provided for @countryStringSi.
  ///
  /// In en, this message translates to:
  /// **'Slovenia'**
  String get countryStringSi;

  /// No description provided for @countryStringSk.
  ///
  /// In en, this message translates to:
  /// **'Slovakia'**
  String get countryStringSk;

  /// No description provided for @countryStringIe.
  ///
  /// In en, this message translates to:
  /// **'Ireland'**
  String get countryStringIe;

  /// No description provided for @countryStringAd.
  ///
  /// In en, this message translates to:
  /// **'Andorra'**
  String get countryStringAd;

  /// No description provided for @informationAboutUsGb.
  ///
  /// In en, this message translates to:
  /// **'Givt is a product of Givt LTD.\n \n\n We are located at the Blackthorn House in Birmingham, England. For questions or complaints you can reach us via 020 3790 8068 or support@givt.co.uk\n \n\n We are registered under the Company Registration Number 11396586.'**
  String get informationAboutUsGb;

  /// No description provided for @authoriseBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Authorise Givt to use Bluetooth'**
  String get authoriseBluetooth;

  /// No description provided for @authoriseBluetoothErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Give Givt permission to access your Bluetooth so you\'re ready to give to a collection.'**
  String get authoriseBluetoothErrorMessage;

  /// No description provided for @authoriseBluetoothExtraText.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings > Privacy > Bluetooth and select \'Givt\'.'**
  String get authoriseBluetoothExtraText;

  /// No description provided for @unregisterErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Terminate failed'**
  String get unregisterErrorTitle;

  /// No description provided for @setupRecurringGiftTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your recurring donation'**
  String get setupRecurringGiftTitle;

  /// No description provided for @setupRecurringGiftText3.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get setupRecurringGiftText3;

  /// No description provided for @setupRecurringGiftText4.
  ///
  /// In en, this message translates to:
  /// **'until'**
  String get setupRecurringGiftText4;

  /// No description provided for @setupRecurringGiftText5.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get setupRecurringGiftText5;

  /// No description provided for @setupRecurringGiftText2.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get setupRecurringGiftText2;

  /// No description provided for @setupRecurringGiftText1.
  ///
  /// In en, this message translates to:
  /// **'I want to give every'**
  String get setupRecurringGiftText1;

  /// No description provided for @setupRecurringGiftWeek.
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get setupRecurringGiftWeek;

  /// No description provided for @setupRecurringGiftMonth.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get setupRecurringGiftMonth;

  /// No description provided for @setupRecurringGiftQuarter.
  ///
  /// In en, this message translates to:
  /// **'quarter'**
  String get setupRecurringGiftQuarter;

  /// No description provided for @setupRecurringGiftYear.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get setupRecurringGiftYear;

  /// No description provided for @menuItemRecurringDonation.
  ///
  /// In en, this message translates to:
  /// **'Recurring donations'**
  String get menuItemRecurringDonation;

  /// No description provided for @setupRecurringGiftHalfYear.
  ///
  /// In en, this message translates to:
  /// **'half year'**
  String get setupRecurringGiftHalfYear;

  /// No description provided for @setupRecurringGiftText6.
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get setupRecurringGiftText6;

  /// No description provided for @recurringGiftsSetupCreate.
  ///
  /// In en, this message translates to:
  /// **'Schedule your'**
  String get recurringGiftsSetupCreate;

  /// No description provided for @recurringGiftsSetupRecurringGift.
  ///
  /// In en, this message translates to:
  /// **'recurring donation'**
  String get recurringGiftsSetupRecurringGift;

  /// No description provided for @recurringDonationYouGive.
  ///
  /// In en, this message translates to:
  /// **'you give'**
  String get recurringDonationYouGive;

  /// No description provided for @recurringDonationStops.
  ///
  /// In en, this message translates to:
  /// **'This will stop on {value0}'**
  String recurringDonationStops(Object value0);

  /// No description provided for @selectRecipient.
  ///
  /// In en, this message translates to:
  /// **'Select recipient'**
  String get selectRecipient;

  /// No description provided for @setupRecurringDonationFailed.
  ///
  /// In en, this message translates to:
  /// **'The recurring donation was not set up successfully. Please try again later.'**
  String get setupRecurringDonationFailed;

  /// No description provided for @emptyRecurringDonationList.
  ///
  /// In en, this message translates to:
  /// **'All your recurring donations will be visible here.'**
  String get emptyRecurringDonationList;

  /// No description provided for @cancelRecurringDonationAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to stop donating to {value0}?'**
  String cancelRecurringDonationAlertTitle(Object value0);

  /// No description provided for @cancelRecurringDonationAlertMessage.
  ///
  /// In en, this message translates to:
  /// **'The donations already made will not be cancelled.'**
  String get cancelRecurringDonationAlertMessage;

  /// No description provided for @cancelRecurringDonation.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get cancelRecurringDonation;

  /// No description provided for @setupRecurringGiftText7.
  ///
  /// In en, this message translates to:
  /// **'Each'**
  String get setupRecurringGiftText7;

  /// No description provided for @cancelRecurringDonationFailed.
  ///
  /// In en, this message translates to:
  /// **'The recurring donation was not cancelled successfully. Please try again later.'**
  String get cancelRecurringDonationFailed;

  /// No description provided for @reportMissingOrganisationListItem.
  ///
  /// In en, this message translates to:
  /// **'Report a missing organisation'**
  String get reportMissingOrganisationListItem;

  /// No description provided for @reportMissingOrganisationPrefilledText.
  ///
  /// In en, this message translates to:
  /// **'Hi! I would really like to give to:'**
  String get reportMissingOrganisationPrefilledText;

  /// No description provided for @setupRecurringDonationFailedDuplicate.
  ///
  /// In en, this message translates to:
  /// **'The recurring donation was not set up successfully. You have already made a donation to this organisation with the same repeating period.'**
  String get setupRecurringDonationFailedDuplicate;

  /// No description provided for @setupRecurringDonationFailedDuplicateTitle.
  ///
  /// In en, this message translates to:
  /// **'Duplicate donation'**
  String get setupRecurringDonationFailedDuplicateTitle;

  /// No description provided for @goToListWithRecurringDonationDonations.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get goToListWithRecurringDonationDonations;

  /// No description provided for @recurringDonationFutureDetailSameYear.
  ///
  /// In en, this message translates to:
  /// **'Upcoming donation'**
  String get recurringDonationFutureDetailSameYear;

  /// No description provided for @discoverSearchButton.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get discoverSearchButton;

  /// No description provided for @discoverDiscoverButton.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get discoverDiscoverButton;

  /// No description provided for @discoverSegmentNow.
  ///
  /// In en, this message translates to:
  /// **'Give'**
  String get discoverSegmentNow;

  /// No description provided for @discoverSegmentWho.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discoverSegmentWho;

  /// No description provided for @discoverHomeDiscoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose category'**
  String get discoverHomeDiscoverTitle;

  /// No description provided for @discoverOrAmountActionSheetOnce.
  ///
  /// In en, this message translates to:
  /// **'One-off donation'**
  String get discoverOrAmountActionSheetOnce;

  /// No description provided for @discoverOrAmountActionSheetRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring donation'**
  String get discoverOrAmountActionSheetRecurring;

  /// No description provided for @reccurringGivtIsBeingProcessed.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your recurring donation to {value0}!\n To see all the information, go to \'Recurring donations\' in the menu.'**
  String reccurringGivtIsBeingProcessed(Object value0);

  /// No description provided for @amountLimitExceededRecurringDonation.
  ///
  /// In en, this message translates to:
  /// **'This amount is higher than your chosen maximum amount. Do you want to continue or change the amount?'**
  String get amountLimitExceededRecurringDonation;

  /// No description provided for @sepaVerifyBody.
  ///
  /// In en, this message translates to:
  /// **'If any of the above is incorrect, please abort the registration and change your \'Personal information\''**
  String get sepaVerifyBody;

  /// No description provided for @signMandate.
  ///
  /// In en, this message translates to:
  /// **'Sign mandate'**
  String get signMandate;

  /// No description provided for @signMandateDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'By continuing you sign the eMandate with above details.\n The mandate will be sent to you via mail.'**
  String get signMandateDisclaimer;

  /// No description provided for @budgetSummaryBalance.
  ///
  /// In en, this message translates to:
  /// **'My giving this month'**
  String get budgetSummaryBalance;

  /// No description provided for @budgetSummarySetGoal.
  ///
  /// In en, this message translates to:
  /// **'Set a giving goal to motivate yourself.'**
  String get budgetSummarySetGoal;

  /// No description provided for @budgetSummaryGiveNow.
  ///
  /// In en, this message translates to:
  /// **'Give now!'**
  String get budgetSummaryGiveNow;

  /// No description provided for @budgetSummaryGivt.
  ///
  /// In en, this message translates to:
  /// **'Given within Givt'**
  String get budgetSummaryGivt;

  /// No description provided for @budgetSummaryNotGivt.
  ///
  /// In en, this message translates to:
  /// **'Given outside Givt'**
  String get budgetSummaryNotGivt;

  /// No description provided for @budgetSummaryShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get budgetSummaryShowAll;

  /// No description provided for @budgetSummaryMonth.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get budgetSummaryMonth;

  /// No description provided for @budgetSummaryYear.
  ///
  /// In en, this message translates to:
  /// **'Annually'**
  String get budgetSummaryYear;

  /// No description provided for @budgetExternalGiftsTitle.
  ///
  /// In en, this message translates to:
  /// **'Giving outside Givt'**
  String get budgetExternalGiftsTitle;

  /// No description provided for @budgetExternalGiftsInfo.
  ///
  /// In en, this message translates to:
  /// **'Get a complete overview of all of your contributions. Add any contributions that you have made outside of Givt. You will find everything in your summary.'**
  String get budgetExternalGiftsInfo;

  /// No description provided for @budgetExternalGiftsSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Your donations outside Givt'**
  String get budgetExternalGiftsSubTitle;

  /// No description provided for @budgetExternalGiftsOrg.
  ///
  /// In en, this message translates to:
  /// **'Name of organisation'**
  String get budgetExternalGiftsOrg;

  /// No description provided for @budgetExternalGiftsTime.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get budgetExternalGiftsTime;

  /// No description provided for @budgetExternalGiftsAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get budgetExternalGiftsAmount;

  /// No description provided for @budgetExternalGiftsSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get budgetExternalGiftsSave;

  /// No description provided for @budgetGivingGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Setup giving goal'**
  String get budgetGivingGoalTitle;

  /// No description provided for @budgetGivingGoalInfo.
  ///
  /// In en, this message translates to:
  /// **'Give consciously. Consider each month whether your giving behaviour matches your personal giving goals.'**
  String get budgetGivingGoalInfo;

  /// No description provided for @budgetGivingGoalMine.
  ///
  /// In en, this message translates to:
  /// **'My giving goal'**
  String get budgetGivingGoalMine;

  /// No description provided for @budgetGivingGoalTime.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get budgetGivingGoalTime;

  /// No description provided for @budgetSummaryGivingGoalMonth.
  ///
  /// In en, this message translates to:
  /// **'Monthly giving goal'**
  String get budgetSummaryGivingGoalMonth;

  /// No description provided for @budgetSummaryGivingGoalEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit giving goal'**
  String get budgetSummaryGivingGoalEdit;

  /// No description provided for @budgetSummaryGivingGoalRest.
  ///
  /// In en, this message translates to:
  /// **'Remaining giving goal'**
  String get budgetSummaryGivingGoalRest;

  /// No description provided for @budgetMenuView.
  ///
  /// In en, this message translates to:
  /// **'My personal summary'**
  String get budgetMenuView;

  /// No description provided for @budgetSummarySetGoalBold.
  ///
  /// In en, this message translates to:
  /// **'Give consciously'**
  String get budgetSummarySetGoalBold;

  /// No description provided for @budgetExternalGiftsInfoBold.
  ///
  /// In en, this message translates to:
  /// **'Gain insight into what you give'**
  String get budgetExternalGiftsInfoBold;

  /// No description provided for @budgetGivingGoalInfoBold.
  ///
  /// In en, this message translates to:
  /// **'Set giving goal'**
  String get budgetGivingGoalInfoBold;

  /// No description provided for @budgetGivingGoalRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove giving goal'**
  String get budgetGivingGoalRemove;

  /// No description provided for @budgetSummaryNoGifts.
  ///
  /// In en, this message translates to:
  /// **'You have no donations (yet) this month'**
  String get budgetSummaryNoGifts;

  /// No description provided for @budgetTestimonialSummary.
  ///
  /// In en, this message translates to:
  /// **'”Since I’ve been using the summary, I have gained more insight into what I give. I give more consciously because of it.\"'**
  String get budgetTestimonialSummary;

  /// No description provided for @budgetTestimonialGivingGoal.
  ///
  /// In en, this message translates to:
  /// **'”My giving goal motivates me to regularly reflect on my giving behaviour.”'**
  String get budgetTestimonialGivingGoal;

  /// No description provided for @budgetTestimonialExternalGifts.
  ///
  /// In en, this message translates to:
  /// **'\"I like that I can add any external donations to my summary. I can now simply keep track of my giving.\"'**
  String get budgetTestimonialExternalGifts;

  /// No description provided for @budgetTestimonialYearlyOverview.
  ///
  /// In en, this message translates to:
  /// **'\"Givt\'s annual overview is great! I\'ve also added all my donations outside Givt. This way I have all my giving in one overview, which is essential for my tax return.\"'**
  String get budgetTestimonialYearlyOverview;

  /// No description provided for @budgetPushMonthly.
  ///
  /// In en, this message translates to:
  /// **'See what you have given this month.'**
  String get budgetPushMonthly;

  /// No description provided for @budgetTooltipYearly.
  ///
  /// In en, this message translates to:
  /// **'One overview for the tax return? View the overview of all your donations here.'**
  String get budgetTooltipYearly;

  /// No description provided for @budgetPushMonthlyBold.
  ///
  /// In en, this message translates to:
  /// **'Your monthly summary is ready.'**
  String get budgetPushMonthlyBold;

  /// No description provided for @budgetExternalGiftsListAddEditButton.
  ///
  /// In en, this message translates to:
  /// **'Manage external donations'**
  String get budgetExternalGiftsListAddEditButton;

  /// No description provided for @budgetExternalGiftsFrequencyOnce.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get budgetExternalGiftsFrequencyOnce;

  /// No description provided for @budgetExternalGiftsFrequencyMonthly.
  ///
  /// In en, this message translates to:
  /// **'Every month'**
  String get budgetExternalGiftsFrequencyMonthly;

  /// No description provided for @budgetExternalGiftsFrequencyQuarterly.
  ///
  /// In en, this message translates to:
  /// **'Every 3 months'**
  String get budgetExternalGiftsFrequencyQuarterly;

  /// No description provided for @budgetExternalGiftsFrequencyHalfYearly.
  ///
  /// In en, this message translates to:
  /// **'Every 6 months'**
  String get budgetExternalGiftsFrequencyHalfYearly;

  /// No description provided for @budgetExternalGiftsFrequencyYearly.
  ///
  /// In en, this message translates to:
  /// **'Every year'**
  String get budgetExternalGiftsFrequencyYearly;

  /// No description provided for @budgetExternalGiftsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get budgetExternalGiftsEdit;

  /// No description provided for @budgetTestimonialSummaryName.
  ///
  /// In en, this message translates to:
  /// **'Willem:'**
  String get budgetTestimonialSummaryName;

  /// No description provided for @budgetTestimonialGivingGoalName.
  ///
  /// In en, this message translates to:
  /// **'Danielle:'**
  String get budgetTestimonialGivingGoalName;

  /// No description provided for @budgetTestimonialExternalGiftsName.
  ///
  /// In en, this message translates to:
  /// **'Johnson:'**
  String get budgetTestimonialExternalGiftsName;

  /// No description provided for @budgetTestimonialSummaryAction.
  ///
  /// In en, this message translates to:
  /// **'View your summary'**
  String get budgetTestimonialSummaryAction;

  /// No description provided for @budgetTestimonialGivingGoalAction.
  ///
  /// In en, this message translates to:
  /// **'Setup your giving goal'**
  String get budgetTestimonialGivingGoalAction;

  /// No description provided for @budgetTestimonialExternalGiftsAction.
  ///
  /// In en, this message translates to:
  /// **'Add external donations'**
  String get budgetTestimonialExternalGiftsAction;

  /// No description provided for @budgetSummaryGivingGoalReached.
  ///
  /// In en, this message translates to:
  /// **'Giving goal achieved'**
  String get budgetSummaryGivingGoalReached;

  /// No description provided for @budgetSummaryNoGiftsExternal.
  ///
  /// In en, this message translates to:
  /// **'Donations outside Givt this month? Add here'**
  String get budgetSummaryNoGiftsExternal;

  /// No description provided for @budgetYearlyOverviewGivenThroughGivt.
  ///
  /// In en, this message translates to:
  /// **'Total within Givt'**
  String get budgetYearlyOverviewGivenThroughGivt;

  /// No description provided for @budgetYearlyOverviewGivenThroughNotGivt.
  ///
  /// In en, this message translates to:
  /// **'Total outside Givt'**
  String get budgetYearlyOverviewGivenThroughNotGivt;

  /// No description provided for @budgetYearlyOverviewGivenTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get budgetYearlyOverviewGivenTotal;

  /// No description provided for @budgetYearlyOverviewGivenTotalTax.
  ///
  /// In en, this message translates to:
  /// **'Total tax relief'**
  String get budgetYearlyOverviewGivenTotalTax;

  /// No description provided for @budgetYearlyOverviewDetailThroughGivt.
  ///
  /// In en, this message translates to:
  /// **'Within Givt'**
  String get budgetYearlyOverviewDetailThroughGivt;

  /// No description provided for @budgetYearlyOverviewDetailAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get budgetYearlyOverviewDetailAmount;

  /// No description provided for @budgetYearlyOverviewDetailDeductable.
  ///
  /// In en, this message translates to:
  /// **'Tax relief'**
  String get budgetYearlyOverviewDetailDeductable;

  /// No description provided for @budgetYearlyOverviewDetailTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get budgetYearlyOverviewDetailTotal;

  /// No description provided for @budgetYearlyOverviewDetailTotalDeductable.
  ///
  /// In en, this message translates to:
  /// **'Total tax relief'**
  String get budgetYearlyOverviewDetailTotalDeductable;

  /// No description provided for @budgetYearlyOverviewDetailNotThroughGivt.
  ///
  /// In en, this message translates to:
  /// **'Outside Givt'**
  String get budgetYearlyOverviewDetailNotThroughGivt;

  /// No description provided for @budgetYearlyOverviewDetailTotalThroughGivt.
  ///
  /// In en, this message translates to:
  /// **'(within Givt)'**
  String get budgetYearlyOverviewDetailTotalThroughGivt;

  /// No description provided for @budgetYearlyOverviewDetailTotalNotThroughGivt.
  ///
  /// In en, this message translates to:
  /// **'(outside Givt)'**
  String get budgetYearlyOverviewDetailTotalNotThroughGivt;

  /// No description provided for @budgetYearlyOverviewDetailTipBold.
  ///
  /// In en, this message translates to:
  /// **'TIP: add your external donations'**
  String get budgetYearlyOverviewDetailTipBold;

  /// No description provided for @budgetYearlyOverviewDetailTipNormal.
  ///
  /// In en, this message translates to:
  /// **'to get a total overview of what you give, both via the Givt app and not via the Givt app.'**
  String get budgetYearlyOverviewDetailTipNormal;

  /// No description provided for @budgetYearlyOverviewDetailReceiveViaMail.
  ///
  /// In en, this message translates to:
  /// **'Receive by e-mail'**
  String get budgetYearlyOverviewDetailReceiveViaMail;

  /// No description provided for @budgetYearlyOverviewDownloadButton.
  ///
  /// In en, this message translates to:
  /// **'Download annual overview'**
  String get budgetYearlyOverviewDownloadButton;

  /// No description provided for @budgetExternalDonationsTaxDeductableSwitch.
  ///
  /// In en, this message translates to:
  /// **'Tax relief'**
  String get budgetExternalDonationsTaxDeductableSwitch;

  /// No description provided for @budgetYearlyOverviewGivingGoalPerYear.
  ///
  /// In en, this message translates to:
  /// **'Annual giving goal'**
  String get budgetYearlyOverviewGivingGoalPerYear;

  /// No description provided for @budgetYearlyOverviewGivenIn.
  ///
  /// In en, this message translates to:
  /// **'Given in'**
  String get budgetYearlyOverviewGivenIn;

  /// No description provided for @budgetYearlyOverviewRelativeTo.
  ///
  /// In en, this message translates to:
  /// **'Relative to the total in'**
  String get budgetYearlyOverviewRelativeTo;

  /// No description provided for @budgetYearlyOverviewVersus.
  ///
  /// In en, this message translates to:
  /// **'Versus'**
  String get budgetYearlyOverviewVersus;

  /// No description provided for @budgetYearlyOverviewPerOrganisation.
  ///
  /// In en, this message translates to:
  /// **'Per organisation'**
  String get budgetYearlyOverviewPerOrganisation;

  /// No description provided for @budgetSummaryNoGiftsYearlyOverview.
  ///
  /// In en, this message translates to:
  /// **'You have no donations (yet) this year'**
  String get budgetSummaryNoGiftsYearlyOverview;

  /// No description provided for @budgetPushYearlyNearlyEndBold.
  ///
  /// In en, this message translates to:
  /// **'{value0} is almost over... Have you made up your balance yet?'**
  String budgetPushYearlyNearlyEndBold(Object value0);

  /// No description provided for @budgetPushYearlyNearlyEnd.
  ///
  /// In en, this message translates to:
  /// **'View your annual overview and see what you have given so far.'**
  String get budgetPushYearlyNearlyEnd;

  /// No description provided for @budgetTestimonialYearlyOverviewAction.
  ///
  /// In en, this message translates to:
  /// **'Go to the overview'**
  String get budgetTestimonialYearlyOverviewAction;

  /// No description provided for @duplicateAccountOrganisationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you are using your own bank details? Could you please check in the menu, under \'Personal information\'? You can change the information there as well, if necessary.'**
  String get duplicateAccountOrganisationMessage;

  /// No description provided for @policyTextUs.
  ///
  /// In en, this message translates to:
  /// **'1. Givt App – US Privacy Policy\nLatest Amendment: [01-03-2025]\nVersion [1.2]\nGivt Inc. Privacy Policy\n\nIntroduction\nThis Privacy Policy outlines Givt Inc.’s (“we,” “our,” or “the Company”) practices with respect to information collected from our Application\n\nGrounds for data collection\nProcessing of your personal information (meaning, any information relating to an identified or identifiable individual; hereinafter “Personal\nInformation”)  is necessary for the performance of our contractual obligations towards you and providing you with our services, to protect\nour legitimate interests and for compliance with legal and financial regulatory obligations to which we are subject.\nWhen you use our App or register yourself or an organization you represent with us, you consent to the collection, storage, use, disclosure and other uses of your Personal Information as described in this Privacy Policy.\nWe encourage our Users to carefully read the Privacy Policy and use it to make informed decisions.\nWhat information do we collect?\nWe collect two types of data and information from Users. The first type of information is un-identified and non-identifiable information pertaining to a User(s), which may be made available or gathered via your use of the App (“Non-personal Information”). We are not aware of the identity of a User from which the Non-personal Information was collected. Non-personal Information which is being collected may include your aggregated usage information and technical information transmitted by your device, including certain software and\nhardware information (e.g. language preference, access time, etc.) in order to enhance the functionality of our App.\nThe second type of information is Personal Information, which is personally identifiable information, namely information that identifies an\nindividual or may with reasonable effort identify an individual. Such information includes:\n\nDevice Information: We collect Personal Information from your device. Such information includes geolocation data, IP address, unique identifiers (e.g. MAC address and UUID) and other information which relates to your activity through the App.\n\nService User Information: We collect additional information for individuals who would like to use our Services. This is gathered\nthrough the App and includes all the information needed to register for our service:\n– Name and address,\n– Date of birth,\n– email address,\n– secured password details, and\n– bank details for the purposes of making payments.\n\n\nContact information: If you choose to contact us you will be asked to provide us with certain details such as: full name; e-mail or physical address, and other relevant information. This may be for yourself or for people in the organization you represent.\n\n\nHow do we receive information about you?\n\nWe receive your Personal Information from various sources:\n\n● When you voluntarily provide us with your personal details in order to register on our App;\n\n● When you use or access our App in connection with your use of our services;\nWhen you use or access our Dashboard in connection with your organization’s use of our services;\n\n● From third party providers, services and public registers (for example, traffic analytics vendors); and,\n\n● Through diagnostic information from the App. The App will send us anonymous information about its functioning. This information contains non-personal data from your smartphone like its type and operating system, but also the version information of the App. This data is solely used for purposes of improving our Service or allowing better responses to your questions.\n\n\nWhat do we do with the information we collect?\n\n\nWe may use the information for the following:\n● To provide the services through the App – we will use a minimum of name and bank details to perform the services of effecting payment(s) via the App. Payment information is never shared with intended recipients of donations;\n● Communicating with you – sending you notices regarding our services, providing you with technical information and responding to\nany customer service issue you may have; to keep you informed of our latest updates and services;\n● Conducting statistical and analytical activities, intended to improve the App and/or the App.\n● For marketing and advertising purposes, such as developing and providing promotional and advertising materials that may be relevant,\nvaluable or otherwise of interest to you.\nIn addition to the different uses listed above, we may transfer or disclose Personal Information to our subsidiaries, affiliated companies and subcontractors in relation to services that we provide to you. We may also disclose information if we have good faith to believe that\ndisclosure of such information is helpful or reasonably necessary to: (i) comply with any applicable law, regulation, legal process or governmental request; (ii) enforce our policies (including our Agreement), including investigations of potential violations thereof; (iii) investigate, detect, prevent, or take action regarding illegal activities or other wrongdoing, suspected fraud or security issues; (iv) to establish or exercise our rights to defend against legal claims; (v) prevent harm to the rights, property or safety of us, our users, yourself or any third party; or (vi) for the purpose of collaborating with law enforcement agencies and/or in case we find it necessary in order to enforce intellectual property or other legal rights.\n\n\nProviding Data to Third Parties When you make a donation, personal information about you, your name, the amount, campaign and email address is shared with the intended recipient of your donation. In some cases, you may have the option to remain anonymous. If you choose to remain anonymous, your personal information will not be shared with the intended recipient of your donation.\nWhen you make a donation, personal information about you, your name, the amount, campaign and email address is shared with the intended recipient of your donation. In some cases, you may have the option to remain anonymous. If you choose to remain anonymous, your personal information will not be shared with the intended recipient of your donation.\n\n\nWe may provide your information to our partners. For example, we may share any information we receive with vendors and service providers retained in connection with the provision of the App. If you use the App to make a donation, your payment-related information, such as credit card or other financial information, is collected by our third-party payment processor on our behalf. In all cases, these parties are necessary to provide the services.\nWe may collect, use, and share anonymous data for statistical purposes, reviews, and comparisons; no such data will be traceable to individuals.\nWe are committed to making it easier for donors to give to charities of their choosing, and we will never sell data to third parties.\nWe may access, preserve, and disclose your information if we believe doing so is required or appropriate to: (a) comply with law enforcement requests and legal process, such as a court order or subpoena; (b) respond to your requests; or (c) protect your, our, or others’ rights, property, or safety.\nWe may transfer your information to service providers, advisors, potential transactional partners, or other third parties in connection with the consideration, negotiation, or completion of a corporate transaction in which we are acquired by or merged with another company or we sell, liquidate, or transfer all or a portion of our assets. The use of your information following any of these events will be governed by the provisions of this Privacy Policy in effect at the time the applicable information was collected.\nWe may also disclose your information with your permission.\n\n\nInformation from Cookies and Other Tracking Technologies. \nWe and our third-party partners collect information about your activities on our Application using cookies, pixel tags, SDKs, or other tracking technologies. Our third-party partners, such as analytics, authentication, and security partners, may also use these technologies to collect information about your online activities over time and across different services.\n\n\nAnalytics Partners. We use analytics services such as Google Analytics to collect and process certain analytics data. [You can learn more about Google’s practices by visiting https://www.google.com/policies/privacy/partners/.]\n\n\nCollection of Audio Data. \n\nIn order to create recorded messages for family members, our App collects audio data if you explicitly enable the App to have access to your device’s microphone via your device’s operating system settings. This feature is designed to enhance user experience by allowing personalized messages to be shared through our services. Audio data is only used for the purpose of delivering the recorded message. Audio recording occurs solely during the active use of this feature. Audio recordings are not shared with third parties unless explicitly required for service delivery or mandated by law. You can disable microphone access at any time through your device settings, which may limit your ability to use this feature.\n\nUser Rights\nYou may request to:\n1.Receive confirmation as to whether or not personal information concerning you is being processed, and access your stored personal information, together with supplementary information.\n2.Receive a copy of personal information you directly volunteer to us in a structured, commonly used and machine-readable format.\n3.Request rectification of your personal information that is in our control.\n4.Request erasure of your personal information.\n5.Object to the processing of personal information by us.\n6.Request portability of your personal information.\n7.Request to restrict processing of your personal information by us.\n8.Lodge a complaint with a supervisory authority.\n\nHowever, please note that these rights are not absolute, and may be subject to our own legitimate interests and regulatory requirements.\nBefore fulfilling your request, we may ask you to provide reasonable information to verify your identity.\n\nRetention\nWe will retain your personal information for as long as necessary to provide our services, and as necessary to comply with our legal\nobligations, resolve disputes, and enforce our policies. Retention periods will be determined taking into account the type of information that is collected and the purpose for which it is collected, bearing in mind the requirements applicable to the situation and the need to destroy outdated, unused information at the earliest reasonable time. Under applicable regulations, we will keep records containing client personal data, account opening documents, communications and anything else as required by applicable laws and regulations.\nWe may rectify, replenish or remove incomplete or inaccurate information, at any time and at our own discretion.\n\nUse of Location Services\nThe App may use the location services as provided by the operating system on the smartphone. With these services, the App may determine the location of the user. The location data will not be sent anywhere outside the smartphone, and is solely used to determine whether the user is in a location where it’s possible to use the App for donating. The locations where one can use App are downloaded to the smartphone prior to using the location services.\n\nHow do we safeguard your information?\nWe take security measures to reduce misuse of and unauthorized access to personal data. Although we take reasonable steps to safeguard information, we cannot be responsible for the acts of those who gain unauthorized access or abuse our App, and we make no warranty, express, implied or otherwise, that we will prevent such access.\n\nTransfer of data outside the EEA\nPlease note that some data recipients may be located outside the EEA. In such cases we will transfer your data only to such countries as approved by the European Commission as providing adequate level of data protection, or enter into legal agreements ensuring an adequate level of data protection. Data collected from Users located in the United States is stored in the United States.\n\nAdvertisements\nWe do not use third-party advertising technology to serve advertisements when you access the App.\n\nMarketing\nWe may use your Personal Information, such as your name, email address to send you a Newsletter about our products and services. You may opt out of receiving this Newsletter at any time by unsubscribing via the link in the newsletter.\nThird Parties\nThe App may contain links to other websites, products, or services that we do not own or operate. We are not responsible for the privacy\npractices of these third parties. Please be aware that this Privacy Policy does not apply to your activities on these third-party services or any information you disclose to these third parties. We encourage you to read their privacy policies before providing any information to them.\n\nUpdates or amendments to this Privacy Policy\nWe reserve the right to periodically amend or revise the Privacy Policy; material changes will be effective immediately upon the display of the revised Privacy policy. The last revision will be reflected in the “Last modified” section. If we materially change the ways in which we use or share personal information collected from you, we will notify you through the App, by email, or other communication. Your continued use of our Services following the notification of such amendments on our Website or through the App, constitutes your acknowledgment and consent of such amendments to the Privacy Policy and your agreement to be bound by the terms of such amendments.\n\nHow to contact us\nIf you have any general questions about the App or the information we collect about you and how we use it, you can contact us at:\nsupport@givt.app or by phone at 918-615-9611.\n'**
  String get policyTextUs;

  /// No description provided for @termsTextUs.
  ///
  /// In en, this message translates to:
  /// **'GIVT INC.\n Terms of Use for Giving with Givt \n Last updated: July 13th, 2022\n Version: 1.2\n These terms of use describe the conditions under which you can use the services made available through the mobile or other downloadable application and website owned by Givt, Inc. (\"Givt\", and \"Service\" respectively) can be utilized by you, the User (\"you\"). These Terms of Use are a legally binding contract between you and Givt regarding your use of the Service.\n BY DOWNLOADING, INSTALLING, OR OTHERWISE ACCESSING OR USING THE SERVICE, YOU AGREE THAT YOU HAVE READ AND UNDERSTOOD, AND, AS A CONDITION TO YOUR USE OF THE SERVICE, YOU AGREE TO BE BOUND BY, THE FOLLOWING TERMS AND CONDITIONS, INCLUDING GIVT\'S PRIVACY POLICY (https://www.givt.app/privacy-policy) (TOGETHER, THESE \"TERMS\"). If you are not eligible, or do not agree to the Terms, then you do not have our permission to use the Service. YOUR USE OF THE SERVICE, AND GIVT\'S PROVISION OF THE SERVICE TO YOU, CONSTITUTES AN AGREEMENT BY GIVT AND BY YOU TO BE BOUND BY THESE TERMS.\n Arbitration NOTICE. Except for certain kinds of disputes described in Section 12, you agree that disputes arising under these Terms will be resolved by binding, individual arbitration, and BY ACCEPTING THESE TERMS, YOU AND GIVT ARE EACH WAIVING THE RIGHT TO A TRIAL BY JURY OR TO PARTICIPATE IN ANY CLASS ACTION OR REPRESENTATIVE PROCEEDING.\n 1. Givt Service Overview. Givt provides its users with a platform to make anonymous donations to any of the entities properly registered with Givt as a recipient of donations (\"Recipient\"). The Service is available for users through their smartphones, and other electronic device. \n 2. Eligibility. You must be at least 18 years old to use the Service. By agreeing to these Terms, you represent and warrant to us that: (a) you are at least 18 years old; (b) you have not previously been suspended or removed from the Service; and (c) your registration and your use of the Service is in compliance with any and all applicable laws and regulations. If you are an entity, organization, or company, the individual accepting these Terms on your behalf represents and warrants that they have authority to bind you to these Terms and you agree to be bound by these Terms. \n 3. Accounts and Registration. To access the Service, you must register for an account. When you register for an account, you may be required to provide us with some information about yourself, such as your (i) name (ii) address, (iii) phone number, and (iv) e-mail address. You agree that the information you provide to us is accurate, complete, and not misleading, and that you will keep it accurate and up to date at all times. When you register, you will be asked to create a password. You are solely responsible for maintaining the confidentiality of your account and password, and you accept responsibility for all activities that occur under your account. If you believe that your account is no longer secure, then you should immediately notify us at support@givt.app.\n 4. Processing Donations\n 4.1. Givt does not provide banking or payment services. To facilitate the processing and transfer of donations from you to Recipients, Givt has entered into an agreement with a third party payment processor (the \"Processor\"). The amount of your donation that is actually received by a Recipient will be net of fees and other charges imposed by Givt and Processor.\n 4.2. The transaction data, including the applicable designated Recipient, will be processed by Givt and forwarded to the Processor. The Processor will, subject to the Processor\'s online terms and conditions, initiate payment transactions to the bank account of the applicable designated Recipient. For the full terms of the transfer of donations, including chargeback, reversals, fees and charges, and limitations on the amount of a donation please see Processor\'s online terms and conditions.\n 4.3. You agree that Givt may pass your transaction and bank data to the Processor, along with all other necessary account and personal information, in order to enable the Processor to initiate the transfer of donations from you to Recipients. Givt reserves the right to change of Processor at any time. You agree that Givt may forward relevant information and data as set forth in this Section 4.3 to the new Processor in order to continue the processing and transfer of donations from you to Recipients.\n 5. License and intellectual property rights\n 5.1. Limited License. Subject to your complete and ongoing compliance with these Terms, Givt grants you a non-exclusive, non-sublicensable and non-transmittable license to (a) install and use one object code copy of any mobile or other downloadable application associated with the Service (whether installed by you or pre-installed on your mobile device manufacturer or a wireless telephone provider) on a mobile device that you own or control; (b) access and use the Service. You are not allowed to use the Service for commercial purposes.\n 5.2. License Restrictions. Except and solely to the extent such a restriction is impermissible under applicable law, you may not: (a) provide the Service to third parties; (b) reproduce, distribute, publicly display, publicly perform, or create derivative works for the Service; (c) decompile, submit to reverse engineer or modify the Service; (d), remove or bypass the technical provisions that are intended to protect the Service and/or Givt. If you are prohibited under applicable law from using the Service, then you may not use it. \n 5.3. Ownership; Proprietary Rights. The Service is owned and operated by Givt. The visual interfaces, graphics, design, compilation, information, data, computer code (including source code or object code), products, software, services, and all other elements of the Service provided by Givt (\"Materials\") are protected by intellectual property and other laws. All Materials included in the Service are the property of Givt or its third-party licensors. Except as expressly authorized by Givt, you may not make use of the Materials. There are no implied licenses in these Terms and Givt reserves all rights to the Materials not granted expressly in these Terms.\n 5.4. Feedback. We respect and appreciate the thoughts and comments from our users. If you choose to provide input and suggestions regarding existing functionalities, problems with or proposed modifications or improvements to the Service (\"Feedback\"), then you hereby grant Givt an unrestricted, perpetual, irrevocable, non-exclusive, fully paid, royalty-free right and license to exploit the Feedback in any manner and for any purpose, including to improve the Service and create other products and services. We will have no obligation to provide you with attribution for any Feedback you provide to us.\n 6. Third-Party Software. The Service may include or incorporate third-party software components that are generally available free of charge under licenses granting recipients broad rights to copy, modify, and distribute those components (\"Third-Party Components\"). Although the Service is provided to you subject to these Terms, nothing in these Terms prevents, restricts, or is intended to prevent or restrict you from obtaining Third-Party Components under the applicable third-party licenses or to limit your use of Third-Party Components under those third-party licenses.\n 7. Prohibited Conduct. BY USING THE SERVICE, YOU AGREE NOT TO:\n 7.1. use the Service for any illegal purpose or in violation of any local, state, national, or international law;\n 7.2. violate, encourage others to violate, or provide instructions on how to violate, any right of a third party, including by infringing or misappropriating any third-party intellectual property right;\n 7.3. interfere with security-related features of the Service, including by: (i) disabling or circumventing features that prevent or limit use, printing or copying of any content; or (ii) reverse engineering or otherwise attempting to discover the source code of any portion of the Service except to the extent that the activity is expressly permitted by applicable law;\n 7.4. interfere with the operation of the Service or any user\'s enjoyment of the Service, including by: (i) uploading or otherwise disseminating any virus, adware, spyware, worm, or other malicious code; (ii) making any unsolicited offer or advertisement to another user of the Service; (iii) collecting personal information about another user or third party without consent; or (iv) interfering with or disrupting any network, equipment, or server connected to or used to provide the Service;\n 7.5. perform any fraudulent activity including impersonating any person or entity, claiming a false affiliation or identity, accessing any other Service account without permission, or falsifying your age or date of birth;\n 7.6. sell or otherwise transfer the access granted under these Terms or any Materials or any right or ability to view, access, or use any Materials; or\n 7.7. attempt to do any of the acts described in this Section 7 or assist or permit any person in engaging in any of the acts described in this Section 7.\n 8. Term, Termination, and Modification of the Service\n 8.1. Term. These Terms are effective beginning when you accept the Terms or first download, install, access, or use the Service, and ending when terminated as described in Section 8.2.\n 8.2. Termination. If you violate any provision of these Terms, then your authorization to access the Service and these Terms automatically terminate. These Terms will end by operation of law in the event you are declared bankrupt, you apply for a moratorium on payments or a general attachment is levied against your assets, in the event of your death, or in the event you go into liquidation, are wound up or dissolved. Following the termination of these Terms (for whatever reason), you shall cease and desist from all further use of Givt. You must then delete all copies (including back-up copies) of Givt from all your systems.\n 8.3. In addition, Givt may, at its sole discretion, terminate these Terms or your account on the Service, or suspend or terminate your access to the Service, at any time for any reason or no reason, with or without notice, and without any liability to you arising from such termination. You may terminate your account and these Terms at any time by deleting or uninstalling the Service, or as otherwise indicated within the Service, or by contacting customer service at support@givt.app. In the event your smartphone, or other electronic device on which the Services are installed, is lost or stolen, inform Givt immediately by contacting support@givt.app. Upon receipt of a message Givt will use commercially reasonable efforts to block the account to prevent further misuse.\n 8.4. Effect of Termination. Upon termination of these Terms: (a) your license rights will terminate and you must immediately cease all use of the Service; (b) you will no longer be authorized to access your account or the Service. If your account has been terminated for a breach of these Terms, then you are prohibited from creating a new account on the Service using a different name, email address or other forms of account verification.\n 8.5. Modification of the Service. Givt reserves the right to modify or discontinue all or any portion of the Service at any time (including by limiting or discontinuing certain features of the Service), temporarily or permanently, without notice to you. Givt will have no liability for any change to the Service, or any suspension or termination of your access to or use of the Service. \n 9. Indemnity. To the fullest extent permitted by law, you are responsible for your use of the Service, and you will defend and indemnify Givt, its affiliates and their respective shareholders, directors, managers, members, officers, employees, consultants, and agents (together, the \"Givt Entities\") from and against every claim brought by a third party, and any related liability, damage, loss, and expense, including attorneys\' fees and costs, arising out of or connected with: (1) your unauthorized use of, or misuse of, the Service; (2) your violation of any portion of these Terms, any representation, warranty, or agreement referenced in these Terms, or any applicable law or regulation; (3) your violation of any third-party right, including any intellectual property right or publicity, confidentiality, other property, or privacy right; or (4) any dispute or issue between you and any third party. We reserve the right, at our own expense, to assume the exclusive defense and control of any matter otherwise subject to indemnification by you (without limiting your indemnification obligations with respect to that matter), and in that case, you agree to cooperate with our defense of those claims.\n 10. Disclaimers; No Warranties.\n THE SERVICE AND ALL MATERIALS AND CONTENT AVAILABLE THROUGH THE SERVICE ARE PROVIDED \"AS IS\" AND ON AN \"AS AVAILABLE\" BASIS. GIVT DISCLAIMS ALL WARRANTIES OF ANY KIND, WHETHER EXPRESS OR IMPLIED, RELATING TO THE SERVICE AND ALL MATERIALS AND CONTENT AVAILABLE THROUGH THE SERVICE, INCLUDING: (A) ANY IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, QUIET ENJOYMENT, OR NON-INFRINGEMENT; AND (B) ANY WARRANTY ARISING OUT OF COURSE OF DEALING, USAGE, OR TRADE. GIVT DOES NOT WARRANT THAT THE SERVICE OR ANY PORTION OF THE SERVICE, OR ANY MATERIALS OR CONTENT OFFERED THROUGH THE SERVICE, WILL BE UNINTERRUPTED, SECURE, OR FREE OF ERRORS, VIRUSES, OR OTHER HARMFUL COMPONENTS, AND GIVT DOES NOT WARRANT THAT ANY OF THOSE ISSUES WILL BE CORRECTED.\n NO ADVICE OR INFORMATION, WHETHER ORAL OR WRITTEN, OBTAINED BY YOU FROM THE SERVICE OR GIVT ENTITIES OR ANY MATERIALS OR CONTENT AVAILABLE THROUGH THE SERVICE WILL CREATE ANY WARRANTY REGARDING ANY OF THE GIVT ENTITIES OR THE SERVICE THAT IS NOT EXPRESSLY STATED IN THESE TERMS. WE ARE NOT RESPONSIBLE FOR ANY DAMAGE THAT MAY RESULT FROM THE SERVICE AND YOUR DEALING WITH ANY OTHER SERVICE USER. WE DO NOT GUARANTEE THE STATUS OF ANY ORGANIZATION, INCLUDING WHETHER AN ORGANIZATION IS A NOT-FOR-PROFIT, CHARITABLE, OR OTHER SIMILAR ORGANIZATION UNDER APPLICABLE LAWS, AND WE DO NOT MAKE ANY REPRESENTATIONS REGARDING THE TAX TREATMENT OF ANY DONATIONS, GIFTS, OR OTHER MONEYS TRANSFERRED OR OTHERWISE PROVIDED TO ANY SUCH ORGANIZATION. YOU ARE SOLELY RESPONSIBLE FOR DETERMINING WHETHER AN ORGANIZATION QUALIFIES AS A NOT-FOR-PROFIT, CHARITABLE, OR OTHER SIMILAR ORGANIZATION UNDER APPLICABLE LAWS AND TO UNDERSTAND THE TAX TREATMENT OF ANY DONATIONS, GIFTS OR OTHER MONEYS TRANSFERRED OR PROVIDED TO SUCH ORGANIZATIONS. YOU UNDERSTAND AND AGREE THAT YOU USE ANY PORTION OF THE SERVICE AT YOUR OWN DISCRETION AND RISK, AND THAT WE ARE NOT RESPONSIBLE FOR ANY DAMAGE TO YOUR PROPERTY (INCLUDING YOUR COMPUTER SYSTEM OR MOBILE DEVICE USED IN CONNECTION WITH THE SERVICE) OR ANY LOSS OF DATA, INCLUDING USER CONTENT.\n THE LIMITATIONS, EXCLUSIONS AND DISCLAIMERS IN THIS SECTION APPLY TO THE FULLEST EXTENT PERMITTED BY LAW. Givt does not disclaim any warranty or other right that Givt is prohibited from disclaiming under applicable law.\n 11. Liability\n 11.1. TO THE FULLEST EXTENT PERMITTED BY LAW, IN NO EVENT WILL THE GIVT ENTITIES BE LIABLE TO YOU FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL OR PUNITIVE DAMAGES (INCLUDING DAMAGES FOR LOSS OF PROFITS, GOODWILL, OR ANY OTHER INTANGIBLE LOSS) ARISING OUT OF OR RELATING TO YOUR ACCESS TO OR USE OF, OR YOUR INABILITY TO ACCESS OR USE, THE SERVICE OR ANY MATERIALS OR CONTENT ON THE SERVICE, WHETHER BASED ON WARRANTY, CONTRACT, TORT (INCLUDING NEGLIGENCE), STATUTE, OR ANY OTHER LEGAL THEORY, AND WHETHER OR NOT ANY GIVT ENTITY HAS BEEN INFORMED OF THE POSSIBILITY OF DAMAGE.\n 11.2. EXCEPT AS PROVIDED IN SECTIONS 11.2 AND 11.3 AND TO THE FULLEST EXTENT PERMITTED BY LAW, THE AGGREGATE LIABILITY OF THE GIVT ENTITIES TO YOU FOR ALL CLAIMS ARISING OUT OF OR RELATING TO THE USE OF OR ANY INABILITY TO USE ANY PORTION OF THE SERVICE OR OTHERWISE UNDER THESE TERMS, WHETHER IN CONTRACT, TORT, OR OTHERWISE, IS LIMITED TO US\$100.\n 11.3. EACH PROVISION OF THESE TERMS THAT PROVIDES FOR A LIMITATION OF LIABILITY, DISCLAIMER OF WARRANTIES, OR EXCLUSION OF DAMAGES IS INTENDED TO AND DOES ALLOCATE THE RISKS BETWEEN THE PARTIES UNDER THESE TERMS. THIS ALLOCATION IS AN ESSENTIAL ELEMENT OF THE BASIS OF THE BARGAIN BETWEEN THE PARTIES. EACH OF THESE PROVISIONS IS SEVERABLE AND INDEPENDENT OF ALL OTHER PROVISIONS OF THESE TERMS. THE LIMITATIONS IN THIS SECTION 11 WILL APPLY EVEN IF ANY LIMITED REMEDY FAILS OF ITS ESSENTIAL PURPOSE.\n 12. Dispute Resolution and Arbitration\n 12.1. Generally. Except as described in Section 12.2 and 12.3, you and Givt agree that every dispute arising in connection with these Terms, the Service, or communications from us will be resolved through binding arbitration. Arbitration uses a neutral arbitrator instead of a judge or jury, is less formal than a court proceeding, may allow for more limited discovery than in court, and is subject to very limited review by courts. This agreement to arbitrate disputes includes all claims whether based in contract, tort, statute, fraud, misrepresentation, or any other legal theory, and regardless of whether a claim arises during or after the termination of these Terms. Any dispute relating to the interpretation, applicability, or enforceability of this binding arbitration agreement will be resolved by the arbitrator.\n YOU UNDERSTAND AND AGREE THAT, BY ENTERING INTO THESE TERMS, YOU AND GIVT ARE EACH WAIVING THE RIGHT TO A TRIAL BY JURY OR TO PARTICIPATE IN A CLASS ACTION.\n 12.2. Exceptions. Although we are agreeing to arbitrate most disputes between us, nothing in these Terms will be deemed to waive, preclude, or otherwise limit the right of either party to: (a) bring an individual action in small claims court; (b) pursue an enforcement action through the applicable federal, state, or local agency if that action is available; (c) seek injunctive relief in a court of law in aid of arbitration; or (d) to file suit in a court of law to address an intellectual property infringement claim.\n 12.3. Opt-Out. If you do not wish to resolve disputes by binding arbitration, you may opt out of the provisions of this Section 12 within 30 days after the date that you agree to these Terms by sending an e-mail to Givt Inc. at support@givt.app, with the following subject line: \"Legal Department – Arbitration Opt-Out\", that specifies: your full legal name, the email address associated with your account on the Service, and a statement that you wish to opt out of arbitration (\"Opt-Out Notice\"). Once Givt receives your Opt-Out Notice, this Section 12 will be void and any action arising out of these Terms will be resolved as set forth in Section 12.2. The remaining provisions of these Terms will not be affected by your Opt-Out Notice.\n 12.4. Arbitrator. This arbitration agreement, and any arbitration between us, is subject to the Federal Arbitration Act and will be administered by the American Arbitration Association (\"AAA\") under its Consumer Arbitration Rules (collectively, \"AAA Rules\") as modified by these Terms. The AAA Rules and filing forms are available online at www.adr.org, by calling the AAA at +1-800-778-7879, or by contacting Givt.\n 12.5. Commencing Arbitration. Before initiating arbitration, a party must first send a written notice of the dispute to the other party by e-mail mail (\"Notice of Arbitration\"). Givt\'s e-address for Notice is: support@givt.app. The Notice of Arbitration must: (a) include the following subject line: \"Notice of Arbitration\"; (b) identify the name or account number of the party making the claim; (c) describe the nature and basis of the claim or dispute; and (d) set forth the specific relief sought (\"Demand\"). The parties will make good faith efforts to resolve the claim directly, but if the parties do not reach an agreement to do so within 30 days after the Notice of Arbitration is received, you or Givt may commence an arbitration proceeding. If you commence arbitration in accordance with these Terms, Givt will reimburse you for your payment of the filing fee, unless your claim is for more than US\$10,000 or if Givt has received 25 or more similar demands for arbitration, in which case the payment of any fees will be decided by the AAA Rules. If the arbitrator finds that either the substance of the claim or the relief sought in the Demand is frivolous or brought for an improper purpose (as measured by the standards set forth in Federal Rule of Civil Procedure 11(b)), then the payment of all fees will be governed by the AAA Rules and the other party may seek reimbursement for any fees paid to AAA.\n 12.6. Arbitration Proceedings. Any arbitration hearing will take place in Fulton County, Georgia unless we agree otherwise or, if the claim is for US\$10,000 or less (and does not seek injunctive relief), you may choose whether the arbitration will be conducted: (a) solely on the basis of documents submitted to the arbitrator; (b) through a telephonic or video hearing; or (c) by an in-person hearing as established by the AAA Rules in the county (or parish) of your residence. During the arbitration, the amount of any settlement offer made by you or Givt must not be disclosed to the arbitrator until after the arbitrator makes a final decision and award, if any. Regardless of the manner in which the arbitration is conducted, the arbitrator must issue a reasoned written decision sufficient to explain the essential findings and conclusions on which the decision and award, if any, are based. \n 12.7. Arbitration Relief. Except as provided in Section 12.8, the arbitrator can award any relief that would be available if the claims had been brough in a court of competent jurisdiction. If the arbitrator awards you an amount higher than the last written settlement amount offered by Givt before an arbitrator was selected, Givt will pay to you the higher of: (a) the amount awarded by the arbitrator and (b) US\$10,000. The arbitrator\'s award shall be final and binding on all parties, except (1) for judicial review expressly permitted by law or (2) if the arbitrator\'s award includes an award of injunctive relief against a party, in which case that party shall have the right to seek judicial review of the injunctive relief in a court of competent jurisdiction that shall not be bound by the arbitrator\'s application or conclusions of law. Judgment on the award may be entered in any court having jurisdiction.\n 12.8. No Class Actions. YOU AND GIVT AGREE THAT EACH MAY BRING CLAIMS AGAINST THE OTHER ONLY IN YOUR OR ITS INDIVIDUAL CAPACITY AND NOT AS A PLAINTIFF OR CLASS MEMBER IN ANY PURPORTED CLASS OR REPRESENTATIVE PROCEEDING. Further, unless both you and Givt agree otherwise, the arbitrator may not consolidate more than one person\'s claims and may not otherwise preside over any form of a representative or class proceeding.  \n 12.9. Modifications to this Arbitration Provision. If Givt makes any substantive change to this arbitration provision, you may reject the change by sending us written notice within 30 days of the change to Givt\'s address for Notice of Arbitration, in which case your account with Givt will be immediately terminated and this arbitration provision, as in effect immediately prior to the changes you rejected will survive.\n 12.10. Enforceability. If Section 12.8 or the entirety of this Section 12.10 is found to be unenforceable, or if Givt receives an Opt-Out Notice from you, then the entirety of this Section 12 will be null and void and, in that case, the exclusive jurisdiction and venue described in Section 13.2 will govern any action arising out of or related to these Terms. \n \n\n 13. Miscellaneous \n 13.1. General Terms. These Terms, including the Privacy Policy and any other agreements expressly incorporated by reference into these Terms, are the entire and exclusive understanding and agreement between you and Givt regarding your use of the Service. You may not assign or transfer these Terms or your rights under these Terms, in whole or in part, by operation of law or otherwise, without our prior written consent. We may assign these Terms and all rights granted under these Terms, at any time without notice or consent. The failure to require performance of any provision will not affect our right to require performance at any other time after that, nor will a waiver by us of any breach or default of these Terms, or any provision of these Terms, be a waiver of any subsequent breach or default or a waiver of the provision itself. Use of Section headers in these Terms is for convenience only and will not have any impact on the interpretation of any provision. Throughout these Terms the use of the word \"including\" means \"including but not limited to.\" If any part of these Terms is held to be invalid or unenforceable, then the unenforceable part will be given effect to the greatest extent possible, and the remaining parts will remain in full force and effect.\n 13.2. Governing Law. These Terms are governed by the laws of the State of Delaware without regard to conflict of law principles. You and Givt submit to the personal and exclusive jurisdiction of the state courts and federal courts located within Fulton County, Georgia for resolution of any lawsuit or court proceeding permitted under these Terms. We operate the Service from our offices in Georgia, and we make no representation that Materials included in the Service are appropriate or available for use in other locations.\n 13.3. Privacy Policy. Please read the Givt Privacy Policy (https://www.givt.app/privacy-policy) carefully for information relating to our collection, use, storage, and disclosure of your personal information. The Givt Privacy Policy is incorporated by this reference into, and made a part of, these Terms. \n 13.4. Additional Terms. Your use of the Service is subject to all additional terms, policies, rules, or guidelines applicable to the Service or certain features of the Service that we may post on or link to from the Service (the \"Additional Terms\"). All Additional Terms are incorporated by this reference into, and made a part of, these Terms.\n 13.5. Modification of these Terms. We reserve the right to change these Terms on a going-forward basis at any time. Please check these Terms periodically for changes. If a change to these Terms materially modifies your rights or obligations, we may require that you accept the modified Terms in order to continue to use the Service. Material modifications are effective upon your acceptance of the modified Terms. Immaterial modifications are effective upon publication. Except as expressly permitted in this Section 13.5, these Terms may be amended only by a written agreement signed by authorized representatives of the parties to these Terms. Disputes arising under these Terms will be resolved in accordance with the version of these Terms that was in effect at the time the dispute arose.\n 13.6. Consent to Electronic Communications. By using the Service, you consent to receiving certain electronic communications from us as further described in our Privacy Policy. Please read our Privacy Policy to learn more about our electronic communications practices. You agree that any notices, agreements, disclosures, or other communications that we send to you electronically will satisfy any legal communication requirements, including that those communications be in writing.\n 13.7. Contact Information. The Service is offered by Givt Inc. located at\n 3343 12 N Cheyenne Ave, #305 TULSA, OK, 74103. You may contact us by emailing us at support@givt.app.\n 13.8. Notice to California Residents. If you are a California resident, then under California Civil Code Section 1789.3, you may contact the Complaint Assistance Unit of the Division of Consumer Services of the California Department of Consumer Affairs in writing at 1625 N. Market Blvd., Suite S-202, Sacramento, California 95834, or by telephone at +1-800-952-5210 in order to resolve a complaint regarding the Service or to receive further information regarding use of the Service.\n 13.9. No Support. We are under no obligation to provide support for the Service. In instances where we may offer support, the support will be subject to published policies.\n 13.10. International Use. The Service is intended for visitors located within the United States. We make no representation that the Service is appropriate or available for use outside of the United States. Access to the Service from countries or territories or by individuals where such access is illegal is prohibited.\n 13.11. Complaints. Givt handles complaints efficiently and as soon as reasonably possible. Any complaint about the implementation of these Terms by Givt must be submitted in writing at Givt via e-mail to support@givt.app.\n 13.12. Notice Regarding Apple. This Section 13 only applies to the extent you are using our mobile application on an iOS device. You acknowledge that these Terms are between you and Givt only, not with Apple Inc. (\"Apple\"), and Apple is not responsible for the Service or the content of it. Apple has no obligation to furnish any maintenance and support services with respect to the Service. If the Service fails to conform to any applicable warranty, you may notify Apple, and Apple will refund any applicable purchase price for the mobile application to you. To the maximum extent permitted by applicable law, Apple has no other warranty obligation with respect to the Service. Apple is not responsible for addressing any claims by you or any third party relating to the Service or your possession and/or use of the Service, including: (1) product liability claims; (2) any claim that the Service fails to conform to any applicable legal or regulatory requirement; or (3) claims arising under consumer protection or similar legislation. Apple is not responsible for the investigation, defense, settlement, and discharge of any third-party claim that the Service and/or your possession and use of the Service infringe a third party\'s intellectual property rights. You agree to comply with any applicable third-party terms when using the Service. Apple and Apple\'s subsidiaries are third-party beneficiaries of these Terms, and upon your acceptance of these Terms, Apple will have the right (and will be deemed to have accepted the right) to enforce these Terms against you as a third-party beneficiary of these Terms. You hereby represent and warrant that: (a) you are not located in a country that is subject to a U.S. Government embargo or that has been designated by the U.S. Government as a \"terrorist supporting\" country; and (b) you are not listed on any U.S. Government list of prohibited or restricted parties.\n\n'**
  String get termsTextUs;

  /// No description provided for @informationAboutUsUs.
  ///
  /// In en, this message translates to:
  /// **'Givt is a product of Givt Inc\n \n\n We are located at 12 N Cheyenne Ave, #305, Tulsa, OK, 74103. For questions or complaints you can reach us via +1 918-615-9611 or support@givt.app\n \n\n We are incorporated in Delaware.'**
  String get informationAboutUsUs;

  /// No description provided for @faQantwoord0Us.
  ///
  /// In en, this message translates to:
  /// **'In the app-menu under \"About Givt / Contact\" there\'s a text field where you can type a message and send it to us. Of course you can also contact us by calling +1 918-615-9611 or by sending an e-mail to support@givt.app.'**
  String get faQantwoord0Us;

  /// No description provided for @invalidQRcodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Inactive QR code'**
  String get invalidQRcodeTitle;

  /// No description provided for @invalidQRcodeMessage.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, this QR code is no longer active. Would you like to give to the general funds of {value0}?'**
  String invalidQRcodeMessage(Object value0);

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @registrationErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration cannot be completed'**
  String get registrationErrorTitle;

  /// No description provided for @cantCancelAlreadyProcessed.
  ///
  /// In en, this message translates to:
  /// **'Alas, you can\'t cancel this donation because it is already processed.'**
  String get cantCancelAlreadyProcessed;

  /// No description provided for @countryStringUs.
  ///
  /// In en, this message translates to:
  /// **'United States of America'**
  String get countryStringUs;

  /// No description provided for @enterPaymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter Payment Details'**
  String get enterPaymentDetails;

  /// No description provided for @directNoticeText.
  ///
  /// In en, this message translates to:
  /// **'Givt Direct Notice to Parents  \nIn order to allow your child to use Givt, an application through which younger users can direct donations, linked to and controlled by your Givt account, we have collected your online contact information, as well as your and your child’s name, for the purpose of obtaining your consent to collect, use, and disclose personal information from your child. \nParental consent is required for Givt to collect, use, or disclose your child\'s personal information. Givt will not collect, use, or disclose personal information from your child if you do not provide consent. As a parent, you provide your consent by completing a nominal payment card charge in your account on the Givt app. If you do not provide consent within a reasonable time, Givt will delete your information from its records, however Givt will retain any information it has collected from you as a standard Givt user, subject to Givt’s standard privacy policy www.givt.app/privacy-policy/ \nThe Givt Privacy Policy for Children Under the Age of 13 www.givt.app/privacy-policy-givt4kids/ provides details regarding how and what personal information we collect, use, and disclose from children under 13 using Givt (the “Application”). \nInformation We Collect from Children\nWe only collect as much information about a child as is reasonably necessary for the child to participate in an activity, and we do not condition his or her participation on the disclosure of more personal information than is reasonably necessary.  \nInformation We Collect Directly \nWe may request information from your child, but this information is optional. We specify whether information is required or optional when we request it. For example, if a child chooses to provide it, we collect information about the child’s choices and preferences, the child’s donation choices, and any good deeds that the child records. \nAutomatic Information Collection and Tracking\nWe use technology to automatically collect information from our users, including children, when they access and navigate through the Application and use certain of its features. The information we collect through these technologies may include: \nOne or more persistent identifiers that can be used to recognize a user over time and across different websites and online services, such as IP address and unique identifiers (e.g. MAC address and UUID); and,\nInformation that identifies a device\'s location (geolocation information).\nWe also may combine non-personal information we collect through these technologies with personal information about you or your child that we collect online.  \nHow We Use Your Child\'s Information\nWe use the personal information we collect from your child to: \nfacilitate donations that your child chooses;\ncommunicate with him or her about activities or features of the Application,;\ncustomize the content presented to a child using the Application;\nRecommend donation opportunities that may be of interest to your child; and,\ntrack his or her use of the Application. \nWe use the information we collect automatically through technology (see Automatic Information Collection and Tracking) and other non-personal information we collect to improve our Application and to deliver a better and more personalized experience by enabling us to:\nEstimate our audience size and usage patterns.\nStore information about the child\'s preferences, allowing us to customize the content according to individual interests.\nWe use geolocation information we collect to determine whether the user is in a location where it’s possible to use the Application for donating. \nOur Practices for Disclosing Children\'s Information\nWe may disclose aggregated information about many of our users, and information that does not identify any individual or device. In addition, we may disclose children\'s personal information:\nTo third parties we use to support the internal operations of our Application.\nIf we are required to do so by law or legal process, such as to comply with any court order or subpoena or to respond to any government or regulatory request.\nIf we believe disclosure is necessary or appropriate to protect the rights, property, or safety of Givt, our customers or others, including to:\nprotect the safety of a child;\nprotect the safety and security of the Application; or\nenable us to take precautions against liability.\nTo law enforcement agencies or for an investigation related to public safety. \nIf Givt is involved in a merger, divestiture, restructuring, reorganization, dissolution, or other sale or transfer of some or all of Givt\'s assets, whether as a going concern or as part of bankruptcy, liquidation, or similar proceeding or event, we may transfer the personal information we have collected or maintain to the buyer or other successor. \nSocial Features \nThe Application allows parents to view information about their child’s donation activities and any good deeds that the child records, and parents may provide certain responses to this information. \nAccessing and Correcting Your Child\'s Personal Information\nAt any time, you may review the child\'s personal information maintained by us, require us to correct or delete the personal information, and/or refuse to permit us from further collecting or using the child\'s information.  \nYou can review, change, or delete your child\'s personal information by:\nLogging into your account and accessing the profile page relating to your child.\nSending us an email at support@givt.app. To protect your and your child’s privacy and security, we may require you to take certain steps or provide additional information to verify your identity before we provide any information or make corrections. \nOperators That Collect or Maintain Information from Children\nGivt Inc. is the operator that collects and maintains personal information from children through the Application.Givt can be contacted at support@givt.app, by mail at 12 N Cheyenne Ave, #305, Tulsa, OK, 74103. , or by phone at +1 918-615-9611.'**
  String get directNoticeText;

  /// No description provided for @mobileNumberUsDigits.
  ///
  /// In en, this message translates to:
  /// **'1231231234'**
  String get mobileNumberUsDigits;

  /// No description provided for @createChildNameErrorTextFirstPart1.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least '**
  String get createChildNameErrorTextFirstPart1;

  /// No description provided for @createChildNameErrorTextFirstPart2.
  ///
  /// In en, this message translates to:
  /// **' characters.'**
  String get createChildNameErrorTextFirstPart2;

  /// No description provided for @createChildAllowanceErrorText.
  ///
  /// In en, this message translates to:
  /// **'Giving allowance must be greater than zero.'**
  String get createChildAllowanceErrorText;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// No description provided for @childInWalletPostfix.
  ///
  /// In en, this message translates to:
  /// **' in Wallet'**
  String get childInWalletPostfix;

  /// No description provided for @childEditProfileErrorText.
  ///
  /// In en, this message translates to:
  /// **'Cannot update child profile. Please try again later.'**
  String get childEditProfileErrorText;

  /// No description provided for @childEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get childEditProfile;

  /// No description provided for @childHistoryBy.
  ///
  /// In en, this message translates to:
  /// **'by'**
  String get childHistoryBy;

  /// No description provided for @childHistoryTo.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get childHistoryTo;

  /// No description provided for @childHistoryToBeApproved.
  ///
  /// In en, this message translates to:
  /// **'To be approved'**
  String get childHistoryToBeApproved;

  /// No description provided for @childHistoryCanContinueMakingADifference.
  ///
  /// In en, this message translates to:
  /// **'can continue making a difference'**
  String get childHistoryCanContinueMakingADifference;

  /// No description provided for @childHistoryYay.
  ///
  /// In en, this message translates to:
  /// **'Yay!'**
  String get childHistoryYay;

  /// No description provided for @childHistoryAllGivts.
  ///
  /// In en, this message translates to:
  /// **'All givts'**
  String get childHistoryAllGivts;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @childParentalApprovalApprovedTitle.
  ///
  /// In en, this message translates to:
  /// **'Yes, {value0} has made a difference!'**
  String childParentalApprovalApprovedTitle(Object value0);

  /// No description provided for @childParentalApprovalApprovedSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you'**
  String get childParentalApprovalApprovedSubTitle;

  /// No description provided for @childParentalApprovalConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'{value0} would love to give'**
  String childParentalApprovalConfirmationTitle(Object value0);

  /// No description provided for @childParentalApprovalConfirmationSubTitle.
  ///
  /// In en, this message translates to:
  /// **'to {value0}\n{value1}'**
  String childParentalApprovalConfirmationSubTitle(
    Object value0,
    Object value1,
  );

  /// No description provided for @childParentalApprovalConfirmationDecline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get childParentalApprovalConfirmationDecline;

  /// No description provided for @childParentalApprovalConfirmationApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get childParentalApprovalConfirmationApprove;

  /// No description provided for @childParentalApprovalDeclinedTitle.
  ///
  /// In en, this message translates to:
  /// **'You have declined {value0}’s request'**
  String childParentalApprovalDeclinedTitle(Object value0);

  /// No description provided for @childParentalApprovalDeclinedSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Maybe next time?'**
  String get childParentalApprovalDeclinedSubTitle;

  /// No description provided for @childParentalApprovalErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Oops, something went wrong!'**
  String get childParentalApprovalErrorTitle;

  /// No description provided for @childParentalApprovalErrorSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get childParentalApprovalErrorSubTitle;

  /// No description provided for @signUpPageTitle.
  ///
  /// In en, this message translates to:
  /// **''**
  String get signUpPageTitle;

  /// No description provided for @surname.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get surname;

  /// No description provided for @pleaseEnterChildName.
  ///
  /// In en, this message translates to:
  /// **'Please enter the child\'s name'**
  String get pleaseEnterChildName;

  /// No description provided for @pleaseEnterChildAge.
  ///
  /// In en, this message translates to:
  /// **'Please enter the child\'s age'**
  String get pleaseEnterChildAge;

  /// No description provided for @pleaseEnterValidName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid name'**
  String get pleaseEnterValidName;

  /// No description provided for @nameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name is too long'**
  String get nameTooLong;

  /// No description provided for @pleaseEnterValidAge.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid age'**
  String get pleaseEnterValidAge;

  /// No description provided for @addAdultInstead.
  ///
  /// In en, this message translates to:
  /// **'Please add an adult instead'**
  String get addAdultInstead;

  /// No description provided for @ageKey.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageKey;

  /// No description provided for @emptyChildrenDonations.
  ///
  /// In en, this message translates to:
  /// **'Your children\'s donations\nwill appear here'**
  String get emptyChildrenDonations;

  /// No description provided for @almostDone.
  ///
  /// In en, this message translates to:
  /// **'Almost done...'**
  String get almostDone;

  /// No description provided for @weHadTroubleGettingAllowance.
  ///
  /// In en, this message translates to:
  /// **'We had trouble getting money from your account for the giving allowance(s).'**
  String get weHadTroubleGettingAllowance;

  /// No description provided for @noWorriesWeWillTryAgain.
  ///
  /// In en, this message translates to:
  /// **'No worries, we will try again tomorrow!'**
  String get noWorriesWeWillTryAgain;

  /// No description provided for @allowanceOopsCouldntGetAllowances.
  ///
  /// In en, this message translates to:
  /// **'Oops! We couldn\'t get the allowance amount from your account.'**
  String get allowanceOopsCouldntGetAllowances;

  /// No description provided for @weWillTryAgainTmr.
  ///
  /// In en, this message translates to:
  /// **'We will try again tomorrow'**
  String get weWillTryAgainTmr;

  /// No description provided for @weWillTryAgainNxtMonth.
  ///
  /// In en, this message translates to:
  /// **'We will try again next month'**
  String get weWillTryAgainNxtMonth;

  /// No description provided for @editChildWeWIllTryAgain.
  ///
  /// In en, this message translates to:
  /// **'We will try again on: '**
  String get editChildWeWIllTryAgain;

  /// No description provided for @familyGoalStepperCause.
  ///
  /// In en, this message translates to:
  /// **'1. Cause'**
  String get familyGoalStepperCause;

  /// No description provided for @familyGoalStepperAmount.
  ///
  /// In en, this message translates to:
  /// **'2. Amount'**
  String get familyGoalStepperAmount;

  /// No description provided for @familyGoalStepperConfirm.
  ///
  /// In en, this message translates to:
  /// **'3. Confirm'**
  String get familyGoalStepperConfirm;

  /// No description provided for @familyGoalCircleMore.
  ///
  /// In en, this message translates to:
  /// **'+{value0} more'**
  String familyGoalCircleMore(Object value0);

  /// No description provided for @familyGoalOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a Family Goal'**
  String get familyGoalOverviewTitle;

  /// No description provided for @familyGoalConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Launch the Family Goal'**
  String get familyGoalConfirmationTitle;

  /// No description provided for @familyGoalCauseTitle.
  ///
  /// In en, this message translates to:
  /// **'Find a cause'**
  String get familyGoalCauseTitle;

  /// No description provided for @familyGoalAmountTitle.
  ///
  /// In en, this message translates to:
  /// **'Set your giving goal'**
  String get familyGoalAmountTitle;

  /// No description provided for @familyGoalStartMakingHabit.
  ///
  /// In en, this message translates to:
  /// **'Start making giving a habit in your family'**
  String get familyGoalStartMakingHabit;

  /// No description provided for @familyGoalCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get familyGoalCreate;

  /// No description provided for @familyGoalConfirmedTitle.
  ///
  /// In en, this message translates to:
  /// **'Family Goal launched!'**
  String get familyGoalConfirmedTitle;

  /// No description provided for @familyGoalToSupport.
  ///
  /// In en, this message translates to:
  /// **'to support'**
  String get familyGoalToSupport;

  /// No description provided for @familyGoalShareWithFamily.
  ///
  /// In en, this message translates to:
  /// **'Share this with your family and make a difference together'**
  String get familyGoalShareWithFamily;

  /// No description provided for @familyGoalLaunch.
  ///
  /// In en, this message translates to:
  /// **'Launch'**
  String get familyGoalLaunch;

  /// No description provided for @familyGoalHowMuch.
  ///
  /// In en, this message translates to:
  /// **'How much do you want to raise?'**
  String get familyGoalHowMuch;

  /// No description provided for @familyGoalAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Most families start out with an amount of \$100'**
  String get familyGoalAmountHint;

  /// No description provided for @certExceptionTitle.
  ///
  /// In en, this message translates to:
  /// **'A little hiccup'**
  String get certExceptionTitle;

  /// No description provided for @certExceptionBody.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t connect to the server. But no worries, try again later and we\'ll get things sorted out!'**
  String get certExceptionBody;

  /// No description provided for @familyGoalPrefix.
  ///
  /// In en, this message translates to:
  /// **'Family Goal: '**
  String get familyGoalPrefix;

  /// No description provided for @permitBiometricQuestionWithType.
  ///
  /// In en, this message translates to:
  /// **'Do you want to use {value0}?'**
  String permitBiometricQuestionWithType(Object value0);

  /// No description provided for @permitBiometricExplanation.
  ///
  /// In en, this message translates to:
  /// **'Speed up the login process and keep you account secure'**
  String get permitBiometricExplanation;

  /// No description provided for @permitBiometricSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get permitBiometricSkip;

  /// No description provided for @permitBiometricActivateWithType.
  ///
  /// In en, this message translates to:
  /// **'Activate {value0}'**
  String permitBiometricActivateWithType(Object value0);

  /// No description provided for @youHaveBeenInvitedToImpactGroup.
  ///
  /// In en, this message translates to:
  /// **'You have been invited\nto the '**
  String get youHaveBeenInvitedToImpactGroup;

  /// No description provided for @acceptInviteKey.
  ///
  /// In en, this message translates to:
  /// **'Accept the invite'**
  String get acceptInviteKey;

  /// No description provided for @chooseGroup.
  ///
  /// In en, this message translates to:
  /// **'Choose Group'**
  String get chooseGroup;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @genericSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Consider it done!'**
  String get genericSuccessTitle;

  /// No description provided for @topUpScreenInfo.
  ///
  /// In en, this message translates to:
  /// **'How much would you like to add to\nyour child\'s Wallet?'**
  String get topUpScreenInfo;

  /// No description provided for @topUpSuccessText.
  ///
  /// In en, this message translates to:
  /// **'{value0} has been added to\nyour child’s Wallet'**
  String topUpSuccessText(Object value0);

  /// No description provided for @goToSettings.
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get goToSettings;

  /// No description provided for @goToSettingsBody.
  ///
  /// In en, this message translates to:
  /// **'To scan the QR Code we need to turn on the camera. Go to Settings to allow that.'**
  String get goToSettingsBody;

  /// No description provided for @selectCountryHint.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get selectCountryHint;

  /// No description provided for @homescreenLetsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go!'**
  String get homescreenLetsGo;

  /// No description provided for @homescreenJourneyOfGenerosity.
  ///
  /// In en, this message translates to:
  /// **'Start your journey of generosity!'**
  String get homescreenJourneyOfGenerosity;

  /// No description provided for @registrationRandomAvatarError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load avatar.'**
  String get registrationRandomAvatarError;

  /// No description provided for @registrationAvatarSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Select your avatar'**
  String get registrationAvatarSelectionTitle;

  /// No description provided for @registrationParentFirstName.
  ///
  /// In en, this message translates to:
  /// **'Parent first name'**
  String get registrationParentFirstName;

  /// No description provided for @registrationParentLastName.
  ///
  /// In en, this message translates to:
  /// **'Parent last name'**
  String get registrationParentLastName;

  /// No description provided for @homepageParentEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Parent email address'**
  String get homepageParentEmailHint;

  /// No description provided for @addMemberAdultDescription.
  ///
  /// In en, this message translates to:
  /// **'This adult will receive an email adding them to the family, enabling them to also:'**
  String get addMemberAdultDescription;

  /// No description provided for @addMemberAdultReason1.
  ///
  /// In en, this message translates to:
  /// **'Login to Givt with their own account'**
  String get addMemberAdultReason1;

  /// No description provided for @addMemberAdultReason2.
  ///
  /// In en, this message translates to:
  /// **'Approve donations of the children'**
  String get addMemberAdultReason2;

  /// No description provided for @addMemberAdultReason3.
  ///
  /// In en, this message translates to:
  /// **'Explore generosity as a family'**
  String get addMemberAdultReason3;

  /// No description provided for @addMemberAdultEmailSameAsLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'You\'ve already created an account for yourself with this email address'**
  String get addMemberAdultEmailSameAsLoggedIn;

  /// No description provided for @unregisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Terminate account'**
  String get unregisterTitle;

  /// No description provided for @unregisterPrimaryBtnText.
  ///
  /// In en, this message translates to:
  /// **'Terminate account'**
  String get unregisterPrimaryBtnText;

  /// No description provided for @unregisterDescription.
  ///
  /// In en, this message translates to:
  /// **'We’re sorry to see you go!\nAfter terminating your account, we cannot recover it for you.'**
  String get unregisterDescription;

  /// No description provided for @unregisterCheckboxText.
  ///
  /// In en, this message translates to:
  /// **'Yes, I want to terminate my account'**
  String get unregisterCheckboxText;

  /// No description provided for @unregisterLoading.
  ///
  /// In en, this message translates to:
  /// **'Terminating account'**
  String get unregisterLoading;

  /// No description provided for @unregisterSuccessText.
  ///
  /// In en, this message translates to:
  /// **'We’re sad to see you leave and we hope to see you again.'**
  String get unregisterSuccessText;

  /// No description provided for @homeScreenWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get homeScreenWelcome;

  /// No description provided for @homeScreenHeyFamily.
  ///
  /// In en, this message translates to:
  /// **'Hey {family}!'**
  String homeScreenHeyFamily(Object family);

  /// No description provided for @tutorialGratitudeGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Gratitude Game'**
  String get tutorialGratitudeGameTitle;

  /// No description provided for @tutorialGratitudeGameDescription.
  ///
  /// In en, this message translates to:
  /// **'This game helps you to build gratitude by reflecting on your day as a family'**
  String get tutorialGratitudeGameDescription;

  /// No description provided for @homeScreenSecondParentDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'{firstName} needs to use their own account'**
  String homeScreenSecondParentDialogTitle(Object firstName);

  /// No description provided for @homeScreenSecondParentDialogDescription.
  ///
  /// In en, this message translates to:
  /// **'Use the Givt App on your own device'**
  String get homeScreenSecondParentDialogDescription;

  /// No description provided for @homeScreenSecondParentDialogConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get homeScreenSecondParentDialogConfirmButton;

  /// No description provided for @tutorialFirstMissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s complete your first mission!'**
  String get tutorialFirstMissionTitle;

  /// No description provided for @tutorialFirstMissionDescription.
  ///
  /// In en, this message translates to:
  /// **'New missions help your family grow together. Tap above to begin!'**
  String get tutorialFirstMissionDescription;

  /// No description provided for @homeScreenGratitudeGameButtonTitle.
  ///
  /// In en, this message translates to:
  /// **'Family Game'**
  String get homeScreenGratitudeGameButtonTitle;

  /// No description provided for @homeScreenGratitudeGameButtonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play now!'**
  String get homeScreenGratitudeGameButtonSubtitle;

  /// No description provided for @setupFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up Family'**
  String get setupFamilyTitle;

  /// No description provided for @setupFamilyHowManyTitle.
  ///
  /// In en, this message translates to:
  /// **'How many people are in your family?'**
  String get setupFamilyHowManyTitle;

  /// No description provided for @childKey.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get childKey;

  /// No description provided for @adultKey.
  ///
  /// In en, this message translates to:
  /// **'Adult'**
  String get adultKey;

  /// No description provided for @setupFamilyAddNextMember.
  ///
  /// In en, this message translates to:
  /// **'Add next member'**
  String get setupFamilyAddNextMember;

  /// No description provided for @homescreenFamilyWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, super family!'**
  String get homescreenFamilyWelcome;

  /// No description provided for @homescreenFamilyGenerosity.
  ///
  /// In en, this message translates to:
  /// **'Let\'s foster generosity together'**
  String get homescreenFamilyGenerosity;

  /// No description provided for @buttonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get buttonSkip;

  /// No description provided for @leagueUnlockLeague.
  ///
  /// In en, this message translates to:
  /// **'Unlock League'**
  String get leagueUnlockLeague;

  /// No description provided for @leagueUnlocked.
  ///
  /// In en, this message translates to:
  /// **'League Unlocked!'**
  String get leagueUnlocked;

  /// No description provided for @leagueWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the League!'**
  String get leagueWelcome;

  /// No description provided for @leagueExplanation.
  ///
  /// In en, this message translates to:
  /// **'Your XP sets your rank. Grow in generosity and climb to the top!'**
  String get leagueExplanation;

  /// No description provided for @buttonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get buttonDone;

  /// No description provided for @originQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Last step'**
  String get originQuestionTitle;

  /// No description provided for @originQuestionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Where did you get your box?'**
  String get originQuestionSubtitle;

  /// No description provided for @originSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select location'**
  String get originSelectLocation;

  /// No description provided for @homeScreenGiveButtonTitle.
  ///
  /// In en, this message translates to:
  /// **'Give'**
  String get homeScreenGiveButtonTitle;

  /// No description provided for @homeScreenGivtButtonDescription.
  ///
  /// In en, this message translates to:
  /// **'Donate to a cause'**
  String get homeScreenGivtButtonDescription;

  /// No description provided for @gratitudeWeeklyGoal.
  ///
  /// In en, this message translates to:
  /// **'Play {amount}x Weekly'**
  String gratitudeWeeklyGoal(Object amount);

  /// No description provided for @gratitudeGoalDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{amount} days left'**
  String gratitudeGoalDaysLeft(Object amount);

  /// No description provided for @familyNavigationBarHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get familyNavigationBarHome;

  /// No description provided for @familyNavigationBarFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get familyNavigationBarFamily;

  /// No description provided for @familyNavigationBarMemories.
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get familyNavigationBarMemories;

  /// No description provided for @familyNavigationBarLeague.
  ///
  /// In en, this message translates to:
  /// **'League'**
  String get familyNavigationBarLeague;

  /// No description provided for @missionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Missions available'**
  String get missionsTitle;

  /// No description provided for @missionsNoMissions.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any missions currently'**
  String get missionsNoMissions;

  /// No description provided for @missionsNoCompletedMissions.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t completed any missions yet'**
  String get missionsNoCompletedMissions;

  /// No description provided for @tutorialMissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Tap to begin mission!'**
  String get tutorialMissionTitle;

  /// No description provided for @tutorialMissionDescription.
  ///
  /// In en, this message translates to:
  /// **'Track your progress and complete your missions here.'**
  String get tutorialMissionDescription;

  /// No description provided for @missionsCardNoMissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'No missions available'**
  String get missionsCardNoMissionsTitle;

  /// No description provided for @missionsCardNoMissionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Your work here is done'**
  String get missionsCardNoMissionsDescription;

  /// No description provided for @missionsCardTitle.
  ///
  /// In en, this message translates to:
  /// **''**
  String get missionsCardTitle;

  /// No description provided for @missionsCardTitleSingular.
  ///
  /// In en, this message translates to:
  /// **'Mission available'**
  String get missionsCardTitleSingular;

  /// No description provided for @missionsCardTitlePlural.
  ///
  /// In en, this message translates to:
  /// **'Missions available'**
  String get missionsCardTitlePlural;

  /// No description provided for @missionsCardDescriptionSingular.
  ///
  /// In en, this message translates to:
  /// **'1 mission available to be completed'**
  String get missionsCardDescriptionSingular;

  /// No description provided for @missionsCardDescriptionPlural.
  ///
  /// In en, this message translates to:
  /// **'{amount} missions available to be completed'**
  String missionsCardDescriptionPlural(Object amount);

  /// No description provided for @progressbarPlayed.
  ///
  /// In en, this message translates to:
  /// **'played'**
  String get progressbarPlayed;

  /// No description provided for @gameStatsActivityThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Game activity this week'**
  String get gameStatsActivityThisWeek;

  /// No description provided for @gameStatsPlayGame.
  ///
  /// In en, this message translates to:
  /// **'Play the Gratitude Game'**
  String get gameStatsPlayGame;

  /// No description provided for @gameStatsAmountOfDeeds.
  ///
  /// In en, this message translates to:
  /// **'{amount} deeds'**
  String gameStatsAmountOfDeeds(Object amount);

  /// No description provided for @homescreenOverlayDiscoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover your reward!'**
  String get homescreenOverlayDiscoverTitle;

  /// No description provided for @homescreenOverlayGiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Who would like to give?'**
  String get homescreenOverlayGiveTitle;

  /// No description provided for @tutorialFamilyExplanationTitle.
  ///
  /// In en, this message translates to:
  /// **'Here’s your super family!'**
  String get tutorialFamilyExplanationTitle;

  /// No description provided for @tutorialFamilyExplanationDescription.
  ///
  /// In en, this message translates to:
  /// **'Work together to find causes to support and spread kindness.'**
  String get tutorialFamilyExplanationDescription;

  /// No description provided for @tutorialManagingFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Managing your family'**
  String get tutorialManagingFamilyTitle;

  /// No description provided for @tutorialManagingFamilyDescription.
  ///
  /// In en, this message translates to:
  /// **'Encourage your heroes by topping up wallets and approving donations.'**
  String get tutorialManagingFamilyDescription;

  /// No description provided for @tutorialTheEndTitle.
  ///
  /// In en, this message translates to:
  /// **'Amazing work, superhero!'**
  String get tutorialTheEndTitle;

  /// No description provided for @tutorialTheEndDescription.
  ///
  /// In en, this message translates to:
  /// **'I’ll let you take it from here. Head to your next mission and keep making a difference!'**
  String get tutorialTheEndDescription;

  /// No description provided for @completedKey.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedKey;

  /// No description provided for @tutorialIntroductionTitle.
  ///
  /// In en, this message translates to:
  /// **'Hey, I’m Captain Generosity'**
  String get tutorialIntroductionTitle;

  /// No description provided for @tutorialIntroductionDescription.
  ///
  /// In en, this message translates to:
  /// **'I’m here to help your family build gratitude and foster generosity. Let’s get started!\''**
  String get tutorialIntroductionDescription;

  /// No description provided for @refundTitle.
  ///
  /// In en, this message translates to:
  /// **'Refund donation?'**
  String get refundTitle;

  /// No description provided for @refundMessageBACS.
  ///
  /// In en, this message translates to:
  /// **'Please contact us at support@givt.co.uk so we can refund your donation.'**
  String get refundMessageBACS;

  /// No description provided for @refundMessageGeneral.
  ///
  /// In en, this message translates to:
  /// **'Go to your online banking environment to refund your donation.'**
  String get refundMessageGeneral;

  /// No description provided for @requestRefund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get requestRefund;

  /// No description provided for @changeName.
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get changeName;

  /// No description provided for @onlineGivingLabel.
  ///
  /// In en, this message translates to:
  /// **'Online giving'**
  String get onlineGivingLabel;

  /// No description provided for @accountDisabled.
  ///
  /// In en, this message translates to:
  /// **'Your account has been blocked. Please contact us at support@givtapp.net'**
  String get accountDisabled;

  /// No description provided for @recurringDonationsFrequenciesWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get recurringDonationsFrequenciesWeekly;

  /// No description provided for @recurringDonationsFrequenciesMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get recurringDonationsFrequenciesMonthly;

  /// No description provided for @recurringDonationsFrequenciesQuarterly.
  ///
  /// In en, this message translates to:
  /// **'Quarterly'**
  String get recurringDonationsFrequenciesQuarterly;

  /// No description provided for @recurringDonationsFrequenciesHalfYearly.
  ///
  /// In en, this message translates to:
  /// **'Half Yearly'**
  String get recurringDonationsFrequenciesHalfYearly;

  /// No description provided for @recurringDonationsFrequenciesYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get recurringDonationsFrequenciesYearly;

  /// No description provided for @closeModalAreYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get closeModalAreYouSure;

  /// No description provided for @closeModalWontBeSaved.
  ///
  /// In en, this message translates to:
  /// **'If you exit now, your current changes won\'t be saved.'**
  String get closeModalWontBeSaved;

  /// No description provided for @closeModalYesExit.
  ///
  /// In en, this message translates to:
  /// **'Yes, exit'**
  String get closeModalYesExit;

  /// No description provided for @closeModalNoBack.
  ///
  /// In en, this message translates to:
  /// **'No, go back'**
  String get closeModalNoBack;

  /// No description provided for @recurringDonationsStep2Description.
  ///
  /// In en, this message translates to:
  /// **'How often do you want to give, and how much?'**
  String get recurringDonationsStep2Description;

  /// No description provided for @recurringDonationsFrequencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Donation frequency'**
  String get recurringDonationsFrequencyTitle;

  /// No description provided for @recurringDonationsAmountTitle.
  ///
  /// In en, this message translates to:
  /// **'Donation amount'**
  String get recurringDonationsAmountTitle;

  /// No description provided for @donationSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get donationSubtotal;

  /// No description provided for @donationTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get donationTotal;

  /// No description provided for @platformFeeTitle.
  ///
  /// In en, this message translates to:
  /// **'Platform contribution (optional)'**
  String get platformFeeTitle;

  /// No description provided for @platformFeeText.
  ///
  /// In en, this message translates to:
  /// **'With your platform contribution there are no platform costs for the receiver.'**
  String get platformFeeText;

  /// No description provided for @platformFeeNoContribution.
  ///
  /// In en, this message translates to:
  /// **'No contribution'**
  String get platformFeeNoContribution;

  /// No description provided for @donationOverviewPlatformContribution.
  ///
  /// In en, this message translates to:
  /// **'Voluntary Platform Contribution'**
  String get donationOverviewPlatformContribution;

  /// No description provided for @donationOverviewPlatformContributionTitle.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your generosity!'**
  String get donationOverviewPlatformContributionTitle;

  /// No description provided for @donationOverviewPlatformContributionText.
  ///
  /// In en, this message translates to:
  /// **'Because of the voluntary platform contribution you\'ve chosen, we can lower the costs of receiving donations.'**
  String get donationOverviewPlatformContributionText;

  /// No description provided for @platformFeePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select contribution'**
  String get platformFeePlaceholder;

  /// No description provided for @platformFeeRequired.
  ///
  /// In en, this message translates to:
  /// **'Field required'**
  String get platformFeeRequired;

  /// No description provided for @recurringDonationsStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Select organisation'**
  String get recurringDonationsStep1Title;

  /// No description provided for @recurringDonationsStep1Description.
  ///
  /// In en, this message translates to:
  /// **'Who do you want to give to?'**
  String get recurringDonationsStep1Description;

  /// No description provided for @recurringDonationsStep1ListTitle.
  ///
  /// In en, this message translates to:
  /// **'Select from list'**
  String get recurringDonationsStep1ListTitle;

  /// No description provided for @recurringDonationsStep1ListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select a cause from the list'**
  String get recurringDonationsStep1ListSubtitle;

  /// No description provided for @recurringDonationsStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Set amount'**
  String get recurringDonationsStep2Title;

  /// No description provided for @recurringDonationsStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Set duration'**
  String get recurringDonationsStep3Title;

  /// No description provided for @recurringDonationsStep3Description.
  ///
  /// In en, this message translates to:
  /// **'How long would you like to schedule this donation for?'**
  String get recurringDonationsStep3Description;

  /// No description provided for @recurringDonationsStartingTitle.
  ///
  /// In en, this message translates to:
  /// **'Starting on'**
  String get recurringDonationsStartingTitle;

  /// No description provided for @recurringDonationsEndsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get recurringDonationsEndsTitle;

  /// No description provided for @recurringDonationsEndsWhenIDecide.
  ///
  /// In en, this message translates to:
  /// **'When I decide'**
  String get recurringDonationsEndsWhenIDecide;

  /// No description provided for @recurringDonationsEndsAfterNumber.
  ///
  /// In en, this message translates to:
  /// **'After a number of donations'**
  String get recurringDonationsEndsAfterNumber;

  /// No description provided for @recurringDonationsEndsAfterDate.
  ///
  /// In en, this message translates to:
  /// **'On a specific date'**
  String get recurringDonationsEndsAfterDate;

  /// No description provided for @recurringDonationsEndDateHintEveryMonth.
  ///
  /// In en, this message translates to:
  /// **'Your donation will occur on the {day} of every month'**
  String recurringDonationsEndDateHintEveryMonth(Object dag, Object day);

  /// No description provided for @recurringDonationsEndDateHintEveryWeek.
  ///
  /// In en, this message translates to:
  /// **'Your donation will occur every week on the {day}'**
  String recurringDonationsEndDateHintEveryWeek(Object day);

  /// No description provided for @recurringDonationsEndDateHintEveryXMonth.
  ///
  /// In en, this message translates to:
  /// **'Your donation will occur every {freq} months on the {day}'**
  String recurringDonationsEndDateHintEveryXMonth(Object day, Object freq);

  /// No description provided for @recurringDonationsEndDateHintEveryYear.
  ///
  /// In en, this message translates to:
  /// **'Your donation will occur once a year on the {day} of {month}'**
  String recurringDonationsEndDateHintEveryYear(Object day, Object month);

  /// No description provided for @recurringDonationsEndsAfterXDonations.
  ///
  /// In en, this message translates to:
  /// **'After {amount} of donations'**
  String recurringDonationsEndsAfterXDonations(Object amount);

  /// No description provided for @recurringDonationsStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get recurringDonationsStep4Title;

  /// No description provided for @recurringDonationsStep4Description.
  ///
  /// In en, this message translates to:
  /// **'Ready to make a difference?'**
  String get recurringDonationsStep4Description;

  /// No description provided for @recurringDonationsStep4YoullDonateTo.
  ///
  /// In en, this message translates to:
  /// **'You\'ll donate to'**
  String get recurringDonationsStep4YoullDonateTo;

  /// No description provided for @recurringDonationsStep4Amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get recurringDonationsStep4Amount;

  /// No description provided for @recurringDonationsStep4Frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get recurringDonationsStep4Frequency;

  /// No description provided for @recurringDonationsStep4Starts.
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get recurringDonationsStep4Starts;

  /// No description provided for @recurringDonationsStep4Ends.
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get recurringDonationsStep4Ends;

  /// No description provided for @recurringDonationsStep4ConfirmMyDonation.
  ///
  /// In en, this message translates to:
  /// **'Confirm my donation'**
  String get recurringDonationsStep4ConfirmMyDonation;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'nl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'US':
            return AppLocalizationsEnUs();
        }
        break;
      }
    case 'es':
      {
        switch (locale.countryCode) {
          case '419':
            return AppLocalizationsEs419();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'nl':
      return AppLocalizationsNl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
