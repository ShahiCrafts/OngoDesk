import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/signup_state.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';

class EmailEntryView extends StatelessWidget {
  EmailEntryView({super.key});

  final _formKey = GlobalKey<FormState>();
  final lightGreyColor = Color(0xFFF5F5F5);
  final orangeColor = Color(0xFFFF5C00);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SignupViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: BlocListener<SignupViewModel, SignupState>(
            listenWhen: (previous, current) {
              return previous.emailFormStatus != current.emailFormStatus;
            },
            listener: (context, state) {
              if (state.emailFormStatus == EmailFormStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message ?? 'Email Submission failed!'),
                  ),
                );
              } else if (state.emailFormStatus == EmailFormStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message ?? 'Email Submission Done!'),
                  ),
                );
                Navigator.pushNamed(context, '/verify-code');
              }
            },
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        _buildHeader(bloc),
                        const SizedBox(height: 40),
                        _buildForm(bloc),
                        const SizedBox(height: 30),
                        _buildSocialSignup(bloc),
                      ],
                    ),
                  ),
                ),
                _buildFooter(bloc),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(SignupViewModel bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/images/logo_temp.png', width: 48),
        const SizedBox(height: 20),
        const Text(
          "Create your Account",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Join us to get started on your journey.",
          style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildForm(SignupViewModel bloc) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email Address",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            onChanged: (email) => bloc.add(RegisterEmailChanged(email)),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "you@example.com",
              prefixIcon: Icon(Icons.email_rounded, color: Colors.grey[500]),
              filled: true,
              fillColor: lightGreyColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildAgreementCheckbox(bloc),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: BlocBuilder<SignupViewModel, SignupState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      bloc.add(EmailSubmitEvent(state.email));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    shadowColor: orangeColor.withOpacity(0.4),
                  ),
                  child:
                      state.emailFormStatus == EmailFormStatus.submitting
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Text(
                            "Continue with email",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgreementCheckbox(SignupViewModel bloc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: BlocBuilder<SignupViewModel, SignupState>(
            builder: (context, state) {
              return Checkbox(
                value: state.privacyPolicy,
                onChanged:
                    (value) => bloc.add(PrivacyPolicyToggled(value ?? false)),
                activeColor: orangeColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: BorderSide(color: Colors.grey.shade400, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'User Agreement',
                  style: const TextStyle(
                    color: Color(0xFFFF5C00),
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          // will implement later
                        },
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: const TextStyle(
                    color: Color(0xFFFF5C00),
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer:
                      TapGestureRecognizer()
                        ..onTap = () {
                          // will implement later
                        },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialSignup(SignupViewModel bloc) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'or sign up with',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: Image.asset('assets/icons/google.png', height: 24),
            label: const Text(
              'Sign-up with Google',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: Colors.black12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(SignupViewModel bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          style: TextStyle(color: Colors.grey.shade700),
        ),
        const SizedBox(width: 6),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerLeft,
          ),
          onPressed: () {},
          child: const Text(
            'Log In',
            style: TextStyle(
              color: Color(0xFFFF5C00),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
