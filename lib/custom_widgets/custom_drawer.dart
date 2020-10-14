import 'package:flutter/material.dart';
import 'package:madero_reservas/screens/about_us_screen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            color: Color(0xFFD9611E),
            height: 200,
            width: double.infinity,
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/brand/brand.png',
                    fit: BoxFit.cover,
                    height: 40,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.store,
              size: 35,
              color: Color(0xFFD9611E),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.orange,
            ),
            title: Text(
              'Estabelecimentos',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Color(0xFFD9611E),
              size: 35,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.orange,
            ),
            title: Text(
              'Sobre Nós',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutUsScreen()));
            },
          ),
        ],
      ),
    );
  }
}
