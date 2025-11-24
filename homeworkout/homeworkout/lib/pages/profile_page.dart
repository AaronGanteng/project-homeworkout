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

  // Variabel untuk menyimpan total statistik
  int _totalWorkouts = 0;
  int _totalMinutes = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Fungsi untuk memuat data dari database lokal
  Future<void> _loadData() async {
    final data = await dbHelper.getLogs();

    // Hitung total statistik
    int workouts = data.length;
    int minutes = 0;
    for (var log in data) {
      minutes += (log['duration'] as int);
    }

    setState(() {
      _logs = data;
      _totalWorkouts = workouts;
      _totalMinutes = minutes;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background putih bersih
      appBar: AppBar(
        title: const Text(
            "Profile",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
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
                      title: "Minutes",
                      value: "$_totalMinutes",
                      icon: Icons.timer,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 3. RIWAYAT LATIHAN (HISTORY)
              const Text(
                "History",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // Menampilkan List Riwayat
              if (_logs.isEmpty)
                _buildEmptyState()
              else
                ListView.builder(
                  shrinkWrap: true, // Agar bisa di dalam SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    final log = _logs[index];
                    return _buildHistoryItem(log);
                  },
                ),
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
          backgroundColor: Colors.grey,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Guest User",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
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
              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
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
}
