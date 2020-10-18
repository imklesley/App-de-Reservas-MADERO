import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madero_reservas/models/user_model.dart';
import 'package:madero_reservas/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        //Usei ListView para agrupar widget e manter a possibilidade de usar o scroll caso precise
        return ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 50,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    model.isLoggedIn()
                        ? // condicional ? faz algo : faz outra coisa
                        Text(
                            model.userData['name'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          )
                        : FlatButton(
                            //Tira espaço lateral do botão
                            padding: EdgeInsets.zero,
                            child: Text(
                              'Entrar ou cadastrar-se',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                            onPressed: () {
                              //Navega para outra tela através de empilhamento da nova tela
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                          ),
                    SizedBox(
                      height: 70,
                    ),
                    Column(
                      //Altera o alinhamento do widget na tela
                        mainAxisAlignment: MainAxisAlignment.start,
                        //Altera o alinhamento do widget na tela
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 60,
                            child: FlatButton(
                              highlightColor: Color(0xFFD9611E),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.email,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      'Alterar E-mail',
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                          Container(
                            height: 60,
                            child: FlatButton(
                              highlightColor: Color(0xFFD9611E),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.lock,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      'Alterar Senha',
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                          Container(
                            height: 60,
                            child: FlatButton(
                              highlightColor: Color(0xFFD9611E),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      'Fale Conosco',
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {},
                            ),
                          )
                        ]),
                  ],
                )),
            SizedBox(height: 150),
            Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                highlightColor: Colors.redAccent,
                child: Text(
                  model.isLoggedIn() ? 'Encerrar Acesso' : 'Fechar aplicativo',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                onPressed: () {
                  if (model.isLoggedIn())
                    model.signOut();
                  else
                    //Para fechar o aplicativo
                    SystemNavigator.pop();
                },
              ),
            )
          ],
        );
      },
    );
  }
}
