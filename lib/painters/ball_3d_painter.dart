import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:gentolo/theme/app_theme.dart';

/// Disegna una pallina 3D con effetto sfera realistico,
/// ombreggiatura zenitale, riflesso speculare e tipografia centrata ad alto contrasto.
class Ball3DPainter {
  // Dimensioni base di riferimento per la pre-renderizzazione vettoriale dei numeri
  static const double _kBaseRadius = 50.0;
  static final Map<int, TextPainter> _numberPainters = _initNumberPainters();

  // Istanze Paint riutilizzabili staticamente per azzerare le allocazioni per frame
  static final Paint _basePaint = Paint()..style = PaintingStyle.fill;
  static final Paint _shadowPaint = Paint()..style = PaintingStyle.fill;
  static final Paint _glowPaint = Paint()..style = PaintingStyle.fill;
  static final Paint _highlightPaint = Paint()..style = PaintingStyle.fill;
  static final Paint _rimPaint = Paint()..style = PaintingStyle.stroke;
  static final Paint _layerPaint = Paint();
  static final Paint _socketBgPaint = Paint()..style = PaintingStyle.fill;
  static final Paint _socketInnerShadowPaint = Paint()..style = PaintingStyle.fill;
  static final Paint _socketBorderPaint = Paint()..style = PaintingStyle.stroke;

  /// Pre-inizializza e calcola il layout di tutti i 90 numeri all'avvio dell'app (una volta sola)
  static Map<int, TextPainter> _initNumberPainters() {
    final map = <int, TextPainter>{};
    for (int i = 1; i <= 90; i++) {
      final isTwoDigits = i >= 10;
      final fontSize = isTwoDigits ? _kBaseRadius * 0.95 : _kBaseRadius * 1.15;
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$i',
          style: TextStyle(
            color: AppTheme.ballText,
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            letterSpacing: isTwoDigits ? -1.0 : 0.0,
            height: 1.0,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout();
      map[i] = textPainter;
    }
    return map;
  }

  static void paintBall({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required int number,
    bool isFlashing = false,
    double flashIntensity = 0.0,
    double altitude = 0.0, // 0.0 = sul tabellone, 1.0 = massima altezza in volo
    double opacity = 1.0,
  }) {
    if (radius <= 0 || opacity <= 0.0) return;

    if (opacity < 1.0) {
      _layerPaint.color = Colors.white.withValues(alpha: opacity);
      canvas.saveLayer(
        Rect.fromCircle(center: center, radius: radius * 2.5),
        _layerPaint,
      );
    }

    // 1. Ombra proiettata (drop shadow) ottimizzata via gradiente radiale (Zero Blur Passes)
    final shadowOffset = Offset(
      radius * (0.08 + altitude * 0.35),
      radius * (0.16 + altitude * 0.55),
    );
    final shadowRadius = radius * (0.92 + altitude * 0.3);
    final shadowOpacity = math.max(0.0, (0.55 - altitude * 0.25)).clamp(0.0, 1.0);

    if (shadowOpacity > 0.01) {
      final shadowCenter = center + shadowOffset;
      final shadowRect = Rect.fromCircle(center: shadowCenter, radius: shadowRadius);
      _shadowPaint.shader = RadialGradient(
        colors: [
          Colors.black.withValues(alpha: shadowOpacity * 0.95),
          Colors.black.withValues(alpha: shadowOpacity * 0.45),
          Colors.black.withValues(alpha: 0.0),
        ],
        stops: const [0.35, 0.70, 1.0],
      ).createShader(shadowRect);
      canvas.drawCircle(shadowCenter, shadowRadius, _shadowPaint);
    }

    // 2. Alone di luce per effetto flash (se attivo nel metodo Combinazione)
    if (isFlashing || flashIntensity > 0.0) {
      final intensity = isFlashing ? 1.0 : flashIntensity;
      final glowRadius = radius * 1.35;
      final glowRect = Rect.fromCircle(center: center, radius: glowRadius);
      _glowPaint.shader = RadialGradient(
        colors: [
          AppTheme.emeraldFlash.withValues(alpha: 0.75 * intensity),
          AppTheme.emeraldFlash.withValues(alpha: 0.0),
        ],
        stops: const [0.45, 1.0],
      ).createShader(glowRect);
      canvas.drawCircle(center, glowRadius, _glowPaint);
    }

    // 3. Gradiente sferico principale 3D
    final lightOffset = Offset(center.dx - radius * 0.28, center.dy - radius * 0.32);

    final highlightColor = isFlashing
        ? AppTheme.flashHighlight
        : AppTheme.ballHighlight;
    final midLightColor = isFlashing
        ? AppTheme.flashPrimary
        : AppTheme.ballMidLight;
    final primaryColor = isFlashing
        ? AppTheme.flashPrimary
        : AppTheme.ballPrimary;
    final shadowColor = isFlashing
        ? AppTheme.flashShadow
        : AppTheme.ballShadow;
    final darkEdgeColor = isFlashing
        ? AppTheme.flashDarkEdge
        : AppTheme.ballDarkEdge;

    final sphereGradient = RadialGradient(
      center: Alignment(
        (lightOffset.dx - center.dx) / radius,
        (lightOffset.dy - center.dy) / radius,
      ),
      radius: 1.05,
      colors: [
        highlightColor,
        midLightColor,
        primaryColor,
        shadowColor,
        darkEdgeColor,
      ],
      stops: const [0.0, 0.22, 0.58, 0.86, 1.0],
    );

    _basePaint.shader = sphereGradient.createShader(
      Rect.fromCircle(center: center, radius: radius),
    );

    canvas.drawCircle(center, radius, _basePaint);

    // 4. Riflesso speculare ellittico in alto a sinistra (Glossy Highlight)
    final highlightCenter = Offset(
      center.dx - radius * 0.28,
      center.dy - radius * 0.34,
    );
    final highlightRect = Rect.fromCenter(
      center: highlightCenter,
      width: radius * 0.52,
      height: radius * 0.32,
    );

    canvas.save();
    canvas.translate(highlightCenter.dx, highlightCenter.dy);
    canvas.rotate(-math.pi / 5.5);
    canvas.translate(-highlightCenter.dx, -highlightCenter.dy);

    _highlightPaint.shader = RadialGradient(
      colors: [
        Colors.white.withValues(alpha: 0.75),
        Colors.white.withValues(alpha: 0.0),
      ],
      stops: const [0.0, 1.0],
    ).createShader(highlightRect);

    canvas.drawOval(highlightRect, _highlightPaint);
    canvas.restore();

    // 5. Riflesso sottile di bordo inferiore (rim light ambientale)
    _rimPaint
      ..color = Colors.white.withValues(alpha: 0.12)
      ..strokeWidth = math.max(1.0, radius * 0.06);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.94),
      math.pi * 0.15,
      math.pi * 0.7,
      false,
      _rimPaint,
    );

