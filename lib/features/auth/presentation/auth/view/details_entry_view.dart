import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ongo_desk/features/auth/presentation/auth/view_model/signup_view_model/signup_event.dart';
import 'package:ongo_desk/features/auth/presentation/auth/view_model/signup_view_model/signup_state.dart';
import 'package:ongo_desk/features/auth/presentation/auth/view_model/signup_view_model/signup_view_model.dart';

class DetailsEntryView extends StatefulWidget {
  const DetailsEntryView({super.key});

  @override
  State<DetailsEntryView> createState() => _DetailsEntryViewState();
}

class _DetailsEntryViewState extends State<DetailsEntryView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  String _selectedRole = 'citizen'; // Default role

  static const Color orangeColor = Color(0xFFFF5C00);

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      context.read<SignupViewModel>().add(
        FullNameAndRoleSubmitEvent(_fullNameController.text, _selectedRole),
      );
    }
  }

  // This build method is already well-designed.
  Widget _buildRoleCard({
    required String value,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedRole == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? orangeColor : Colors.grey.shade300,
              width: isSelected ? 2.5 : 1.5,
            ),
            borderRadius: BorderRadius.circular(20),
            color: isSelected ? orangeColor.withOpacity(0.03) : Colors.white,
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: orangeColor.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : [],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 28,
                    child: Radio<String>(
                      value: value,
                      groupValue: _selectedRole,
                      onChanged: (val) => setState(() => _selectedRole = val!),
                      activeColor: orangeColor,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Icon(
                    icon,
                    color: isSelected ? orangeColor : Colors.grey.shade600,
                    size: 26,
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 28,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color:
                                isSelected
                                    ? Colors.black87
                                    : Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            isSelected ? Colors.black54 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupViewModel, SignupState>(
      listenWhen: (previous, current) {
        return previous.emailFormStatus != current.emailFormStatus &&
            current.emailFormStatus == EmailFormStatus.nameAndRoleSubmitted;
      },
      listener: (context, state) {
        if (state.emailFormStatus == EmailFormStatus.nameAndRoleSubmitted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Details Saved!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushNamed(context, '/password-entry');
        }
      },
      builder: (context, state) {
        final isSubmitting =
            state.emailFormStatus == EmailFormStatus.submitting;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'About You',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 1,
            shadowColor: Colors.black.withOpacity(0.1),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "What should we call you?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _fullNameController,
                      validator:
                          (value) =>
                              value == null || value.trim().isEmpty
                                  ? "Please enter your name"
                                  : null,
                      decoration: InputDecoration(
                        hintText: "Enter your full name",
                        prefixIcon: Icon(
                          LucideIcons.user,
                          color: Colors.grey.shade600,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      "How will you be using the app?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _buildRoleCard(
                          value: 'citizen',
                          icon: LucideIcons.user,
                          title: "Public User",
                          subtitle: "General features.",
                        ),
                        _buildRoleCard(
                          value: 'official',
                          icon: LucideIcons.briefcase,
                          title: "Official",
                          subtitle: "Enhanced permissions.",
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: isSubmitting ? null : _onContinue,
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
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                      : const Text(
                        "Continue",
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
}
