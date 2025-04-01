import 'package:flutter/material.dart';
import 'package:maps_application/styles/font_styles.dart';

class SignInGosuslugiPage extends StatefulWidget {
  const SignInGosuslugiPage({super.key});

  @override
  State<SignInGosuslugiPage> createState() => _SignInGosuslugiPageState();
}

class _SignInGosuslugiPageState extends State<SignInGosuslugiPage> {
  final TextEditingController loginTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SignInAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Text(
            'Вход через ГосУслуги находится в процессе разработки',
            style: AuthTextStyles.header_small,
          ),
        ),
      ),
    );
  }

  AppBar SignInAppBar() {
    return AppBar(
      title: const Text(
        "Войти через Госуслуги",
        style: AuthTextStyles.header,
      ),
    );
  }
}
