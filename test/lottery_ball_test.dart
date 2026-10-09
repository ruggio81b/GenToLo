import 'package:flutter_test/flutter_test.dart';
import 'package:gentolo/models/lottery_ball.dart';

void main() {
  group('LotteryBall Model Tests', () {
    test('Costruzione con valori validi e fallback automatico di currentBoardIndex', () {
      final ball = LotteryBall(
        number: 42,
        originalGridIndex: 41,
        seedX: 0.5,
        seedY: -0.2,
        freqX: 2.0,
        freqY: 2.5,
        phase: 1.0,
      );

      expect(ball.number, equals(42));
      expect(ball.originalGridIndex, equals(41));
      expect(ball.currentBoardIndex, equals(41));
      expect(ball.drawnSlotIndex, equals(-1));
      expect(ball.state, equals(BallState.normal));
      expect(ball.isDrawn, isFalse);
    });

    test('isDrawn riflette drawnSlotIndex', () {
      final ball = LotteryBall(
        number: 7,
        originalGridIndex: 6,
        seedX: 0.1,
        seedY: 0.2,
        freqX: 1.5,
        freqY: 1.8,
        phase: 0.5,
      );

      expect(ball.isDrawn, isFalse);
      ball.drawnSlotIndex = 0;
      expect(ball.isDrawn, isTrue);
      ball.drawnSlotIndex = 5;
      expect(ball.isDrawn, isTrue);
    });

    test('reset ripristina state, drawnSlotIndex e assegna gridIndex', () {
      final ball = LotteryBall(
        number: 90,
        originalGridIndex: 89,
        seedX: 0.0,
        seedY: 0.0,
        freqX: 2.0,
        freqY: 2.0,
        phase: 0.0,
      );

      ball.currentBoardIndex = 12;
      ball.drawnSlotIndex = 2;
      ball.state = BallState.drawn;

      ball.reset(89);

      expect(ball.currentBoardIndex, equals(89));
      expect(ball.drawnSlotIndex, equals(-1));
      expect(ball.state, equals(BallState.normal));
      expect(ball.isDrawn, isFalse);
    });

    test('randomizeTurbulence aggiorna i parametri con valori finiti e validi', () {
      final ball = LotteryBall(
        number: 1,
        originalGridIndex: 0,
        seedX: 0.1,
        seedY: 0.1,
        freqX: 2.0,
        freqY: 2.0,
        phase: 0.0,
      );

      ball.randomizeTurbulence();

      expect(ball.seedX.isFinite, isTrue);
      expect(ball.seedY.isFinite, isTrue);
      expect(ball.freqX > 0, isTrue);
      expect(ball.freqY > 0, isTrue);
      expect(ball.phase.isFinite, isTrue);
    });

    test('Asserzioni falliscono per valori non validi in debug/test', () {
      expect(
        () => LotteryBall(
          number: 0,
          originalGridIndex: 0,
          seedX: 0, seedY: 0, freqX: 1, freqY: 1, phase: 0,
        ),
        throwsAssertionError,
      );

      expect(
        () => LotteryBall(
          number: 91,
          originalGridIndex: 0,
          seedX: 0, seedY: 0, freqX: 1, freqY: 1, phase: 0,
        ),
        throwsAssertionError,
      );

      expect(
        () => LotteryBall(
          number: 1,
          originalGridIndex: -1,
          seedX: 0, seedY: 0, freqX: 1, freqY: 1, phase: 0,
        ),
        throwsAssertionError,
      );

      expect(
        () => LotteryBall(
          number: 1,
          originalGridIndex: 90,
          seedX: 0, seedY: 0, freqX: 1, freqY: 1, phase: 0,
        ),
        throwsAssertionError,
      );

      expect(
        () => LotteryBall(
          number: 1,
          originalGridIndex: 0,
          seedX: 0, seedY: 0, freqX: 0, freqY: 1, phase: 0,
        ),
        throwsAssertionError,
      );

      final validBall = LotteryBall(
        number: 1,
        originalGridIndex: 0,
        seedX: 0, seedY: 0, freqX: 1, freqY: 1, phase: 0,
      );
      expect(() => validBall.reset(-1), throwsAssertionError);
      expect(() => validBall.reset(90), throwsAssertionError);
    });
  });
}
