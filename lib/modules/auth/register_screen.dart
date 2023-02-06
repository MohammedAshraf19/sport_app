import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../shared/component/components.dart';
import '../../shared/component/helperfunctions.dart';
import '../../shared/component/layout.dart';
import '../../shared/network/local/cach_helper.dart';
import '../home/home_screen.dart';
import 'cubit/auth_cubit.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final formkey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LoadingCreateUserErorr) {
            showSnackbar(context, Text(state.e));
            AuthCubit.get(context).isLoading = false;
          }
          if (state is CreateUserDataBaseErorr) {
            showSnackbar(context, Text(state.e));
            AuthCubit.get(context).isLoading = false;
          }
          if (state is CreateUserDataBaseSucceful) {
            CacheHelper.saveData(key: "uid", value: state.uid);
            AuthCubit.get(context).isLoading = false;
          }
          if (state is LoadingCreateUser) {
            AuthCubit.get(context).isLoading = true;
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: AuthCubit.get(context).isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppLayout.getHeigth(20)),
                      child: Form(
                        key: formkey,
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Register",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                                Gap(AppLayout.getHeigth(10)),
                                defaultTextFormField(
                                    prefixIcon: Icons.mail,
                                    controller: nameController,
                                    hintText: "Full Name",
                                    keyboard: TextInputType.name,
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "please enter your name";
                                      }
                                      return null;
                                    }),
                                Gap(AppLayout.getHeigth(10)),
                                defaultTextFormField(
                                  prefixIcon: Icons.email_rounded,
                                  controller: emailController,
                                  hintText: "Email",
                                  keyboard: TextInputType.emailAddress,
                                  validator: (value) {
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
                                  validator: (value) {
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
                                Gap(AppLayout.getHeigth(10)),
                                defaultTextFormField(
                                    prefixIcon: Icons.phone,
                                    controller: phoneController,
                                    hintText: "phone number",
                                    keyboard: TextInputType.phone,
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "please enter number";
                                      }
                                      return null;
                                    }),
                                Gap(AppLayout.getHeigth(15)),
                                SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          if (formkey.currentState!
                                              .validate()) {
                                            AuthCubit.get(context)
                                                .createUserEmail(
                                                    nameController.text,
                                                    emailController.text,
                                                    phoneController.text,
                                                    passwordController.text)
                                                .then((value) {
                                              nameController.clear();
                                              emailController.clear();
                                              phoneController.clear();
                                              passwordController.clear();
                                              nextScreenRep(
                                                  context, HomeScreen());
                                            });
                                          }
                                        },
                                        child: const Text("Rigest now"))),
                                Gap(AppLayout.getHeigth(30)),
                                Text.rich(TextSpan(
                                    text: "you already have an account ? ",
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "login now ",
                                          style: const TextStyle(
                                              decoration:
                                                  TextDecoration.underline),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              nextScreenRep(
                                                  context, LoginScreen());
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
