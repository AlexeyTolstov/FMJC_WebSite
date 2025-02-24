import 'package:flutter/material.dart';
import 'package:maps_application/styles/font_styles.dart';

class SignInVKPage extends StatefulWidget {
  const SignInVKPage({super.key});

  @override
  State<SignInVKPage> createState() => _SignInVKPageState();
}

class _SignInVKPageState extends State<SignInVKPage> {
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
          children: [const Text("Пока нельзя ;(")],
        ),
      ),
    );
  }

  AppBar SignInAppBar() {
    return AppBar(
      title: const Text(
        "Войти через ВК",
        style: LoginAndSignUpFontStyles.header,
      ),
    );
  }
}
