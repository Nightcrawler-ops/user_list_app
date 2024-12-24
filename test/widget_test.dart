import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:user_list_app/user_list_screen.dart';
import 'package:user_list_app/user_provider.dart';

void main() {
  testWidgets('User list displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => UserProvider()..fetchUsers(),
        child: MaterialApp(
          home: UserListScreen(),
        ),
      ),
    );

    // Verify that the CircularProgressIndicator is displayed initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Allow the app to settle
    await tester.pumpAndSettle();

    // Verify that the error message is displayed
    expect(find.text('Failed to load users'), findsOneWidget);
  });
}
