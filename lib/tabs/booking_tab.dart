import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:madero_reservas/models/user_model.dart';
import 'package:madero_reservas/screens/edit_screen.dart';
import 'package:madero_reservas/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class BookingTab extends StatefulWidget {
  @override
  _BookingTabState createState() => _BookingTabState();
}

class _BookingTabState extends State<BookingTab> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            } else if (!model.isLoggedIn()) {
              return Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Column(
                      children: [
                        Icon(
                          Icons.login,
                          size: 120,
                          color: Color(0xFFD9611E),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Entre para vizualizar suas reservas',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFFD9611E),
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        Container(
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
                                'Entre',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              color: Color(0xFFD9611E),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                            ))
                      ],
                    )),
                  ],
                ),
              );
            } else {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(model.user.uid)
                    .collection('schedule')
                    .orderBy('date_time_reservation', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.black,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFD9611E)),
                      ),
                    );
                  } else {
                    if (snapshot.data.docs.length == 0) {
                      return Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Column(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 120,
                                  color: Color(0xFFD9611E),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Você não possui reservas!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFFD9611E),
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                          ],
                        ),
                      );
                    } else {
                      List<DocumentSnapshot> books = snapshot.data.docs;

                      return ListView(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 20,

                              columns: [
                                DataColumn(
                                  label: Text(
                                    'Restaurante',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                ),
                                DataColumn(
                                    label: Text(
                                  'Data e Horário',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                )),
                                DataColumn(
                                    label: Text(
                                  'Ação',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ))
                              ],
                              rows: books.map((book) {
                                Timestamp timestamp =
                                    book['date_time_reservation'];

                                DateTime dateTime = timestamp.toDate();

                                return DataRow(cells: [
                                  DataCell(Text(book['restaurant_name'])),
                                  DataCell(Text(
                                      '${dateTime.day}/ ${dateTime.month}/ ${dateTime.year} às ${dateTime.hour}:${dateTime.minute}')),
                                  DataCell(
                                      Text(
                                        'Editar',
                                        style: TextStyle(
                                            color: Color(0xFFD9611E),
                                            fontWeight: FontWeight.bold),
                                      ), onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditScreen(book)));
                                  }),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ],
                      );
                    }
                  }
                },
              );
            }
          },
        ));
  }
}
