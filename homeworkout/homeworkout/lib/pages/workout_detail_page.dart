import 'package:flutter/material.dart';
import 'package:homeworkout/models/workout_model.dart';

class WorkoutDetailPage extends StatefulWidget {
  final Workout workout;

  const WorkoutDetailPage({super.key, required this.workout});

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  // Default tab terpilih
  String _selectedTab = 'Video';

  // State untuk timer durasi
  late int _currentDuration;

  @override
  void initState() {
    super.initState();
    // Mengambil durasi dari model.
    // Pastikan di model workout_model.dart field duration sudah di-set (misal default 30)
    _currentDuration = widget.workout.duration;
  }

  // Helper: Format detik ke menit:detik (00:30)
  String _formatDuration(int seconds) {
    int min = seconds ~/ 60;
    int sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  // Helper: Tambah/Kurang durasi
  void _adjustDuration(int amount) {
    setState(() {
      _currentDuration += amount;
      // Batas minimal 10 detik agar tidak error/negatif
      if (_currentDuration < 10) _currentDuration = 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Background Hitam Pekat (Dark Mode)

      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.workout.name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Tambahkan aksi feedback jika perlu
            },
            child: const Text("Feedback", style: TextStyle(color: Colors.grey)),
          )
        ],
      ),

      // --- BODY ---
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // 1. GAMBAR LATIHAN
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        widget.workout.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[900],
                          child: const Icon(Icons.broken_image, color: Colors.white54, size: 50),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2. TABS (Video | Muscle | How-to-do)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2E), // Abu gelap
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        _buildTabItem("Video"),
                        _buildTabItem("Muscle"),
                        _buildTabItem("How-to-do"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 3. DURATION CONTROLLER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "DURATION (SECONDS)",
                        style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2C2E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => _adjustDuration(-10),
                              icon: const Icon(Icons.remove, color: Colors.white),
                            ),
                            Text(
                              _formatDuration(_currentDuration),
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: () => _adjustDuration(10),
                              icon: const Icon(Icons.add, color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 4. INSTRUCTIONS (PERBAIKAN DISINI)
                  // Menggunakan Column dan map agar tampil sebagai list, bukan paragraf
                  if (widget.workout.instructions.isNotEmpty) ...[
                    const Text(
                      "INSTRUCTIONS",
                      style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    ...widget.workout.instructions.map((text) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• ", style: TextStyle(color: Colors.white, fontSize: 16)),
                          Expanded(
                            child: Text(
                              text,
                              style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],

                  const SizedBox(height: 24),

                  // 5. FOCUS AREA (CHIPS)
                  const Text(
                    "FOCUS AREA",
                    style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 12, // Jarak antar chip horizontal
                      runSpacing: 12, // Jarak antar chip vertikal
                      children: widget.workout.targetMuscles.map((muscle) {
                        return _buildCustomChip(muscle);
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 6. MUSCLE MAP (BODY IMAGE)
                  Center(
                    child: SizedBox(
                      height: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Body Front Placeholder
                          Expanded(
                            child: Opacity(
                              opacity: 0.6,
                              child: Image.network(
                                "https://cdn-icons-png.flaticon.com/512/2858/2858062.png", // Aset dummy
                                color: Colors.grey,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Body Back Placeholder
                          Expanded(
                            child: Opacity(
                              opacity: 0.6,
                              child: Image.network(
                                "https://cdn-icons-png.flaticon.com/512/2858/2858062.png", // Aset dummy
                                color: Colors.grey,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 100), // Spacer bawah agar tidak tertutup tombol Close
                ],
              ),
            ),
          ),

          // --- TOMBOL CLOSE BAWAH ---
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF121212),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER: CUSTOM CHIP (BINTIK BIRU) ---
  Widget _buildCustomChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label.replaceAll('_', ' '),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER: TAB ---
  Widget _buildTabItem(String title) {
    bool isSelected = _selectedTab == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = title),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}