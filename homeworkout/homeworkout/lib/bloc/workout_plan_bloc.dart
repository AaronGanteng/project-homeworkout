import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'workout_plan_event.dart';

part 'workout_plan_state.dart';

class WorkoutPlanBloc extends Bloc<WorkoutPlanEvent, WorkoutPlanState> {
  WorkoutPlanBloc() : super(WorkoutPlanInitial()) {
    // Daftarkan 'handler' untuk 'LoadPlansEvent'
    // Ini adalah inti logikanya:
    // "Jika (on) ada 'LoadPlansEvent' yang masuk, jalankan fungsi ini..."
    on<LoadPlansEvent>(_onLoadPlans);
  }

  void _onLoadPlans(
    LoadPlansEvent event,
    Emitter<WorkoutPlanState> emit,
  ) async {
    // 1. Beri tahu UI bahwa kita sedang loading
    emit(PlansLoading());

    try {
      // 2. Simulasi mengambil data dari Firebase (butuh waktu 2 detik)
      // TODO: Ganti ini dengan kode Firebase Anda yang sebenarnya
      final snapshot = await FirebaseFirestore.instance
          .collection('workout_plans')
          .get();

      // (Di sinilah Anda akan memanggil:
      final plans = snapshot.docs.map((doc) => doc.data()).toList();

      // 3. Jika berhasil, beri tahu UI bahwa data sudah siap (loaded)
      emit(PlansLoaded(plans));
    } catch (e) {
      // 4. Jika gagal, beri tahu UI bahwa ada error
      emit(PlansError("Gagal mengambil data: $e."));
    }
  }
}
