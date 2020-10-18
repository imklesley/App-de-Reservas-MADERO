import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madero_reservas/models/user_model.dart';
import 'package:madero_reservas/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'confirmation_screen.dart';

class RestaurantScreen extends StatefulWidget {
  //Inicializo a classe com o documento que representa o restaurante
  final DocumentSnapshot restaurantData;

  RestaurantScreen(this.restaurantData);

  @override
  _RestaurantScreenState createState() =>
      _RestaurantScreenState(restaurantData);
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  //Inicializo a classe com o documento que representa o restaurante, que está vindo da classe acima
  final DocumentSnapshot restaurantData;

  _RestaurantScreenState(this.restaurantData);

  //Guardam os resultados dos pickes de data e horário
  DateTime dateReservation = null;
  TimeOfDay timeReservation = null;

  //usei essa key para exibir os snacksbars
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //Função que chama o picker de data e atribui à sua respectiva variável
    pickDate() async {
      //Aguardo até o usuário finalizar a sua seleção e então guardo o resultado
      DateTime dateSelected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 5),
      );

      setState(() {
        dateReservation = dateSelected;
      });
    }

    //Função que chama o picker de horário e atribui à sua respectiva variável
    pickTime() async {
      //Aguardo até o usuário finalizar a sua seleção e então guardo o resultado
      TimeOfDay timeSelected = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      setState(() {
        timeReservation = timeSelected;
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          restaurantData['name'],
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor: Color(0xFFD9611E),
      ),
      backgroundColor: Colors.white,
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          //Após pressionar para reservar, o app aguarda a finalização do salvamento dos dados no firebase, logo enquanto mostra-se um circulaprogressindicator
          if (model.isLoading == true) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD9611E)),
              ),
            );
          } else {
            return ListView(
              children: [
                Hero(
                  tag: restaurantData.id,
                  child: Stack(
                    children: [
                      ClipRRect(
                        //Serve para da bordas em outros widgets, aqui usado para dar bordas em imagem
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: restaurantData['image'],
                            fit: BoxFit.cover,
                            height: 270,
                            width: 400),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          color: Color.fromRGBO(0, 0, 0, .4),
                        ),
                        height: 270,
                      ),
                      Positioned(
                          bottom: 0,
                          left: 15,
                          child: FlatButton(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Ir para ${restaurantData['name']}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            onPressed: () async {
                              //Coloquei latitude e longitude dentro de outras variáveis pra ficar mais simples a vizualização e o entendimento
                              double lat = restaurantData['location'].latitude;
                              double long =
                                  restaurantData['location'].longitude;
                              //Usa o url_launcher, que direciona para o app ou site do link passado
                              await launch(
                                  'https://www.google.com/maps/search/?api=1&query=${lat},${long}');
                            },
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Faça sua Reserva',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 320,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                //Tile que chama o Picker de data
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    dateReservation == null
                                        ? 'Escolha a data da sua reserva'
                                        : 'Data Selecionada:\t ${dateReservation.day < 10 ? '0' + dateReservation.day.toString() : dateReservation.day.toString()} / ${dateReservation.month < 10 ? '0' + dateReservation.month.toString() : dateReservation.month.toString()} / ${dateReservation.year}',
                                    style: dateReservation != null
                                        ? TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)
                                        : TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                  ),
                                  trailing: Icon(
                                    Icons.date_range,
                                    color: Colors.deepOrange,
                                    size: 30,
                                  ),
                                  onTap: () {
                                    //chama a função que abre e coloca o valor escolhido dentro da nossa variável
                                    pickDate();
                                  },
                                ),

                                //Tile que chama o Picker de horário
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    timeReservation == null
                                        ? 'Escolha o horário da sua reserva'
                                        : 'Horário Selecionado:\t\t\t\t\t\t ${timeReservation.hour < 10 ? '0' + timeReservation.hour.toString() : timeReservation.hour.toString()} : ${timeReservation.minute < 10 ? '0' + timeReservation.minute.toString() : timeReservation.minute.toString()}',
                                    style: timeReservation != null
                                        ? TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)
                                        : TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                  ),
                                  trailing: Icon(
                                    Icons.access_time,
                                    color: Colors.deepOrange,
                                    size: 30,
                                  ),
                                  onTap: () {
                                    //chama a função que abre e coloca o valor escolhido dentro da nossa variável
                                    pickTime();
                                  },
                                ),
                                SizedBox(
                                  height: 60,
                                ),
                                //Botão para reservar ou entrar para reservar
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12))),
                                        height: 60,
                                        width: 280,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12))),
                                          child: Text(
                                            model.isLoggedIn()
                                                ? 'Reservar'
                                                : 'Entre para reservar',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          color: Color(0xFFD9611E),
                                          onPressed: () async {
                                            //Verifica-se o usuário está logado
                                            if (model.isLoggedIn()) {
                                              //caso esteja, verifica-se ele preenche os campos de data e hora
                                              if (dateReservation != null &&
                                                  timeReservation != null) {
                                                //Se tiver preenchido começa-se os preparativos para finalizar o pedido

                                                //Criei um novo datetime usando as informações de data de dateReservation e de horário de timeReservation, e então converti para timestamp
                                                Timestamp dateTimeReservation =
                                                    Timestamp.fromDate(DateTime(
                                                        dateReservation.year,
                                                        dateReservation.month,
                                                        dateReservation.day,
                                                        timeReservation.hour,
                                                        timeReservation
                                                            .minute));

                                                //Representa o estado da reserva. Após o restaurante finalizar muda para true significando que o usuário já compareceu.
                                                bool finished = false;
                                                //Construimos um dícionário que contém todas as informações da reserva
                                                Map<String, dynamic>
                                                    reservationData = {
                                                  'status': finished,
                                                  'restaurant_id':
                                                      restaurantData.id,
                                                  'restaurant_name':
                                                      restaurantData['name'],
                                                  'user_id': model.user.uid,
                                                  'user_name':
                                                      model.userData['name'],
                                                  'date_time_reservation':
                                                      dateTimeReservation,
                                                };

                                                //Chama o método que realiza o pedido de reserva. Nesse método, é enviado as informações
                                                // de reservationData tanto para o restaurante como para o usuário
                                                await model.endOrder(
                                                    reservationData,
                                                    restaurantData.id);

                                                //Após ter finalizado o pedido
                                                //Vai empilhar/navegar a tela de confirmação porém substui na pilha a tela atual, logo quando pressionar em voltar ele volta para o inicio
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ConfirmationScreen(
                                                                restaurantData[
                                                                    'name'])));
                                              } else {
                                                //Caso o usuário não preencheu o campo de data ou o campo de horário,
                                                // mostra-se um snackbar vermelho falando pra ele inserir os dados
                                                SnackBar snackBar = SnackBar(
                                                  content: Text(
                                                    'Insira uma data e um horário',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  duration:
                                                      Duration(seconds: 2),
                                                );

                                                _scaffoldKey.currentState
                                                    .showSnackBar(snackBar);
                                              }
                                            } else {
                                              //Caso o usuário não esteja logado direciona ele para página de login/cadastro
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginScreen()));
                                            }
                                          },
                                        )))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
