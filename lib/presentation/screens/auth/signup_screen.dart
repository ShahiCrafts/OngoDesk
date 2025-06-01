import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ongo_desk/blocs/signup/signup_bloc.dart';
import 'package:ongo_desk/blocs/signup/signup_event.dart';
import 'package:ongo_desk/blocs/signup/signup_state.dart';
import 'package:ongo_desk/presentation/widgets/custom_text_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupBloc(),
      child: SignupForm(),
    );
  }
}

class SignupForm extends StatelessWidget {

  SignupForm({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const orangeColor = Color(0xFFFF5C00);
    final bloc = context.read<SignupBloc>();

    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state.emailFormStatus == EmailFormStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? 'Login Failed!'))
          );
          bloc.add(FormReset());
        } else if (state.emailFormStatus == EmailFormStatus.success) {
          Navigator.pushNamed(context, '/signup');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: BlocBuilder<SignupBloc, SignupState>(
              builder: (context, state) {
                return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Logo
                    Image.asset(
                      'assets/images/logo.png',
                      width: size.width * 0.24,
                      fit: BoxFit.contain,
                    ),
                
                    const SizedBox(height: 4),
                
                    /// App Title
                    const Text(
                      '.OnGo Desk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                
                    const SizedBox(height: 12),
                
                    /// Sub Text
                    const Text(
                      'Create an account to get started',
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                
                    const SizedBox(height: 32),
                
                    /// Email Field Label
                    CustomTextField(
                      label: 'Email Address',
                      hintText: 'example@gmail.com',
                      onChanged: (value) => bloc.add(RegisterEmailChanged(value)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }
                
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        
                        return null;
                      },
                    ),
                
                    const SizedBox(height: 16),
                
                    /// Checkbox + Policy Agreement Text
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Checkbox(
                            value: state.value,
                            activeColor: orangeColor,
                            onChanged: (value) {
                              bloc.add(PrivacyPolicyChecked(value ?? false));
                            },
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'By continuing, you agree to our User Agreement and acknowledge that you understand the policy.',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                
                    const SizedBox(height: 34),
                
                    /// Continue with Email Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {}
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: orangeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        child: const Text(
                          'Continue with Email',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                
                    const SizedBox(height: 20),
                
                    /// Divider with "or sign-up with"
                    Row(
                      children: const [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'or sign-up with',
                            style: TextStyle(fontSize: 14, color: Colors.black45),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                
                    const SizedBox(height: 20),
                
                    /// Google Signup Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Image.asset('assets/icons/google.png', height: 20),
                        label: const Text(
                          'Sign-up with Google',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          side: const BorderSide(color: Colors.black12),
                        ),
                      ),
                    ),
                
                    const SizedBox(height: 32),
                
                    /// Already have an account?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              color: orangeColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
              },
            ),
          ),
        ),
      ),
    );
  }
}
