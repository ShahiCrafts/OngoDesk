import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ongo_desk/data/models/post_model.dart';
import 'package:ongo_desk/features/dashboard/presentation/widgets/community_drawer.dart';
import 'package:ongo_desk/features/dashboard/presentation/widgets/dashboard_app_bar.dart';
import 'package:ongo_desk/features/dashboard/presentation/widgets/post_card.dart';
import 'package:ongo_desk/features/dashboard/presentation/widgets/switcher_bottom_sheet.dart';
import '../view_model/dashboard_view_model.dart';
import '../view_model/dashboard_event.dart';
import '../view_model/dashboard_state.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final popupKey = GlobalKey<PopupMenuButtonState>();

  final listCommunity = [
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

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const ProfileOptionsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const brandColor = Color(0xFFFF5C00);

    final pages = [
      ListView.separated(
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: posts.length,
        itemBuilder: (context, index) => PostCard(post: posts[index]),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
      ),
      const Center(child: Text('Search Screen Placeholder')),
      const Center(child: Text('Messages Screen Placeholder')),
      const Center(child: Text('Profile Screen Placeholder')),
    ];

    return BlocProvider(
      create: (_) => DashboardViewModel(),
      child: BlocBuilder<DashboardViewModel, DashboardState>(
        builder: (context, state) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: const Color(0xFFF8F9FB),
            appBar: DashboardAppBar(
              popupKey: popupKey,
              scaffoldKey: _scaffoldKey,
              onProfileLongPress: () => _showModalBottomSheet(context),
              onProfilePressed: () => popupKey.currentState?.showButtonMenu(),
            ),
            drawer: CommunityDrawer(
              isListOpen: state.isListOpen,
              toggleList:
                  () => context.read<DashboardViewModel>().add(
                    ToggleCommunityList(),
                  ),
              communities: listCommunity,
            ),
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: pages[state.currentIndex],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create-post');
              },
              backgroundColor: brandColor,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              elevation: 6,
              child: const Icon(Icons.add, size: 30),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              elevation: 8,
              color: Colors.white,
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      context,
                      Icons.home,
                      'Home',
                      0,
                      state.currentIndex,
                    ),
                    _buildNavItem(
                      context,
                      Icons.search,
                      'Search',
                      1,
                      state.currentIndex,
                    ),
                    const SizedBox(width: 68),
                    _buildNavItem(
                      context,
                      Icons.message,
                      'Messages',
                      2,
                      state.currentIndex,
                    ),
                    _buildNavItem(
                      context,
                      Icons.person,
                      'Profile',
                      3,
                      state.currentIndex,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    int currentIndex,
  ) {
    const brandColor = Color(0xFFFF5C00);
    final isSelected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => context.read<DashboardViewModel>().add(TabChanged(index)),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 6),
            Icon(
              icon,
              size: 24,
              color: isSelected ? brandColor : Colors.grey[600],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? brandColor : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
