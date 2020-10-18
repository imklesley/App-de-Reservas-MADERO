import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:madero_reservas/screens/restaurant_screen.dart';
import 'package:transparent_image/transparent_image.dart';

class RestaurantTile extends StatelessWidget {
  //Inicializo a classe com o documento que possui todas as informações necessárias para a construção da tile desse restaurante
  final DocumentSnapshot restaurantData;

  RestaurantTile(this.restaurantData);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        //Widget que cria um card com uma determinada elevação
        shape: RoundedRectangleBorder(
            //Coloca-se a borda no card de 12 pixel em todas as bordas
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: ClipRRect(
            //Para fazer a nossa imagem tbm ficar com bordas arredondadas
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Stack(
              children: [
                Hero(
                  //Animação mais simples do flutter
                  tag: restaurantData.id,
                  //Passo um identificador, quando o flutter
                  // perceber que mudamos de página e nessa outra página tbm possuir um widget do tipo Hero com a msm tag ele automaticamente irá realizar esse efeito
                  child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: restaurantData['image'],
                      fit: BoxFit.cover,
                      height: 230,
                      width: 400),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    color: Color.fromRGBO(0, 0, 0, 0.7),
                    height: 50,
                    width: 370,
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  restaurantData['name'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w200),
                                ),
                                Row(//Constrói as estrelinhas de avaliação
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    Icon(
                                      Icons.star_half,
                                      color: Colors.amber,
                                    ),
                                  ],
                                )
                              ],
                            ))),
                  ),
                )
              ],
            )),
      ),
      onTap: () {
        //Navego empilhando a próxima tela e passo o documento que representa
        // o restaurante e lá vamos conseguir construir a tela do restaurante. Nessa tela será usado todas as informações do restaurante
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RestaurantScreen(restaurantData)));
      },
    );
  }
}
