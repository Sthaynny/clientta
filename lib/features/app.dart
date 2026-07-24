import 'package:flutter/material.dart';
import 'package:ufersa_hub/core/router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ConectaFERSA',
      initialRoute: AppRouters.home.path,
      routes: routes,
    );
  }
}
