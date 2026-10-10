import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

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
    Locale('en'),
    Locale('it'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In it, this message translates to:
  /// **'GenToLo - Generatore numeri casuali'**
  String get appTitle;

  /// No description provided for @close.
  ///
  /// In it, this message translates to:
  /// **'Chiudi'**
  String get close;

  /// No description provided for @randomMethod.
  ///
  /// In it, this message translates to:
  /// **'Casuale'**
  String get randomMethod;

  /// No description provided for @exclusionMethod.
  ///
  /// In it, this message translates to:
  /// **'Esclusione'**
  String get exclusionMethod;

  /// No description provided for @combinationMethod.
  ///
  /// In it, this message translates to:
  /// **'Combinazione'**
  String get combinationMethod;

  /// No description provided for @sort.
  ///
  /// In it, this message translates to:
  /// **'Ordina'**
  String get sort;

  /// No description provided for @sortAscending.
  ///
  /// In it, this message translates to:
  /// **'1 ➔ 90'**
  String get sortAscending;

  /// No description provided for @sortAscendingSemantics.
  ///
  /// In it, this message translates to:
  /// **'Numeri in ordine crescente'**
  String get sortAscendingSemantics;

  /// No description provided for @sortDrawOrderSemantics.
  ///
  /// In it, this message translates to:
  /// **'Numeri in ordine di estrazione'**
  String get sortDrawOrderSemantics;

  /// No description provided for @info.
  ///
  /// In it, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @shareError.
  ///
  /// In it, this message translates to:
  /// **'Impossibile condividere la combinazione'**
  String get shareError;

  /// No description provided for @infoTitle.
  ///
  /// In it, this message translates to:
  /// **'Informazioni'**
  String get infoTitle;

  /// No description provided for @methodsSectionTitle.
  ///
  /// In it, this message translates to:
  /// **'I 3 METODI DI ESTRAZIONE'**
  String get methodsSectionTitle;

  /// No description provided for @casualeDesc.
  ///
  /// In it, this message translates to:
  /// **'Estrazione casuale diretta di numeri dal tabellone, senza ripetizioni.'**
  String get casualeDesc;

  /// No description provided for @esclusioneDesc.
  ///
  /// In it, this message translates to:
  /// **'Scarto progressivo di numeri casuali dal tabellone fino a far rimanere solo i numeri \"superstiti\" nella quantità desiderata.'**
  String get esclusioneDesc;

  /// No description provided for @combinazioneDesc.
  ///
  /// In it, this message translates to:
  /// **'Mescolamento casuale di tutti i numeri del tabellone ed estrazione delle posizioni corrispondenti alla quantità scelta.'**
  String get combinazioneDesc;

  /// No description provided for @disclaimerText.
  ///
  /// In it, this message translates to:
  /// **'GenToLo (Generatore numeri per Tombola e Lotterie) è un generatore casuale e simulatore numerico indipendente sviluppato per scopi ricreativi. L\'applicazione non gestisce scommesse, non garantisce alcuna vincita e non ha alcun collegamento con giochi o concorsi a premi.'**
  String get disclaimerText;

  /// No description provided for @openSourceLicenses.
  ///
  /// In it, this message translates to:
  /// **'Licenze Open Source'**
  String get openSourceLicenses;

  /// No description provided for @privacyPolicy.
  ///
  /// In it, this message translates to:
  /// **'Informativa sulla Privacy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyOfflineTitle.
  ///
  /// In it, this message translates to:
  /// **'100% Offline e Privacy by Design'**
  String get privacyPolicyOfflineTitle;

  /// No description provided for @privacyPolicyOfflineDesc.
  ///
  /// In it, this message translates to:
  /// **'L\'applicazione funziona interamente in locale e non richiede il permesso di accesso a Internet. Nessuna informazione lascia mai il tuo dispositivo.'**
  String get privacyPolicyOfflineDesc;

  /// No description provided for @privacyPolicyNoDataTitle.
  ///
  /// In it, this message translates to:
  /// **'Nessun Dato Personale Raccolto'**
  String get privacyPolicyNoDataTitle;

  /// No description provided for @privacyPolicyNoDataDesc.
  ///
  /// In it, this message translates to:
  /// **'Non vengono raccolti dati personali, identificatori del dispositivo né statistiche. I numeri estratti risiedono solo nella memoria temporanea; sul dispositivo vengono memorizzate unicamente le preferenze di gioco selezionate.'**
  String get privacyPolicyNoDataDesc;

  /// No description provided for @privacyPolicySharingTitle.
  ///
  /// In it, this message translates to:
  /// **'Condivisione dei Numeri'**
  String get privacyPolicySharingTitle;

  /// No description provided for @privacyPolicySharingDesc.
  ///
  /// In it, this message translates to:
  /// **'La funzione facoltativa di condivisione impiega unicamente il menu nativo di sistema. Nessun dato transita da server dello sviluppatore.'**
  String get privacyPolicySharingDesc;

  /// No description provided for @privacyPolicyNoAdsTitle.
  ///
  /// In it, this message translates to:
  /// **'Zero Pubblicità e Tracciamento'**
  String get privacyPolicyNoAdsTitle;

  /// No description provided for @privacyPolicyNoAdsDesc.
  ///
  /// In it, this message translates to:
  /// **'GenToLo non integra SDK pubblicitari, framework di analisi (come Firebase o Google Analytics) né strumenti di telemetria.'**
  String get privacyPolicyNoAdsDesc;

  /// No description provided for @privacyPolicyOwner.
  ///
  /// In it, this message translates to:
  /// **'Titolare del Trattamento: Fabrizio Ruggiano (ruggio81b@gmail.com)'**
  String get privacyPolicyOwner;

  /// No description provided for @closeDialog.
  ///
  /// In it, this message translates to:
  /// **'Chiudi'**
  String get closeDialog;

  /// No description provided for @extractionSettingsTitle.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni Estrazione'**
  String get extractionSettingsTitle;

  /// No description provided for @numbersToExtractLabel.
  ///
  /// In it, this message translates to:
  /// **'Numeri da estrarre:'**
  String get numbersToExtractLabel;

  /// No description provided for @extractRangeLabel.
  ///
  /// In it, this message translates to:
  /// **'Estrai numeri da 1 a:'**
  String get extractRangeLabel;

  /// No description provided for @hiddenNumbersNotice.
  ///
  /// In it, this message translates to:
  /// **'I numeri da {start} a 90 resteranno nascosti sul tabellone.'**
  String hiddenNumbersNotice(int start);

  /// No description provided for @tombolaModeTitle.
  ///
  /// In it, this message translates to:
  /// **'Modalità Tombola'**
  String get tombolaModeTitle;

  /// No description provided for @tombolaInfoTooltip.
  ///
  /// In it, this message translates to:
  /// **'Come funziona la modalità Tombola?'**
  String get tombolaInfoTooltip;

  /// No description provided for @tombolaExplanation.
  ///
  /// In it, this message translates to:
  /// **'In modalità Tombola le estrazioni sono progressive e senza reinserimento:\n\n• I numeri estratti non tornano disponibili sul tabellone e restano segnati.\n• Alla successiva estrazione, i numeri nei cerchi scendono sul tabellone posizionandosi e oscurandosi nella loro casella per fare spazio ai nuovi estratti.\n• La sessione prosegue fino all\'esaurimento dei numeri sul tabellone.'**
  String get tombolaExplanation;

  /// No description provided for @understood.
  ///
  /// In it, this message translates to:
  /// **'Ho capito'**
  String get understood;

  /// No description provided for @resetOngoingTombola.
  ///
  /// In it, this message translates to:
  /// **'Azzera partita Tombola in corso'**
  String get resetOngoingTombola;

  /// No description provided for @cancel.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get cancel;

  /// No description provided for @apply.
  ///
  /// In it, this message translates to:
  /// **'Applica'**
  String get apply;

  /// No description provided for @openSettingsSemantics.
  ///
  /// In it, this message translates to:
  /// **'{count, plural, =1{Apri impostazioni estrazione: 1 numero da 1 a {max}} other{Apri impostazioni estrazione: {count} numeri da 1 a {max}}}'**
  String openSettingsSemantics(int count, int max);

  /// No description provided for @tombolaCompletedBadge.
  ///
  /// In it, this message translates to:
  /// **'TOMBOLA COMPLETATA'**
  String get tombolaCompletedBadge;

  /// No description provided for @tombolaRemainingBadge.
  ///
  /// In it, this message translates to:
  /// **'{count, plural, =1{TOMBOLA (1 RIMASTO)} other{TOMBOLA ({count} RIMASTI)}}'**
  String tombolaRemainingBadge(int count);

  /// No description provided for @standardDrawnBadge.
  ///
  /// In it, this message translates to:
  /// **'{count, plural, =1{1 ESTRATTO • 1-{max}} other{{count} ESTRATTI • 1-{max}}}'**
  String standardDrawnBadge(int count, int max);

  /// No description provided for @shareCombinationTooltip.
  ///
  /// In it, this message translates to:
  /// **'Condividi combinazione estratta'**
  String get shareCombinationTooltip;

  /// No description provided for @tombolaCompletedBanner.
  ///
  /// In it, this message translates to:
  /// **'Tombola completata!'**
  String get tombolaCompletedBanner;

  /// No description provided for @tombolaRemainingBanner.
  ///
  /// In it, this message translates to:
  /// **'{count, plural, =1{Tombola: 1 numero sul tabellone} other{Tombola: {count} numeri sul tabellone}}'**
  String tombolaRemainingBanner(int count);

  /// No description provided for @newGame.
  ///
  /// In it, this message translates to:
  /// **'Nuova Partita'**
  String get newGame;

  /// No description provided for @versionLabel.
  ///
  /// In it, this message translates to:
  /// **'{appName} Versione {version}'**
  String versionLabel(String appName, String version);

  /// No description provided for @appSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Generatore numeri per Tombola e Lotterie'**
  String get appSubtitle;

  /// No description provided for @createdBy.
  ///
  /// In it, this message translates to:
  /// **'Creato da {author}'**
  String createdBy(String author);

  /// No description provided for @boardSemanticsLabel.
  ///
  /// In it, this message translates to:
  /// **'Tabellone di estrazione'**
  String get boardSemanticsLabel;

  /// No description provided for @noNumbersDrawnYet.
  ///
  /// In it, this message translates to:
  /// **'Nessun numero ancora estratto'**
  String get noNumbersDrawnYet;

  /// No description provided for @drawnNumbersSemantics.
  ///
  /// In it, this message translates to:
  /// **'Numeri estratti: {numbers}'**
  String drawnNumbersSemantics(String numbers);

  /// No description provided for @languageLabel.
  ///
  /// In it, this message translates to:
  /// **'Lingua:'**
  String get languageLabel;

  /// No description provided for @languageSystem.
  ///
  /// In it, this message translates to:
  /// **'Predefinita di sistema'**
  String get languageSystem;

  /// No description provided for @languageItalian.
  ///
  /// In it, this message translates to:
  /// **'Italiano'**
  String get languageItalian;

  /// No description provided for @languageEnglish.
  ///
  /// In it, this message translates to:
  /// **'Inglese'**
  String get languageEnglish;
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
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
