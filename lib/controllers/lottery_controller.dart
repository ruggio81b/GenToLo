import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:gentolo/models/extraction_settings.dart';
import 'package:gentolo/models/lottery_ball.dart';
import 'package:gentolo/services/extraction_service.dart';
import 'package:gentolo/services/settings_service.dart';

enum LotteryPhase {
  idle,
  resetting,  // Reintegro animato o espulsione palline fuori schermo
  animating,  // Moto turbolento ed estrazione
  completed,  // Estrazione terminata con le palline alloggiate nei cerchi
}

class LotteryController extends ChangeNotifier {
  final ExtractionService _service;
  final SettingsService? _settingsService;
  final TickerProvider vsync;

  late final AnimationController animationController;
  late final AnimationController sortController;
  late final AnimationController resetController;

  /// Configurazione attiva per le estrazioni (quantità, range 1..X, modalità Tombola)
  ExtractionSettings settings;

  LotteryPhase phase = LotteryPhase.idle;
  ExtractionMethod? currentMethod;
  ExtractionResult? lastResult;
  ExtractionMethod? _pendingMethod;

  /// Numeri già estratti nella sessione attiva di Tombola
  final Set<int> tombolaExtractedNumbers = {};

  bool _disposed = false;
  bool get isDisposed => _disposed;

  /// Indica se il controller sta attualmente eseguendo un'animazione di estrazione o reintegro
  bool get isBusy => animationController.isAnimating || resetController.isAnimating;

  int get drawCount => settings.drawCount;
  int get maxNumber => settings.maxNumber;
  bool get isTombolaMode => settings.isTombolaMode;

  /// Quanti numeri rimangono disponibili sul tabellone della Tombola
  int get remainingTombolaCount => math.max(0, maxNumber - tombolaExtractedNumbers.length);

  /// Indica se la partita di Tombola è terminata per esaurimento numeri sul tabellone
  bool get isTombolaFinished => isTombolaMode && remainingTombolaCount <= 0;

  /// Le 90 palline del tabellone
  final List<LotteryBall> balls = [];

  /// Numeri estratti per la combinazione attiva
  List<int> drawnNumbers = [];

  // Ordinamento dei numeri estratti (false = ordine di estrazione, true = crescente 1-90)
  bool isSortedAscending = false;

