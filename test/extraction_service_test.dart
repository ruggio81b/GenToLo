import 'package:flutter_test/flutter_test.dart';
import 'package:gentolo/services/extraction_service.dart';

void main() {
  late ExtractionService service;

  setUp(() {
    service = ExtractionService();
  });

  group('ExtractionService Tests (Configurazione a 6 Numeri)', () {
    test('Metodo Casuale estrae 6 numeri unici tra 1 e 90', () {
      for (int i = 0; i < 30; i++) {
        final result = service.extractCasuale(drawCount: 6);
        expect(result.method, equals(ExtractionMethod.casuale));
        expect(result.drawnNumbers.length, equals(6));
        expect(result.drawnNumbers.toSet().length, equals(6));
        for (final num in result.drawnNumbers) {
          expect(num, inInclusiveRange(1, 90));
        }
      }
    });

    test('Metodo Esclusione scarta 84 numeri ed estrae i rimanenti 6', () {
      for (int i = 0; i < 30; i++) {
        final result = service.extractEsclusione(drawCount: 6);
        expect(result.method, equals(ExtractionMethod.esclusione));
        expect(result.drawnNumbers.length, equals(6));
        expect(result.discardedNumbers.length, equals(84));

        final allNumbers = {...result.drawnNumbers, ...result.discardedNumbers};
        expect(allNumbers.length, equals(90));
        expect(allNumbers, equals(List.generate(90, (idx) => idx + 1).toSet()));
      }
    });

    test('Metodo Combinazione crea permutazione di 90 numeri e seleziona 6 indici', () {
      for (int i = 0; i < 30; i++) {
        final result = service.extractCombinazione(drawCount: 6);
        expect(result.method, equals(ExtractionMethod.combinazione));
        expect(result.boardPermutation.length, equals(90));
        expect(result.boardPermutation.toSet().length, equals(90));

        expect(result.chosenIndices.length, equals(6));
        expect(result.chosenIndices.toSet().length, equals(6));

        expect(result.drawnNumbers.length, equals(6));
        for (int j = 0; j < 6; j++) {
          final idx = result.chosenIndices[j];
          expect(result.drawnNumbers[j], equals(result.boardPermutation[idx]));
        }
      }
    });
  });

  group('ExtractionService Tests (Configurazione a 5 Numeri)', () {
    test('Metodo Casuale estrae 5 numeri unici tra 1 e 90', () {
      for (int i = 0; i < 30; i++) {
        final result = service.extractCasuale(drawCount: 5);
        expect(result.method, equals(ExtractionMethod.casuale));
        expect(result.drawnNumbers.length, equals(5));
        expect(result.drawnNumbers.toSet().length, equals(5));
        for (final num in result.drawnNumbers) {
          expect(num, inInclusiveRange(1, 90));
        }
      }
    });

    test('Metodo Esclusione scarta 85 numeri ed estrae i rimanenti 5', () {
      for (int i = 0; i < 30; i++) {
        final result = service.extractEsclusione(drawCount: 5);
        expect(result.method, equals(ExtractionMethod.esclusione));
        expect(result.drawnNumbers.length, equals(5));
        expect(result.discardedNumbers.length, equals(85));

        final allNumbers = {...result.drawnNumbers, ...result.discardedNumbers};
        expect(allNumbers.length, equals(90));
        expect(allNumbers, equals(List.generate(90, (idx) => idx + 1).toSet()));
      }
    });

    test('Metodo Combinazione crea permutazione di 90 numeri e seleziona 5 indici', () {
      for (int i = 0; i < 30; i++) {
        final result = service.extractCombinazione(drawCount: 5);
        expect(result.method, equals(ExtractionMethod.combinazione));
        expect(result.boardPermutation.length, equals(90));
        expect(result.boardPermutation.toSet().length, equals(90));

        expect(result.chosenIndices.length, equals(5));
        expect(result.chosenIndices.toSet().length, equals(5));

        expect(result.drawnNumbers.length, equals(5));
        for (int j = 0; j < 5; j++) {
          final idx = result.chosenIndices[j];
          expect(result.drawnNumbers[j], equals(result.boardPermutation[idx]));
        }
      }
    });
  });

  group('ExtractionService Validation & Edge Cases', () {
    test('drawCount non valido solleva RangeError (0, -1, 91)', () {
      expect(() => service.extractCasuale(drawCount: 0), throwsRangeError);
      expect(() => service.extractCasuale(drawCount: -1), throwsRangeError);
      expect(() => service.extractCasuale(drawCount: 91), throwsRangeError);

      expect(() => service.extractEsclusione(drawCount: 0), throwsRangeError);
      expect(() => service.extractEsclusione(drawCount: -1), throwsRangeError);
      expect(() => service.extractEsclusione(drawCount: 91), throwsRangeError);

      expect(() => service.extractCombinazione(drawCount: 0), throwsRangeError);
      expect(() => service.extractCombinazione(drawCount: -1), throwsRangeError);
      expect(() => service.extractCombinazione(drawCount: 91), throwsRangeError);
    });

    test('Casi limite validi: drawCount = 1 (estratto singolo)', () {
      final resCasuale = service.extractCasuale(drawCount: 1);
      expect(resCasuale.drawnNumbers.length, equals(1));
      expect(resCasuale.drawnNumbers.first, inInclusiveRange(1, 90));

      final resEsclusione = service.extractEsclusione(drawCount: 1);
      expect(resEsclusione.drawnNumbers.length, equals(1));
      expect(resEsclusione.discardedNumbers.length, equals(89));

      final resCombinazione = service.extractCombinazione(drawCount: 1);
      expect(resCombinazione.drawnNumbers.length, equals(1));
      expect(resCombinazione.chosenIndices.length, equals(1));
    });

    test('Casi limite validi: drawCount = 90 (tutte le palline)', () {
      final resCasuale = service.extractCasuale(drawCount: 90);
      expect(resCasuale.drawnNumbers.length, equals(90));
      expect(resCasuale.drawnNumbers.toSet().length, equals(90));

      final resEsclusione = service.extractEsclusione(drawCount: 90);
      expect(resEsclusione.drawnNumbers.length, equals(90));
      expect(resEsclusione.discardedNumbers.isEmpty, isTrue);

      final resCombinazione = service.extractCombinazione(drawCount: 90);
      expect(resCombinazione.drawnNumbers.length, equals(90));
      expect(resCombinazione.chosenIndices.length, equals(90));
    });
  });

  group('ExtractionService Monte Carlo Statistical Distribution', () {
    test('Simulazione massiva Metodo Casuale (10.000 estrazioni, 0 duplicati, copertura uniforme)', () {
      const iterations = 10000;
      const drawCount = 6;
      final frequencies = List<int>.filled(91, 0); // 1..90

      for (int i = 0; i < iterations; i++) {
        final res = service.extractCasuale(drawCount: drawCount);
        expect(res.drawnNumbers.length, equals(drawCount));
        expect(res.drawnNumbers.toSet().length, equals(drawCount), reason: 'Rilevato duplicato!');

        for (final num in res.drawnNumbers) {
          expect(num, inInclusiveRange(1, 90));
          frequencies[num]++;
        }
      }

      // Media attesa per numero: (10000 * 6) / 90 = ~667
      for (int num = 1; num <= 90; num++) {
        expect(frequencies[num], greaterThan(450), reason: 'Numero $num estratto troppo raramente');
        expect(frequencies[num], lessThan(900), reason: 'Numero $num estratto troppo frequentemente');
      }
    });

    test('Simulazione massiva Metodo Esclusione (10.000 estrazioni, 0 duplicati, partizione esatta)', () {
      const iterations = 10000;
      const drawCount = 5;
      final frequencies = List<int>.filled(91, 0);

      for (int i = 0; i < iterations; i++) {
        final res = service.extractEsclusione(drawCount: drawCount);
        expect(res.drawnNumbers.length, equals(drawCount));
        expect(res.drawnNumbers.toSet().length, equals(drawCount));
        expect(res.discardedNumbers.length, equals(85));

        // Intersezione vuota tra estratti e scartati
        expect(res.discardedNumbers.intersection(res.drawnNumbers.toSet()).isEmpty, isTrue);

        for (final num in res.drawnNumbers) {
          frequencies[num]++;
        }
      }

      // Media attesa: (10000 * 5) / 90 = ~555
      for (int num = 1; num <= 90; num++) {
        expect(frequencies[num], greaterThan(350), reason: 'Numero $num estratto troppo raramente');
        expect(frequencies[num], lessThan(800), reason: 'Numero $num estratto troppo frequentemente');
      }
    });

    test('Simulazione massiva Metodo Combinazione (10.000 estrazioni, 0 duplicati, permutazione integra)', () {
      const iterations = 10000;
      const drawCount = 6;
      final frequencies = List<int>.filled(91, 0);

      for (int i = 0; i < iterations; i++) {
        final res = service.extractCombinazione(drawCount: drawCount);
        expect(res.drawnNumbers.length, equals(drawCount));
        expect(res.drawnNumbers.toSet().length, equals(drawCount));
        expect(res.boardPermutation.length, equals(90));
        expect(res.boardPermutation.toSet().length, equals(90));

        for (final num in res.drawnNumbers) {
          frequencies[num]++;
        }
      }

      for (int num = 1; num <= 90; num++) {
        expect(frequencies[num], greaterThan(450), reason: 'Numero $num estratto troppo raramente');
        expect(frequencies[num], lessThan(900), reason: 'Numero $num estratto troppo frequentemente');
      }
    });
  });
}
