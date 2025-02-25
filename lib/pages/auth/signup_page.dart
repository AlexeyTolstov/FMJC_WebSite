import 'package:flutter/material.dart';
import 'package:maps_application/styles/button_styles.dart';
import 'package:maps_application/styles/font_styles.dart';
import 'package:maps_application/styles/images.dart';
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

          /// Форма для регистрации
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
                          'Зарегистрироваться',
                          style: AuthTextStyles.header,
                        ),

                        SizedBox(height: 20),

                        InputLoginPassword(
                          loginTextController: loginTextController,
                          passwordTextController: passwordTextController,
                        ),

                        const SizedBox(height: 30),

                        /// Кнопка "Зарегистрироваться"
                        Center(
                          child: TextButton(
                            onPressed: signUpValidation,
                            style: AuthButtonsStyles.mainButton,
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

                        const SizedBox(height: 10),

                        /// Кнопка "войти" - переход на страницу входа
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pushReplacementNamed(
                                context, '/sign-in'),
                            style: AuthButtonsStyles.secondaryButton,
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

                        const SizedBox(height: 30),

                        /// Вход через соцсети

                        const Text(
                          "Зарегистрироваться через: ",
                          style: AuthTextStyles.pharagraph,
                        ),

                        const SizedBox(height: 20),

                        /// Войти через госуслуги

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