  /// Inizializza il controller, le 90 palline e le animazioni
  LotteryController({
    required this.vsync,
    ExtractionSettings? initialSettings,
    ExtractionService? service,
    SettingsService? settingsService,
  })  : _service = service ?? ExtractionService(),
        _settingsService = settingsService,
        settings = initialSettings ?? const ExtractionSettings() {
    _initBalls();

    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 3500),
    )..addListener(notifyListeners)
     ..addStatusListener((status) {
       if (status == AnimationStatus.completed) {
         phase = LotteryPhase.completed;
         if (isTombolaMode && lastResult != null) {
           tombolaExtractedNumbers.addAll(lastResult!.drawnNumbers);
           for (final ball in balls) {
             if (lastResult!.drawnNumbers.contains(ball.number)) {
               ball.isTombolaExtracted = true;
             }
           }
         }
         notifyListeners();
       }
     });

    sortController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 600),
    )..addListener(notifyListeners);

    resetController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 600),
    )..addListener(notifyListeners);
  }

  void _initBalls() {
    final random = math.Random();
    balls.clear();
    for (int i = 0; i < 90; i++) {
      final num = i + 1;
      final signX = random.nextBool() ? 1.0 : -1.0;
      final signY = random.nextBool() ? 1.0 : -1.0;
      final seedX = signX * (0.45 + random.nextDouble() * 0.45);
      final seedY = signY * (0.45 + random.nextDouble() * 0.45);
      final freqX = 1.5 + random.nextDouble() * 2.5;
      final freqY = 1.5 + random.nextDouble() * 2.5;
      final phaseOffset = random.nextDouble() * math.pi * 2;

      balls.add(
        LotteryBall(
          number: num,
          originalGridIndex: i,
          seedX: seedX,
          seedY: seedY,
          freqX: freqX,
          freqY: freqY,
          phase: phaseOffset,
        ),
      );
    }
  }

  /// Aggiorna le impostazioni di estrazione (quantità, range 1..X, modalità Tombola)
  Future<void>? updateSettings(ExtractionSettings newSettings) {
    if (isBusy) return null;
    if (settings == newSettings) return null;

    final wasTombola = settings.isTombolaMode;
    final maxChanged = settings.maxNumber != newSettings.maxNumber;
    final modeChanged = wasTombola != newSettings.isTombolaMode;
    settings = newSettings;
    final saveFuture = _settingsService?.saveSettings(newSettings);

    // Se cambia la modalità (Tombola <-> Normale) o cambia il range, reintegriamo il tabellone
    if (modeChanged || maxChanged) {
      tombolaExtractedNumbers.clear();
      _resetToBoard();
    } else if (phase == LotteryPhase.completed && drawnNumbers.length != settings.drawCount) {
      _resetToBoard();
    }
    notifyListeners();
    return saveFuture;
  }

  /// Reimposta la sessione di Tombola reintegrando tutti i numeri sul tabellone
  void resetTombolaSession() {
    if (isBusy) return;
    tombolaExtractedNumbers.clear();
    _resetToBoard();
    notifyListeners();
  }

  /// Avvia l'estrazione gestendo fluidamente il reintegro o l'espulsione Tombola
  void startExtraction(ExtractionMethod method) {
    if (isBusy) return;
    if (isTombolaMode && isTombolaFinished) return;

    // Modalità Tombola: le palline già nei cerchi scendono verso il tabellone oscurandosi
    if (isTombolaMode) {
      if (phase == LotteryPhase.idle && drawnNumbers.isEmpty) {
        _launchExtraction(method);
        return;
      }

      _pendingMethod = method;
      phase = LotteryPhase.resetting;

      resetController.duration = const Duration(milliseconds: 750);
      resetController.forward(from: 0.0).then((_) {
        if (_disposed) return;
        for (final ball in balls) {
          ball.isFlyingOffScreen = false;
          if (drawnNumbers.contains(ball.number)) {
            ball.drawnSlotIndex = -1;
            ball.state = BallState.normal;
          }
        }
        drawnNumbers.clear();
        final nextMethod = _pendingMethod;
        _pendingMethod = null;
        if (nextMethod != null && !_disposed) {
          _launchExtraction(nextMethod);
        }
      });
      notifyListeners();
      return;
    }

    // Modalità Standard: se il tabellone è a riposo, estrai subito
    if (phase == LotteryPhase.idle && drawnNumbers.isEmpty) {
      _launchExtraction(method);
      return;
    }

    // Altrimenti: esegui prima il reintegro fluido sul tabellone
    _pendingMethod = method;
    phase = LotteryPhase.resetting;
    resetController.duration = const Duration(milliseconds: 600);
    resetController.forward(from: 0.0).then((_) {
      if (_disposed) return;
      _resetToBoard();
      final nextMethod = _pendingMethod;
      _pendingMethod = null;
      if (nextMethod != null && !_disposed) {
        _launchExtraction(nextMethod);
      }
    });
    notifyListeners();
  }

  void _launchExtraction(ExtractionMethod method) {
    currentMethod = method;
    phase = LotteryPhase.animating;
    isSortedAscending = false;
    sortController.value = 0.0;

    // Durata personalizzata per il metodo Combinazione (4,8s) ed Esclusione (3,8s)
    if (method == ExtractionMethod.combinazione) {
      animationController.duration = const Duration(milliseconds: 4800);
    } else if (method == ExtractionMethod.esclusione) {
      animationController.duration = const Duration(milliseconds: 3800);
    } else {
      animationController.duration = const Duration(milliseconds: 3600);
    }

    final effectiveDrawCount = isTombolaMode
        ? math.min(drawCount, remainingTombolaCount)
        : drawCount;

    if (effectiveDrawCount <= 0) return;

    // Esegui l'estrazione con i parametri aggiornati (quantità, range 1..X, esclusi per Tombola)
    final result = _service.extract(
      method,
      drawCount: effectiveDrawCount,
      maxNumber: maxNumber,
      excludedNumbers: isTombolaMode ? tombolaExtractedNumbers : const {},
    );
    lastResult = result;
    drawnNumbers = List.from(result.drawnNumbers);

    // In modalità Tombola, le posizioni libere sul tabellone escludono quelle già occupate
    // dalle palline estratte nei turni precedenti.
    final availableGridIndices = isTombolaMode
        ? [
            for (int i = 0; i < maxNumber; i++)
              if (!tombolaExtractedNumbers.contains(i + 1)) i
          ]
        : List<int>.generate(maxNumber, (i) => i);

    // Mappa le proprietà delle palline per l'animazione e rigenera turbolenza casuale
    final random = math.Random();
    for (final ball in balls) {
      // Ignora le palline oltre il range massimo X
      if (ball.number > maxNumber) continue;

      ball.randomizeTurbulence(random);
      final drawnIndex = result.drawnNumbers.indexOf(ball.number);
      ball.drawnSlotIndex = drawnIndex;

      if (method == ExtractionMethod.esclusione) {
        ball.currentBoardIndex = ball.originalGridIndex;
        ball.state = result.discardedNumbers.contains(ball.number)
            ? BallState.discarded
            : (drawnIndex >= 0 ? BallState.drawn : BallState.normal);
      } else if (method == ExtractionMethod.combinazione) {
        final permIndex = result.boardPermutation.indexOf(ball.number);
        ball.currentBoardIndex = permIndex >= 0
            ? availableGridIndices[permIndex]
            : ball.originalGridIndex;
        ball.state = drawnIndex >= 0 ? BallState.drawn : BallState.normal;
      } else {
        ball.currentBoardIndex = ball.originalGridIndex;
        ball.state = drawnIndex >= 0 ? BallState.drawn : BallState.normal;
      }
    }

    animationController.forward(from: 0.0);
    notifyListeners();
  }

  void _resetToBoard() {
    animationController.stop();
    sortController.stop();
    resetController.stop();
    sortController.value = 0.0;
    resetController.value = 0.0;
    isSortedAscending = false;
    drawnNumbers.clear();

    for (int i = 0; i < balls.length; i++) {
      balls[i].reset(balls[i].originalGridIndex);
      if (isTombolaMode && tombolaExtractedNumbers.contains(balls[i].number)) {
        balls[i].isTombolaExtracted = true;
      }
    }
    phase = LotteryPhase.idle;
  }

  /// Alterna l'ordinamento della combinazione estratta nei cerchi in alto (estrazione vs crescente)
  void toggleSortOrder() {
    if (drawnNumbers.isEmpty || isBusy) return;

    isSortedAscending = !isSortedAscending;
    if (isSortedAscending) {
      sortController.forward();
    } else {
      sortController.reverse();
    }
    notifyListeners();
  }

  /// Restituisce i numeri estratti formattati come testo separato da spazio
  String get formattedDrawnNumbers {
    if (drawnNumbers.isEmpty) return '';
    final list = isSortedAscending
        ? (List<int>.from(drawnNumbers)..sort())
        : drawnNumbers;
    return list.join(' ');
  }

  /// Restituisce l'indice di destinazione nei cerchi per una pallina estratta
  int getTargetSlotForDrawnBall(int drawnNumber, bool sorted) {
    if (!sorted) {
      return drawnNumbers.indexOf(drawnNumber);
    } else {
      final sortedList = List<int>.from(drawnNumbers)..sort();
      return sortedList.indexOf(drawnNumber);
    }
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    animationController.dispose();
    sortController.dispose();
    resetController.dispose();
    super.dispose();
  }
}
