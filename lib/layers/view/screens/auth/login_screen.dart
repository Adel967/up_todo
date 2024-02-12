import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_todo/layers/view/screens/auth/sign_up_screen.dart';
import 'package:up_todo/layers/view/screens/home/home_screen.dart';

import '../../../../core/configuration/assets.dart';
import '../../../../core/constants/theme.dart';
import '../../../../core/loaders/loading_overlay.dart';
import '../../../../injection_container.dart';
import '../../../bloc/auth_bloc/auth_cubit.dart';
import '../../widgets/custom_text_field_with_title.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameEditingController =
      TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  final authCubit = sl<AuthCubit>();

  login() {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      authCubit.login(usernameEditingController.text.trim(),
          passwordEditingController.text);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameEditingController.dispose();
    passwordEditingController.dispose();
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
                MaterialPageRoute(builder: (_) => HomeScreen()));
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
                  "Login",
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
                            onPressed: () => login(),
                            child: Text(
                              "Login",
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
                          Assets.GOOGLE_ICON,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Login With Google",
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
                          "Login With Apple",
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
                      "Don\'t have an account ? ",
                      style: TextStyle(
                          color: Colors.white.withOpacity(.8), fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => SignUpScreen())),
                      child: Text(
                        "Register",
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
