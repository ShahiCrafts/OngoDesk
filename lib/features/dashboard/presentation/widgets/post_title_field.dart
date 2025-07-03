import 'package:flutter/material.dart';

class PostTitleField extends StatelessWidget {
  final TextEditingController controller;

  const PostTitleField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: "Title",
        hintStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: Colors.black26,
        ),
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
