import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/animation.dart';
import 'package:gentolo/models/lottery_ball.dart';
import 'package:gentolo/painters/ball_render_item.dart';

/// Calcolatore delle traiettorie cinematiche e del caos per i 3 metodi di estrazione
class TrajectoryCalculator {
  /// Calcolo per il metodo Casuale:
  /// Fino a t=0.55 turbolenza a mezz'aria. Da t=0.55 a 1.0 le non estratte tornano sul tabellone
  /// e le estratte volano nei cerchi superiori, atterrando simultaneamente all'unisono a t=1.0.
  static BallRenderItem calculateCasuale({
    required LotteryBall ball,
    required double t,
    required List<Offset> gridPositions,
    required List<Offset> socketPositions,
    required double boardWidth,
    required double boardHeight,
    required double ballRadius,
    required double socketRadius,
  }) {
    final originalPos = gridPositions[ball.originalGridIndex];

    Offset chaosOffsetAt(double time, double intensity) {
      final angleProgress = time / 0.55;
      final dx = math.sin(ball.phase + angleProgress * ball.freqX * math.pi * 2) *
          ball.seedX *
          (boardWidth * 0.42) *
          intensity;
      final dy = math.cos(ball.phase + angleProgress * ball.freqY * math.pi * 2) *
          ball.seedY *
          (boardHeight * 0.40) *
          intensity;
      return Offset(dx, dy);
    }

    if (t <= 0.55) {
      final ramp = (t / 0.15).clamp(0.0, 1.0);
      final altitude = Curves.easeOutQuad.transform(ramp);
      final offset = chaosOffsetAt(t, ramp);
      final pos = originalPos + offset;
      final radius = ballRadius * (1.0 + altitude * 0.12);
      return BallRenderItem(
        ball: ball,
        center: pos,
        radius: radius,
        altitude: altitude,
        opacity: 1.0,
      );
    } else {
      // Confluenza continua con inerzia: le palline continuano ad oscillare smorzandosi verso le destinazioni
      final p = ((t - 0.55) / 0.45).clamp(0.0, 1.0);
      final dampingIntensity = math.cos(p * math.pi * 0.5);
      final wobble = chaosOffsetAt(t, dampingIntensity);

      if (ball.drawnSlotIndex >= 0) {
        // Le estratte volano nei cerchi superiori trasportando la propria oscillazione fino a destinazione
        final target = socketPositions[ball.drawnSlotIndex];
        final flightP = Curves.easeInOutSine.transform(p);
        final arcOffset = Offset(0, -math.sin(flightP * math.pi) * 32.0);
        final basePos = Offset.lerp(originalPos, target, flightP)! + arcOffset;
        final pos = basePos + wobble;
        final radius = lerpDouble(ballRadius, socketRadius, flightP)!;
        final altitude = lerpDouble(1.0, 0.0, flightP)!;

        return BallRenderItem(
          ball: ball,
          center: pos,
          radius: radius,
          altitude: altitude,
          opacity: 1.0,
        );
      } else {
        // Le non estratte continuano a vorticare mentre l'orbita collassa morbidamente nella propria casella
        final pos = originalPos + wobble;
        final altitude = dampingIntensity;
        final radius = ballRadius * (1.0 + altitude * 0.10);

        return BallRenderItem(
          ball: ball,
          center: pos,
          radius: radius,
          altitude: altitude,
          opacity: 1.0,
        );
      }
    }
  }

