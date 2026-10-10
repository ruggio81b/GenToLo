// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GenToLo - Random Number Generator';

  @override
  String get close => 'Close';

  @override
  String get randomMethod => 'Random';

  @override
  String get exclusionMethod => 'Exclusion';

  @override
  String get combinationMethod => 'Combination';

  @override
  String get sort => 'Sort';

  @override
  String get sortAscending => '1 ➔ 90';

  @override
  String get sortAscendingSemantics => 'Numbers in ascending order';

  @override
  String get sortDrawOrderSemantics => 'Numbers in extraction order';

  @override
  String get info => 'Info';

  @override
  String get shareError => 'Couldn\'t share the combination';

  @override
  String get infoTitle => 'Information';

  @override
  String get methodsSectionTitle => 'THE 3 DRAWING METHODS';

  @override
  String get casualeDesc =>
      'Direct random draw of numbers from the board, with no repeats.';

  @override
  String get esclusioneDesc =>
      'Numbers are randomly discarded from the board, one at a time, until only the chosen quantity of \"survivors\" remains.';

  @override
  String get combinazioneDesc =>
      'Randomly shuffles all the numbers on the board, then takes as many positions as the quantity you chose.';

  @override
  String get disclaimerText =>
      'GenToLo (Number Generator for Tombola and Lotteries) is an independent random generator and numerical simulator developed for recreational purposes. The app does not handle bets, does not guarantee any winnings, and is not affiliated with any games or prize contests.';

  @override
  String get openSourceLicenses => 'Open Source Licenses';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyOfflineTitle => '100% Offline & Privacy by Design';

  @override
  String get privacyPolicyOfflineDesc =>
      'The app works entirely on your device and does not request Internet access permission. No information ever leaves your device.';

  @override
  String get privacyPolicyNoDataTitle => 'No Personal Data Collected';

  @override
  String get privacyPolicyNoDataDesc =>
      'No personal data, device identifiers or usage statistics are collected. Drawn numbers exist only in temporary memory; only your selected game preferences are stored on the device.';

  @override
  String get privacyPolicySharingTitle => 'Number Sharing';

  @override
  String get privacyPolicySharingDesc =>
      'The optional sharing feature uses only the native system share sheet. No data passes through the developer\'s servers.';

  @override
  String get privacyPolicyNoAdsTitle => 'Zero Ads & Zero Tracking';

  @override
  String get privacyPolicyNoAdsDesc =>
      'GenToLo includes no advertising SDKs, analytics frameworks (such as Firebase or Google Analytics) or telemetry tools.';

  @override
  String get privacyPolicyOwner =>
      'Data Controller: Fabrizio Ruggiano (ruggio81b@gmail.com)';

  @override
  String get closeDialog => 'Close';

  @override
  String get extractionSettingsTitle => 'Draw Settings';

  @override
  String get numbersToExtractLabel => 'Numbers to draw:';

  @override
  String get extractRangeLabel => 'Draw numbers from 1 to:';

  @override
  String hiddenNumbersNotice(int start) {
    return 'Numbers from $start to 90 will stay hidden on the board.';
  }

  @override
  String get tombolaModeTitle => 'Tombola Mode';

  @override
  String get tombolaInfoTooltip => 'How does Tombola mode work?';

  @override
  String get tombolaExplanation =>
      'In Tombola mode, draws are progressive and numbers are never put back:\n\n• Drawn numbers don\'t return to the board and stay marked.\n• At the next draw, the numbers in the circles drop onto the board, settling and dimming in their cell to make room for the newly drawn ones.\n• The session continues until all numbers on the board are drawn.';

  @override
  String get understood => 'Got it';

  @override
  String get resetOngoingTombola => 'Reset Tombola game in progress';

  @override
  String get cancel => 'Cancel';

  @override
  String get apply => 'Apply';

  @override
  String openSettingsSemantics(int count, int max) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Open draw settings: $count numbers from 1 to $max',
      one: 'Open draw settings: 1 number from 1 to $max',
    );
    return '$_temp0';
  }

  @override
  String get tombolaCompletedBadge => 'TOMBOLA COMPLETED';

  @override
  String tombolaRemainingBadge(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'TOMBOLA ($count LEFT)',
      one: 'TOMBOLA (1 LEFT)',
    );
    return '$_temp0';
  }

  @override
  String standardDrawnBadge(int count, int max) {
    return '$count DRAWN • 1-$max';
  }

  @override
  String get shareCombinationTooltip => 'Share drawn combination';

  @override
  String get tombolaCompletedBanner => 'Tombola completed!';

  @override
  String tombolaRemainingBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tombola: $count numbers on the board',
      one: 'Tombola: 1 number on the board',
    );
    return '$_temp0';
  }

  @override
  String get newGame => 'New Game';

  @override
  String versionLabel(String appName, String version) {
    return '$appName Version $version';
  }

  @override
  String get appSubtitle => 'Number Generator for Tombola and Lotteries';

  @override
  String createdBy(String author) {
    return 'Created by $author';
  }

  @override
  String get boardSemanticsLabel => 'Number board';

  @override
  String get noNumbersDrawnYet => 'No numbers drawn yet';

  @override
  String drawnNumbersSemantics(String numbers) {
    return 'Drawn numbers: $numbers';
  }

  @override
  String get languageLabel => 'Language:';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageItalian => 'Italian';

  @override
  String get languageEnglish => 'English';
}
