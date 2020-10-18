import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:madero_reservas/tiles/restaurant_tile.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Realiza a busca por todos os documentos que representam um restaurante
    return FutureBuilder<QuerySnapshot>(
        //QuerySnapshot significa que estão vindo varios documentos do cloudfirestore
        future: FirebaseFirestore.instance.collection('restaurants').get(),
        builder: (context, snapshot) {
          //Caso ainda ainda não tenha baixado todos os dados, mostrar circularprogressindicator
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD9611E)),
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
                  child: Row(
                    //alinhamento/espaçamento entre os filhos de forma igualitária
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        //Container só serve para especificar as dimensões desejadas no botão
                        height: 70,
                        width: 100,
                        child: RaisedButton(
                          highlightColor: Colors.deepOrange,
                          //background do botão
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.glassCheers,
                              color: Colors.orange,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        height: 70,
                        width: 100,
                        child: RaisedButton(
                          highlightColor: Colors.deepOrange,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          onPressed: () {},
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.hamburger,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 70,
                        width: 100,
                        child: RaisedButton(
                          highlightColor: Colors.deepOrange,
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          onPressed: () {},
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.pizzaSlice,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Nossos Restaurantes',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat'),
                  ),
                ),
                Expanded(
                  //Permite esticar/expadir todo par todo os espaçi disponível em tela, sem dar overflow de pixels
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                        //Peguei todos os documentos que o firebase me retornou, usei a função .map, que me permite "entrar" dentro de cada documento e fazer algo
                        children: snapshot.data.docs
                            .map((restaurant) => RestaurantTile(
                                restaurant)) //Pega cada documento que representa um restaurante e passa como parametro para a class RestaurantTile que irá construir a tile que representa o restaurante/
                            .toList()),
                  ),
                ),
              ],
            );
          }
        });
  }
}
