import 'package:flutter/material.dart';
import 'package:homeworkout/firestore/database_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _logs = [];
  bool _isLoading = true;
  bool _isHistoryExpanded = false;

  // Variabel untuk menyimpan total statistik
  int _totalWorkouts = 0;
  int _totalMinutes = 0;

  // Statistik Minggu Ini (Mon-Sun)
  int _weeklyDuration = 0;
  int _weeklyCalories = 0;

  // Array 7 hari: Index 0=Mon, 6=Sun
  List<double> _dailyDurationValues = List.filled(7, 0.0);
  List<double> _dailyCalorieValues = List.filled(7, 0.0);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Fungsi untuk memuat data dari database lokal
  Future<void> _loadData() async {
    final data = await dbHelper.getLogs();

    // 1. Hitung total statistik
    int workouts = data.length;
    int minutes = 0;

    // 2. Siapkan data Mingguan
    DateTime now = DateTime.now();
    // Cari hari Senin minggu ini (Start of Week)
    // now.weekday: 1=Mon, 7=Sun
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    // Reset jam ke 00:00:00 agar akurat
    startOfWeek = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    DateTime endOfWeek = startOfWeek.add(const Duration(days: 7));

    // Reset nilai mingguan
    int wDuration = 0;
    int wCalories = 0;
    List<double> dDurations = List.filled(7, 0.0);
    List<double> dCalories = List.filled(7, 0.0);

    for (var log in data) {
      // Hitung Total All Time
      minutes += (log['duration'] as int);

      // Hitung Weekly
      DateTime logDate = DateTime.parse(log['date']);

      // Cek apakah log ini ada di minggu ini (Senin - Minggu)
      if (logDate.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
          logDate.isBefore(endOfWeek)) {

        wDuration += (log['duration'] as int);
        wCalories += (log['kcal'] as int);

        // Masukkan ke array harian (logDate.weekday 1=Mon -> index 0)
        int dayIndex = logDate.weekday - 1;
        dDurations[dayIndex] += (log['duration'] as int);
        dCalories[dayIndex] += (log['kcal'] as int);
      }
    }

    setState(() {
      _logs = data;
      _totalWorkouts = workouts;
      _totalMinutes = minutes;

      // Update data mingguan
      _weeklyDuration = wDuration;
      _weeklyCalories = wCalories;
      _dailyDurationValues = dDurations;
      _dailyCalorieValues = dCalories;

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan berapa item yang ditampilkan
    // Jika expanded = true, tampilkan semua. Jika false, maksimal 4.
    final itemCount = _isHistoryExpanded ? _logs.length : (_logs.length > 4 ? 4 : _logs.length);
    final bool showExpandButton = _logs.length > 4;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
            "Profile",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28)
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadData, // Tarik ke bawah untuk refresh data
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. PROFILE HEADER
              _buildProfileHeader(),

              const SizedBox(height: 24),

              // 2. STATISTIK RINGKASAN
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: "Workouts",
                      value: "$_totalWorkouts",
                      icon: Icons.fitness_center,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      title: "Duration (min)",
                      value: "$_totalMinutes",
                      icon: Icons.timer,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 3. WEEKLY ACTIVITY (GRAPH) --
              const Text(
                "This Week",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  // Grafik Duration
                  Expanded(
                    child: _buildWeeklyGraphCard(
                      title: "Duration",
                      value: "$_weeklyDuration",
                      unit: "min",
                      data: _dailyDurationValues,
                      color: Colors.blueAccent,
                      maxTarget: 300,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Grafik Calories
                  Expanded(
                    child: _buildWeeklyGraphCard(
                      title: "Calories",
                      value: "$_weeklyCalories",
                      unit: "kcal",
                      data: _dailyCalorieValues,
                      color: Colors.orangeAccent,
                      maxTarget: 500
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 4. RIWAYAT LATIHAN (HISTORY)
              const Text(
                "History",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              // Menampilkan List Riwayat
              if (_logs.isEmpty)
                _buildEmptyState()
              else
                Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true, // Agar bisa di dalam SingleChildScrollView
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        final log = _logs[index];
                        return _buildHistoryItem(log);
                      },
                    ),
                    if (showExpandButton)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isHistoryExpanded = !_isHistoryExpanded;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isHistoryExpanded ? "Show Less" : "Show More (${_logs.length - 4})",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Icon(
                              _isHistoryExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              // Tambahan padding bawah agar tombol tidak terlalu mepet edge
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Header Profil
  Widget _buildProfileHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage("https://placehold.co/200x200/png?text=User"),
          backgroundColor: Colors.black,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Guest User",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              "Keep going!",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  // Widget Kartu Statistik
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Angka Besar
              Text(
                value,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              // Ikon di pojok kanan atas
              Container(
                padding: const EdgeInsets.all(0),
                child: Icon(
                  icon,
                  size: 45, // Ukuran ikon sedang
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Title di bawah angka
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Widget Item List Riwayat
  Widget _buildHistoryItem(Map<String, dynamic> log) {
    // Parsing tanggal dari string ISO
    final date = DateTime.parse(log['date']);
    // Format tanggal manual (DD/MM/YYYY)
    final dateStr = "${date.day}/${date.month}/${date.year}";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.blue),
        ),
        title: Text(
          log['workoutTitle'] ?? "Workout",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(dateStr), // Menampilkan tanggal
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${log['duration']} min",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
              onPressed: () async {
                // Fitur Hapus Log
                await dbHelper.deleteLog(log['id']);
                _loadData(); // Refresh tampilan setelah hapus
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget Tampilan Kosong
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Icons.history, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No workout history yet",
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyGraphCard({
    required String title,
    required String value,
    required String unit,
    required List<double> data,
    required Color color,
    required double maxTarget, // Parameter baru untuk batas maksimal (skala)
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E), // Background Gelap
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Judul
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
          const SizedBox(height: 8),

          // Angka Total
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(unit, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // GRAFIK BATANG (BAR CHART)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              // Hitung tinggi relatif terhadap maxTarget (misal 300)
              double percentage = data[index] / maxTarget;
              // Batasi agar tidak lebih dari 1.0 (100%)
              if (percentage > 1.0) percentage = 1.0;

              // Total tinggi grafik adalah 60 pixel
              double barHeight = 60.0 * percentage;

              // Label Hari
              List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
              bool isToday = (DateTime.now().weekday - 1) == index;

              return Column(
                children: [
                  // Batang (Bar)
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Background Bar (Indikator Kosong - Abu-abu gelap)
                      Container(
                        width: 8,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      // Active Bar (Berwarna) - Height dinamis
                      Container(
                        width: 8,
                        height: barHeight,
                        decoration: BoxDecoration(
                          // Jika ada data > 0 tampilkan warna, jika 0 tidak tampil (height 0)
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Label Hari
                  Text(
                    days[index],
                    style: TextStyle(
                      color: isToday ? color : Colors.grey, // Highlight huruf hari ini
                      fontSize: 10,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  // Segitiga kecil penunjuk hari ini (Indicator)
                  if (isToday)
                    Icon(Icons.arrow_drop_up, color: color, size: 14)
                  else
                    const SizedBox(height: 14), // Placeholder agar tinggi tetap sama
                ],
              );
            }),
          )
        ],
      ),
    );
  }
}
