import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:madero_reservas/screens/restaurant_screen.dart';
import 'package:transparent_image/transparent_image.dart';

class RestaurantTile extends StatelessWidget {
  final DocumentSnapshot restaurantData;

  RestaurantTile(this.restaurantData);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Stack(
              children: [
                Hero(
                  tag: restaurantData.id,
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
                                Row(
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RestaurantScreen(restaurantData)));
      },
    );
  }
}
