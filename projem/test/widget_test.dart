import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projem/main.dart';

void main() {
  testWidgets('Todo Listesi Ekleme ve Silme Testi', (WidgetTester tester) async {
    // Uygulamamızı oluşturup bir frame tetikleyelim.
    await tester.pumpWidget(ProjemApp());

    // Başlangıçta herhangi bir todo öğesi olmadığını doğrulayalım.
    expect(find.byType(ListTile), findsNothing);

    // '+' butonuna tıklayıp yeni bir todo öğesi ekleyelim.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump(); // Açılır pencerenin görünmesi için bir frame daha tetikleyelim.

    // Metin alanına bir todo metni girelim.
    await tester.enterText(find.byType(TextField), 'Yeni Todo');
    await tester.tap(find.text('Ekle'));
    await tester.pump(); // Todo öğesinin listeye eklenmesi için bir frame daha tetikleyelim.

    // Yeni eklenen todo öğesinin listede olduğunu doğrulayalım.
    expect(find.text('Yeni Todo'), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);

    // Todo öğesini silmek için çöp kutusu ikonuna tıklayalım.
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump(); // Silme işleminin gerçekleşmesi için bir frame daha tetikleyelim.

    // Silinen todo öğesinin artık listede olmadığını doğrulayalım.
    expect(find.text('Yeni Todo'), findsNothing);
    expect(find.byType(ListTile), findsNothing);
  });
}
