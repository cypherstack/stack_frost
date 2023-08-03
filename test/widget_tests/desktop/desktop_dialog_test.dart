import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stackfrost/models/isar/stack_theme.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/widgets/desktop/desktop_dialog.dart';
import 'package:stackfrost/widgets/desktop/desktop_dialog_close_button.dart';

import '../../sample_data/theme_json.dart';

void main() {
  testWidgets("test DesktopDialog builds", (widgetTester) async {
    final key = UniqueKey();

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
        home: Material(
          child: DesktopDialog(
            key: key,
            child: const DesktopDialogCloseButton(),
          ),
        ),
      ),
    );

    expect(find.byType(DesktopDialog), findsOneWidget);
  });
}
