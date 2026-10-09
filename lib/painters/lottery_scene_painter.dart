import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gentolo/controllers/lottery_controller.dart';
import 'package:gentolo/painters/ball_3d_painter.dart';
import 'package:gentolo/painters/ball_render_item.dart';
import 'package:gentolo/painters/trajectory_calculator.dart';
import 'package:gentolo/services/extraction_service.dart';
import 'package:gentolo/theme/app_theme.dart';

/// Painter principale per il tabellone, gli alloggiamenti superiori e le sfere 3D
class LotteryScenePainter extends CustomPainter {
  final LotteryController controller;

  LotteryScenePainter({required this.controller}) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // 1. Calcolo Geometria
    const theme = AppTheme.defaultTheme;
    final socketCount = controller.drawCount;

    const topMargin = 16.0;
    const horizontalPadding = 16.0;
    final availableWidth = size.width - 2 * horizontalPadding;

    // Regola geometrica adattiva:
    // Da 1 a 5 numeri: dimensione fissa identica a quella che avrebbero con 5 cerchi
    // Da 6 a 10 numeri: dimensione scalata proporzionalmente per ospitare tutti gli alloggiamenti
    final effectiveCols = math.max(5, socketCount);
    final maxSocketDiameter = math.min(
      52.0,
      (availableWidth / effectiveCols) - 6.0,
    );
    final socketRadius = maxSocketDiameter / 2;
    final socketY = topMargin + socketRadius + 2.0;

    final List<Offset> socketPositions = [];
    const gap = 6.0;
    final totalSocketsWidth = socketCount * maxSocketDiameter + (socketCount - 1) * gap;
    final startX = (size.width - totalSocketsWidth) / 2 + socketRadius;
    final stepX = maxSocketDiameter + gap;

    for (int k = 0; k < socketCount; k++) {
      final cx = startX + stepX * k;
      socketPositions.add(Offset(cx, socketY));
    }

    // Tabellone 10 colonne x 9 righe (le dimensioni restano fisse anche se maxNumber < 90)
    const boardTopGap = 16.0;
    final boardTop = socketY + socketRadius + boardTopGap;
    final boardBottom = size.height - 12.0;
    final maxBoardWidth = math.min(size.width - 16.0, 520.0);
    final boardLeft = (size.width - maxBoardWidth) / 2;
    final boardWidth = maxBoardWidth;
    final boardHeight = math.max(10.0, boardBottom - boardTop);

    final cellWidth = boardWidth / 10;
    final cellHeight = boardHeight / 9;
    final ballRadius = math.min(cellWidth, cellHeight) * 0.44;

    final List<Offset> gridPositions = [];
    for (int i = 0; i < 90; i++) {
      final col = i % 10;
      final row = i ~/ 10;
      final x = boardLeft + cellWidth * (col + 0.5);
      final y = boardTop + cellHeight * (row + 0.5);
      gridPositions.add(Offset(x, y));
    }

    // 2. Disegno Sfondo Tabellone
    _paintBoardBackground(
      canvas,
      Rect.fromLTWH(boardLeft, boardTop, boardWidth, boardHeight),
      theme,
    );

    // 3. Disegno degli Alloggiamenti Superiori
    for (int k = 0; k < socketCount; k++) {
      final isOccupied = controller.phase == LotteryPhase.completed &&
          k < controller.drawnNumbers.length;

      Ball3DPainter.paintSocket(
        canvas: canvas,
        center: socketPositions[k],
        radius: socketRadius,
        isHighlighted: isOccupied,
        borderColor: theme.socketBorder,
        backgroundColor: theme.socketBackground,
      );
    }

    // 4. Calcolo Posizione e Rendering delle Palline
    final List<BallRenderItem> renderItems = [];

    final t = controller.animationController.value;
    final method = controller.currentMethod ?? ExtractionMethod.casuale;

