import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class ButtonsStartWith extends StatefulWidget {
  const ButtonsStartWith({super.key});

  @override
  State<ButtonsStartWith> createState() => _ButtonsStartWithState();
}

class _ButtonsStartWithState extends State<ButtonsStartWith> {
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return; // El usuario canceló el inicio de sesión
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (authResult.user != null) {
        // El inicio de sesión con Google fue exitoso, redirige a HomeScreen
        context.go('/home-page');
      }
    } catch (e) {
      // Manejo de errores. Puedes imprimir el error o tomar otras acciones.
      print("Error durante el inicio de sesión con Google: $e");
      // Aquí puedes mostrar un mensaje de error o realizar otras acciones en caso de error.
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;

        if (accessToken != null) {
          final AuthCredential credential =
              FacebookAuthProvider.credential(accessToken.token);
          final UserCredential authResult =
              await FirebaseAuth.instance.signInWithCredential(credential);

          if (authResult.user != null) {
            // El inicio de sesión con Facebook fue exitoso, redirige a HomeScreen
            context.go('/home-page');
          }
        }
      }
    } catch (e) {
      // Manejo de errores. Puedes imprimir el error o tomar otras acciones.
      print("Error durante el inicio de sesión con Facebook: $e");
      // Aquí puedes mostrar un mensaje de error o realizar otras acciones en caso de error.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            signInWithFacebook(context);
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)))),
          child: SizedBox(
            width: 80, // Ancho deseado
            height: 60, // Alto deseado
            child: Image.asset('assets/images_company/facebook.png'),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        ElevatedButton(
            onPressed: () async {
              await signInWithGoogle(context);
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)))),
            child: SizedBox(
              width: 80, // Ancho deseado
              height: 60, // Alto deseado
              child: Image.asset(
                'assets/images_company/google.png',
              ),
            )),
      ],
    );
  }
}