  /// Calcolo per il metodo Esclusione:
  /// Fino a 2,00s (2.00 / 3.80) turbolenza caotica. Da 2,00s le scartate vengono scagliate fuori schermo
  /// lungo la loro traiettoria tangente finale di mescolamento; da 2,432s le superstiti volano nei cerchi superiori.
  static BallRenderItem calculateEsclusione({
    required LotteryBall ball,
    required double t,
    required List<Offset> gridPositions,
    required List<Offset> socketPositions,
    required double boardWidth,
    required double boardHeight,
    required double ballRadius,
    required double socketRadius,
    required Size screenSize,
    required Offset boardCenter,
  }) {
    final originalPos = gridPositions[ball.originalGridIndex];

    Offset chaosOffsetAt(double time, double intensity) {
      final angleProgress = time / 0.55;
      final dx = math.sin(ball.phase + angleProgress * ball.freqX * math.pi * 2) *
          ball.seedX *
          (boardWidth * 0.40) *
          intensity;
      final dy = math.cos(ball.phase + angleProgress * ball.freqY * math.pi * 2) *
          ball.seedY *
          (boardHeight * 0.38) *
          intensity;
      return Offset(dx, dy);
    }

    final isDrawn = ball.drawnSlotIndex >= 0;

    if (isDrawn) {
      // LOGICA PALLINE ESTRATTE (Superstiti):
      // Fino a 2,432s continuano a mescolarsi al centro mentre le altre iniziano a volare via a 2,00s.
      // Da 2,432s a 3,584s volano rapidamente e con decisione nei cerchi superiori (durata invariata).
      const flightStartTime = 2.432 / 3.80;
      const flightEndTime = 3.584 / 3.80;

      if (t <= flightStartTime) {
        final ramp = (t / 0.15).clamp(0.0, 1.0);
        final altitude = Curves.easeOutQuad.transform(ramp);
        final offset = chaosOffsetAt(t, ramp);
        final pos = originalPos + offset;
        final radius = ballRadius * (1.0 + altitude * 0.12);
        return BallRenderItem(
          ball: ball,
          center: pos,
          radius: radius,
          altitude: altitude,
          opacity: 1.0,
        );
      } else {
        // Volo rapido e diretto verso il cerchio assegnato
        final flightP = ((t - flightStartTime) / (flightEndTime - flightStartTime)).clamp(0.0, 1.0);
        final smoothFlight = Curves.easeOutCubic.transform(flightP);

        final flightStartPos = originalPos + chaosOffsetAt(flightStartTime, 1.0);
        final targetSocket = socketPositions[ball.drawnSlotIndex];
        final arcOffset = Offset(0, -math.sin(smoothFlight * math.pi) * 28.0);

        final pos = Offset.lerp(flightStartPos, targetSocket, smoothFlight)! + arcOffset;
        final radius = lerpDouble(ballRadius, socketRadius, smoothFlight)!;
        final altitude = lerpDouble(1.0, 0.0, smoothFlight)!;

        return BallRenderItem(
          ball: ball,
          center: pos,
          radius: radius,
          altitude: altitude,
          opacity: 1.0,
        );
      }
    } else {
      // LOGICA PALLINE SCARTATE (Espulse):
      // Fino a 2,00s si mescolano al centro (tempo aumentato a 2,00s esatti).
      // Da 2,00s vengono espulse dallo schermo.
      const expulsionStartTime = 2.00 / 3.80;

      if (t <= expulsionStartTime) {
        final ramp = (t / 0.15).clamp(0.0, 1.0);
        final altitude = Curves.easeOutQuad.transform(ramp);
        final offset = chaosOffsetAt(t, ramp);
        final pos = originalPos + offset;
        final radius = ballRadius * (1.0 + altitude * 0.12);
        return BallRenderItem(
          ball: ball,
          center: pos,
          radius: radius,
          altitude: altitude,
          opacity: 1.0,
        );
      } else {
        // Da expulsionStartTime escono proseguendo alla loro reale velocità istantanea di mescolamento (inerzia fisica pura)
        Offset chaosVelocityAt(double time) {
          final angleProgress = time / 0.55;
          final kX = (ball.freqX * math.pi * 2) / 0.55;
          final kY = (ball.freqY * math.pi * 2) / 0.55;
          final vx = math.cos(ball.phase + angleProgress * ball.freqX * math.pi * 2) *
              kX *
              ball.seedX *
              (boardWidth * 0.40);
          final vy = -math.sin(ball.phase + angleProgress * ball.freqY * math.pi * 2) *
              kY *
              ball.seedY *
              (boardHeight * 0.38);
          return Offset(vx, vy);
        }

        var v = chaosVelocityAt(expulsionStartTime);

        // Velocità di sicurezza minima se la pallina si trova casualmente su un punto d'inversione
        const minSpeed = 1350.0;
        if (v.distance < minSpeed) {
          Offset fallbackDir;
          if (v.distance > 0.001) {
            fallbackDir = v / v.distance;
          } else {
            var d = originalPos - boardCenter;
            if (d.distance < 0.001) d = Offset(ball.seedX, ball.seedY);
            fallbackDir = d / d.distance;
          }
          v = fallbackDir * minSpeed;
        }

        final exitStartPos = originalPos + chaosOffsetAt(expulsionStartTime, 1.0);

        // Controllo traiettoria critica verso i cerchi superiori:
        // Se la pallina viaggia verso l'alto (v.dy < 0) e interseca la fascia dei cerchi
        // a t >= 2.72s (quando le prescelte sono quasi in posizione), viene dirottata casualmente
        // verso destra, sotto o sinistra (mai verso l'alto).
        if (v.dy < -1.0 && socketPositions.isNotEmpty) {
          final socketY = socketPositions.first.dy;
          if (exitStartPos.dy > socketY) {
            final tCross = expulsionStartTime + (socketY - exitStartPos.dy) / v.dy;
            if (tCross >= 2.72 / 3.80) {
              final xCross = exitStartPos.dx + v.dx * (tCross - expulsionStartTime);
              final minSocketX = socketPositions.first.dx - socketRadius * 2.5;
              final maxSocketX = socketPositions.last.dx + socketRadius * 2.5;
              if (xCross >= minSocketX && xCross <= maxSocketX) {
                // Dirottamento casuale deterministico per l'estrazione: destra, sotto o sinistra
                final divertRnd = math.Random(ball.number * 7919 + (ball.phase * 10000).toInt());
                final choice = divertRnd.nextInt(3); // 0: destra, 1: sotto, 2: sinistra
                double angle;
                switch (choice) {
                  case 0: // Destra (0° - 45°)
                    angle = divertRnd.nextDouble() * 0.25 * math.pi;
                  case 1: // Sotto (63° - 117°)
                    angle = 0.35 * math.pi + divertRnd.nextDouble() * 0.30 * math.pi;
                  case 2: // Sinistra (135° - 180°)
                    angle = 0.75 * math.pi + divertRnd.nextDouble() * 0.25 * math.pi;
                  default:
                    angle = 0.5 * math.pi;
                }
                final speed = math.max(v.distance, minSpeed);
                v = Offset(math.cos(angle), math.sin(angle)) * speed;
              }
            }
          }
        }

        // Garanzia di uscita completa dallo schermo entro 3,80s (t = 1.0):
        // Se con la velocità attuale la pallina non farebbe in tempo a varcare il bordo,
        // le applichiamo la spinta minima indispensabile per uscire prima della chiusura.
        if (v.distance > 0.001) {
          final u = v / v.distance;
          const borderMargin = 15.0;
          double distToExit = double.infinity;

          if (u.dx > 0.001) {
            final d = (screenSize.width + ballRadius + borderMargin - exitStartPos.dx) / u.dx;
            if (d > 0 && d < distToExit) distToExit = d;
          } else if (u.dx < -0.001) {
            final d = (-ballRadius - borderMargin - exitStartPos.dx) / u.dx;
            if (d > 0 && d < distToExit) distToExit = d;
          }

          if (u.dy > 0.001) {
            final d = (screenSize.height + ballRadius + borderMargin - exitStartPos.dy) / u.dy;
            if (d > 0 && d < distToExit) distToExit = d;
          } else if (u.dy < -0.001) {
            final d = (-ballRadius - borderMargin - exitStartPos.dy) / u.dy;
            if (d > 0 && d < distToExit) distToExit = d;
          }

          if (distToExit.isFinite && distToExit > 0) {
            const remainingTime = 1.0 - expulsionStartTime;
            final neededSpeed = distToExit / remainingTime;
            if (v.distance < neededSpeed) {
              v = u * neededSpeed;
            }
          }
        }

        final dt = t - expulsionStartTime;
        final pos = exitStartPos + v * dt;

        return BallRenderItem(
          ball: ball,
          center: pos,
          radius: ballRadius * 1.12,
          altitude: 1.0,
          opacity: 1.0,
        );
      }
    }
  }

