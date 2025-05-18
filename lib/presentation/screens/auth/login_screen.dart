import 'package:flutter/material.dart';
import 'package:ongo_desk/presentation/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  static const Color orangeColor = Color(0xFFFF5C00);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
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
                  hintText: 'example@gmail.com',
                  controller: emailAddressController,
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
                  controller: passwordController,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  togglePasswordVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
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
                          value: rememberMe,
                          activeColor: orangeColor,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value ?? false;
                            });
                          },
                        ),
                        const Text(
                          "Remember me",
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(fontSize: 15, color: Colors.red),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

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
                        style: TextStyle(fontSize: 14, color: Colors.black45),
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
          ),
        ),
      ),
    );
  }
}
