import 'package:flutter/material.dart';
import 'package:homeworkout/pages/workout_detail_page.dart';
import '../models/workout_model.dart';
import '../services/workout_service.dart';

class ClassicPage extends StatefulWidget {
  const ClassicPage({super.key});

  @override
  State<ClassicPage> createState() => _ClassicPageState();
}

class _ClassicPageState extends State<ClassicPage> {
  String _selectedWorkoutCategory = 'Shoulder & Back';
  String _searchQuery = "";
  final List<String> _workoutCategories = [
    'Shoulder & Back',
    'Chest',
    'Arm',
    'Full Body',
    'Legs',
  ];
  final WorkoutService _workoutService = WorkoutService();

  // Mapping dari kategori UI ke bodyParts di data
  final Map<String, List<String>> _categoryMapping = {
    'Shoulder & Back': ['SHOULDERS', 'BACK'],
    'Chest': ['CHEST'],
    'Arm': ['UPPER ARMS', 'BICEPS', 'TRICEPS'],
    'Full Body': ['FULL BODY'],
    'Legs': ['QUADRICEPS', 'THIGHS', 'CALVES'],
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomNavbar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Classic Plan", "See All"),
                  _buildClassicPlanList(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12.0),
                        Text(
                          "Quick Start",
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        const Text(
                          'Classic Workouts',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                      ],
                    ),
                  ),
                  _buildWorkoutCategoryFilter(),
                  _buildWorkoutList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomNavbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Home Workout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search workouts, plans...',
              hintStyle: TextStyle(color: Colors.grey[600]),
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String? actionText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (actionText != null)
            Text(
              actionText,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildClassicPlanList() {
    double cardHeight = 220;

    return Container(
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16.0, right: 8.0),
        itemCount: 3,
        itemBuilder: (context, index) {
          final mockData = [
            {
              'title': 'MASSIVE UPPER BODY',
              'days': '28 Days',
              'desc': 'Sculpt your upper body and shred your abs...',
              'image': 'https://placehold.co/300x220/0052CC/FFFFFF?text=Plan+1',
            },
            {
              'title': 'BEGINNER SHRED',
              'days': '30 Days',
              'desc': 'Burn fat and build lean muscle...',
              'image': 'https://placehold.co/300x220/003B95/FFFFFF?text=Plan+2',
            },
            {
              'title': 'CORE STRENGTH',
              'days': '14 Days',
              'desc': 'Focus on your core and stability...',
              'image': 'https://placehold.co/300x220/002A6C/FFFFFF?text=Plan+3',
            },
          ];

          return Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 300,
              height: cardHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    mockData[index]['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[900],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mockData[index]['days']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          mockData[index]['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mockData[index]['desc']!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blueAccent[400],
                          ),
                          child: const Text(
                            'Start',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkoutCategoryFilter() {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16.0),
        itemCount: _workoutCategories.length,
        itemBuilder: (context, index) {
          final category = _workoutCategories[index];
          final bool isSelected = (category == _selectedWorkoutCategory);

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(category),
              labelStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    _selectedWorkoutCategory = category;
                  }
                });
              },
              backgroundColor: Colors.grey[900],
              selectedColor: Colors.blueAccent[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildWorkoutList() {
    final targetBodyParts =
        _categoryMapping[_selectedWorkoutCategory] ?? [];

    final stream = _searchQuery.isNotEmpty
        ? _workoutService.searchWorkouts(_searchQuery)
        : _workoutService.getWorkoutsByBodyParts(targetBodyParts);

    return StreamBuilder<List<Workout>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "No workouts found",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final workouts = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          itemCount: workouts.length,
          itemBuilder: (context, index) {
            final workout = workouts[index];

            return Card(
              color: Colors.grey[900],
              margin: const EdgeInsets.only(bottom: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WorkoutDetailPage(workout: workout),
                    ),
                  );
                },
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    workout.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  workout.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  workout.bodyParts.join(', ').replaceAll('_', ' '),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.blue,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
