// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'GenToLo - Generatore numeri casuali';

  @override
  String get close => 'Chiudi';

  @override
  String get randomMethod => 'Casuale';

  @override
  String get exclusionMethod => 'Esclusione';

  @override
  String get combinationMethod => 'Combinazione';

  @override
  String get sort => 'Ordina';

  @override
  String get sortAscending => '1 ➔ 90';

  @override
  String get sortAscendingSemantics => 'Numeri in ordine crescente';

  @override
  String get sortDrawOrderSemantics => 'Numeri in ordine di estrazione';

  @override
  String get info => 'Info';

  @override
  String get shareError => 'Impossibile condividere la combinazione';

  @override
  String get infoTitle => 'Informazioni';

  @override
  String get methodsSectionTitle => 'I 3 METODI DI ESTRAZIONE';

  @override
  String get casualeDesc =>
      'Estrazione casuale diretta di numeri dal tabellone, senza ripetizioni.';

  @override
  String get esclusioneDesc =>
      'Scarto progressivo di numeri casuali dal tabellone fino a far rimanere solo i numeri \"superstiti\" nella quantità desiderata.';

  @override
  String get combinazioneDesc =>
      'Mescolamento casuale di tutti i numeri del tabellone ed estrazione delle posizioni corrispondenti alla quantità scelta.';

  @override
  String get disclaimerText =>
      'GenToLo (Generatore numeri per Tombola e Lotterie) è un generatore casuale e simulatore numerico indipendente sviluppato per scopi ricreativi. L\'applicazione non gestisce scommesse, non garantisce alcuna vincita e non ha alcun collegamento con giochi o concorsi a premi.';

  @override
  String get openSourceLicenses => 'Licenze Open Source';

  @override
  String get privacyPolicy => 'Informativa sulla Privacy';

  @override
  String get privacyPolicyOfflineTitle => '100% Offline e Privacy by Design';

  @override
  String get privacyPolicyOfflineDesc =>
      'L\'applicazione funziona interamente in locale e non richiede il permesso di accesso a Internet. Nessuna informazione lascia mai il tuo dispositivo.';

  @override
  String get privacyPolicyNoDataTitle => 'Nessun Dato Personale Raccolto';

  @override
  String get privacyPolicyNoDataDesc =>
      'Non vengono raccolti dati personali, identificatori del dispositivo né statistiche. I numeri estratti risiedono solo nella memoria temporanea; sul dispositivo vengono memorizzate unicamente le preferenze di gioco selezionate.';

  @override
  String get privacyPolicySharingTitle => 'Condivisione dei Numeri';

  @override
  String get privacyPolicySharingDesc =>
      'La funzione facoltativa di condivisione impiega unicamente il menu nativo di sistema. Nessun dato transita da server dello sviluppatore.';

  @override
  String get privacyPolicyNoAdsTitle => 'Zero Pubblicità e Tracciamento';

  @override
  String get privacyPolicyNoAdsDesc =>
      'GenToLo non integra SDK pubblicitari, framework di analisi (come Firebase o Google Analytics) né strumenti di telemetria.';

  @override
  String get privacyPolicyOwner =>
      'Titolare del Trattamento: Fabrizio Ruggiano (ruggio81b@gmail.com)';

  @override
  String get closeDialog => 'Chiudi';

  @override
  String get extractionSettingsTitle => 'Impostazioni Estrazione';

  @override
  String get numbersToExtractLabel => 'Numeri da estrarre:';

  @override
  String get extractRangeLabel => 'Estrai numeri da 1 a:';

  @override
  String hiddenNumbersNotice(int start) {
    return 'I numeri da $start a 90 resteranno nascosti sul tabellone.';
  }

  @override
  String get tombolaModeTitle => 'Modalità Tombola';

  @override
  String get tombolaInfoTooltip => 'Come funziona la modalità Tombola?';

  @override
  String get tombolaExplanation =>
      'In modalità Tombola le estrazioni sono progressive e senza reinserimento:\n\n• I numeri estratti non tornano disponibili sul tabellone e restano segnati.\n• Alla successiva estrazione, i numeri nei cerchi scendono sul tabellone posizionandosi e oscurandosi nella loro casella per fare spazio ai nuovi estratti.\n• La sessione prosegue fino all\'esaurimento dei numeri sul tabellone.';

  @override
  String get understood => 'Ho capito';

  @override
  String get resetOngoingTombola => 'Azzera partita Tombola in corso';

  @override
  String get cancel => 'Annulla';

  @override
  String get apply => 'Applica';

  @override
  String openSettingsSemantics(int count, int max) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Apri impostazioni estrazione: $count numeri da 1 a $max',
      one: 'Apri impostazioni estrazione: 1 numero da 1 a $max',
    );
    return '$_temp0';
  }

  @override
  String get tombolaCompletedBadge => 'TOMBOLA COMPLETATA';

  @override
  String tombolaRemainingBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TOMBOLA ($count RIMASTI)',
      one: 'TOMBOLA (1 RIMASTO)',
    );
    return '$_temp0';
  }

  @override
  String standardDrawnBadge(int count, int max) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ESTRATTI • 1-$max',
      one: '1 ESTRATTO • 1-$max',
    );
    return '$_temp0';
  }

  @override
  String get shareCombinationTooltip => 'Condividi combinazione estratta';

  @override
  String get tombolaCompletedBanner => 'Tombola completata!';

  @override
  String tombolaRemainingBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tombola: $count numeri sul tabellone',
      one: 'Tombola: 1 numero sul tabellone',
    );
    return '$_temp0';
  }

  @override
  String get newGame => 'Nuova Partita';

  @override
  String versionLabel(String appName, String version) {
    return '$appName Versione $version';
  }

  @override
  String get appSubtitle => 'Generatore numeri per Tombola e Lotterie';

  @override
  String createdBy(String author) {
    return 'Creato da $author';
  }

  @override
  String get boardSemanticsLabel => 'Tabellone di estrazione';

  @override
  String get noNumbersDrawnYet => 'Nessun numero ancora estratto';

  @override
  String drawnNumbersSemantics(String numbers) {
    return 'Numeri estratti: $numbers';
  }

  @override
  String get languageLabel => 'Lingua:';

  @override
  String get languageSystem => 'Predefinita di sistema';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languageEnglish => 'Inglese';
}
