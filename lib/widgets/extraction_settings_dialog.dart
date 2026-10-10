import 'package:flutter/material.dart';
import 'package:gentolo/controllers/lottery_controller.dart';
import 'package:gentolo/l10n/app_localizations.dart';
import 'package:gentolo/main.dart';
import 'package:gentolo/models/extraction_settings.dart';
import 'package:gentolo/theme/app_theme.dart';

/// Finestrella modale di configurazione per quantità di numeri (1..10), range 1..X e modalità Tombola
class ExtractionSettingsDialog extends StatefulWidget {
  final LotteryController controller;

  const ExtractionSettingsDialog({super.key, required this.controller});

  @override
  State<ExtractionSettingsDialog> createState() => _ExtractionSettingsDialogState();
}

class _ExtractionSettingsDialogState extends State<ExtractionSettingsDialog> {
  late int _drawCount;
  late int _maxNumber;
  late bool _isTombolaMode;
  Locale? _selectedLocale;
  bool _localeInitialized = false;

  @override
  void initState() {
    super.initState();
    _drawCount = widget.controller.drawCount;
    _maxNumber = widget.controller.maxNumber;
    _isTombolaMode = widget.controller.isTombolaMode;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_localeInitialized) {
      _selectedLocale = LocaleScope.of(context)?.locale;
      _localeInitialized = true;
    }
  }

  void _showTombolaInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF092815),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            color: AppTheme.defaultTheme.primaryAccent.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
        title: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: AppTheme.defaultTheme.primaryAccent),
            const SizedBox(width: 8.0),
            Text(
              l10n.tombolaModeTitle,
              style: const TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          l10n.tombolaExplanation,
          style: const TextStyle(color: Colors.white70, fontSize: 14.0, height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              l10n.understood,
              style: TextStyle(color: AppTheme.defaultTheme.primaryAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const theme = AppTheme.defaultTheme;
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: const Color(0xFF092815),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(
          color: theme.primaryAccent.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titolo e pulsante chiudi
            Row(
              children: [
                Icon(Icons.tune_rounded, color: theme.primaryAccent, size: 22.0),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    l10n.extractionSettingsTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: l10n.close,
                ),
              ],
            ),
            const SizedBox(height: 14.0),
            Divider(color: Colors.white.withValues(alpha: 0.12), height: 1.0),
            const SizedBox(height: 18.0),

            // 1. Quantità numeri da estrarre (1..10)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.numbersToExtractLabel,
                  style: const TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w600),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: theme.primaryAccent.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: theme.primaryAccent.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    '$_drawCount',
                    style: TextStyle(
                      color: theme.primaryAccent,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: theme.primaryAccent,
                inactiveTrackColor: Colors.white24,
                thumbColor: theme.primaryAccent,
                overlayColor: theme.primaryAccent.withValues(alpha: 0.2),
              ),
              child: Slider(
                value: _drawCount.toDouble(),
                min: 1.0,
                max: 10.0,
                divisions: 9,
                label: '$_drawCount',
                onChanged: (val) {
                  setState(() {
                    _drawCount = val.round();
                    if (_maxNumber < _drawCount) {
                      _maxNumber = _drawCount;
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 14.0),

            // 2. Selettore Range numeri (da 1 a X)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.extractRangeLabel,
                  style: const TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w600),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: theme.primaryAccent.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: theme.primaryAccent.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    '$_maxNumber',
                    style: TextStyle(
                      color: theme.primaryAccent,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: theme.primaryAccent,
                inactiveTrackColor: Colors.white24,
                thumbColor: theme.primaryAccent,
                overlayColor: theme.primaryAccent.withValues(alpha: 0.2),
              ),
              child: Slider(
                value: _maxNumber.toDouble(),
                min: _drawCount.toDouble(),
                max: 90.0,
                divisions: 90 - _drawCount > 0 ? 90 - _drawCount : 1,
                label: '$_maxNumber',
                onChanged: (val) {
                  setState(() {
                    _maxNumber = val.round().clamp(_drawCount, 90);
                  });
                },
              ),
            ),
            if (_maxNumber < 90)
              Padding(
                padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
                child: Text(
                  l10n.hiddenNumbersNotice(_maxNumber + 1),
                  style: const TextStyle(color: Colors.white54, fontSize: 12.0),
                ),
              ),
            const SizedBox(height: 10.0),
            Divider(color: Colors.white.withValues(alpha: 0.12), height: 1.0),
            const SizedBox(height: 14.0),

            // 3. Modalità Tombola con icona informativa
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: _isTombolaMode
                    ? theme.primaryAccent.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(
                  color: _isTombolaMode
                      ? theme.primaryAccent.withValues(alpha: 0.45)
                      : Colors.white12,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          l10n.tombolaModeTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        IconButton(
                          icon: Icon(
                            Icons.info_outline_rounded,
                            size: 19.0,
                            color: theme.primaryAccent,
                          ),
                          onPressed: () => _showTombolaInfo(context),
                          tooltip: l10n.tombolaInfoTooltip,
                          constraints: const BoxConstraints(minWidth: 44.0, minHeight: 44.0),
                          padding: const EdgeInsets.all(8.0),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: _isTombolaMode,
                    activeTrackColor: theme.primaryAccent,
                    onChanged: (val) {
                      setState(() {
                        _isTombolaMode = val;
                      });
                    },
                  ),
                ],
              ),
            ),

            if (widget.controller.isTombolaMode && widget.controller.tombolaExtractedNumbers.isNotEmpty) ...[
              const SizedBox(height: 12.0),
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    widget.controller.resetTombolaSession();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 18.0, color: Colors.orangeAccent),
                  label: Text(
                    l10n.resetOngoingTombola,
                    style: const TextStyle(color: Colors.orangeAccent, fontSize: 13.0),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 12.0),
            Divider(color: Colors.white.withValues(alpha: 0.12), height: 1.0),
            const SizedBox(height: 14.0),

            // 4. Selezione Lingua (menu a tendina senza bandierine)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.language_rounded, color: theme.primaryAccent, size: 20.0),
                    const SizedBox(width: 8.0),
                    Text(
                      l10n.languageLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: theme.primaryAccent.withValues(alpha: 0.45),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      value: _selectedLocale?.languageCode,
                      dropdownColor: const Color(0xFF092815),
                      icon: Icon(Icons.arrow_drop_down_rounded, color: theme.primaryAccent),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                      onChanged: (String? val) {
                        setState(() {
                          _selectedLocale = val != null ? Locale(val) : null;
                        });
                      },
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(l10n.languageSystem),
                        ),
                        DropdownMenuItem<String?>(
                          value: 'it',
                          child: Text(l10n.languageItalian),
                        ),
                        DropdownMenuItem<String?>(
                          value: 'en',
                          child: Text(l10n.languageEnglish),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22.0),

            // Bottoni Salva / Annulla
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel, style: const TextStyle(color: Colors.white60)),
                ),
                const SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {
                    final newSettings = ExtractionSettings(
                      drawCount: _drawCount,
                      maxNumber: _maxNumber,
                      isTombolaMode: _isTombolaMode,
                    );
                    widget.controller.updateSettings(newSettings);
                    final scope = LocaleScope.of(context);
                    if (scope != null && scope.locale != _selectedLocale) {
                      scope.onLocaleChanged(_selectedLocale);
                    }
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryAccent,
                    foregroundColor: const Color(0xFF140D00),
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    l10n.apply,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
