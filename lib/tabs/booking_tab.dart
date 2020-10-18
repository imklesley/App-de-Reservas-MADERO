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
        //Toda vez que foi utilizado ScopedModelDescendant nesse app, serviu
        // para verificar se o usuário está logado, ter acesso aos dados do
        // usuário ou verificar se o app está em espera ou não
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            //Verifica-se se está carregando alguma coisa
            if (model.isLoading == true) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD9611E)),
                ),
              );
            } else if (!model.isLoggedIn()) {
              //verica-se se o usuário não está logado, caso isso seja true retorna uma tela que irá direcionar o usuário para tela delogin/cadastro
              return Container(
                color: Colors.white,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
              );
            } else {
              //Usei StreamBuilder pois quero que quando ocorrer atualizações nos dados mude a tela
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(model.user.uid)
                    .collection('schedule')
                    .orderBy('date_time_reservation', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  //Caso não tenha os dados ainda chama o circulaprogressindicator
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.black,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFD9611E)),
                      ),
                    );
                  } else {
                    //verifica-se se o usuário possui alguma reserva, caso ele não tenha, ou seja snapshot.data.docs.length == 0
                    if (snapshot.data.docs.length == 0) {
                      return Container(
                        color: Colors.white,
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                      );
                    } else {
                      //Só para não ter que ficar digitando snapshot.data.docs o tempo todo
                      List<DocumentSnapshot> books = snapshot.data.docs;
                      return ListView(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          SingleChildScrollView(
                            //permite "scrollar" na horizontal
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 20,
                              columns: [
                                //Define-se as colunas
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

                              //Agora precisamos passar todas as linhas que serão exibidas
                              rows: books.map((book) {

                                //Recebendo o timestamp do firebase
                                Timestamp timestamp =
                                    book['date_time_reservation'];

                                //Criamos datetime que possui todas as informações sobre data e horário da reserva
                                DateTime dateTime = timestamp.toDate();

                                return DataRow(cells: [
                                  DataCell(Text(book['restaurant_name'])),
                                  DataCell(Text(
                                      '${dateTime.day}/ ${dateTime.month}/ ${dateTime.year} às ${dateTime.hour}:${dateTime.minute}')),
                                  DataCell(
                                    //Aqui é o botão que direciona para a tela de reservas
                                      Text(
                                        'Editar',
                                        style: TextStyle(
                                            color: Color(0xFFD9611E),
                                            fontWeight: FontWeight.bold),
                                      ), onTap: () {
                                        //Navega/empilha para página que irá realiza a edição dos dados -- Update e Delete
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
