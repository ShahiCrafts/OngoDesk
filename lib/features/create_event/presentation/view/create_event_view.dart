import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ongo_desk/features/create_event/presentation/view_model/create_event_event.dart';
import 'package:ongo_desk/features/create_event/presentation/view_model/create_event_state.dart';
import 'package:ongo_desk/features/create_event/presentation/view_model/create_event_view_model.dart';

const Color themeColor = Color(0xFFFF5C00);

class CreateEventView extends StatelessWidget {
  const CreateEventView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateEventViewModel(),
      child: const CreateEventPage(),
    );
  }
}

class CreateEventPage extends StatelessWidget {
  const CreateEventPage({super.key});

  /// Handles the entire image picking flow, from permissions to source selection.
  Future<void> _pickImage(BuildContext context) async {
    // Request camera and photo permissions.
    await [Permission.camera, Permission.photos].request();

    // Check if at least one permission is granted.
    if (await Permission.camera.isGranted || await Permission.photos.isGranted) {
      if (context.mounted) {
        final source = await _showImageSourceDialog(context);
        if (source != null) {
          context.read<CreateEventViewModel>().add(CreateEventCoverImagePicked(source));
        }
      }
    } else {
      // Show a message if permissions are denied.
       if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Camera and Photos permissions are needed to select an image.'),
          backgroundColor: Colors.red,
        ));
       }
    }
  }

  /// Shows a dialog for the user to choose between Camera and Gallery.
  Future<ImageSource?> _showImageSourceDialog(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: themeColor),
              title: const Text('Camera'),
              onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: themeColor),
              title: const Text('Gallery'),
              onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows the date picker, then the time picker.
  Future<void> _pickDate(BuildContext context, {required bool isStartDate}) async {
    final bloc = context.read<CreateEventViewModel>();
    final state = bloc.state;
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: (isStartDate ? state.startDate : state.endDate) ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 2)),
    );
    if (pickedDate != null && context.mounted) {
      _pickTime(context, pickedDate: pickedDate, isStartDate: isStartDate);
    }
  }

  Future<void> _pickTime(BuildContext context, {required DateTime pickedDate, required bool isStartDate}) async {
    final bloc = context.read<CreateEventViewModel>();
    final state = bloc.state;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime((isStartDate ? state.startDate : state.endDate) ?? DateTime.now()),
    );
    if (pickedTime != null) {
      final newDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      if (isStartDate) {
        bloc.add(CreateEventStartDateChanged(newDateTime));
      } else {
        bloc.add(CreateEventEndDateChanged(newDateTime));
      }
    }
  }

  /// Handles the form submission.
  void _onCreatePressed(BuildContext context) {
    final bloc = context.read<CreateEventViewModel>();
    if (bloc.state.isFormValid) {
      bloc.add(CreateEventSubmitted());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event creation initiated!'),
          backgroundColor: themeColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFormValid = context.select((CreateEventViewModel bloc) => bloc.state.isFormValid);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Event', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: isFormValid ? () => _onCreatePressed(context) : null,
            child: Text(
              'Post',
              style: TextStyle(
                color: isFormValid ? themeColor : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CoverPhotoInput(onTap: () => _pickImage(context)),
            const SizedBox(height: 24),
            _buildLabel('Event Title'),
            _StyledTextField(
              hintText: 'e.g., Community Hiking Trip',
              onChanged: (value) => context.read<CreateEventViewModel>().add(CreateEventTitleChanged(value)),
            ),
            const SizedBox(height: 16),
            _DateTimeInputs(onPickDate: _pickDate),
            const SizedBox(height: 16),
            _buildLabel('Event Type'),
            const SizedBox(height: 8),
            const Center(child: _EventTypeSelector()),
            const SizedBox(height: 16),
            _buildLabel('Location'),
            const _LocationTextField(),
            const SizedBox(height: 16),
            _buildLabel('Description'),
            _StyledTextField(
              hintText: 'Tell attendees more about your event...',
              maxLines: 4,
              onChanged: (value) => context.read<CreateEventViewModel>().add(CreateEventDescriptionChanged(value)),
            ),
            const SizedBox(height: 16),
            _buildLabel('Maximum Attendees'),
            _StyledTextField(
              hintText: 'e.g., 100',
              keyboardType: TextInputType.number,
              onChanged: (value) => context.read<CreateEventViewModel>().add(CreateEventMaxAttendeesChanged(int.tryParse(value))),
            ),
            const SizedBox(height: 16),
            _buildLabel('Contact Information'),
            _StyledTextField(
              hintText: 'Phone number, email, etc.',
              onChanged: (value) => context.read<CreateEventViewModel>().add(CreateEventContactChanged(value)),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 24, bottom: 12),
              child: Divider(thickness: 1),
            ),
            const Text(
              'Additional Options',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _ToggleWithSubtitle(
              title: 'Enable Waitlist',
              subtitle: 'When event is full, allow others to join the waitlist.',
              selector: (state) => state.enableWaitlist,
              onChanged: (value) => context.read<CreateEventViewModel>().add(CreateEventEnableWaitlistToggled(value)),
            ),
            _ToggleWithSubtitle(
              title: 'Send Reminders to Attendees',
              subtitle: 'Send automatic reminders before the event.',
              selector: (state) => state.sendReminders,
              onChanged: (value) => context.read<CreateEventViewModel>().add(CreateEventSendRemindersToggled(value)),
            ),
            _ToggleWithSubtitle(
              title: 'Require RSVP',
              subtitle: 'Require attendees to RSVP before joining.',
              selector: (state) => state.requireRSVP,
              onChanged: (value) => context.read<CreateEventViewModel>().add(CreateEventRequireRSVPToggled(value)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      );
}

// Internal private widgets for better build method readability

class _CoverPhotoInput extends StatelessWidget {
  final VoidCallback onTap;
  const _CoverPhotoInput({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventViewModel, CreateEventState>(
      buildWhen: (p, c) => p.coverImage != c.coverImage || p.imageUploadStatus != c.imageUploadStatus,
      builder: (context, state) {
        return GestureDetector(
          onTap: state.imageUploadStatus == ImageUploadStatus.uploading ? null : onTap,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
            child: state.coverImage == null
                ? _buildPlaceholder()
                : _buildPreview(state),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      key: const ValueKey('placeholder'),
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey),
            SizedBox(height: 8),
            Text('Add a cover photo'),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(CreateEventState state) {
    return ClipRRect(
      key: ValueKey(state.coverImage!.path),
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.file(
            File(state.coverImage!.path),
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          // Animated Upload Overlay
          if (state.imageUploadStatus == ImageUploadStatus.uploading)
            Container(
              height: 180,
              width: double.infinity,
              color: Colors.black.withOpacity(0.7),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
                    SizedBox(height: 16),
                    Text(
                      'Uploading...',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
           if (state.imageUploadStatus != ImageUploadStatus.uploading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.edit_outlined, color: Colors.white, size: 30),
              ),
            ),
        ],
      ),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final String? hintText;
  final int maxLines;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;

  const _StyledTextField({
    this.hintText,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextFormField(
        onChanged: onChanged,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black45),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}

class _DateTimeInputs extends StatelessWidget {
  final Function(BuildContext, {required bool isStartDate}) onPickDate;
  const _DateTimeInputs({required this.onPickDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BlocBuilder<CreateEventViewModel, CreateEventState>(
            buildWhen: (p, c) => p.startDate != c.startDate,
            builder: (context, state) {
              return _DatePicker(
                label: 'Start',
                value: state.startDate,
                onTap: () => onPickDate(context, isStartDate: true),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: BlocBuilder<CreateEventViewModel, CreateEventState>(
            buildWhen: (p, c) => p.endDate != c.endDate,
            builder: (context, state) {
              return _DatePicker(
                label: 'End',
                value: state.endDate,
                onTap: () => onPickDate(context, isStartDate: false),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DatePicker extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  const _DatePicker({required this.label, this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 4),
            Text(
              value == null ? 'Select Date' : DateFormat.yMMMd().add_jm().format(value!),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventTypeSelector extends StatelessWidget {
  const _EventTypeSelector();

  @override
  Widget build(BuildContext context) {
    final locationType = context.select((CreateEventViewModel bloc) => bloc.state.locationType);

    return SegmentedButton<LocationType>(
      segments: const [
        ButtonSegment(
          value: LocationType.physical,
          label: Text('Physical'),
          icon: Icon(Icons.location_on_outlined),
        ),
        ButtonSegment(
          value: LocationType.online,
          label: Text('Online'),
          icon: Icon(Icons.link),
        ),
      ],
      selected: {locationType},
      onSelectionChanged: (val) => context.read<CreateEventViewModel>().add(CreateEventLocationTypeChanged(val.first)),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          return states.contains(MaterialState.selected) ? themeColor : Colors.grey[100];
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          return states.contains(MaterialState.selected) ? Colors.white : Colors.black87;
        }),
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        side: MaterialStateProperty.all(BorderSide.none),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _ToggleWithSubtitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool Function(CreateEventState) selector;
  final ValueChanged<bool> onChanged;

  const _ToggleWithSubtitle({
    required this.title,
    required this.subtitle,
    required this.selector,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final value = context.select((CreateEventViewModel bloc) => selector(bloc.state));
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              subtitle,
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
          ),
          trailing: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: themeColor,
          ),
          onTap: () => onChanged(!value),
        ),
      ),
    );
  }
}

class _LocationTextField extends StatelessWidget {
  const _LocationTextField();

  @override
  Widget build(BuildContext context) {
    final locationType = context.select((CreateEventViewModel bloc) => bloc.state.locationType);

    return _StyledTextField(
      hintText: locationType == LocationType.physical ? 'Enter venue address' : 'Paste meeting link',
      prefixIcon: Icon(
        locationType == LocationType.physical ? Icons.map : Icons.link,
        color: themeColor,
      ),
      onChanged: (value) => context.read<CreateEventViewModel>().add(CreateEventLocationChanged(value)),
    );
  }
}