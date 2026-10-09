import 'dart:math';

/// I tre metodi di estrazione ideati dall'autore
enum ExtractionMethod {
  casuale,      // Estrazione diretta di N numeri senza ripetizione
  esclusione,   // Estrazione di numeri scartati; gli N rimanenti formano la combinazione
  combinazione, // Permutazione dei numeri del tabellone; estrazione di N indici e selezione corrispondente
}

/// Risultato dettagliato di un'estrazione con tutti i dati utili all'animazione
class ExtractionResult {
  final ExtractionMethod method;
  
  // La combinazione finale estratta nell'ordine di sorteggio
  final List<int> drawnNumbers;

  // Lista di tutti i numeri scartati (90 - drawCount)
  final Set<int> discardedNumbers;

  // Ordine delle 90 posizioni del tabellone (popolata per il metodo Combinazione)
  final List<int> boardPermutation;

  // Gli indici (0..89) scelti per il metodo Combinazione
  final List<int> chosenIndices;

  ExtractionResult({
    required this.method,
    required this.drawnNumbers,
    this.discardedNumbers = const {},
    this.boardPermutation = const [],
    this.chosenIndices = const [],
  });
}

class ExtractionService {
  final Random _random;

  /// Generatore crittografico CSPRNG (Random.secure) fornito dalla piattaforma
  ExtractionService([Random? random]) : _random = random ?? Random.secure();

  void _validatePoolAndDrawCount(int poolLength, int drawCount) {
    if (drawCount < 1 || drawCount > 90) {
      throw RangeError.range(
        drawCount,
        1,
        90,
        'drawCount',
        'Il numero di elementi da estrarre deve essere compreso tra 1 e 90.',
      );
    }
    if (poolLength < drawCount) {
      throw StateError(
        'Pool insufficiente: disponibili $poolLength numeri, richiesti $drawCount.',
      );
    }
  }

  List<int> _buildPool(int maxNumber, Set<int> excludedNumbers) {
    final effectiveMax = maxNumber.clamp(1, 90);
    return List<int>.generate(effectiveMax, (i) => i + 1)
        .where((n) => !excludedNumbers.contains(n))
        .toList();
  }

  /// Metodo 1: Casuale
  /// Scelta casuale di [drawCount] numeri tra 1 e [maxNumber] senza ripetizione,
  /// escludendo eventuali [excludedNumbers] (usati in modalità Tombola).
  ExtractionResult extractCasuale({
    int drawCount = 6,
    int maxNumber = 90,
    Set<int> excludedNumbers = const {},
  }) {
    final pool = _buildPool(maxNumber, excludedNumbers);
    _validatePoolAndDrawCount(pool.length, drawCount);
    pool.shuffle(_random);
    final drawn = pool.take(drawCount).toList();

    return ExtractionResult(
      method: ExtractionMethod.casuale,
      drawnNumbers: drawn,
    );
  }

  /// Metodo 2: Esclusione
  /// Scelta casuale di (pool.length - [drawCount]) numeri scartati senza ripetizione.
  /// Visualizzazione dei rimanenti [drawCount] non scartati ("i superstiti").
  ExtractionResult extractEsclusione({
    int drawCount = 6,
    int maxNumber = 90,
    Set<int> excludedNumbers = const {},
  }) {
    final pool = _buildPool(maxNumber, excludedNumbers);
    _validatePoolAndDrawCount(pool.length, drawCount);
    pool.shuffle(_random);
    final discardCount = pool.length - drawCount;
    final discarded = pool.take(discardCount).toSet();
    final drawn = pool.skip(discardCount).take(drawCount).toList();

    return ExtractionResult(
      method: ExtractionMethod.esclusione,
      drawnNumbers: drawn,
      discardedNumbers: discarded,
    );
  }

  /// Metodo 3: Combinazione
  /// Permutazione casuale completa dei numeri disponibili nel pool.
  /// Successiva scelta casuale di [drawCount] indici distinti.
  /// I numeri estratti sono quelli posizionati negli indici scelti.
  ExtractionResult extractCombinazione({
    int drawCount = 6,
    int maxNumber = 90,
    Set<int> excludedNumbers = const {},
  }) {
    final pool = _buildPool(maxNumber, excludedNumbers);
    _validatePoolAndDrawCount(pool.length, drawCount);
    final permutation = List<int>.from(pool)..shuffle(_random);

    final indices = List<int>.generate(pool.length, (i) => i);
    indices.shuffle(_random);
    final chosenIndices = indices.take(drawCount).toList();

    final drawn = chosenIndices.map((idx) => permutation[idx]).toList();

    return ExtractionResult(
      method: ExtractionMethod.combinazione,
      drawnNumbers: drawn,
      boardPermutation: permutation,
      chosenIndices: chosenIndices,
    );
  }

  /// Esegue l'estrazione in base al metodo, al range e ai numeri già estratti
  ExtractionResult extract(
    ExtractionMethod method, {
    int drawCount = 6,
    int maxNumber = 90,
    Set<int> excludedNumbers = const {},
  }) {
    switch (method) {
      case ExtractionMethod.casuale:
        return extractCasuale(
          drawCount: drawCount,
          maxNumber: maxNumber,
          excludedNumbers: excludedNumbers,
        );
      case ExtractionMethod.esclusione:
        return extractEsclusione(
          drawCount: drawCount,
          maxNumber: maxNumber,
          excludedNumbers: excludedNumbers,
        );
      case ExtractionMethod.combinazione:
        return extractCombinazione(
          drawCount: drawCount,
          maxNumber: maxNumber,
          excludedNumbers: excludedNumbers,
        );
    }
  }
}
