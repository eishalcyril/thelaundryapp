part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserSignUp extends UserState {}

class LoginLoading extends UserState {}

class LoginSuccess extends UserState {
  const LoginSuccess({
    this.userRole,this.userData
  });

  final Map? userData;
  final int? userRole;
}

class IsAlreadyLoginTrue extends UserState {}

class IsAlreadyLoginFalse extends UserState {}

class ChangePasswordSuccess extends UserState {}

class LoginError extends UserState {}

class LogoutUser extends UserState {}

class getOTPSuccess extends UserState {}
