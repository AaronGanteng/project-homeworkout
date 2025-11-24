import 'package:flutter/material.dart';
import 'package:homeworkout/firestore/database_helper.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  int _selectedDay = 1;

  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),

              _buildStageHeader(
                stageNum: 1,
                title: "Muscle Awakening",
                progress: "0/7",
              ),
              const SizedBox(height: 16),

              _buildDayRow(day: 1, isFirst: true),
              _buildDayRow(day: 2),
              _buildDayRow(day: 3),
              _buildDayRow(day: 4),
              _buildDayRow(day: 5),
              _buildDayRow(day: 6),
              _buildDayRow(day: 7, isLast: true),

              const SizedBox(height: 32),

              // -- STAGE 2 (Contoh Struktur Lanjutan) --
              _buildStageHeader(
                stageNum: 2,
                title: "Widen Your Frame",
                progress: "0/7",
              ),
              const SizedBox(height: 16),

              _buildDayRow(day: 8, isFirst: true, isLast: true),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER BARU: Menggabungkan Logika Timeline + Pilihan Kartu ---
  Widget _buildDayRow({
    required int day,
    bool isFirst = false,
    bool isLast = false,
  }) {
    // Cek apakah hari ini sedang dipilih
    bool isSelected = _selectedDay == day;

    return _buildTimelineItem(
      isFirst: isFirst,
      isLast: isLast,
      isActive: isSelected,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDay = day;
          });
        },
        // Container Luar yang Beranimasi (Warna & Ukuran)
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          // Durasi animasi
          curve: Curves.easeInOut,
          // Gerakan halus
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            // Animasi perubahan warna background
            color: isSelected ? Colors.white : Colors.grey[900],
            borderRadius: BorderRadius.circular(20),
            // Opsional: Tambah shadow sedikit saat aktif agar lebih pop-up
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          // AnimatedSwitcher untuk transisi konten (Isi kartu)
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              // Efek Fade + Sedikit Zoom saat ganti konten
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axis: Axis.vertical,
                  axisAlignment: -1.0,
                  child: child,
                ),
              );
            },
            // KONTEN KARTU
            // Gunakan 'key' yang berbeda agar Flutter tahu ini widget beda
            child: isSelected
                ? _buildActiveContent(day) // Tampilan Besar (Putih)
                : _buildInactiveContent(day), // Tampilan Kecil (Gelap)
          ),
        ),
      ),
    );
  }

  // ISI KONTEN SAAT AKTIF (Besar)
  Widget _buildActiveContent(int day) {
    return Column(
      key: ValueKey('active-$day'), // Key penting untuk animasi!
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          "Day $day",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildTag(Icons.timer, "5 mins", isLightMode: true),
            const SizedBox(width: 8),
            _buildTag(
              Icons.local_fire_department,
              "79 kcal",
              isLightMode: true,
            ),
          ],
        ),
        const SizedBox(height: 24), // Jarak ke tombol
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              // 1. Bersihkan string angka (hapus tulisan "mins" dan "kcal")
              // Contoh: "5 mins" -> "5" -> 5
              // RegExp(r'[^0-9]') artinya "hapus semua karakter yang BUKAN angka 0-9"
              int duration = 30;
              int calories = 50;

              // 2. Siapkan data map untuk SQFlite
              Map<String, dynamic> row = {
                'workoutTitle': "Day $day",
                'duration': duration,
                'kcal': calories,
                'date': DateTime.now().toIso8601String(),
              };

              // 3. Simpan ke Database Lokal
              // Pastikan dbHelper sudah diinisialisasi di _PersonalTabState
              await dbHelper.insertLog(row);

              // 4. Tampilkan Konfirmasi
              if (mounted) {
                // Cek apakah widget masih ada di layar sebelum update UI
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Latihan Day $day selesai & tersimpan!",
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    // Tampil melayang lebih keren
                    margin: const EdgeInsets.all(16),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
            ),
            child: const Text(
              "Start Now",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // ISI KONTEN SAAT TIDAK AKTIF (Kecil)
  Widget _buildInactiveContent(int day) {
    return Row(
      key: ValueKey('inactive-$day'), // Key penting untuk animasi!
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Day $day",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "5 mins | 79 kcal",
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
        // Placeholder gambar kecil
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            "https://placehold.co/100x100/333/FFF?text=Day+$day",
            width: 80,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(width: 80, height: 60, color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }

  // 1. WIDGET HEADER
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "FULL BODY MUSCLE GAIN", // Sesuai permintaan
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25, // Font besar
                  fontWeight: FontWeight.w900, // Sangat tebal
                ),
              ),
            ],
          ),
        ),
        // Tombol Filter
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // 3. WIDGET JUDUL STAGE
  Widget _buildStageHeader({
    required int stageNum,
    required String title,
    required String progress,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Stage $stageNum: $title",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            Icon(Icons.grid_view, color: Colors.grey[600], size: 16),
            const SizedBox(width: 4),
            Text(
              progress,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  // 4. WIDGET PEMBUNGKUS TIMELINE (Garis & Titik)
  Widget _buildTimelineItem({
    required Widget child,
    bool isActive = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 20,
            child: Column(
              children: [
                // --- GARIS ATAS (TOP LINE) ---
                // Disembunyikan (transparan) jika ini adalah item PERTAMA
                Expanded(
                  child: Container(
                    width: 2,
                    color: isFirst ? Colors.transparent : Colors.grey[800],
                  ),
                ),

                // --- TITIK (DOT) ---
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.blue : Colors.grey[800],
                    shape: BoxShape.circle,
                    border: isActive
                        ? Border.all(
                            color: Colors.blue.withOpacity(0.3),
                            width: 4,
                          )
                        : null,
                  ),
                ),

                // --- GARIS BAWAH (BOTTOM LINE) ---
                // Disembunyikan (transparan) jika ini adalah item TERAKHIR
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12), // Jarak ke kartu
          // Bagian Kanan: Isi Kartu
          Expanded(child: child),
        ],
      ),
    );
  }

  // 5. KARTU BESAR (AKTIF/HARI INI)
  Widget _buildBigActiveCard({
    required String day,
    required String mins,
    required String kcal,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      height: 200,
      // Sedikit lebih pendek karena tanpa gambar background
      decoration: BoxDecoration(
        color: Colors.white, // <-- BACKGROUND PUTIH
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          Text(
            "Day $day",
            style: const TextStyle(
              color: Colors.black, // <-- TEKS HITAM
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Menggunakan style tag khusus untuk background putih
              _buildTag(Icons.timer, mins, isLightMode: true),
              const SizedBox(width: 8),
              _buildTag(Icons.local_fire_department, kcal, isLightMode: true),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Tombol tetap Biru
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "Start Now",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 6. KARTU KECIL (COMING SOON)
  Widget _buildSmallUpcomingCard({
    required String day,
    required String mins,
    required String kcal,
    required String imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900], // <-- KEMBALI KE WARNA GELAP
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Day $day",
                style: const TextStyle(
                  color: Colors.white, // <-- Teks Putih
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "$mins | $kcal",
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
            ],
          ),
          // Gambar kecil di kanan (Kotak Abu-abu jika gambar error)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imagePath,
              width: 80,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(width: 80, height: 60, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk tag kecil
  Widget _buildTag(IconData icon, String text, {bool isLightMode = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        // Jika mode light (kartu putih), background abu-abu muda.
        // Jika mode dark (kartu hitam), background transparan hitam.
        color: isLightMode ? Colors.grey[300] : Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            // Ikon gelap di kartu putih, ikon terang di kartu gelap
            color: isLightMode ? Colors.grey[800] : Colors.white70,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              // Teks gelap di kartu putih
              color: isLightMode ? Colors.black87 : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
