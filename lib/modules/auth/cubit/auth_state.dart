part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class ScurityState extends AuthState {}

class LoadingCreateUser extends AuthState {}

class LoadingCreateUserErorr extends AuthState {
  final String e;
  LoadingCreateUserErorr(this.e);
}

class CreateUserDataBaseSucceful extends AuthState {
  final String uid;
  CreateUserDataBaseSucceful(this.uid);
}

class CreateUserDataBaseErorr extends AuthState {
  final String e;
  CreateUserDataBaseErorr(this.e);
}

class LoadingLoginUser extends AuthState {}

class LoginUserSucceful extends AuthState {
  final String uid;
  LoginUserSucceful(this.uid);
}

class LoginUserError extends AuthState {
  final String erorr;
  LoginUserError(this.erorr);
}
