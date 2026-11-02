import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';
import 'package:myffsc/core/widgets/app_text_field.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          home: Scaffold(
            body: child,
          ),
        );
      },
    );
  }

  group('AppTextField', () {
    testWidgets('renders hint text and label correctly', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const AppTextField(
            label: 'Nom complet',
            hintText: 'Ex: Georges Byona',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nom complet'), findsOneWidget);
      expect(find.text('Ex: Georges Byona'), findsOneWidget);
    });

    testWidgets('validates input correctly in a Form', (tester) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();

      await tester.pumpWidget(
        buildTestableWidget(
          Form(
            key: formKey,
            child: AppTextField(
              controller: controller,
              validator: (val) =>
                  (val == null || val.isEmpty) ? 'Champ requis' : null,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(find.text('Champ requis'), findsOneWidget);
    });

    testWidgets('unfocuses when tapping outside', (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        buildTestableWidget(
          Column(
            children: [
              AppTextField(
                focusNode: focusNode,
                hintText: 'Input',
              ),
              const SizedBox(height: 50),
              const Text('Outside Area'),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Focus the text field
      await tester.tap(find.byType(AppTextField));
      await tester.pumpAndSettle();
      expect(focusNode.hasFocus, isTrue);

      // Tap outside
      await tester.tap(find.text('Outside Area'));
      await tester.pumpAndSettle();
      expect(focusNode.hasFocus, isFalse);
    });
  });
}
