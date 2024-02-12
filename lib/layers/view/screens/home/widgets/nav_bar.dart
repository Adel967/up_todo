import 'dart:io';

import 'package:flutter/material.dart';
import 'package:up_todo/core/constants/theme.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0.0,
      height: 70,
      padding: EdgeInsets.all(0),
      color: Color(0XFF363636),
      child: Row(
        children: [
          navItem(Icons.home, pageIndex == 0,
              onTap: () => onTap(0), title: "Index"),
          navItem(Icons.calendar_month, pageIndex == 1,
              onTap: () => onTap(1), title: "Calender"),
          const SizedBox(width: 80),
          navItem(Icons.watch_later, pageIndex == 2,
              onTap: () => onTap(2), title: "Focus"),
          navItem(Icons.person, pageIndex == 3,
              onTap: () => onTap(3), title: "Profile"),
        ],
      ),
    );
  }

  Widget navItem(IconData icon, bool selected,
      {Function()? onTap, required String title}) {
    return Expanded(
      child: GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 25,
                color: selected ? Colors.white : Colors.white.withOpacity(0.4),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          )),
    );
  }
}
