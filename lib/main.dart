import 'package:flutter/material.dart';
import 'package:loja_teste_2/models/cart_model.dart';
import 'package:loja_teste_2/models/user_model.dart';
import 'package:loja_teste_2/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant(
        builder: (context, child, model){
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child:  MaterialApp(
              title: "Loja do Capiroto",
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  primaryColor: Color.fromARGB(255, 4, 125, 141)
              ),
              debugShowCheckedModeBanner: false,
              home:  HomeScreen(),
            ),
          )
        },)
    );
  }
}

