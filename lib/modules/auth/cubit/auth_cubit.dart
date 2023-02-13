import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // this boolean is used for loading screen
  bool isLoading = false;

  // user collections
  var userCollection = FirebaseFirestore.instance.collection("users");

  static AuthCubit get(context) => BlocProvider.of(context);
  bool scuretiyPassword = true;
  IconData suffixIcon = Icons.visibility;

  void changeScureity() {
    scuretiyPassword = !scuretiyPassword;
    suffixIcon = scuretiyPassword ? Icons.visibility : Icons.visibility_off;
    emit(ScurityState());
  }

  // create user account on firebase
  Future createUserEmail(
      String name, String email, String phone, String password) async {
    try {
      emit(LoadingCreateUser());
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      creatUserDataBase(name, email, user.uid, phone, "");
    } on FirebaseAuthException catch (e) {
      emit(LoadingCreateUserErorr(e.toString()));
    }
  }
  //add user data to database

  creatUserDataBase(
      String name, String email, String uid, String phone, String image) {
    UserModel userModel = UserModel(
        email: email, image: image, phone: phone, name: name, uId: uid);
    userCollection.doc(uid).set(userModel.toJson()).then((value) {
      emit(CreateUserDataBaseSucceful(uid));
    }).catchError((e) {
      emit(CreateUserDataBaseErorr(e.toString()));
    });
  }

  //login function
  Future loginUserWithEmailPassword(String email, String password) async {
    try {
      emit(LoadingLoginUser());
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      emit(LoginUserSucceful(user.uid));
    } on FirebaseAuthException catch (e) {
      emit(LoginUserError(e.toString()));
    }
  }
}
