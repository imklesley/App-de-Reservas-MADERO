import 'package:firebase_core/firebase_core.dart';
import 'package:madero_reservas/models/user_model.dart';
import 'package:madero_reservas/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';


void main() async {
  //Realizamos a inicializção da conexão do app com o firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //Inicia a aplicação
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: MaterialApp(
        title: 'MADERO',
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
        theme: ThemeData(
          fontFamily: 'Montserrat',
          cursorColor: Colors.deepOrange,
          highlightColor: Colors.orange,
          primarySwatch: Colors.orange,
          primaryColor: Color(0xFFD9611E),
        ),
      ),
    );
  }
}



