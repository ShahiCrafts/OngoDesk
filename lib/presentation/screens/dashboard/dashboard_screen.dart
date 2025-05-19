import 'package:flutter/material.dart';
import 'package:ongo_desk/data/models/post_model.dart';
import 'package:ongo_desk/presentation/widgets/post_card.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final List<PostModel> posts = [
    PostModel(
      category: 'ogd/infrastructure',
      status: 'pending',
      postedAt: '1h',
      postedBy: 'Saugat Shahi',
      content:
          'Broken parks near bhaisepati area, requires attention of municipality.',
      upVoteCount: '12',
      downVoteCount: '32',
      imageUri: 'https://media.istockphoto.com/id/603853418/photo/damaged-swing-seat-in-a-playground.jpg?s=612x612&w=0&k=20&c=jyqd3XRUbQiy6QXYZlKcBknDDto2XsioVIRrpKh5ew8=',
      profileUri: 'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg'
    ),
    PostModel(
      category: 'ogd/road',
      status: 'resolved',
      postedAt: '1yrs',
      postedBy: 'Sushant Jaishi',
      content:
          'Too many potholes near yala-sadak, soon to be noticed, caused many issues and prone to accidents.',
      upVoteCount: '12',
      downVoteCount: '32',
      imageUri: 'https://images.squarespace-cdn.com/content/v1/573365789f726693272dc91a/1704992146415-CI272VYXPALWT52IGLUB/AdobeStock_201419293.jpeg?format=1500w',
      profileUri:
          'https://images.pexels.com/photos/1081685/pexels-photo-1081685.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    ),
    PostModel(
      category: 'ogd/community',
      status: 'pending',
      postedAt: '1day',
      postedBy: 'Sabin Khadka',
      content:
          'Broken community water sources near ratnapark area, requires attention of municipality.',
      upVoteCount: '12',
      downVoteCount: '32',
      imageUri: 'https://ritewayphoenix.com/wp-content/uploads/2023/01/PACMED-FB-Ad-Size.18.jpg',
      profileUri:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyW2MAFrFnfa_bT1jSttLbmvfotJcqQyCCGg&s',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Color brandColor = Color(0xFFFF5C00);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: IconButton(
            onPressed: () {},
            icon: Image.asset('assets/icons/menu.png'),
          ),
        ),
        title: Row(
          children: [
            Text(
              '.OnGo Desk',
              style: TextStyle(
                color: brandColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(width: 4),

            Icon(Icons.keyboard_arrow_down, color: Colors.black87, size: 20),
          ],
        ),

        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),

          IconButton(
            onPressed: () {},
            icon: Padding(
              padding: EdgeInsets.only(right: 12),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey.shade400,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) => PostCard(post: posts[index]),
      ),
    );
  }
}