    for (final ball in controller.balls) {
      // Regola: le palline con numero > maxNumber restano nascoste senza modificare la griglia
      if (ball.number > controller.maxNumber) {
        continue;
      }

      Offset pos = gridPositions[ball.originalGridIndex];
      double radius = ballRadius;
      double altitude = 0.0;
      double opacity = 1.0;
      bool isFlashing = false;
      double flashIntensity = 0.0;

      // In modalità Tombola, pallina già estratta in turni precedenti
      final isAlreadyExtractedTombola = controller.isTombolaMode &&
          ball.isTombolaExtracted &&
          ball.drawnSlotIndex < 0;

      if (controller.phase == LotteryPhase.idle) {
        pos = gridPositions[ball.originalGridIndex];
        radius = ballRadius;
        altitude = 0.0;
        if (isAlreadyExtractedTombola) {
          opacity = 0.28;
        }
      } else if (controller.phase == LotteryPhase.completed) {
        if (ball.drawnSlotIndex >= 0) {
          final slotOriginal = controller.drawnNumbers.indexOf(ball.number);
          final sortedList = List<int>.from(controller.drawnNumbers)..sort();
          final slotSorted = sortedList.indexOf(ball.number);

          final posOriginal = socketPositions[slotOriginal];
          final posSorted = socketPositions[slotSorted];

          final sortP = Curves.easeInOutCubic.transform(
            controller.sortController.value.clamp(0.0, 1.0),
          );
          pos = Offset.lerp(posOriginal, posSorted, sortP)!;
          radius = socketRadius;
          altitude = 0.0;
        } else {
          if (isAlreadyExtractedTombola) {
            pos = gridPositions[ball.originalGridIndex];
            radius = ballRadius;
            altitude = 0.0;
            opacity = 0.28;
          } else if (method == ExtractionMethod.esclusione) {
            opacity = 0.0;
          } else if (method == ExtractionMethod.combinazione) {
            pos = gridPositions[ball.currentBoardIndex];
            radius = ballRadius;
          } else {
            pos = gridPositions[ball.originalGridIndex];
            radius = ballRadius;
            altitude = 0.0;
          }
        }
      } else if (controller.phase == LotteryPhase.resetting) {
        final resetP = Curves.easeInOutCubic.transform(
          controller.resetController.value.clamp(0.0, 1.0),
        );
        final targetPos = gridPositions[ball.originalGridIndex];

        if (ball.drawnSlotIndex >= 0) {
          final slotOriginal = controller.drawnNumbers.indexOf(ball.number);
          final sortedList = List<int>.from(controller.drawnNumbers)..sort();
          final slotSorted = sortedList.indexOf(ball.number);
          final posOriginal = socketPositions[slotOriginal];
          final posSorted = socketPositions[slotSorted];
          final sortP = controller.sortController.value.clamp(0.0, 1.0);
          final startSocketPos = Offset.lerp(posOriginal, posSorted, sortP)!;

          final arcOffset = Offset(0, -math.sin(resetP * math.pi) * 22.0);
          pos = Offset.lerp(startSocketPos, targetPos, resetP)! + arcOffset;
          radius = lerpDouble(socketRadius, ballRadius, resetP)!;
          altitude = math.sin(resetP * math.pi) * 0.7;

          if (controller.isTombolaMode) {
            // In Tombola la pallina scende nella sua casella oscurandosi gradualmente da 1.0 a 0.28
            opacity = lerpDouble(1.0, 0.28, resetP)!;
          } else {
            opacity = 1.0;
          }
        } else {
          if (isAlreadyExtractedTombola) {
            pos = targetPos;
            radius = ballRadius;
            altitude = 0.0;
            opacity = 0.28;
          } else if (method == ExtractionMethod.esclusione) {
            final boardCenter = Offset(boardLeft + boardWidth / 2, boardTop + boardHeight / 2);
            var dir = targetPos - boardCenter;
            if (dir.distance == 0) {
              dir = Offset(ball.seedX, ball.seedY);
            }
            dir = dir / dir.distance;
            final flyDistance = math.max(size.width, size.height) * 1.5;
            final offScreenPos = targetPos + dir * flyDistance;

            pos = Offset.lerp(offScreenPos, targetPos, resetP)!;
            radius = ballRadius;
            altitude = (1.0 - resetP) * 0.4;
            opacity = 1.0;
          } else if (method == ExtractionMethod.combinazione) {
            final scrambledPos = gridPositions[ball.currentBoardIndex];
            pos = Offset.lerp(scrambledPos, targetPos, resetP)!;
            radius = ballRadius;
            altitude = math.sin(resetP * math.pi) * 0.25;
            opacity = 1.0;
          } else {
            pos = targetPos;
            radius = ballRadius;
            altitude = 0.0;
            opacity = 1.0;
          }
        }
      } else if (controller.phase == LotteryPhase.animating) {
        if (isAlreadyExtractedTombola) {
          pos = gridPositions[ball.originalGridIndex];
          radius = ballRadius;
          altitude = 0.0;
          opacity = 0.28;
        } else {
          switch (method) {
            case ExtractionMethod.casuale:
              final item = TrajectoryCalculator.calculateCasuale(
                ball: ball,
                t: t,
                gridPositions: gridPositions,
                socketPositions: socketPositions,
                boardWidth: boardWidth,
                boardHeight: boardHeight,
                ballRadius: ballRadius,
                socketRadius: socketRadius,
              );
              pos = item.center;
              radius = item.radius;
              altitude = item.altitude;
              opacity = item.opacity;

            case ExtractionMethod.esclusione:
              final item = TrajectoryCalculator.calculateEsclusione(
                ball: ball,
                t: t,
                gridPositions: gridPositions,
                socketPositions: socketPositions,
                boardWidth: boardWidth,
                boardHeight: boardHeight,
                ballRadius: ballRadius,
                socketRadius: socketRadius,
                screenSize: size,
                boardCenter: Offset(boardLeft + boardWidth / 2, boardTop + boardHeight / 2),
              );
              pos = item.center;
              radius = item.radius;
              altitude = item.altitude;
              opacity = item.opacity;

            case ExtractionMethod.combinazione:
              final item = TrajectoryCalculator.calculateCombinazione(
                ball: ball,
                t: t,
                gridPositions: gridPositions,
                socketPositions: socketPositions,
                boardWidth: boardWidth,
                boardHeight: boardHeight,
                ballRadius: ballRadius,
                socketRadius: socketRadius,
              );
              pos = item.center;
              radius = item.radius;
              altitude = item.altitude;
              opacity = item.opacity;
              isFlashing = item.isFlashing;
              flashIntensity = item.flashIntensity;
          }
        }
      }

      if (opacity > 0.0) {
        final isOffScreen = pos.dx + radius < -20 ||
            pos.dx - radius > size.width + 20 ||
            pos.dy + radius < -20 ||
            pos.dy - radius > size.height + 20;

        if (!isOffScreen) {
          renderItems.add(
            BallRenderItem(
              ball: ball,
              center: pos,
              radius: radius,
              altitude: altitude,
              opacity: opacity,
              isFlashing: isFlashing,
              flashIntensity: flashIntensity,
            ),
          );
        }
      }
    }

