import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_diu/widgets/auth.dart';

void main(){
  runApp((App()));
}


class App extends StatelessWidget{
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Diu Quiz",
      theme: ThemeData().copyWith(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor:const Color.fromARGB(255, 44, 5, 140),

      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 44, 5, 140),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 44, 5, 140),
      ),
    ),
      home:Auth() ,
    );
  }

}