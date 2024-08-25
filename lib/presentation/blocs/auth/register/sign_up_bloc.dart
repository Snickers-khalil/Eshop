import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../domain/repositories/auth_repository.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository;

  SignUpBloc(this.authRepository) : super(SignUpInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
  }

  void _onSignUpRequested(SignUpRequested event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());
    try {
      final userCredential = await authRepository.signUp(event.email, event.password);
      await authRepository.sendEmailVerification();
      emit(SignUpSuccess(userCredential: userCredential));
    } catch (e) {
      emit(SignUpError(message: e.toString()));
    }
  }
}

