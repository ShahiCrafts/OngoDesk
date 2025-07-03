import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/detail_view_model/detail_entry_event.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/detail_view_model/detail_entry_state.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/detail_view_model/detail_entry_view_model.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/signup_view_model/email_view_model/email_entry_view_model.dart';

class DetailEntryView extends StatelessWidget {
  DetailEntryView({super.key});

  static const Color orangeColor = Color(0xFFFF5C00);
  static const Color lightGreyColor = Color(0xFFF5F5F5);
  static const Color textPrimaryColor = Color(0xFF1A1A1A);
  static const Color textSecondaryColor = Color(0xFF6B7280);

  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailEntryViewModel, DetailEntryState>(
      builder: (context, state) {
        final isSubmitting = state.status == DetailFormStatus.isSubmitting;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Complete Account Setup',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textPrimaryColor,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(LucideIcons.arrowLeft, color: textPrimaryColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          backgroundColor: Colors.white,
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.all(20),
            child: SizedBox(
              height: 56,
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    isSubmitting
                        ? null
                        : () {
                          if (formKey.currentState!.validate()) {
                            context.read<DetailEntryViewModel>().add(
                              SubmitDetailEntryForm(
                                context: context,
                                fullName: fullNameController.text,
                                email:
                                    context
                                        .read<EmailEntryViewModel>()
                                        .state
                                        .email,
                                password: passwordController.text,
                              ),
                            );
                          }
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    isSubmitting
                        ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                        : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Complete Setup",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              LucideIcons.arrowRight,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // Top Icon
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          orangeColor.withOpacity(0.12),
                          orangeColor.withOpacity(0.06),
                        ],
                      ),
                    ),
                    child: const Icon(
                      LucideIcons.userCheck,
                      size: 32,
                      color: orangeColor,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    "Almost There!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: textPrimaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Just a few more details to secure your account and get started with OnGo Desk.",
                    style: TextStyle(
                      fontSize: 16,
                      color: textSecondaryColor,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Full Name Field
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Full Name",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: fullNameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: "Enter your full name",
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.grey[500],
                      ),
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
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your full name';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: passwordController,
                    obscureText: state.obscurePassword,
                    decoration: InputDecoration(
                      hintText: "Create a secure password",
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.grey[500],
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          state.obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: () {
                          context.read<DetailEntryViewModel>().add(
                            TogglePasswordVisibility(),
                          );
                        },
                      ),
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
                        return 'Please enter a password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Requirements
                  _buildPasswordRequirements(passwordController.text),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _buildPasswordRequirements(String password) {
  final checks = {
    'At least 8 characters': password.length >= 8,
    'One uppercase letter': RegExp(r'[A-Z]').hasMatch(password),
    'One lowercase letter': RegExp(r'[a-z]').hasMatch(password),
    'One number': RegExp(r'[0-9]').hasMatch(password),
  };

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:
        checks.entries.map((entry) {
          final valid = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Icon(
                  valid ? LucideIcons.check : LucideIcons.x,
                  size: 14,
                  color: valid ? Colors.green : Colors.red.shade500,
                ),
                const SizedBox(width: 8),
                Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 14,
                    color: valid ? Colors.green : Colors.red.shade500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
  );
}
