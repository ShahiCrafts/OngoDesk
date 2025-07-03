import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ImageUploadEvent extends Equatable {
  const ImageUploadEvent();

  @override
  List<Object> get props => [];
}

/// Triggered when the user taps the "Add Image" button.
/// This will start the permission request flow.
class ImagePermissionRequested extends ImageUploadEvent {}

/// Triggered after the user has selected images from the gallery.
class ImagesSelected extends ImageUploadEvent {
  final List<XFile> images;

  const ImagesSelected(this.images);

  @override
  List<Object> get props => [images];
}

/// Triggered to clear the current image selection.
class ImageSelectionCleared extends ImageUploadEvent {}
