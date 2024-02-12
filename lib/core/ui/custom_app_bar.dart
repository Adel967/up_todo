import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/state/app_state.dart';
import '../configuration/assets.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppStateModel>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.menu,
          size: 30,
          color: Colors.white,
        ),
        Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        Stack(
          children: [
            Container(
                height: 30,
                width: 30,
                child: ClipOval(child: Image.asset(Assets.USER_ICON))),
            provider.currentUser != null &&
                    provider.currentUser!.imageUrl != null
                ? Container(
                    height: 30,
                    width: 30,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: provider.currentUser!.imageUrl.toString(),
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
      ],
    );
  }
}
