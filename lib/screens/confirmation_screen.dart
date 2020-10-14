import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ConfirmationScreen extends StatelessWidget {
  final String restaraurantName;

  ConfirmationScreen(this.restaraurantName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          restaraurantName,
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.checkCircle,
                  color: Colors.green,
                  size: 160,
                ),
                SizedBox(
                  height: 40,
                ),
                Text('A sua reserva foi efetuada com sucesso.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 100,
                ),
                Container(
                  height: 44,
                  child: RaisedButton(
                      color: Colors.green,
                      child: Text('Ir para início',
                          style: TextStyle(color: Colors.white, fontSize: 22)),
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
