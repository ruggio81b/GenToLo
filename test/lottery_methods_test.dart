import 'package:flutter_test/flutter_test.dart';
import 'package:gentolo/main.dart';

void main() {
  group('GenToLo Methods Animation & Flow Tests', () {
    testWidgets('Test completo metodo Esclusione con verifica ricomposizione e Combinazione', (WidgetTester tester) async {
      await tester.pumpWidget(const GenToLoApp());
      await tester.pumpAndSettle();

      // Clicca su Esclusione
      await tester.tap(find.text('Esclusione'));
      await tester.pump();

      // Avanza il tempo per completare Esclusione (3700ms)
      await tester.pump(const Duration(milliseconds: 3700));
      await tester.pumpAndSettle();

      // Verifica che il pulsante Ordina sia ora abilitato
      expect(find.text('Ordina'), findsOneWidget);

      // Clicca su Combinazione per verificare la ricomposizione animata del tabellone
      await tester.tap(find.text('Combinazione'));
      await tester.pump();

      // Avanza per completare la fase di reset (~600ms)
      await tester.pump(const Duration(milliseconds: 650));
      await tester.pump();

      // Avanza il tempo per completare l'estrazione di Combinazione (4800ms)
      await tester.pump(const Duration(milliseconds: 4900));
      await tester.pumpAndSettle();

      // Verifica completamento estrazione
      expect(find.text('Ordina'), findsOneWidget);
    });
  });
}
