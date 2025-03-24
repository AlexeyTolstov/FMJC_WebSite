import 'package:flutter/material.dart';
import 'package:maps_application/pages/add_route_page.dart';
import 'package:maps_application/pages/add_suggestion_page.dart';
import 'package:maps_application/pages/auth/signin_gosuslugi.dart';
import 'package:maps_application/pages/auth/signin_ok_page.dart';
import 'package:maps_application/pages/auth/signin_page.dart';
import 'package:maps_application/pages/auth/signin_vk_page.dart';
import 'package:maps_application/pages/home_page.dart';
import 'package:maps_application/pages/main_page.dart';
import 'package:maps_application/pages/auth/signup_page.dart';
import 'package:maps_application/pages/suggestion_view_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/sign-in',
      routes: {
        '/': (context) => const HomePage(),
        '/sign-in': (context) => const SignInPage(),
        '/sign-in/vk': (context) => const SignInVKPage(),
        '/sign-in/ok': (context) => const SignInOKPage(),
        '/sign-in/gosuslugi': (context) => const SignInGosuslugiPage(),
        '/sign-up': (context) => const SignUpPage(),
        '/main_page': (context) => const MainPage(),
        '/add-route': (context) => const AddRoutePage(),
        '/add-suggestion': (context) => const AddSuggestionPage(),
        '/suggestion-view': (context) => const SuggestionViewPage(),
      },
    );
  }
}
