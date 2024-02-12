import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:up_todo/core/firestore_key.dart';
import 'package:up_todo/core/shared_preference_key.dart';

import '../../../layers/models/user.dart';

class AppStateModel extends ChangeNotifier {
  ProfileContent? currentUser;
  late SharedPreferences prefs;
  bool _authenticated = false;
  FirebaseStorage _storage = FirebaseStorage.instance;

  changeUserImage(File image) async {
    Reference reference =
        _storage.ref().child("images/${currentUser!.username}.jpg");
    await reference.putFile(image);
    String location = await reference.getDownloadURL();

    await FirebaseFirestore.instance
        .collection(FireStoreKeys.USER_COLLECTION)
        .doc(currentUser!.username)
        .update({"imageUrl": location});

    prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPreferencesKeys.IMAGE_URL_KEY, location);
    init();
  }

  Future init() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString(SharedPreferencesKeys.USER_ID_KEY) != null) {
      currentUser = ProfileContent(
          username: prefs.getString(SharedPreferencesKeys.USER_ID_KEY),
          imageUrl: prefs.getString(SharedPreferencesKeys.IMAGE_URL_KEY));
      _authenticated = true;
    }
    notifyListeners();
  }

  Future logout() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove(SharedPreferencesKeys.USER_ID_KEY);
    prefs.remove(SharedPreferencesKeys.IMAGE_URL_KEY);
    init();
  }

  bool get authenticated => _authenticated;
}
