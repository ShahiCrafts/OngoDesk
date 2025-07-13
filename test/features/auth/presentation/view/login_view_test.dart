import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ongo_desk/features/auth/presentation/view/login_view.dart';
import 'package:ongo_desk/features/auth/presentation/view/widgets/custom_text_field.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

class MockLoginViewModel extends Mock implements LoginViewModel {}

class FakeLoginEvent extends Fake implements LoginEvent {}

class FakeLoginState extends Fake implements LoginState {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockLoginViewModel mockViewModel;

  setUpAll(() {
    registerFallbackValue(FakeLoginEvent());
    registerFallbackValue(FakeLoginState());
  });

  setUp(() {
    mockViewModel = MockLoginViewModel();
    when(() => mockViewModel.state).thenReturn(const LoginState());
    when(
      () => mockViewModel.stream,
    ).thenAnswer((_) => const Stream<LoginState>.empty());
  });

  Widget createTestWidget({NavigatorObserver? observer}) {
    return MaterialApp(
      navigatorObservers: observer != null ? [observer] : [],
      routes: {
        '/signup': (_) => const Scaffold(body: Text('Signup Page')),
        '/dashboard': (_) => const Scaffold(body: Text('Dashboard')),
      },
      home: BlocProvider<LoginViewModel>.value(
        value: mockViewModel,
        child: LoginView(),
      ),
    );
  }

  Future<void> pumpLoginView(WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();
  }

  group('LoginView Widget Tests', () {
    testWidgets('Should show Welcome Back text', (tester) async {
      await pumpLoginView(tester);
      expect(find.text('Welcome Back!'), findsOneWidget);
    });

    testWidgets('Should show logo and subtitle text', (tester) async {
      await pumpLoginView(tester);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName ==
                  'assets/images/logo_temp.png',
        ),
        findsOneWidget,
      );
      expect(find.text("Log in to your .OnGo Desk account."), findsOneWidget);
    });

    testWidgets('Should find Google login button by key', (tester) async {
      await pumpLoginView(tester);
      expect(find.byKey(const ValueKey('google_login_button')), findsOneWidget);
    });

    testWidgets('Should handle login failure state', (tester) async {
      when(() => mockViewModel.state).thenReturn(
        const LoginState(
          formStatus: FormStatus.failure,
          message: "Invalid credentials",
        ),
      );
      when(() => mockViewModel.stream).thenAnswer(
        (_) => Stream.value(
          const LoginState(
            formStatus: FormStatus.failure,
            message: "Invalid credentials",
          ),
        ),
      );

      await tester.pumpWidget(createTestWidget());
      await tester.pump(); // ensure listener gets the stream

      // Here you can also expect to show a snackbar or error UI if implemented.
    });

    testWidgets('Should display and tap on Forgot Password', (tester) async {
      await pumpLoginView(tester);

      // Find the text directly
      final forgotPasswordFinder = find.text('Forgot Password?');

      // Check if it appears
      expect(forgotPasswordFinder, findsOneWidget);

      // Tap it
      await tester.tap(forgotPasswordFinder);
      await tester.pump();
    });

    testWidgets('Should tap Google login button', (tester) async {
      await pumpLoginView(tester);

      final googleButton = find.byKey(const ValueKey('google_login_button'));
      expect(googleButton, findsOneWidget);

      // Scroll it into view if necessary
      await tester.ensureVisible(googleButton);

      // Now tap
      await tester.tap(googleButton);
      await tester.pump();
    });

    testWidgets('Should dispatch TogglePasswordVisibility event on icon tap', (
      tester,
    ) async {
      await pumpLoginView(tester);
      final passwordField = find.byType(CustomTextField).at(1);
      final toggleIcon = find.descendant(
        of: passwordField,
        matching: find.byType(IconButton),
      );
      await tester.tap(toggleIcon);
      verify(() => mockViewModel.add(TogglePasswordVisibility())).called(1);
    });

    testWidgets('Should toggle Remember Me checkbox and dispatch event', (
      tester,
    ) async {
      await pumpLoginView(tester);
      final checkbox = find.byType(Checkbox);
      await tester.tap(checkbox);
      await tester.pump();
      verify(() => mockViewModel.add(const RememberMeToggled(true))).called(1);
    });

    testWidgets('Should show CircularProgressIndicator when submitting', (
      tester,
    ) async {
      when(
        () => mockViewModel.state,
      ).thenReturn(const LoginState(formStatus: FormStatus.submitting));
      when(
        () => mockViewModel.stream,
      ).thenAnswer((_) => const Stream<LoginState>.empty());

      await tester.pumpWidget(createTestWidget()); // Use simple pump
      await tester.pump(); // One frame to reflect UI changes

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should not submit when form is invalid', (tester) async {
      await pumpLoginView(tester);
      final loginButton = find.widgetWithText(
        ElevatedButton,
        'Login with email',
      );
      await tester.tap(loginButton);
      await tester.pump();
      verifyNever(() => mockViewModel.add(any()));
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Should allow typing in email and password fields', (
      tester,
    ) async {
      await pumpLoginView(tester);
      final emailField = find.byType(CustomTextField).at(0);
      final passwordField = find.byType(CustomTextField).at(1);

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');

      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('Should dispatch LoginSubmitted on valid form', (tester) async {
      when(() => mockViewModel.state).thenReturn(
        const LoginState(email: 'test@example.com', password: 'password123'),
      );
      await pumpLoginView(tester);

      await tester.enterText(
        find.byType(CustomTextField).at(0),
        'test@example.com',
      );
      await tester.enterText(find.byType(CustomTextField).at(1), 'password123');

      final loginButton = find.widgetWithText(
        ElevatedButton,
        'Login with email',
      );
      await tester.tap(loginButton);
      await tester.pump();

      verify(() => mockViewModel.add(any())).called(greaterThanOrEqualTo(1));
    });

    testWidgets('Should show footer with Sign Up prompt', (tester) async {
      await pumpLoginView(tester);
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('Should navigate to signup screen on Sign Up tap', (
      tester,
    ) async {
      await pumpLoginView(tester);
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();
      expect(find.text('Signup Page'), findsOneWidget);
    });

    testWidgets('Should navigate to dashboard on successful login', (
      tester,
    ) async {
      final mockObserver = MockNavigatorObserver();

      when(() => mockViewModel.state).thenReturn(
        const LoginState(
          formStatus: FormStatus.success,
          message: "Login Successful!",
        ),
      );
      when(() => mockViewModel.stream).thenAnswer(
        (_) => Stream.value(
          const LoginState(
            formStatus: FormStatus.success,
            message: "Login Successful!",
          ),
        ),
      );

      await tester.pumpWidget(createTestWidget(observer: mockObserver));
      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}
