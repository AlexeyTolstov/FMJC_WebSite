import 'package:flutter/material.dart';
import 'package:maps_application/styles/font_styles.dart';

class SignInOKPage extends StatefulWidget {
  const SignInOKPage({super.key});

  @override
  State<SignInOKPage> createState() => _SignInOKPageState();
}

class _SignInOKPageState extends State<SignInOKPage> {
  final TextEditingController loginTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SignInAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Text(
            'Вход через Одноклассники находится в процессе разработки',
            style: AuthTextStyles.header_small,
          ),
        ),
      ),
    );
  }

  AppBar SignInAppBar() {
    return AppBar(
      title: const Text(
        "Войти через ОК",
        style: AuthTextStyles.header,
      ),
    );
  }
}
