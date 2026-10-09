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
}
