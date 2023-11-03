import 'package:apptacticalstore/presentations/screens/home/home_screen.dart';
import 'package:apptacticalstore/presentations/screens/login/loginscreen.dart';
import 'package:apptacticalstore/presentations/screens/products/create_products.dart';
import 'package:apptacticalstore/presentations/screens/registrer/registrerscreen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    name: LoginScreen.name,
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/registrerscreen',
    name: RegistrerScreen.name,
    builder: (context, state) => const RegistrerScreen(),
  ),
  GoRoute(
    path: '/home-page',
    name: HomeScreen.name,
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/crear-producto',
    name: CreateProducts.name,
    builder: (context, state) => const CreateProducts(),
  ),
]);
