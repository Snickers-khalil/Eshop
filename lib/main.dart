import 'package:e_shop/domain/repositories/product_repository_impl.dart';
import 'package:e_shop/presentation/blocs/auth/login/auth_bloc.dart';
import 'package:e_shop/presentation/blocs/auth/register/sign_up_bloc.dart';
import 'package:e_shop/presentation/blocs/product/product_bloc.dart';
import 'package:e_shop/presentation/pages/auth/login.dart';
import 'package:e_shop/presentation/pages/auth/register_screen.dart';
import 'package:e_shop/presentation/pages/cart/cart_screen.dart';
import 'package:e_shop/presentation/pages/home/home_screen.dart';
import 'package:e_shop/presentation/pages/product/product_screen.dart';
import 'package:e_shop/presentation/pages/splash/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/models/product.dart';
import 'domain/repositories/auth_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => ProductRepositoryImpl()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(RepositoryProvider.of<AuthRepository>(context),),
          ),
          BlocProvider<SignUpBloc>(
            create: (context) => SignUpBloc(RepositoryProvider.of<AuthRepository>(context),),
          ),
          BlocProvider<ProductBloc>(
            create: (context) => ProductBloc(productRepository: RepositoryProvider.of<ProductRepositoryImpl>(context),),
          ),
          BlocProvider(
            create: (context) => SignUpBloc(RepositoryProvider.of<AuthRepository>(context),),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const HomeScreen();
              }
              return const SplashScreen();
            },
          ),
          routes: {
            // '/': (context) => const SplashScreen(),
            '/splash': (context) => const SplashScreen(),
            '/home': (context) => const HomeScreen(),
            '/signIn': (context) => LoginScreen(),
            '/signUp': (context) => const SignUpScreen(),
            '/cart': (context) => const CartView(),
            '/product': (context) => const ProductScreen(),
          },
        ),
      ),
    );
  }
}