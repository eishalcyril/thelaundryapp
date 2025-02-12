import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:laundry_app/common/network/newapiservice.dart';
import 'package:laundry_app/main.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  Box box = Hive.box('laundry');

  Future<void> userLogin(body) async {
    try {
      if (state is UserInitial) {
        emit(LoginLoading());
        final response =
            await NewApiService().post(endpoint: 'User/Login', body: body);
        if (response == null) {
          emit(LoginError());
          return;
        }
        developer.log(response.toString());
        if (response['type'] == 'SUCCESS') {
          emit(LoginSuccess(
              userRole: response['data']['isAdmin'],
              userData: response['data']));
        } else if (response['type'] == 'ERROR') {
          emit(
            LoginError(),
          );
        } else {
          emit(UserInitial());
        }
      } else if (state is UserSignUp) {
        emit(LoginLoading());
        final response =
            await NewApiService().post(endpoint: 'User/Signup', body: body);
        developer.log(response.toString());
        if (response == null) {
          emit(LoginError());
          return;
        }

        if (response['type'] == 'SUCCESS') {
          await rootScaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text('Signup Succcessful'),
              backgroundColor: Colors.green,
            ),
          );
          emit(UserInitial());
        } else if (response['type'] == 'ERROR') {
          await rootScaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: Text('Signup Unsucccessful'),
              backgroundColor: Colors.redAccent,
            ),
          );
          emit(
            LoginError(),
          );
        } else {
          emit(UserInitial());
        }
      }
    } on Exception catch (e) {
      emit(UserInitial());
      developer.log('', error: 'Unhandled exception: ${e.toString()}');
    }
  }

  Future<void> initState() async {
    emit(UserInitial());
  }

  Future<void> signUp() async {
    emit(UserSignUp());
  }
}
