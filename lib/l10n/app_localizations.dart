import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'UGCWorks'**
  String get appTitle;

  /// No description provided for @collaborations.
  ///
  /// In en, this message translates to:
  /// **'Collaborations'**
  String get collaborations;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @earningsMenu.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get earningsMenu;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @myCollaborations.
  ///
  /// In en, this message translates to:
  /// **'My Collaborations'**
  String get myCollaborations;

  /// No description provided for @createCollaboration.
  ///
  /// In en, this message translates to:
  /// **'Create Collaboration'**
  String get createCollaboration;

  /// No description provided for @noCollaborationsFound.
  ///
  /// In en, this message translates to:
  /// **'No collaborations found'**
  String get noCollaborationsFound;

  /// No description provided for @noCollaborationsYet.
  ///
  /// In en, this message translates to:
  /// **'There are no collaborations yet.\nCreate your first collaboration.'**
  String get noCollaborationsYet;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @filterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by status'**
  String get filterByStatus;

  /// No description provided for @allTimeframes.
  ///
  /// In en, this message translates to:
  /// **'All timeframes'**
  String get allTimeframes;

  /// No description provided for @earningsOverview.
  ///
  /// In en, this message translates to:
  /// **'Earnings Overview'**
  String get earningsOverview;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @exportFormat.
  ///
  /// In en, this message translates to:
  /// **'Choose export format'**
  String get exportFormat;

  /// No description provided for @csv.
  ///
  /// In en, this message translates to:
  /// **'CSV'**
  String get csv;

  /// No description provided for @pdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @sum.
  ///
  /// In en, this message translates to:
  /// **'Sum'**
  String get sum;

  /// No description provided for @count.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get count;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @feedbackTo.
  ///
  /// In en, this message translates to:
  /// **'Feedback to'**
  String get feedbackTo;

  /// No description provided for @sendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get sendEmail;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @deadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadline;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @scriptAndNotes.
  ///
  /// In en, this message translates to:
  /// **'Script & Notes'**
  String get scriptAndNotes;

  /// No description provided for @partner.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get partner;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @script.
  ///
  /// In en, this message translates to:
  /// **'Script'**
  String get script;

  /// No description provided for @noNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes.'**
  String get noNotes;

  /// No description provided for @noScript.
  ///
  /// In en, this message translates to:
  /// **'No script available.'**
  String get noScript;

  /// No description provided for @fullscreen.
  ///
  /// In en, this message translates to:
  /// **'Script in fullscreen'**
  String get fullscreen;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteCollaboration.
  ///
  /// In en, this message translates to:
  /// **'Delete Collaboration'**
  String get deleteCollaboration;

  /// No description provided for @deleteCollaborationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete this collaboration?'**
  String get deleteCollaborationConfirm;

  /// No description provided for @collaborationDeleted.
  ///
  /// In en, this message translates to:
  /// **'Collaboration deleted'**
  String get collaborationDeleted;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @industry.
  ///
  /// In en, this message translates to:
  /// **'Industry'**
  String get industry;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @removeFilters.
  ///
  /// In en, this message translates to:
  /// **'Remove filters'**
  String get removeFilters;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @filterByStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter by status'**
  String get filterByStatusTitle;

  /// No description provided for @firstTalks.
  ///
  /// In en, this message translates to:
  /// **'First talks'**
  String get firstTalks;

  /// No description provided for @contractToSign.
  ///
  /// In en, this message translates to:
  /// **'Contract to sign'**
  String get contractToSign;

  /// No description provided for @scriptToProduce.
  ///
  /// In en, this message translates to:
  /// **'Create script'**
  String get scriptToProduce;

  /// No description provided for @inProduction.
  ///
  /// In en, this message translates to:
  /// **'In production'**
  String get inProduction;

  /// No description provided for @contentEditing.
  ///
  /// In en, this message translates to:
  /// **'Content editing'**
  String get contentEditing;

  /// No description provided for @contentFeedback.
  ///
  /// In en, this message translates to:
  /// **'Content feedback'**
  String get contentFeedback;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finished;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @deadlineAndNotification.
  ///
  /// In en, this message translates to:
  /// **'Deadline & Notification'**
  String get deadlineAndNotification;

  /// No description provided for @notify.
  ///
  /// In en, this message translates to:
  /// **'Notify'**
  String get notify;

  /// No description provided for @daysBefore.
  ///
  /// In en, this message translates to:
  /// **'Days before'**
  String get daysBefore;

  /// No description provided for @dayBefore.
  ///
  /// In en, this message translates to:
  /// **'Day before'**
  String get dayBefore;

  /// No description provided for @fee.
  ///
  /// In en, this message translates to:
  /// **'Fee (optional)'**
  String get fee;

  /// No description provided for @feeForTable.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get feeForTable;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title *'**
  String get title;

  /// No description provided for @titleForTable.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleForTable;

  /// No description provided for @enterTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter title'**
  String get enterTitle;

  /// No description provided for @enterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter valid amount'**
  String get enterValidAmount;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @welcomeCreator.
  ///
  /// In en, this message translates to:
  /// **'Welcome, Creator! 👋'**
  String get welcomeCreator;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Tired of managing your collaborations in Excel, note apps and calendars?'**
  String get welcomeMessage;

  /// No description provided for @keepTrack.
  ///
  /// In en, this message translates to:
  /// **'Keep track of all your collaborations in one place 📊'**
  String get keepTrack;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Get automatically notified when deadlines expire ⏰'**
  String get notifications;

  /// No description provided for @startNow.
  ///
  /// In en, this message translates to:
  /// **'Start now and save yourself from chaos and Excel lists 🚀'**
  String get startNow;

  /// No description provided for @letsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go'**
  String get letsGo;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @earningsAsCsv.
  ///
  /// In en, this message translates to:
  /// **'Earnings as CSV'**
  String get earningsAsCsv;

  /// No description provided for @earningsAsPdf.
  ///
  /// In en, this message translates to:
  /// **'Earnings as PDF'**
  String get earningsAsPdf;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Your collaboration'**
  String get notificationTitle;

  /// No description provided for @notificationDue.
  ///
  /// In en, this message translates to:
  /// **'is due on'**
  String get notificationDue;

  /// No description provided for @notificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your deadline is expiring'**
  String get notificationSubtitle;

  /// No description provided for @betaDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Note: In this beta version, your data is only stored locally on your device. Data may be lost when switching apps or reinstalling. In the final version, your data will be securely stored in the cloud.'**
  String get betaDisclaimer;

  /// No description provided for @betaDisclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Beta Version Notice'**
  String get betaDisclaimerTitle;

  /// No description provided for @cloudSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync your data in the cloud ☁️'**
  String get cloudSyncTitle;

  /// No description provided for @cloudSyncMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple to securely store your collaborations in the cloud. Your data will be safe and accessible across all your devices.'**
  String get cloudSyncMessage;

  /// No description provided for @loggedInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Logged in with Apple'**
  String get loggedInWithApple;

  /// No description provided for @refreshTokenExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get refreshTokenExpiredTitle;

  /// No description provided for @refreshTokenExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again to sync your data.'**
  String get refreshTokenExpiredMessage;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeleted;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? All your collaborations will be permanently deleted and cannot be recovered.'**
  String get deleteAccountConfirmation;

  /// No description provided for @deleteAccountError.
  ///
  /// In en, this message translates to:
  /// **'Error deleting account'**
  String get deleteAccountError;

  /// No description provided for @dataNotSecuredTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Not Secured'**
  String get dataNotSecuredTitle;

  /// No description provided for @dataNotSecuredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your data is stored locally and not backed up in the cloud. Sign in with Apple to secure your data.'**
  String get dataNotSecuredMessage;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'App-Infos'**
  String get appInfo;

  /// No description provided for @supportInfo.
  ///
  /// In en, this message translates to:
  /// **'Support-Infos'**
  String get supportInfo;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID:'**
  String get userId;

  /// No description provided for @copyUserId.
  ///
  /// In en, this message translates to:
  /// **'Copy User ID'**
  String get copyUserId;

  /// No description provided for @userIdCopied.
  ///
  /// In en, this message translates to:
  /// **'User ID copied to clipboard'**
  String get userIdCopied;

  /// No description provided for @copyError.
  ///
  /// In en, this message translates to:
  /// **'Error copying User ID'**
  String get copyError;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed.'**
  String get loginFailed;

  /// No description provided for @discardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardChanges;

  /// No description provided for @discardChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'All entered data will be lost. Are you sure you want to leave?'**
  String get discardChangesMessage;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations 🎉'**
  String get congratulations;

  /// No description provided for @firstCollaborationMessage.
  ///
  /// In en, this message translates to:
  /// **'You have created your first collaboration!\n\nSo you don\'t miss any deadlines, you can be automatically reminded.'**
  String get firstCollaborationMessage;

  /// No description provided for @yesRemindMe.
  ///
  /// In en, this message translates to:
  /// **'Yes, remind me'**
  String get yesRemindMe;

  /// No description provided for @noMaybeLater.
  ///
  /// In en, this message translates to:
  /// **'No, maybe later'**
  String get noMaybeLater;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled ✅'**
  String get notificationsEnabled;

  /// No description provided for @notificationsDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications not allowed ❌'**
  String get notificationsDenied;

  /// No description provided for @collaborationCreated.
  ///
  /// In en, this message translates to:
  /// **'Collaboration created successfully! ✅'**
  String get collaborationCreated;

  /// No description provided for @collaborationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Collaboration updated successfully! ✅'**
  String get collaborationUpdated;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @dashboardWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! 👋'**
  String get dashboardWelcome;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Here\'s your collaboration overview'**
  String get dashboardSubtitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @totalEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get totalEarnings;

  /// No description provided for @totalCollaborations.
  ///
  /// In en, this message translates to:
  /// **'Total Collaborations'**
  String get totalCollaborations;

  /// No description provided for @activeCollaborations.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeCollaborations;

  /// No description provided for @completedCollaborations.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedCollaborations;

  /// No description provided for @highestPaidCollab.
  ///
  /// In en, this message translates to:
  /// **'Highest Paid Collaboration'**
  String get highestPaidCollab;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get allTime;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgress;

  /// No description provided for @createFirstCollab.
  ///
  /// In en, this message translates to:
  /// **'Create your first collaboration to see your dashboard'**
  String get createFirstCollab;

  /// No description provided for @timePeriod.
  ///
  /// In en, this message translates to:
  /// **'Time Period'**
  String get timePeriod;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @overall.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get overall;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish Collaboration'**
  String get finish;

  /// No description provided for @finishCollaboration.
  ///
  /// In en, this message translates to:
  /// **'Finish Collaboration'**
  String get finishCollaboration;

  /// No description provided for @finishCollaborationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to mark this collaboration as finished?'**
  String get finishCollaborationConfirm;

  /// No description provided for @collaborationFinished.
  ///
  /// In en, this message translates to:
  /// **'Collaboration marked as finished! ✅'**
  String get collaborationFinished;

  /// No description provided for @collaborationAlreadyFinished.
  ///
  /// In en, this message translates to:
  /// **'Collaboration is already finished!'**
  String get collaborationAlreadyFinished;

  /// No description provided for @searchCollaborationsHint.
  ///
  /// In en, this message translates to:
  /// **'Search collaborations...'**
  String get searchCollaborationsHint;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// No description provided for @enjoyingApp.
  ///
  /// In en, this message translates to:
  /// **'Enjoying UGCWorks?'**
  String get enjoyingApp;

  /// No description provided for @reviewMessage.
  ///
  /// In en, this message translates to:
  /// **'We would love to hear your feedback! Your review helps us improve and reach more creators.'**
  String get reviewMessage;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;
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
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
