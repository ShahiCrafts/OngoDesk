import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/create_post_event.dart';
import '../../view_model/create_post_view_model.dart';

class LocationDisplay extends StatelessWidget {
  final String address;

  const LocationDisplay({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue.shade200)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on, color: Colors.blue, size: 16),
          const SizedBox(width: 8),
          Flexible(
              child: Text(
            address,
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: Colors.blue),
          )),
          const SizedBox(width: 4),
          InkWell(
            onTap: () =>
                context.read<CreatePostViewModel>().add(LocationRemoved()),
            borderRadius: BorderRadius.circular(30),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.close, size: 16, color: Colors.blue),
            ),
          )
        ],
      ),
    );
  }
}