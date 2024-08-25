import 'package:e_shop/presentation/pages/auth/login.dart';
import 'package:flutter/material.dart';

import '../../blocs/auth/register/sign_up_bloc.dart';
import '../../blocs/auth/register/sign_up_event.dart';
import '../../blocs/auth/register/sign_up_state.dart';
import '../../widgets/custom_button_auth.dart';
import '../../widgets/custom_logo_auth.dart';
import '../../widgets/textformfield.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> formKeySignUp = GlobalKey<FormState>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: formKeySignUp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 50),
                    const CustomLogoAuth(),
                    Container(height: 20),
                    const Text("Sign Up",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                    Container(height: 10),
                    const Text("Sign up to continue using the app", style: TextStyle(color: Colors.grey)),
                    Container(height: 20),
                    const Text(
                      "Username",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Container(height: 10),
                    CustomTextForm(
                      hinttext: "Enter Your Username",
                      mycontroller: usernameController,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Can't be empty";
                        }
                        return null;
                      },
                    ),
                    Container(height: 20),
                    const Text(
                      "Email",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Container(height: 10),
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
                    Container(height: 10),
                    const Text(
                      "Password",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Container(height: 10),
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
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      alignment: Alignment.topRight,
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocConsumer<SignUpBloc, SignUpState>(
                listener: (context, state) {
                  if (state is SignUpSuccess) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      showCloseIcon: true,
                      closeIcon: const Icon(Icons.close),
                      title: 'Success',
                      desc: 'Account created successfully. Please check your email to verify your account.',
                    ).show();
                    Navigator.of(context).pushReplacementNamed("login");
                  } else if (state is SignUpError) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      showCloseIcon: true,
                      closeIcon: const Icon(Icons.close),
                      title: 'Error',
                      desc: state.message,
                    ).show();
                  }
                },
                builder: (context, state) {
                  return CustomButtonAuth(
                    title: "Sign Up",
                    onPressed: () {
                      if (formKeySignUp.currentState!.validate()) {
                              context.read<SignUpBloc>().add(
                                SignUpRequested(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  username: usernameController.text,
                                ));
                      }else{
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          showCloseIcon: true,
                          closeIcon: const Icon(Icons.close),
                          title: 'Error',
                          desc: 'Verify Data input',
                        ).show();
                      }
                    },
                  );
                },
              ),
              Container(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreen()),
                  );
                },
                child: const Center(
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                      text: "Have An Account? ",
                    ),
                    TextSpan(
                        text: "Login",
                        style: TextStyle(
                            color: Color(0xFF527cff), fontWeight: FontWeight.bold)),
                  ])),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
