import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexis_app/main.dart';

void main() {
  testWidgets('exibe e pesquisa as palavras da tela inicial', (tester) async {
    await tester.pumpWidget(const LexisApp());
    expect(find.text('Meu Dicionário'), findsOneWidget);
    expect(find.text('alcova'), findsOneWidget);
    expect(find.text('barreira'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'bar');
    await tester.pump();
    expect(find.text('barreira'), findsOneWidget);
    expect(find.text('alcova'), findsNothing);
  });

  testWidgets('abre as telas da etapa 3', (tester) async {
    await tester.pumpWidget(const LexisApp());

    await tester.tap(find.byTooltip('Nova palavra'));
    await tester.pumpAndSettle();
    expect(find.text('Nova palavra'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('alcova'));
    await tester.pumpAndSettle();
    expect(find.text('Visualizar palavra'), findsOneWidget);

    await tester.tap(find.byTooltip('Editar palavra'));
    await tester.pumpAndSettle();
    expect(find.text('Editar palavra'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Configurações'));
    await tester.pumpAndSettle();
    expect(find.text('Configurações'), findsOneWidget);
  });
}
