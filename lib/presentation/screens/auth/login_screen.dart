import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ongo_desk/blocs/login/login_bloc.dart';
import 'package:ongo_desk/blocs/login/login_event.dart';
import 'package:ongo_desk/blocs/login/login_state.dart';
import 'package:ongo_desk/presentation/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => LoginBloc(), child: LoginForm());
  }
}

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final _formKey = GlobalKey<FormState>();
  static const Color orangeColor = Color(0xFFFF5C00);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = context.read<LoginBloc>();

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
    print(state.email);
    print(state.password);
    print(state.rememberMe);
    print(state.formStatus);
    print(state.message);

    if (state.formStatus == FormStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message ?? 'Login failed')),
      );

      // Reset form status after showing the error
      bloc.add(ResetFormStatus());
    }

    if (state.formStatus == FormStatus.success) {
      // Navigate to dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');

      // Reset form status after success
      bloc.add(ResetFormStatus());
    }
  },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: size.width * 0.24,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              ".OnGo Desk",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      CustomTextField(
                        label: 'Email Address',
                        onChanged:
                            (email) => bloc.add(LoginEmailChanged(email)),
                        hintText: 'example@gmail.com',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }

                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      CustomTextField(
                        label: "Password",
                        hintText: "**********",
                        isPassword: true,
                        onChanged:
                            (password) =>
                                bloc.add(LoginPasswordChanged(password)),
                        obscureText: state.obscurePassword,
                        togglePasswordVisibility: () {
                          bloc.add(TogglePasswordVisibility());
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 6),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: state.rememberMe,
                                activeColor: orangeColor,
                                onChanged: (value) {
                                  bloc.add(RememberMeToggled(value ?? false));
                                },
                              ),
                              const Text(
                                "Remember me",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Forgot Password?",
                            style: TextStyle(fontSize: 15, color: Colors.red),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              bloc.add(
                                LoginSubmitted(state.email, state.password),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: orangeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child:
                              state.formStatus == FormStatus.submitting
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text(
                                    'Login with Email',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: const [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'or sign-in with',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: Image.asset(
                            'assets/icons/google.png',
                            height: 20,
                          ),
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

                      const SizedBox(height: 82),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: const Text(
                              "Sign-up",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: orangeColor,
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
