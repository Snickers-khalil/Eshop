import 'package:flutter/cupertino.dart';

@immutable
abstract class SplashEvent {}

class CheckConnectivity extends SplashEvent {}

class NavigateToNextScreen extends SplashEvent {}