    // 6. Testo del numero precompilato con GPU Scaling (Zero Text Layouts a frame)
    final textPainter = _numberPainters[number]!;
    final scale = radius / _kBaseRadius;
    canvas.save();
    canvas.translate(center.dx, center.dy + (radius * 0.06));
    canvas.scale(scale, scale);
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
    canvas.restore();

    if (opacity < 1.0) {
      canvas.restore();
    }
  }

  /// Disegna un alloggiamento/cerchio vuoto della barra superiore
  static void paintSocket({
    required Canvas canvas,
    required Offset center,
    required double radius,
    bool isHighlighted = false,
    Color? borderColor,
    Color? backgroundColor,
  }) {
    // Ombra interna / incasso
    _socketBgPaint.color = backgroundColor ?? AppTheme.defaultTheme.socketBackground;
    canvas.drawCircle(center, radius, _socketBgPaint);

    // Gradiente incavato
    final socketRect = Rect.fromCircle(center: center, radius: radius);
    _socketInnerShadowPaint.shader = RadialGradient(
      colors: [
        Colors.black.withValues(alpha: 0.2),
        Colors.black.withValues(alpha: 0.8),
      ],
      stops: const [0.6, 1.0],
    ).createShader(socketRect);
    canvas.drawCircle(center, radius, _socketInnerShadowPaint);

    // Bordo esterno (oro o arancione in base alla modalità)
    final resolvedBorderColor = borderColor ?? AppTheme.goldAccent;
    _socketBorderPaint
      ..color = isHighlighted
          ? resolvedBorderColor
          : resolvedBorderColor.withValues(alpha: 0.7)
      ..strokeWidth = math.max(2.0, radius * 0.08);
    canvas.drawCircle(center, radius, _socketBorderPaint);
  }
}
