import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Pip\'s Word Vault'**
  String get appTitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Pip\'s Word Vault!'**
  String get welcomeTitle;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep track of all your favorite new words in one cozy place.'**
  String get welcomeDescription;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'START'**
  String get start;

  /// No description provided for @recentlyCarved.
  ///
  /// In en, this message translates to:
  /// **'Recently Carved'**
  String get recentlyCarved;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @giftAWord.
  ///
  /// In en, this message translates to:
  /// **'Gift a Word'**
  String get giftAWord;

  /// No description provided for @wordVault.
  ///
  /// In en, this message translates to:
  /// **'Word Vault'**
  String get wordVault;

  /// No description provided for @noWordsYet.
  ///
  /// In en, this message translates to:
  /// **'No words yet...'**
  String get noWordsYet;

  /// No description provided for @giftOneToPip.
  ///
  /// In en, this message translates to:
  /// **'Gift one to Pip!'**
  String get giftOneToPip;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @filterByType.
  ///
  /// In en, this message translates to:
  /// **'Filter by type'**
  String get filterByType;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @noWordsFound.
  ///
  /// In en, this message translates to:
  /// **'No words found.'**
  String get noWordsFound;

  /// No description provided for @newWord.
  ///
  /// In en, this message translates to:
  /// **'New Word'**
  String get newWord;

  /// No description provided for @addWord.
  ///
  /// In en, this message translates to:
  /// **'Add Word'**
  String get addWord;

  /// No description provided for @wordOrPhrase.
  ///
  /// In en, this message translates to:
  /// **'Word or Phrase'**
  String get wordOrPhrase;

  /// No description provided for @whatDoesItMean.
  ///
  /// In en, this message translates to:
  /// **'What does it mean?'**
  String get whatDoesItMean;

  /// No description provided for @howDoYouUseIt.
  ///
  /// In en, this message translates to:
  /// **'How do you use it?'**
  String get howDoYouUseIt;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'(Optional)'**
  String get optional;

  /// No description provided for @types.
  ///
  /// In en, this message translates to:
  /// **'Types'**
  String get types;

  /// No description provided for @noun.
  ///
  /// In en, this message translates to:
  /// **'Noun'**
  String get noun;

  /// No description provided for @verb.
  ///
  /// In en, this message translates to:
  /// **'Verb'**
  String get verb;

  /// No description provided for @adjective.
  ///
  /// In en, this message translates to:
  /// **'Adjective'**
  String get adjective;

  /// No description provided for @adverb.
  ///
  /// In en, this message translates to:
  /// **'Adverb'**
  String get adverb;

  /// No description provided for @idiom.
  ///
  /// In en, this message translates to:
  /// **'Idiom'**
  String get idiom;

  /// No description provided for @slang.
  ///
  /// In en, this message translates to:
  /// **'Slang'**
  String get slang;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @carveItInStone.
  ///
  /// In en, this message translates to:
  /// **'Carve it in stone'**
  String get carveItInStone;

  /// No description provided for @pleaseEnterAWord.
  ///
  /// In en, this message translates to:
  /// **'Please enter a word'**
  String get pleaseEnterAWord;

  /// No description provided for @pleaseEnterAMeaning.
  ///
  /// In en, this message translates to:
  /// **'Please enter a meaning'**
  String get pleaseEnterAMeaning;

  /// No description provided for @pleaseSelectAtLeastOneType.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one type'**
  String get pleaseSelectAtLeastOneType;

  /// No description provided for @youHaveGiftedPip.
  ///
  /// In en, this message translates to:
  /// **'You\'ve gifted Pip '**
  String get youHaveGiftedPip;

  /// No description provided for @wordsSoFarReady.
  ///
  /// In en, this message translates to:
  /// **' words so far! Ready to add more?'**
  String get wordsSoFarReady;

  /// No description provided for @giftPipNewWord.
  ///
  /// In en, this message translates to:
  /// **'Gift Pip a New Word'**
  String get giftPipNewWord;

  /// No description provided for @englishWord.
  ///
  /// In en, this message translates to:
  /// **'English Word'**
  String get englishWord;

  /// No description provided for @egEthereal.
  ///
  /// In en, this message translates to:
  /// **'e.g., Ethereal'**
  String get egEthereal;

  /// No description provided for @arabicTranslation.
  ///
  /// In en, this message translates to:
  /// **'Arabic Translation'**
  String get arabicTranslation;

  /// No description provided for @egArabic.
  ///
  /// In en, this message translates to:
  /// **'e.g., أثيري'**
  String get egArabic;

  /// No description provided for @wordTypes.
  ///
  /// In en, this message translates to:
  /// **'Word Types'**
  String get wordTypes;

  /// No description provided for @addSentence.
  ///
  /// In en, this message translates to:
  /// **'Add Sentence'**
  String get addSentence;

  /// No description provided for @sentences.
  ///
  /// In en, this message translates to:
  /// **'Sentences'**
  String get sentences;

  /// No description provided for @carved.
  ///
  /// In en, this message translates to:
  /// **'Carved!'**
  String get carved;

  /// No description provided for @pipLovesNewWord.
  ///
  /// In en, this message translates to:
  /// **'Pip loves the new word!'**
  String get pipLovesNewWord;

  /// No description provided for @englishSentence.
  ///
  /// In en, this message translates to:
  /// **'English sentence...'**
  String get englishSentence;

  /// No description provided for @arabicTranslationSentence.
  ///
  /// In en, this message translates to:
  /// **'Arabic translation...'**
  String get arabicTranslationSentence;

  /// No description provided for @exampleSentences.
  ///
  /// In en, this message translates to:
  /// **'Example Sentences'**
  String get exampleSentences;

  /// No description provided for @example.
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get example;

  /// No description provided for @wordRoleInSentence.
  ///
  /// In en, this message translates to:
  /// **'Word Role In Sentence:'**
  String get wordRoleInSentence;

  /// No description provided for @editWord.
  ///
  /// In en, this message translates to:
  /// **'Edit Word'**
  String get editWord;

  /// No description provided for @updateWord.
  ///
  /// In en, this message translates to:
  /// **'Update Word'**
  String get updateWord;

  /// No description provided for @folder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get folder;

  /// No description provided for @folders.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get folders;

  /// No description provided for @selectFolder.
  ///
  /// In en, this message translates to:
  /// **'Select Folder'**
  String get selectFolder;

  /// No description provided for @createNewFolder.
  ///
  /// In en, this message translates to:
  /// **'Create New Folder'**
  String get createNewFolder;

  /// No description provided for @unsorted.
  ///
  /// In en, this message translates to:
  /// **'Unsorted'**
  String get unsorted;

  /// No description provided for @backToFolders.
  ///
  /// In en, this message translates to:
  /// **'Back to Folders'**
  String get backToFolders;

  /// No description provided for @carveIntoVault.
  ///
  /// In en, this message translates to:
  /// **'Carve into Vault'**
  String get carveIntoVault;

  /// No description provided for @navVault.
  ///
  /// In en, this message translates to:
  /// **'Vault'**
  String get navVault;

  /// No description provided for @navAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get navAdd;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @errorEnterWords.
  ///
  /// In en, this message translates to:
  /// **'Please enter both English and Arabic words'**
  String get errorEnterWords;

  /// No description provided for @errorSelectWordType.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one Word Type'**
  String get errorSelectWordType;

  /// No description provided for @pronoun.
  ///
  /// In en, this message translates to:
  /// **'Pronoun'**
  String get pronoun;

  /// No description provided for @preposition.
  ///
  /// In en, this message translates to:
  /// **'Prep'**
  String get preposition;

  /// No description provided for @conjunction.
  ///
  /// In en, this message translates to:
  /// **'Conj'**
  String get conjunction;

  /// No description provided for @interjection.
  ///
  /// In en, this message translates to:
  /// **'Interj'**
  String get interjection;

  /// No description provided for @searchNoWordsFound.
  ///
  /// In en, this message translates to:
  /// **'No words found!'**
  String get searchNoWordsFound;

  /// No description provided for @searchVaultEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your vault is empty!'**
  String get searchVaultEmpty;

  /// No description provided for @tryDifferentSearchTerm.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term.'**
  String get tryDifferentSearchTerm;

  /// No description provided for @goToAddTab.
  ///
  /// In en, this message translates to:
  /// **'Go to the Add tab to carve a new word.'**
  String get goToAddTab;

  /// No description provided for @foundPrefix.
  ///
  /// In en, this message translates to:
  /// **'FOUND '**
  String get foundPrefix;

  /// No description provided for @resultsSuffix.
  ///
  /// In en, this message translates to:
  /// **' RESULTS'**
  String get resultsSuffix;

  /// No description provided for @allWordsPrefix.
  ///
  /// In en, this message translates to:
  /// **'ALL WORDS '**
  String get allWordsPrefix;

  /// No description provided for @deleteFolder.
  ///
  /// In en, this message translates to:
  /// **'Delete Folder'**
  String get deleteFolder;

  /// No description provided for @deleteFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Folder Options'**
  String get deleteFolderTitle;

  /// No description provided for @deleteFolderKeepWords.
  ///
  /// In en, this message translates to:
  /// **'Keep Words'**
  String get deleteFolderKeepWords;

  /// No description provided for @deleteFolderDeleteWords.
  ///
  /// In en, this message translates to:
  /// **'Delete Words'**
  String get deleteFolderDeleteWords;

  /// No description provided for @deleteFolderMoveWords.
  ///
  /// In en, this message translates to:
  /// **'Move Words'**
  String get deleteFolderMoveWords;

  /// No description provided for @moveWordsTo.
  ///
  /// In en, this message translates to:
  /// **'Move to...'**
  String get moveWordsTo;

  /// No description provided for @deleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected'**
  String get deleteSelected;

  /// No description provided for @moveSelected.
  ///
  /// In en, this message translates to:
  /// **'Move Selected'**
  String get moveSelected;

  /// No description provided for @selectionMode.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selectionMode;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
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
