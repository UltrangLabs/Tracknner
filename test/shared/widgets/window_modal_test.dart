import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:running/shared/theme/app_theme.dart';
import 'package:running/shared/widgets/window_modal.dart';

void main() {
  group('WindowModal', () {
    testWidgets('renders required child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: WindowModal(child: Text('Modal Content Test'))),
        ),
      );

      expect(find.text('Modal Content Test'), findsOneWidget);
    });

    test('throws AssertionError if barrierOpacity > 0.7', () {
      expect(
        () => WindowModal(barrierOpacity: 0.71, child: const SizedBox()),
        throwsAssertionError,
      );
    });

    test('throws AssertionError if barrierOpacity < 0.0', () {
      expect(
        () => WindowModal(barrierOpacity: -0.1, child: const SizedBox()),
        throwsAssertionError,
      );
    });

    testWidgets('executes custom onClose callback when tapping outside', (
      WidgetTester tester,
    ) async {
      var isClosed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WindowModal(
              onClose: () {
                isClosed = true;
              },
              child: const Text('Modal Body'),
            ),
          ),
        ),
      );

      // Tap on the backdrop (outside the center modal card)
      await tester.tapAt(const Offset(10.0, 10.0));
      await tester.pump();

      expect(isClosed, isTrue);
    });

    testWidgets('does not close when tapping inside the modal card', (
      WidgetTester tester,
    ) async {
      var isClosed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WindowModal(
              onClose: () {
                isClosed = true;
              },
              child: const Text('Modal Body'),
            ),
          ),
        ),
      );

      // Tap inside the center card
      await tester.tap(find.text('Modal Body'));
      await tester.pump();

      expect(isClosed, isFalse);
    });

    testWidgets('renders close button and triggers close when tapped', (
      WidgetTester tester,
    ) async {
      var isClosed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WindowModal(
              showCloseButton: true,
              onClose: () {
                isClosed = true;
              },
              child: const Text('Modal Body'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();

      expect(isClosed, isTrue);
    });

    testWidgets('WindowModal.show displays and closes via backdrop', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    WindowModal.show<void>(
                      context: context,
                      child: const Text('Imperative Modal Content'),
                    );
                  },
                  child: const Text('Open Modal'),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Imperative Modal Content'), findsNothing);

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Imperative Modal Content'), findsOneWidget);

      // Tap outside to close
      await tester.tapAt(const Offset(10.0, 10.0));
      await tester.pumpAndSettle();

      expect(find.text('Imperative Modal Content'), findsNothing);
    });

    testWidgets('applies default theme colors from AppTheme', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: WindowModal(child: Text('Themed Content'))),
        ),
      );

      final containerFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == quaternaryColor,
      );

      expect(containerFinder, findsOneWidget);
    });
  });
}
