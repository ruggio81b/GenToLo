import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gentolo/controllers/lottery_controller.dart';
import 'package:gentolo/l10n/app_localizations.dart';
import 'package:gentolo/models/extraction_settings.dart';
import 'package:gentolo/services/extraction_service.dart';
import 'package:gentolo/services/settings_service.dart';
import 'package:gentolo/widgets/control_panel.dart';

void main() {
  group('ExtractionSettings Model Tests', () {
    test('Valori di default corretti (5 numeri e range 90)', () {
      const settings = ExtractionSettings();
      expect(settings.drawCount, equals(5));
      expect(settings.maxNumber, equals(90));
      expect(settings.isTombolaMode, isFalse);
    });

    test('copyWith rispetta i vincoli di range (maxNumber >= drawCount)', () {
      const settings = ExtractionSettings();
      final updated = settings.copyWith(drawCount: 8, maxNumber: 5);
      expect(updated.drawCount, equals(8));
      expect(updated.maxNumber, equals(8)); // agganciato a drawCount
    });

    test('copyWith aggiorna modalità Tombola', () {
      const settings = ExtractionSettings();
      final updated = settings.copyWith(isTombolaMode: true);
      expect(updated.isTombolaMode, isTrue);
    });
  });

  group('ExtractionService con Range Personalizzato (1..X) e Tombola Pool', () {
    late ExtractionService service;

    setUp(() {
      service = ExtractionService();
    });

    test('Estrazione con maxNumber ridotto (es. 1..20)', () {
      for (int i = 0; i < 20; i++) {
        final result = service.extractCasuale(drawCount: 5, maxNumber: 20);
        expect(result.drawnNumbers.length, equals(5));
        expect(result.drawnNumbers.toSet().length, equals(5));
        for (final num in result.drawnNumbers) {
          expect(num, inInclusiveRange(1, 20));
        }
      }
    });

    test('Estrazione Tombola con esclusione dei numeri già estratti', () {
      final excluded = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
      final result = service.extractCasuale(
        drawCount: 5,
        maxNumber: 15,
        excludedNumbers: excluded,
      );
      // I numeri disponibili sono solo 11, 12, 13, 14, 15
      expect(result.drawnNumbers.length, equals(5));
      expect(result.drawnNumbers.toSet(), equals({11, 12, 13, 14, 15}));
      expect(result.drawnNumbers.toSet().intersection(excluded), isEmpty);
    });

    test('Solleva eccezione quando il pool residuo è inferiore a drawCount', () {
      final excluded = {1, 2, 3, 4, 5, 6, 7, 8};
      // Disponibili solo 9 e 10 (2 numeri), richiesti 3
      expect(
        () => service.extractCasuale(
          drawCount: 3,
          maxNumber: 10,
          excludedNumbers: excluded,
        ),
        throwsStateError,
      );
    });

    test('Metodo Esclusione rispetta il pool ridotto', () {
      final excluded = {1, 2, 3};
      final result = service.extractEsclusione(
        drawCount: 4,
        maxNumber: 10,
        excludedNumbers: excluded,
      );
      // Totale disponibili: 7 numeri. Estratti 4, scartati 3.
      expect(result.drawnNumbers.length, equals(4));
      expect(result.discardedNumbers.length, equals(3));
      expect(result.drawnNumbers.toSet().intersection(excluded), isEmpty);
      expect(result.discardedNumbers.intersection(excluded), isEmpty);
    });

    test('Metodo Combinazione rispetta il pool ridotto', () {
      final excluded = {1, 2, 3};
      final result = service.extractCombinazione(
        drawCount: 3,
        maxNumber: 6,
        excludedNumbers: excluded,
      );
      expect(result.drawnNumbers.length, equals(3));
      expect(result.boardPermutation.length, equals(3));
      expect(result.drawnNumbers.toSet().intersection(excluded), isEmpty);
    });
  });

  group('LotteryController Tombola Reset Timing', () {
    testWidgets('startExtraction imposta resetController duration a 750ms in Tombola e 600ms in Standard', (WidgetTester tester) async {
      // Standard controller
      final controllerStd = LotteryController(vsync: tester);
      controllerStd.phase = LotteryPhase.completed;
      controllerStd.drawnNumbers = [10, 20, 30, 40, 50, 60];
      controllerStd.startExtraction(ExtractionMethod.casuale);
      expect(controllerStd.resetController.duration, equals(const Duration(milliseconds: 600)));
      controllerStd.dispose();

      // Tombola controller
      final controllerTombola = LotteryController(vsync: tester)
        ..updateSettings(const ExtractionSettings(isTombolaMode: true));
      controllerTombola.phase = LotteryPhase.completed;
      controllerTombola.drawnNumbers = [1, 2, 3, 4, 5, 6];
      controllerTombola.startExtraction(ExtractionMethod.casuale);
      expect(controllerTombola.resetController.duration, equals(const Duration(milliseconds: 750)));
      controllerTombola.dispose();
    });

    testWidgets('Passaggio da modalità normale a Tombola resetta sempre il tabellone', (WidgetTester tester) async {
      final controller = LotteryController(vsync: tester);
      // Simula estrazione completata in modalità normale
      controller.phase = LotteryPhase.completed;
      controller.drawnNumbers = [7, 14, 21, 28, 35];
      for (final ball in controller.balls) {
        if (controller.drawnNumbers.contains(ball.number)) {
          ball.drawnSlotIndex = controller.drawnNumbers.indexOf(ball.number);
        }
      }

      expect(controller.drawnNumbers, isNotEmpty);
      expect(controller.phase, equals(LotteryPhase.completed));

      // Passaggio a modalità Tombola
      controller.updateSettings(const ExtractionSettings(isTombolaMode: true));

      expect(controller.isTombolaMode, isTrue);
      expect(controller.phase, equals(LotteryPhase.idle));
      expect(controller.drawnNumbers, isEmpty);
      expect(controller.tombolaExtractedNumbers, isEmpty);
      expect(controller.balls.every((b) => !b.isDrawn && !b.isTombolaExtracted), isTrue);
      controller.dispose();
    });

    testWidgets('Passaggio da modalità Tombola a normale resetta sempre il tabellone', (WidgetTester tester) async {
      final controller = LotteryController(
        vsync: tester,
        initialSettings: const ExtractionSettings(isTombolaMode: true),
      );
      // Simula estrazioni completate in Tombola
      controller.phase = LotteryPhase.completed;
      controller.drawnNumbers = [3, 11, 22];
      controller.tombolaExtractedNumbers.addAll([3, 11, 22, 45, 90]);
      for (final ball in controller.balls) {
        if (controller.tombolaExtractedNumbers.contains(ball.number)) {
          ball.isTombolaExtracted = true;
        }
      }

      expect(controller.drawnNumbers, isNotEmpty);
      expect(controller.tombolaExtractedNumbers, isNotEmpty);

      // Passaggio a modalità normale
      controller.updateSettings(const ExtractionSettings(isTombolaMode: false));

      expect(controller.isTombolaMode, isFalse);
      expect(controller.phase, equals(LotteryPhase.idle));
      expect(controller.drawnNumbers, isEmpty);
      expect(controller.tombolaExtractedNumbers, isEmpty);
      expect(controller.balls.every((b) => !b.isDrawn && !b.isTombolaExtracted), isTrue);
      controller.dispose();
    });
  });

  group('SettingsService & Persistence Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('loadSettings restituisce valori di default (drawCount: 5, maxNumber: 90) se vuoto', () async {
      const service = SettingsService();
      final settings = await service.loadSettings();
      expect(settings.drawCount, equals(5));
      expect(settings.maxNumber, equals(90));
      expect(settings.isTombolaMode, isFalse);
    });

    test('saveSettings e successiva lettura ripropongono le scelte dell\'utente', () async {
      const service = SettingsService();
      const updated = ExtractionSettings(drawCount: 8, maxNumber: 75);
      await service.saveSettings(updated);

      final reloaded = await service.loadSettings();
      expect(reloaded.drawCount, equals(8));
      expect(reloaded.maxNumber, equals(75));
    });

    testWidgets('LotteryController salva automaticamente i settings quando aggiornati', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'settings_draw_count': 3, 'settings_max_number': 50});
      const service = SettingsService();
      final initial = await service.loadSettings();

      final controller = LotteryController(
        vsync: tester,
        initialSettings: initial,
        settingsService: service,
      );

      expect(controller.drawCount, equals(3));
      expect(controller.maxNumber, equals(50));

      // L'utente aggiorna dal dialog a 7 numeri
      await controller.updateSettings(const ExtractionSettings(drawCount: 7, maxNumber: 80));

      final persisted = await service.loadSettings();
      expect(persisted.drawCount, equals(7));
      expect(persisted.maxNumber, equals(80));

      controller.dispose();
    });

    testWidgets('ControlPanel mantiene altezza invariata prima e dopo prima estrazione Tombola', (WidgetTester tester) async {
      final controller = LotteryController(
        vsync: tester,
        initialSettings: const ExtractionSettings(isTombolaMode: true),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ControlPanel(controller: controller),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final initialSize = tester.getSize(find.byType(ControlPanel));

      // Simuliamo il completamento della prima estrazione con numeri estratti
      controller.phase = LotteryPhase.completed;
      controller.lastResult = ExtractionResult(
        method: ExtractionMethod.casuale,
        drawnNumbers: const [1, 2, 3, 4, 5],
      );
      controller.tombolaExtractedNumbers.addAll([1, 2, 3, 4, 5]);
      controller.notifyListeners();
      await tester.pumpAndSettle();

      final afterSize = tester.getSize(find.byType(ControlPanel));

      expect(afterSize.height, equals(initialSize.height));
      expect(afterSize.width, equals(initialSize.width));

      controller.dispose();
    });
  });

  group('Tombola Completion & Remaining Count Tests', () {
    testWidgets('Non segnala tombola completata se rimangono numeri da estrarre (< drawCount)', (WidgetTester tester) async {
      final controller = LotteryController(
        vsync: tester,
        initialSettings: const ExtractionSettings(drawCount: 5, maxNumber: 10, isTombolaMode: true),
      );

      // Simula che 8 numeri siano già stati estratti (ne rimangono 2, mentre drawCount = 5)
      controller.tombolaExtractedNumbers.addAll([1, 2, 3, 4, 5, 6, 7, 8]);
      expect(controller.remainingTombolaCount, equals(2));
      // Fondamentale: non deve essere considerata finita perché 2 numeri sono ancora da estrarre!
      expect(controller.isTombolaFinished, isFalse);

      // Verifica nel ControlPanel: deve indicare 2 numeri nel sacchetto, non "Tombola completata!"
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: ControlPanel(controller: controller)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tombola: 2 numeri nel sacchetto'), findsOneWidget);
      expect(find.text('Tombola completata!'), findsNothing);

      controller.dispose();
    });

    testWidgets('Estrazione finale in Tombola estrae tutti i numeri residui quando rimangono meno di drawCount', (WidgetTester tester) async {
      final controller = LotteryController(
        vsync: tester,
        initialSettings: const ExtractionSettings(drawCount: 5, maxNumber: 7, isTombolaMode: true),
      );

      // 5 numeri estratti su 7: rimangono 2 numeri nel sacchetto
      controller.tombolaExtractedNumbers.addAll([1, 2, 3, 4, 5]);
      expect(controller.remainingTombolaCount, equals(2));
      expect(controller.isTombolaFinished, isFalse);

      // Avvia l'estrazione: deve estrarre i 2 rimanenti (min(5, 2) = 2) senza lanciare eccezioni
      controller.startExtraction(ExtractionMethod.casuale);
      tester.binding.scheduleFrame();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 3700));
      await tester.pumpAndSettle();

      expect(controller.drawnNumbers.length, equals(2));
      expect(controller.tombolaExtractedNumbers.length, equals(7));
      expect(controller.remainingTombolaCount, equals(0));
      expect(controller.isTombolaFinished, isTrue);

      controller.dispose();
    });

    testWidgets('Singular/Plural format corretto per 1 numero rimasto nel sacchetto', (WidgetTester tester) async {
      final controller = LotteryController(
        vsync: tester,
        initialSettings: const ExtractionSettings(drawCount: 4, maxNumber: 5, isTombolaMode: true),
      );

      // Rimane 1 solo numero
      controller.tombolaExtractedNumbers.addAll([1, 2, 3, 4]);
      expect(controller.remainingTombolaCount, equals(1));
      expect(controller.isTombolaFinished, isFalse);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: ControlPanel(controller: controller)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tombola: 1 numero nel sacchetto'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('Partita con X numeri iniziali poi cambiati: estrazione completa di tutti i residui fino a 0', (WidgetTester tester) async {
      // Scenario utente: parte con 5 numeri su max 12
      final controller = LotteryController(
        vsync: tester,
        initialSettings: const ExtractionSettings(drawCount: 5, maxNumber: 12, isTombolaMode: true),
      );

      // Prima estrazione (5 numeri)
      controller.startExtraction(ExtractionMethod.casuale);
      tester.binding.scheduleFrame();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 3700));
      await tester.pumpAndSettle();

      expect(controller.tombolaExtractedNumbers.length, equals(5));
      expect(controller.remainingTombolaCount, equals(7));
      expect(controller.isTombolaFinished, isFalse);

      // L'utente cambia le impostazioni a 4 numeri
      controller.updateSettings(const ExtractionSettings(drawCount: 4, maxNumber: 12, isTombolaMode: true));
      expect(controller.drawCount, equals(4));

      // Seconda estrazione (4 numeri)
      controller.startExtraction(ExtractionMethod.casuale);
      tester.binding.scheduleFrame();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750)); // reset tombola timing
      await tester.pump(const Duration(milliseconds: 3700)); // extraction animation
      await tester.pumpAndSettle();

      expect(controller.tombolaExtractedNumbers.length, equals(9));
      expect(controller.remainingTombolaCount, equals(3));
      // Rimangono 3 numeri (< drawCount 4): NON deve dire che la tombola è completata!
      expect(controller.isTombolaFinished, isFalse);

      // Terza ed ultima estrazione: estrae i 3 rimanenti
      controller.startExtraction(ExtractionMethod.casuale);
      tester.binding.scheduleFrame();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750));
      await tester.pump(const Duration(milliseconds: 3700));
      await tester.pumpAndSettle();

      expect(controller.drawnNumbers.length, equals(3));
      expect(controller.tombolaExtractedNumbers.length, equals(12));
      expect(controller.remainingTombolaCount, equals(0));
      expect(controller.isTombolaFinished, isTrue);

      controller.dispose();
    });

    testWidgets('Metodo Combinazione in Tombola non posiziona mai le palline su caselle già estratte', (WidgetTester tester) async {
      final controller = LotteryController(
        vsync: tester,
        initialSettings: const ExtractionSettings(drawCount: 5, maxNumber: 20, isTombolaMode: true),
      );

      // Simuliamo che i primi 5 numeri siano già stati estratti (occupano gli indici griglia 0, 1, 2, 3, 4)
      final previouslyExtracted = {1, 2, 3, 4, 5};
      final occupiedGridIndices = {0, 1, 2, 3, 4};
      controller.tombolaExtractedNumbers.addAll(previouslyExtracted);
      for (final ball in controller.balls) {
        if (previouslyExtracted.contains(ball.number)) {
          ball.isTombolaExtracted = true;
        }
      }

      // Eseguiamo l'estrazione con metodo Combinazione
      controller.startExtraction(ExtractionMethod.combinazione);
      tester.binding.scheduleFrame();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 4900));
      await tester.pumpAndSettle();

      // Tutte le palline ancora attive (non estratte in precedenza)
      final activeBalls = controller.balls.where(
        (b) => b.number <= 20 && !previouslyExtracted.contains(b.number),
      ).toList();

      final activeBoardIndices = activeBalls.map((b) => b.currentBoardIndex).toSet();

      // Nessuna pallina attiva deve essere posizionata su una casella già estratta!
      expect(
        activeBoardIndices.intersection(occupiedGridIndices),
        isEmpty,
        reason: 'Rilevata sovrapposizione tra palline rimescolate e caselle già estratte!',
      );

      // Ogni pallina attiva deve occupare una casella distinta tra quelle libere
      expect(activeBoardIndices.length, equals(activeBalls.length));
      for (final idx in activeBoardIndices) {
        expect(idx, inInclusiveRange(5, 19));
      }

      // Le palline già estratte in precedenza devono conservare il loro originalGridIndex
      for (final num in previouslyExtracted) {
        final extractedBall = controller.balls.firstWhere((b) => b.number == num);
        expect(extractedBall.currentBoardIndex, equals(extractedBall.originalGridIndex));
      }

      controller.dispose();
    });
  });
}
