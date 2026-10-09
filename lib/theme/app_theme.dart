import 'package:flutter/material.dart';

/// Configurazione cromatica specifica per ciascuna modalità di gioco
class GameThemeColors {
  final Color backgroundTop;
  final Color backgroundBottom;
  final Color boardBackground;
  final Color boardBorder;
  final Color boardInnerBorder;
  final Color primaryAccent;
  final Color secondaryAccent;
  final Color socketBorder;
  final Color socketBackground;
  final Color textMuted;
  final LinearGradient badgeGradient;
  final Color badgeTextColor;

  const GameThemeColors({
    required this.backgroundTop,
    required this.backgroundBottom,
    required this.boardBackground,
    required this.boardBorder,
    required this.boardInnerBorder,
    required this.primaryAccent,
    required this.secondaryAccent,
    required this.socketBorder,
    required this.socketBackground,
    required this.textMuted,
    required this.badgeGradient,
    required this.badgeTextColor,
  });
}

class AppTheme {
  // Palette 3D per le Palline Dorate
  static const Color ballHighlight = Color(0xFFFFFDE7);
  static const Color ballMidLight = Color(0xFFFFE082);
  static const Color ballPrimary = Color(0xFFFFB300);
  static const Color ballShadow = Color(0xFF8D5B00);
  static const Color ballDarkEdge = Color(0xFF4E3000);
  static const Color ballText = Color(0xFF140D00);

  // Palette 3D per la Pallina in stato Flash Verde (Combinazione)
  static const Color flashHighlight = Color(0xFFF1F8E9);
  static const Color flashPrimary = Color(0xFF00E676);
  static const Color flashShadow = Color(0xFF00701A);
  static const Color flashDarkEdge = Color(0xFF003300);
  static const Color emeraldFlash = Color(0xFF00E676);

  // Colori Accento
  static const Color exclusionRed = Color(0xFFD32F2F);
  static const Color goldPrimary = Color(0xFFFFC107);
  static const Color goldAccent = Color(0xFFFFD700);

  // Tema Principale (Verde Panno & Oro)
  static const GameThemeColors defaultTheme = GameThemeColors(
    backgroundTop: Color(0xFF0F3D22),
    backgroundBottom: Color(0xFF071E10),
    boardBackground: Color(0xFF092815),
    boardBorder: Color(0xFF1B5E20),
    boardInnerBorder: Color(0x40FFD700),
    primaryAccent: Color(0xFFFFC107),
    secondaryAccent: Color(0xFFFFD700),
    socketBorder: Color(0xFFE0A800),
    socketBackground: Color(0xFF05170B),
    textMuted: Color(0xFFA5D6A7),
    badgeGradient: LinearGradient(
      colors: [Color(0xFFFFD700), Color(0xFFFFC107)],
    ),
    badgeTextColor: Color(0xFF140D00),
  );

  /// Restituisce i colori del tema principale (Verde Panno & Oro)
  static GameThemeColors of() => defaultTheme;

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: goldPrimary,
      scaffoldBackgroundColor: const Color(0xFF071E10),
      colorScheme: const ColorScheme.dark(
        primary: goldPrimary,
        secondary: goldAccent,
      ),
      fontFamily: 'Roboto',
    );
  }
}
