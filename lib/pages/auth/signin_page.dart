import 'package:flutter/material.dart';
import 'package:maps_application/styles/button_styles.dart';
import 'package:maps_application/styles/font_styles.dart';
import 'package:maps_application/widgets/auth/gosuslugi_button.dart';
import 'package:maps_application/api_client.dart';
import 'package:maps_application/widgets/auth/ok_button.dart';
import 'package:maps_application/widgets/auth/vk_button.dart';
import 'package:maps_application/widgets/signin_password_input.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
            /// Форма входа (login / password)
            Center(
              child: SizedBox(
                width: 300,
                child: InputLoginPassword(
                  loginTextController: loginTextController,
                  passwordTextController: passwordTextController,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// Кнопка входа
            Center(
              child: TextButton(
                // onPressed: () {},
                onPressed: signInValidation,
                style: AuthButtonsStyles.mainButton,
                child: const SizedBox(
                  width: 300,
                  child: Text(
                    "Войти",
                    textAlign: TextAlign.center,
                    style: LoginAndSignUpFontStyles.buttonText,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// Кнопка "зарегистрироваться"
            Center(
              child: TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/sign-up'),
                style: AuthButtonsStyles.secondaryButton,
                child: const SizedBox(
                  width: 300,
                  child: Text(
                    "Зарегистрироваться",
                    textAlign: TextAlign.center,
                    style: LoginAndSignUpFontStyles.buttonText,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),

            /// Вход через российские платформы
            const Text(
              "Войти через: ",
              style: LoginAndSignUpFontStyles.pharagraph,
            ),

            const SizedBox(height: 20),
            Center(
              child: GosuslugiButton(
                onTap: () => Navigator.pushNamed(context, '/sign-in/gosuslugi'),
              ),
            ),
            SizedBox(height: 10),

            /// ОК и ВК
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OKButton(
                    onTap: () => Navigator.pushNamed(context, '/sign-in/ok'),
                  ),
                  SizedBox(width: 50),
                  VKButton(
                    onTap: () => Navigator.pushNamed(context, '/sign-in/vk'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar SignInAppBar() {
    return AppBar(
      title: const Text(
        "Войти",
        style: LoginAndSignUpFontStyles.header,
      ),
    );
  }

  void signInValidation() {
    bool isValid = signInUser(
      login: loginTextController.text,
      password: passwordTextController.text,
    );

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Неправильный Логин/Пароль'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      Navigator.pushReplacementNamed(context, '/main_page');
    }
  }
}
