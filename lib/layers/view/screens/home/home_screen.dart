import 'package:flutter/material.dart';
import 'package:up_todo/core/constants/theme.dart';
import 'package:up_todo/layers/bloc/tasks_cubit/tasks_cubit.dart';
import 'package:up_todo/layers/view/screens/calendar/calendar_screen.dart';
import 'package:up_todo/layers/view/screens/index/widgets/add_task_dialog.dart';
import 'package:up_todo/layers/view/screens/home/widgets/nav_bar.dart';
import 'package:up_todo/layers/view/screens/index/index_screen.dart';
import 'package:up_todo/layers/view/screens/profile/profile_screen.dart';

import '../../../../injection_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget indexScreen = IndexScreen();
  int selectedIndex = 0;

  List<Widget> _screens() {
    return [
      indexScreen,
      CalendarScreen(),
      Scaffold(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens()[selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          height: 64,
          width: 64,
          child: FloatingActionButton(
            backgroundColor: ThemeColors.secondary,
            elevation: 0,
            onPressed: () {
              if (selectedIndex == 0 || selectedIndex == 1) {
                AddTaskDialog().showDialog(context);
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        pageIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
