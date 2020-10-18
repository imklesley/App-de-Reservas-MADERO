import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          'Sobre Nós',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Color(0xFFD9611E),
      ),
      backgroundColor: Colors.white,

      //Construtor de futuro, irá buscar os dados no firebase e construir da maneira que desejar
      body: FutureBuilder<DocumentSnapshot>(
          //futuro a ser construido
          future: FirebaseFirestore.instance
              .collection('general')
              .doc('about_us')
              .get(),
          //Construtor do futuro, pega os dados da imagem e retorna algum widget
          builder: (context, snapshot) {
            //Ainda não possui dados?
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD9611E)),
                ),
              );
            else {
              // Caso já possua os dados

              List<Widget> article = [];//Vai guardar os elementos já construidos de cada tela.
              for (var element in snapshot.data['text']) {
                if (element['type'] == 'image') {
                  article.add(FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: element['data'],
                    fit: BoxFit.cover,
                    height: element['height'] + 0.0,
                  ));
                } else if (element['type'] == 'text') {
                  article.add(Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Text(
                      element['data'],
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ));
                }
                article.add(SizedBox(
                  height: 20,
                ));
              }

              return ListView(children: article);
            }
          }),
    );
  }
}
