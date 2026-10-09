import 'package:flutter_test/flutter_test.dart';
import 'package:gentolo/main.dart';

void main() {
  testWidgets('Smoke test di GenToLo: verifica presenza elementi chiave ed estrazione', (WidgetTester tester) async {
    await tester.pumpWidget(const GenToLoApp());
    await tester.pumpAndSettle();

    // Verifica titolo applicazione e indicatore iniziale
    expect(find.text('GenToLo'), findsOneWidget);
    expect(find.text('5 ESTRATTI • 1-90'), findsOneWidget);

    // Verifica presenza dei 3 pulsanti di estrazione
    expect(find.text('Casuale'), findsOneWidget);
    expect(find.text('Esclusione'), findsOneWidget);
    expect(find.text('Combinazione'), findsOneWidget);

    // Verifica presenza del pulsante Info
    expect(find.text('Info'), findsOneWidget);

    // Test apertura dialogo Info e verifica intestazione/autore
    await tester.tap(find.text('Info'));
    await tester.pumpAndSettle();
    expect(find.text('Informazioni'), findsOneWidget);
    expect(find.text('GenToLo Versione 1.0.0'), findsOneWidget);
    expect(find.text('Creato da Fabrizio Ruggiano'), findsOneWidget);
    expect(find.text('I 3 METODI DI ESTRAZIONE'), findsOneWidget);

    // Chiusura del dialogo Info tramite pulsante Chiudi
    await tester.tap(find.byTooltip('Chiudi'));
    await tester.pumpAndSettle();

    // Test tocco su Casuale
    await tester.tap(find.text('Casuale'));
    await tester.pump();

    // Avanza il tempo per completare l'animazione (3600ms)
    await tester.pump(const Duration(milliseconds: 3600));
    await tester.pumpAndSettle();

    // Verifica che l'estrazione sia completata e sia possibile ordinare
    expect(find.text('Ordina'), findsOneWidget);

    // Test tocco sul pulsante Ordina
    await tester.tap(find.text('Ordina'));
    await tester.pumpAndSettle();

    expect(find.text('1 ➔ 90'), findsOneWidget);
  });

  testWidgets('Test apertura finestrella impostazioni, info Tombola ed estrazione', (WidgetTester tester) async {
    await tester.pumpWidget(const GenToLoApp());
    await tester.pumpAndSettle();

    // Tocco sul badge impostazioni GenToLo
    await tester.tap(find.text('GenToLo'));
    await tester.pumpAndSettle();

    // Verifica apertura del dialog di configurazione
    expect(find.text('Impostazioni Estrazione'), findsOneWidget);
    expect(find.text('Numeri da estrarre:'), findsOneWidget);
    expect(find.text('Estrai numeri da 1 a:'), findsOneWidget);
    expect(find.text('Modalità Tombola'), findsOneWidget);

    // Test apertura spiegazione modale della modalità Tombola
    await tester.tap(find.byTooltip('Come funziona la modalità Tombola?'));
    await tester.pumpAndSettle();

    expect(find.text('Ho capito'), findsOneWidget);
    await tester.tap(find.text('Ho capito'));
    await tester.pumpAndSettle();

    // Applica le impostazioni
    await tester.tap(find.text('Applica'));
    await tester.pumpAndSettle();

    // Dialog chiuso, app pronta
    expect(find.text('Impostazioni Estrazione'), findsNothing);

    // Esegui estrazione Casuale
    await tester.tap(find.text('Casuale'));
    await tester.pump();

    await tester.pump(const Duration(milliseconds: 3600));
    await tester.pumpAndSettle();

    expect(find.text('Ordina'), findsOneWidget);
  });
}
