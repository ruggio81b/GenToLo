/// Impostazioni di estrazione configurabili dall'utente in GenToLo
class ExtractionSettings {
  /// Quanti numeri estrarre contemporaneamente (da 1 a 10, default 5)
  final int drawCount;

  /// Limite superiore del range di numeri estraibili da 1 a X (drawCount <= maxNumber <= 90, default 90)
  final int maxNumber;

  /// Indica se è attiva la modalità Tombola (estrazioni progressive senza reinserimento)
  final bool isTombolaMode;

  const ExtractionSettings({
    this.drawCount = 5,
    this.maxNumber = 90,
    this.isTombolaMode = false,
  })  : assert(drawCount >= 1 && drawCount <= 10, 'drawCount deve essere compreso tra 1 e 10'),
        assert(maxNumber >= drawCount && maxNumber <= 90, 'maxNumber deve essere compreso tra drawCount e 90');

  ExtractionSettings copyWith({
    int? drawCount,
    int? maxNumber,
    bool? isTombolaMode,
  }) {
    final newDrawCount = (drawCount ?? this.drawCount).clamp(1, 10);
    var newMax = (maxNumber ?? this.maxNumber).clamp(newDrawCount, 90);
    return ExtractionSettings(
      drawCount: newDrawCount,
      maxNumber: newMax,
      isTombolaMode: isTombolaMode ?? this.isTombolaMode,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExtractionSettings &&
          runtimeType == other.runtimeType &&
          drawCount == other.drawCount &&
          maxNumber == other.maxNumber &&
          isTombolaMode == other.isTombolaMode;

  @override
  int get hashCode => Object.hash(drawCount, maxNumber, isTombolaMode);
}
