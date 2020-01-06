import 'package:flutter/material.dart';
import 'package:loja_teste_2/screens/home_screen.dart';
import 'package:loja_teste_2/screens/login_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: "Loja do Capiroto",
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color.fromARGB(255, 4, 125, 141)
      ),
      debugShowCheckedModeBanner: false,
      home:  LoginScreen(),
    );
  }
}

