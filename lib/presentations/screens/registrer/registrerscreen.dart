// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:apptacticalstore/presentations/components/mytextfield.dart';
import 'package:apptacticalstore/infraestructure/conection_firebase/registrer_firebase_service.dart';
import 'package:apptacticalstore/presentations/components/logo2.dart';
import 'package:apptacticalstore/presentations/components/text_and_textbutton.dart';
import 'package:apptacticalstore/presentations/components/validate_button.dart';
import 'package:apptacticalstore/config/services/validation_service.dart';

class RegistrerScreen extends StatefulWidget {
  static const name = 'registrer';
  const RegistrerScreen({super.key});

  @override
  State<RegistrerScreen> createState() => _RegistrerScreenState();
}

class _RegistrerScreenState extends State<RegistrerScreen> {
  final usernameRegistrerController = TextEditingController();
  final passwordRegistrerController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firebase = FirebaseFirestore.instance;
  String _errorMessage = '';
  String _spaceErrorMessage = '';
  final bool _isPasswordVisible = false;
  final bool _isConfirmPasswordVisible = false;

  Future<bool> registrerUser() async {
    final correo = usernameRegistrerController.text.trim();
    final contrasena = passwordRegistrerController.text.trim();
    final confirmarContrasena = confirmPasswordController.text.trim();
    if (correo.isEmpty || contrasena.isEmpty || confirmarContrasena.isEmpty) {
      _spaceErrorMessage = 'Por favor, complete todos los campos.';
      return false;
    } else {
      setState(() {
        _spaceErrorMessage = '';
      });
    }

    final firebaseService = FirebaseService();
    final registrationSuccessful =
        await firebaseService.registerUser(correo, contrasena);

    if (registrationSuccessful) {
      await firebaseService.addUserData(correo, contrasena);
    }

    return registrationSuccessful;
  }

  Future<void> _showSuccessDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registro Exitoso'),
          content: const Text(
              'Tu registro se ha completado con éxito. Por favor, inicia sesión.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo de éxito
                context.go(
                    '/'); // Redirige al usuario a la pantalla de inicio de sesión
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageLogo2(height: 100.0, width: 300.0),
              const SizedBox(height: 30),
              MyTextField(
                controller: usernameRegistrerController,
                hintText: 'Correo',
                obscureText: false,
                backgroundColor: Colors.grey.shade300,
                errorText: ValidationService.validateEmail(
                    usernameRegistrerController.text),
                onChanged: (value) {
                  setState(() {
                    _errorMessage = '';
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                controller: passwordRegistrerController,
                hintText: 'Contraseña',
                obscureText: !_isPasswordVisible,
                isPasswordToggle: true,
                backgroundColor: Colors.grey.shade300,
                errorText: ValidationService.validatePassword(
                    passwordRegistrerController.text),
                onChanged: (value) {
                  setState(() {
                    _errorMessage = '';
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirmar Contraseña',
                obscureText: !_isConfirmPasswordVisible,
                isPasswordToggle: true,
                backgroundColor: Colors.grey.shade300,
                errorText: ValidationService.validateConfirmPassword(
                    passwordRegistrerController.text,
                    confirmPasswordController.text),
                onChanged: (value) {
                  setState(() {
                    _errorMessage = '';
                  });
                },
              ),
              const SizedBox(
                height: 22,
              ),
              ValidateButton(
                buttonText: 'Registrar',
                onPressed: () async {
                  bool exitRegistration = await registrerUser();

                  if (exitRegistration) {
                    _showSuccessDialog(context);
                  }
                },
              ),
              TextAndTextButtom(
                questionText: '¿Ya tienes una cuenta?',
                linkText: 'Iniciar sesión',
                onPressed: () => context.go('/'),
              ),
              Text(
                _spaceErrorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
