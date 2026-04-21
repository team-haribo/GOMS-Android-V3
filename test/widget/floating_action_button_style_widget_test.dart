import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/widgets/buttons/gradient_floating_action_button.dart';
import 'package:goms/core/widgets/buttons/qr_button.dart';
import 'package:goms/features/outing/ui/widgets/user_manage_button.dart';

void main() {
  testWidgets('GradientFloatingActionButton applies gradient and shadow spec', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GradientFloatingActionButton(
            baseColor: AppColors.mainColor,
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );

    final decoratedBox = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
    final decoration = decoratedBox.decoration as BoxDecoration;
    final shadow = decoration.boxShadow!.single;

    expect(decoration.shape, BoxShape.circle);
    expect(decoration.gradient, isA<LinearGradient>());
    expect(shadow.offset, const Offset(0, 8.1));
    expect(shadow.blurRadius, 13);
    expect(shadow.spreadRadius, 0);
    expect(shadow.color, Colors.black.withValues(alpha: 0.8));
  });

  testWidgets(
      'QRButton and UserManageButton use gradient floating button shell', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                QRButton(type: RoleEnum.user),
                UserManageButton(),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.byType(GradientFloatingActionButton), findsNWidgets(2));
  });
}
