import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final List<String> bodyParts = [
    'Shoulder',
    'Chest',
    'Arm',
    'Full body',
    'Core',
    'Butt & Leg',
    'Back',
    'Custom',
  ];

  final List<String> workoutFiltersRow1 = [
    'Latest Updates', 'Beginner', 'Intermediate', 'Advanced'
  ];

  final List<String> workoutFiltersRow2 = [
    '1-7 min', '8-15 min', '>15 min', 'Stretching & Warm-Up'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Text(
              "Home Workout",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search workouts, plans...",
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Grid untuk Body Parts
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, // 4 kolom
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: bodyParts.length,
                    shrinkWrap: true,
                    // Penting di dalam SingleChildScrollView
                    physics: const NeverScrollableScrollPhysics(),
                    // Penting
                    itemBuilder: (context, index) {
                      return _buildBodyPartChip(bodyParts[index]);
                    },
                  ),

                  const SizedBox(height: 50),

                  Container(
                    height: 45, // Tinggi untuk satu baris chip
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        // Mengizinkan scrolling via sentuhan (HP) dan mouse (web)
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        },
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, // Scroll ke kanan-kiri
                        itemCount: workoutFiltersRow1.length,
                        itemBuilder: (context, index) {
                          final filter = workoutFiltersRow1[index];
                          return Padding(
                            // Beri jarak antar chip
                            padding: const EdgeInsets.only(right: 8.0),
                            child: _buildFilterChip(filter), // Panggil helper
                          );
                        },
                      ),
                    ),
                  ),

                  // Spasi antar baris
                  const SizedBox(height: 8.0),

                  Container(
                    height: 45, // Tinggi untuk satu baris chip
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        // Mengizinkan scrolling via sentuhan (HP) dan mouse (web)
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        },
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal, // Scroll ke kanan-kiri
                        itemCount: workoutFiltersRow2.length,
                        itemBuilder: (context, index) {
                          final filter = workoutFiltersRow2[index];
                          return Padding(
                            // Beri jarak antar chip
                            padding: const EdgeInsets.only(right: 8.0),
                            child: _buildFilterChip(filter), // Panggil helper
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24), // Spasi di akhir
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk chip Body Part
  Widget _buildBodyPartChip(String label) {
    // Pastikan nama file di folder assets sama persis dengan label!
    // Contoh: "Shoulder" -> "assets/logos/Shoulder.png"
    String imagePath = 'assets/logos/$label.png';

    return InkWell(
      onTap: () {
        /* Logika saat body part di-klik */
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: Container(
              width: 70, // Diameter lingkaran (2 x radius 35)
              height: 70,
              color: Colors.grey[900], // Warna background jika gambar transparan/loading
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover, // <-- INI KUNCINYA (Supaya full cover)
                errorBuilder: (context, error, stackTrace) {
                  // Fallback jika gambar belum ada di assets
                  return const Icon(
                    Icons.fitness_center,
                    color: Colors.blue,
                    size: 32,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),

          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 12,
              color: Colors.white, // Teks putih
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Widget untuk chip filter
  Widget _buildFilterChip(String label) {
    return InkWell(
      onTap: () {
        /* Logika saat filter di-klik */
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[900], // Latar belakang biru muda
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
