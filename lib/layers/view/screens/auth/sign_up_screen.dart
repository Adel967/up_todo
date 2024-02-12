import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_todo/core/configuration/assets.dart';
import 'package:up_todo/core/constants/theme.dart';
import 'package:up_todo/core/loaders/loading_overlay.dart';
import 'package:up_todo/layers/bloc/auth_bloc/auth_cubit.dart';
import 'package:up_todo/layers/view/screens/auth/login_screen.dart';
import 'package:up_todo/layers/view/widgets/custom_text_field_with_title.dart';

import '../../../../injection_container.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameEditingController =
      TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();
  final TextEditingController confirmPasswordEditingController =
      TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  final authCubit = sl<AuthCubit>();

  signUp() {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      authCubit.signUp(usernameEditingController.text.trim(),
          passwordEditingController.text);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameEditingController.dispose();
    passwordEditingController.dispose();
    confirmPasswordEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary,
      appBar: AppBar(
        backgroundColor: ThemeColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        bloc: authCubit,
        listener: (context, state) {
          if (state is AuthLoading) {
            LoadingOverlay.of(context).show();
          } else if (state is AuthLoaded) {
            LoadingOverlay.of(context).hide();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => LoginScreen()));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Your account has created successfully!"),
              backgroundColor: ThemeColors.secondary,
            ));
          } else if (state is AuthError) {
            LoadingOverlay.of(context).hide();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
              backgroundColor: ThemeColors.secondary,
            ));
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Register",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10,
                ),
                Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextFieldWithTitle(
                            title: "Username",
                            hintText: "Enter your username",
                            textEditingController: usernameEditingController,
                            textInputType: TextInputType.text),
                        SizedBox(
                          height: 15,
                        ),
                        CustomTextFieldWithTitle(
                          title: "Password",
                          hintText: "Enter your password",
                          textEditingController: passwordEditingController,
                          textInputType: TextInputType.text,
                          isSecure: true,
                          val: (String text) {
                            if (text.length < 6) {
                              return "Your password is very short!";
                            }
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomTextFieldWithTitle(
                          title: "Confirm Password",
                          hintText: "Enter your password",
                          textEditingController:
                              confirmPasswordEditingController,
                          textInputType: TextInputType.text,
                          isSecure: true,
                          val: (String text) {
                            if (text != passwordEditingController.text) {
                              return "Password Mismatch";
                            }
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(vertical: 10)),
                                backgroundColor: MaterialStateProperty.all(
                                    ThemeColors.secondary),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5)))),
                            onPressed: () => signUp(),
                            child: Text(
                              "Register",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ))
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      height: 1,
                      color: Colors.white,
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "OR",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Container(
                      height: 1,
                      color: Colors.white,
                    )),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                OutlinedButton(
                    onPressed: () => authCubit.registerWithGoogle(),
                    style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: ThemeColors.secondary),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.GOOGLE_ICON,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Register With Google",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )
                      ],
                    )),
                SizedBox(
                  height: 15,
                ),
                OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: ThemeColors.secondary),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.APPLE_ICON,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Register With Apple",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )
                      ],
                    )),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account ? ",
                      style: TextStyle(
                          color: Colors.white.withOpacity(.8), fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => LoginScreen())),
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
