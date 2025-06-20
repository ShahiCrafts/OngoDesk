import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ongo_desk/features/auth/presentation/auth/view_model/signup_view_model/signup_event.dart';
import 'package:ongo_desk/features/auth/presentation/auth/view_model/signup_view_model/signup_state.dart';
import 'package:ongo_desk/features/auth/presentation/auth/view_model/signup_view_model/signup_view_model.dart';

class PasswordEntryView extends StatelessWidget {
  const PasswordEntryView({super.key});

  static const Color orangeColor = Color(0xFFFF5C00);
  static const Color lightGreyColor = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return BlocConsumer<SignupViewModel, SignupState>(
      listenWhen: (previous, current) {
        return previous.emailFormStatus != current.emailFormStatus &&
            (current.emailFormStatus == EmailFormStatus.failure ||
                current.emailFormStatus == EmailFormStatus.success);
      },
      listener: (context, state) {
        if (state.emailFormStatus == EmailFormStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Registration Successful!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, '/login');
        } else if (state.emailFormStatus == EmailFormStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Registration Failed!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isSubmitting =
            state.emailFormStatus == EmailFormStatus.submitting;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'Setup Password',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 1,
            shadowColor: Colors.black.withOpacity(0.1),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    const Icon(
                      LucideIcons.keyRound,
                      color: orangeColor,
                      size: 64,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Set Your Password",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Your password must be at least 8 characters long and secure.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      "Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      obscureText: state.obscurePassword,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please enter a password';
                        if (value.length < 8)
                          return 'Password must be at least 8 characters';
                        return null;
                      },
                      decoration: _buildInputDecoration(
                        context: context,
                        hintText: 'Enter your password',
                        icon: LucideIcons.lock,
                        isObscured: state.obscurePassword,
                        onVisibilityToggle:
                            () => context.read<SignupViewModel>().add(
                              TogglePasswordVisibility(),
                            ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Confirm Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: state.obscureConfirmPassword,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please confirm your password';
                        if (value != passwordController.text)
                          return 'Passwords do not match';
                        return null;
                      },
                      decoration: _buildInputDecoration(
                        context: context,
                        hintText: 'Confirm your password',
                        icon: LucideIcons.lock,
                        isObscured: state.obscureConfirmPassword,
                        onVisibilityToggle:
                            () => context.read<SignupViewModel>().add(
                              ToggleConfirmPasswordVisibility(),
                            ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              // *** UPDATED: Logic now dispatches the correct event with all required data ***
              onPressed:
                  isSubmitting
                      ? null
                      : () {
                        if (formKey.currentState!.validate()) {
                          context.read<SignupViewModel>().add(
                            OnFormSubmittedEvent(
                              state.email, // From the BLoC state
                              state.role, // From the BLoC state
                              passwordController
                                  .text, // From the local controller
                            ),
                          );
                        }
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: orangeColor,
                disabledBackgroundColor: orangeColor.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child:
                  isSubmitting
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                      : const Text(
                        "Finish",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _buildInputDecoration({
    required BuildContext context,
    required String hintText,
    required IconData icon,
    required bool isObscured,
    required VoidCallback onVisibilityToggle,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon, color: Colors.grey.shade600),
      suffixIcon: IconButton(
        icon: Icon(
          isObscured ? LucideIcons.eyeOff : LucideIcons.eye,
          color: Colors.grey.shade600,
        ),
        onPressed: onVisibilityToggle,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      filled: true,
      fillColor: lightGreyColor,
    );
  }
}
