import 'package:flutter/material.dart';

class InputLoginPassword extends StatefulWidget {
  final TextEditingController loginTextController;
  final TextEditingController passwordTextController;

  final String? loginErrorText;
  final String? passwordErrorText;

  const InputLoginPassword({
    super.key,
    required this.loginTextController,
    required this.passwordTextController,
    required this.loginErrorText,
    required this.passwordErrorText,
  });

  @override
  State<InputLoginPassword> createState() => _InputLoginPasswordState();
}

class _InputLoginPasswordState extends State<InputLoginPassword> {
  bool isHide = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.loginTextController,
          decoration: InputDecoration(
            errorText: widget.loginErrorText,
            hintText: "Логин, e-mail или телефон",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: widget.passwordTextController,
          obscureText: isHide,
          decoration: InputDecoration(
            errorText: widget.passwordErrorText,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isHide = !isHide;
                });
              },
              icon: Icon(isHide ? Icons.visibility_off : Icons.visibility),
            ),
            hintText: "Пароль",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
