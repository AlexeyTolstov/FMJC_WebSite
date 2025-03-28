import 'package:flutter/material.dart';
import 'package:maps_application/api/auth.dart';
// import 'package:maps_application/api/ping.dart';
import 'package:maps_application/styles/button_styles.dart';
import 'package:maps_application/styles/font_styles.dart';
import 'package:maps_application/styles/images.dart';
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ApplicationImages.BackgroundImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: IntrinsicWidth(
              child: IntrinsicHeight(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Войти',
                          style: AuthTextStyles.header,
                        ),

                        SizedBox(height: 20),

                        /// Форма входа (login / password)

                        SizedBox(
                          width: 300,
                          child: InputLoginPassword(
                            loginTextController: loginTextController,
                            passwordTextController: passwordTextController,
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// Кнопка входа

                        Center(
                          child: TextButton(
                            onPressed: signInValidation,
                            style: AuthButtonsStyles.mainButton,
                            child: const SizedBox(
                              width: 250,
                              child: Text(
                                "Войти",
                                textAlign: TextAlign.center,
                                style: AuthTextStyles.buttonText,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// Кнопка "зарегистрироваться"

                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, '/sign-up'),
                            style: AuthButtonsStyles.secondaryButton,
                            child: const SizedBox(
                              width: 250,
                              child: Text(
                                "Зарегистрироваться",
                                textAlign: TextAlign.center,
                                style: AuthTextStyles.buttonText,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// Вход через российские платформы
                        const Text(
                          "Войти через: ",
                          style: AuthTextStyles.pharagraph,
                        ),

                        const SizedBox(height: 10),

                        Center(
                          child: GosuslugiButton(
                            onTap: () => Navigator.pushNamed(
                                context, '/sign-in/gosuslugi'),
                          ),
                        ),

                        SizedBox(height: 10),

                        /// ОК и ВК
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OKButton(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/sign-in/ok'),
                            ),
                            SizedBox(width: 50),
                            VKButton(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/sign-in/vk'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void signInValidation() {
    sign_in(
            login: loginTextController.text,
            password: passwordTextController.text)
        .whenComplete(() {
      Navigator.pushReplacementNamed(context, '/main_page');
    }).onError((error, value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Неправильный Логин/Пароль'),
          duration: Duration(seconds: 3),
        ),
      );
    });
  }
}
