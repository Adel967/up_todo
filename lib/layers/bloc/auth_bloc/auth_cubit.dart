import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:up_todo/core/app/state/app_state.dart';
import 'package:up_todo/layers/bloc/tasks_cubit/tasks_cubit.dart';

import '../../../core/shared_preference_key.dart';
import '../../../injection_container.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  login(String username, String password) async {
    emit(AuthLoading());
    try {
      final checkExistingUser = await users.doc(username).get();
      if (checkExistingUser.exists) {
        if (checkExistingUser["password"] == encryption(password)) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(SharedPreferencesKeys.USER_ID_KEY, username);
          await sl<AppStateModel>().init();
          await sl<TasksCubit>().getTasks();
          emit(AuthLoaded());
          return;
        }
      }
    } catch (ex) {
      emit(AuthError(error: "Username or Password is incorrect!"));
    }
    emit(AuthError(error: "Username or Password is incorrect!"));
  }

  signUp(String username, String password) async {
    emit(AuthLoading());
    if (await checkUserExist(username)) {
      emit(AuthError(error: "This username used before!"));
      return;
    }
    await users
        .doc(username)
        .set({"username": username, "password": encryption(password)}).then(
            (value) => emit(AuthLoaded()));
  }

  registerWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    // if (gUser != null) {
    //   final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    //   emit(AuthLoading());
    //   if (await checkUserExist(gAuth.idToken!)) {
    //     emit(AuthError(error: "This username used before!"));
    //     return;
    //   }
    //   await users.doc(gAuth.idToken!).set({
    //     "username": gAuth.idToken!,
    //     "password": encryption(gAuth.accessToken!)
    //   }).then((value) => emit(AuthLoaded()));
    // }
  }

  checkUserExist(String docId) async {
    final checkExistingUser = await users.doc(docId).get();
    if (checkExistingUser.exists) {
      return true;
    }
    return false;
  }

  String encryption(String password) {
    var bytes = utf8.encode(password); // data being hashed
    var digest = md5.convert(bytes);
    return digest.toString();
  }
}
