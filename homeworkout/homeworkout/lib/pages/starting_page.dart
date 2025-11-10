import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeworkout/bloc/workout_plan_bloc.dart';
import 'package:homeworkout/pages/home_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
  @override
  void iniState() {
    super.initState();

    context.read<WorkoutPlanBloc>().add(LoadPlansEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkoutPlanBloc, WorkoutPlanState> (
      listener: (context, state) {
        if (state is PlansLoaded) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }

        if (state is PlansError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF2A7FFF),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logos/App_Logo.png', width: 250, height: 250,),
              const SizedBox(height: 32,),
              LoadingAnimationWidget.twistingDots(
                leftDotColor: Colors.white,
                rightDotColor: Colors.white,
                size: 50, // Atur ukurannya
              ),
            ],
          ),
        ),
      ),
    );
  }
}
