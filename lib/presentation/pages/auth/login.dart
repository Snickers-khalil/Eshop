import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_shop/presentation/pages/auth/register_screen.dart';
import 'package:e_shop/presentation/pages/product/product_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../blocs/auth/login/auth_bloc.dart';
import '../../blocs/auth/login/auth_event.dart';
import '../../blocs/auth/login/auth_state.dart';
import '../../widgets/custom_button_auth.dart';
import '../../widgets/custom_logo_auth.dart';
import '../../widgets/textformfield.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> signInWithGoogle() async {
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        if (googleUser == null) {
          _showDialog(context, DialogType.info, 'Info', 'Google sign-in was canceled.');
          return;
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      } catch (e) {
        print(e);
        _showDialog(context, DialogType.error, 'Error', 'Google sign-in failed. Please try again. Error: $e');
      }
    }

    return BlocProvider(
      create: (context) => AuthBloc(AuthRepository()),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomLogoAuth(),
                    const SizedBox(height: 10),
                    const Text(
                      "Login To Continue Using The App",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    CustomTextForm(
                      hinttext: "Enter Your Email",
                      mycontroller: emailController,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Can't be empty";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextForm(
                      hinttext: "Enter Your Password",
                      mycontroller: passwordController,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Can't be empty";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                      },
                      child: Container(
                        alignment: Alignment.topRight,
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthAuthenticated) {
                    Navigator.of(context).pushReplacementNamed('/home');
                  } else if (state is AuthError) {
                    _showDialog(context, DialogType.error, 'Error', state.error);
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CustomButtonAuth(
                    title: "Login",
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                          AuthLoginRequested(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          ),
                        );
                      } else {
                        _showDialog(context, DialogType.error, 'Error', 'Verify Data input');
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              MaterialButton(
                height: 40,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.grey[700],
                textColor: Colors.white,
                onPressed: signInWithGoogle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Login With Google  "),
                    Image.asset(
                      "assets/images/4.png",
                      width: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/signUp'); // Adjust the route name as needed

                },
                child: const Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: "Don't Have An Account? "),
                        TextSpan(
                          text: "Register",
                          style: TextStyle(
                            color: Color(0xFF527cff),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, DialogType dialogType, String title, String desc) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.rightSlide,
      showCloseIcon: true,
      closeIcon: const Icon(Icons.close),
      title: title,
      desc: desc,
    ).show();
  }
}
