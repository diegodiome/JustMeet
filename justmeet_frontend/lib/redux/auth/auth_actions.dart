import 'dart:async';

import 'package:flutter/material.dart';
import 'package:justmeet_frontend/model/user.dart';

class VerifyAuthenticationState {}

class LogIn {
  final String email;
  final String password;
  final Completer completer;

  LogIn({
    this.email, 
    this.password,
    Completer completer
  }) : completer = completer ?? Completer();
}

class LogInWithGoogle {}

@immutable
class OnAuthenticated {
  final User user;

  const OnAuthenticated({@required this.user});

  @override
  String toString() {
    return "OnAuthenticated{user: $user}";
  }
}

class LogOut {}

class OnLogOutSuccess {
  OnLogOutSuccess();

  @override
  String toString() {
    return 'LogOut success';
  }
}

class OnLogOutFail {
  final dynamic error;

  OnLogOutFail(this.error);

  @override
  String toString() {
    return 'OnLogOutFail{Error on logout: $error}';
  }
}

