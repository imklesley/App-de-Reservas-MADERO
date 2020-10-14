import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:madero_reservas/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class EditScreen extends StatefulWidget {
  final DocumentSnapshot bookingData;

  EditScreen(this.bookingData);

  @override
  _EditScreenState createState() => _EditScreenState(this.bookingData);
}

class _EditScreenState extends State<EditScreen> {
  final DocumentSnapshot bookingData;

  _EditScreenState(this.bookingData);

  DateTime dateReservation = null;
  TimeOfDay timeReservation = null;

  @override
  Widget build(BuildContext context) {
    showAlertDialog(BuildContext context) {
      Widget yesButton = FlatButton(
        child: Text("Sim"),
        onPressed: () {
          UserModel.of(context)
              .deleteBook(bookingData.id, bookingData['restaurant_id']);
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      );
      Widget noButton = FlatButton(
        child: Text("Não"),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Cancelar Reserva?"),
        content: Text('Você confirma o cancelamento da sua reserva?'),
        actions: [yesButton, noButton],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    Timestamp timestampFirebase = bookingData['date_time_reservation'];
    DateTime dateTime = timestampFirebase.toDate();

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    //Pickers
    void pickDate() async {
      DateTime dateSelected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 5),
      );

      setState(() {
        print(dateSelected);
        dateReservation = dateSelected;
      });
    }

    void pickTime() async {
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
          'Editar',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        actions: [
          FlatButton(
              highlightColor: Colors.red,
              child: Text(
                'Cancelar Reserva',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              onPressed: () {
                showAlertDialog(context);
              })
        ],
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
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      dateReservation == null
                          ? 'Data da reserva\t\t\t\t\t\t  ${dateTime.day < 10 ? '0' + dateTime.day.toString() : dateTime.day.toString()} / ${dateTime.month < 10 ? '0' + dateTime.month.toString() : dateTime.month.toString()} / ${dateTime.year}'
                          : 'Nova Data:\t\t\t\t\t\t  ${dateReservation.day < 10 ? '0' + dateReservation.day.toString() : dateReservation.day.toString()} / ${dateReservation.month < 10 ? '0' + dateReservation.month.toString() : dateReservation.month.toString()} / ${dateReservation.year}',
                      style: dateReservation != null
                          ? TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)
                          : TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
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
                          ? 'Horário da reserva\t\t\t\t\t\t ${dateTime.hour < 10 ? '0' + dateTime.hour.toString() : dateTime.hour.toString()} : ${dateTime.minute < 10 ? '0' + dateTime.minute.toString() : dateTime.minute.toString()}'
                          : 'Novo Horário:\t\t\t\t\t\t ${timeReservation.hour < 10 ? '0' + timeReservation.hour.toString() : timeReservation.hour.toString()} : ${timeReservation.minute < 10 ? '0' + timeReservation.minute.toString() : timeReservation.minute.toString()} ${timeReservation.hour >= 0 && timeReservation.hour < 12 ? 'AM' : 'PM'}',
                      style: timeReservation != null
                          ? TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)
                          : TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          height: 60,
                          width: 280,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: Text(
                              'Finalizar Edição',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              if (dateReservation != null &&
                                  timeReservation != null) {
                                //Montei um timestamp baseado por datetime, sendo que o datetime foi construido baseado nas informações de  dateReservation e  timeReservation
                                Timestamp dateTimeReservation =
                                    Timestamp.fromDate(DateTime(
                                        dateReservation.year,
                                        dateReservation.month,
                                        dateReservation.day,
                                        timeReservation.hour,
                                        timeReservation.minute));
                                //Representa o estado da reserva. Após o restaurante finalizar muda para true significando que o usuário já compareceu.
                                bool finished = false;
                                Map<String, dynamic> reservationData = {
                                  'status': finished,
                                  'restaurant_id': bookingData['restaurant_id'],
                                  'restaurant_name':
                                      bookingData['restaurant_name'],
                                  'user_id': bookingData['user_id'],
                                  'user_name': bookingData['user_name'],
                                  'date_time_reservation': dateTimeReservation,
                                };
                                //Salva alterações no firebase
                                await UserModel.of(context).updateBooking(
                                    reservationData, bookingData.id);

                                Navigator.pop(context);
                              } else {
                                SnackBar snackBar = SnackBar(
                                  content: Text(
                                    'Atualize a data e horário',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 2),
                                );

                                _scaffoldKey.currentState
                                    .removeCurrentSnackBar();
                                _scaffoldKey.currentState
                                    .showSnackBar(snackBar);
                              }
                            },
                            color: Color(0xFFD9611E),
                          )))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
