import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ongo_desk/features/auth/domain/usecase/auth_otp_usecase.dart';
import 'package:ongo_desk/features/auth/presentation/view/signup_view/detail_entry_view.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/detail_view_model/detail_entry_event.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/detail_view_model/detail_entry_state.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/detail_view_model/detail_entry_view_model.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/email_view_model/email_entry_state.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/email_view_model/email_entry_view_model.dart';

// ───── Mock Classes ───────────────────────────────────────────
class MockDetailEntryViewModel extends Mock implements DetailEntryViewModel {}

class MockEmailEntryViewModel extends Mock implements EmailEntryViewModel {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockSendOtpUsecase extends Mock implements SendOtpUsecase {}

class MockVerifyOtpUsecase extends Mock implements VerifyOtpUsecase {}

// Fake BuildContext to use in fallback value for SubmitDetailEntryForm
class FakeBuildContext extends Fake implements BuildContext {}

class FakeRoute extends Fake implements Route<dynamic> {}


void main() {
  late MockDetailEntryViewModel mockDetailViewModel;
  late MockEmailEntryViewModel mockEmailViewModel;
  late MockSendOtpUsecase mockSendOtp;
  late MockVerifyOtpUsecase mockVerifyOtp;
  late FakeBuildContext fakeContext;

  setUp(() {
    mockDetailViewModel = MockDetailEntryViewModel();
    mockEmailViewModel = MockEmailEntryViewModel();
    mockSendOtp = MockSendOtpUsecase();
    mockVerifyOtp = MockVerifyOtpUsecase();
    fakeContext = FakeBuildContext();
        registerFallbackValue(FakeRoute());


    registerFallbackValue(
      SubmitDetailEntryForm(
        context: fakeContext,
        fullName: '',
        email: '',
        password: '',
      ),
    );
    registerFallbackValue(TogglePasswordVisibility());
    registerFallbackValue(const DetailEntryState());
  });

  Widget createTestApp({
    NavigatorObserver? observer,
    DetailEntryState? overrideState,
  }) {
    final detailState = overrideState ?? const DetailEntryState();

    when(() => mockDetailViewModel.state).thenReturn(detailState);
    when(
      () => mockDetailViewModel.stream,
    ).thenAnswer((_) => const Stream<DetailEntryState>.empty());

    when(
      () => mockEmailViewModel.state,
    ).thenReturn(const EmailEntryState(email: 'test@email.com'));
    when(
      () => mockEmailViewModel.stream,
    ).thenAnswer((_) => const Stream<EmailEntryState>.empty());

    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<DetailEntryViewModel>.value(value: mockDetailViewModel),
          BlocProvider<EmailEntryViewModel>.value(value: mockEmailViewModel),
        ],
        child: DetailEntryView(),
      ),
      navigatorObservers: observer != null ? [observer] : [],
    );
  }

  group('DetailEntryView Widget Tests', () {
    testWidgets('Should show header and intro texts', (tester) async {
      await tester.pumpWidget(createTestApp());

      expect(find.text('Almost There!'), findsOneWidget);
      expect(find.textContaining('Just a few more details'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('Should validate empty and short full name', (tester) async {
      await tester.pumpWidget(createTestApp());

      await tester.tap(find.text('Complete Setup'));
      await tester.pump();
      expect(find.text('Please enter your full name'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).first, 'A');
      await tester.tap(find.text('Complete Setup'));
      await tester.pump();
      expect(find.text('Name must be at least 2 characters'), findsOneWidget);
    });

    testWidgets('Should validate empty and short password', (tester) async {
      await tester.pumpWidget(createTestApp());

      await tester.enterText(find.byType(TextFormField).first, 'John Doe');
      await tester.tap(find.text('Complete Setup'));
      await tester.pump();
      expect(find.text('Please enter a password'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).last, 'short');
      await tester.tap(find.text('Complete Setup'));
      await tester.pump();
      expect(
        find.text('Password must be at least 8 characters'),
        findsOneWidget,
      );
    });

    testWidgets('Should dispatch TogglePasswordVisibility', (tester) async {
      // obscurePassword: true means password is hidden, so icon is visibility_off
      const state = DetailEntryState(obscurePassword: true);
      await tester.pumpWidget(createTestApp(overrideState: state));

      // The icon shown when password is hidden is visibility_off, NOT visibility
      final icon = find.byIcon(Icons.visibility_off);
      expect(icon, findsOneWidget);

      await tester.tap(icon);
      await tester.pump();

      verify(
        () => mockDetailViewModel.add(TogglePasswordVisibility()),
      ).called(1);
    });

    testWidgets('Should show password requirement checklist', (tester) async {
      await tester.pumpWidget(createTestApp());

      await tester.enterText(find.byType(TextFormField).last, 'Pass123');
      await tester.pump();

      expect(find.text('At least 8 characters'), findsOneWidget);
      expect(find.text('One uppercase letter'), findsOneWidget);
      expect(find.text('One lowercase letter'), findsOneWidget);
      expect(find.text('One number'), findsOneWidget);
    });

    testWidgets('Should show loader and disable button when submitting', (
      tester,
    ) async {
      const submitting = DetailEntryState(
        status: DetailFormStatus.isSubmitting,
      );
      await tester.pumpWidget(createTestApp(overrideState: submitting));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final ElevatedButton button = tester.widget(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('Should dispatch SubmitDetailEntryForm when valid', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp());

      await tester.enterText(find.byType(TextFormField).first, 'John Doe');
      await tester.enterText(find.byType(TextFormField).last, 'Password123');

      await tester.tap(find.text('Complete Setup'));
      await tester.pump();

      verify(
        () => mockDetailViewModel.add(any(that: isA<SubmitDetailEntryForm>())),
      ).called(1);
    });

    testWidgets('Should pop on back button tap', (tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(createTestApp(observer: mockObserver));

      final backIcon = find.byIcon(LucideIcons.arrowLeft);
      expect(backIcon, findsOneWidget);

      await tester.tap(backIcon);
      await tester.pumpAndSettle();

      verify(() => mockObserver.didPop(any(), any())).called(1);
    });
  });
}
