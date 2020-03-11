

import 'package:flutter/cupertino.dart';

@immutable
class AuthState {

  final bool isAuthenticated;
  final String uid;

  AuthState({
    this.isAuthenticated,
    this.uid
  });

  factory AuthState.initial() {
    return new AuthState(
      isAuthenticated: false,
      uid: ''
    );
  }

  AuthState copyWith({
    bool isAuthenticated,
    uid
  }){
    return new AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      uid: uid ?? this.uid
    );
  }
}