// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:dairysathi/app.dart';
// import 'package:dairysathi/core/other_services/network_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();

//   testWidgets('Login Flow Test (Phone + Password)', (tester) async {
//     final NetworkService networkService = NetworkService();
//     // Start app
//     await tester.pumpWidget(DairySathi(networkService: networkService));
//     await tester.pumpAndSettle();

//     // 🟢 Enter phone
//     await tester.enterText(find.byKey(Key('phoneField')), '9876543210');

//     // 🟢 Enter password
//     await tester.enterText(find.byKey(Key('passwordField')), '123456');

//     // 🟢 Tap login
//     await tester.tap(find.byKey(Key('loginBtn')));
//     await tester.pumpAndSettle();

//     // 🟢 Verify navigation to dashboard
//     expect(find.byKey(Key('dashboardText')), findsOneWidget);
//   });
// }
