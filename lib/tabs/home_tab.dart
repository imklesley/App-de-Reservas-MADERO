import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:madero_reservas/tiles/restaurant_tile.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('restaurants').get(),
        builder: (context, snapshot) {
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                              FontAwesomeIcons.glassCheers,
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                        children: snapshot.data.docs
                            .map((restaurant) => RestaurantTile(restaurant))
                            .toList()),
                  ),
                ),
              ],
            );
          }
        });
  }
}
