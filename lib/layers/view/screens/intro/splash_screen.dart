import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:up_todo/core/app/state/app_state.dart';
import 'package:up_todo/core/configuration/assets.dart';
import 'package:up_todo/core/constants/theme.dart';
import 'package:up_todo/core/shared_preference_key.dart';
import 'package:up_todo/layers/bloc/tasks_cubit/tasks_cubit.dart';
import 'package:up_todo/layers/view/screens/home/home_screen.dart';
import 'package:up_todo/layers/view/screens/intro/on_boarding_screen.dart';
import 'package:up_todo/layers/view/screens/intro/welcome_screen.dart';
import '../../../../injection_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final tasksCubit = sl<TasksCubit>();
  final appState = sl<AppStateModel>();

  //This function check if it is the first time for user in the app
  checkIfFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Future.delayed(Duration(seconds: 3), () async {
      if (prefs.getBool(SharedPreferencesKeys.FIRST_TIME_KEY) == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => OnBoardingScreen()));
      } else {
        if (prefs.getString(SharedPreferencesKeys.USER_ID_KEY) != null) {
          await appState.init();
          tasksCubit.getTasks();
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => WelcomeScreen()));
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfFirstTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary,
      body: BlocListener<TasksCubit, TasksState>(
        bloc: tasksCubit,
        listener: (context, state) {
          if (state is TasksLoaded) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => HomeScreen()));
          }
        },
        child: Center(
          child: Image.asset(Assets.APP_ICON),
        ),
      ),
    );
  }
}
