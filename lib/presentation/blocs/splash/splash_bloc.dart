import 'package:e_shop/presentation/blocs/splash/splash_event.dart';
import 'package:e_shop/presentation/blocs/splash/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final Connectivity _connectivity;

  SplashBloc(
      this._connectivity,
      ) : super(SplashInitial());

  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    if (event is CheckConnectivity) {
      yield SplashLoading();
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        yield SplashConnected();
      } else {
        yield SplashDisconnected();
      }
    } else if (event is NavigateToNextScreen) {
      final token = await _getToken();

      // if (token != null) {
      //   yield SplashNavigate(RouteHelper.login);
      // } else {
      //   yield SplashNavigate(RouteHelper.splash);
      // }
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token_key'); // Adjust token key if needed
  }

}