    // 5. Ordinamento e Disegno Palline con ombreggiatura e prospettiva Z
    renderItems.sort((a, b) => a.altitude.compareTo(b.altitude));

    // Disegno sfere 3D (paintBall gestisce l'ombreggiatura a terra e la sfera zenitale in base all'altitudine)
    for (final item in renderItems) {
      Ball3DPainter.paintBall(
        canvas: canvas,
        center: item.center,
        radius: item.radius,
        number: item.ball.number,
        isFlashing: item.isFlashing,
        flashIntensity: item.flashIntensity,
        altitude: item.altitude,
        opacity: item.opacity,
      );
    }
  }

  void _paintBoardBackground(Canvas canvas, Rect boardRect, GameThemeColors theme) {
    final rrect = RRect.fromRectAndRadius(boardRect, const Radius.circular(12.0));

    final bgPaint = Paint()
      ..color = theme.boardBackground
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, bgPaint);

    final borderPaint = Paint()
      ..color = theme.boardBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawRRect(rrect, borderPaint);

    final innerBorderRect = boardRect.deflate(3.0);
    final innerRRect = RRect.fromRectAndRadius(innerBorderRect, const Radius.circular(9.0));
    final innerPaint = Paint()
      ..color = theme.boardInnerBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(innerRRect, innerPaint);
  }

  @override
  bool shouldRepaint(covariant LotteryScenePainter oldDelegate) => true;
}
