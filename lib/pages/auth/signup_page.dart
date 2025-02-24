import 'package:flutter/material.dart';
import 'package:maps_application/styles/button_styles.dart';
import 'package:maps_application/styles/font_styles.dart';
import 'package:maps_application/widgets/auth/gosuslugi_button.dart';
import 'package:maps_application/api_client.dart';
import 'package:maps_application/widgets/auth/ok_button.dart';
import 'package:maps_application/widgets/auth/vk_button.dart';
import 'package:maps_application/widgets/signin_password_input.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController loginTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SignUpAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Форма для регистрации
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

            /// Кнопка "Зарегистрироваться"
            Center(
              child: TextButton(
                onPressed: signUpValidation,
                style: AuthButtonsStyles.mainButton,
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

            const SizedBox(height: 10),

            /// Кнопка "войти" - переход на страницу входа
            Center(
              child: TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/sign-in'),
                style: AuthButtonsStyles.secondaryButton,
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

            const SizedBox(height: 50),

            /// Вход через соцсети
            const Text(
              "Зарегистрироваться через: ",
              style: LoginAndSignUpFontStyles.pharagraph,
            ),

            const SizedBox(height: 20),

            /// Войти через госуслуги
            Center(
              child: GosuslugiButton(
                onTap: () => Navigator.pushNamed(context, '/sign-in/gosuslugi'),
              ),
            ),
            SizedBox(height: 10),

            /// ОК и ВК
            Row(
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
          ],
        ),
      ),
    );
  }

  AppBar SignUpAppBar() {
    return AppBar(
      title: const Text(
        "Зарегистрироваться",
        style: LoginAndSignUpFontStyles.header,
      ),
    );
  }

  @override
  void dispose() {
    loginTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  void signUpValidation() {
    if (loginTextController.text.length >= 1 &&
        passwordTextController.text.length >= 1) {
      createNewUser(
        login: loginTextController.text,
        password: passwordTextController.text,
      );
      Navigator.pushReplacementNamed(context, '/main_page');
      // HiveService.saveUser(User(
      //   login: loginTextController.text,
      //   password: passwordTextController.text,
      // )).then((value) => Navigator.pushReplacementNamed(context, '/main_page'));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не корректные данные'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
