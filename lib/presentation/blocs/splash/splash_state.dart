import 'package:flutter/cupertino.dart';

@immutable
abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashConnected extends SplashState {}

class SplashDisconnected extends SplashState {}

class SplashNavigate extends SplashState {
  final String routeName;
  SplashNavigate(this.routeName);
}
