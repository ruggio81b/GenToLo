import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gentolo/controllers/lottery_controller.dart';
import 'package:gentolo/models/extraction_settings.dart';
import 'package:gentolo/painters/lottery_scene_painter.dart';
import 'package:gentolo/services/settings_service.dart';
import 'package:gentolo/theme/app_theme.dart';
import 'package:gentolo/widgets/control_panel.dart';
import 'package:gentolo/widgets/top_bar.dart';

class LotteryScreen extends StatefulWidget {
  final ExtractionSettings? initialSettings;
  final SettingsService? settingsService;

  const LotteryScreen({
    super.key,
    this.initialSettings,
    this.settingsService,
  });

  @override
  State<LotteryScreen> createState() => _LotteryScreenState();
}

class _LotteryScreenState extends State<LotteryScreen>
    with TickerProviderStateMixin {
  late final LotteryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LotteryController(
      vsync: this,
      initialSettings: widget.initialSettings,
      settingsService: widget.settingsService ?? const SettingsService(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          const theme = AppTheme.defaultTheme;
          final navColor = theme.backgroundBottom;

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: navColor,
              systemNavigationBarIconBrightness: Brightness.light,
              systemNavigationBarDividerColor: Colors.transparent,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.2),
                  radius: 1.15,
                  colors: [
                    theme.backgroundTop,
                    theme.backgroundBottom,
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Barra superiore con badge impostazioni, info, share e toggle ordinamento
                    TopBar(controller: _controller),

                    // Area Centrale Grafica con i Cerchi Superiori (1..10) e il Tabellone 90 Palline
                    Expanded(
                      child: Semantics(
                        container: true,
                        label: 'Tabellone di estrazione',
                        value: _controller.drawnNumbers.isEmpty
                            ? 'Nessun numero ancora estratto'
                            : 'Numeri estratti: ${_controller.formattedDrawnNumbers}',
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return CustomPaint(
                              size: Size(constraints.maxWidth, constraints.maxHeight),
                              painter: LotteryScenePainter(controller: _controller),
                            );
                          },
                        ),
                      ),
                    ),

                    // Barra di controllo inferiore con i tre metodi di estrazione
                    ControlPanel(controller: _controller),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
