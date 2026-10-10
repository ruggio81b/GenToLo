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
  final savedLanguage = await settingsService.loadLanguageCode();
  final initialLocale = savedLanguage != null ? Locale(savedLanguage) : null;

  runApp(GenToLoApp(
    initialLocale: initialLocale,
    initialSettings: initialSettings,
    settingsService: settingsService,
  ));
}

/// Scope che consente ai widget discendenti di leggere e modificare dinamicamente il [Locale] attivo.
class LocaleScope extends InheritedWidget {
  final Locale? locale;
  final ValueChanged<Locale?> onLocaleChanged;

  const LocaleScope({
    super.key,
    required this.locale,
    required this.onLocaleChanged,
    required super.child,
  });

  static LocaleScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LocaleScope>();

  @override
  bool updateShouldNotify(LocaleScope oldWidget) => locale != oldWidget.locale;
}

class GenToLoApp extends StatefulWidget {
  static const String appName = 'GenToLo';
  static const String appTitle = 'GenToLo - Generatore numeri casuali';
  static const String appVersion = '1.1.0';
  static const String appAuthor = 'Fabrizio Ruggiano';
  static const String appLegalese = '© 2026 Fabrizio Ruggiano — GNU General Public License v3.0';

  final Locale? initialLocale;
  final Locale? locale;
  final ExtractionSettings? initialSettings;
  final SettingsService? settingsService;

  const GenToLoApp({
    super.key,
    this.initialLocale,
    this.locale,
    this.initialSettings,
    this.settingsService,
  });

  @override
  State<GenToLoApp> createState() => _GenToLoAppState();
}

class _GenToLoAppState extends State<GenToLoApp> {
  Locale? _currentLocale;

  @override
  void initState() {
    super.initState();
    _currentLocale = widget.locale ?? widget.initialLocale;
  }

  @override
  void didUpdateWidget(GenToLoApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.locale != null && widget.locale != oldWidget.locale) {
      _currentLocale = widget.locale;
    }
  }

  void _onLocaleChanged(Locale? newLocale) {
    setState(() {
      _currentLocale = newLocale;
    });
    widget.settingsService?.saveLanguageCode(newLocale?.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return LocaleScope(
      locale: _currentLocale,
      onLocaleChanged: _onLocaleChanged,
      child: MaterialApp(
        onGenerateTitle: (context) => AppLocalizations.of(context)?.appTitle ?? GenToLoApp.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
        locale: _currentLocale,
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
          initialSettings: widget.initialSettings,
          settingsService: widget.settingsService,
        ),
      ),
    );
  }
}
