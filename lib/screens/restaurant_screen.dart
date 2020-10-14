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
  final DocumentSnapshot restaurantData;

  RestaurantScreen(this.restaurantData);

  @override
  _RestaurantScreenState createState() =>
      _RestaurantScreenState(restaurantData);
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final DocumentSnapshot restaurantData;

  _RestaurantScreenState(this.restaurantData);

  DateTime dateReservation = null;
  TimeOfDay timeReservation = null;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    pickDate() async {
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

    pickTime() async {
      TimeOfDay timeSelected =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());

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
                              double lat = restaurantData['location'].latitude;
                              double long =
                                  restaurantData['location'].longitude;
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
                                    pickDate();
                                  },
                                ),
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
                                    pickTime();
                                  },
                                ),
                                SizedBox(
                                  height: 60,
                                ),
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
                                                : "Entre para reservar",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () async {
                                            if (model.isLoggedIn()) {
                                              if (dateReservation != null &&
                                                  timeReservation != null) {
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
                                                String orderId =
                                                    await model.endOrder(
                                                        reservationData,
                                                        model.user.uid,
                                                        restaurantData.id);

                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ConfirmationScreen(
                                                                restaurantData[
                                                                    'name'])));
                                              } else {
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
                                                    .removeCurrentSnackBar();
                                                _scaffoldKey.currentState
                                                    .showSnackBar(snackBar);
                                              }
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginScreen()));
                                            }
                                          },
                                          color: Color(0xFFD9611E),
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
