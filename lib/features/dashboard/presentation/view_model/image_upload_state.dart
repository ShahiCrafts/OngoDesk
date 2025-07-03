import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ImageUploadState extends Equatable {
  const ImageUploadState();

  @override
  List<Object> get props => [];
}

/// The initial state before any action is taken.
class ImageUploadInitial extends ImageUploadState {}

/// State when permissions are denied by the user.
class ImageUploadPermissionDenied extends ImageUploadState {}

/// State when images have been successfully selected.
class ImageUploadSuccess extends ImageUploadState {
  final List<XFile> selectedImages;

  const ImageUploadSuccess(this.selectedImages);

  @override
  List<Object> get props => [selectedImages];
}

/// State when an error occurs during the process.
class ImageUploadFailure extends ImageUploadState {
  final String error;

  const ImageUploadFailure(this.error);

  @override
  List<Object> get props => [error];
}
