import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'workout_plan_event.dart';
part 'workout_plan_state.dart';

class WorkoutPlanBloc extends Bloc<WorkoutPlanEvent, WorkoutPlanState> {
  WorkoutPlanBloc() : super(WorkoutPlanInitial()) {
    // Daftarkan 'handler' untuk 'LoadPlansEvent'
    // Ini adalah inti logikanya:
    // "Jika (on) ada 'LoadPlansEvent' yang masuk, jalankan fungsi ini..."
    on<LoadPlansEvent>(_onLoadPlans);
  }

  void _onLoadPlans(LoadPlansEvent event, Emitter<WorkoutPlanState> emit) async {
    // 1. Beri tahu UI bahwa kita sedang loading
    emit(PlansLoading());

    try {
      // 2. Simulasi mengambil data dari Firebase (butuh waktu 2 detik)
      // TODO: Ganti ini dengan kode Firebase Anda yang sebenarnya
      await Future.delayed(const Duration(seconds: 2));

      // (Di sinilah Anda akan memanggil:
      //  final data = await _firebaseRepository.getWorkoutPlans(); )

      // 3. Jika berhasil, beri tahu UI bahwa data sudah siap (loaded)
      emit(PlansLoaded(/* kirim data hasil fetch di sini jika perlu */));

    } catch (e) {
      // 4. Jika gagal, beri tahu UI bahwa ada error
      emit(PlansError("Gagal mengambil data dari server."));
    }
  }
}