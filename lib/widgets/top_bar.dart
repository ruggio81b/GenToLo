import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gentolo/controllers/lottery_controller.dart';
import 'package:gentolo/l10n/app_localizations.dart';
import 'package:gentolo/theme/app_theme.dart';
import 'package:gentolo/widgets/extraction_settings_dialog.dart';
import 'package:gentolo/widgets/info_dialog.dart';

class TopBar extends StatelessWidget {
  final LotteryController controller;

  const TopBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final hasNumbers = controller.drawnNumbers.isNotEmpty;
    final isAnimating =
        controller.animationController.isAnimating || controller.resetController.isAnimating;
    const theme = AppTheme.defaultTheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
      child: Row(
        children: [
          // Badge / Pulsante per aprire la finestrella delle impostazioni di estrazione
          Semantics(
            button: true,
            excludeSemantics: true,
            label: l10n.openSettingsSemantics(controller.drawCount, controller.maxNumber),
            child: InkWell(
              onTap: isAnimating ? null : () => _showSettingsDialog(context),
              borderRadius: BorderRadius.circular(10.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                constraints: const BoxConstraints(minHeight: 44.0),
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                decoration: BoxDecoration(
                  gradient: controller.isTombolaMode
                      ? const LinearGradient(colors: [Color(0xFFFF9800), Color(0xFFFF5722)])
                      : theme.badgeGradient,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: (controller.isTombolaMode ? Colors.deepOrange : theme.primaryAccent)
                          .withValues(alpha: 0.35),
                      blurRadius: 8.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'GenToLo',
                          style: TextStyle(
                            color: theme.badgeTextColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 13.0,
                            letterSpacing: 1.1,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          controller.isTombolaMode
                              ? (controller.isTombolaFinished
                                  ? l10n.tombolaCompletedBadge
                                  : l10n.tombolaRemainingBadge(controller.remainingTombolaCount))
                              : l10n.standardDrawnBadge(controller.drawCount, controller.maxNumber),
                          style: TextStyle(
                            color: theme.badgeTextColor.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w700,
                            fontSize: 9.0,
                            letterSpacing: 0.8,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 4.0),
                    Icon(
                      Icons.tune_rounded,
                      color: theme.badgeTextColor,
                      size: 16.0,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Spacer(),

          // Pulsante "Info ⓘ" per aprire la schermata informativa
          TextButton(
            onPressed: () => _showInfoDialog(context),
            style: TextButton.styleFrom(
              backgroundColor: theme.boardBackground,
              minimumSize: const Size(44.0, 44.0),
              padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 6.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(
                  color: theme.primaryAccent.withValues(alpha: 0.5),
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.info,
                  style: TextStyle(
                    color: theme.primaryAccent,
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4.0),
                Icon(
                  Icons.info_outline_rounded,
                  size: 16.0,
                  color: theme.primaryAccent,
                ),
              ],
            ),
          ),

          const SizedBox(width: 6.0),

          // Pulsante "Condividi" con Tooltip per accessibilità
          AnimatedOpacity(
            opacity: hasNumbers && !isAnimating ? 1.0 : 0.35,
            duration: const Duration(milliseconds: 300),
            child: Builder(
              builder: (buttonContext) {
                return Tooltip(
                  message: l10n.shareCombinationTooltip,
                  child: TextButton(
                    onPressed: hasNumbers && !isAnimating
                        ? () async {
                            final text = controller.formattedDrawnNumbers;
                            if (text.isNotEmpty) {
                              final box = buttonContext.findRenderObject() as RenderBox?;
                              final Rect? sharePositionOrigin =
                                  (box != null && box.hasSize && box.attached)
                                      ? box.localToGlobal(Offset.zero) & box.size
                                      : (buttonContext.mounted
                                          ? Rect.fromLTWH(
                                              0,
                                              0,
                                              MediaQuery.sizeOf(buttonContext).width,
                                              40,
                                            )
                                          : null);
                              try {
                                await Share.share(
                                  text,
                                  sharePositionOrigin: sharePositionOrigin,
                                );
                              } catch (_) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.shareError),
                                      backgroundColor: theme.boardBackground,
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              }
                            }
                          }
                        : null,
                    style: TextButton.styleFrom(
                      backgroundColor: theme.boardBackground,
                      minimumSize: const Size(44.0, 44.0),
                      padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 6.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                          color: theme.primaryAccent.withValues(alpha: 0.5),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.share_rounded,
                      size: 18.0,
                      color: theme.primaryAccent,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 6.0),

          // Interruttore / Pulsante per Ordinare la Combinazione (Crescente vs Estrazione)
          AnimatedOpacity(
            opacity: hasNumbers && !isAnimating ? 1.0 : 0.35,
            duration: const Duration(milliseconds: 300),
            child: Semantics(
              button: true,
              enabled: hasNumbers && !isAnimating,
              selected: controller.isSortedAscending,
              excludeSemantics: true,
              label: controller.isSortedAscending
                  ? l10n.sortAscendingSemantics
                  : l10n.sortDrawOrderSemantics,
              child: TextButton.icon(
                onPressed: hasNumbers && !isAnimating
                    ? () => controller.toggleSortOrder()
                    : null,
                icon: Icon(
                  controller.isSortedAscending
                      ? Icons.check_circle_outline_rounded
                      : Icons.sort_rounded,
                  size: 17.0,
                  color: controller.isSortedAscending
                      ? AppTheme.emeraldFlash
                      : theme.primaryAccent,
                ),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    controller.isSortedAscending ? l10n.sortAscending : l10n.sort,
                    style: TextStyle(
                      color: controller.isSortedAscending
                          ? AppTheme.emeraldFlash
                          : theme.primaryAccent,
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: theme.boardBackground,
                  minimumSize: const Size(0, 44.0),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(
                      color: controller.isSortedAscending
                          ? AppTheme.emeraldFlash.withValues(alpha: 0.6)
                          : theme.primaryAccent.withValues(alpha: 0.5),
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => ExtractionSettingsDialog(controller: controller),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => InfoDialog(
        drawCount: controller.drawCount,
        maxNumber: controller.maxNumber,
        theme: AppTheme.defaultTheme,
      ),
    );
  }
}
