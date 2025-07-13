import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ongo_desk/features/auth/presentation/view/widgets/custom_text_field.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/login_view_model/login_state.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final _formKey = GlobalKey<FormState>();
  static const Color orangeColor = Color(0xFFFF5C00);
  static const Color lightGreyColor = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocListener<LoginViewModel, LoginState>(
                listenWhen:
                    (previous, current) =>
                        (previous.formStatus == FormStatus.success) !=
                        (current.formStatus == FormStatus.failure),
                listener: (context, state) {
                  if (state.formStatus == FormStatus.success &&
                      state.message == "Login Successful!") {
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  }
                },
                child: SingleChildScrollView(
                    key: const ValueKey('login_scroll_view'), // <-- ADD THIS LINE

                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      _buildHeader(context),
                      const SizedBox(height: 36),
                      _buildForm(context),
                      const SizedBox(height: 30),
                      _buildSocialLogin(context),
                    ],
                  ),
                ),
              ),
            ),
            _buildFooter(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/images/logo_temp.png', width: 50),
        const SizedBox(height: 20),
        const Text(
          "Welcome Back!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Log in to your .OnGo Desk account.",
          style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    final bloc = context.read<LoginViewModel>();
    return BlocBuilder<LoginViewModel, LoginState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                bloc: bloc,
                hintText: 'johndoe@example.com',
                lightGreyColor: lightGreyColor,
                state: state,
                textLabel: 'Email Address',
                isPassword: false,
                validator: (value) {
                  if ((value ?? '').isEmpty) return 'Please enter your email';
                  return null;
                },
                onChanged: (email) => bloc.add(LoginEmailChanged(email!)),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                bloc: bloc,
                hintText: 'Enter your password',
                lightGreyColor: lightGreyColor,
                state: state,
                textLabel: 'Password',
                isPassword: true,
                validator: (value) {
                  if ((value ?? '').isEmpty)
                    return 'Please enter your password';
                  return null;
                },
                onPressed: () => bloc.add(TogglePasswordVisibility()),
                onChanged:
                    (password) => bloc.add(LoginPasswordChanged(password!)),
              ),
              const SizedBox(height: 10),
              _buildOptions(context, state),
              const SizedBox(height: 26),
              _buildLoginButton(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptions(BuildContext context, LoginState state) {
    final bloc = context.read<LoginViewModel>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: state.rememberMe,
              onChanged: (value) => bloc.add(RememberMeToggled(value ?? false)),
              activeColor: orangeColor,
              visualDensity: VisualDensity.compact,
            ),
            const Text("Remember me"),
          ],
        ),
        const Text(
          "Forgot Password?",
          style: TextStyle(color: orangeColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context, LoginState state) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed:
            state.formStatus == FormStatus.submitting
                ? null
                : () {
                  if (_formKey.currentState!.validate()) {
                    context.read<LoginViewModel>().add(
                      LoginSubmitted(state.email, state.password, context),
                    );
                  }
                },
        style: ElevatedButton.styleFrom(
          backgroundColor: orangeColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            state.formStatus == FormStatus.submitting
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : const Text(
                  "Login with email",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }

  Widget _buildSocialLogin(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'or log in with',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            key: const ValueKey('google_login_button'), //

            onPressed: () {},
            icon: Image.asset('assets/icons/google.png', height: 24),
            label: const Text(
              'Continue with Google',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: Colors.grey.shade300, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.grey.shade700),
        ),
        const SizedBox(width: 6),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerLeft,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/signup');
          },
          child: const Text(
            'Sign Up',
            style: TextStyle(color: orangeColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
