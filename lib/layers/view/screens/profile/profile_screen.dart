import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:up_todo/core/app/state/app_state.dart';
import 'package:up_todo/core/configuration/assets.dart';
import 'package:up_todo/core/constants/theme.dart';
import 'package:up_todo/layers/view/screens/intro/welcome_screen.dart';
import 'package:up_todo/layers/view/screens/profile/widgets/change_image_dialog.dart';
import 'package:up_todo/layers/view/screens/profile/widgets/settings_card.dart';
import '../../../../core/ui/warning_dialog.dart';
import '../../../../injection_container.dart';
import '../../../bloc/task_filter_bloc/task_filter_cubit.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final taskFilterCubit = sl<TaskFilter>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppStateModel>(context);
    return Scaffold(
      backgroundColor: ThemeColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Profile",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(
                  height: 15,
                ),
                Stack(
                  children: [
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        height: 100,
                        width: 100,
                        child: ClipOval(child: Image.asset(Assets.USER_ICON))),
                    provider.currentUser != null &&
                            provider.currentUser!.imageUrl != null
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            height: 100,
                            width: 100,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl:
                                    provider.currentUser!.imageUrl.toString(),
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  provider.currentUser!.username.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                BlocBuilder<TaskFilter, TaskFilterState>(
                  bloc: taskFilterCubit,
                  builder: (context, state) {
                    if (state is TaskFilterLoaded) {
                      return Row(
                        children: [
                          Expanded(
                            child: tasksNumber(
                                "${state.uncompletedTask.length}  Tasks left"),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: tasksNumber(
                                "${state.completedTask.length}  Tasks done"),
                          ),
                        ],
                      );
                    }
                    return SizedBox();
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                settingsCategory("Settings", [
                  SettingsCard(
                      icon: Icons.settings,
                      title: "App Settings",
                      function: () {})
                ]),
                SizedBox(
                  height: 20,
                ),
                settingsCategory("Account", [
                  SettingsCard(
                      icon: Icons.person,
                      title: "Change Account Name",
                      function: () {}),
                  SettingsCard(
                      icon: Icons.lock,
                      title: "Change Account Password",
                      function: () {}),
                  SettingsCard(
                      icon: Icons.image,
                      title: "Change Account Image",
                      function: () => ChangeImageDialog().showDialog(context)),
                ]),
                SizedBox(
                  height: 20,
                ),
                settingsCategory("Up todo", [
                  SettingsCard(
                      icon: Icons.people, title: "About Us", function: () {}),
                  SettingsCard(icon: Icons.info, title: "FAQ", function: () {}),
                  SettingsCard(
                      icon: Icons.electric_bolt,
                      title: "Help & feedback",
                      function: () {}),
                  SettingsCard(
                      icon: Icons.thumb_up,
                      title: "Support Us",
                      function: () {}),
                ]),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () async {
                    final res = await showDialog<bool?>(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) => WarningDialog(
                              message: '${"Are you sure!"}',
                              isWithButton: true,
                              isWithWarningLogo: true,
                            ));
                    if (res != null) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()),
                          (Route<dynamic> route) => false);
                      provider.logout();
                    }
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Logout",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column settingsCategory(String title, List<SettingsCard> cards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7)),
        ),
        SizedBox(
          height: 15,
        ),
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: cards.length,
          separatorBuilder: (context, index) => SizedBox(
            height: 15,
          ),
          itemBuilder: (context, index) {
            return cards[index];
          },
        ),
      ],
    );
  }

  Container tasksNumber(String text) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
          color: ThemeColors.accent, borderRadius: BorderRadius.circular(4)),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