  /// Calcolo per il metodo Combinazione:
  /// 1. Turbolenza a mezz'aria
  /// 2. Rientro DIRETTO sul tabellone già nella posizione rimescolata
  /// 3. Pausa scenica sul tabellone rimescolato con flash per le estratte
  /// 4. Decollo delle prescelte verso i cerchi superiori
  static BallRenderItem calculateCombinazione({
    required LotteryBall ball,
    required double t,
    required List<Offset> gridPositions,
    required List<Offset> socketPositions,
    required double boardWidth,
    required double boardHeight,
    required double ballRadius,
    required double socketRadius,
  }) {
    final originalPos = gridPositions[ball.originalGridIndex];
    final scrambledPos = gridPositions[ball.currentBoardIndex];

    Offset chaosOffsetAt(double time, double intensity) {
      final angleProgress = time / 0.42;
      final dx = math.sin(ball.phase + angleProgress * ball.freqX * math.pi * 2) *
          ball.seedX *
          (boardWidth * 0.40) *
          intensity;
      final dy = math.cos(ball.phase + angleProgress * ball.freqY * math.pi * 2) *
          ball.seedY *
          (boardHeight * 0.38) *
          intensity;
      return Offset(dx, dy);
    }

    if (t <= 0.42) {
      // Fase 1: Chaos a mezz'aria
      final ramp = (t / 0.15).clamp(0.0, 1.0);
      final altitude = Curves.easeOutQuad.transform(ramp);
      final offset = chaosOffsetAt(t, ramp);
      final pos = originalPos + offset;
      final radius = ballRadius * (1.0 + altitude * 0.12);
      return BallRenderItem(
        ball: ball,
        center: pos,
        radius: radius,
        altitude: altitude,
        opacity: 1.0,
      );
    } else if (t <= 0.65) {
      // Fase 2: Confluenza continua sul tabellone disordinato con inerzia smorzata
      final p = ((t - 0.42) / 0.23).clamp(0.0, 1.0);
      final shiftP = Curves.easeInOutSine.transform(p);
      final dampingIntensity = math.cos(p * math.pi * 0.5);
      final wobble = chaosOffsetAt(t, dampingIntensity);
      final basePos = Offset.lerp(originalPos, scrambledPos, shiftP)!;
      final pos = basePos + wobble;
      final altitude = (1.0 - shiftP) * dampingIntensity;

      return BallRenderItem(
        ball: ball,
        center: pos,
        radius: ballRadius,
        altitude: altitude,
        opacity: 1.0,
      );
    } else if (t <= 0.80) {
      // Fase 3: Pausa sul tabellone rimescolato + Flash per le estratte
      final isSelected = ball.drawnSlotIndex >= 0;
      double flashIntensity = 0.0;
      if (isSelected) {
        final p = ((t - 0.65) / 0.15).clamp(0.0, 1.0);
        flashIntensity = math.sin(p * math.pi * 2).abs();
      }

      return BallRenderItem(
        ball: ball,
        center: scrambledPos,
        radius: ballRadius,
        altitude: 0.0,
        opacity: 1.0,
        isFlashing: isSelected,
        flashIntensity: flashIntensity,
      );
    } else {
      // Fase 4: Le palline selezionate decollano e volano nei cerchi superiori
      final p = ((t - 0.80) / 0.20).clamp(0.0, 1.0);
      final smoothP = Curves.easeInOutCubic.transform(p);

      if (ball.drawnSlotIndex >= 0) {
        final target = socketPositions[ball.drawnSlotIndex];
        final arcOffset = Offset(0, -math.sin(smoothP * math.pi) * 28.0);
        final pos = Offset.lerp(scrambledPos, target, smoothP)! + arcOffset;
        final radius = lerpDouble(ballRadius, socketRadius, smoothP)!;
        final altitude = lerpDouble(1.0, 0.0, smoothP)!;
        final flashIntensity = (1.0 - smoothP) * 0.7;

        return BallRenderItem(
          ball: ball,
          center: pos,
          radius: radius,
          altitude: altitude,
          opacity: 1.0,
          isFlashing: flashIntensity > 0.1,
          flashIntensity: flashIntensity,
        );
      } else {
        // Le non estratte rimangono nel tabellone rimescolato
        return BallRenderItem(
          ball: ball,
          center: scrambledPos,
          radius: ballRadius,
          altitude: 0.0,
          opacity: 1.0,
        );
      }
    }
  }
}
