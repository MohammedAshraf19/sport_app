import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:sport_app/modules/auth/register_screen.dart';

import '../../shared/component/components.dart';
import '../../shared/component/helperfunctions.dart';
import '../../shared/component/layout.dart';
import '../../shared/network/local/cach_helper.dart';
import '../home/home_screen.dart';
import 'cubit/auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoginUserSucceful) {
            CacheHelper.saveData(key: "uid", value: state.uid);
            AuthCubit.get(context).isLoading = false;
          }
          if (state is LoginUserError) {
            showSnackbar(context, Text(state.erorr));
            AuthCubit.get(context).isLoading = false;
          }
          if (state is LoadingLoginUser) {
            AuthCubit.get(context).isLoading = true;
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: AuthCubit.get(context).isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppLayout.getHeigth(20)),
                      child: Form(
                        key: formkey,
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                                Gap(AppLayout.getHeigth(10)),
                                defaultTextFormField(
                                  prefixIcon: Icons.email_rounded,
                                  controller: emailController,
                                  hintText: "Email",
                                  keyboard: TextInputType.emailAddress,
                                  validator: (String value) {
                                    if (!RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email address';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                Gap(AppLayout.getHeigth(10)),
                                defaultTextFormField(
                                  suffixPressed: () {
                                    AuthCubit.get(context).changeScureity();
                                  },
                                  suffixIcon: AuthCubit.get(context).suffixIcon,
                                  prefixIcon: Icons.password_outlined,
                                  controller: passwordController,
                                  hintText: "password",
                                  keyboard: TextInputType.visiblePassword,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'Please enter a passwrod';
                                    } else if (value.length < 6) {
                                      return 'this password is too short';
                                    } else {
                                      return null;
                                    }
                                  },
                                  security:
                                      AuthCubit.get(context).scuretiyPassword,
                                ),
                                Gap(AppLayout.getHeigth(15)),
                                SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          if (formkey.currentState!
                                              .validate()) {
                                            AuthCubit.get(context)
                                                .loginUserWithEmailPassword(
                                                    emailController.text,
                                                    passwordController.text)
                                                .then((value) {
                                              emailController.clear();
                                              passwordController.clear();
                                              nextScreenRep(
                                                  context, HomeScreen());
                                            });
                                          }
                                        },
                                        child: const Text("Login"))),
                                Gap(AppLayout.getHeigth(30)),
                                Text.rich(TextSpan(
                                    text: "you don't have an account? ",
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "create one",
                                          style: const TextStyle(
                                              decoration:
                                                  TextDecoration.underline),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              nextScreen(
                                                  context, RegisterScreen());
                                            })
                                    ]))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
