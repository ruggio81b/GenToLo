import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gentolo/l10n/app_localizations.dart';
import 'package:gentolo/models/extraction_settings.dart';
import 'package:gentolo/screens/lottery_screen.dart';
import 'package:gentolo/services/settings_service.dart';
import 'package:gentolo/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Blocco dell'orientamento in verticale per smartphone e tablet
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Personalizzazione barra di sistema Android/iOS
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.defaultTheme.backgroundBottom,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  const settingsService = SettingsService();
  final initialSettings = await settingsService.loadSettings();

  runApp(GenToLoApp(
    initialSettings: initialSettings,
    settingsService: settingsService,
  ));
}

class GenToLoApp extends StatelessWidget {
  static const String appName = 'GenToLo';
  static const String appTitle = 'GenToLo - Generatore numeri casuali';
  static const String appVersion = '1.0.0';
  static const String appAuthor = 'Fabrizio Ruggiano';
  static const String appLegalese = '© 2026 Fabrizio Ruggiano — GNU General Public License v3.0';

  /// Lingua attiva dell'applicazione (rilasciata in lingua Italiana).
  final Locale? locale;
  final ExtractionSettings? initialSettings;
  final SettingsService? settingsService;

  const GenToLoApp({
    super.key,
    this.locale = const Locale('it'),
    this.initialSettings,
    this.settingsService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: mediaQuery.textScaler.clamp(
              minScaleFactor: 0.85,
              maxScaleFactor: 1.25,
            ),
          ),
          child: child!,
        );
      },
      home: LotteryScreen(
        initialSettings: initialSettings,
        settingsService: settingsService,
      ),
    );
  }
}
