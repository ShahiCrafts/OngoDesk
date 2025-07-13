import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/create_post_event.dart';
import '../../view_model/create_post_state.dart';
import '../../view_model/create_post_view_model.dart';
import '../../view_model/post_type_enum.dart';

class PostInputFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController bodyController;
  final FocusNode titleFocusNode;
  final FocusNode bodyFocusNode;
  final CreatePostState state;

  const PostInputFields({
    super.key,
    required this.titleController,
    required this.bodyController,
    required this.titleFocusNode,
    required this.bodyFocusNode,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitleField(context, state),
        _buildBodyField(context, state),
      ],
    );
  }

  Widget _buildTitleField(BuildContext context, CreatePostState state) {
    String hintText;
    switch (state.postType) {
      case PostType.poll:
        hintText = "Poll question";
        break;
      case PostType.discussion:
        hintText = "Discussion title";
        break;
      default:
        hintText = "Issue title";
    }

    return TextFormField(
      controller: titleController,
      focusNode: titleFocusNode,
      onChanged: (val) =>
          context.read<CreatePostViewModel>().add(TitleChanged(val)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black26,
        ),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.only(left: 4),
      ),
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      maxLines: 1,
    );
  }

  Widget _buildBodyField(BuildContext context, CreatePostState state) {
    String hintText;
    switch (state.postType) {
      case PostType.poll:
        hintText = "Add more context to your poll (optional)...";
        break;
      case PostType.discussion:
        hintText = "Start the discussion...";
        break;
      default:
        hintText = "Briefly describe the issue and how it has affected you...";
    }

    return TextFormField(
      controller: bodyController,
      focusNode: bodyFocusNode,
      onChanged: (val) =>
          context.read<CreatePostViewModel>().add(BodyChanged(val)),
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.only(left: 4),
      ),
      style: const TextStyle(fontSize: 16),
      maxLines: null,
      keyboardType: TextInputType.multiline,
      scrollPadding: const EdgeInsets.only(bottom: 100),
    );
  }
}