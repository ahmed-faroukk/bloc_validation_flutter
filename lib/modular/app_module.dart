import 'package:flutter_modular/flutter_modular.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/pages/signup_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/auth/presentation/pages/login_screen.dart';

class AppModule extends Module {
  @override
  void binds(i) {
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const SplashPage());
    r.child('/login', child: (context) => const LoginPage());
    r.child('/signup', child: (context) => const SignUpPage());
  }
}
