import 'package:flutter/material.dart';
import '../../../../../core/constants/theme.dart';

class ChooseIconDialog extends StatefulWidget {
  const ChooseIconDialog({super.key, this.initialIcon});
  final IconData? initialIcon;

  @override
  State<ChooseIconDialog> createState() => _ChooseIconDialogState();
}

class _ChooseIconDialogState extends State<ChooseIconDialog> {
  int selectedIndex = 0;
  List<IconData> icons = [
    Icons.home,
    Icons.sports_basketball,
    Icons.health_and_safety,
    Icons.music_note,
    Icons.work,
    Icons.video_camera_back_outlined,
    Icons.games,
    Icons.fastfood,
    Icons.movie,
    Icons.mode,
    Icons.search,
    Icons.favorite,
    Icons.facebook,
    Icons.family_restroom,
    Icons.code,
    Icons.drive_eta,
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.initialIcon != null) {
      selectedIndex = icons.indexOf(widget.initialIcon!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: ThemeColors.accent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      content: Padding(
        padding: EdgeInsets.all(10),
        child: SizedBox(
          width: size.width * 0.9,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Choose Icon",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                Divider(
                  color: Color(0XFF979797),
                ),
                SizedBox(
                  height: 10,
                ),
                GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.0, crossAxisCount: 4),
                    shrinkWrap: true,
                    itemCount: icons.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            color: selectedIndex == index
                                ? ThemeColors.secondary
                                : Color(0XFF272727),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                              child: Icon(
                            icons[index],
                            color: Colors.white,
                          )),
                        ),
                      );
                    }),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: ThemeColors.secondary, fontSize: 16),
                      ),
                    )),
                    Expanded(
                        child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3))),
                          backgroundColor:
                              MaterialStateProperty.all(ThemeColors.secondary)),
                      onPressed: () =>
                          Navigator.of(context).pop(icons[selectedIndex]),
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
