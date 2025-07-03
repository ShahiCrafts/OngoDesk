import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'image_upload_event.dart';
import 'image_upload_state.dart';

class ImageUploadViewModel extends Bloc<ImageUploadEvent, ImageUploadState> {
  final ImagePicker _picker = ImagePicker();

  ImageUploadViewModel() : super(ImageUploadInitial()) {
    on<ImagePermissionRequested>(_onImagePermissionRequested);
    on<ImagesSelected>(_onImagesSelected);
    on<ImageSelectionCleared>(_onImageSelectionCleared);
  }

  Future<void> _onImagePermissionRequested(
    ImagePermissionRequested event,
    Emitter<ImageUploadState> emit,
  ) async {
    // Request permission for the photo library.
    // Add handling for different OS versions if needed.
    final status = await Permission.photos.request();

    if (status.isGranted) {
      try {
        // Allow user to pick multiple images.
        final List<XFile> pickedFiles = await _picker.pickMultiImage();
        if (pickedFiles.isNotEmpty) {
          add(ImagesSelected(pickedFiles));
        }
      } catch (e) {
        emit(ImageUploadFailure('Failed to pick images: ${e.toString()}'));
      }
    } else if (status.isPermanentlyDenied) {
      // The user has permanently denied the permission.
      // You should show a dialog directing them to settings.
      emit(ImageUploadPermissionDenied());
      // Consider showing a dialog here to open app settings.
      openAppSettings();
    } else {
      emit(ImageUploadPermissionDenied());
    }
  }

  void _onImagesSelected(
    ImagesSelected event,
    Emitter<ImageUploadState> emit,
  ) {
    emit(ImageUploadSuccess(event.images));
  }

  void _onImageSelectionCleared(
    ImageSelectionCleared event,
    Emitter<ImageUploadState> emit,
  ) {
    emit(ImageUploadInitial());
  }
}
