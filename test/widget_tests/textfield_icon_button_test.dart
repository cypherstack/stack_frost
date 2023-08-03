import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stackfrost/models/isar/stack_theme.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/widgets/icon_widgets/x_icon.dart';
import 'package:stackfrost/widgets/textfield_icon_button.dart';

import '../sample_data/theme_json.dart';

void main() {
  testWidgets("test", (widgetTester) async {
    await widgetTester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: [
            StackColors.fromStackColorTheme(
              StackTheme.fromJson(
                json: lightThemeJsonMap,
              ),
            ),
          ],
        ),
        home: const Material(
          child: TextFieldIconButton(child: XIcon()),
        ),
      ),
    );

    expect(find.byType(TextFieldIconButton), findsOneWidget);
    expect(find.byType(XIcon), findsOneWidget);
  });
}
