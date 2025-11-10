import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentBottomNavIndex = 0;
  String _selectedWorkoutCategory = 'Shoulder & Back';
  final List<String> _workoutCategories = [
    'Shoulder & Back',
    'Chest',
    'Arm',
    'Full Body',
    'Legs',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNavBar(),
      body: SafeArea(
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
                      child: Text(
                        "Quick Start",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _buildSectionTitle("Classic Workouts", null),
                    _buildWorkoutCategoryFilter(),
                    _buildWorkoutList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk Navbar Kustom (Judul & Search)
  Widget _buildCustomNavbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul Aplikasi
          const Text(
            'Home Workout',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search workouts, plans...',
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Judul Bagian (e.g., "Classic Plan" dan "See All")
  Widget _buildSectionTitle(String title, String? actionText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (actionText != null)
            Text(
              actionText,
              style: const TextStyle(
                color: Colors.blue, // Sesuai tema "biru putih"
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  // Widget untuk daftar "Classic Plan" (Horizontal Scroll)
  Widget _buildClassicPlanList() {
    // Tinggi kartu
    double cardHeight = 220;

    return Container(
      height: cardHeight,
      // Kita pakai ListView.builder agar efisien
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16.0, right: 8.0),
        itemCount: 3, // Data tiruan: ada 3 plan
        itemBuilder: (context, index) {
          // Data tiruan untuk plan
          final mockData = [
            {
              'title': 'MASSIVE UPPER BODY',
              'days': '28 Days',
              'desc': 'Sculpt your upper body and shred your abs...',
              'image':
              'https://placehold.co/300x220/0052CC/FFFFFF?text=Plan+1'
            },
            {
              'title': 'BEGINNER SHRED',
              'days': '30 Days',
              'desc': 'Burn fat and build lean muscle...',
              'image':
              'https://placehold.co/300x220/003B95/FFFFFF?text=Plan+2'
            },
            {
              'title': 'CORE STRENGTH',
              'days': '14 Days',
              'desc': 'Focus on your core and stability...',
              'image':
              'https://placehold.co/300x220/002A6C/FFFFFF?text=Plan+3'
            },
          ];

          // Ini adalah kartu plan-nya
          return Card(
            clipBehavior: Clip.antiAlias, // Untuk memotong gambar
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            margin: const EdgeInsets.only(right: 8.0),
            child: Container(
              width: 300, // Lebar kartu
              height: cardHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Gambar Latar Belakang
                  Image.network(
                    mockData[index]['image']!,
                    fit: BoxFit.cover,
                    // Error builder untuk jika URL gambar gagal dimuat
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.grey),
                    ),
                  ),
                  // Gradient hitam di atas gambar agar teks terbaca
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  // Konten Teks di atas gambar
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
                            foregroundColor: Colors.blue, // Teks biru
                          ),
                          child: const Text('Start'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget untuk filter kategori (Horizontal Scroll)
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
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
              selected: isSelected,
              onSelected: (bool selected) {
                // Mengganti state kategori yang dipilih
                setState(() {
                  _selectedWorkoutCategory = category;
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.blue, // Sesuai tema "biru putih"
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

  // Widget untuk daftar latihan (Vertikal, berdasarkan filter)
  Widget _buildWorkoutList() {
    // Data tiruan - idealnya ini difilter berdasarkan _selectedWorkoutCategory
    final mockWorkouts = [
      {
        'title': '$_selectedWorkoutCategory - Beginner',
        'mins': '15 mins',
        'image': 'https://placehold.co/100x100/EEE/000?text=W1'
      },
      {
        'title': '$_selectedWorkoutCategory - Intermediate',
        'mins': '25 mins',
        'image': 'https://placehold.co/100x100/EEE/000?text=W2'
      },
      {
        'title': '$_selectedWorkoutCategory - Advanced',
        'mins': '30 mins',
        'image': 'https://placehold.co/100x100/EEE/000?text=W3'
      },
      {
        'title': '$_selectedWorkoutCategory - Pro',
        'mins': '30 mins',
        'image': 'https://placehold.co/100x100/EEE/000?text=W3'
      },
      {
        'title': '$_selectedWorkoutCategory - Max',
        'mins': '30 mins',
        'image': 'https://placehold.co/100x100/EEE/000?text=W3'
      },
    ];

    return ListView.builder(
      // Penting: 2 baris ini agar ListView di dalam SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,

      padding: const EdgeInsets.all(16.0),
      itemCount: mockWorkouts.length,
      itemBuilder: (context, index) {
        final workout = mockWorkouts[index];
        return Card(
          color: Colors.white,
          elevation: 2,
          shadowColor: Colors.grey[100],
          margin: const EdgeInsets.only(bottom: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                workout['image']!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            title: Text(
              workout['title']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              workout['mins']!,
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
  }

  // Widget untuk Footer (Bottom Navigation Bar)
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentBottomNavIndex,
      onTap: (index) {
        setState(() {
          _currentBottomNavIndex = index;
        });
      },
      // Tipe 'fixed' agar semua 5 item terlihat dan tidak bergeser
      type: BottomNavigationBarType.fixed,

      // Tema "biru putih"
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey[500],
      backgroundColor: Colors.white,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Classic',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Discover',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_pin),
          label: 'Personal',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Daily',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Me',
        ),
      ],
    );
  }
}
