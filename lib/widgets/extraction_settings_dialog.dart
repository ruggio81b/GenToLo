import 'package:flutter/material.dart';
import 'package:gentolo/controllers/lottery_controller.dart';
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

  @override
  void initState() {
    super.initState();
    _drawCount = widget.controller.drawCount;
    _maxNumber = widget.controller.maxNumber;
    _isTombolaMode = widget.controller.isTombolaMode;
  }

  void _showTombolaInfo(BuildContext context) {
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
            const Text(
              'Modalità Tombola',
              style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'In modalità Tombola le estrazioni sono progressive e senza reinserimento:\n\n'
          '• I numeri estratti non tornano nel sacchetto e restano segnati.\n'
          '• Alla successiva estrazione, i numeri nei cerchi scendono sul tabellone posizionandosi e oscurandosi nella loro casella per fare spazio ai nuovi estratti.\n'
          '• La sessione prosegue fino all\'esaurimento dei numeri nel sacchetto.',
          style: TextStyle(color: Colors.white70, fontSize: 14.0, height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Ho capito',
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
                const Expanded(
                  child: Text(
                    'Impostazioni Estrazione',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Chiudi',
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
                const Text(
                  'Numeri da estrarre:',
                  style: TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w600),
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
                const Text(
                  'Estrai numeri da 1 a:',
                  style: TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w600),
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
                  'I numeri da ${_maxNumber + 1} a 90 resteranno nascosti sul tabellone.',
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
                        const Text(
                          'Modalità Tombola',
                          style: TextStyle(
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
                          tooltip: 'Come funziona la modalità Tombola?',
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(4.0),
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
                  label: const Text(
                    'Azzera partita Tombola in corso',
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 13.0),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 22.0),

            // Bottoni Salva / Annulla
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Annulla', style: TextStyle(color: Colors.white60)),
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
                  child: const Text(
                    'Applica',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
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
