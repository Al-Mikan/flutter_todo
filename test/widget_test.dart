// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:clear_tasks/main.dart';
import 'package:clear_tasks/repositories/genre_repository.dart';

class MockGenreRepository extends Mock implements GenreRepository {}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // GenreRepositoryのモックインスタンスを作成
    final mockGenreRepository = MockGenreRepository();

    // モックのGenreRepositoryをMyAppに渡してウィジェットを構築
    await tester.pumpWidget(MyApp(genreRepository: mockGenreRepository));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
