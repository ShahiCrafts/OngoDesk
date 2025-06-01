import 'package:flutter/material.dart';
import 'package:ongo_desk/data/models/post_model.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 12, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Category and Posted Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: post.category,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: ' • ${post.postedAt}',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
            ],
          ),

          const SizedBox(height: 2),

          /// Avatar, Name and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(post.profileUri),
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'by',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        post.postedBy,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color:
                      post.status == 'resolved'
                          ? const Color(0xFFECFDF3)
                          : post.status == 'pending'
                          ? const Color(0xFFFEF3F2)
                          : Colors.grey[300],
                ),
                child: Text(
                  post.status,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color:
                        post.status == 'resolved'
                            ? const Color(0xFF379D55)
                            : post.status == 'pending'
                            ? const Color(0xFFDD3920)
                            : Colors.red,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Post Content
          Text(
            post.content,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 10),

          /// Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              post.imageUri,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 180,
            ),
          ),

          const SizedBox(height: 12),

          /// Upvote / Downvote / Share
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Upvote + Downvote
              Row(
                children: [
                  _VoteButton(
                    icon: Icons.arrow_circle_up,
                    count: post.upVoteCount,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 12),
                  _VoteButton(
                    icon: Icons.arrow_circle_down,
                    count: post.downVoteCount,
                    onPressed: () {},
                  ),
                ],
              ),

              /// Share Button
              /// Share Button
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.send_and_archive_rounded,
                        size: 20,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VoteButton extends StatelessWidget {
  final IconData icon;
  final String count;
  final VoidCallback onPressed;

  const _VoteButton({
    required this.icon,
    required this.count,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPressed,
            child: Icon(icon, size: 20, color: Colors.black87),
          ),
          const SizedBox(width: 6),
          Text(
            count,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
