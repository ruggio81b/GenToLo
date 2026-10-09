import 'package:flutter/material.dart';
import 'package:gentolo/l10n/app_localizations.dart';
import 'package:gentolo/main.dart';
import 'package:gentolo/theme/app_theme.dart';

/// Finestra modale informativa con spiegazione dei 3 metodi, crediti e disclaimer legali
class InfoDialog extends StatelessWidget {
  final int drawCount;
  final int maxNumber;
  final GameThemeColors theme;

  const InfoDialog({
    super.key,
    required this.drawCount,
    this.maxNumber = 90,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: theme.boardBackground,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
      titlePadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 4.0),
      contentPadding: const EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 14.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(
          color: theme.primaryAccent,
          width: 1.5,
        ),
      ),
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            color: theme.primaryAccent,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: l10n.close,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              l10n.infoTitle,
              style: TextStyle(
                color: theme.primaryAccent,
                fontSize: 17.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Intestazione Versione e Autore
              const Text(
                '${GenToLoApp.appName} Versione ${GenToLoApp.appVersion}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 15.0,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2.0),
              const Text(
                'Generatore numeri per Tombola e Lotterie',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                'Creato da ${GenToLoApp.appAuthor}',
                style: TextStyle(
                  color: theme.primaryAccent,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Divider(color: Colors.white24, height: 16),

              // I 3 Metodi di estrazione
              Text(
                l10n.methodsSectionTitle,
                style: TextStyle(
                  color: theme.primaryAccent,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 6.0),
              _MethodDescTile(
                title: '1. ${l10n.randomMethod}',
                color: theme.primaryAccent,
                description: l10n.casualeDesc,
              ),
              const Divider(color: Colors.white12, height: 12),
              _MethodDescTile(
                title: '2. ${l10n.exclusionMethod}',
                color: AppTheme.exclusionRed,
                description: l10n.esclusioneDesc,
              ),
              const Divider(color: Colors.white12, height: 12),
              _MethodDescTile(
                title: '3. ${l10n.combinationMethod}',
                color: AppTheme.emeraldFlash,
                description: l10n.combinazioneDesc,
              ),
              const Divider(color: Colors.white24, height: 16),

              // Disclaimer e Note
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.white12,
                    width: 1.0,
                  ),
                ),
                child: Text(
                  l10n.disclaimerText,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 10.0,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      ),
                      onPressed: () => _showPrivacyPolicyDialog(context, l10n, theme),
                      icon: const Icon(Icons.privacy_tip_outlined, size: 14.0, color: Colors.white70),
                      label: Text(
                        l10n.privacyPolicy,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11.5,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      ),
                      onPressed: () {
                        showLicensePage(
                          context: context,
                          applicationName: GenToLoApp.appName,
                          applicationVersion: GenToLoApp.appVersion,
                          applicationLegalese: GenToLoApp.appLegalese,
                        );
                      },
                      icon: const Icon(Icons.description_outlined, size: 14.0, color: Colors.white70),
                      label: Text(
                        l10n.openSourceLicenses,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11.5,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacyPolicyDialog(
    BuildContext context,
    AppLocalizations l10n,
    GameThemeColors theme,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.boardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(
            color: theme.primaryAccent,
            width: 1.5,
          ),
        ),
        titlePadding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 4.0),
        contentPadding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
        title: Row(
          children: [
            Icon(Icons.privacy_tip_outlined, color: theme.primaryAccent, size: 22.0),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                l10n.privacyPolicy,
                style: TextStyle(
                  color: theme.primaryAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _PrivacySectionTile(
                  icon: Icons.wifi_off_rounded,
                  title: l10n.privacyPolicyOfflineTitle,
                  description: l10n.privacyPolicyOfflineDesc,
                  theme: theme,
                ),
                const SizedBox(height: 10.0),
                _PrivacySectionTile(
                  icon: Icons.no_accounts_outlined,
                  title: l10n.privacyPolicyNoDataTitle,
                  description: l10n.privacyPolicyNoDataDesc,
                  theme: theme,
                ),
                const SizedBox(height: 10.0),
                _PrivacySectionTile(
                  icon: Icons.share_outlined,
                  title: l10n.privacyPolicySharingTitle,
                  description: l10n.privacyPolicySharingDesc,
                  theme: theme,
                ),
                const SizedBox(height: 10.0),
                _PrivacySectionTile(
                  icon: Icons.block_outlined,
                  title: l10n.privacyPolicyNoAdsTitle,
                  description: l10n.privacyPolicyNoAdsDesc,
                  theme: theme,
                ),
                const SizedBox(height: 12.0),
                const Divider(color: Colors.white24, height: 1.0),
                const SizedBox(height: 8.0),
                Text(
                  l10n.privacyPolicyOwner,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 10.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              l10n.closeDialog,
              style: TextStyle(
                color: theme.primaryAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacySectionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final GameThemeColors theme;

  const _PrivacySectionTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.0, color: theme.primaryAccent),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11.0,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MethodDescTile extends StatelessWidget {
  final String title;
  final String description;
  final Color color;

  const _MethodDescTile({
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          description,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13.0,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
