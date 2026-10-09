import 'dart:math' as math;

/// Stato visivo e comportamentale della singola pallina durante le animazioni.
enum BallState {
  normal,      // A riposo sul tabellone
  flying,      // In volo caotico
  discarded,   // Scartata (vola fuori schermo nel metodo Esclusione)
  flashing,    // Flash verde (evidenziata nel metodo Combinazione)
  drawn,       // Estratta e alloggiata nei cerchi in alto
}

/// Rappresenta una delle 90 palline da gioco.
class LotteryBall {
  final int number;

  // Posizione originaria sulla griglia (0-9 col, 0-8 row, totale 0..89)
  final int originalGridIndex;

  // Posizione attuale/rimescolata sul tabellone (per il metodo Combinazione)
  int currentBoardIndex;

  // Posizione dell'indice estratto se appartiene alla combinazione, altrimenti -1
  int drawnSlotIndex;

  // Parametri casuali per generare una turbolenza organica e unica
  double seedX;
  double seedY;
  double freqX;
  double freqY;
  double phase;

  BallState state;

  /// Indica se la pallina è già stata estratta in turni precedenti nella sessione Tombola
  bool isTombolaExtracted;

  /// Indica se la pallina sta volando via fuori schermo all'inizio del nuovo turno di Tombola
  bool isFlyingOffScreen;

  LotteryBall({
    required this.number,
    required this.originalGridIndex,
    this.currentBoardIndex = -1,
    this.drawnSlotIndex = -1,
    required this.seedX,
    required this.seedY,
    required this.freqX,
    required this.freqY,
    required this.phase,
    this.state = BallState.normal,
    this.isTombolaExtracted = false,
    this.isFlyingOffScreen = false,
  })  : assert(number >= 1 && number <= 90, 'number deve essere compreso tra 1 e 90'),
        assert(originalGridIndex >= 0 && originalGridIndex < 90, 'originalGridIndex deve essere tra 0 e 89'),
        assert(currentBoardIndex == -1 || (currentBoardIndex >= 0 && currentBoardIndex < 90), 'currentBoardIndex non valido'),
        assert(drawnSlotIndex == -1 || drawnSlotIndex >= 0, 'drawnSlotIndex non valido'),
        assert(seedX.isFinite && seedY.isFinite, 'seedX e seedY devono essere valori finiti'),
        assert(freqX.isFinite && freqX > 0 && freqY.isFinite && freqY > 0, 'freqX e freqY devono essere finite e positive'),
        assert(phase.isFinite, 'phase deve essere un valore finito') {
    if (currentBoardIndex == -1) {
      currentBoardIndex = originalGridIndex;
    }
  }

  bool get isDrawn => drawnSlotIndex >= 0;

  void reset(int gridIndex) {
    assert(gridIndex >= 0 && gridIndex < 90, 'gridIndex deve essere compreso tra 0 e 89');
    currentBoardIndex = gridIndex;
    drawnSlotIndex = -1;
    state = BallState.normal;
    isTombolaExtracted = false;
    isFlyingOffScreen = false;
  }

  /// Ricalcola parametri casuali di turbolenza con ampiezza minima garantita (nessuna pallina immobile)
  void randomizeTurbulence([math.Random? random]) {
    final rnd = random ?? math.Random();
    final signX = rnd.nextBool() ? 1.0 : -1.0;
    final signY = rnd.nextBool() ? 1.0 : -1.0;
    seedX = signX * (0.45 + rnd.nextDouble() * 0.45);
    seedY = signY * (0.45 + rnd.nextDouble() * 0.45);
    freqX = 1.5 + rnd.nextDouble() * 2.5;
    freqY = 1.5 + rnd.nextDouble() * 2.5;
    phase = rnd.nextDouble() * math.pi * 2;
  }
}
