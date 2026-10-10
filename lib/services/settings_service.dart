import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gentolo/models/extraction_settings.dart';

/// Servizio per la persistenza locale delle preferenze di estrazione dell'utente
class SettingsService {
  static const String _keyDrawCount = 'settings_draw_count';
  static const String _keyMaxNumber = 'settings_max_number';
  static const String _keyLanguageCode = 'settings_language_code';

  final SharedPreferences? _prefs;

  const SettingsService([this._prefs]);

  /// Carica le impostazioni memorizzate sul dispositivo.
  /// Se non sono presenti o in caso di errore, restituisce i valori di default (drawCount: 5, maxNumber: 90).
  Future<ExtractionSettings> loadSettings() async {
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      final savedDrawCount = prefs.getInt(_keyDrawCount) ?? 5;
      final safeDrawCount = savedDrawCount.clamp(1, 10);

      final savedMaxNumber = prefs.getInt(_keyMaxNumber) ?? 90;
      final safeMaxNumber = savedMaxNumber.clamp(safeDrawCount, 90);

      return ExtractionSettings(
        drawCount: safeDrawCount,
        maxNumber: safeMaxNumber,
        isTombolaMode: false,
      );
    } catch (e, stackTrace) {
      developer.log(
        'Errore durante il caricamento delle impostazioni, uso default',
        error: e,
        stackTrace: stackTrace,
        name: 'SettingsService',
      );
      return const ExtractionSettings(drawCount: 5, maxNumber: 90);
    }
  }

  /// Salva le impostazioni correnti nel local storage
  Future<void> saveSettings(ExtractionSettings settings) async {
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      await prefs.setInt(_keyDrawCount, settings.drawCount);
      await prefs.setInt(_keyMaxNumber, settings.maxNumber);
    } catch (e, stackTrace) {
      developer.log(
        'Errore durante il salvataggio delle impostazioni',
        error: e,
        stackTrace: stackTrace,
        name: 'SettingsService',
      );
    }
  }

  /// Carica il codice lingua memorizzato (es. 'it', 'en'), oppure null se predefinito di sistema.
  Future<String?> loadLanguageCode() async {
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      return prefs.getString(_keyLanguageCode);
    } catch (e, stackTrace) {
      developer.log(
        'Errore durante il caricamento del codice lingua, uso default di sistema',
        error: e,
        stackTrace: stackTrace,
        name: 'SettingsService',
      );
      return null;
    }
  }

  /// Salva il codice lingua selezionato nel local storage (passare null per ripristinare il default di sistema).
  Future<void> saveLanguageCode(String? languageCode) async {
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      if (languageCode == null || languageCode.isEmpty) {
        await prefs.remove(_keyLanguageCode);
      } else {
        await prefs.setString(_keyLanguageCode, languageCode);
      }
    } catch (e, stackTrace) {
      developer.log(
        'Errore durante il salvataggio del codice lingua',
        error: e,
        stackTrace: stackTrace,
        name: 'SettingsService',
      );
    }
  }
}
