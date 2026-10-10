import 'package:flutter/material.dart';
import 'package:gentolo/controllers/lottery_controller.dart';
import 'package:gentolo/l10n/app_localizations.dart';
import 'package:gentolo/services/extraction_service.dart';
import 'package:gentolo/theme/app_theme.dart';

class ControlPanel extends StatelessWidget {
  final LotteryController controller;

  const ControlPanel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isAnimating = controller.isBusy;
    const theme = AppTheme.defaultTheme;
    final l10n = AppLocalizations.of(context)!;
    final isTombolaFinished = controller.isTombolaFinished;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Color.lerp(theme.backgroundBottom, Colors.black, 0.4)!.withValues(alpha: 0.94),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 16.0,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: theme.primaryAccent.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avviso o barra di stato in modalità Tombola
            if (controller.isTombolaMode) ...[
              Container(
                height: 40.0,
                margin: const EdgeInsets.only(bottom: 10.0),
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: isTombolaFinished
                      ? Colors.orange.withValues(alpha: 0.2)
                      : theme.boardBackground,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: isTombolaFinished ? Colors.orangeAccent : theme.primaryAccent.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            isTombolaFinished ? Icons.celebration_rounded : Icons.confirmation_number_rounded,
                            size: 18.0,
                            color: isTombolaFinished ? Colors.orangeAccent : theme.primaryAccent,
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                isTombolaFinished
                                    ? l10n.tombolaCompletedBanner
                                    : l10n.tombolaRemainingBanner(controller.remainingTombolaCount),
                                style: TextStyle(
                                  color: isTombolaFinished ? Colors.orangeAccent : Colors.white70,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    Visibility(
                      visible: isTombolaFinished || controller.tombolaExtractedNumbers.isNotEmpty,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: TextButton(
                        onPressed: isAnimating ? null : () => controller.resetTombolaSession(),
                        style: TextButton.styleFrom(
                          minimumSize: const Size(0, 36.0),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                        ),
                        child: Text(
                          l10n.newGame,
                          style: TextStyle(
                            color: theme.primaryAccent,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Riga dei 3 tasti di estrazione (Casuale, Esclusione, Combinazione)
            Row(
              children: [
                // 1. Bottone Casuale
                Expanded(
                  child: _buildMethodButton(
                    title: l10n.randomMethod,
                    icon: Icons.casino_rounded,
                    accentColor: theme.primaryAccent,
                    isActive: controller.currentMethod == ExtractionMethod.casuale,
                    isDisabled: isAnimating || isTombolaFinished,
                    onPressed: () => controller.startExtraction(ExtractionMethod.casuale),
                  ),
                ),
                const SizedBox(width: 8.0),

                // 2. Bottone Esclusione
                Expanded(
                  child: _buildMethodButton(
                    title: l10n.exclusionMethod,
                    icon: Icons.close_rounded,
                    accentColor: AppTheme.exclusionRed,
                    isActive: controller.currentMethod == ExtractionMethod.esclusione,
                    isDisabled: isAnimating || isTombolaFinished,
                    onPressed: () => controller.startExtraction(ExtractionMethod.esclusione),
                  ),
                ),
                const SizedBox(width: 8.0),

                // 3. Bottone Combinazione
                Expanded(
                  child: _buildMethodButton(
                    title: l10n.combinationMethod,
                    icon: Icons.grid_view_rounded,
                    accentColor: AppTheme.emeraldFlash,
                    isActive: controller.currentMethod == ExtractionMethod.combinazione,
                    isDisabled: isAnimating || isTombolaFinished,
                    onPressed: () => controller.startExtraction(ExtractionMethod.combinazione),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodButton({
    required String title,
    required IconData icon,
    required Color accentColor,
    required bool isActive,
    required bool isDisabled,
    required VoidCallback onPressed,
  }) {
    const vPadding = 11.0;
    const iconSize = 23.0;
    const titleSize = 13.5;

    return Semantics(
      button: true,
      enabled: !isDisabled,
      selected: isActive,
      excludeSemantics: true,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(14.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: vPadding, horizontal: 4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  accentColor.withValues(alpha: isActive ? 0.35 : (isDisabled ? 0.05 : 0.16)),
                  accentColor.withValues(alpha: isActive ? 0.16 : (isDisabled ? 0.02 : 0.05)),
                ],
              ),
              border: Border.all(
                color: accentColor.withValues(alpha: isActive ? 0.95 : (isDisabled ? 0.20 : 0.50)),
                width: isActive ? 1.8 : 1.2,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.35),
                        blurRadius: 10.0,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : const [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 4.0,
                        offset: Offset(0, 1),
                      ),
                    ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isDisabled
                      ? accentColor.withValues(alpha: 0.35)
                      : accentColor,
                  size: iconSize,
                ),
                const SizedBox(height: 4.0),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      color: isActive
                          ? Colors.white
                          : isDisabled
                              ? Colors.white30
                              : Colors.white,
                      fontSize: titleSize,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                      shadows: const [
                        Shadow(
                          color: Colors.black87,
                          blurRadius: 3.0,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
