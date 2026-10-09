import 'dart:ui';
import 'package:gentolo/models/lottery_ball.dart';

/// Rappresenta i parametri calcolati per il rendering di una singola pallina sulla scena 3D
class BallRenderItem {
  final LotteryBall ball;
  final Offset center;
  final double radius;
  final double altitude;
  final double opacity;
  final bool isFlashing;
  final double flashIntensity;

  const BallRenderItem({
    required this.ball,
    required this.center,
    required this.radius,
    required this.altitude,
    required this.opacity,
    this.isFlashing = false,
    this.flashIntensity = 0.0,
  });
}
