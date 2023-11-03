import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:apptacticalstore/presentations/components/mytextfield.dart';
import 'package:apptacticalstore/presentations/components/text_and_textbutton.dart';
import 'package:apptacticalstore/presentations/components/validate_button.dart';
import 'package:apptacticalstore/presentations/screens/login/button_start_session_with.dart';
import 'package:apptacticalstore/presentations/components/logo1.dart';

class LoginScreen extends StatefulWidget {
  static const name = 'login-screen';
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final bool _isPasswordVisible = false;
  String _messageError = '';

  validarDatos() async {
    try {
      CollectionReference ref = FirebaseFirestore.instance.collection('Users');
      QuerySnapshot usuario = await ref.get();

      if (usuario.docs.isNotEmpty != 0) {
        for (var cursor in usuario.docs) {
          if (cursor.get('Correo') == usernameController.text) {
            print('Ususrio en base de datos');

            if (cursor.get('Contraseña') == passwordController.text) {
              print('Acceso ');
              context.go('/home-page');
            } else {
              _messageError = 'Usuario o contraseña incorrecta';
            }
          } else {
            _messageError = 'Usuario o contraseña incorrecta';
          }
        }
      } else {
        print('No hay informacion en la collecion');
      }
    } catch (e) {
      print('Error.....$e');
    }
    setState(() {
      _messageError = 'Usuario o contraseña incorrecta.';
    }); // Actualiza la interfaz para mostrar el mensaje
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            imageLogo1(width: 250, height: 250),
            const SizedBox(
              height: 20,
            ),
            MyTextField(
              controller: usernameController,
              hintText: 'Usuario',
              obscureText: false,
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              controller: passwordController,
              hintText: 'Contraseña',
              obscureText: !_isPasswordVisible,
              isPasswordToggle: true,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(_messageError,
                style: const TextStyle(
                  color: Colors.red,
                )),
            TextAndTextButtom(
              mainAxisAlignment: MainAxisAlignment.end,
              questionText: '',
              linkText: '¿Olvidaste tu contraseña?',
              padding: const EdgeInsets.symmetric(horizontal: 35),
              onPressed: () {
                //TODO definir metodo
              },
            ),
            ValidateButton(
              buttonText: 'Ingresar',
              onPressed: () {
                validarDatos();
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const _TextContinueWith(),
            const SizedBox(
              height: 10,
            ),
            const ButtonsStartWith(),
            const SizedBox(
              height: 10,
            ),
            TextAndTextButtom(
              onPressed: () => context.go('/registrerscreen'),
              questionText: '¿Aùn no tienes cuenta?',
              linkText: 'Regìstrate',
            ),
          ],
        ),
      ),
    );
  }
}

class _TextContinueWith extends StatelessWidget {
  const _TextContinueWith();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 0.8,
              color: Colors.grey[600],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Inicia sesión con',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 0.8,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
