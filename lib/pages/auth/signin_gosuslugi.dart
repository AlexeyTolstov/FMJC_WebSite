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
      appBar: SignInAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Вход через ГосУслуги еще не реализован >_<"),
          ],
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
