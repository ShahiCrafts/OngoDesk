import 'package:flutter/material.dart';
import 'package:ongo_desk/presentation/widgets/community_drawer.dart';
import 'package:ongo_desk/presentation/widgets/dashboard_app_bar.dart';
import 'package:ongo_desk/presentation/widgets/post_card.dart';
import 'package:ongo_desk/data/models/post_model.dart';
import 'package:ongo_desk/presentation/widgets/switcher_bottom_sheet.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final popupKey = GlobalKey<PopupMenuButtonState>();
  bool isListOpen = false;
  int _currentIndex = 0;

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const ProfileOptionsBottomSheet(),
    );
  }

  final List<Map<String, dynamic>> listCommunity = [
    {
      'name': 'og/roadmaintenance',
      'icon': Icons.construction,
      'isFavorite': false,
    },
    {
      'name': 'og/cleaningservices',
      'icon': Icons.cleaning_services,
      'isFavorite': false,
    },
    {
      'name': 'og/electricityissues',
      'icon': Icons.electric_bolt,
      'isFavorite': false,
    },
    {
      'name': 'og/watermanagement',
      'icon': Icons.water_damage,
      'isFavorite': true,
    },
    {
      'name': 'og/publictransport',
      'icon': Icons.directions_bus,
      'isFavorite': false,
    },
  ];

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
      imageUri:
          'https://media.istockphoto.com/id/603853418/photo/damaged-swing-seat-in-a-playground.jpg?s=612x612&w=0&k=20&c=jyqd3XRUbQiy6QXYZlKcBknDDto2XsioVIRrpKh5ew8=',
      profileUri:
          'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg',
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
      imageUri:
          'https://images.squarespace-cdn.com/content/v1/573365789f726693272dc91a/1704992146415-CI272VYXPALWT52IGLUB/AdobeStock_201419293.jpeg?format=1500w',
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
      imageUri:
          'https://ritewayphoenix.com/wp-content/uploads/2023/01/PACMED-FB-Ad-Size.18.jpg',
      profileUri:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyW2MAFrFnfa_bT1jSttLbmvfotJcqQyCCGg&s',
    ),
  ];

  late final List<Widget> pages = [
    ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) => PostCard(post: posts[index]),
    ),
    const Center(
      child: Text(
        'Search Screen Placeholder',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    ),
    const Center(
      child: Text(
        'Communities Screen Placeholder',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    ),
    const Center(
      child: Text(
        'Inbox Screen Placeholder',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      appBar: DashboardAppBar(
        popupKey: popupKey,
        scaffoldKey: _scaffoldKey,
        onProfileLongPress: () => _showModalBottomSheet(context),
        onProfilePressed: () => popupKey.currentState?.showButtonMenu(),
      ),

      drawer: CommunityDrawer(
        isListOpen: isListOpen,
        toggleList: () {
          setState(() {
            isListOpen = !isListOpen;
          });
        },
        communities: listCommunity,
      ),

      body: pages[_currentIndex],

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // You can add per-tab behavior here
        },
        backgroundColor: const Color(0xFFFF5C00),
        shape: const CircleBorder(),
        child: const Icon(Icons.edit, color: Colors.white),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: Colors.white,
        shadowColor: Colors.black,
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.space_dashboard_rounded,
                color:
                    _currentIndex == 0 ? const Color(0xFFFF5C00) : Colors.grey,
              ),
              onPressed: () => setState(() => _currentIndex = 0),
            ),
            IconButton(
              icon: Icon(
                Icons.search,
                color:
                    _currentIndex == 1 ? const Color(0xFFFF5C00) : Colors.grey,
              ),
              onPressed: () => setState(() => _currentIndex = 1),
            ),
            const SizedBox(width: 48), // space for FAB
            IconButton(
              icon: Icon(
                Icons.group_add_rounded,
                color:
                    _currentIndex == 2 ? const Color(0xFFFF5C00) : Colors.grey,
              ),
              onPressed: () => setState(() => _currentIndex = 2),
            ),
            IconButton(
              icon: Icon(
                Icons.message,
                color:
                    _currentIndex == 3 ? const Color(0xFFFF5C00) : Colors.grey,
              ),
              onPressed: () => setState(() => _currentIndex = 3),
            ),
          ],
        ),
      ),
    );
  }
}
